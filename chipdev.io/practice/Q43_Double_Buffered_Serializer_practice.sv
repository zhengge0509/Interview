/*
 * Q43 — Double-Buffered Serializer
 *
 * Serialize DATA_WIDTH-bit words LSB first with a ready/valid input and ready/valid one-bit output.
 * Internally provide capacity for two complete words: one active word and one pending word.
 * - resetn is an active-low synchronous reset. Clear both buffered-word valid states.
 * - Accept a word on in_valid && in_ready whenever either internal slot is available.
 * - out_valid indicates that an active bit is available. Advance only on out_valid && out_ready.
 * - Hold out_bit and out_last stable during output backpressure.
 * - Assert out_last with each word's final bit.
 * - A pending word may be accepted while the active word is still being serialized.
 * - When the active word completes and a pending word exists, begin the pending word on the next
 *   cycle with no out_valid bubble.
 * - Correctly handle simultaneous input acceptance, final-bit consumption, and pending-to-active
 *   promotion. Preserve input word order without loss or duplication.
 */
module double_buffered_serializer #(
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

