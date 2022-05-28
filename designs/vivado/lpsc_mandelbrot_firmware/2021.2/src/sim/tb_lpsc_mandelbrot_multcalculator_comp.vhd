----------------------------------------------------------------------------------
--
-- Company: HES-SO Master
-- Author: Pierrick Muller <pierrick.muller@hes-so.ch>
--
-- Module Name: tb_lpsc_mandelbrot_calculator - arch
-- Target Device: digilentinc.com:nexys_video:part0:1.1 xc7a200tsbg484-1
-- Tool version: 2021.2
-- Description: tb for lpsc_mandelbrot_calculator
--
-- Last update: 06.05.2022

-----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Utile pour générer des valeurs pseudo-aléatoires.
use ieee.math_real.uniform;
use ieee.math_real.floor;

library unisim;
use unisim.vcomponents.all;

entity tb_lpsc_mandelbrot_multcalculator_comp is
-- Empty for a testbench
end tb_lpsc_mandelbrot_multcalculator_comp;


architecture behavioral of tb_lpsc_mandelbrot_multcalculator_comp is

    constant C_CLK_PERIOD : time    := 10 ns;
    constant C_NB_TEST    : integer := 1;
    constant C_TEST_DATA_R  : std_logic_vector := "000010000000000000";

    component lpsc_mandelbrot_calculator_comp is
    	generic ( comma : integer := 14;
		max_iter : integer := 127;
		SIZE : integer := 18;
		SCREEN_RES : integer := 10);
        port (
    		clk : in std_logic;
		rst : in std_logic;
		ready : out std_logic;
		start : in std_logic;
		finished : out std_logic;
		c_real : in std_logic_vector(SIZE-1 downto 0);
		c_imaginary : in std_logic_vector(SIZE-1 downto 0);
		z_real : out std_logic_vector(SIZE-1 downto 0);
		z_imaginary : out std_logic_vector(SIZE-1 downto 0);
		iterations : out std_logic_vector(SIZE-1 downto 0);
		x_screen : in std_logic_vector(SCREEN_RES-1 downto 0);
		y_screen : in std_logic_vector(SCREEN_RES-1 downto 0);
		x_screen_out : out std_logic_vector(SCREEN_RES-1 downto 0);
		y_screen_out : out std_logic_vector(SCREEN_RES-1 downto 0);
		other_finished : in std_logic;
		busy : out std_logic
		);
    end component lpsc_mandelbrot_calculator_comp;

    signal ClkxC            : std_ulogic := '0';
    signal RstxR            : std_ulogic := '1';  -- Au départ, on dans l'état reset.
    signal CIxD		    : std_logic_vector(17 downto 0)	:= (others => '0'); --"000010000000000000";
    signal CRxD		    : std_logic_vector(17 downto 0)	:= (others => '0'); --"000010000000000000";
    signal ZnIxDP	    : std_logic_vector(17 downto 0)	:= (others => '0');
    signal ZnRxDP	    : std_logic_vector(17 downto 0)	:= (others => '0');
    signal StartxS	    : std_logic := '0';
    signal FinishedxS	    : std_logic := '0';
    signal IterationxS      : std_logic_vector(17 downto 0)     := (others => '0');
    signal ReadyxS	    : std_logic := '0';

    signal XscreenxD		: std_logic_vector( 9 downto 0)	:= (others => '0');
    signal YscreenxD		: std_logic_vector( 9 downto 0)	:= (others => '0');
    signal BusyxS		: std_logic;

    signal Start1xS	    : std_logic := '0';
    signal Finished1xS	    : std_logic := '0';
    signal Iteration1xS      : std_logic_vector(17 downto 0)     := (others => '0');
    signal Ready1xS	    : std_logic := '0';
    signal Busy1xS		: std_logic;


    --signal ProbexS          : std_ulogic := '0';
    --signal PulsexS          : std_ulogic := '0';
    -- Signaux internes à la simulation.
    signal EndOfSimxS       : boolean    := false;

begin

    AsyncStatxB : block is
    begin  -- block AsyncStatxB

        -- On génére une horloge de période C_CLK_PERIOD.
        ClkxAS : ClkxC <= not ClkxC after (C_CLK_PERIOD / 2);
        -- On lève le reset après 100 ns.
        RstxAS : RstxR <= '0'       after (C_CLK_PERIOD * 10);

    end block AsyncStatxB;

    ---------------------------------------------------------------------------
    -- Instance du composant lpsc_mandelbrot_calculator.
    ---------------------------------------------------------------------------
    LpscEdgeDetectorxI : entity work.lpsc_mandelbrot_calculator_comp
        port map (
            	clk => ClkxC,
		rst => RstxR,
		ready => ReadyxS,
		start => StartxS,
		finished => FinishedxS,
		c_real => CRxD,
		c_imaginary => CIxD,
		z_real => ZnRxDP,
		z_imaginary => ZnIxDP,
		iterations => IterationxS,
		x_screen => XscreenxD,
		y_screen => YscreenxD,
		x_screen_out => open,
		y_screen_out => open,
		other_finished => '0',
		busy  => BusyxS
	    );

    LpscEdgeDetector2xI : entity work.lpsc_mandelbrot_calculator_comp
        port map (
            	clk => ClkxC,
		rst => RstxR,
		ready => Ready1xS,
		start => Start1xS,
		finished => Finished1xS,
		c_real => CRxD,
		c_imaginary => CIxD,
		z_real => open,
		z_imaginary => open,
		iterations => Iteration1xS,
		x_screen => XscreenxD,
		y_screen => YscreenxD,
		x_screen_out => open,
		y_screen_out => open,
		other_finished => FinishedxS,
		busy  => Busy1xS
	    );

    ---------------------------------------------------------------------------
    -- Process de fin de simulation.
    ---------------------------------------------------------------------------
    EndOfSimxP : process is
    begin  -- process EndOfSimxP

        -- Condition de fin de simulation.
        if EndOfSimxS = true then
            assert false report "Fin de la simulation!" severity failure;
        end if;

        -- On attend un cycle d'horloge.
        wait until rising_edge(ClkxC);

    end process EndOfSimxP;

    ---------------------------------------------------------------------------
    -- Process de test pour le composant lpsc_edge_detector.
    -- On alterne simplement le signal d'entrée avec une attente
    -- pseudo-aléatoire.
    ---------------------------------------------------------------------------
    TestLpscEdgeDetectorxP : process is
    begin  -- process TestLpscEdgeDetectorxP

        -- On initialise le signal d'entré à 0
        -- ProbexS <= '0';
	
        -- On attend la fin du reset.
        wait until (RstxR = '0');
	--StartxS <= '1';
	--wait until rising_edge(ClkxC);
	--StartxS <= '0';

        -- On effectue C_NB_TEST fois le test.
        --for i in 0 to 30 loop
	XscreenxD <= "0000000000";
	YscreenxD <= "0000000000";
	CRxD <= C_TEST_DATA_R;
	CIxD <= C_TEST_DATA_R;
	wait until ReadyxS = '1';
	--wait until Ready1xS = '1';
	StartxS <= '1';
	wait until rising_edge(ClkxC);
	wait until rising_edge(ClkxC);
	StartxS <= '0';
	XscreenxD <= "0000000001";
	YscreenxD <= "0000000001";
	CRxD <= C_TEST_DATA_R;
	CIxD <= C_TEST_DATA_R;
	Start1xS <= '1';
	wait until rising_edge(ClkxC);
	Start1xS <= '0';

	--	wait until rising_edge(ClkxC);
	wait on FinishedxS;
	wait on Finished1xS;
	
        EndOfSimxS <= true;

    end process TestLpscEdgeDetectorxP;

end behavioral;

