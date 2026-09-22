/*
 * Q05 — Reversing Bits
 *
 * Build combinational logic that completely reverses the bit order of din onto dout.
 * For every i: dout[DATA_WIDTH-1-i] = din[i].
 * Example: for DATA_WIDTH=8 and din=8'b1101_0000, dout=8'b0000_1011.
 */
module reversing_bits #(parameter DATA_WIDTH=32)
  (input  logic [DATA_WIDTH-1:0] din,
   output logic [DATA_WIDTH-1:0] dout);

  // TODO: Implement your design here.
  logic serial_bit;
  always_comb begin 
    for(int i = 0 ; i < DATA_WIDTH ; i++) begin
      serial_bit = din[i];
      dout[DATA_WIDTH-1-i] = serial_bit;
    end
    
  end
endmodule
