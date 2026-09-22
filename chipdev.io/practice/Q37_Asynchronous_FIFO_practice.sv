/*
 * Q37 — Asynchronous FIFO with Gray-Code Pointers
 *
 * Design a dual-clock FIFO that safely transfers data from wr_clk to rd_clk.
 * DEPTH is 2**ADDR_WIDTH.
 * - wr_resetn and rd_resetn are active-low asynchronous resets in their respective clock domains.
 * - Accept a write on a wr_clk rising edge when wr_en && !full.
 * - Accept a read on an rd_clk rising edge when rd_en && !empty; update rd_data with the popped word.
 * - Generate full entirely in the write domain and empty entirely in the read domain.
 * - Do not pass multi-bit binary pointers directly between clock domains. Cross Gray-coded pointers
 *   through at least two synchronizer stages, then compare them using standard asynchronous-FIFO rules.
 * - Include an extra pointer bit to distinguish equal-address full and empty conditions.
 * - Never overwrite unread data, return stale data as a successful read, or create combinational paths
 *   between the two clock domains.
 */
module asynchronous_fifo #(
  parameter int DATA_WIDTH = 8,
  parameter int ADDR_WIDTH = 3
) (
  input  logic                  wr_clk,
  input  logic                  wr_resetn,
  input  logic                  wr_en,
  input  logic [DATA_WIDTH-1:0] wr_data,
  output logic                  full,
  input  logic                  rd_clk,
  input  logic                  rd_resetn,
  input  logic                  rd_en,
  output logic [DATA_WIDTH-1:0] rd_data,
  output logic                  empty
);

  // TODO: Implement your design here.

endmodule

