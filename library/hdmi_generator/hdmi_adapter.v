/*

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
module hdmi_adapter(
  input wire areset,
  input wire aclk,

  input wire [63:0] s_axis_rgb_tdata,
  input wire s_axis_rgb_tvalid,
  input wire s_axis_rgb_tlast,
  output reg s_axis_rgb_tready,

  input wire [9:0] cx,
  input wire [9:0] cy,

  input wire [9:0] screen_width,
  input wire [9:0] screen_height,

  output reg[23:0] rgb
);
  reg [$clog2(24)-1:0] addra;
  reg [$clog2(24)-1:0] addra_next;

  reg [$clog2(24)-1:0] addrb;
  reg [$clog2(24)-1:0] addrb_next;

  reg directiona = 1'b0;
  reg directiona_next;

  reg directionb = 1'b0;
  reg directionb_next;

  reg sync = 1'b0;
  reg sync_next;

  wire [63:0] dia;

  reg we;
  reg re;

  wire [63:0] dob, doc;
  wire [23:0] dod;

  (* ram_style = "distributed" *)
  reg [63:0] ram [0:2];

  always @(posedge aclk) begin
    if (we)
      ram[addra >> 3] <= dia;
  end

  assign dia = s_axis_rgb_tdata;

  assign dob = ram[(addrb >> 3)];
  assign doc = ram[(addrb >> 3) + 1];

  assign dod = (addrb == 0)  ? dob[23:0]              :
               (addrb == 3)  ? dob[47:24]             :
               (addrb == 6)  ? {doc[7:0],dob[63:48]}  :
               (addrb == 9)  ? dob[31:8]              :
               (addrb == 12) ? dob[55:32]             :
               (addrb == 15) ? {doc[15:0],dob[63:56]} :
               (addrb == 18) ? dob[39:16]             :
                               dob[63:40];

  wire sof;
  wire video;
  wire underflow;

  assign sof       = cx == 0 && cy == 0;
  assign video     = cx < screen_width && cy < screen_height;
  assign underflow = (addra < addrb + 3) ^ directiona ^ directionb;

  always @(posedge aclk)
    if (areset) begin
      addra      <= 0;
      addrb      <= 0;
      directiona <= 1'b0;
      directionb <= 1'b0;
      sync       <= 1'b0;
      rgb        <= 24'd0;
    end else begin
      addra      <= addra_next;
      addrb      <= addrb_next;
      directiona <= directiona_next;
      directionb <= directionb_next;
      sync       <= sync_next;
      rgb        <= re ? dod : 24'd0;
    end

  always @* begin
    addra_next = addra;
    addrb_next = addrb;

    we = 1'b0;
    re = 1'b0;

    directiona_next = directiona;
    directionb_next = directionb;

    sync_next = sync;

    s_axis_rgb_tready = ~directiona;

    if (sof)
      sync_next = 1'b1;

    if (sync || sync_next) begin
      s_axis_rgb_tready = 1'b0;

      if (underflow) begin
        addra_next        = 0;
        addrb_next        = 0;
        directiona_next   = 1'b0;
        directionb_next   = 1'b0;
        sync_next         = 1'b0;
        s_axis_rgb_tready = 1'b1;
      end else begin
        if (video) begin
          re = 1'b1;

          if (addrb == 21) begin
            addrb_next      = 0;
            directionb_next = ~directionb;
          end else
            addrb_next = addrb + 3;
        end

        case (addrb)
          0, 3: if (addra != 0)
            s_axis_rgb_tready = 1'b1;
          6: if (addra != 0 && addra != 8)
            s_axis_rgb_tready = 1'b1;
          9, 12: if (addra != 8)
            s_axis_rgb_tready = 1'b1;
          15: if (addra != 8 || addra != 16)
            s_axis_rgb_tready = 1'b1;
          18, 21: if (addra != 16)
            s_axis_rgb_tready = 1'b1;
        endcase
      end
    end

    if (s_axis_rgb_tvalid && s_axis_rgb_tready) begin
      we = 1'b1;

      if (addra == 16) begin
        addra_next      = 0;
        directiona_next = ~directiona;
      end else
        addra_next = addra + 8;
    end
  end
endmodule
`default_nettype wire
// vim:ts=2 sw=2 tw=120 et
