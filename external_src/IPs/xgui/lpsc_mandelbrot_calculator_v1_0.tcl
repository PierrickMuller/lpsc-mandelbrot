# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "comma" -parent ${Page_0}
  ipgui::add_param $IPINST -name "max_iter" -parent ${Page_0}


}

proc update_PARAM_VALUE.SIZE { PARAM_VALUE.SIZE } {
	# Procedure called to update SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIZE { PARAM_VALUE.SIZE } {
	# Procedure called to validate SIZE
	return true
}

proc update_PARAM_VALUE.comma { PARAM_VALUE.comma } {
	# Procedure called to update comma when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.comma { PARAM_VALUE.comma } {
	# Procedure called to validate comma
	return true
}

proc update_PARAM_VALUE.max_iter { PARAM_VALUE.max_iter } {
	# Procedure called to update max_iter when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.max_iter { PARAM_VALUE.max_iter } {
	# Procedure called to validate max_iter
	return true
}


proc update_MODELPARAM_VALUE.comma { MODELPARAM_VALUE.comma PARAM_VALUE.comma } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.comma}] ${MODELPARAM_VALUE.comma}
}

proc update_MODELPARAM_VALUE.max_iter { MODELPARAM_VALUE.max_iter PARAM_VALUE.max_iter } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.max_iter}] ${MODELPARAM_VALUE.max_iter}
}

proc update_MODELPARAM_VALUE.SIZE { MODELPARAM_VALUE.SIZE PARAM_VALUE.SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIZE}] ${MODELPARAM_VALUE.SIZE}
}

