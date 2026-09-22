/*
 * Q07 — Parallel-In Serial-Out Shift Register
 *
 * Design a DATA_WIDTH-bit parallel-in, serial-out (PISO) shift register.
 * - resetn is an active-low synchronous reset. Clear the internal register and dout on reset.
 * - On a rising edge with din_en=1, load din in parallel.
 * - When din_en=0, shift the stored data right by one bit on each rising edge.
 * - dout presents the current least-significant bit, so data is transmitted LSB first.
 * - If din_en remains high, reload the current value of din on every cycle.
 */
module PISO_shift_register #(parameter DATA_WIDTH=16)
  (input  logic                  clk,
   input  logic                  resetn,
   input  logic [DATA_WIDTH-1:0] din,
   input  logic                  din_en,
   output logic                  dout);


  // TODO: Implement your design here.
  logic [DATA_WIDTH-1:0] data;
  always_ff @(posedge clk) begin 
    if(!resetn) begin
      dout <= '0; 
      data <= '0;
    end else begin
      if(din_en)begin
        dout <= din[0];
        data <= din >> 1;
      end else begin
        dout <= data[0];
        data <= data >> 1;
      end    
    end
  end
endmodule
