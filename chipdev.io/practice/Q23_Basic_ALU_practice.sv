/*
 * Q23 — Basic ALU
 *
 * Given two DATA_WIDTH-bit inputs a and b, compute all six combinational results simultaneously:
 * - a_plus_b: a+b
 * - a_minus_b: a-b
 * - not_a: bitwise NOT a
 * - a_and_b, a_or_b, and a_xor_b: the corresponding bitwise operations
 * Every output is exactly DATA_WIDTH bits, so addition overflow and subtraction underflow are truncated.
 */
module basic_alu #(parameter DATA_WIDTH=4)
  (input  logic [DATA_WIDTH-1:0] a,
   input  logic [DATA_WIDTH-1:0] b,
   output logic [DATA_WIDTH-1:0] a_plus_b,
   output logic [DATA_WIDTH-1:0] a_minus_b,
   output logic [DATA_WIDTH-1:0] not_a,
   output logic [DATA_WIDTH-1:0] a_and_b,
   output logic [DATA_WIDTH-1:0] a_or_b,
   output logic [DATA_WIDTH-1:0] a_xor_b);

  // TODO: Implement your design here.
  assign a_plus_b = a + b ;
  assign a_minus_b = a-b;
  assign not_a = ~a;
  assign a_and_b = a & b;
  assign a_or_b = a | b;
  assign a_xor_b = a ^ b;
endmodule
