/*
 * Q12 — Count Trailing Zeroes
 *
 * Count the number of consecutive zeros in din, starting at the LSB.
 * - This is combinational logic.
 * - Stop counting at the first 1; higher bits do not affect the result.
 * - If din is all zeros, dout must equal DATA_WIDTH.
 * - The original output interface is preserved as [$clog2(DATA_WIDTH):0].
 */
module trailing_zeroes #(parameter DATA_WIDTH=32)
  (input  logic [DATA_WIDTH-1:0]       din,
   output logic [$clog2(DATA_WIDTH):0] dout);

  // TODO: Implement your design here.
  logic [$clog2(DATA_WIDTH):0]count,max,left,right;

  always_comb begin
    // count = '0;
    max = '0;
    left='0;
    right='0;
    for(int k =0 ; k < DATA_WIDTH ; k++)begin
      if(!din[k])begin
        left = left +1;
      end else begin
        left = k;
        right = k;
        // max = 
      end
      max = (left - right > max) ? (left - right) : max;
    end
    // if(left == 32 && right == 0) dout = 32;
    dout = max;
  end
endmodule
