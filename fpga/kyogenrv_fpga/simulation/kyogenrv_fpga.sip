set_global_assignment -entity "kyogenrv_fpga" -library "lib_kyogenrv_fpga" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "kyogenrv_fpga" -library "lib_kyogenrv_fpga" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "kyogenrv_fpga" -library "lib_kyogenrv_fpga" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_kyogenrv_fpga" -name SPD_FILE [file join $::quartus(sip_path) "../kyogenrv_fpga.spd"]
set_global_assignment -library "lib_kyogenrv_fpga" -name MISC_FILE [file join $::quartus(sip_path) "../../kyogenrv_fpga.qsys"]

set_global_assignment -library "lib_kyogenrv_fpga" -name MISC_FILE [file join $::quartus(sip_path) "kyogenrv_fpga.v"]
