/*
 * Q16 — Streaming Divisible-by-3 Detector
 *
 * din is an MSB-first serial binary stream. Append one bit on every rising edge of clk and
 * determine whether the complete binary number received so far is divisible by 3.
 * - Drive dout=1 for a divisible value and dout=0 otherwise.
 * - resetn is an active-low synchronous reset. Clear the received value and set dout=0.
 * - For example, the input sequence 1,0,0,1 represents the prefixes 1, 2, 4, and 9;
 *   dout should be 1 after the final bit.
 * - A modulo-remainder FSM may be used; storing an indefinitely growing number is unnecessary.
 */
module divisible_by_3
  (input  logic clk,
   input  logic resetn,
   input  logic din,
   output logic dout);

  // TODO: Implement your design here.
  typedef enum logic [1:0] {
    REM0 = 2'b00,
    REM1 = 2'b01,
    REM2 = 2'b10,
    IDLE = 2'b11
  } fsm;

  fsm state, next_state;
  always_ff @( posedge clk ) begin
    if(!resetn)begin
      // dout <= '0;
      state <= IDLE;
    end else begin 
      state <= next_state;
      // if(next_state == REM0) dout <= 1'b1;
      // else dout <= 1'b0;
    end
  end
  
  always_comb begin
    next_state = state;
    case (state)
      REM0: next_state = (din)? REM1 : REM0; 
      REM1: next_state = (din)? REM0 : REM2;
      REM2: next_state = (din)? REM2 : REM1;
      IDLE: next_state = (din)? REM1 : REM0;
      default: next_state = REM0;
    endcase
    // if(next_state == REM0)dout = 1'b1;
  end
  assign dout = (state == REM0);
endmodule
