# gmii input delay

set_input_delay -clock [get_clocks GMII_rx_clk] -max 1.0 [get_ports {GMII_rxd* GMII_rx_dv}]
set_input_delay -clock [get_clocks GMII_rx_clk] -min -0.5 [get_ports {GMII_rxd* GMII_rx_dv}]

# gmii output delay

set_output_delay -clock [get_clocks GMII_tx_clk] -max 1.0 [get_ports {GMII_txd* GMII_tx_en}]
set_output_delay -clock [get_clocks GMII_tx_clk] -min -0.5 [get_ports {GMII_txd* GMII_tx_en}]

# hdmi output delay

set_false_path -to [get_ports {hdmi_clk_p}]

set_output_delay -reference_pin [get_ports {hdmi_clk_p}] -max 1.2 [get_ports {hdmi_d*_p}]
set_output_delay -reference_pin [get_ports {hdmi_clk_p}] -min -1.2 [get_ports {hdmi_d*_p}]
