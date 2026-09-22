/*
 * Q17 — Streaming Divisible-by-5 Detector
 *
 * din is an MSB-first serial binary stream. Append one bit on every rising edge of clk and
 * determine whether the complete binary number received so far is divisible by 5.
 * - Drive dout=1 for a divisible value and dout=0 otherwise.
 * - resetn is an active-low synchronous reset. Clear the received value and set dout=0.
 * - For example, the input sequence 1,1,1,1 forms decimal 15; dout should be 1 after the final bit.
 * - Track only the remainder modulo 5 rather than storing the complete number.
 */
module divisible_by_5
  (input  logic clk,
   input  logic resetn,
   input  logic din,
   output logic dout);

  // TODO: Implement your design here.
  typedef enum [2:0] {  
    IDLE = 3'b000,
    REM0 = 3'b001,
    REM1 = 3'b010,
    REM2 = 3'b011,
    REM3 = 3'b100,
    REM4 = 3'b101
  } fsm;

  fsm state, next_state;
  always_ff @(posedge clk) begin
    if(!resetn) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

always_comb begin
  next_state = state;
  case(state)
    IDLE : next_state = (din) ? REM1 : REM0;
    REM0 : next_state = (din) ? REM1 : REM0;
    REM1 : next_state = (din) ? REM3 : REM2;
    REM2 : next_state = (din) ? REM0 : REM4;
    REM3 : next_state = (din) ? REM2 : REM1;
    REM4 : next_state = (din) ? REM4 : REM3;
    default : next_state = IDLE;
  endcase
end
assign dout = (state == REM0);

endmodule
