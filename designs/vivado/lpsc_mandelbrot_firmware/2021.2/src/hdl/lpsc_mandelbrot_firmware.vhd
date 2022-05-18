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
-- Module Name: lpsc_mandelbrot_firmware - arch
-- Target Device: digilentinc.com:nexys_video:part0:1.1 xc7a200tsbg484-1
-- Tool version: 2021.2
-- Description: lpsc_mandelbrot_firmware
--
-- Last update: 2022-04-12
--
---------------------------------------------------------------------------------
--
-- Modification : 24.004.2022
-- Author : Pierrick Muller
-- Description : Uncomment BRAM and different clock domain
--
---------------------------------------------------------------------------------
--
-- Modification : 14.05.2022
-- Author : Pierrick Muller
-- Description : start integration iterator
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library lpsc_lib;
use lpsc_lib.lpsc_hdmi_interface_pkg.all;

entity lpsc_mandelbrot_firmware is



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

end lpsc_mandelbrot_firmware;

architecture arch of lpsc_mandelbrot_firmware is

    -- Constants

    ---------------------------------------------------------------------------
    -- Resolution configuration
    ---------------------------------------------------------------------------
    -- Possible resolutions
    --
    -- 1024x768
    -- 1024x600
    -- 800x600
    -- 640x480

    -- constant C_VGA_CONFIG : t_VgaConfig := C_1024x768_VGACONFIG;
     constant C_VGA_CONFIG : t_VgaConfig := C_1024x600_VGACONFIG;
    -- constant C_VGA_CONFIG : t_VgaConfig := C_800x600_VGACONFIG;
    -- constant C_VGA_CONFIG : t_VgaConfig := C_640x480_VGACONFIG;

    -- constant C_RESOLUTION : string := "1024x768";
    constant C_RESOLUTION : string := "1024x600";
    --constant C_RESOLUTION : string := "800x600";
    constant C_INC_RE	  : std_logic_vector(17 downto 0) := "000000000000111101";
    constant C_INC_IM	  : std_logic_vector(17 downto 0) := "000000000000110111";
    -- constant C_RESOLUTION : string := "640x480";

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

    -- Components

    component hdmi is
        generic (
            C_CHANNEL_NUMBER : integer;
            C_DATA_SIZE      : integer;
            C_PIXEL_SIZE     : integer;
            C_HDMI_LATENCY   : integer;
            C_VGA_CONFIG     : t_VgaConfig;
            C_RESOLUTION     : string);
        port (
            ClkSys100MhzxCI : in    std_logic;
            RstxRI          : in    std_logic;
            PllLockedxSO    : out   std_logic;
            ClkVgaxCO       : out   std_logic;
            HCountxDO       : out   std_logic_vector((C_DATA_SIZE - 1) downto 0);
            VCountxDO       : out   std_logic_vector((C_DATA_SIZE - 1) downto 0);
            VidOnxSO        : out   std_logic;
            DataxDI         : in    std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
            HdmiTxRsclxSO   : out   std_logic;
            HdmiTxRsdaxSIO  : inout std_logic;
            HdmiTxHpdxSI    : in    std_logic;
            HdmiTxCecxSIO   : inout std_logic;
            HdmiTxClkPxSO   : out   std_logic;
            HdmiTxClkNxSO   : out   std_logic;
            HdmiTxPxDO      : out   std_logic_vector((C_CHANNEL_NUMBER - 2) downto 0);
            HdmiTxNxDO      : out   std_logic_vector((C_CHANNEL_NUMBER - 2) downto 0));
    end component hdmi;

    component clk_mandelbrot
        port(
            ClkMandelxCO    : out std_logic;
            reset           : in  std_logic;
            PllLockedxSO    : out std_logic;
            ClkSys100MhzxCI : in  std_logic);
    end component;

    component image_generator is
        generic (
            C_DATA_SIZE  : integer;
            C_PIXEL_SIZE : integer;
            C_VGA_CONFIG : t_VgaConfig);
        port (
            ClkVgaxCI    : in  std_logic;
            RstxRAI      : in  std_logic;
            PllLockedxSI : in  std_logic;
            HCountxDI    : in  std_logic_vector((C_DATA_SIZE - 1) downto 0);
            VCountxDI    : in  std_logic_vector((C_DATA_SIZE - 1) downto 0);
            VidOnxSI     : in  std_logic;
            DataxDO      : out std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
            Color1xDI    : in  std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0));
    end component image_generator;

    component bram_video_memory_wauto_dauto_rdclk1_wrclk1
        port (
            clka  : in  std_logic;
            wea   : in  std_logic_vector(0 downto 0);
            addra : in  std_logic_vector(19 downto 0);
            dina  : in  std_logic_vector(8 downto 0);
            douta : out std_logic_vector(8 downto 0);
            clkb  : in  std_logic;
            web   : in  std_logic_vector(0 downto 0);
            addrb : in  std_logic_vector(19 downto 0);
            dinb  : in  std_logic_vector(8 downto 0);
            doutb : out std_logic_vector(8 downto 0));
    end component;

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


    -- Signals

    -- Clocks
    signal ClkVgaxC             : std_logic                                         := '0';
    signal ClkMandelxC          : std_logic;
    signal UBlazeUserClkxC      : std_logic                                         := '0';
    -- Reset
    signal ResetxR              : std_logic                                         := '0';
    -- Pll Locked
    signal PllLockedxS          : std_logic                                         := '0';
    signal PllLockedxD          : std_logic_vector(0 downto 0)                      := (others => '0');
    signal PllNotLockedxS       : std_logic                                         := '0';
    signal HdmiPllLockedxS      : std_logic                                         := '0';
    signal HdmiPllNotLockedxS   : std_logic                                         := '0';
    signal UBlazePllLockedxS    : std_logic                                         := '0';
    signal UBlazePllNotLockedxS : std_logic                                         := '0';
    -- VGA
    signal HCountxD             : std_logic_vector((C_DATA_SIZE - 1) downto 0);
    signal VCountxD             : std_logic_vector((C_DATA_SIZE - 1) downto 0);
    signal VidOnxS              : std_logic;
    -- Others
    signal DataImGen2HDMIxD     : std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
    signal DataImGen2BramMVxD         : std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
    signal DataBramMV2HdmixD          : std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
    signal HdmiSourcexD         : t_HdmiSource                                      := C_NO_HDMI_SOURCE;
    signal BramVideoMemoryWriteAddrxD : std_logic_vector((C_BRAM_VIDEO_MEMORY_ADDR_SIZE - 1) downto 0) := (others => '0');
    signal BramVideoMemoryReadAddrxD  : std_logic_vector((C_BRAM_VIDEO_MEMORY_ADDR_SIZE - 1) downto 0);
    signal BramVideoMemoryWriteDataxD : std_logic_vector((C_BRAM_VIDEO_MEMORY_DATA_SIZE - 1) downto 0);
    signal BramVideoMemoryReadDataxD  : std_logic_vector((C_BRAM_VIDEO_MEMORY_DATA_SIZE - 1) downto 0);
    -- AXI4 Lite To Register Bank Signals
    signal WrDataxD             : std_logic_vector((C_AXI4_DATA_SIZE - 1) downto 0) := (others => '0');
    signal WrAddrxD             : std_logic_vector((C_AXI4_ADDR_SIZE - 1) downto 0) := (others => '0');
    signal WrValidxS            : std_logic                                         := '0';
    signal RdDataxD             : std_logic_vector((C_AXI4_DATA_SIZE - 1) downto 0) := (others => '0');
    signal RdAddrxD             : std_logic_vector((C_AXI4_ADDR_SIZE - 1) downto 0) := (others => '0');
    signal RdValidxS            : std_logic                                         := '0';
    signal WrValidDelayedxS     : std_logic                                         := '0';
    signal RdValidFlagColor1xS  : std_logic                                         := '0';
    signal RdEmptyFlagColor1xS  : std_logic                                         := '0';
    signal RdDataFlagColor1xDP  : std_logic_vector((C_FIFO_DATA_SIZE - 1) downto 0) := x"003a8923";
    signal RdDataFlagColor1xDN  : std_logic_vector((C_FIFO_DATA_SIZE - 1) downto 0) := x"003a8923";

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
    type States is (idle,iter,write_mem,next_val);
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

  

    -- Attributes
    -- attribute mark_debug                              : string;
    -- attribute mark_debug of DebugFlagColor1RegPortxDP : signal is "true";
    -- --
    -- attribute keep                                    : string;
    -- attribute keep of DebugFlagColor1RegPortxDP       : signal is "true";

begin

    -- Asynchronous statements

    DebugxB : block is

        -- Debug signals
        -- signal DebugVectExamplexD : std_logic_vector((C_AXI4_DATA_SIZE - 1) downto 0) := (others => '0');

        -- Attributes
        -- attribute mark_debug                       : string;
        -- attribute mark_debug of DebugVectExamplexD : signal is "true";
        -- --
        -- attribute keep                             : string;
        -- attribute keep of DebugVectExamplexD       : signal is "true";

    begin  -- block DebugxB

    end block DebugxB;

    IOPinoutxB : block is
    begin  -- block IOPinoutxB

        ResetxAS      : ResetxR                                 <= not ResetxRNI;
        HdmiTxRsclxAS : HdmiTxRsclxSO                           <= HdmiSourcexD.HdmiSourceOutxD.HdmiTxRsclxS;
        HdmiTxRsdaxAS : HdmiTxRsdaxSIO                          <= HdmiSourcexD.HdmiSourceInOutxS.HdmiTxRsdaxS;
        HdmiTxHpdxAS  : HdmiSourcexD.HdmiSourceInxS.HdmiTxHpdxS <= HdmiTxHpdxSI;
        HdmiTxCecxAS  : HdmiTxCecxSIO                           <= HdmiSourcexD.HdmiSourceInOutxS.HdmiTxCecxS;
        HdmiTxClkPxAS : HdmiTxClkPxSO                           <= HdmiSourcexD.HdmiSourceOutxD.HdmiTxClkPxS;
        HdmiTxClkNxAS : HdmiTxClkNxSO                           <= HdmiSourcexD.HdmiSourceOutxD.HdmiTxClkNxS;
        HdmiTxPxAS    : HdmiTxPxDO                              <= HdmiSourcexD.HdmiSourceOutxD.HdmiTxPxD;
        HdmiTxNxAS    : HdmiTxNxDO                              <= HdmiSourcexD.HdmiSourceOutxD.HdmiTxNxD;

    end block IOPinoutxB;

    -- VGA HDMI Clock Domain
    ---------------------------------------------------------------------------

    VgaHdmiCDxB : block is
    begin  -- block VgaHdmiCDxB

        DataBramMV2HdmixAS : DataBramMV2HdmixD <= BramVideoMemoryReadDataxD(8 downto 6) & "00000" &
                                                  BramVideoMemoryReadDataxD(5 downto 3) & "00000" &
                                                  BramVideoMemoryReadDataxD(2 downto 0) & "00000";

        BramVMRdAddrxAS : BramVideoMemoryReadAddrxD <= VCountxD((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE - 1) downto 0) &
                                                       HCountxD((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE - 1) downto 0);

        HdmiPllNotLockedxAS : HdmiPllNotLockedxS <= not HdmiPllLockedxS;

        LpscHdmixI : entity work.lpsc_hdmi
            generic map (
                C_CHANNEL_NUMBER => C_CHANNEL_NUMBER,
                C_DATA_SIZE      => C_DATA_SIZE,
                C_PIXEL_SIZE     => C_PIXEL_SIZE,
                C_HDMI_LATENCY   => C_HDMI_LATENCY,
                C_VGA_CONFIG     => C_VGA_CONFIG,
                C_RESOLUTION     => C_RESOLUTION)
            port map (
                ClkSys100MhzxCI => ClkSys100MhzxCI,
                RstxRI          => ResetxR,
                PllLockedxSO    => HdmiPllLockedxS,
                ClkVgaxCO       => ClkVgaxC,
                HCountxDO       => HCountxD,
                VCountxDO       => VCountxD,
                VidOnxSO        => open, --VidOnxS,
                DataxDI         => DataBramMV2HdmixD, --DataImGen2HDMIxD,  --DataBramMV2HdmixD,
                HdmiTXRsclxSO   => HdmiSourcexD.HdmiSourceOutxD.HdmiTxRsclxS,
                HdmiTXRsdaxSIO  => HdmiSourcexD.HdmiSourceInOutxS.HdmiTxRsdaxS,
                HdmiTXHpdxSI    => HdmiSourcexD.HdmiSourceInxS.HdmiTxHpdxS,
                HdmiTXCecxSIO   => HdmiSourcexD.HdmiSourceInOutxS.HdmiTxCecxS,
                HdmiTXClkPxSO   => HdmiSourcexD.HdmiSourceOutxD.HdmiTxClkPxS,
                HdmiTXClkNxSO   => HdmiSourcexD.HdmiSourceOutxD.HdmiTxClkNxS,
                HdmiTXPxDO      => HdmiSourcexD.HdmiSourceOutxD.HdmiTxPxD,
                HdmiTXNxDO      => HdmiSourcexD.HdmiSourceOutxD.HdmiTxNxD);

    end block VgaHdmiCDxB;

    -- VGA HDMI To FPGA User Clock Domain Crossing
    ---------------------------------------------------------------------------

    VgaHdmiToFpgaUserCDCxB : block is
    begin  -- block VgaHdmiToFpgaUserCDCxB

        BramVideoMemoryxI : bram_video_memory_wauto_dauto_rdclk1_wrclk1
            port map (
                -- Port A (Write)
                clka  => ClkMandelxC,
                wea   => PllLockedxD,
                addra => BramVideoMemoryWriteAddrxD,
                dina  => BramVideoMemoryWriteDataxD,
                douta => open,
                -- Port B (Read)
                clkb  => ClkVgaxC,
                web   => (others => '0'),
                addrb => BramVideoMemoryReadAddrxD,
                dinb  => (others => '0'),
                doutb => BramVideoMemoryReadDataxD);

    end block VgaHdmiToFpgaUserCDCxB;

    -- FPGA User Clock Domain
    ---------------------------------------------------------------------------

    FpgaUserCDxB : block is

        signal ClkSys100MhzBufgxC : std_logic                                    := '0';
       -- signal HCountIntxD        : std_logic_vector((C_DATA_SIZE - 1) downto 0) := std_logic_vector(C_VGA_CONFIG.HActivexD - 1);
        -- signal VCountIntxD        : std_logic_vector((C_DATA_SIZE - 1) downto 0) := (others => '0');

    begin  -- block FpgaUserCDxB

        PllNotLockedxAS : PllNotLockedxS <= not PllLockedxS;
        PllLockedxAS    : PllLockedxD(0) <= PllLockedxS;

        BramVideoMemoryWriteDataxAS : BramVideoMemoryWriteDataxD <= DataImGen2BramMVxD(23 downto 21) &
                                                                    DataImGen2BramMVxD(15 downto 13) &
                                                                    DataImGen2BramMVxD(7 downto 5);
--
--        BramVMWrAddrxAS : BramVideoMemoryWriteAddrxD <= VCountIntxD((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE - 1) downto 0) &
--                                                        HCountIntxD((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE - 1) downto 0);

        BramVMWrAddrxAS : BramVideoMemoryWriteAddrxD <= YscreenHDMIxD((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE - 1) downto 0) &
                                                        XscreenHDMIxD((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE - 1) downto 0);



        BUFGClkSysToClkMandelxI : BUFG
            port map (
                O => ClkSys100MhzBufgxC,
                I => ClkSys100MhzxCI);

        ClkMandelbrotxI : clk_mandelbrot
            port map (
                ClkMandelxCO    => ClkMandelxC,
                reset           => ResetxR,
                PllLockedxSO    => PllLockedxS,
                ClkSys100MhzxCI => ClkSys100MhzBufgxC);

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


    end block FpgaUserCDxB;

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
				State1xP <= idle;
				--NextValuexS <= '1';
		end case;
	end if;
    end process state_machine_2;

--NextValuexS <= '1' when (NextValue0xS = '1' or NextValue1xS = '1') else
--		'0';
--XscreenHDMIxD <= XscreenHDMIcalc0xD when FinishedxS = '1' or StatexP = write_mem else
--		 XscreenHDMIcalc1xD when Finished1xS = '1' or State1xP = write_mem else
--		 XscreenHDMIxD;
--YscreenHDMIxD <= YscreenHDMIcalc0xD when FinishedxS = '1' or StatexP = write_mem else
--		 YscreenHDMIcalc1xD when Finished1xS = '1' or State1xP = write_mem else
--		 YscreenHDMIxD;
--DataImGen2BramMVxD <= DataImGen2BramMV0xD when FinishedxS = '1' or StatexP = write_mem else
--		      DataImGen2BramMV1xD when Finished1xS = '1' or State1xP = write_mem else
--		      DataImGen2BramMVxD; 

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


end arch;
