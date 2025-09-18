# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_vctcxo_ctrl
adi_ip_files axi_vctcxo_ctrl [list \
  "../common/util_reset_sync.v" \
  "b205_ref_pll.v" \
  "ltc2630_spi.v" \
  "axi_vctcxo_ctrl_slave.v" \
  "axi_vctcxo_ctrl_constr.xdc" \
  "axi_vctcxo_ctrl.v" ]
adi_ip_properties_lite axi_vctcxo_ctrl

set cc [ipx::current_core]

ipx::infer_bus_interfaces xilinx.com:interface:aximm_rtl:1.0 $cc

ipx::associate_bus_interfaces -busif s_axi -clock s_axi_aclk -clear $cc

ipx::infer_bus_interface tcxo_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface ext_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface ext_pps xilinx.com:signal:clock_rtl:1.0 $cc

ipx::create_xgui_files $cc
ipx::save_core $cc
