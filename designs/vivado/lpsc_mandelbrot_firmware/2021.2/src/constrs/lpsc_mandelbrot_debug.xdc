


connect_debug_port dbg_hub/clk [get_nets clka]

connect_debug_port u_ila_0/probe3 [get_nets [list {StatexP[3][0]} {StatexP[3][1]} {StatexP[3][2]}]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list FpgaUserCDxB.ClkMandelbrotxI/inst/ClkMandelxCO]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {CounterclkxS[0]} {CounterclkxS[1]} {CounterclkxS[2]} {CounterclkxS[3]} {CounterclkxS[4]} {CounterclkxS[5]} {CounterclkxS[6]} {CounterclkxS[7]} {CounterclkxS[8]} {CounterclkxS[9]} {CounterclkxS[10]} {CounterclkxS[11]} {CounterclkxS[12]} {CounterclkxS[13]} {CounterclkxS[14]} {CounterclkxS[15]} {CounterclkxS[16]} {CounterclkxS[17]} {CounterclkxS[18]} {CounterclkxS[19]} {CounterclkxS[20]} {CounterclkxS[21]} {CounterclkxS[22]} {CounterclkxS[23]} {CounterclkxS[24]} {CounterclkxS[25]} {CounterclkxS[26]} {CounterclkxS[27]} {CounterclkxS[28]} {CounterclkxS[29]} {CounterclkxS[30]} {CounterclkxS[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list CyclefinishedxS]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets ClkMandelxC]
