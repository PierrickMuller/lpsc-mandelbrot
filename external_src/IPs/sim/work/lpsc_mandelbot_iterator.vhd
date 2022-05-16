--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
--Date        : Sat May 14 20:19:13 2022
--Host        : pierrick-Aspire-A515-54G running 64-bit Linux Mint 20
--Command     : generate_target lpsc_mandelbot_iterator.bd
--Design      : lpsc_mandelbot_iterator
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity lpsc_mandelbot_iterator is
  port (
    CIxD : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CRxD : in STD_LOGIC_VECTOR ( 17 downto 0 );
    IterationNumxDN : out STD_LOGIC_VECTOR ( 17 downto 0 );
    IterationNumxDP : in STD_LOGIC_VECTOR ( 17 downto 0 );
    RvaluexD : out STD_LOGIC_VECTOR ( 17 downto 0 );
    ZnIxDN : out STD_LOGIC_VECTOR ( 17 downto 0 );
    ZnIxDP : in STD_LOGIC_VECTOR ( 17 downto 0 );
    ZnRxDN : out STD_LOGIC_VECTOR ( 17 downto 0 );
    ZnRxDP : in STD_LOGIC_VECTOR ( 17 downto 0 );
    clk : in STD_LOGIC;
    rst : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of lpsc_mandelbot_iterator : entity is "lpsc_mandelbot_iterator,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=lpsc_mandelbot_iterator,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=28,numReposBlks=28,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of lpsc_mandelbot_iterator : entity is "lpsc_mandelbot_iterator.hwdef";
end lpsc_mandelbot_iterator;

architecture STRUCTURE of lpsc_mandelbot_iterator is
  component lpsc_mandelbot_iterator_c_addsub_0_0 is
  port (
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_c_addsub_0_0;
  component lpsc_mandelbot_iterator_mult_gen_0_2 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    SCLR : in STD_LOGIC;
    P : out STD_LOGIC_VECTOR ( 35 downto 0 )
  );
  end component lpsc_mandelbot_iterator_mult_gen_0_2;
  component lpsc_mandelbot_iterator_mult_power2_ZR_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    SCLR : in STD_LOGIC;
    P : out STD_LOGIC_VECTOR ( 35 downto 0 )
  );
  end component lpsc_mandelbot_iterator_mult_power2_ZR_0;
  component lpsc_mandelbot_iterator_c_addsub_0_1 is
  port (
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_c_addsub_0_1;
  component lpsc_mandelbot_iterator_mult_2_ZR_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    SCLR : in STD_LOGIC;
    P : out STD_LOGIC_VECTOR ( 35 downto 0 )
  );
  end component lpsc_mandelbot_iterator_mult_2_ZR_0;
  component lpsc_mandelbot_iterator_slice_mul_2_ZR_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 16 downto 0 )
  );
  end component lpsc_mandelbot_iterator_slice_mul_2_ZR_0;
  component lpsc_mandelbot_iterator_c_addsub_0_2 is
  port (
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_c_addsub_0_2;
  component lpsc_mandelbot_iterator_final_add_imaginary_0 is
  port (
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_final_add_imaginary_0;
  component lpsc_mandelbot_iterator_c_addsub_0_3 is
  port (
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_c_addsub_0_3;
  component lpsc_mandelbot_iterator_mult_power2_ZI_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    SCLR : in STD_LOGIC;
    P : out STD_LOGIC_VECTOR ( 35 downto 0 )
  );
  end component lpsc_mandelbot_iterator_mult_power2_ZI_0;
  component lpsc_mandelbot_iterator_mult_power2_ZnI_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    SCLR : in STD_LOGIC;
    P : out STD_LOGIC_VECTOR ( 35 downto 0 )
  );
  end component lpsc_mandelbot_iterator_mult_power2_ZnI_0;
  component lpsc_mandelbot_iterator_add_ZI_mul_ZR_0 is
  port (
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    B : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_add_ZI_mul_ZR_0;
  component lpsc_mandelbot_iterator_add_Iteration_Number_0 is
  port (
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_add_Iteration_Number_0;
  component lpsc_mandelbot_iterator_add_Iteration_Number1_0 is
  port (
    A : in STD_LOGIC_VECTOR ( 17 downto 0 );
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_add_Iteration_Number1_0;
  component lpsc_mandelbot_iterator_xlconcat_0_0 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 16 downto 0 );
    In1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_xlconcat_0_0;
  component lpsc_mandelbot_iterator_xlslice_0_1 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component lpsc_mandelbot_iterator_xlslice_0_1;
  component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_0 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 16 downto 0 );
    In1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_0;
  component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_1 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 16 downto 0 );
    In1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_1;
  component lpsc_mandelbot_iterator_slice_sign_mul_ZI_ZR_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component lpsc_mandelbot_iterator_slice_sign_mul_ZI_ZR_0;
  component lpsc_mandelbot_iterator_slice_sign_pow2_ZR_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component lpsc_mandelbot_iterator_slice_sign_pow2_ZR_0;
  component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 16 downto 0 )
  );
  end component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_0;
  component lpsc_mandelbot_iterator_slice_pow2_ZR_1 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 16 downto 0 )
  );
  end component lpsc_mandelbot_iterator_slice_pow2_ZR_1;
  component lpsc_mandelbot_iterator_slice_sign_mul_ZI_ZR_1 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component lpsc_mandelbot_iterator_slice_sign_mul_ZI_ZR_1;
  component lpsc_mandelbot_iterator_slice_sign_pow2_ZnI_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component lpsc_mandelbot_iterator_slice_sign_pow2_ZnI_0;
  component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_1 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 16 downto 0 )
  );
  end component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_1;
  component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_2 is
  port (
    Din : in STD_LOGIC_VECTOR ( 35 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 16 downto 0 )
  );
  end component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_2;
  component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_2 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 16 downto 0 );
    In1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_2;
  component lpsc_mandelbot_iterator_concat_pow2_ZnI_0 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 16 downto 0 );
    In1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component lpsc_mandelbot_iterator_concat_pow2_ZnI_0;
  signal CIxD_1 : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal CRxD_1 : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal IterationNumxDP_1 : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal ZnIxDP_1 : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal ZnRxDP_1 : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal add_Iteration_Number1_S : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal add_Iteration_Number2_S : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal add_ZnI_mul_ZnR_S : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal c_addsub_0_S1 : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal clk_1 : STD_LOGIC;
  signal concat_mul_ZI_ZR_dout : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal concat_pow2_ZI_dout : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal concat_pow2_ZR_dout : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal concat_pow2_ZnI_dout : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal concat_pow2_ZnR_dout : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal final_add_imaginary1_S : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal final_add_imaginary_S : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal final_add_real_S : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal mult_2_ZR1_P : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal mult_power2_ZI_P : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal mult_power2_ZR_P : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal mult_power2_ZnI_P : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal mult_power2_ZnR_P : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal rst_1 : STD_LOGIC;
  signal slice_mul_ZI_ZR_Dout : STD_LOGIC_VECTOR ( 16 downto 0 );
  signal slice_pow2_ZI_Dout : STD_LOGIC_VECTOR ( 16 downto 0 );
  signal slice_pow2_ZR_Dout : STD_LOGIC_VECTOR ( 16 downto 0 );
  signal slice_pow2_ZnI_Dout : STD_LOGIC_VECTOR ( 16 downto 0 );
  signal slice_pow2_ZnR_Dout : STD_LOGIC_VECTOR ( 16 downto 0 );
  signal slice_sign_mul_ZI_ZR_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal slice_sign_pow2_ZI_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal slice_sign_pow2_ZR_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal slice_sign_pow2_ZnI_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal slice_sign_pow2_ZnR_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal sub_pow2_ZI_ZR_S : STD_LOGIC_VECTOR ( 17 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 CLK.CLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_RESET rst, CLK_DOMAIN lpsc_mandelbot_iterator_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of rst : signal is "xilinx.com:signal:reset:1.0 RST.RST RST";
  attribute X_INTERFACE_PARAMETER of rst : signal is "XIL_INTERFACENAME RST.RST, INSERT_VIP 0, POLARITY ACTIVE_HIGH";
  attribute X_INTERFACE_INFO of CRxD : signal is "xilinx.com:signal:data:1.0 DATA.CRXD DATA";
  attribute X_INTERFACE_PARAMETER of CRxD : signal is "XIL_INTERFACENAME DATA.CRXD, LAYERED_METADATA undef";
begin
  CIxD_1(17 downto 0) <= CIxD(17 downto 0);
  CRxD_1(17 downto 0) <= CRxD(17 downto 0);
  IterationNumxDN(17 downto 0) <= c_addsub_0_S1(17 downto 0);
  IterationNumxDP_1(17 downto 0) <= IterationNumxDP(17 downto 0);
  RvaluexD(17 downto 0) <= add_ZnI_mul_ZnR_S(17 downto 0);
  ZnIxDN(17 downto 0) <= add_Iteration_Number1_S(17 downto 0);
  ZnIxDP_1(17 downto 0) <= ZnIxDP(17 downto 0);
  ZnRxDN(17 downto 0) <= add_Iteration_Number2_S(17 downto 0);
  ZnRxDP_1(17 downto 0) <= ZnRxDP(17 downto 0);
  clk_1 <= clk;
  rst_1 <= rst;
add_Iteration_Number: component lpsc_mandelbot_iterator_c_addsub_0_3
     port map (
      A(17 downto 0) => IterationNumxDP_1(17 downto 0),
      CLK => clk_1,
      S(17 downto 0) => c_addsub_0_S1(17 downto 0),
      SCLR => rst_1
    );
add_Iteration_Number1: component lpsc_mandelbot_iterator_add_Iteration_Number_0
     port map (
      A(17 downto 0) => final_add_imaginary_S(17 downto 0),
      CLK => clk_1,
      S(17 downto 0) => add_Iteration_Number1_S(17 downto 0),
      SCLR => rst_1
    );
add_Iteration_Number2: component lpsc_mandelbot_iterator_add_Iteration_Number1_0
     port map (
      A(17 downto 0) => final_add_real_S(17 downto 0),
      CLK => clk_1,
      S(17 downto 0) => add_Iteration_Number2_S(17 downto 0),
      SCLR => rst_1
    );
add_ZI_mul_ZR: component lpsc_mandelbot_iterator_final_add_imaginary_0
     port map (
      A(17 downto 0) => concat_mul_ZI_ZR_dout(17 downto 0),
      B(17 downto 0) => concat_mul_ZI_ZR_dout(17 downto 0),
      CLK => clk_1,
      S(17 downto 0) => final_add_imaginary1_S(17 downto 0),
      SCLR => rst_1
    );
add_ZnI_mul_ZnR: component lpsc_mandelbot_iterator_add_ZI_mul_ZR_0
     port map (
      A(17 downto 0) => concat_pow2_ZnI_dout(17 downto 0),
      B(17 downto 0) => concat_pow2_ZnR_dout(17 downto 0),
      CLK => clk_1,
      S(17 downto 0) => add_ZnI_mul_ZnR_S(17 downto 0),
      SCLR => rst_1
    );
concat_mul_ZI_ZR: component lpsc_mandelbot_iterator_xlconcat_0_0
     port map (
      In0(16 downto 0) => slice_mul_ZI_ZR_Dout(16 downto 0),
      In1(0) => slice_sign_mul_ZI_ZR_Dout(0),
      dout(17 downto 0) => concat_mul_ZI_ZR_dout(17 downto 0)
    );
concat_pow2_ZI: component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_1
     port map (
      In0(16 downto 0) => slice_pow2_ZI_Dout(16 downto 0),
      In1(0) => slice_sign_pow2_ZI_Dout(0),
      dout(17 downto 0) => concat_pow2_ZI_dout(17 downto 0)
    );
concat_pow2_ZR: component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_0
     port map (
      In0(16 downto 0) => slice_pow2_ZR_Dout(16 downto 0),
      In1(0) => slice_sign_pow2_ZR_Dout(0),
      dout(17 downto 0) => concat_pow2_ZR_dout(17 downto 0)
    );
concat_pow2_ZnI: component lpsc_mandelbot_iterator_concat_mul_ZI_ZR_2
     port map (
      In0(16 downto 0) => slice_pow2_ZnI_Dout(16 downto 0),
      In1(0) => slice_sign_pow2_ZnI_Dout(0),
      dout(17 downto 0) => concat_pow2_ZnI_dout(17 downto 0)
    );
concat_pow2_ZnR: component lpsc_mandelbot_iterator_concat_pow2_ZnI_0
     port map (
      In0(16 downto 0) => slice_pow2_ZnR_Dout(16 downto 0),
      In1(0) => slice_sign_pow2_ZnR_Dout(0),
      dout(17 downto 0) => concat_pow2_ZnR_dout(17 downto 0)
    );
final_add_imaginary: component lpsc_mandelbot_iterator_c_addsub_0_2
     port map (
      A(17 downto 0) => CIxD_1(17 downto 0),
      B(17 downto 0) => final_add_imaginary1_S(17 downto 0),
      CLK => clk_1,
      S(17 downto 0) => final_add_imaginary_S(17 downto 0),
      SCLR => rst_1
    );
final_add_real: component lpsc_mandelbot_iterator_c_addsub_0_1
     port map (
      A(17 downto 0) => sub_pow2_ZI_ZR_S(17 downto 0),
      B(17 downto 0) => CRxD_1(17 downto 0),
      CLK => clk_1,
      S(17 downto 0) => final_add_real_S(17 downto 0),
      SCLR => rst_1
    );
mult_ZI_ZR: component lpsc_mandelbot_iterator_mult_2_ZR_0
     port map (
      A(17 downto 0) => ZnIxDP_1(17 downto 0),
      B(17 downto 0) => ZnRxDP_1(17 downto 0),
      CLK => clk_1,
      P(35 downto 0) => mult_2_ZR1_P(35 downto 0),
      SCLR => rst_1
    );
mult_power2_ZI: component lpsc_mandelbot_iterator_mult_power2_ZR_0
     port map (
      A(17 downto 0) => ZnIxDP_1(17 downto 0),
      B(17 downto 0) => ZnIxDP_1(17 downto 0),
      CLK => clk_1,
      P(35 downto 0) => mult_power2_ZI_P(35 downto 0),
      SCLR => rst_1
    );
mult_power2_ZR: component lpsc_mandelbot_iterator_mult_gen_0_2
     port map (
      A(17 downto 0) => ZnRxDP_1(17 downto 0),
      B(17 downto 0) => ZnRxDP_1(17 downto 0),
      CLK => clk_1,
      P(35 downto 0) => mult_power2_ZR_P(35 downto 0),
      SCLR => rst_1
    );
mult_power2_ZnI: component lpsc_mandelbot_iterator_mult_power2_ZI_0
     port map (
      A(17 downto 0) => final_add_imaginary_S(17 downto 0),
      B(17 downto 0) => final_add_imaginary_S(17 downto 0),
      CLK => clk_1,
      P(35 downto 0) => mult_power2_ZnI_P(35 downto 0),
      SCLR => rst_1
    );
mult_power2_ZnR: component lpsc_mandelbot_iterator_mult_power2_ZnI_0
     port map (
      A(17 downto 0) => final_add_real_S(17 downto 0),
      B(17 downto 0) => final_add_real_S(17 downto 0),
      CLK => clk_1,
      P(35 downto 0) => mult_power2_ZnR_P(35 downto 0),
      SCLR => rst_1
    );
slice_mul_ZI_ZR: component lpsc_mandelbot_iterator_slice_mul_2_ZR_0
     port map (
      Din(35 downto 0) => mult_2_ZR1_P(35 downto 0),
      Dout(16 downto 0) => slice_mul_ZI_ZR_Dout(16 downto 0)
    );
slice_pow2_ZI: component lpsc_mandelbot_iterator_slice_pow2_ZR_1
     port map (
      Din(35 downto 0) => mult_power2_ZI_P(35 downto 0),
      Dout(16 downto 0) => slice_pow2_ZI_Dout(16 downto 0)
    );
slice_pow2_ZR: component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_0
     port map (
      Din(35 downto 0) => mult_power2_ZR_P(35 downto 0),
      Dout(16 downto 0) => slice_pow2_ZR_Dout(16 downto 0)
    );
slice_pow2_ZnI: component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_1
     port map (
      Din(35 downto 0) => mult_power2_ZnI_P(35 downto 0),
      Dout(16 downto 0) => slice_pow2_ZnI_Dout(16 downto 0)
    );
slice_pow2_ZnR: component lpsc_mandelbot_iterator_slice_mul_ZI_ZR_2
     port map (
      Din(35 downto 0) => mult_power2_ZnR_P(35 downto 0),
      Dout(16 downto 0) => slice_pow2_ZnR_Dout(16 downto 0)
    );
slice_sign_mul_ZI_ZR: component lpsc_mandelbot_iterator_xlslice_0_1
     port map (
      Din(35 downto 0) => mult_2_ZR1_P(35 downto 0),
      Dout(0) => slice_sign_mul_ZI_ZR_Dout(0)
    );
slice_sign_pow2_ZI: component lpsc_mandelbot_iterator_slice_sign_pow2_ZR_0
     port map (
      Din(35 downto 0) => mult_power2_ZI_P(35 downto 0),
      Dout(0) => slice_sign_pow2_ZI_Dout(0)
    );
slice_sign_pow2_ZR: component lpsc_mandelbot_iterator_slice_sign_mul_ZI_ZR_0
     port map (
      Din(35 downto 0) => mult_power2_ZR_P(35 downto 0),
      Dout(0) => slice_sign_pow2_ZR_Dout(0)
    );
slice_sign_pow2_ZnI: component lpsc_mandelbot_iterator_slice_sign_mul_ZI_ZR_1
     port map (
      Din(35 downto 0) => mult_power2_ZnI_P(35 downto 0),
      Dout(0) => slice_sign_pow2_ZnI_Dout(0)
    );
slice_sign_pow2_ZnR: component lpsc_mandelbot_iterator_slice_sign_pow2_ZnI_0
     port map (
      Din(35 downto 0) => mult_power2_ZnR_P(35 downto 0),
      Dout(0) => slice_sign_pow2_ZnR_Dout(0)
    );
sub_pow2_ZI_ZR: component lpsc_mandelbot_iterator_c_addsub_0_0
     port map (
      A(17 downto 0) => concat_pow2_ZR_dout(17 downto 0),
      B(17 downto 0) => concat_pow2_ZI_dout(17 downto 0),
      CLK => clk_1,
      S(17 downto 0) => sub_pow2_ZI_ZR_S(17 downto 0),
      SCLR => rst_1
    );
end STRUCTURE;
