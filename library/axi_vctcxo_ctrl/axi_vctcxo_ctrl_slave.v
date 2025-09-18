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
module axi_vctcxo_ctrl_slave #(
    parameter integer REG_DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH     = 5
) (
    output wire [0:0] dac_mode,
    output wire [15:0] dac_user_set_value,
    input wire [15:0] dac_value,
    output wire [1:0] dac_ref_sel,
    input wire dac_locked,
    input wire pll_locked,

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
  reg axi_awready;
  reg axi_wready;
  reg axi_bvalid;
  reg axi_arready;
  reg [REG_DATA_WIDTH-1:0] axi_rdata;
  reg axi_rvalid;

  localparam integer ADDR_LSB = 2;
  localparam integer AW = ADDR_WIDTH - 2;
  localparam integer DW = REG_DATA_WIDTH;

  localparam integer REG_ADDR_MODE          = 0;  //  0
  localparam integer REG_ADDR_USER_VALUE    = 1;  //  4
  localparam integer REG_ADDR_CURRENT_VALUE = 2;  //  8
  localparam integer REG_ADDR_REF_SEL       = 3;  // 12
  localparam integer REG_ADDR_STATUS        = 4;  // 16

  localparam integer RW_MEM_SIZE = 3;
  localparam integer RO_MEM_SIZE = 2;

  localparam integer MEM_SIZE = RW_MEM_SIZE + RO_MEM_SIZE;

  reg [DW-1:0] mem[0:MEM_SIZE-1];

  assign s_axi_awready = axi_awready;
  assign s_axi_wready  = axi_wready;
  assign s_axi_bresp   = 2'b00;  // The OKAY response
  assign s_axi_bvalid  = axi_bvalid;
  assign s_axi_arready = axi_arready;
  assign s_axi_rdata   = axi_rdata;
  assign s_axi_rresp   = 2'b00;  // The OKAY response
  assign s_axi_rvalid  = axi_rvalid;

  wire valid_read_request, read_response_stall;

  assign valid_read_request  = s_axi_arvalid || !s_axi_arready;
  assign read_response_stall = s_axi_rvalid  && !s_axi_rready;

  reg [AW-1:0] pre_raddr, raddr;

  always @(posedge s_axi_aclk) if (s_axi_arready) pre_raddr <= s_axi_araddr;

  always @(*)
    if (!axi_arready) raddr = pre_raddr;
    else raddr = s_axi_araddr[AW+ADDR_LSB-1:ADDR_LSB];

  initial axi_arready = 1'b1;
  always @(posedge s_axi_aclk)
    if (!s_axi_resetn) axi_arready <= 1'b1;
    else if (read_response_stall) begin
      axi_arready <= !valid_read_request;
    end else axi_arready <= 1'b1;

  reg [AW-1:0] pre_waddr, waddr;
  reg [REG_DATA_WIDTH-1:0] pre_wdata, wdata;
  reg [(REG_DATA_WIDTH/8)-1:0] pre_wstrb, wstrb;

  wire valid_write_address, valid_write_data, write_response_stall;

  assign valid_write_address  = s_axi_awvalid || !axi_awready;
  assign valid_write_data     = s_axi_wvalid  || !axi_wready;
  assign write_response_stall = s_axi_bvalid  && !s_axi_bready;

  initial axi_awready = 1'b1;
  always @(posedge s_axi_aclk)
    if (!s_axi_resetn) axi_awready <= 1'b1;
    else if (write_response_stall || valid_read_request) begin
      axi_awready <= !valid_write_address;
    end else if (valid_write_data) axi_awready <= 1'b1;
    else axi_awready <= !valid_write_address;

  initial axi_wready = 1'b1;
  always @(posedge s_axi_aclk)
    if (!s_axi_resetn) axi_wready <= 1'b1;
    else if (write_response_stall || valid_read_request) axi_wready <= !valid_write_data;
    else if (valid_write_address) axi_wready <= 1'b1;
    else axi_wready <= (axi_wready && !s_axi_wvalid);

  always @(posedge s_axi_aclk) if (s_axi_awready) pre_waddr <= s_axi_awaddr[AW+ADDR_LSB-1:ADDR_LSB];

  always @(posedge s_axi_aclk)
    if (s_axi_wready) begin
      pre_wdata <= s_axi_wdata;
      pre_wstrb <= s_axi_wstrb;
    end

  always @(*)
    if (!axi_awready) waddr = pre_waddr;
    else waddr = s_axi_awaddr[AW+ADDR_LSB-1:ADDR_LSB];

  always @(*)
    if (!axi_wready) begin
      wstrb = pre_wstrb;
      wdata = pre_wdata;
    end else begin
      wstrb = s_axi_wstrb;
      wdata = s_axi_wdata;
    end

  initial axi_rvalid = 1'b0;
  initial axi_bvalid = 1'b0;
  always @(posedge s_axi_aclk)
    if (!s_axi_resetn) begin
      axi_bvalid <= 1'b0;
      axi_rvalid <= 1'b0;
    end else begin
      if (s_axi_rready) axi_rvalid <= 1'b0;
      if (s_axi_bready) axi_bvalid <= 1'b0;

      if (valid_read_request)
        axi_rvalid <= 1'b1;
      else if (valid_write_address && valid_write_data)
        axi_bvalid <= 1'b1;
    end

  integer i;
  initial begin
    // default values from Linux ad5660_mp.c driver
    mem[REG_ADDR_MODE]          = 1;
    mem[REG_ADDR_USER_VALUE]    = 2300;
    mem[REG_ADDR_CURRENT_VALUE] = 0;
    mem[REG_ADDR_REF_SEL]       = 0;
    mem[REG_ADDR_STATUS]        = 0;
  end
  always @(posedge s_axi_aclk)
    if (!s_axi_resetn) begin
    end else begin
      if (!read_response_stall && valid_read_request)
        axi_rdata <= mem[raddr];
      else if (!write_response_stall && valid_write_address && valid_write_data) begin
        if (wstrb[0]) mem[waddr][7:0]   <= wdata[7:0];
        if (wstrb[1]) mem[waddr][15:8]  <= wdata[15:8];
        if (wstrb[2]) mem[waddr][23:16] <= wdata[23:16];
        if (wstrb[3]) mem[waddr][31:24] <= wdata[31:24];
      end else begin
        mem[REG_ADDR_CURRENT_VALUE] <= {16'b0, dac_value};
        mem[REG_ADDR_STATUS]        <= {30'b0, dac_locked, pll_locked};
      end
    end

  assign dac_mode           = mem[REG_ADDR_MODE][0];
  assign dac_user_set_value = mem[REG_ADDR_USER_VALUE][15:0];
  assign dac_ref_sel        = mem[REG_ADDR_REF_SEL][1:0];
endmodule
`default_nettype wire
// vim:ts=2 sw=2 tw=120 et
