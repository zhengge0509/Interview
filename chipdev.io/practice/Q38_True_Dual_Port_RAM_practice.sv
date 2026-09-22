/*
 * Q38 — True Dual-Port Synchronous RAM
 *
 * Implement a parameterized memory with two symmetric ports sharing one clock.
 * - Each port has its own enable, write enable, address, write data, and registered read data.
 * - resetn is an active-low synchronous reset for rdata_a, rdata_b, and collision. The memory
 *   contents do not need to reset.
 * - On a rising edge with en_x=1, port x reads its addressed old memory value into rdata_x.
 * - On the same edge, if we_x=1, port x also writes wdata_x. This is read-first behavior.
 * - The two ports may read or write different addresses simultaneously.
 * - If both ports write the same address in one cycle, assert collision and suppress both writes;
 *   both read outputs still receive the old value.
 * - Otherwise collision=0 and all enabled operations complete normally.
 */
module true_dual_port_ram #(
  parameter int DATA_WIDTH = 32,
  parameter int ADDR_WIDTH = 4
) (
  input  logic                  clk,
  input  logic                  resetn,
  input  logic                  en_a,
  input  logic                  we_a,
  input  logic [ADDR_WIDTH-1:0] addr_a,
  input  logic [DATA_WIDTH-1:0] wdata_a,
  output logic [DATA_WIDTH-1:0] rdata_a,
  input  logic                  en_b,
  input  logic                  we_b,
  input  logic [ADDR_WIDTH-1:0] addr_b,
  input  logic [DATA_WIDTH-1:0] wdata_b,
  output logic [DATA_WIDTH-1:0] rdata_b,
  output logic                  collision
);

  // TODO: Implement your design here.

endmodule

