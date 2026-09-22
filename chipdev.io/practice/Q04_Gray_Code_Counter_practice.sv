/*
 * Q04 — Gray Code Counter
 *
 * Design a DATA_WIDTH-bit Gray-code counter.
 * - resetn is an active-low synchronous reset. On reset, out=0 and the next count starts at 1.
 * - On every non-reset rising edge of clk, convert the incrementing binary count to Gray code.
 * - Consecutive Gray-code values should differ by exactly one bit.
 * - The supplied test resets before overflow. The reference RTL stops incrementing at the
 *   maximum binary value.
 */
module gray_code_generator #(parameter DATA_WIDTH = 4)
  (input  logic                  clk,
   input  logic                  resetn,
   output logic [DATA_WIDTH-1:0] out);

  // TODO: Implement your design here.
  // the function of gray code is graycode(i) = i XOR (i >> 1)
  logic [DATA_WIDTH-1:0] count;
  always_ff @( posedge clk ) begin
    if(!resetn)begin
      count <= {{{DATA_WIDTH-1}{1'b0}}, 1'b1};
      out <= '0;
    end
    else begin
      out <= count ^ (count >> 1);
      count <= count + 1'b1;
    end
  end
endmodule
