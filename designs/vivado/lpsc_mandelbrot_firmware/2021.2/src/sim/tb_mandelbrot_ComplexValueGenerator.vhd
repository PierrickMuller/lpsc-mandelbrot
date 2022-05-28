----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2022 11:49:11 PM
-- Design Name: 
-- Module Name: tb_mandelbrot_ComplexValueGenerator - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Utile pour générer des valeurs pseudo-aléatoires.
use ieee.math_real.uniform;
use ieee.math_real.floor;

library unisim;
use unisim.vcomponents.all;


entity tb_mandelbrot_ComplexValueGenerator is
-- Empty for a testbench
end tb_mandelbrot_ComplexValueGenerator;

architecture Behavioral of tb_mandelbrot_ComplexValueGenerator is
	constant C_CLK_PERIOD 	: time    := 10 ns;
    	constant C_NB_TEST    	: integer := 1;
	constant SIZE	      	: integer := 18;
	constant SCREEN_RES	: integer := 10;
	constant X_SIZE		: integer := 1024;
	constant Y_SIZE		: integer := 600;
	
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
	
	signal ClkxC            : std_ulogic := '0';
    	signal RstxR            : std_ulogic := '1';  -- Au départ, on dans l'état reset.

	signal EndOfSimxS       : boolean    := false;


	signal NextValuexS	: std_logic := '0';
	signal CincrexD		: std_logic_vector((SIZE -1) downto 0) := (others => '0');
	signal CincimxD		: std_logic_vector((SIZE -1) downto 0) := (others => '0');
	signal CtopleftrexD	: std_logic_vector((SIZE -1) downto 0) := "111000000000000000";
	signal CtopleftimxD	: std_logic_vector((SIZE -1) downto 0) := "000100000000000000";
	signal CrealxD		: std_logic_vector((SIZE -1) downto 0) := (others => '0');
	signal CimaginaryxD	: std_logic_vector((SIZE -1) downto 0) := (others => '0');
	signal XscreenxD	: std_logic_vector((SCREEN_RES -1) downto 0) := (others => '0');
	signal YscreenxD	: std_logic_vector((SCREEN_RES -1) downto 0) := (others => '0');

begin

	AsyncStatxB : block is
	begin  -- block AsyncStatxB

		-- On génére une horloge de période C_CLK_PERIOD.
		ClkxAS : ClkxC <= not ClkxC after (C_CLK_PERIOD / 2);
		-- On lève le reset après 100 ns.
		RstxAS : RstxR <= '0'       after (C_CLK_PERIOD * 10);

	end block AsyncStatxB;

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
    	-- Instance du composant lpsc_mandelbr
    	---------------------------------------------------------------------------

	LpscMadelbrotComplexValueGenerator : lpsc_mandelbrot_ComplexValueGenerator
		port map (
			clk => ClkxC,
			reset => RstxR,
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

 	---------------------------------------------------------------------------
	-- Process de test pour le composant lpsc_mandelbrot_ComplexValueGenerator.
	---------------------------------------------------------------------------
	TestLpscMandelbrotComplexValueGeneratorxP : process is
	begin  -- process TestLpscEdgeDetectorxP
	
		-- On attend la fin du reset.
		wait until (RstxR = '0');

		CincrexD 	<= "000000000000110000";
		CincimxD 	<= "000000000000110111";
		CtopleftrexD 	<= "111000000000000000";
		CtopleftimxD	<= "000100000000000000";
		NextValuexS	<= '1';

		for i in 0 to X_SIZE*Y_SIZE  loop
		
            		wait for  C_CLK_PERIOD;

        	end loop;  -- i

		-- On signifie la fin de la simulation.
		-- Le process EndOfSimxP se chargera de mettre
		-- fin à la simulation.
		EndOfSimxS <= true;

	end process TestLpscMandelbrotComplexValueGeneratorxP;
	

end Behavioral;
