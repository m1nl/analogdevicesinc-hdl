# uart
set_property IOSTANDARD LVCMOS33 [get_ports UART_0_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_0_txd]
set_property PACKAGE_PIN H16 [get_ports UART_0_rxd]
set_property PACKAGE_PIN H17 [get_ports UART_0_txd]

# leds

set_property IOSTANDARD LVCMOS33 [get_ports gpio_led_green]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_led_red]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_led_aux_0]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_led_aux_1]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_led_aux_2]
set_property IOSTANDARD LVCMOS33 [get_ports buzzer]
set_property PACKAGE_PIN W13 [get_ports gpio_led_green]
set_property PACKAGE_PIN W14 [get_ports gpio_led_red]
set_property PACKAGE_PIN E19 [get_ports gpio_led_aux_0]
set_property PACKAGE_PIN K17 [get_ports gpio_led_aux_1]
set_property PACKAGE_PIN H18 [get_ports gpio_led_aux_2]
set_property PACKAGE_PIN D18 [get_ports buzzer]

# switches

set_property IOSTANDARD LVCMOS33 [get_ports gpio_switch_aux_0]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_switch_aux_1]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_switch_aux_2]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_switch_aux_3]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_switch_aux_4]
set_property PACKAGE_PIN T19 [get_ports gpio_switch_aux_0]
set_property PACKAGE_PIN P19 [get_ports gpio_switch_aux_1]
set_property PACKAGE_PIN U20 [get_ports gpio_switch_aux_2]
set_property PACKAGE_PIN U19 [get_ports gpio_switch_aux_3]
set_property PACKAGE_PIN V20 [get_ports gpio_switch_aux_4]

# hdmi

## HDMI TMDS Clock
set_property PACKAGE_PIN F19 [get_ports {hdmi_clk_p}]
set_property PACKAGE_PIN F20 [get_ports {hdmi_clk_n}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_clk_p}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_clk_n}]

## HDMI TMDS Data 0
set_property PACKAGE_PIN D19 [get_ports {hdmi_d0_p}]
set_property PACKAGE_PIN D20 [get_ports {hdmi_d0_n}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_d0_p}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_d0_n}]

## HDMI TMDS Data 1
set_property PACKAGE_PIN C20 [get_ports {hdmi_d1_p}]
set_property PACKAGE_PIN B20 [get_ports {hdmi_d1_n}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_d1_p}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_d1_n}]

## HDMI TMDS Data 2
set_property PACKAGE_PIN B19 [get_ports {hdmi_d2_p}]
set_property PACKAGE_PIN A20 [get_ports {hdmi_d2_n}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_d2_p}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_d2_n}]

# ethernet PHY

set_property IOSTANDARD LVCMOS33 [get_ports GMII_rx_clk]
set_property IOSTANDARD LVCMOS33 [get_ports GMII_tx_clk]
set_property PACKAGE_PIN U14 [get_ports GMII_rx_clk]
set_property PACKAGE_PIN U15 [get_ports GMII_tx_clk]

set_property IOSTANDARD LVCMOS33 [get_ports {GMII_rxd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GMII_rxd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GMII_rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GMII_rxd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports GMII_tx_en]
set_property IOSTANDARD LVCMOS33 [get_ports {GMII_txd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GMII_txd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GMII_txd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GMII_txd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports GMII_rx_dv]
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_PHY_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_PHY_mdio_io]
set_property PACKAGE_PIN Y17 [get_ports {GMII_rxd[3]}]
set_property PACKAGE_PIN V17 [get_ports {GMII_rxd[2]}]
set_property PACKAGE_PIN V16 [get_ports {GMII_rxd[1]}]
set_property PACKAGE_PIN Y16 [get_ports {GMII_rxd[0]}]
set_property PACKAGE_PIN W19 [get_ports GMII_tx_en]
set_property PACKAGE_PIN W18 [get_ports {GMII_txd[0]}]
set_property PACKAGE_PIN Y18 [get_ports {GMII_txd[1]}]
set_property PACKAGE_PIN V18 [get_ports {GMII_txd[2]}]
set_property PACKAGE_PIN Y19 [get_ports {GMII_txd[3]}]
set_property PACKAGE_PIN W15 [get_ports MDIO_PHY_mdc]
set_property PACKAGE_PIN Y14 [get_ports MDIO_PHY_mdio_io]
set_property PACKAGE_PIN W16 [get_ports GMII_rx_dv]

# ext_clk

set_property IOSTANDARD LVCMOS33 [get_ports ext_clk]
set_property PACKAGE_PIN N18 [get_ports ext_clk]

# ddr

set_property IOSTANDARD SSTL15_T_DCI [get_ports *fixed_io_ddr_vr*]
set_property IOSTANDARD DIFF_SSTL15 [get_ports *ddr_ck*]
set_property IOSTANDARD SSTL15 [get_ports *ddr_addr*]
set_property IOSTANDARD SSTL15 [get_ports *ddr_ba*]
set_property IOSTANDARD SSTL15 [get_ports ddr_reset_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cs_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_ras_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cas_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_we_n]
set_property IOSTANDARD SSTL15 [get_ports ddr_cke]
set_property IOSTANDARD SSTL15 [get_ports ddr_odt]
set_property IOSTANDARD SSTL15_T_DCI [get_ports *ddr_dq[*]]
set_property IOSTANDARD SSTL15_T_DCI [get_ports *ddr_dm[*]]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports *ddr_dqs*]
