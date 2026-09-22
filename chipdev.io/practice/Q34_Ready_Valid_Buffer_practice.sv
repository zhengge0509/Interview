/*
 * Q34 — One-Entry Ready/Valid Elastic Buffer
 *
 * Implement a one-entry buffer between an upstream ready/valid producer and a downstream consumer.
 * - resetn is an active-low synchronous reset. After reset, out_valid=0.
 * - An input transfer occurs on a rising edge when in_valid && in_ready.
 * - An output transfer occurs on a rising edge when out_valid && out_ready.
 * - Once out_valid=1, out_data must remain stable while out_ready=0.
 * - The buffer must support one transfer per clock after filling. If the current output is consumed
 *   while a new input is valid, replace it on the same edge without inserting a bubble.
 * - Apply backpressure by deasserting in_ready only when the stored item cannot be replaced safely.
 * - Do not drop, duplicate, or reorder data.
 */
module ready_valid_buffer #(
  parameter int DATA_WIDTH = 32
) (
  input  logic                  clk,
  input  logic                  resetn,
  input  logic                  in_valid,
  output logic                  in_ready,
  input  logic [DATA_WIDTH-1:0] in_data,
  output logic                  out_valid,
  input  logic                  out_ready,
  output logic [DATA_WIDTH-1:0] out_data
);

  // TODO: Implement your design here.

endmodule

