# gmii input delay

set_input_delay -clock [get_clocks GMII_rx_clk] -max 1.0 [get_ports {GMII_rxd* GMII_rx_dv}]
set_input_delay -clock [get_clocks GMII_rx_clk] -min -0.5 [get_ports {GMII_rxd* GMII_rx_dv}]

# gmii output delay

set_output_delay -clock [get_clocks GMII_tx_clk] -max 1.0 [get_ports {GMII_txd* GMII_tx_en}]
set_output_delay -clock [get_clocks GMII_tx_clk] -min -0.5 [get_ports {GMII_txd* GMII_tx_en}]
