----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/21/2022 09:02:59 PM
-- Design Name: 
-- Module Name: tb_lpsc_mandelbrot_stateMachine - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_lpsc_mandelbrot_stateMachine is
end tb_lpsc_mandelbrot_stateMachine;

architecture Behavioral of tb_lpsc_mandelbrot_stateMachine is

    constant C_DATA_SIZE                        : integer               := 18; --16
    constant C_PIXEL_SIZE                       : integer               := 8;
    constant C_BRAM_VIDEO_MEMORY_ADDR_SIZE      : integer               := 20;
    constant C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE : integer               := 10;
    constant C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE  : integer               := 10;
    constant C_BRAM_VIDEO_MEMORY_DATA_SIZE      : integer               := 9;
    constant C_CDC_TYPE                         : integer range 0 to 2  := 1;
    constant C_RESET_STATE                      : integer range 0 to 1  := 0;
    constant C_SINGLE_BIT                       : integer range 0 to 1  := 1;
    constant C_FLOP_INPUT                       : integer range 0 to 1  := 1;
    constant C_VECTOR_WIDTH                     : integer range 0 to 32 := 2;
    constant C_MTBF_STAGES                      : integer range 0 to 6  := 5;
    constant C_ALMOST_FULL_LEVEL                : integer               := 948;
    constant C_ALMOST_EMPTY_LEVEL               : integer               := 76;
    constant C_FIFO_DATA_SIZE                   : integer               := 32;
    constant C_FIFO_PARITY_SIZE                 : integer               := 4;
    constant C_OUTPUT_BUFFER                    : boolean               := false;


    constant C_INC_RE	  : std_logic_vector(17 downto 0) := "000000000000111101";
    constant C_INC_IM	  : std_logic_vector(17 downto 0) := "000000000000110111";

    constant C_CLK_PERIOD : time    := 10 ns;


	COMPONENT lpsc_mandelbrot_calculator_comp
    		generic(
		comma : integer := 14;
		max_iter : integer := 127;
		SIZE : integer := 18;
		SCREEN_RES : integer := 10
		);
	  PORT (
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

    END COMPONENT;

    	component lpsc_mandelbrot_ComplexValueGenerator is
		generic(
			SIZE       : integer := 18;  -- Taille en bits de nombre au format virgule fixe
			X_SIZE     : integer := 1024;  -- Taille en X (Nombre de pixel) de la fractale à afficher
			Y_SIZE     : integer := 600;  -- Taille en Y (Nombre de pixel) de la fractale à afficher
			SCREEN_RES : integer := 10);  -- Nombre de bit pour les vecteurs X et Y de la position du pixel

    		port(
			clk           : in  std_logic;
			reset         : in  std_logic;
			-- interface avec le module MandelbrotMiddleware
			next_value    : in  std_logic;
			c_inc_RE      : in  std_logic_vector((SIZE - 1) downto 0);
			c_inc_IM      : in  std_logic_vector((SIZE - 1) downto 0);
			c_top_left_RE : in  std_logic_vector((SIZE - 1) downto 0);
			c_top_left_IM : in  std_logic_vector((SIZE - 1) downto 0);
			c_real        : out std_logic_vector((SIZE - 1) downto 0);
			c_imaginary   : out std_logic_vector((SIZE - 1) downto 0);
			X_screen      : out std_logic_vector((SCREEN_RES - 1) downto 0);
			Y_screen      : out std_logic_vector((SCREEN_RES - 1) downto 0));
	end component lpsc_mandelbrot_ComplexValueGenerator;

	-- Tests signals Calculator
    	signal ReadyxS		: std_logic					    := '0';
    	signal StartxS		: std_logic					    := '0';
    	signal FinishedxS		: std_logic					    := '0';
    	signal CrealxD		: std_logic_vector(17 downto 0)			    := (others => '0');
    	signal CimaginaryxD		: std_logic_vector(17 downto 0)			    := (others => '0');
    	signal ZrealxD		: std_logic_vector(17 downto 0)			    := (others => '0');
    	signal ZimaginaryxD		: std_logic_vector(17 downto 0)			    := (others => '0');
    	signal IterationsxD		: std_logic_vector(17 downto 0)			    := (others => '0');

	    -- Signaux machine d'état 
    	type States is (idle,iter,write_mem,write_mem_2,next_val);
    	signal StatexP,State1xP : States := idle;

	-- Tests signaux generator
	signal NextValuexS		: std_logic := '0';
    	signal CincrexD		: std_logic_vector((C_DATA_SIZE -1) downto 0) := C_INC_RE;  -- (others => '0');
    	signal CincimxD		: std_logic_vector((C_DATA_SIZE -1) downto 0) := C_INC_IM; -- (others => '0');
    	signal CtopleftrexD		: std_logic_vector((C_DATA_SIZE -1) downto 0) := "111000000000000000";
    	signal CtopleftimxD		: std_logic_vector((C_DATA_SIZE -1) downto 0) := "000100000000000000";
    	--signal CrealxD		: std_logic_vector((SIZE -1) downto 0) := (others => '0');
    	--signal CimaginaryxD		: std_logic_vector((SIZE -1) downto 0) := (others => '0');
    	signal XscreenxD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE -1) downto 0) := (others => '0');
    	signal YscreenxD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE -1) downto 0) := (others => '0');
    	signal XscreenHDMIxD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE -1) downto 0) := (others => '0');
    	signal YscreenHDMIxD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE -1) downto 0) := (others => '0');
    	signal XscreenHDMIcalc0xD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE -1) downto 0) := (others => '0');
    	signal YscreenHDMIcalc0xD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE -1) downto 0) := (others => '0');
    	signal BusyxS		: std_logic;


    	signal Busy1xS		: std_logic;
    	signal XscreenHDMIcalc1xD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE -1) downto 0) := (others => '0');
    	signal YscreenHDMIcalc1xD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE -1) downto 0) := (others => '0');
    	signal Ready1xS		: std_logic					    := '0';
    	signal Start1xS		: std_logic					    := '0';
    	signal Finished1xS		: std_logic					    := '0';
    	signal Iterations1xD		: std_logic_vector(17 downto 0)			    := (others => '0');
    	signal DataImGen2BramMV0xD         : std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
    	signal DataImGen2BramMV1xD         : std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
    	signal NextValue0xS		: std_logic := '0';
    	signal NextValue1xS		: std_logic := '0';

	signal DataImGen2BramMVxD         : std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
    	signal BramVideoMemoryWriteAddrxD : std_logic_vector((C_BRAM_VIDEO_MEMORY_ADDR_SIZE - 1) downto 0) := (others => '0');

	 signal BramVideoMemoryWriteDataxD : std_logic_vector((C_BRAM_VIDEO_MEMORY_DATA_SIZE - 1) downto 0);


	signal ClkMandelxC            : std_ulogic := '0';	
	signal PllNotLockedxS            : std_ulogic := '1';  -- Au départ, on dans l'état reset.
	signal EndOfSimxS       : boolean    := false;


begin



	AsyncStatxB : block is
		begin  -- block AsyncStatxB

			-- On génére une horloge de période C_CLK_PERIOD.
			ClkxAS : ClkMandelxC <= not ClkMandelxC after (C_CLK_PERIOD / 2);
			-- On lève le reset après 100 ns.
			RstxAS : PllNotlockedxS <= '0'       after (C_CLK_PERIOD * 10);

	end block AsyncStatxB;

	EndOfSimxP : process is
		begin  -- process EndOfSimxP
			-- Condition de fin de simulation.
			if EndOfSimxS = true then
			    assert false report "Fin de la simulation!" severity failure;
			end if;

			-- On attend un cycle d'horloge.
			wait until rising_edge(ClkMandelxC);
	end process EndOfSimxP;





	BramVideoMemoryWriteDataxAS : BramVideoMemoryWriteDataxD <= DataImGen2BramMVxD(23 downto 21) &
                                                                    DataImGen2BramMVxD(15 downto 13) &
                                                                    DataImGen2BramMVxD(7 downto 5);

        BramVMWrAddrxAS : BramVideoMemoryWriteAddrxD <= YscreenHDMIxD((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE - 1) downto 0) &
                                                        XscreenHDMIxD((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE - 1) downto 0);

	LpscMandelbrotCalculator_0 : lpsc_mandelbrot_calculator_comp
		  PORT MAP (
			  clk => ClkMandelxC,
			  rst => PllNotLockedxS,
			  ready => ReadyxS,
			  start => StartxS,
			  finished => FinishedxS,
			  c_real => CrealxD,
			  c_imaginary => CimaginaryxD,
			  z_real => ZrealxD,
			  z_imaginary => ZimaginaryxD,
			  iterations => IterationsxD,
			  x_screen => XscreenxD,
			  y_screen => YscreenxD,
		 	  x_screen_out => XscreenHDMIcalc0xD,
			  y_screen_out => YscreenHDMIcalc0xD,
			  other_finished => '0',
			  busy  => BusyxS
			);

	LpscMandelbrotCalculator_1 : lpsc_mandelbrot_calculator_comp
		  PORT MAP (
			  clk => ClkMandelxC,
			  rst => PllNotLockedxS,
			  ready => Ready1xS,
			  start => Start1xS,
			  finished => Finished1xS,
			  c_real => CrealxD,
			  c_imaginary => CimaginaryxD,
			  z_real => open,
			  z_imaginary => open,
			  iterations => Iterations1xD,
			  x_screen => XscreenxD,
			  y_screen => YscreenxD,
		 	  x_screen_out => XscreenHDMIcalc1xD,
			  y_screen_out => YscreenHDMIcalc1xD,
			  other_finished => FinishedxS,
			  busy  => Busy1xS
			);


	LpscMandelbrotComplexValueGenerator : lpsc_mandelbrot_ComplexValueGenerator
		port map (
			clk => ClkMandelxC,
			reset => PllNotLockedxS,
			next_value => NextValuexS,
			c_inc_RE => CincrexD,
			c_inc_IM => CincimxD,
			c_top_left_RE => CtopleftrexD,
			c_top_left_IM => CtopleftimxD,
			c_real => CrealxD,
			c_imaginary => CimaginaryxD,
			X_screen => XscreenxD,
			Y_screen => YscreenxD
		);


    state_machine : process(all) is
    begin
	if PllNotLockedxS = '1' then
		--CrealxD <= (others => '0');
		--CimaginaryxD <= (others => '0');
		NextValue0xS <= '0';
		StartxS <= '0';
	elsif rising_edge(ClkMandelxC) then
		StartxS <= '0';
		NextValue0xS <= '0';
		case StatexP is
			when idle =>
				if ReadyxS = '1' then
					StartxS <= '1';
					StatexP <= next_val;
				else
					StatexP <= idle;
				end if;
			when next_val =>
				NextValue0xS <= '1';
				StatexP <= iter;
			when iter =>
				if FinishedxS = '1' then
					--XscreenHDMIxD <= XscreenHDMIcalc0xD;
					--YscreenHDMIxD <= YscreenHDMIcalc0xD;
	                		DataImGen2BramMV0xD <=  x"000000" when unsigned(IterationsxD) > 127 else
							       x"00" & IterationsxD(6 downto 0) & '1' & x"FF";

					StatexP <= write_mem;
				else
					StatexP <= iter;
				end if;
			when write_mem => 
				StatexP <= write_mem_2;
			when write_mem_2 =>
				StatexP <= idle;
				--NextValuexS <= '1';
		end case;
	end if;
    end process state_machine;

    state_machine_2 : process(all) is
    begin
	if PllNotLockedxS = '1' then
		NextValue1xS <= '0';
		Start1xS <= '0';
	elsif rising_edge(ClkMandelxC) then
		Start1xS <= '0';
		NextValue1xS <= '0';
		case State1xP is
			when idle =>
				if Ready1xS = '1' and BusyxS = '1' then
					Start1xS <= '1';
					State1xP <= next_val;
				else
					State1xP <= idle;
				end if;
			when next_val =>
				NextValue1xS <= '1';
				State1xP <= iter;
			when iter =>
				if Finished1xS = '1' and FinishedxS = '0' then
					--XscreenHDMIxD <= XscreenHDMIcalc1xD;
					--YscreenHDMIxD <= YscreenHDMIcalc1xD;
	                		DataImGen2BramMV1xD <=  x"000000" when unsigned(Iterations1xD) > 127 else
							       x"00" & Iterations1xD(6 downto 0) & '1' & x"FF";

					State1xP <= write_mem;
				else
					State1xP <= iter;
				end if;
			when write_mem => 
				State1xP <= write_mem_2;
			when write_mem_2 =>
				State1xP <= idle;
				--NextValuexS <= '1';
		end case;
	end if;
    end process state_machine_2;

    state_machine_hdmi : process(all) is
    begin
    	if PllNotLockedxS = '1' then
		NextValuexS <= '0';
		XscreenHDMIxD <= (others => '0');
		YscreenHDMIxD <= (others => '0');
	elsif rising_edge(ClkMandelxC) then
		--NextValuexS <= '1' when (NextValue0xS = '1' or NextValue1xS = '1') else --(StatexP = next_val or State1xP = next_val) else
		--'0';

		if(unsigned(XscreenHDMIxD) = 1023) and (unsigned(YscreenHDMIxD) = 599) then
			EndOfSimxS <= true;
		end if;
		NextValuexS <= '1' when (StatexP = next_val or State1xP = next_val) else
		'0';
		XscreenHDMIxD <= XscreenHDMIcalc0xD when StatexP = write_mem else
				XscreenHDMIcalc1xD when State1xP = write_mem else
		 		XscreenHDMIxD;
		YscreenHDMIxD <= YscreenHDMIcalc0xD when StatexP = write_mem else
				YscreenHDMIcalc1xD when State1xP = write_mem else
		 		YscreenHDMIxD;
		DataImGen2BramMVxD <= DataImGen2BramMV0xD when StatexP = write_mem else
		      		DataImGen2BramMV1xD when State1xP = write_mem else
		      		DataImGen2BramMVxD;
	end if;
    end process state_machine_hdmi;



end Behavioral;
