--------------------------------------------------------------------------------
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

entity lpsc_mandelbrot_calculator_comp is
	
	generic ( comma : integer := 14; -- nombre de bits après la virgule
		max_iter : integer := 127;
		SIZE : integer := 18;
		SCREEN_RES : integer := 10);
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
		iterations : out std_logic_vector(SIZE-1 downto 0);
		x_screen : in std_logic_vector(SCREEN_RES-1 downto 0);
		y_screen : in std_logic_vector(SCREEN_RES-1 downto 0);
		x_screen_out : out std_logic_vector(SCREEN_RES-1 downto 0);
		y_screen_out : out std_logic_vector(SCREEN_RES-1 downto 0);
		other_finished : in std_logic;
		busy : out std_logic
	);

end lpsc_mandelbrot_calculator_comp;

architecture arch of lpsc_mandelbrot_calculator_comp is
	
	constant C_COMMA_UP	: integer					:= (SIZE*2)-(SIZE-comma)-1;
	constant C_COMMA_DOWN	: integer					:= comma;
	constant C_R_VALUE	: std_logic_vector( (SIZE - 1) downto 0)	:= "010000000000000000";
	constant C_MAX_ITER	: integer					:= max_iter;
	
	signal MultZiZrxD	: std_logic_vector( (2*SIZE-1) downto 0)	:= (others => '0');
	signal MultPow2ZrxD	: std_logic_vector( (2*SIZE-1) downto 0)	:= (others => '0');
	signal MultPow2ZixD	: std_logic_vector( (2*SIZE-1) downto 0)	:= (others => '0');
	signal CalcRayon	: std_logic_vector( (2*SIZE-1) downto 0)	:= (others => '0');
	signal ZnIxDP		: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal ZnRxDP		: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal AddZiMulZrxD	: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal SubPow2ZiZrxD	: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal AddFinalIxD	: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal AddFinalRxD	: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal ZnIxDN		: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal ZnRxDN		: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal CixD		: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal CRxD		: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');


	signal ReadyxS		: std_logic					:= '0';
	signal StartxS		: std_logic					:= '0';
	signal FinishedxS	: std_logic					:= '0';
	signal FinishedxSP	: std_logic					:= '0';

	signal IterationsxDP	: std_logic_vector( (SIZE - 1) downto 0)	:= (others => '0');
	signal IterationsxDN	: std_logic_vector( (SIZE - 1) downto 0) 	:= (others => '0');

	signal XscreenxD	: std_logic_vector( (SCREEN_RES-1) downto 0)	:= (others => '0');
	signal YscreenxD	: std_logic_vector( (SCREEN_RES-1) downto 0)	:= (others => '0');
	signal BusyxS		: std_logic;

	type States is (rdy,calc,finish); --,rst_state);
	signal StatexP, StatexN : States := rdy;


	attribute use_dsp : string;
	attribute use_dsp of arch : architecture is "yes";

begin

	-- Assignation
	--CixD <= c_imaginary;
	--CrxD <= c_real;
	StartxS <= start;

	lpsc_mandelbrot_iterator : process(all) is
	begin 
		
		ZnIxDP <= ZnIxDN;
		ZnRxDP <= ZnRxDN;

		MultZiZrxD <= std_logic_vector(signed(ZnIxDP) * signed(ZnRxDP));
		MultPow2ZrxD <= std_logic_vector(signed(ZnRxDP) * signed(ZnRxDP));
		MultPow2ZixD <= std_logic_vector(signed(ZnIxDP) * signed(ZnIxDP));

		AddZiMulZrxD <= std_logic_vector(signed(MultZiZrxD(C_COMMA_UP downto C_COMMA_DOWN)) + signed(MultZiZrxD(C_COMMA_UP downto C_COMMA_DOWN)));	
		SubPow2ZiZrxD <= std_logic_vector(signed(MultPow2ZrxD(C_COMMA_UP downto C_COMMA_DOWN)) - signed(MultPow2ZixD(C_COMMA_UP downto C_COMMA_DOWN)));	

		AddFinalIxD <= std_logic_vector(signed(CixD) + signed(AddZiMulZrxD));
		AddFinalRxD <= std_logic_vector(signed(CrxD) + signed(SubPow2ZiZrxD));
		
		IterationsxDN <= std_logic_vector(signed(IterationsxDP) + 1);
		
		CalcRayon <= std_logic_vector((signed(AddFinalIxD)*signed(AddFinalIxD)) + (signed(AddFinalRxD)*signed(AddFinalRxD))); 

		if (unsigned(CalcRayon(C_COMMA_UP downto C_COMMA_DOWN)) > unsigned(C_R_VALUE) OR signed(IterationsxDN) > C_MAX_ITER) then
			FinishedxS <= '1';
		else 
			FinishedxS <= '0';
		end if;


	end process lpsc_mandelbrot_iterator;



	state_machine : process(clk,rst)
	begin
		if(rst = '1') then
			ZnIxDN <= (others => '0');
			ZnRxDN <= (others => '0');
			IterationsxDP <= (others => '0');
			CixD <= (others => '0');
			CrxD <= (others => '0');
			XscreenxD <= (others => '0');
			YscreenxD <= (others => '0');
			BusyxS <= '0';
			StatexP <= rdy;
		elsif(rising_edge(clk)) then
			FinishedxSP <= '0';
			--BusyxS <= '0';
			case StatexP is
				when rdy => 
					if StartxS = '1' and ReadyxS = '1' then
						CixD <= c_imaginary;
						CrxD <= c_real;
						XscreenxD <= x_screen;
						YscreenxD <= y_screen;
						StatexP <= calc;
					else
						StatexP <= rdy;
						ReadyxS <= '1';
						BusyxS <= '0';
						ZnIxDN <= (others => '0');
						ZnRxDN <= (others => '0');
						IterationsxDP <= (others => '0');
					end if;
				when calc => 
					BusyxS <= '1';
					ReadyxS <= '0';
					ZnIxDN <= AddFinalIxD;
					ZnRxDN <= AddFinalRxD;
					IterationsxDP <= IterationsxDN;
					if FinishedxS = '1' then
						FinishedxSP <= FinishedxS;
						StatexP <= finish;
					else
						StatexP <= calc;
					end if;
				when finish => 
					ReadyxS <= '0';
					BusyxS <= '1';
					FinishedxSP <= '1';
					if(other_finished = '1') then
						StatexP <= finish;
					else
						StatexP <= rdy;
					end if;
					--StatexP <= rdy;
				--when rst_state =>
			end case;
		end if;
	end process state_machine;

	finished <= FinishedxSP;
	z_real <= ZnRxDN;
	z_imaginary <= ZnIxDN;
	iterations <= IterationsxDP;
	ready <= ReadyxS;
	x_screen_out <= XscreenxD;
	y_screen_out <= YscreenxD;
	busy <= BusyxS;


end arch;
