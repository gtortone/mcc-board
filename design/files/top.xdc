#set_property IODELAY_GROUP temac_iodelay_group0 [get_cells system_i/rj45/axi_ethernet_0/U0/mac/U0/tri_mode_ethernet_mac_idelayctrl_common_i]
#set_property IODELAY_GROUP temac_iodelay_group1 [get_cells system_i/rj45/axi_ethernet_1/U0/mac/U0/tri_mode_ethernet_mac_idelayctrl_common_i]
#set_property IODELAY_GROUP temac_iodelay_group2 [get_cells system_i/rj45/axi_ethernet_2/U0/mac/U0/tri_mode_ethernet_mac_idelayctrl_common_i]
#set_property IODELAY_GROUP temac_iodelay_group3 [get_cells system_i/rj45/axi_ethernet_3/U0/mac/U0/tri_mode_ethernet_mac_idelayctrl_common_i]
#set_property IODELAY_GROUP temac_iodelay_group4 [get_cells system_i/rj45/axi_ethernet_4/U0/mac/U0/tri_mode_ethernet_mac_idelayctrl_common_i]
#set_property IODELAY_GROUP temac_iodelay_group5 [get_cells system_i/rj45/axi_ethernet_5/U0/mac/U0/tri_mode_ethernet_mac_idelayctrl_common_i]
#set_property IODELAY_GROUP temac_iodelay_group6 [get_cells system_i/rj45/axi_ethernet_6/U0/mac/U0/tri_mode_ethernet_mac_idelayctrl_common_i]
#set_property IODELAY_GROUP temac_iodelay_group7 [get_cells system_i/rj45/axi_ethernet_7/U0/mac/U0/tri_mode_ethernet_mac_idelayctrl_common_i]

#125MHz main system clock from PLL
#create_clock -period 8.000 -name CLK_SYS_clk -waveform {0.000 4.000} [get_ports CLK_SYS_clk_n]

#125MHz other gtx transceivers ref clocks
create_clock -period 8.000 -name CLK_MGT_clk -waveform {0.000 4.000} [get_ports CLK_MGT_clk_n]

# FPGA clocks

#set_property -dict {PACKAGE_PIN AC7 IOSTANDARD LVCMOS18} [get_ports CLK_SE]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports CLK_SYS_clk_p]
set_property -dict {PACKAGE_PIN V6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports CLK_SYS_clk_n]
set_property -dict {PACKAGE_PIN Y2 IOSTANDARD LVDS} [get_ports CLK_REC_p]
set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVDS} [get_ports CLK_REC_n]
#set_property -dict {PACKAGE_PIN AH6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports CLK_SAS_p]
#set_property -dict {PACKAGE_PIN AJ6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports CLK_SAS_n]

set_property PACKAGE_PIN L8 [get_ports CLK_MGT_clk_p]
set_property PACKAGE_PIN L7 [get_ports CLK_MGT_clk_n]
#set_property PACKAGE_PIN J8 [get_ports CLK_GTH_1_clk_p]
#set_property PACKAGE_PIN J7 [get_ports CLK_GTH_1_clk_n]

# eth 0
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS18} [get_ports {rgmii_0_td[0]}]
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS18} [get_ports {rgmii_0_td[1]}]
set_property -dict {PACKAGE_PIN V8 	IOSTANDARD LVCMOS18} [get_ports {rgmii_0_td[2]}]
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS18} [get_ports {rgmii_0_td[3]}]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS18} [get_ports rgmii_0_txc]
set_property -dict {PACKAGE_PIN Y8 	IOSTANDARD LVCMOS18} [get_ports rgmii_0_tx_ctl]
set_property -dict {PACKAGE_PIN V9 	IOSTANDARD LVCMOS18} [get_ports {rgmii_0_rd[0]}]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS18} [get_ports {rgmii_0_rd[1]}]
set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS18} [get_ports {rgmii_0_rd[2]}]
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS18} [get_ports {rgmii_0_rd[3]}]
set_property -dict {PACKAGE_PIN U8 	IOSTANDARD LVCMOS18} [get_ports rgmii_0_rxc]
set_property -dict {PACKAGE_PIN U9 	IOSTANDARD LVCMOS18} [get_ports rgmii_0_rx_ctl]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS18} [get_ports mdio_0_mdc]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS18} [get_ports mdio_0_mdio_io]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS18} [get_ports {phy_rst_n_0[0]}]

# eth 1
set_property -dict {PACKAGE_PIN N12 IOSTANDARD LVCMOS18} [get_ports {rgmii_1_td[0]}]
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS18} [get_ports {rgmii_1_td[1]}]
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS18} [get_ports {rgmii_1_td[2]}]
set_property -dict {PACKAGE_PIN K10 IOSTANDARD LVCMOS18} [get_ports {rgmii_1_td[3]}]
set_property -dict {PACKAGE_PIN L11 IOSTANDARD LVCMOS18} [get_ports rgmii_1_txc]
set_property -dict {PACKAGE_PIN L10 IOSTANDARD LVCMOS18} [get_ports rgmii_1_tx_ctl]
set_property -dict {PACKAGE_PIN P11 IOSTANDARD LVCMOS18} [get_ports {rgmii_1_rd[0]}]
set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVCMOS18} [get_ports {rgmii_1_rd[1]}]
set_property -dict {PACKAGE_PIN N10 IOSTANDARD LVCMOS18} [get_ports {rgmii_1_rd[2]}]
set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVCMOS18} [get_ports {rgmii_1_rd[3]}]
set_property -dict {PACKAGE_PIN Y9  IOSTANDARD LVCMOS18} [get_ports rgmii_1_rxc]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS18} [get_ports rgmii_1_rx_ctl]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS18} [get_ports mdio_1_mdc]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS18} [get_ports mdio_1_mdio_io]
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS18} [get_ports {phy_rst_n_1[0]}]

# eth 2
set_property -dict {PACKAGE_PIN AD6 IOSTANDARD LVCMOS18} [get_ports {rgmii_2_td[0]}]
set_property -dict {PACKAGE_PIN AB3 IOSTANDARD LVCMOS18} [get_ports {rgmii_2_td[1]}]
set_property -dict {PACKAGE_PIN AD1 IOSTANDARD LVCMOS18} [get_ports {rgmii_2_td[2]}]
set_property -dict {PACKAGE_PIN AC2 IOSTANDARD LVCMOS18} [get_ports {rgmii_2_td[3]}]
set_property -dict {PACKAGE_PIN AC1 IOSTANDARD LVCMOS18} [get_ports rgmii_2_txc]
set_property -dict {PACKAGE_PIN AD2 IOSTANDARD LVCMOS18} [get_ports rgmii_2_tx_ctl]
set_property -dict {PACKAGE_PIN AA3 IOSTANDARD LVCMOS18} [get_ports {rgmii_2_rd[0]}]
set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS18} [get_ports {rgmii_2_rd[1]}]
set_property -dict {PACKAGE_PIN AA1 IOSTANDARD LVCMOS18} [get_ports {rgmii_2_rd[2]}]
set_property -dict {PACKAGE_PIN AC3 IOSTANDARD LVCMOS18} [get_ports {rgmii_2_rd[3]}]
set_property -dict {PACKAGE_PIN AC6 IOSTANDARD LVCMOS18} [get_ports rgmii_2_rxc]
set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVCMOS18} [get_ports rgmii_2_rx_ctl]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS18} [get_ports mdio_2_mdc]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS18} [get_ports mdio_2_mdio_io]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS18} [get_ports {phy_rst_n_2[0]}]

# eth 3
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS18} [get_ports {rgmii_3_td[0]}]
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS18} [get_ports {rgmii_3_td[1]}]
set_property -dict {PACKAGE_PIN AE5 IOSTANDARD LVCMOS18} [get_ports {rgmii_3_td[2]}]
set_property -dict {PACKAGE_PIN AD5 IOSTANDARD LVCMOS18} [get_ports {rgmii_3_td[3]}]
set_property -dict {PACKAGE_PIN AE4 IOSTANDARD LVCMOS18} [get_ports rgmii_3_txc]
set_property -dict {PACKAGE_PIN AD4 IOSTANDARD LVCMOS18} [get_ports rgmii_3_tx_ctl]
set_property -dict {PACKAGE_PIN AE2 IOSTANDARD LVCMOS18} [get_ports {rgmii_3_rd[0]}]
set_property -dict {PACKAGE_PIN AE3 IOSTANDARD LVCMOS18} [get_ports {rgmii_3_rd[1]}]
set_property -dict {PACKAGE_PIN AA5 IOSTANDARD LVCMOS18} [get_ports {rgmii_3_rd[2]}]
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS18} [get_ports {rgmii_3_rd[3]}]
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS18} [get_ports rgmii_3_rxc]
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS18} [get_ports rgmii_3_rx_ctl]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS18} [get_ports mdio_3_mdc]
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVCMOS18} [get_ports mdio_3_mdio_io]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS18} [get_ports {phy_rst_n_3[0]}]

# eth 4
set_property -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS18} [get_ports {rgmii_4_td[0]}]
set_property -dict {PACKAGE_PIN AA7  IOSTANDARD LVCMOS18} [get_ports {rgmii_4_td[1]}]
set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS18} [get_ports {rgmii_4_td[2]}]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports {rgmii_4_td[3]}]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports rgmii_4_txc]
set_property -dict {PACKAGE_PIN AC8  IOSTANDARD LVCMOS18} [get_ports rgmii_4_tx_ctl]
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports {rgmii_4_rd[0]}]
set_property -dict {PACKAGE_PIN AE9  IOSTANDARD LVCMOS18} [get_ports {rgmii_4_rd[1]}]
set_property -dict {PACKAGE_PIN AD9  IOSTANDARD LVCMOS18} [get_ports {rgmii_4_rd[2]}]
set_property -dict {PACKAGE_PIN AC9  IOSTANDARD LVCMOS18} [get_ports {rgmii_4_rd[3]}]
set_property -dict {PACKAGE_PIN AB8  IOSTANDARD LVCMOS18} [get_ports rgmii_4_rxc]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS18} [get_ports rgmii_4_rx_ctl]
set_property -dict {PACKAGE_PIN B15  IOSTANDARD LVCMOS18} [get_ports mdio_4_mdc]
set_property -dict {PACKAGE_PIN A15  IOSTANDARD LVCMOS18} [get_ports mdio_4_mdio_io]
set_property -dict {PACKAGE_PIN J15  IOSTANDARD LVCMOS18} [get_ports {phy_rst_n_4[0]}]

# eth 5
set_property -dict {PACKAGE_PIN V4  IOSTANDARD LVCMOS18} [get_ports {rgmii_5_td[0]}]
set_property -dict {PACKAGE_PIN Y5  IOSTANDARD LVCMOS18} [get_ports {rgmii_5_td[1]}]
set_property -dict {PACKAGE_PIN W5  IOSTANDARD LVCMOS18} [get_ports {rgmii_5_td[2]}]
set_property -dict {PACKAGE_PIN W6  IOSTANDARD LVCMOS18} [get_ports {rgmii_5_td[3]}]
set_property -dict {PACKAGE_PIN U1  IOSTANDARD LVCMOS18} [get_ports rgmii_5_txc]
set_property -dict {PACKAGE_PIN T1  IOSTANDARD LVCMOS18} [get_ports rgmii_5_tx_ctl]
set_property -dict {PACKAGE_PIN U7  IOSTANDARD LVCMOS18} [get_ports {rgmii_5_rd[0]}]
set_property -dict {PACKAGE_PIN U4  IOSTANDARD LVCMOS18} [get_ports {rgmii_5_rd[1]}]
set_property -dict {PACKAGE_PIN U5  IOSTANDARD LVCMOS18} [get_ports {rgmii_5_rd[2]}]
set_property -dict {PACKAGE_PIN W4  IOSTANDARD LVCMOS18} [get_ports {rgmii_5_rd[3]}]
set_property -dict {PACKAGE_PIN W7  IOSTANDARD LVCMOS18} [get_ports rgmii_5_rxc]
set_property -dict {PACKAGE_PIN U6  IOSTANDARD LVCMOS18} [get_ports rgmii_5_rx_ctl]
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS18} [get_ports mdio_5_mdc]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports mdio_5_mdio_io]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS18} [get_ports {phy_rst_n_5[0]}]

# eth 6
set_property -dict {PACKAGE_PIN AH9  IOSTANDARD LVCMOS18} [get_ports {rgmii_6_td[0]}]
set_property -dict {PACKAGE_PIN AJ9  IOSTANDARD LVCMOS18} [get_ports {rgmii_6_td[1]}]
set_property -dict {PACKAGE_PIN AK9  IOSTANDARD LVCMOS18} [get_ports {rgmii_6_td[2]}]
set_property -dict {PACKAGE_PIN AK10 IOSTANDARD LVCMOS18} [get_ports {rgmii_6_td[3]}]
set_property -dict {PACKAGE_PIN AK8  IOSTANDARD LVCMOS18} [get_ports rgmii_6_txc]
set_property -dict {PACKAGE_PIN AJ10 IOSTANDARD LVCMOS18} [get_ports rgmii_6_tx_ctl]
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS18} [get_ports {rgmii_6_rd[0]}]
set_property -dict {PACKAGE_PIN AF8  IOSTANDARD LVCMOS18} [get_ports {rgmii_6_rd[1]}]
set_property -dict {PACKAGE_PIN AF7  IOSTANDARD LVCMOS18} [get_ports {rgmii_6_rd[2]}]
set_property -dict {PACKAGE_PIN AH8  IOSTANDARD LVCMOS18} [get_ports {rgmii_6_rd[3]}]
set_property -dict {PACKAGE_PIN AG8  IOSTANDARD LVCMOS18} [get_ports rgmii_6_rxc]
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS18} [get_ports rgmii_6_rx_ctl]
set_property -dict {PACKAGE_PIN K14  IOSTANDARD LVCMOS18} [get_ports mdio_6_mdc]
set_property -dict {PACKAGE_PIN J14  IOSTANDARD LVCMOS18} [get_ports mdio_6_mdio_io]
set_property -dict {PACKAGE_PIN E13  IOSTANDARD LVCMOS18} [get_ports {phy_rst_n_6[0]}]

# eth 7
set_property -dict {PACKAGE_PIN AK12 IOSTANDARD LVCMOS18} [get_ports {rgmii_7_td[0]}]
set_property -dict {PACKAGE_PIN AJ7  IOSTANDARD LVCMOS18} [get_ports {rgmii_7_td[1]}]
set_property -dict {PACKAGE_PIN AG13 IOSTANDARD LVCMOS18} [get_ports {rgmii_7_td[2]}]
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18} [get_ports {rgmii_7_td[3]}]
set_property -dict {PACKAGE_PIN AH13 IOSTANDARD LVCMOS18} [get_ports rgmii_7_txc]
set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18} [get_ports rgmii_7_tx_ctl]
set_property -dict {PACKAGE_PIN AJ12 IOSTANDARD LVCMOS18} [get_ports {rgmii_7_rd[0]}]
set_property -dict {PACKAGE_PIN AJ11 IOSTANDARD LVCMOS18} [get_ports {rgmii_7_rd[1]}]
set_property -dict {PACKAGE_PIN AK11 IOSTANDARD LVCMOS18} [get_ports {rgmii_7_rd[2]}]
set_property -dict {PACKAGE_PIN AK13 IOSTANDARD LVCMOS18} [get_ports {rgmii_7_rd[3]}]
set_property -dict {PACKAGE_PIN AH7  IOSTANDARD LVCMOS18} [get_ports rgmii_7_rxc]
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS18} [get_ports rgmii_7_rx_ctl]
set_property -dict {PACKAGE_PIN F13  IOSTANDARD LVCMOS18} [get_ports mdio_7_mdc]
set_property -dict {PACKAGE_PIN E14  IOSTANDARD LVCMOS18} [get_ports mdio_7_mdio_io]
set_property -dict {PACKAGE_PIN G13  IOSTANDARD LVCMOS18} [get_ports {phy_rst_n_7[0]}]

# sfp 0
set_property PACKAGE_PIN K2 [get_ports sfp_0_rxp]
set_property PACKAGE_PIN K1 [get_ports sfp_0_rxn]
set_property PACKAGE_PIN J4 [get_ports sfp_0_txp]
set_property PACKAGE_PIN J3 [get_ports sfp_0_txn]

## sfp 1
#set_property PACKAGE_PIN H2 [get_ports sfp_1_rxp]
#set_property PACKAGE_PIN H1 [get_ports sfp_1_rxn]
#set_property PACKAGE_PIN H6 [get_ports sfp_1_txp]
#set_property PACKAGE_PIN H5 [get_ports sfp_1_txn]

## sfp 2
#set_property PACKAGE_PIN G4 [get_ports sas_0_rxp]
#set_property PACKAGE_PIN G3 [get_ports sas_0_rxn]
#set_property PACKAGE_PIN F6 [get_ports sas_0_txp]
#set_property PACKAGE_PIN F5 [get_ports sas_0_txn]

# sfp 3
#set_property PACKAGE_PIN F2 [get_ports sfp_3_rxp]
#set_property PACKAGE_PIN F1 [get_ports sfp_3_rxn]
#set_property PACKAGE_PIN E4 [get_ports sfp_3_txp]
#set_property PACKAGE_PIN E3 [get_ports sfp_3_txn]

# auxiliary
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS33} [get_ports DS[0]]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports DS[1]]
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports DS[2]]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports DS[3]]
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS33} [get_ports DS[4]]
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports DS[5]]
set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVCMOS33} [get_ports DS[6]]
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33} [get_ports DS[7]]

set_property -dict {PACKAGE_PIN AG4 IOSTANDARD LVCMOS18} [get_ports LED[0]]
set_property -dict {PACKAGE_PIN AJ1 IOSTANDARD LVCMOS18} [get_ports LED[1]]

set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVCMOS33} [get_ports PB[0]]
set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVCMOS33} [get_ports PB[1]]

# sfp slowcontrol
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports SFP_TXF[0]]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports SFP_TXF[1]]
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVCMOS33} [get_ports SFP_TXD[0]]
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports SFP_TXD[1]]
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS33} [get_ports SFP_LOS[0]]
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports SFP_LOS[1]]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports SFP_MOD[0]]
set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports SFP_MOD[1]]

# pll
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS18} [get_ports PLL_INTR[0]]
set_property -dict {PACKAGE_PIN AG9  IOSTANDARD LVCMOS18} [get_ports PLL_INTR[1]]

# poe
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS33} [get_ports POE_RST[0]]
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS33} [get_ports POE_RST[1]]
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS33} [get_ports POE_INT[0]]
set_property -dict {PACKAGE_PIN J10 IOSTANDARD LVCMOS33} [get_ports POE_INT[1]]
set_property -dict {PACKAGE_PIN F11 IOSTANDARD LVCMOS33} [get_ports POE_OSS[0]]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports POE_OSS[1]]

# sync & trig

set_property -dict {PACKAGE_PIN AF3 IOSTANDARD LVDS} [get_ports MPMT_TRIG_io_p]
set_property -dict {PACKAGE_PIN AG3 IOSTANDARD LVDS} [get_ports MPMT_TRIG_io_n]
set_property -dict {PACKAGE_PIN AF2 IOSTANDARD LVDS} [get_ports MPMT_SYNC_io_p]
set_property -dict {PACKAGE_PIN AF1 IOSTANDARD LVDS} [get_ports MPMT_SYNC_io_n]

set_property -dict {PACKAGE_PIN AK7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports EXT_TRIG_I_io_p]
set_property -dict {PACKAGE_PIN AK6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports EXT_TRIG_I_io_n]
set_property -dict {PACKAGE_PIN AH3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports SAS_TRIG_I_io_p]
set_property -dict {PACKAGE_PIN AH2 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports SAS_TRIG_I_io_n]
set_property -dict {PACKAGE_PIN AK4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports SAS_SYNC_I_io_p]
set_property -dict {PACKAGE_PIN AK3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports SAS_SYNC_I_io_n]

set_property -dict {PACKAGE_PIN AF6 IOSTANDARD LVDS} [get_ports EXT_TRIG_O_io_p]
set_property -dict {PACKAGE_PIN AF5 IOSTANDARD LVDS} [get_ports EXT_TRIG_O_io_n]
set_property -dict {PACKAGE_PIN AG1 IOSTANDARD LVDS} [get_ports SAS_TRIG_O_io_p]
set_property -dict {PACKAGE_PIN AH1 IOSTANDARD LVDS} [get_ports SAS_TRIG_O_io_n]
set_property -dict {PACKAGE_PIN AJ2 IOSTANDARD LVDS} [get_ports SAS_SYNC_O_io_p]
set_property -dict {PACKAGE_PIN AK2 IOSTANDARD LVDS} [get_ports SAS_SYNC_O_io_n]

################################################################################################
# false paths
################################################################################################
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *data_sync_reg1}]













