/*
 * Q36 — Clock-Domain-Crossing Pulse Synchronizer
 *
 * Transfer a one-cycle pulse from src_clk to an unrelated dst_clk domain. A source pulse may be
 * shorter than one dst_clk period, so synchronizing the pulse level directly is not sufficient.
 * - src_resetn and dst_resetn are active-low asynchronous resets for their respective domains.
 * - Convert each accepted src_pulse event into persistent state in the source domain, synchronize
 *   that state through at least two destination-domain flip-flops, and recreate a one-cycle dst_pulse.
 * - Each source pulse must produce exactly one destination pulse: no loss, duplication, or stretching.
 * - dst_pulse must be asserted for exactly one dst_clk cycle.
 * - Assume consecutive source pulses are separated by enough time for the previous event to cross
 *   and be observed in the destination domain. No acknowledgment channel is required.
 * - Mark synchronizer registers appropriately for CDC/synthesis tools when supported.
 */
module cdc_pulse_synchronizer (
  input  logic src_clk,
  input  logic src_resetn,
  input  logic src_pulse,
  input  logic dst_clk,
  input  logic dst_resetn,
  output logic dst_pulse
);

  // TODO: Implement your design here.

endmodule

