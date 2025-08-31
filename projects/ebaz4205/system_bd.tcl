# default ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 MDIO_PHY
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 GMII

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_0

create_bd_port -dir I -from 9 -to 0 gpio_i
create_bd_port -dir O -from 9 -to 0 gpio_o
create_bd_port -dir O -from 9 -to 0 gpio_t

create_bd_port -dir O ttc0_wave0_out

create_bd_port -dir O hdmi_clk
create_bd_port -dir O hdmi_d0
create_bd_port -dir O hdmi_d1
create_bd_port -dir O hdmi_d2

create_bd_port -dir I ext_clk

# instance: sys_ps7

ad_ip_instance processing_system7 sys_ps7

# ps7 settings

ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V}
ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 3.3V}

ad_ip_parameter sys_ps7 CONFIG.PCW_PACKAGE_NAME {clg400}

ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_ENABLE 1

ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 10

ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_ENET0_IO {EMIO}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_IO {EMIO}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {External}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 5
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {100 Mbps}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_RESET_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_PERIPHERAL_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK0_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST0_PORT 1

ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK1_PORT 0
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK2_PORT 0
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK3_PORT 0

ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ 100.0

ad_ip_parameter sys_ps7 CONFIG.PCW_NAND_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_NAND_GRP_D8_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_NAND_NAND_IO {MIO 0 2.. 14}

ad_ip_parameter sys_ps7 CONFIG.PCW_NOR_PERIPHERAL_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_CD_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_POW_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_WP_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45}

ad_ip_parameter sys_ps7 CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ 100.0
ad_ip_parameter sys_ps7 CONFIG.PCW_SDIO_PERIPHERAL_VALID 1

ad_ip_parameter sys_ps7 CONFIG.PCW_UART0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UART0_GRP_FULL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_UART0_UART0_IO {EMIO}

ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_GRP_FULL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_UART1_IO {MIO 24 .. 25}

ad_ip_parameter sys_ps7 CONFIG.PCW_I2C_RESET_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C0_RESET_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_I2C1_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_I2C1_RESET_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI1_PERIPHERAL_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_TTC0_IO {EMIO}
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {External}

ad_ip_parameter sys_ps7 CONFIG.PCW_USB_RESET_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_USB1_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_USB1_RESET_ENABLE 0

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_FABRIC_INTERRUPT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_INTR 1
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_MODE REVERSE

ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_0_PULLUP  {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_9_PULLUP  {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_10_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_11_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_12_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_13_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_14_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_20_PULLUP {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_40_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_40_SLEW   {fast}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_41_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_42_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_43_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_44_PULLUP {enabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_45_PULLUP {enabled}

# DDR MT41K128M16 JT-125

ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K128M16 JT-125}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE 1

# interface connections

ad_connect sys_ps7/MDIO_ETHERNET_0 MDIO_PHY
ad_connect sys_ps7/GMII_ETHERNET_0 GMII

ad_connect ddr sys_ps7/DDR
ad_connect fixed_io sys_ps7/FIXED_IO

ad_connect UART_0 sys_ps7/UART_0

ad_connect gpio_i sys_ps7/GPIO_I
ad_connect gpio_o sys_ps7/GPIO_O
ad_connect gpio_t sys_ps7/GPIO_T

ad_connect ttc0_wave0_out sys_ps7/TTC0_WAVE0_OUT

ad_connect sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect sys_cpu_clk sys_ps7/M_AXI_GP0_ACLK
ad_connect sys_cpu_clk sys_ps7/TTC0_CLK0_IN

ad_ip_instance xlconcat sys_concat_intc
ad_ip_parameter sys_concat_intc CONFIG.NUM_PORTS 16

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

# system reset/clock definitions

ad_connect sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# interrupts

ad_connect sys_concat_intc/dout sys_ps7/IRQ_F2P
ad_connect sys_concat_intc/In15 GND
ad_connect sys_concat_intc/In14 GND
ad_connect sys_concat_intc/In13 GND
ad_connect sys_concat_intc/In12 GND
ad_connect sys_concat_intc/In11 GND
ad_connect sys_concat_intc/In10 GND
ad_connect sys_concat_intc/In9 GND
ad_connect sys_concat_intc/In8 GND
ad_connect sys_concat_intc/In7 GND
ad_connect sys_concat_intc/In6 GND
ad_connect sys_concat_intc/In5 GND
ad_connect sys_concat_intc/In4 GND
ad_connect sys_concat_intc/In3 GND
ad_connect sys_concat_intc/In2 GND
ad_connect sys_concat_intc/In1 GND
ad_connect sys_concat_intc/In0 GND
