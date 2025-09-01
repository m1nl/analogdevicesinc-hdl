# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create hdmi_generator
adi_ip_files hdmi_generator [list \
  "../common/util_reset_sync.v" \
  "hdmi_adapter.v" \
  "hdmi_generator_constr.xdc" \
  "hdmi_generator.v" ]

adi_ip_properties_lite hdmi_generator

set cc [ipx::current_core]

ipx::infer_bus_interfaces xilinx.com:interface:axis_rtl:1.0 $cc
ipx::associate_bus_interfaces -busif s_axis_rgb -clock pixel_clk -clear $cc

set reset_inf [ipx::get_bus_interfaces pixel_reset -of_objects $cc]
set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_inf]
set_property value "ACTIVE_HIGH" $reset_polarity

ipx::create_xgui_files $cc
ipx::save_core $cc
