-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
-- Date        : Wed May 18 19:36:57 2022
-- Host        : pierrick-Aspire-A515-54G running 64-bit Linux Mint 20
-- Command     : write_vhdl -force -mode synth_stub -rename_top clk_mandelbrot -prefix
--               clk_mandelbrot_ clk_mandelbrot_stub.vhdl
-- Design      : clk_mandelbrot
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tsbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_mandelbrot is
  Port ( 
    ClkMandelxCO : out STD_LOGIC;
    reset : in STD_LOGIC;
    PllLockedxSO : out STD_LOGIC;
    ClkSys100MhzxCI : in STD_LOGIC
  );

end clk_mandelbrot;

architecture stub of clk_mandelbrot is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "ClkMandelxCO,reset,PllLockedxSO,ClkSys100MhzxCI";
begin
end;
