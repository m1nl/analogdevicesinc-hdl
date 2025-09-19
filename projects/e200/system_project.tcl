###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create e200 0 {} "xc7z020clg400-2"

adi_project_files e200 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "system_constr_impl.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

set_property is_enabled false [get_files *system_sys_ps7_0.xdc]
adi_project_run e200
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

