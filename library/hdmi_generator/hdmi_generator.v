`timescale 1ns / 100ps

module hdmi_generator(
  input wire clk,
  input wire aresetn,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 pixel_reset RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
  output wire pixel_reset,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pixel_clk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET pixel_reset, CLK_DOMAIN pixel_clk, FREQ_HZ 25250000, ASSOCIATED_BUSIF rgb" *)
  output wire pixel_clk,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pixel_clk_5x CLK" *)
  (* X_INTERFACE_PARAMETER = "CLK_DOMAIN pixel_clk_5x, FREQ_HZ 126250000" *)
  output wire pixel_x5_clk,

  input wire [9:0] cx,
  input wire [9:0] cy,

  input wire [9:0] screen_width,
  input wire [9:0] screen_height,

  output reg [23:0] rgb
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
    .CLKIN1   (clk),
    .CLKINSEL (1'b1),
    .CLKFBOUT (clkfbout),
    .CLKFBIN  (clkfbout_o),
    .CLKOUT0  (pixel_clk_i),
    .CLKOUT1  (pixel_x5_clk_i),
    .LOCKED   (locked),
    .PWRDWN   (1'b0),
    .RST      (1'b0)
  );

  BUFG clkfbout_bufg(
    .O(clkfbout_o),
    .I(clkfbout)
  );

  BUFG pixel_clk_bufg (
    .O(pixel_clk),
    .I(pixel_clk_i)
  );

  BUFG pixel_x5_clk_bufg(
    .O(pixel_x5_clk),
    .I(pixel_x5_clk_i)
  );

  util_reset_sync util_reset_sync_0 (
    .out(pixel_reset),
    .clk(pixel_clk),
    .rst(!aresetn || !locked)
  );

  always @(posedge pixel_clk)
    rgb <= {(cx[0] == 1'b1) ? 8'hff : 8'h00, (cx[0] == 1'b1) ? 8'h00 : 8'hff, (cy[0] == 1'b1) ? 8'hff : 8'h00};
endmodule
