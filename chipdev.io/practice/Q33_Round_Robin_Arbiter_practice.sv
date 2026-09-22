/*
 * Q33 — Parameterized Round-Robin Arbiter
 *
 * Arbitrate among N requesters using fair round-robin priority.
 * - req[i]=1 means requester i is asking for service.
 * - grant must be one-hot or all zero and must never grant an inactive requester.
 * - resetn is an active-low synchronous reset. After reset, requester 0 has the highest priority.
 * - If at least one request is active, grant the first active requester found while scanning from
 *   the current priority pointer and wrapping from N-1 back to 0.
 * - After granting requester i, the next arbitration starts at requester (i+1) modulo N.
 * - If no request is active, grant=0 and the priority pointer must not move.
 * - A requester that remains asserted must not starve while other requesters are also active.
 */
module round_robin_arbiter #(
  parameter int N = 4
) (
  input  logic         clk,
  input  logic         resetn,
  input  logic [N-1:0] req,
  output logic [N-1:0] grant
);

  // TODO: Implement your design here.

endmodule

