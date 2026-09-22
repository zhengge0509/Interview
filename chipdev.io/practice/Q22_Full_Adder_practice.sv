/*
 * Q22 — One-Bit Full Adder
 *
 * Implement a 1-bit full adder.
 * - The inputs are a, b, and cin.
 * - sum is the least-significant bit of the three-input addition.
 * - cout is the carry-out bit.
 * - This is combinational logic and must handle all eight input combinations correctly.
 */
module full_adder
  (input  logic a,
   input  logic b,
   input  logic cin,
   output logic sum,
   output logic cout);

  // TODO: Implement your design here.
  assign sum = (a & b & cin) | ((a ^ b) & ~cin) | (~a & ~b & cin);
  assign cout = (a & b) | ((a ^ b)&cin);


endmodule
