# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create hdmi
adi_ip_files hdmi [list \
  "audio_clock_regeneration_packet.sv" \
  "audio_info_frame.sv" \
  "audio_sample_packet.sv" \
  "auxiliary_video_information_info_frame.sv" \
  "packet_assembler.sv" \
  "packet_picker.sv" \
  "serializer_3ch.sv" \
  "source_product_description_info_frame.sv" \
  "tmds_channel.sv" \
  "hdmi.v" ]

set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties_lite hdmi

set cc [ipx::current_core]

#ipx::infer_bus_interfaces xilinx.com:interface:axis_rtl:1.0 $cc
#ipx::infer_bus_interfaces xilinx.com:interface:aximm_rtl:1.0 $cc
#
#ipx::associate_bus_interfaces -busif s_axi -clock s_axi_aclk -clear $cc
#ipx::associate_bus_interfaces -busif s_axis_data -clock aclk -clear $cc
#
#ipx::associate_bus_interfaces -busif m_axis_burst_desc -clock aclk $cc
#ipx::associate_bus_interfaces -busif m_axis_fft_config -clock aclk $cc
#
#set reset_inf [ipx::get_bus_interfaces reset_req -of_objects $cc]
#set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_inf]
#set_property value "ACTIVE_HIGH" $reset_polarity

ipx::create_xgui_files $cc
ipx::save_core $cc
