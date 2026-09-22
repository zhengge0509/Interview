/*
 * Q30 — Thermometer Code Detector
 *
 * Determine whether codeIn is a valid thermometer code.
 * - A valid value must contain exactly one 0/1 transition between adjacent bits.
 * - Accept both 000...011...111 and the reverse form 111...100...000.
 * - All-zero and all-one values contain no transition and are invalid under this definition.
 * - A value with two or more transitions, such as 00110111, is invalid.
 * - This is combinational logic. Assert isThermometer for a valid code.
 */
module thermometer_code_detector #(parameter DATA_WIDTH=8)
  (input  logic [DATA_WIDTH-1:0] codeIn,
   output logic                  isThermometer);

  // TODO: Implement your design here.
  logic [$clog2(DATA_WIDTH)-1:0]trans_count;
  always_comb begin 
    trans_count = '0;
    for(int i=1; i< DATA_WIDTH ; i++)begin
      if(codeIn[i] != codeIn[i-1])begin
        trans_count = trans_count + 1'b1;
      end
    end
     if(trans_count == 'd1)isThermometer = 1'b1;
     else isThermometer = 1'b0;
  end
endmodule
