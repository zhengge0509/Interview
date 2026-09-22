/*
 * Q40 — Ready/Valid Bit Serializer
 *
 * Convert each DATA_WIDTH-bit input word into a one-bit-per-cycle serial stream using ready/valid
 * handshakes on both sides. Serialize LSB first.
 * - resetn is an active-low synchronous reset. After reset, out_valid=0 and in_ready=1.
 * - Accept an input word only on a rising edge where in_valid && in_ready.
 * - Present one bit with out_valid=1. Advance only when out_valid && out_ready.
 * - While out_valid=1 and out_ready=0, out_bit and out_last must remain stable.
 * - Assert out_last together with the final bit of each word.
 * - While transmitting non-final bits, deassert in_ready so the active word cannot be overwritten.
 * - On a cycle where the final output bit is accepted, allow a new input word to be accepted on
 *   the same edge. The next word must begin on the following cycle without an invalid bubble.
 * - Do not drop, duplicate, or reorder bits.
 */
module ready_valid_serializer #(
  parameter int DATA_WIDTH = 8
) (
  input  logic                  clk,
  input  logic                  resetn,
  input  logic                  in_valid,
  output logic                  in_ready,
  input  logic [DATA_WIDTH-1:0] in_data,
  output logic                  out_valid,
  input  logic                  out_ready,
  output logic                  out_bit,
  output logic                  out_last
);

  // TODO: Implement your design here.

endmodule

