/*
 * Q42 — Wide-to-Narrow Ready/Valid Width Converter
 *
 * Convert each IN_WIDTH-bit input transfer into IN_WIDTH/OUT_WIDTH narrower output beats.
 * IN_WIDTH must be an integer multiple of OUT_WIDTH.
 * - resetn is an active-low synchronous reset. After reset, out_valid=0 and in_ready=1.
 * - Accept a wide word on in_valid && in_ready.
 * - Transmit the least-significant OUT_WIDTH-bit chunk first, followed by increasing chunks.
 * - Assert out_last with the final chunk of each input word.
 * - Advance only on out_valid && out_ready. Hold out_data and out_last stable during backpressure.
 * - While transmitting a non-final chunk, deassert in_ready.
 * - Allow a new input word on the same edge that accepts the previous word's final output chunk,
 *   so consecutive words can be converted without an invalid output bubble.
 */
module wide_to_narrow_converter #(
  parameter int IN_WIDTH = 32,
  parameter int OUT_WIDTH = 8
) (
  input  logic                 clk,
  input  logic                 resetn,
  input  logic                 in_valid,
  output logic                 in_ready,
  input  logic [IN_WIDTH-1:0]  in_data,
  output logic                 out_valid,
  input  logic                 out_ready,
  output logic [OUT_WIDTH-1:0] out_data,
  output logic                 out_last
);

  // TODO: Implement your design here.

endmodule

