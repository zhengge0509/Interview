/*
 * Q29 — Binary to Thermometer Decoder
 *
 * Convert the unsigned 8-bit din into a 256-bit thermometer code.
 * - The lowest din+1 bits of dout are 1; all remaining upper bits are 0.
 * - Therefore, din=0 -> dout[0]=1; din=3 -> dout[3:0]=4'b1111; and
 *   din=255 -> all 256 bits are 1.
 * - This is combinational logic.
 */
module binary_to_thermometer_decoder
  (input  logic [7:0]   din,
   output logic [255:0] dout);

  // TODO: Implement your design here.
  always_comb begin
    for(int i =0; i < 256 ; i++)begin
      if(i <= din)begin
        dout[i] = 1'b1;
      end else begin
        dout[i] = 1'b0;
      end
    end
    
  end
endmodule
