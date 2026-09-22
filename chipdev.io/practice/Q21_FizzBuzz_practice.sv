/*
 * Q21 — FizzBuzz Counter
 *
 * Build a synchronous counter that cycles from 0 through MAX_CYCLES-1 and reports its
 * divisibility status.
 * - resetn is an active-low synchronous reset. Set the counter to 0 on reset.
 * - Increment on every rising edge of clk and wrap to 0 after MAX_CYCLES-1.
 * - Assert fizz when the counter is divisible by FIZZ.
 * - Assert buzz when the counter is divisible by BUZZ.
 * - Assert fizzbuzz when both conditions hold; fizz and buzz must also remain asserted.
 * - By the mathematical convention used here, counter=0 is divisible by both values.
 */
module fizzbuzz #(parameter FIZZ=2, BUZZ=3, MAX_CYCLES=20)
  (input  logic clk,
   input  logic resetn,
   output logic fizz,
   output logic buzz,
   output logic fizz_buzz
   );

  // TODO: Implement your design here.
  logic [$clog2(MAX_CYCLES)+1:0] counter;
  logic [$clog2(FIZZ)+1:0] counter4_fizz;
  logic [$clog2(BUZZ)+1:0] counter4_buzz;
  always_ff @( posedge clk ) begin : blockName
    if(!resetn)begin
      fizz <= '1;
      buzz <= '1;
      fizz_buzz <= '1;
      counter4_buzz <= 'd1;
      counter4_fizz <= 'd1;
      counter <='d1;
    end else begin
      counter4_fizz <= counter4_fizz + 1'b1;
      counter4_buzz <= counter4_buzz + 1'b1;
      counter <= counter + 1'b1;
      if(counter == MAX_CYCLES)begin
        counter4_buzz <= 'd1; buzz <= 1'b1;
        counter4_fizz <= 'd1; fizz <= 'd1;
        fizz_buzz <= 1'b1;
        counter <= 'd1;
      end else begin
        // for(int i =0 ; i< MAX_CYCLES -1 ; i++)begin

          // if(counter4_buzz == '0) buzz <= 1'b1;
          if (counter4_buzz == BUZZ) begin
            counter4_buzz <= 'd1; buzz <= 1'b1;
          end
          else buzz <= 1'b0;

          // if(counter4_fizz == '0) fizz <= 1'b1; 
          if (counter4_fizz == FIZZ)begin
            counter4_fizz <= 'd1; fizz <= 'd1;
          end 
          else fizz <= 1'b0;

          if(counter4_buzz == BUZZ && counter4_fizz == FIZZ)fizz_buzz <= 1'b1;
          else fizz_buzz <= 1'b0;
        // end
      end
    end
  end
endmodule
