/*
 * Q18 — Bit Palindrome Detector
 *
 * Determine whether the DATA_WIDTH-bit din reads identically from MSB to LSB and from LSB to MSB.
 * - Drive dout=1 when din equals its bit-reversed value; otherwise drive dout=0.
 * - This is combinational logic.
 * - All-zero and all-one values are also palindromes.
 */
module palindrome_detector #(parameter DATA_WIDTH=32)
  (input  logic [DATA_WIDTH-1:0] din,
   output logic                  dout);

  // TODO: Implement your design here.
  // logic false;
  // always_comb begin 
  //   false = 1'b0;
  //   for(int i = 0 ; i < DATA_WIDTH ; i++) begin
  //     if(din[i] != din[DATA_WIDTH - i - 1]) false = 1'b1;
  //     // else false = 1'b1;
  //   end 
  //   dout = (!false);
  // end
  assign dout = (din == {<<{din}});
endmodule
