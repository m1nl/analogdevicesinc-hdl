/*

Copyright (c) MicroPhase
Copyright (c) 2025 Mateusz Nalewajski

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

`default_nettype none
`timescale 1 ns / 1 ps
module axi_vctcxo_ctrl #(
  parameter DEVICE = "LTC2630",

  parameter integer REG_DATA_WIDTH = 32,
  parameter integer ADDR_WIDTH     = 5
) (
  input wire tcxo_clk,

  input wire ext_clk,
  input wire ext_pps,

  output wire ext_clk_locked,
  output wire ext_pps_locked,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 vctxco_resetn_200M RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
  output wire resetn_200M,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 vctxco_aclk_200M CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET vctxco_resetn_200M, CLK_DOMAIN vctxco_aclk_200M, FREQ_HZ 200000000" *)
  output wire aclk_200M,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 vctxco_resetn_250M RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
  output wire resetn_250M,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 vctxco_aclk_250M CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET vctxco_resetn_250M, CLK_DOMAIN vctxco_aclk_250M, FREQ_HZ 250000000" *)
  output wire aclk_250M,

  output wire dac_sync_n,
  output wire dac_sclk,
  output wire dac_din,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_resetn RST" *)
  input wire s_axi_resetn,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_RESET s_axi_resetn, ASSOCIATED_BUSIF s_axi" *)
  input wire s_axi_aclk,
  input wire [ADDR_WIDTH-1:0] s_axi_awaddr,
  input wire [2:0] s_axi_awprot,
  input wire s_axi_awvalid,
  output wire s_axi_awready,
  input wire [REG_DATA_WIDTH-1:0] s_axi_wdata,
  input wire [(REG_DATA_WIDTH/8)-1:0] s_axi_wstrb,
  input wire s_axi_wvalid,
  output wire s_axi_wready,
  output wire [1:0] s_axi_bresp,
  output wire s_axi_bvalid,
  input wire s_axi_bready,
  input wire [ADDR_WIDTH-1:0] s_axi_araddr,
  input wire [2:0] s_axi_arprot,
  input wire s_axi_arvalid,
  output wire s_axi_arready,
  output wire [REG_DATA_WIDTH-1:0] s_axi_rdata,
  output wire [1:0] s_axi_rresp,
  output wire s_axi_rvalid,
  input wire s_axi_rready
);

  wire [0:0]  dac_mode;
  wire [15:0] dac_user_set_value;
  wire [15:0] dac_value;
  wire [1:0]  dac_ref_sel;
  wire        dac_locked;

  wire ref_clk;
  wire ext_ref_clk;
  wire ref_ext_pll_locked;

  wire ref_is_10M;
  wire ref_is_pps;

  wire pll_locked;

  wire aclk_200M_i, aclk_200M_o;
  wire aclk_250M_i, aclk_250M_o;
  wire ref_clk_i, ref_clk_o;

  wire reset_200M;
  wire reset_250M;

  axi_vctcxo_ctrl_slave #(
    .REG_DATA_WIDTH(REG_DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) axi_vctcxo_ctrl_slave_0 (
    .dac_mode(dac_mode),
    .dac_user_set_value(dac_user_set_value),
    .dac_value(dac_value),
    .dac_ref_sel(dac_ref_sel),
    .dac_locked(ref_ext_pll_locked),
    .pll_locked(pll_locked),
    .s_axi_aclk(s_axi_aclk),
    .s_axi_resetn(s_axi_resetn),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready)
  );

  assign ext_clk_locked = ref_ext_pll_locked & ref_is_10M;
  assign ext_pps_locked = ref_ext_pll_locked & ref_is_pps;

  assign ext_ref_clk = (dac_ref_sel == 2'b00) ? ext_clk : (dac_ref_sel == 2'b01) ? ext_pps : 1'b0;

  PLLE2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .COMPENSATION("INTERNAL"),
    .DIVCLK_DIVIDE(1),
    .CLKFBOUT_MULT(25),
    .CLKOUT0_DIVIDE(5),
    .CLKOUT1_DIVIDE(4),
    .CLKOUT2_DIVIDE(25),
    .CLKIN1_PERIOD(25.0)
  ) clkgen (
    .PWRDWN(1'b0),
    .RST(~s_axi_resetn),
    .CLKIN1(tcxo_clk),
    .CLKOUT0(aclk_200M_i),
    .CLKOUT1(aclk_250M_i),
    .CLKOUT2(ref_clk_i),
    .LOCKED(pll_locked)
  );

  BUFG buf_aclk_200M (
    .I(aclk_200M_i),
    .O(aclk_200M_o)
  );

  assign aclk_200M = aclk_200M_o;

  BUFG buf_aclk_250M (
    .I(aclk_250M_i),
    .O(aclk_250M_o)
  );

  assign aclk_250M = aclk_250M_o;

  BUFG buf_ref_clk (
    .I(ref_clk_i),
    .O(ref_clk_o)
  );

  assign ref_clk = ref_clk_o;

  util_reset_sync util_reset_sync_0 (
    .out(reset_200M),
    .clk(aclk_200M),
    .rst(~s_axi_resetn || !pll_locked)
  );

  assign resetn_200M = !reset_200M;

  util_reset_sync util_reset_sync_1 (
    .out(reset_250M),
    .clk(aclk_250M),
    .rst(~s_axi_resetn || !pll_locked)
  );

  assign resetn_250M = !reset_250M;

  b205_ref_pll #(
    .DEVICE(DEVICE)
  ) u_b205_ref_pll (
    .reset(reset_200M),
    .clk(aclk_200M),
    .ref_clk(ref_clk),
    .ext_ref_clk(ext_ref_clk),
    .locked(ref_ext_pll_locked),
    .ref_is_10M(ref_is_10M),
    .ref_is_pps(ref_is_pps),
    .dac_dft(16'd42580),
    .sclk(dac_sclk),
    .mosi(dac_din),
    .sync_n(dac_sync_n),
    .dac_mode(dac_mode),
    .dac_user_set_value(dac_user_set_value),
    .dac_value(dac_value)
  );
endmodule
`default_nettype wire
// vim:ts=2 sw=2 tw=120 et
