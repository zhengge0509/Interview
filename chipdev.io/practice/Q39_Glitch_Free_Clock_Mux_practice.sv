/*
 * Q39 — Glitch-Free Clock Multiplexer
 *
 * Select between two unrelated free-running clocks without producing a runt pulse or overlapping
 * clock enables.
 * - resetn is an active-low asynchronous reset. While reset is asserted, clk_out must remain low.
 * - sel=0 selects clk0; sel=1 selects clk1.
 * - A selection change may take multiple source-clock edges to complete. Extra latency is allowed.
 * - Disable the currently selected clock only during a safe low phase, and enable the other clock
 *   only after the first clock is disabled.
 * - clk_out may pause during switching, but it must never contain a pulse shorter than the normal
 *   high or low phase of the contributing source clock.
 * - Do not implement this as a plain combinational ternary mux on the clock signals.
 * - In a production ASIC/FPGA flow, discuss when a dedicated library/FPGA clock-control primitive
 *   should be used instead of inferred RTL.
 */
module glitch_free_clock_mux (
  input  logic clk0,
  input  logic clk1,
  input  logic resetn,
  input  logic sel,
  output logic clk_out
);

  // TODO: Implement your design here.

endmodule

