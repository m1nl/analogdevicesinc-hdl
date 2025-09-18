###############################################################################
## Copyright (C) 2025 Mateusz Nalewajski. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks ext_pps] \
    -group [get_clocks -include_generated_clocks ext_clk] \
    -group [get_clocks -include_generated_clocks tcxo_clk];

set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks clk_fpga_0] \
    -group [get_clocks -include_generated_clocks rx_clk] \
    -group [get_clocks -include_generated_clocks tcxo_clk];

###

set_false_path -from [get_pins {i_system_wrapper/system_i/axi_ad9361/inst/i_rx/i_up_adc_common/up_adc_gpio_out_int_reg[0]/C}];
set_false_path -from [get_pins {i_system_wrapper/system_i/axi_ad9361/inst/i_tx/i_up_dac_common/up_dac_gpio_out_int_reg[0]/C}];
