proc create_ipi_design { offsetfile design_name } {
	create_bd_design $design_name
	open_bd_design $design_name

	# Create Clock and Reset Ports
	set ACLK [ create_bd_port -dir I -type clk ACLK ]
	set_property -dict [ list CONFIG.FREQ_HZ {100000000} CONFIG.PHASE {0.000} CONFIG.CLK_DOMAIN "${design_name}_ACLK" ] $ACLK
	set ARESETN [ create_bd_port -dir I -type rst ARESETN ]
	set_property -dict [ list CONFIG.POLARITY {ACTIVE_LOW}  ] $ARESETN
	set_property CONFIG.ASSOCIATED_RESET ARESETN $ACLK

	# Create instance: axis_txc_generator_0, and set properties
	set axis_txc_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:axis_txc_generator:1.0 axis_txc_generator_0]

	# Create instance: master_0, and set properties
	set master_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cdn_axi_bfm master_0]
	set_property -dict [ list CONFIG.C_PROTOCOL_SELECTION {2} ] $master_0

	# Create interface connections
	connect_bd_intf_net [get_bd_intf_pins master_0/M_AXI_LITE] [get_bd_intf_pins axis_txc_generator_0/S_AXI]

	# Create port connections
	connect_bd_net -net aclk_net [get_bd_ports ACLK] [get_bd_pins master_0/M_AXI_LITE_ACLK] [get_bd_pins axis_txc_generator_0/S_AXI_ACLK]
	connect_bd_net -net aresetn_net [get_bd_ports ARESETN] [get_bd_pins master_0/M_AXI_LITE_ARESETN] [get_bd_pins axis_txc_generator_0/S_AXI_ARESETN]

	# Create instance: slave_0, and set properties
	set slave_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cdn_axi_bfm slave_0]
	set_property -dict [ list CONFIG.C_PROTOCOL_SELECTION {3} CONFIG.C_MODE_SELECT {1} CONFIG.C_S_AXIS_TDATA_WIDTH {32} CONFIG.C_S_AXIS_STROBE_NOT_USED {1} CONFIG.C_S_AXIS_KEEP_NOT_USED {1}  ] $slave_0


	# Create interface connections
	connect_bd_intf_net -intf_net slave_0_s_axis [get_bd_intf_pins axis_txc_generator_0/M_AXIS] [get_bd_intf_pins slave_0/S_AXIS]
	# Create port connections
	connect_bd_net -net aclk_net [get_bd_ports ACLK] [get_bd_pins axis_txc_generator_0/M_AXIS_ACLK] [get_bd_pins slave_0/S_AXIS_ACLK]
	connect_bd_net -net aresetn_net [get_bd_ports ARESETN] [get_bd_pins axis_txc_generator_0/M_AXIS_ARESETN] [get_bd_pins slave_0/S_AXIS_ARESETN]

	# Auto assign address
	assign_bd_address

	# Copy all address to interface_address.vh file
	set bd_path [file dirname [get_property NAME [get_files ${design_name}.bd]]]
	upvar 1 $offsetfile offset_file
	set offset_file "${bd_path}/axis_txc_generator_v1_0_tb_include.vh"
	set fp [open $offset_file "w"]
	puts $fp "`ifndef axis_txc_generator_v1_0_tb_include_vh_"
	puts $fp "`define axis_txc_generator_v1_0_tb_include_vh_\n"
	puts $fp "//Configuration current bd names"
	puts $fp "`define BD_INST_NAME ${design_name}_i"
	puts $fp "`define BD_WRAPPER ${design_name}_wrapper\n"
	puts $fp "//Configuration address parameters"

	set offset [get_property OFFSET [get_bd_addr_segs -of_objects [get_bd_addr_spaces master_0/Data_lite]]]
	set offset_hex [string replace $offset 0 1 "32'h"]
	puts $fp "`define S_AXI_SLAVE_ADDRESS ${offset_hex}"

	puts $fp "`endif"
	close $fp
}

set ip_path [file dirname [file normalize [get_property XML_FILE_NAME [ipx::get_cores xilinx.com:user:axis_txc_generator:1.0]]]]
set test_bench_file ${ip_path}/example_designs/bfm_design/axis_txc_generator_v1_0_tb.v
set interface_address_vh_file ""

# Set IP Repository and Update IP Catalogue 
set repo_paths [get_property ip_repo_paths [current_fileset]] 
if { [lsearch -exact -nocase $repo_paths $ip_path ] == -1 } {
	set_property ip_repo_paths "$ip_path [get_property ip_repo_paths [current_fileset]]" [current_fileset]
	update_ip_catalog
}

set design_name ""
set all_bd {}
set all_bd_files [get_files *.bd -quiet]
foreach file $all_bd_files {
set file_name [string range $file [expr {[string last "/" $file] + 1}] end]
set bd_name [string range $file_name 0 [expr {[string last "." $file_name] -1}]]
lappend all_bd $bd_name
}

for { set i 1 } { 1 } { incr i } {
	set design_name "axis_txc_generator_v1_0_bfm_${i}"
	if { [lsearch -exact -nocase $all_bd $design_name ] == -1 } {
		break
	}
}

create_ipi_design interface_address_vh_file ${design_name}
validate_bd_design

set wrapper_file [make_wrapper -files [get_files ${design_name}.bd] -top -force]
import_files -force -norecurse $wrapper_file

set_property SOURCE_SET sources_1 [get_filesets sim_1]
import_files -fileset sim_1 -norecurse -force $test_bench_file
remove_files -quiet -fileset sim_1 axis_txc_generator_v1_0_tb_include.vh
import_files -fileset sim_1 -norecurse -force $interface_address_vh_file
set_property top axis_txc_generator_v1_0_tb [get_filesets sim_1]
set_property top_lib {} [get_filesets sim_1]
set_property top_file {} [get_filesets sim_1]
launch_xsim -simset sim_1 -mode behavioral
restart
run 1000 us
