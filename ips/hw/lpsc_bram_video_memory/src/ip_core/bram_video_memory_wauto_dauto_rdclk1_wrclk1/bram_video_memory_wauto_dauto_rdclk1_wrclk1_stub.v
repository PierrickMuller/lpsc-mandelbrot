// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Mon Feb 28 10:34:26 2022
// Host        : debian-xps15 running 64-bit Debian GNU/Linux 11 (bullseye)
// Command     : write_verilog -force -mode synth_stub
//               /home/jo/Documents/Hepia/cours/lpsc/lpsc-mandelbrot/ips/hw/lpsc_bram_video_memory/src/ip_core/bram_video_memory_wauto_dauto_rdclk1_wrclk1/bram_video_memory_wauto_dauto_rdclk1_wrclk1_stub.v
// Design      : bram_video_memory_wauto_dauto_rdclk1_wrclk1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *)
module bram_video_memory_wauto_dauto_rdclk1_wrclk1(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[19:0],dina[8:0],douta[8:0],clkb,web[0:0],addrb[19:0],dinb[8:0],doutb[8:0]" */;
  input clka;
  input [0:0]wea;
  input [19:0]addra;
  input [8:0]dina;
  output [8:0]douta;
  input clkb;
  input [0:0]web;
  input [19:0]addrb;
  input [8:0]dinb;
  output [8:0]doutb;
endmodule
