set_false_path \
  -from [get_pins {util_reset_sync_0/sync_reg*/C}] \
  -to [get_pins {util_reset_sync_0/rst_hold_reg*/PRE}]

set_false_path \
  -from [get_pins {util_reset_sync_1/sync_reg*/C}] \
  -to [get_pins {util_reset_sync_1/rst_hold_reg*/D}]
