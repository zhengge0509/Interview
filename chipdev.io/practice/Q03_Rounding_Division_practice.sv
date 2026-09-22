/*
 * Q03 — Rounding Division
 *
 * Divide unsigned din by 2**DIV_LOG2, round the result to the nearest integer,
 * and drive the result on dout.
 * - Round exact half-way cases upward (round half up).
 * - OUT_WIDTH is the output width; IN_WIDTH defaults to OUT_WIDTH+DIV_LOG2.
 * - If the rounded result exceeds the maximum OUT_WIDTH value, saturate dout to all ones.
 * - This is combinational logic. The intended approach uses shifts and the low remainder bits,
 *   rather than a general-purpose divider.
 */
module rounding_division #(parameter
  DIV_LOG2=2,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input  logic [IN_WIDTH-1:0]  din,
  output logic [OUT_WIDTH-1:0] dout
);

  // TODO: Implement your design here.
  // if din is 1110, din/ 2**DIV_LOG2 = 1110 >> 2
  // assign dout = din >> DIV_LOG2;
  logic [DIV_LOG2 -1 :0] remainder;
  always_comb begin
    remainder = din[DIV_LOG2 -1:0];
    dout = din >> DIV_LOG2;
    if(remainder >= 2'b10 && dout < 32'hFFFFFFFF)begin
      dout = dout + 1'b1;
    end
    // if (dout == 32'hFFFFFFFF)
    
  end

endmodule
