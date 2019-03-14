# Legal Notice: (C)2019 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	ethernet_pt_nios2_gen2_0_cpu 	ethernet_pt_nios2_gen2_0_cpu:*
set 	ethernet_pt_nios2_gen2_0_cpu_oci 	ethernet_pt_nios2_gen2_0_cpu_nios2_oci:the_ethernet_pt_nios2_gen2_0_cpu_nios2_oci
set 	ethernet_pt_nios2_gen2_0_cpu_oci_break 	ethernet_pt_nios2_gen2_0_cpu_nios2_oci_break:the_ethernet_pt_nios2_gen2_0_cpu_nios2_oci_break
set 	ethernet_pt_nios2_gen2_0_cpu_ocimem 	ethernet_pt_nios2_gen2_0_cpu_nios2_ocimem:the_ethernet_pt_nios2_gen2_0_cpu_nios2_ocimem
set 	ethernet_pt_nios2_gen2_0_cpu_oci_debug 	ethernet_pt_nios2_gen2_0_cpu_nios2_oci_debug:the_ethernet_pt_nios2_gen2_0_cpu_nios2_oci_debug
set 	ethernet_pt_nios2_gen2_0_cpu_wrapper 	ethernet_pt_nios2_gen2_0_cpu_debug_slave_wrapper:the_ethernet_pt_nios2_gen2_0_cpu_debug_slave_wrapper
set 	ethernet_pt_nios2_gen2_0_cpu_jtag_tck 	ethernet_pt_nios2_gen2_0_cpu_debug_slave_tck:the_ethernet_pt_nios2_gen2_0_cpu_debug_slave_tck
set 	ethernet_pt_nios2_gen2_0_cpu_jtag_sysclk 	ethernet_pt_nios2_gen2_0_cpu_debug_slave_sysclk:the_ethernet_pt_nios2_gen2_0_cpu_debug_slave_sysclk
set 	ethernet_pt_nios2_gen2_0_cpu_oci_path 	 [format "%s|%s" $ethernet_pt_nios2_gen2_0_cpu $ethernet_pt_nios2_gen2_0_cpu_oci]
set 	ethernet_pt_nios2_gen2_0_cpu_oci_break_path 	 [format "%s|%s" $ethernet_pt_nios2_gen2_0_cpu_oci_path $ethernet_pt_nios2_gen2_0_cpu_oci_break]
set 	ethernet_pt_nios2_gen2_0_cpu_ocimem_path 	 [format "%s|%s" $ethernet_pt_nios2_gen2_0_cpu_oci_path $ethernet_pt_nios2_gen2_0_cpu_ocimem]
set 	ethernet_pt_nios2_gen2_0_cpu_oci_debug_path 	 [format "%s|%s" $ethernet_pt_nios2_gen2_0_cpu_oci_path $ethernet_pt_nios2_gen2_0_cpu_oci_debug]
set 	ethernet_pt_nios2_gen2_0_cpu_jtag_tck_path 	 [format "%s|%s|%s" $ethernet_pt_nios2_gen2_0_cpu_oci_path $ethernet_pt_nios2_gen2_0_cpu_wrapper $ethernet_pt_nios2_gen2_0_cpu_jtag_tck]
set 	ethernet_pt_nios2_gen2_0_cpu_jtag_sysclk_path 	 [format "%s|%s|%s" $ethernet_pt_nios2_gen2_0_cpu_oci_path $ethernet_pt_nios2_gen2_0_cpu_wrapper $ethernet_pt_nios2_gen2_0_cpu_jtag_sysclk]
set 	ethernet_pt_nios2_gen2_0_cpu_jtag_sr 	 [format "%s|*sr" $ethernet_pt_nios2_gen2_0_cpu_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_oci_break_path|break_readreg*] -to [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_oci_debug_path|*resetlatch]     -to [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_jtag_sr[33]]
set_false_path -from [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_oci_debug_path|monitor_ready]  -to [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_jtag_sr[0]]
set_false_path -from [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_oci_debug_path|monitor_error]  -to [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_jtag_sr[34]]
set_false_path -from [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_ocimem_path|*MonDReg*] -to [get_keepers *$ethernet_pt_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from *$ethernet_pt_nios2_gen2_0_cpu_jtag_sr*    -to *$ethernet_pt_nios2_gen2_0_cpu_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$ethernet_pt_nios2_gen2_0_cpu_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$ethernet_pt_nios2_gen2_0_cpu_oci_debug_path|monitor_go
