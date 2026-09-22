/*
 * Q15 — Sequence Detector
 *
 * Sample the serial input din on each rising edge of clk and detect whether the four most
 * recent bits equal 4'b1010.
 * - Assert dout for one cycle when the sequence is detected; otherwise drive dout=0.
 * - Support overlapping sequences. For example, 101010 contains two matches.
 * - resetn is an active-low synchronous reset. Clear the input history and dout on reset.
 */
module sequence_detector
  (input  logic clk,
   input  logic resetn,
   input  logic din,
   output logic dout);

  // TODO: Implement your design here.
  localparam logic [3:0] target = 4'b1010;
  logic [3:0] shift_in ;
  // assgin target = 4'b1010;
  always_ff @( posedge clk ) begin
    if(!resetn)begin
      // dout <= '0;
      shift_in <= '0;
    end else begin
      shift_in <= (shift_in << 1) | din;
    end
  end

  assign dout = (shift_in == target);
endmodule
