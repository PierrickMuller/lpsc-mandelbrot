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
	
	component lpsc_mandelbot_iterator is
  	port (
    		clk : in STD_LOGIC;
    		ZnRxDP : in STD_LOGIC_VECTOR ( 17 downto 0 );
    		ZnIxDP : in STD_LOGIC_VECTOR ( 17 downto 0 );
    		CRxD : in STD_LOGIC_VECTOR ( 17 downto 0 );
    		CIxD : in STD_LOGIC_VECTOR ( 17 downto 0 );
		IterationNumxDN : out STD_LOGIC_VECTOR ( 17 downto 0 );
    		IterationNumxDP : in STD_LOGIC_VECTOR ( 17 downto 0 );
		RvaluexD : out STD_LOGIC_VECTOR ( 17 downto 0 );
    		ZnRxDN : out STD_LOGIC_VECTOR ( 17 downto 0 );
    		ZnIxDN : out STD_LOGIC_VECTOR ( 17 downto 0 )
  	);
  	end component lpsc_mandelbot_iterator;

	-- Signals
	
	-- Signaux Z actuel et futur
	signal ZnRxDP		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal ZnIxDP		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal ZnRxDN   	: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal ZnIxDN		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	
	-- Signaux C 
	signal CRxD		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal CIxD		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');

	-- Sigaux Z temporaires (Carré, added, multiple...)
	signal ZnR_carrexD 	: std_logic_vector( (2*SIZE)-1 downto 0) 	:= (others => '0');
	signal ZnI_carrexD	: std_logic_vector( (2*SIZE)-1 downto 0)	:= (others => '0');
	signal TwoZnRZnIxD	: std_logic_vector( SIZE -1 downto 0)		:= (others => '0');
	
	-- Signaux machine d'état 
	type States is (rdy,calc,finish);
	signal StatexP, StatexN : States := rdy;

	-- Sinaux I/O
	signal StartxS		: std_logic					:= '0';
	signal FinishedxS	: std_logic					:= '0';
	signal IterationxD	: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');

	signal CalcDonexS	: std_logic					:= '0';
	signal IterationNumxDP  : std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal IterationNumxDN  : std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
	signal RvaluexD		: std_logic_vector( SIZE-1 downto 0)		:= (others => '0');
    	-- Attributes
    	-- attribute mark_debug                              : string;
    	-- attribute mark_debug of DebugFlagColor1RegPortxDP : signal is "true";
    	-- --
    	-- attribute keep                                    : string;
    	-- attribute keep of DebugFlagColor1RegPortxDP       : signal is "true";

begin
	
	StartxS <= start;

	CRxD <= c_real;
	CIxD <= c_imaginary;

	lpsc_mandelbot_iterator_i: component lpsc_mandelbot_iterator
     	port map (
      		CIxD(17 downto 0) => CIxD(17 downto 0),
      		CRxD(17 downto 0) => CRxD(17 downto 0),
      		ZnIxDN(17 downto 0) => ZnIxDN(17 downto 0),
      		ZnIxDP(17 downto 0) => ZnIxDP(17 downto 0),
      		ZnRxDN(17 downto 0) => ZnRxDN(17 downto 0),
      		ZnRxDP(17 downto 0) => ZnRxDP(17 downto 0),
		IterationNumxDN(17 downto 0) => IterationNumxDN(17 downto 0),
      		IterationNumxDP(17 downto 0) => IterationNumxDP(17 downto 0),
		RvaluexD(17 downto 0) => RvaluexD(17 downto 0),
      		clk => clk
    	);
	z_real <= ZnRxDN;
	z_imaginary <= ZnIxDN;

	--process(clk)
    	--begin 
	-- a revoir
		--if (rst = '1') then
			-- ZnIxDP <= (others => '0');
			-- ZnRxDP <= (others => '0');
		--	IterationNumxDP <= (others => '0');
		--elsif(rising_edge(clk)) then 
			--ZnIxDP <= ZnIxDN;
			--ZnRxDP <= ZnRxDN;
			--IterationNumxDP <= IterationNumxDN;
			--if (unsigned(RvaluexD(17 downto 14)) > 4) then 
			--	CalcDonexS <= '1';
			--elsif (unsigned(RvaluexD(17 downto 14)) = 4) then -- and (unsigned(RvaluexD(13 downto 0) /= 0)))then 
			--	CalcDonexS <= '1';
			--else 
		--		CalcDonexS <= '0';
		--	end if;
	--	end if;
    --	end process;
	
	state_machine : process(clk,rst)
	begin 
		FinishedxS <= '0';
		if(rst = '1') then
			ZnIxDP <= (others => '0');
			ZnRxDP <= (others => '0');
			--ZnIxDN <= (others => '0');
			--ZnRxDN <= (others => '0');
			IterationNumxDP <= (others => '0');
			--IterationNumxDN <= (others => '0');
			StatexP <= rdy;
		elsif(rising_edge(clk)) then
			case StatexP is 
				when rdy =>
					if StartxS = '1' then
						--IterationxD <= (others => '0');
						StatexP <= calc;
					else
						StatexP <= rdy;
						ZnIxDP <= (others => '0');
						ZnRxDP <= (others => '0');
						--ZnIxDN <= (others => '0');
						--ZnRxDN <= (others => '0');
						IterationNumxDP <= (others => '0');
						--IterationNumxDN <= (others => '0');
					end if;
				when calc =>
					ZnIxDP <= ZnIxDN;
					ZnRxDP <= ZnRxDN;
					IterationNumxDP <= IterationNumxDN;
					if (unsigned(RvaluexD(17 downto 14)) > 4) or ((unsigned(RvaluexD(17 downto 14)) = 4) and (unsigned(RvaluexD(13 downto 0)) /= 0)) then
						StatexP <= finish;
					else
						StatexP <= calc;
					end if;
				when finish =>
					FinishedxS <= '1';
					StatexP <= rdy;
			end case;
		end if;
	end process state_machine;

finished <= FinishedxS;
z_real <= ZnRxDN;
z_imaginary <= ZnIxDN;
iterations <= IterationNumxDN;

end arch;
