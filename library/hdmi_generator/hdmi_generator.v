`default_nettype none
`timescale 1 ns / 1 ps
module hdmi_generator(
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_100m RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
  input wire reset_100m,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk_100m CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET reset_100m" *)
  input wire clk_100m,

  input wire [63:0] s_axis_rgb_tdata,
  input wire s_axis_rgb_tvalid,
  input wire s_axis_rgb_tlast,
  output wire s_axis_rgb_tready,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 pixel_reset RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
  output wire pixel_reset,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pixel_clk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET pixel_reset, CLK_DOMAIN pixel_clk, FREQ_HZ 25250000, ASSOCIATED_BUSIF s_axis_rgb" *)
  output wire pixel_clk,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pixel_clk_5x CLK" *)
  (* X_INTERFACE_PARAMETER = "CLK_DOMAIN pixel_clk_5x, FREQ_HZ 126250000" *)
  output wire pixel_x5_clk,

  input wire [9:0] cx,
  input wire [9:0] cy,

  input wire [9:0] screen_width,
  input wire [9:0] screen_height,

  output wire [23:0] rgb
);
  wire clkfbout, clkfbout_o;

  wire pixel_clk_i;
  wire pixel_x5_clk_i;

  wire locked;

  MMCME2_ADV #(
    .BANDWIDTH        ("OPTIMIZED"),
    .COMPENSATION     ("ZHOLD"),
    .STARTUP_WAIT     ("FALSE"),
    .CLKIN1_PERIOD    (10.000),
    .DIVCLK_DIVIDE    (5),
    .CLKFBOUT_MULT_F  (50.500),
    .CLKOUT0_DIVIDE_F (40.000),
    .CLKOUT1_DIVIDE   (8)
  ) mmcm_adv_inst (
    .PWRDWN(1'b0),
    .RST(reset_100m),
    .CLKIN1(clk_100m),
    .CLKINSEL(1'b1),
    .CLKFBOUT(clkfbout),
    .CLKFBIN(clkfbout_o),
    .CLKOUT0(pixel_clk_i),
    .CLKOUT1(pixel_x5_clk_i),
    .LOCKED(locked)
  );

  BUFG clkfbout_bufg(
    .I(clkfbout),
    .O(clkfbout_o)
  );

  BUFG pixel_clk_bufg (
    .I(pixel_clk_i),
    .O(pixel_clk)
  );

  BUFG pixel_x5_clk_bufg(
    .I(pixel_x5_clk_i),
    .O(pixel_x5_clk)
  );

  util_reset_sync util_reset_sync_0 (
    .rst(reset_100m || !locked),
    .clk(pixel_clk),
    .out(pixel_reset)
  );

  hdmi_adapter hdmi_adapter_0 (
    .areset(pixel_reset),
    .aclk(pixel_clk),
    .s_axis_rgb_tdata(s_axis_rgb_tdata),
    .s_axis_rgb_tvalid(s_axis_rgb_tvalid),
    .s_axis_rgb_tlast(s_axis_rgb_tlast),
    .s_axis_rgb_tready(s_axis_rgb_tready),
    .rgb(rgb),
    .sof(cx == 0 && cy == 0)
  );
endmodule
`default_nettype wire
// vim:ts=2 sw=2 tw=120 et
