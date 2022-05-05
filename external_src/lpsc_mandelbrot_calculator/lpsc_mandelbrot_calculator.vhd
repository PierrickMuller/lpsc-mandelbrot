----------------------------------------------------------------------------------
--
-- Company: HES-SO Master
-- Author: Pierrick Muller <pierrick.muller@hes-so.ch>
--
-- Module Name: lpsc_mandelbrot_calculator - arch
-- Target Device: digilentinc.com:nexys_video:part0:1.1 xc7a200tsbg484-1
-- Tool version: 2021.2
-- Description: lpsc_mandelbrot_calculator
--
-- Last update: 26.04.2022

-----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity lpsc_mandelbrot_calculator is
	
	generic ( comma : integer := 14; -- nombre de bits après la virgule
		max_iter : integer := 127;
		SIZE : integer := 18);
	port(
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

end lpsc_mandelbrot_calculator;

architecture arch of lpsc_mandelbrot_calculator is

	-- Constants


	-- Components


	-- Signals
	
	-- Signaux Z actuel et futur
	signal ZnRxDP		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal ZnIxDP		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal ZnRxDN   	: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal ZNIxDP		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	
	-- Signaux C 
	signal CRxD		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal CIxD		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');

	-- Sigaux Z temporaires (Carré, added, multiple...)
	signal ZnR_carrexD 	: std_logic_vector( (2*SIZE)-1 downto 0) 	:= (others => '0');
	signal ZnI_carrexD	: std_logic_vector( (2*SIZE)-1 downto 0)	:= (others => '0');
	signal TwoZnRZnIxD	: std_logic_vector( SIZE -1 downto 0)		:= (others => '0');


    	-- Attributes
    	-- attribute mark_debug                              : string;
    	-- attribute mark_debug of DebugFlagColor1RegPortxDP : signal is "true";
    	-- --
    	-- attribute keep                                    : string;
    	-- attribute keep of DebugFlagColor1RegPortxDP       : signal is "true";

begin

	CRxD <= c_real;
	CIxD <= c_imaginary; 

	-- multiplication 


end arch;
