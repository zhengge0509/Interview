/*
 * Q45 — Round-Robin Two-Source Serializer
 *
 * Arbitrate between two ready/valid input sources and serialize each accepted WORD_WIDTH-bit word
 * LSB first onto one ready/valid output stream.
 * - resetn is an active-low synchronous reset. After reset, source 0 has arbitration priority.
 * - When idle, accept at most one source. If both are valid, choose according to round-robin priority.
 * - After accepting a word, remain committed to that source until all WORD_WIDTH bits are transferred.
 *   Bits from different words must never interleave.
 * - Assert out_source throughout a word to identify its source, and assert out_last with its final bit.
 * - Advance only on out_valid && out_ready. Hold out_bit, out_source, and out_last stable on a stall.
 * - After completing a word from source i, give the other source priority at the next arbitration.
 * - Input ready signals may assert only for the source selected for acceptance. This version may
 *   insert one idle cycle between words; same-cycle refill is not required.
 */
module two_source_serializer #(
  parameter int WORD_WIDTH = 8
) (
  input  logic                  clk,
  input  logic                  resetn,
  input  logic                  s0_valid,
  output logic                  s0_ready,
  input  logic [WORD_WIDTH-1:0] s0_data,
  input  logic                  s1_valid,
  output logic                  s1_ready,
  input  logic [WORD_WIDTH-1:0] s1_data,
  output logic                  out_valid,
  input  logic                  out_ready,
  output logic                  out_bit,
  output logic                  out_last,
  output logic                  out_source
);

  // TODO: Implement your design here.

endmodule

