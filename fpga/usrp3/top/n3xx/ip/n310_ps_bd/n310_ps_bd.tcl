
################################################################
# This is a generated script based on design: n310_ps_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source n310_ps_bd_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z100ffg900-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name n310_ps_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_iic:2.0\
xilinx.com:ip:axi_uartlite:2.0\
ettus.com:ip:axi_bitq:1.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_protocol_converter:2.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: dma
proc create_hier_cell_dma { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_dma() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_DMA_SG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_RX_DMA

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_TX_DMA

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_dma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dmac

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_dma


  # Create pins
  create_bd_pin -dir I bus_clk
  create_bd_pin -dir I bus_rstn
  create_bd_pin -dir I clk40
  create_bd_pin -dir I clk40_rstn
  create_bd_pin -dir O rx_irq
  create_bd_pin -dir O tx_irq

  # Create instance: axi_dma_eth_internal, and set properties
  set axi_dma_eth_internal [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_eth_internal ]
  set_property -dict [ list \
   CONFIG.c_enable_multi_channel {0} \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_burst_size {16} \
   CONFIG.c_num_mm2s_channels {1} \
   CONFIG.c_num_s2mm_channels {1} \
   CONFIG.c_s2mm_burst_size {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
 ] $axi_dma_eth_internal

  # Create instance: axi_protocol_convert_rx, and set properties
  set axi_protocol_convert_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_convert_rx ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.MI_PROTOCOL {AXI3} \
   CONFIG.READ_WRITE_MODE {WRITE_ONLY} \
   CONFIG.TRANSLATION_MODE {0} \
 ] $axi_protocol_convert_rx

  # Create instance: axi_protocol_convert_tx, and set properties
  set axi_protocol_convert_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_convert_tx ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.MI_PROTOCOL {AXI3} \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   CONFIG.TRANSLATION_MODE {0} \
 ] $axi_protocol_convert_tx

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins m_axis_dma] [get_bd_intf_pins axi_dma_eth_internal/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_eth_internal/M_AXI_MM2S] [get_bd_intf_pins axi_protocol_convert_tx/S_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_eth_internal/M_AXI_S2MM] [get_bd_intf_pins axi_protocol_convert_rx/S_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins M_AXI_DMA_SG] [get_bd_intf_pins axi_dma_eth_internal/M_AXI_SG]
  connect_bd_intf_net -intf_net axi_protocol_convert_0_M_AXI [get_bd_intf_pins M_AXI_TX_DMA] [get_bd_intf_pins axi_protocol_convert_tx/M_AXI]
  connect_bd_intf_net -intf_net axi_protocol_convert_1_M_AXI [get_bd_intf_pins M_AXI_RX_DMA] [get_bd_intf_pins axi_protocol_convert_rx/M_AXI]
  connect_bd_intf_net -intf_net s_axi_dmac_1 [get_bd_intf_pins s_axi_dmac] [get_bd_intf_pins axi_dma_eth_internal/S_AXI_LITE]
  connect_bd_intf_net -intf_net s_axis_dma_1 [get_bd_intf_pins s_axis_dma] [get_bd_intf_pins axi_dma_eth_internal/S_AXIS_S2MM]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins tx_irq] [get_bd_pins axi_dma_eth_internal/mm2s_introut]
  connect_bd_net -net axi_dma_0_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_eth_internal/mm2s_prmry_reset_out_n] [get_bd_pins axi_protocol_convert_tx/aresetn]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins rx_irq] [get_bd_pins axi_dma_eth_internal/s2mm_introut]
  connect_bd_net -net axi_dma_0_s2mm_prmry_reset_out_n [get_bd_pins axi_dma_eth_internal/s2mm_prmry_reset_out_n] [get_bd_pins axi_protocol_convert_rx/aresetn]
  connect_bd_net -net bus_clk_1 [get_bd_pins bus_clk] [get_bd_pins axi_dma_eth_internal/m_axi_mm2s_aclk] [get_bd_pins axi_dma_eth_internal/m_axi_s2mm_aclk] [get_bd_pins axi_dma_eth_internal/m_axi_sg_aclk] [get_bd_pins axi_protocol_convert_rx/aclk] [get_bd_pins axi_protocol_convert_tx/aclk]
  connect_bd_net -net clk40_1 [get_bd_pins clk40] [get_bd_pins axi_dma_eth_internal/s_axi_lite_aclk]
  connect_bd_net -net clk40_rstn_1 [get_bd_pins clk40_rstn] [get_bd_pins axi_dma_eth_internal/axi_resetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set GPIO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0 ]

  set M_AXI_ETH_DMA0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_ETH_DMA0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_ETH_DMA0

  set M_AXI_ETH_DMA1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_ETH_DMA1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_ETH_DMA1

  set M_AXI_JESD0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_JESD0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_JESD0

  set M_AXI_JESD1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_JESD1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_JESD1

  set M_AXI_NET0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_NET0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_NET0

  set M_AXI_NET1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_NET1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_NET1

  set M_AXI_NET2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_NET2 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_NET2

  set M_AXI_WR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_WR ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {62500000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_WR

  set M_AXI_XBAR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_XBAR ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M_AXI_XBAR

  set S_AXI_GP0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GP0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI_GP0

  set S_AXI_GP1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GP1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {5} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI_GP1

  set S_AXI_HP0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_HP0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI_HP0

  set S_AXI_HP1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_HP1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {5} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI_HP1

  set USBIND_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:usbctrl_rtl:1.0 USBIND_0 ]

  set WR_UART [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 WR_UART ]

  set m_axi_eth_internal [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_eth_internal ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {31} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {40000000} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $m_axi_eth_internal

  set m_axis_dma [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_dma ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $m_axis_dma

  set s_axis_dma [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_dma ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.TDEST_WIDTH {4} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $s_axis_dma


  # Create ports
  set DDR_VRN [ create_bd_port -dir IO DDR_VRN ]
  set DDR_VRP [ create_bd_port -dir IO DDR_VRP ]
  set FCLK_CLK0 [ create_bd_port -dir O -type clk FCLK_CLK0 ]
  set FCLK_CLK1 [ create_bd_port -dir O -type clk FCLK_CLK1 ]
  set FCLK_CLK2 [ create_bd_port -dir O -type clk FCLK_CLK2 ]
  set FCLK_CLK3 [ create_bd_port -dir O -type clk FCLK_CLK3 ]
  set FCLK_RESET0_N [ create_bd_port -dir O -type rst FCLK_RESET0_N ]
  set FCLK_RESET1_N [ create_bd_port -dir O -type rst FCLK_RESET1_N ]
  set FCLK_RESET2_N [ create_bd_port -dir O -type rst FCLK_RESET2_N ]
  set FCLK_RESET3_N [ create_bd_port -dir O -type rst FCLK_RESET3_N ]
  set IRQ_F2P [ create_bd_port -dir I -from 15 -to 0 -type intr IRQ_F2P ]
  set_property -dict [ list \
   CONFIG.PortWidth {16} \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] $IRQ_F2P
  set JTAG0_TCK [ create_bd_port -dir IO JTAG0_TCK ]
  set JTAG0_TDI [ create_bd_port -dir IO JTAG0_TDI ]
  set JTAG0_TDO [ create_bd_port -dir I JTAG0_TDO ]
  set JTAG0_TMS [ create_bd_port -dir IO JTAG0_TMS ]
  set JTAG1_TCK [ create_bd_port -dir IO JTAG1_TCK ]
  set JTAG1_TDI [ create_bd_port -dir IO JTAG1_TDI ]
  set JTAG1_TDO [ create_bd_port -dir I JTAG1_TDO ]
  set JTAG1_TMS [ create_bd_port -dir IO JTAG1_TMS ]
  set MIO [ create_bd_port -dir IO -from 53 -to 0 MIO ]
  set M_AXI_WR_CLK [ create_bd_port -dir I -type clk M_AXI_WR_CLK ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M_AXI_WR} \
   CONFIG.ASSOCIATED_RESET {M_AXI_WR_RSTn} \
   CONFIG.FREQ_HZ {62500000} \
 ] $M_AXI_WR_CLK
  set M_AXI_WR_RSTn [ create_bd_port -dir I -type rst M_AXI_WR_RSTn ]
  set PS_CLK [ create_bd_port -dir IO PS_CLK ]
  set PS_PORB [ create_bd_port -dir IO PS_PORB ]
  set PS_SRSTB [ create_bd_port -dir IO PS_SRSTB ]
  set SPI0_MISO_I [ create_bd_port -dir I SPI0_MISO_I ]
  set SPI0_MISO_O [ create_bd_port -dir O SPI0_MISO_O ]
  set SPI0_MISO_T [ create_bd_port -dir O SPI0_MISO_T ]
  set SPI0_MOSI_I [ create_bd_port -dir I SPI0_MOSI_I ]
  set SPI0_MOSI_O [ create_bd_port -dir O SPI0_MOSI_O ]
  set SPI0_MOSI_T [ create_bd_port -dir O SPI0_MOSI_T ]
  set SPI0_SCLK_I [ create_bd_port -dir I SPI0_SCLK_I ]
  set SPI0_SCLK_O [ create_bd_port -dir O SPI0_SCLK_O ]
  set SPI0_SCLK_T [ create_bd_port -dir O SPI0_SCLK_T ]
  set SPI0_SS1_O [ create_bd_port -dir O SPI0_SS1_O ]
  set SPI0_SS2_O [ create_bd_port -dir O SPI0_SS2_O ]
  set SPI0_SS_I [ create_bd_port -dir I SPI0_SS_I ]
  set SPI0_SS_O [ create_bd_port -dir O SPI0_SS_O ]
  set SPI0_SS_T [ create_bd_port -dir O SPI0_SS_T ]
  set SPI1_MISO_I [ create_bd_port -dir I SPI1_MISO_I ]
  set SPI1_MISO_O [ create_bd_port -dir O SPI1_MISO_O ]
  set SPI1_MISO_T [ create_bd_port -dir O SPI1_MISO_T ]
  set SPI1_MOSI_I [ create_bd_port -dir I SPI1_MOSI_I ]
  set SPI1_MOSI_O [ create_bd_port -dir O SPI1_MOSI_O ]
  set SPI1_MOSI_T [ create_bd_port -dir O SPI1_MOSI_T ]
  set SPI1_SCLK_I [ create_bd_port -dir I SPI1_SCLK_I ]
  set SPI1_SCLK_O [ create_bd_port -dir O SPI1_SCLK_O ]
  set SPI1_SCLK_T [ create_bd_port -dir O SPI1_SCLK_T ]
  set SPI1_SS1_O [ create_bd_port -dir O SPI1_SS1_O ]
  set SPI1_SS2_O [ create_bd_port -dir O SPI1_SS2_O ]
  set SPI1_SS_I [ create_bd_port -dir I SPI1_SS_I ]
  set SPI1_SS_O [ create_bd_port -dir O SPI1_SS_O ]
  set SPI1_SS_T [ create_bd_port -dir O SPI1_SS_T ]
  set S_AXI_GP0_ACLK [ create_bd_port -dir I -type clk S_AXI_GP0_ACLK ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {S_AXI_GP0_ARESETN} \
   CONFIG.FREQ_HZ {40000000} \
 ] $S_AXI_GP0_ACLK
  set S_AXI_GP0_ARESETN [ create_bd_port -dir I -type rst S_AXI_GP0_ARESETN ]
  set S_AXI_GP1_ACLK [ create_bd_port -dir I -type clk S_AXI_GP1_ACLK ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {S_AXI_GP1_ARESETN} \
   CONFIG.FREQ_HZ {40000000} \
 ] $S_AXI_GP1_ACLK
  set S_AXI_GP1_ARESETN [ create_bd_port -dir I -type rst S_AXI_GP1_ARESETN ]
  set S_AXI_HP0_ACLK [ create_bd_port -dir I -type clk S_AXI_HP0_ACLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {40000000} \
 ] $S_AXI_HP0_ACLK
  set S_AXI_HP0_ARESETN [ create_bd_port -dir I -type rst S_AXI_HP0_ARESETN ]
  set S_AXI_HP1_ACLK [ create_bd_port -dir I -type clk S_AXI_HP1_ACLK ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {S_AXI_HP1_ARESETN} \
   CONFIG.FREQ_HZ {40000000} \
 ] $S_AXI_HP1_ACLK
  set S_AXI_HP1_ARESETN [ create_bd_port -dir I -type rst S_AXI_HP1_ARESETN ]
  set bus_clk [ create_bd_port -dir I -type clk bus_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_dma:s_axis_dma} \
   CONFIG.ASSOCIATED_RESET {bus_rstn} \
   CONFIG.FREQ_HZ {200000000} \
 ] $bus_clk
  set bus_rstn [ create_bd_port -dir I -type rst bus_rstn ]
  set clk40 [ create_bd_port -dir I -type clk clk40 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M_AXI_NET0:M_AXI_NET1:M_AXI_XBAR:M_AXI_JESD0:M_AXI_JESD1:M_AXI_ETH_DMA0:M_AXI_ETH_DMA1:M_AXI_NET2} \
   CONFIG.ASSOCIATED_RESET {clk40_rstn} \
   CONFIG.FREQ_HZ {40000000} \
 ] $clk40
  set clk40_rstn [ create_bd_port -dir I -type rst clk40_rstn ]
  set qsfp_scl_i [ create_bd_port -dir I qsfp_scl_i ]
  set qsfp_scl_o [ create_bd_port -dir O qsfp_scl_o ]
  set qsfp_scl_t [ create_bd_port -dir O qsfp_scl_t ]
  set qsfp_sda_i [ create_bd_port -dir I qsfp_sda_i ]
  set qsfp_sda_o [ create_bd_port -dir O qsfp_sda_o ]
  set qsfp_sda_t [ create_bd_port -dir O qsfp_sda_t ]

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.NUM_MI {15} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_hp0, and set properties
  set axi_interconnect_hp0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_hp0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {3} \
 ] $axi_interconnect_hp0

  # Create instance: axi_interconnect_hp1, and set properties
  set axi_interconnect_hp1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_hp1 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_hp1

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_0

  # Create instance: dma
  create_hier_cell_dma [current_bd_instance .] dma

  # Create instance: jtag_0, and set properties
  set jtag_0 [ create_bd_cell -type ip -vlnv ettus.com:ip:axi_bitq:1.0 jtag_0 ]

  # Create instance: jtag_1, and set properties
  set jtag_1 [ create_bd_cell -type ip -vlnv ettus.com:ip:axi_bitq:1.0 jtag_1 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {800.000000} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {40.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {166.666672} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {166.666672} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {800} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {48} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {40000000} \
   CONFIG.PCW_CLK2_FREQ {166666672} \
   CONFIG.PCW_CLK3_FREQ {200000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1600.000} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {EMIO} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {1} \
   CONFIG.PCW_ENET0_RESET_IO {MIO 6} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_EN_CLK3_PORT {1} \
   CONFIG.PCW_EN_EMIO_GPIO {1} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {1} \
   CONFIG.PCW_EN_EMIO_SPI1 {1} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_PJTAG {1} \
   CONFIG.PCW_EN_RST1_PORT {1} \
   CONFIG.PCW_EN_RST2_PORT {1} \
   CONFIG.PCW_EN_RST3_PORT {1} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SPI0 {1} \
   CONFIG.PCW_EN_SPI1 {1} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {5} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {3} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK3_BUF {TRUE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {40} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {166.6667} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {64} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_IO {MIO 3} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {133.333328} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {in} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {out} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {in} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {in} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {inout} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {out} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {inout} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {inout} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {inout} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {inout} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {inout} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {in} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#GPIO#GPIO#I2C Reset#GPIO#GPIO#ENET Reset#USB Reset#UART 1#UART 1#PJTAG#PJTAG#PJTAG#PJTAG#UART 0#UART 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#GPIO#GPIO#GPIO#GPIO#I2C 0#I2C 0#GPIO#GPIO} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#gpio[1]#gpio[2]#reset#gpio[4]#gpio[5]#reset#reset#tx#rx#tdi#tdo#tck#tms#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#gpio[46]#gpio[47]#gpio[48]#gpio[49]#scl#sda#gpio[52]#gpio[53]} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_PJTAG_PJTAG_IO {MIO 10 .. 13} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS0_IO {EMIO} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS1_IO {EMIO} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS2_IO {EMIO} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI0_SPI0_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS0_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS1_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS2_IO {EMIO} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI1_SPI1_IO {EMIO} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 8 .. 9} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.096} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.102} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.100} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.090} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.054} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.040} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.041} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.010} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {1} \
   CONFIG.PCW_USB0_RESET_IO {MIO 7} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_S_AXI_GP0 {0} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {1} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
   CONFIG.PCW_USE_S_AXI_HP3 {1} \
 ] $processing_system7_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.NUM_PORTS {9} \
 ] $xlconcat_0

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_2

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]
  connect_bd_intf_net -intf_net S_AXI_GP0_1 [get_bd_intf_ports S_AXI_GP0] [get_bd_intf_pins axi_interconnect_hp0/S01_AXI]
  connect_bd_intf_net -intf_net S_AXI_GP1_1 [get_bd_intf_ports S_AXI_GP1] [get_bd_intf_pins axi_interconnect_hp1/S01_AXI]
  connect_bd_intf_net -intf_net S_AXI_HP0_1 [get_bd_intf_ports S_AXI_HP0] [get_bd_intf_pins axi_interconnect_hp0/S00_AXI]
  connect_bd_intf_net -intf_net S_AXI_HP1_1 [get_bd_intf_ports S_AXI_HP1] [get_bd_intf_pins axi_interconnect_hp1/S00_AXI]
  connect_bd_intf_net -intf_net WR_UART [get_bd_intf_ports WR_UART] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_ports M_AXI_ETH_DMA0] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_ports M_AXI_NET0] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_ports M_AXI_ETH_DMA1] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_ports M_AXI_NET1] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_ports M_AXI_XBAR] [get_bd_intf_pins axi_interconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_ports M_AXI_JESD0] [get_bd_intf_pins axi_interconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_ports M_AXI_JESD1] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_ports M_AXI_NET2] [get_bd_intf_pins axi_interconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_ports m_axi_eth_internal] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins axi_interconnect_0/M10_AXI] [get_bd_intf_pins dma/s_axi_dmac]
  connect_bd_intf_net -intf_net axi_interconnect_0_M11_AXI [get_bd_intf_pins axi_interconnect_0/M11_AXI] [get_bd_intf_pins jtag_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M12_AXI [get_bd_intf_pins axi_interconnect_0/M12_AXI] [get_bd_intf_pins jtag_1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins axi_interconnect_0/M13_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M14_AXI [get_bd_intf_ports M_AXI_WR] [get_bd_intf_pins axi_interconnect_0/M14_AXI]
  connect_bd_intf_net -intf_net axi_protocol_converter_hp0_M_AXI [get_bd_intf_pins axi_interconnect_hp0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_protocol_converter_hp1_M_AXI [get_bd_intf_pins axi_interconnect_hp1/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP1]
  connect_bd_intf_net -intf_net dma_M_AXI_DMA_SG [get_bd_intf_pins axi_interconnect_hp0/S02_AXI] [get_bd_intf_pins dma/M_AXI_DMA_SG]
  connect_bd_intf_net -intf_net dma_M_AXI_RX_DMA [get_bd_intf_pins dma/M_AXI_RX_DMA] [get_bd_intf_pins processing_system7_0/S_AXI_HP2]
  connect_bd_intf_net -intf_net dma_M_AXI_TX_DMA [get_bd_intf_pins dma/M_AXI_TX_DMA] [get_bd_intf_pins processing_system7_0/S_AXI_HP3]
  connect_bd_intf_net -intf_net m_axis_dma_1 [get_bd_intf_ports m_axis_dma] [get_bd_intf_pins dma/m_axis_dma]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_GPIO_0 [get_bd_intf_ports GPIO_0] [get_bd_intf_pins processing_system7_0/GPIO_0]
  connect_bd_intf_net -intf_net processing_system7_0_USBIND_0 [get_bd_intf_ports USBIND_0] [get_bd_intf_pins processing_system7_0/USBIND_0]
  connect_bd_intf_net -intf_net s_axis_dma_1 [get_bd_intf_ports s_axis_dma] [get_bd_intf_pins dma/s_axis_dma]

  # Create port connections
  connect_bd_net -net IRQ_F2P_1 [get_bd_ports IRQ_F2P] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net JTAG0_TCK [get_bd_ports JTAG0_TCK] [get_bd_pins jtag_0/bit_clk]
  connect_bd_net -net JTAG0_TDI [get_bd_ports JTAG0_TDI] [get_bd_pins jtag_0/bit_out]
  connect_bd_net -net JTAG0_TDO [get_bd_ports JTAG0_TDO] [get_bd_pins jtag_0/bit_in]
  connect_bd_net -net JTAG0_TMS [get_bd_ports JTAG0_TMS] [get_bd_pins jtag_0/bit_stb]
  connect_bd_net -net JTAG1_TCK [get_bd_ports JTAG1_TCK] [get_bd_pins jtag_1/bit_clk]
  connect_bd_net -net JTAG1_TDI [get_bd_ports JTAG1_TDI] [get_bd_pins jtag_1/bit_out]
  connect_bd_net -net JTAG1_TDO [get_bd_ports JTAG1_TDO] [get_bd_pins jtag_1/bit_in]
  connect_bd_net -net JTAG1_TMS [get_bd_ports JTAG1_TMS] [get_bd_pins jtag_1/bit_stb]
  connect_bd_net -net M_AXI_WR_CLK [get_bd_ports M_AXI_WR_CLK] [get_bd_pins axi_interconnect_0/M14_ACLK]
  connect_bd_net -net M_AXI_WR_RSTn [get_bd_ports M_AXI_WR_RSTn] [get_bd_pins axi_interconnect_0/M14_ARESETN]
  connect_bd_net -net SPI0_MISO_I_1 [get_bd_ports SPI0_MISO_I] [get_bd_pins processing_system7_0/SPI0_MISO_I]
  connect_bd_net -net SPI0_MOSI_I_1 [get_bd_ports SPI0_MOSI_I] [get_bd_pins processing_system7_0/SPI0_MOSI_I]
  connect_bd_net -net SPI0_SCLK_I_1 [get_bd_ports SPI0_SCLK_I] [get_bd_pins processing_system7_0/SPI0_SCLK_I]
  connect_bd_net -net SPI0_SS_I_1 [get_bd_ports SPI0_SS_I] [get_bd_pins processing_system7_0/SPI0_SS_I]
  connect_bd_net -net SPI1_MISO_I_1 [get_bd_ports SPI1_MISO_I] [get_bd_pins processing_system7_0/SPI1_MISO_I]
  connect_bd_net -net SPI1_MOSI_I_1 [get_bd_ports SPI1_MOSI_I] [get_bd_pins processing_system7_0/SPI1_MOSI_I]
  connect_bd_net -net SPI1_SCLK_I_1 [get_bd_ports SPI1_SCLK_I] [get_bd_pins processing_system7_0/SPI1_SCLK_I]
  connect_bd_net -net SPI1_SS_I_1 [get_bd_ports SPI1_SS_I] [get_bd_pins processing_system7_0/SPI1_SS_I]
  connect_bd_net -net S_AXI_HP0_ACLK_1 [get_bd_ports S_AXI_HP0_ACLK] [get_bd_pins axi_interconnect_hp0/M00_ACLK] [get_bd_pins axi_interconnect_hp0/S00_ACLK] [get_bd_pins axi_interconnect_hp0/S01_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK]
  connect_bd_net -net S_AXI_HP0_ARESETN_1 [get_bd_ports S_AXI_HP0_ARESETN] [get_bd_pins axi_interconnect_hp0/M00_ARESETN] [get_bd_pins axi_interconnect_hp0/S00_ARESETN] [get_bd_pins axi_interconnect_hp0/S01_ARESETN]
  connect_bd_net -net S_AXI_HP1_ACLK_1 [get_bd_ports S_AXI_HP1_ACLK] [get_bd_pins axi_interconnect_hp1/ACLK] [get_bd_pins axi_interconnect_hp1/M00_ACLK] [get_bd_pins axi_interconnect_hp1/S00_ACLK] [get_bd_pins axi_interconnect_hp1/S01_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK]
  connect_bd_net -net S_AXI_HP1_ARESETN_1 [get_bd_ports S_AXI_HP1_ARESETN] [get_bd_pins axi_interconnect_hp1/ARESETN] [get_bd_pins axi_interconnect_hp1/M00_ARESETN] [get_bd_pins axi_interconnect_hp1/S00_ARESETN] [get_bd_pins axi_interconnect_hp1/S01_ARESETN]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_uartlite_0_interrupt [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net bus_clk [get_bd_ports bus_clk] [get_bd_pins axi_interconnect_hp0/ACLK] [get_bd_pins axi_interconnect_hp0/S02_ACLK] [get_bd_pins dma/bus_clk] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP3_ACLK]
  connect_bd_net -net bus_rstn [get_bd_ports bus_rstn] [get_bd_pins axi_interconnect_hp0/ARESETN] [get_bd_pins axi_interconnect_hp0/S02_ARESETN] [get_bd_pins dma/bus_rstn]
  connect_bd_net -net clk40 [get_bd_ports clk40] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M10_ACLK] [get_bd_pins axi_interconnect_0/M11_ACLK] [get_bd_pins axi_interconnect_0/M12_ACLK] [get_bd_pins axi_interconnect_0/M13_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins dma/clk40] [get_bd_pins jtag_0/S_AXI_ACLK] [get_bd_pins jtag_1/S_AXI_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
  connect_bd_net -net clk40_rstn [get_bd_ports clk40_rstn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M10_ARESETN] [get_bd_pins axi_interconnect_0/M11_ARESETN] [get_bd_pins axi_interconnect_0/M12_ARESETN] [get_bd_pins axi_interconnect_0/M13_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins dma/clk40_rstn] [get_bd_pins jtag_0/S_AXI_ARESETN] [get_bd_pins jtag_1/S_AXI_ARESETN]
  connect_bd_net -net ddr_vrn [get_bd_ports DDR_VRN] [get_bd_pins processing_system7_0/DDR_VRN]
  connect_bd_net -net ddr_vrp [get_bd_ports DDR_VRP] [get_bd_pins processing_system7_0/DDR_VRP]
  connect_bd_net -net dma_tx_irq [get_bd_pins dma/tx_irq] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net mio [get_bd_ports MIO] [get_bd_pins processing_system7_0/MIO]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_ports FCLK_CLK0] [get_bd_pins processing_system7_0/FCLK_CLK0]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_ports FCLK_CLK1] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_ports FCLK_CLK2] [get_bd_pins processing_system7_0/FCLK_CLK2]
  connect_bd_net -net processing_system7_0_FCLK_CLK3 [get_bd_ports FCLK_CLK3] [get_bd_pins processing_system7_0/FCLK_CLK3]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_ports FCLK_RESET0_N] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net processing_system7_0_FCLK_RESET1_N [get_bd_ports FCLK_RESET1_N] [get_bd_pins processing_system7_0/FCLK_RESET1_N]
  connect_bd_net -net processing_system7_0_FCLK_RESET2_N [get_bd_ports FCLK_RESET2_N] [get_bd_pins processing_system7_0/FCLK_RESET2_N]
  connect_bd_net -net processing_system7_0_FCLK_RESET3_N [get_bd_ports FCLK_RESET3_N] [get_bd_pins processing_system7_0/FCLK_RESET3_N]
  connect_bd_net -net processing_system7_0_SPI0_MISO_O [get_bd_ports SPI0_MISO_O] [get_bd_pins processing_system7_0/SPI0_MISO_O]
  connect_bd_net -net processing_system7_0_SPI0_MISO_T [get_bd_ports SPI0_MISO_T] [get_bd_pins processing_system7_0/SPI0_MISO_T]
  connect_bd_net -net processing_system7_0_SPI0_MOSI_O [get_bd_ports SPI0_MOSI_O] [get_bd_pins processing_system7_0/SPI0_MOSI_O]
  connect_bd_net -net processing_system7_0_SPI0_MOSI_T [get_bd_ports SPI0_MOSI_T] [get_bd_pins processing_system7_0/SPI0_MOSI_T]
  connect_bd_net -net processing_system7_0_SPI0_SCLK_O [get_bd_ports SPI0_SCLK_O] [get_bd_pins processing_system7_0/SPI0_SCLK_O]
  connect_bd_net -net processing_system7_0_SPI0_SCLK_T [get_bd_ports SPI0_SCLK_T] [get_bd_pins processing_system7_0/SPI0_SCLK_T]
  connect_bd_net -net processing_system7_0_SPI0_SS1_O [get_bd_ports SPI0_SS1_O] [get_bd_pins processing_system7_0/SPI0_SS1_O]
  connect_bd_net -net processing_system7_0_SPI0_SS2_O [get_bd_ports SPI0_SS2_O] [get_bd_pins processing_system7_0/SPI0_SS2_O]
  connect_bd_net -net processing_system7_0_SPI0_SS_O [get_bd_ports SPI0_SS_O] [get_bd_pins processing_system7_0/SPI0_SS_O]
  connect_bd_net -net processing_system7_0_SPI0_SS_T [get_bd_ports SPI0_SS_T] [get_bd_pins processing_system7_0/SPI0_SS_T]
  connect_bd_net -net processing_system7_0_SPI1_MISO_O [get_bd_ports SPI1_MISO_O] [get_bd_pins processing_system7_0/SPI1_MISO_O]
  connect_bd_net -net processing_system7_0_SPI1_MISO_T [get_bd_ports SPI1_MISO_T] [get_bd_pins processing_system7_0/SPI1_MISO_T]
  connect_bd_net -net processing_system7_0_SPI1_MOSI_O [get_bd_ports SPI1_MOSI_O] [get_bd_pins processing_system7_0/SPI1_MOSI_O]
  connect_bd_net -net processing_system7_0_SPI1_MOSI_T [get_bd_ports SPI1_MOSI_T] [get_bd_pins processing_system7_0/SPI1_MOSI_T]
  connect_bd_net -net processing_system7_0_SPI1_SCLK_O [get_bd_ports SPI1_SCLK_O] [get_bd_pins processing_system7_0/SPI1_SCLK_O]
  connect_bd_net -net processing_system7_0_SPI1_SCLK_T [get_bd_ports SPI1_SCLK_T] [get_bd_pins processing_system7_0/SPI1_SCLK_T]
  connect_bd_net -net processing_system7_0_SPI1_SS1_O [get_bd_ports SPI1_SS1_O] [get_bd_pins processing_system7_0/SPI1_SS1_O]
  connect_bd_net -net processing_system7_0_SPI1_SS2_O [get_bd_ports SPI1_SS2_O] [get_bd_pins processing_system7_0/SPI1_SS2_O]
  connect_bd_net -net processing_system7_0_SPI1_SS_O [get_bd_ports SPI1_SS_O] [get_bd_pins processing_system7_0/SPI1_SS_O]
  connect_bd_net -net processing_system7_0_SPI1_SS_T [get_bd_ports SPI1_SS_T] [get_bd_pins processing_system7_0/SPI1_SS_T]
  connect_bd_net -net ps_clk [get_bd_ports PS_CLK] [get_bd_pins processing_system7_0/PS_CLK]
  connect_bd_net -net ps_porb [get_bd_ports PS_PORB] [get_bd_pins processing_system7_0/PS_PORB]
  connect_bd_net -net ps_srstb [get_bd_ports PS_SRSTB] [get_bd_pins processing_system7_0/PS_SRSTB]
  connect_bd_net -net qsfp_scl_i [get_bd_ports qsfp_scl_i] [get_bd_pins axi_iic_0/scl_i]
  connect_bd_net -net qsfp_scl_o [get_bd_ports qsfp_scl_o] [get_bd_pins axi_iic_0/scl_o]
  connect_bd_net -net qsfp_scl_t [get_bd_ports qsfp_scl_t] [get_bd_pins axi_iic_0/scl_t]
  connect_bd_net -net qsfp_sda_i [get_bd_ports qsfp_sda_i] [get_bd_pins axi_iic_0/sda_i]
  connect_bd_net -net qsfp_sda_o [get_bd_ports qsfp_sda_o] [get_bd_pins axi_iic_0/sda_o]
  connect_bd_net -net qsfp_sda_t [get_bd_ports qsfp_sda_t] [get_bd_pins axi_iic_0/sda_t]
  connect_bd_net -net rx_dma_irq [get_bd_pins dma/rx_irq] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_2/Dout]

  # Create address segments
  create_bd_addr_seg -range 0x00004000 -offset 0x40000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_ETH_DMA0/Reg] SEG_M_AXI_ETH_DMA0_Reg
  create_bd_addr_seg -range 0x00004000 -offset 0x40008000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_ETH_DMA1/Reg] SEG_M_AXI_ETH_DMA1_Reg
  create_bd_addr_seg -range 0x00004000 -offset 0x40014000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_JESD0/Reg] SEG_M_AXI_JESD0_Reg
  create_bd_addr_seg -range 0x00004000 -offset 0x40018000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_JESD1/Reg] SEG_M_AXI_JESD1_Reg
  create_bd_addr_seg -range 0x00004000 -offset 0x40004000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_NET0/Reg] SEG_M_AXI_NET0_Reg
  create_bd_addr_seg -range 0x00004000 -offset 0x4000C000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_NET1/Reg] SEG_M_AXI_NET1_Reg
  create_bd_addr_seg -range 0x00020000 -offset 0x40020000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_NET2/Reg] SEG_M_AXI_NET2_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0x43D40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_WR/Reg] SEG_M_AXI_WR_Reg
  create_bd_addr_seg -range 0x00004000 -offset 0x40010000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs M_AXI_XBAR/Reg] SEG_M_AXI_XBAR_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x42C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_WR_UART_Reg
  create_bd_addr_seg -range 0x00004000 -offset 0x40040000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs dma/axi_dma_eth_internal/S_AXI_LITE/Reg] SEG_axi_dma_eth_internal_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43D80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x42100000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs jtag_0/S_AXI/reg0] SEG_jtag_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x42200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs jtag_1/S_AXI/reg0] SEG_jtag_1_reg0
  create_bd_addr_seg -range 0x00004000 -offset 0x40050000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs m_axi_eth_internal/Reg] SEG_m_axi_eth_internal_Reg
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces dma/axi_dma_eth_internal/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces dma/axi_dma_eth_internal/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces dma/axi_dma_eth_internal/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_0_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_GP0] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_GP1] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_GP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_HP0] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_HP1] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

