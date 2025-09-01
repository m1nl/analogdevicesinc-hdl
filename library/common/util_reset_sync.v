/*
 * Synchronizes an active-high asynchronous reset signal to a given clock by
 * using a pipeline of N registers.
 */
module util_reset_sync #
(
    // depth of synchronizer
    parameter N = 3,
    // duration of pulse
    parameter D = 2
)
(
    input  wire clk,
    input  wire rst,
    output wire out
);

(* ASYNC_REG = "TRUE" *)
reg [N-1:0] rst_hold = {N{1'b0}};
reg [D-1:0] sync_reg = {D{1'b0}};

assign out = |sync_reg[D-1:0];

always @(posedge clk or posedge rst) begin
  if (rst) begin
    rst_hold <= {N{1'b1}};
  end else begin
    rst_hold[N-1:0] <= {rst_hold[N-2:0], 1'b0};
  end
end

always @(posedge clk) begin
  sync_reg[0] <= rst_hold[N-1];
  sync_reg[D-1:1] <= sync_reg[D-2:0];
end

endmodule

`resetall
