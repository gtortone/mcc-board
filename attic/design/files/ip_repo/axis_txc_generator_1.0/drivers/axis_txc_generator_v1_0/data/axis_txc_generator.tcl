

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "XTxcGenerator" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR"
	
	xdefine_config_file $drv_handle "xtxcgenerator_g.c" "XTxcGenerator" "DEVICE_ID" "C_S_AXI_BASEADDR"
}
