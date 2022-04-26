// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Sun Apr 24 17:35:35 2022
// Host        : pierrick-Aspire-A515-54G running 64-bit Linux Mint 20
// Command     : write_verilog -force -mode synth_stub
//               /home/pierrick/LPSC_workspace/lpsc-mandelbrot/ips/hw/lpsc_clk_mandelbrot/src/ip_core/clk_mandelbrot/clk_mandelbrot_stub.v
// Design      : clk_mandelbrot
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_mandelbrot(ClkMandelxCO, reset, PllLockedxSO, 
  ClkSys100MhzxCI)
/* synthesis syn_black_box black_box_pad_pin="ClkMandelxCO,reset,PllLockedxSO,ClkSys100MhzxCI" */;
  output ClkMandelxCO;
  input reset;
  output PllLockedxSO;
  input ClkSys100MhzxCI;
endmodule
