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

entity tb_lpsc_mandelbrot_calculator is
-- Empty for a testbench
end tb_lpsc_mandelbrot_calculator;


architecture behavioral of tb_lpsc_mandelbrot_calculator is

    constant C_CLK_PERIOD : time    := 10 ns;
    constant C_NB_TEST    : integer := 1;
    constant C_TEST_DATA_R  : std_logic_vector := "000010000000000000";

    component lpsc_mandelbrot_calculator is
    	generic ( comma : integer := 14;
		max_iter : integer := 127;
		SIZE : integer := 18);
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
		iterations : out std_logic_vector(SIZE-1 downto 0)
		);
    end component lpsc_mandelbrot_calculator;

    signal ClkxC            : std_ulogic := '0';
    signal RstxR            : std_ulogic := '1';  -- Au départ, on dans l'état reset.
    signal CIxD		    : std_logic_vector(17 downto 0)	:= "000010000000000000";
    signal CRxD		    : std_logic_vector(17 downto 0)	:= "000010000000000000";
    signal ZnIxDP	    : std_logic_vector(17 downto 0)	:= (others => '0');
    signal ZnRxDP	    : std_logic_vector(17 downto 0)	:= (others => '0');
    signal StartxS	    : std_logic := '0';
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
    LpscEdgeDetectorxI : entity work.lpsc_mandelbrot_calculator
        port map (
            	clk => ClkxC,
		rst => RstxR,
		ready => open,
		start => StartxS,
		finished => open,
		c_real => CRxD,
		c_imaginary => CIxD,
		z_real => ZnRxDP,
		z_imaginary => ZnIxDP,
		iterations => open
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
	StartxS <= '1';

        -- On effectue C_NB_TEST fois le test.
        for i in 0 to 30 loop
	
		CRxD <= C_TEST_DATA_R;
		CIxD <= C_TEST_DATA_R;
		wait until rising_edge(ClkxC);

        end loop;  -- i

        -- On signifie la fin de la simulation.
        -- Le process EndOfSimxP se chargera de mettre
        -- fin à la simulation.
        EndOfSimxS <= true;

    end process TestLpscEdgeDetectorxP;

end behavioral;

