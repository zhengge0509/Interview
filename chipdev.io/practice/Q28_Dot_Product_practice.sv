/*
 * Q28 — Streaming Dot Product
 *
 * Receive two unsigned vectors A and B, each of length 3, sequentially through one 8-bit din.
 * - resetn is an active-low synchronous reset. Clear all stored data and the result.
 * - On the first three active clocks after reset, receive A[0], A[1], and A[2], in that order.
 * - On the next three clocks, receive B[0], B[1], and B[2], in that order.
 * - After receiving B[2], compute dout=A0*B0+A1*B1+A2*B2 and begin collecting the next A vector.
 * - Each product is 16 bits, and the sum of three products is returned in the 18-bit dout.
 * - run is 0 while collecting data and 1 during reset and when a dot product is completed.
 */
module dot_product
  (input  logic [7:0]  din,
   input  logic        clk,
   input  logic        resetn,
   output logic [17:0] dout,
   output logic        run);

  // TODO: Implement your design here.
  logic [7:0] a_arr [0:3];
  logic [7:0] b_arr [0:3];
  logic [2:0] counter;
  always_ff @( posedge clk ) begin
    if(!resetn)begin
      for(int i =0 ; i < 3 ; i++)begin
        a_arr[0] <= '0;
        b_arr[0] <= '0;
        run <= 1'b1;
        counter <= '0;
      end
    end else begin
      if(counter < 3'd5)begin
        if(counter <= 'd2)begin
          a_arr[counter] = din;
        end else begin
          b_arr[counter - 'd3] <= din; 
        end
        counter <= counter + 1'b1;
        run <= '0;
      end else if(counter == 'd5)begin
        counter <= '0;
        run <= 1'b1;
        dout <= a_arr[0] * b_arr[0] + a_arr[1] * b_arr[1] + a_arr[2] * din;
      end



    end    
  end
endmodule
