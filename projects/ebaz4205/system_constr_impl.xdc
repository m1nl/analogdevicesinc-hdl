# ethernet PHY
create_clock -period 40.000 -name GMII_rx_clk -waveform {0.000 20.000} [get_ports GMII_rx_clk]
create_clock -period 40.000 -name GMII_tx_clk -waveform {0.000 20.000} [get_ports GMII_tx_clk]

# ext_clk

create_clock -period 10.00 -name ext_clk -waveform {0.000 5.000} [get_ports ext_clk]
