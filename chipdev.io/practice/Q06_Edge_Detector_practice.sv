/*
 * Q06 — Rising Edge Detector
 *
 * Detect 0-to-1 transitions on din in the clk domain.
 * - When din first changes from low to high, assert dout for exactly one clock cycle.
 * - Do not generate repeated pulses while din remains high. din must return low before
 *   another rising edge can be detected.
 * - resetn is an active-low synchronous reset with priority over din. Set dout=0 on reset.
 */
module edge_detector
  (input  logic clk,
   input  logic resetn,
   input  logic din,
   output logic dout);

  // TODO: Implement your design here.
  logic din_past;
  // assign din_past = din;
  always_ff @( posedge clk ) begin 
    if(!resetn)begin
      dout <= '0;
      din_past <= din;
    end else begin
      dout <= 1'b0;
      if(~din_past && din)begin
        dout <= ~dout;
      end
      din_past <= din;
    end
  end
endmodule
