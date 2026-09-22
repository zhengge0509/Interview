/*
 * Q35 — APB3/APB4 Register Slave
 *
 * Implement a zero-wait-state APB slave containing four 32-bit read/write registers at byte
 * addresses 8'h00, 8'h04, 8'h08, and 8'h0C.
 * - PRESETn is an active-low synchronous reset that clears all four registers.
 * - APB setup phase: PSEL=1 and PENABLE=0. Do not modify state during setup.
 * - APB access phase: PSEL=1 and PENABLE=1. Assert PREADY during every access phase.
 * - Complete writes only during an access phase with PWRITE=1. PSTRB[i] updates byte i;
 *   bytes with a deasserted strobe retain their previous values.
 * - For reads, drive PRDATA with the addressed register value.
 * - Valid addresses must be word aligned and one of the four addresses listed above.
 * - During an access to an invalid or unaligned address, assert PSLVERR and perform no write.
 * - Outside an access phase, drive PREADY=0 and PSLVERR=0. PRDATA may be 0.
 */
module apb_register_slave (
  input  logic        PCLK,
  input  logic        PRESETn,
  input  logic        PSEL,
  input  logic        PENABLE,
  input  logic        PWRITE,
  input  logic [7:0]  PADDR,
  input  logic [31:0] PWDATA,
  input  logic [3:0]  PSTRB,
  output logic [31:0] PRDATA,
  output logic        PREADY,
  output logic        PSLVERR
);

  // TODO: Implement your design here.

endmodule

