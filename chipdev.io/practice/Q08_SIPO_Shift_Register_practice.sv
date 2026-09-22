/*
 * Q08 — Serial-In Parallel-Out Shift Register
 *
 * Design a DATA_WIDTH-bit serial-in, parallel-out (SIPO) shift register.
 * - resetn is an active-low synchronous reset. Set dout=0 on reset.
 * - On every rising edge of clk, shift the old contents toward the MSB and place din in bit 0.
 * - The equivalent update is: new_value = (old_value << 1) plus din.
 * - dout continuously presents the complete shift-register contents.
 */
module SIPO_shift_register #(parameter DATA_WIDTH=16)
  (input  logic                  clk,
   input  logic                  resetn,
   input  logic                  din,
   output logic [DATA_WIDTH-1:0] dout);

  // TODO: Implement your design here.
  always_ff @( posedge clk ) begin : blockName
    if(!resetn)begin
      dout <= '0;
    end else begin
      dout <= (dout << 1) | din;
      // dout[0] <= din;
    end    
  end

endmodule
