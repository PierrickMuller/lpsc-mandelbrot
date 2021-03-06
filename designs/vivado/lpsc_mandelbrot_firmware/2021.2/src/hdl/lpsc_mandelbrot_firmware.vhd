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

    constant C_NB_CALCULATORS			: integer		:= 70;
    constant C_NB_ITER				: integer		:= 127;

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
		max_iter : integer := C_NB_ITER;
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
			SIZE       : integer := C_DATA_SIZE; -- Taille en bits de nombre au format virgule fixe
			X_SIZE     : integer := 1024;  -- Taille en X (Nombre de pixel) de la fractale ?? afficher
			Y_SIZE     : integer := 600;  -- Taille en Y (Nombre de pixel) de la fractale ?? afficher
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

    type t_DataImGen2Bram is array((C_NB_CALCULATORS -1 ) downto 0) of std_logic_vector(((C_PIXEL_SIZE * 3) - 1) downto 0);
    type t_ArrayIter is array((C_NB_CALCULATORS -1) downto 0) of std_logic_vector((C_DATA_SIZE - 1)  downto 0);	
    type t_ArrayScreenHdmiY is array((C_NB_CALCULATORS -1) downto 0) of std_logic_vector((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE -1) downto 0) ;
    type t_ArrayScreenHdmiX is array((C_NB_CALCULATORS -1) downto 0) of std_logic_vector((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE -1) downto 0) ;

    signal DataImGen2BramMVArrayxD    : t_DataImGen2Bram;

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

    -- Signals Calculator
    signal ReadyxS		: std_logic_vector((C_NB_CALCULATORS-1) downto 0)	    := (others => '0');
    signal StartxS		: std_logic_vector((C_NB_CALCULATORS-1) downto 0)	    := (others => '0');
    signal FinishedxS		: std_logic_vector((C_NB_CALCULATORS-1) downto 0)	    := (others => '0');
    signal CrealxD		: std_logic_vector((C_DATA_SIZE - 1) downto 0)	    := (others => '0');
    signal CimaginaryxD		: std_logic_vector((C_DATA_SIZE - 1) downto 0)	    := (others => '0');
    signal IterationsxD		: t_ArrayIter := (others => (others => '0'));
    signal BusyxS		: std_logic_vector((C_NB_CALCULATORS - 1) downto 0) := (others => '0'); 
    signal OtherFinishedxS	: std_logic_vector((C_NB_CALCULATORS - 1) downto 0) := (others => '0');
    
    -- Signaux machine d'??tat 
    type States is (idle,iter,write_mem,write_mem_2,next_val);
    type StatesArray is array((C_NB_CALCULATORS -1) downto 0) of States;
    signal StatexP,State1xP : StatesArray := (others => idle);
  
    -- Tests signaux generator
    signal NextValuexS		: std_logic := '0';
    signal CincrexD		: std_logic_vector((C_DATA_SIZE -1) downto 0) := C_INC_RE;  
    signal CincimxD		: std_logic_vector((C_DATA_SIZE -1) downto 0) := C_INC_IM; 
    signal CtopleftrexD		: std_logic_vector((C_DATA_SIZE -1) downto 0) := "111000000000000000";
    signal CtopleftimxD		: std_logic_vector((C_DATA_SIZE -1) downto 0) := "000100000000000000";
    signal XscreenxD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE -1) downto 0) := (others => '0');
    signal YscreenxD		: std_logic_vector((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE -1) downto 0) := (others => '0');
    signal XscreenHDMIxD	: std_logic_vector((C_BRAM_VIDEO_MEMORY_HIGH_ADDR_SIZE -1) downto 0) := (others => '0');
    signal YscreenHDMIxD	: std_logic_vector((C_BRAM_VIDEO_MEMORY_LOW_ADDR_SIZE -1) downto 0) := (others => '0'); 
    signal XscreenHDMIcalcxD	: t_ArrayScreenHdmiX := (others => (others => '0'));
    signal YscreenHDMIcalcxD	: t_ArrayScreenHdmiY := (others => (others => '0'));

    -- Debug signals 
    signal CounterclkxS		: std_logic_vector(31 downto 0)			    := (others => '0');
    signal CyclefinishedxS	: std_logic					    := '0';
    

    -- Attributes
    attribute keep                            : string;
    attribute mark_debug                      : string;

    attribute mark_debug of XscreenHDMIxD     : signal is "true";
    attribute keep of XscreenHDMIxD	      : signal is "true";
    attribute mark_debug of YscreenHDMIxD     : signal is "true";
    attribute keep of YscreenHDMIxD	      : signal is "true";
    attribute mark_debug of CounterclkxS      : signal is "true";
    attribute keep of CounterclkxS	      : signal is "true";
    attribute mark_debug of CyclefinishedxS   : signal is "true";
    attribute keep of CyclefinishedxS	      : signal is "true";

    attribute mark_debug of BusyxS	      : signal is "true";
    attribute keep of BusyxS		      : signal is "true";
    attribute mark_debug of ReadyxS	      : signal is "true";
    attribute keep of ReadyxS		      : signal is "true";
    attribute mark_debug of StatexP	      : signal is "true";
    attribute keep of StatexP		      : signal is "true";
    attribute mark_debug of FinishedxS	      : signal is "true";
    attribute keep of FinishedxS	      : signal is "true";
    attribute mark_debug of OtherFinishedxS   : signal is "true";
    attribute keep of OtherFinishedxS	      : signal is "true";
    
    attribute mark_debug of ClkMandelxC       : signal is "true";
    attribute keep of ClkMandelxC	      : signal is "true";
    
     
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

    begin  -- block FpgaUserCDxB

        PllNotLockedxAS : PllNotLockedxS <= not PllLockedxS;
        PllLockedxAS    : PllLockedxD(0) <= PllLockedxS;

        BramVideoMemoryWriteDataxAS : BramVideoMemoryWriteDataxD <= DataImGen2BramMVxD(23 downto 21) &
                                                                    DataImGen2BramMVxD(15 downto 13) &
                                                                    DataImGen2BramMVxD(7 downto 5);

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


	-- Generator for calculators blocks

	GEN_CALCS : for I in 0 to (C_NB_CALCULATORS - 1 ) generate

		FIRST_CALC : if I = 0 generate
			LpscMandelbrotCalculator_0 : lpsc_mandelbrot_calculator_comp
		  		PORT MAP (
			 		 clk => ClkMandelxC,
			 		 rst => PllNotLockedxS,
			 		 ready => ReadyxS(I),
			 		 start => StartxS(I),
			 		 finished => FinishedxS(I),
			 		 c_real => CrealxD,
			 		 c_imaginary => CimaginaryxD,
			 		 z_real => open,
			 		 z_imaginary => open,
			 		 iterations => IterationsxD(I),
			 		 x_screen => XscreenxD,
			 		 y_screen => YscreenxD,
		 	 		 x_screen_out => XscreenHDMIcalcxD(I),
			 		 y_screen_out => YscreenHDMIcalcxD(I),
			 		 other_finished => '0',
			 		 busy  => BusyxS(I)
				);
		end generate FIRST_CALC;

		OTHER_CALC : IF I > 0 generate
			OtherFinishedxS(I) <= '0' when (or FinishedxS(I-1 downto 0) = '0') else -- unsigned(FinishedxS(I-1 downto 0)) = 0 else
					   '1';
			LpscMandelbrotCalculator_X : lpsc_mandelbrot_calculator_comp
		  		PORT MAP (
			 		 clk => ClkMandelxC,
			 		 rst => PllNotLockedxS,
			 		 ready => ReadyxS(I),
			 		 start => StartxS(I),
			 		 finished => FinishedxS(I),
			 		 c_real => CrealxD,
			 		 c_imaginary => CimaginaryxD,
			 		 z_real => open,
			 		 z_imaginary => open,
			 		 iterations => IterationsxD(I),
			 		 x_screen => XscreenxD,
			 		 y_screen => YscreenxD,
		 	 		 x_screen_out => XscreenHDMIcalcxD(I),
			 		 y_screen_out => YscreenHDMIcalcxD(I),
			 		 other_finished => OtherFinishedxS(I),
			 		 busy  => BusyxS(I)
				);	
		end generate OTHER_CALC;
	end generate GEN_CALCS;


    end block FpgaUserCDxB;

    -- Generator for State machine for each calculator

    GEN_SM_CALCS : for I in 0 to (C_NB_CALCULATORS-1) generate
    	sm_calc_X : process(all) is
	begin
		if PllNotLockedxS = '1' then
			StartxS(I) <= '0';
		elsif rising_edge(ClkMandelxC) then
			StartxS(I) <= '0';
			case StatexP(I) is 
				when idle =>
					if ReadyxS(I) = '1' then
						if I = 0 or (and BusyxS(I-1 downto 0) = '1') then -- (unsigned(BusyxS(I-1 downto 0)) = (2**I-1)) then 
							StartxS(I) <= '1';
							StatexP(I) <= next_val;
						else
							StatexP(I) <= idle;
						end if;
					else
						StatexP(I) <= idle;
					end if;
				when next_val => 
					StatexP(I) <= iter;
				when iter => 
					if FinishedxS(I) = '1' then
						if I = 0 or (or FinishedxS(I-1 downto 0) = '0') then -- (unsigned(FinishedxS(I-1 downto 0)) = 0) then
		                			DataImGen2BramMVArrayxD(I) <=  x"000000" when unsigned(IterationsxD(I)) > C_NB_ITER else
								       x"00" & IterationsxD(I)(6 downto 0) & '1' & x"FF";
						
							StatexP(I) <= write_mem;
						else
							Statexp(I) <= iter;
						end if;
					else
						StatexP(I) <= iter;
					end if;
				when write_mem => 
					StatexP(I) <= write_mem_2;
				when write_mem_2 =>
					StatexP(I) <= idle;
			end case;
		end if;
	
	end process sm_calc_X;
    end generate GEN_SM_CALCS;

    -- State machine for value change and HDMI 

    state_machine_hdmi : process(all) is
    begin
    	if PllNotLockedxS = '1' then
		NextValuexS <= '0';
		XscreenHDMIxD <= (others => '0');
		YscreenHDMIxD <= (others => '0');
	elsif rising_edge(ClkMandelxC) then
		NextValuexS <= '0';
		XscreenHDMIxD <= XscreenHDMIxD;
		YscreenHDMIxD <= YscreenHDMIxD;
		DataImGen2BramMVxD <= DataImGen2BramMVxD;
		for i in 0 to (C_NB_CALCULATORS-1) loop
			if StatexP(I) = next_val then
				NextValuexS <= '1';
			end if;

			if StatexP(I) = write_mem then
				XscreenHDMIxD <= XscreenHDMIcalcxD(I);
				YscreenHDMIxD <= YscreenHDMIcalcxD(I);
				DataImGen2BramMVxD <= DataImGen2BramMVArrayxD(I);
			end if;		
		
		end loop;
	end if;
    end process state_machine_hdmi;

    -- State machine for cycle counter

    state_machine_debug : process(all) is 
    begin
    	if rising_edge(ClkMandelxC) then
		CyclefinishedxS <= '0';
		CounterclkxS <= std_logic_vector(unsigned(CounterclkxS) + 1);
		if (unsigned(YscreenHDMIxD) = 599 and unsigned(XscreenHDMIxD) = 1023) then
			CyclefinishedxS <= '1';
			CounterclkxS <= (others => '0');
		end if;
	end if;
    end process state_machine_debug;


end arch;
