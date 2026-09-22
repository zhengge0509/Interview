/*
 * Q10 — Population Count
 *
 * Count the number of bits set to 1 in din and drive the count on dout.
 * - This is combinational logic; no clock or reset is required.
 * - When din=0, dout=0. When every bit of din is 1, dout=DATA_WIDTH.
 * - The original output interface is preserved as [$clog2(DATA_WIDTH):0].
 */
module counting_ones #(parameter DATA_WIDTH=16)
  (input  logic [DATA_WIDTH-1:0]       din,
   output logic [$clog2(DATA_WIDTH):0] dout);

  // TODO: Implement your design here.
  logic [DATA_WIDTH -1 :0]mask = 1;
  logic [$clog2(DATA_WIDTH):0] count;
  always_comb begin
    count = 0;
    for(int i =0; i< DATA_WIDTH ; i++)begin
      if(din[i]) count = count +1;
    end
    dout = count;
  end
endmodule
