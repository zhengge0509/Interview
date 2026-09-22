/*
 * Q13 — One-Hot Detector
 *
 * Determine whether exactly one bit of din is set to 1.
 * - Exactly one set bit: onehot=1.
 * - No set bits or two or more set bits: onehot=0.
 * - This is combinational logic.
 */
module onehot_detector #(parameter DATA_WIDTH=32)
  (input  logic [DATA_WIDTH-1:0] din,
   output logic                  onehot);

  // TODO: Implement your design here.
  logic flag, not_first_one;
  //My design is to use for loop to check from LSB, the "flag" is 1'b0 at first, if there is
  //There is a faster logic is that if(din!=0 && (din & (din-1'b1)==0) 
  always_comb begin 
    flag = '0;
    not_first_one='0;
    onehot = '0;
    for(int i =0; i<DATA_WIDTH ; i++)begin
      if(din[i])begin
        if(flag)begin
          not_first_one = 1'b1;
        end
        flag = 1'b1;
      end
    end
    if(flag && !not_first_one)onehot = 1'b1;
    
  end

endmodule
