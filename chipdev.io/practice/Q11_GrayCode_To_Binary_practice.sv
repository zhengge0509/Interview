/*
 * Q11 — Gray Code to Binary
 *
 * Convert the DATA_WIDTH-bit Gray code input gray into the binary output bin.
 * - This is combinational logic.
 * - The MSB remains unchanged. Each remaining binary bit can be obtained by XORing
 *   the preceding higher binary bit with the current Gray-code bit.
 * - Assign every output bit for every possible input to avoid inferring a latch.
 */
module graycode_to_binary #(parameter DATA_WIDTH=16)
  (input  logic [DATA_WIDTH-1:0] gray,
   output logic [DATA_WIDTH-1:0] bin);

  // TODO: Implement your design here.

endmodule
