# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create hdmi_generator
adi_ip_files hdmi_generator [list \
  "../common/util_reset_sync.v" \
  "hdmi_generator_constr.xdc" \
  "hdmi_generator.v" ]

adi_ip_properties_lite hdmi_generator

set cc [ipx::current_core]

ipx::create_xgui_files $cc
ipx::save_core $cc
