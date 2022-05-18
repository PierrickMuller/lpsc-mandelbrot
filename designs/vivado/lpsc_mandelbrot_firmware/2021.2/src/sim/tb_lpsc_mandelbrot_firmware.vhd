----------------------------------------------------------------------------------
--                                 _             _
--                                | |_  ___ _ __(_)__ _
--                                | ' \/ -_) '_ \ / _` |
--                                |_||_\___| .__/_\__,_|
--                                         |_|
--
----------------------------------------------------------------------------------
--
-- Company: hepia
-- Author: Joachim Schmidt <joachim.schmidt@hesge.ch
--
-- Module Name: tb_lpsc_mandelbrot_firmware - arch
-- Target Device: digilentinc.com:nexys_video:part0:1.1 xc7a200tsbg484-1
-- Tool version: 2021.2
-- Description: Testbench for lpsc_mandelbrot_firmware
--
-- Last update: 2022-02-28 10:18:28
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity tb_lpsc_mandelbrot_firmware is
end tb_lpsc_mandelbrot_firmware;


architecture behavioral of tb_lpsc_mandelbrot_firmware is

	constant C_CLK_PERIOD : time    := 10 ns;
	constant C_NB_TEST    : integer := 10;

	component lpsc_mandelbrot_firmware is

	    generic (
		C_CHANNEL_NUMBER : integer := 4;
		C_HDMI_LATENCY   : integer := 0;
		C_GPIO_SIZE      : integer := 8;
		C_AXI4_DATA_SIZE : integer := 32;
		C_AXI4_ADDR_SIZE : integer := 12);

	    port (
		-- Clock and Reset Active Low
		ClkSys100MhzxCI : in    std_logic;
		ResetxRNI       : in    std_logic;
		-- Leds
		LedxDO          : out   std_logic_vector((C_GPIO_SIZE - 1) downto 0);
		-- Buttons
		-- BtnCxSI         : in    std_logic;
		-- HDMI
		HdmiTxRsclxSO   : out   std_logic;
		HdmiTxRsdaxSIO  : inout std_logic;
		HdmiTxHpdxSI    : in    std_logic;
		HdmiTxCecxSIO   : inout std_logic;
		HdmiTxClkPxSO   : out   std_logic;
		HdmiTxClkNxSO   : out   std_logic;
		HdmiTxPxDO      : out   std_logic_vector((C_CHANNEL_NUMBER - 2) downto 0);
		HdmiTxNxDO      : out   std_logic_vector((C_CHANNEL_NUMBER - 2) downto 0));

	end component lpsc_mandelbrot_firmware;

	signal ClkxC            : std_ulogic := '0';	
	signal RstxR            : std_ulogic := '0';  -- Au départ, on dans l'état reset.
	signal EndOfSimxS       : boolean    := false;

begin

	AsyncStatxB : block is
		begin  -- block AsyncStatxB

			-- On génére une horloge de période C_CLK_PERIOD.
			ClkxAS : ClkxC <= not ClkxC after (C_CLK_PERIOD / 2);
			-- On lève le reset après 100 ns.
			RstxAS : RstxR <= '1'       after (C_CLK_PERIOD * 10);

	end block AsyncStatxB;


	LpscMandelbrotFirmwarexI : lpsc_mandelbrot_firmware
		port map(
			
		ClkSys100MhzxCI => ClkxC,
		ResetxRNI       => RstxR,
		LedxDO          => open,
		HdmiTxRsclxSO   => open,
		HdmiTxRsdaxSIO  => open,
		HdmiTxHpdxSI    => '0',
		HdmiTxCecxSIO   => open,
		HdmiTxClkPxSO   => open,
		HdmiTxClkNxSO   => open,
		HdmiTxPxDO      => open,
		HdmiTxNxDO      => open
		);

	EndOfSimxP : process is
		begin  -- process EndOfSimxP
			-- Condition de fin de simulation.
			if EndOfSimxS = true then
			    assert false report "Fin de la simulation!" severity failure;
			end if;

			-- On attend un cycle d'horloge.
			wait until rising_edge(ClkxC);
	end process EndOfSimxP;

	TestLpscMandelbrotFirmwarexP : process is 
	begin
		wait until ( RstxR = '1');

		for i in 0 to C_NB_TEST loop
			wait until rising_edge(ClkxC);
		end loop;

		EndOfSimxS <= true;

	end process TestLpscMandelbrotFirmwarexP;

end behavioral;
