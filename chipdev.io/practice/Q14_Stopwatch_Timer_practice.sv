/*
 * Q14 — Stopwatch Timer
 *
 * Implement a synchronous stopwatch counter with start and stop controls.
 * - reset is an active-high synchronous reset with the highest priority. Clear count and
 *   return to the stopped state.
 * - When stop=1, stop counting. stop has priority over start.
 * - After receiving a start pulse, continue incrementing on every clock even after start returns to 0.
 * - After receiving a stop pulse, hold the current count until the next start.
 * - After count reaches MAX, wrap to 0 on the next update.
 */
module stopwatch_timer #(parameter DATA_WIDTH=16, MAX=99)
  (input  logic                  clk,
   input  logic                  reset,
   input  logic                  start,
   input  logic                  stop,
   output logic [DATA_WIDTH-1:0] count);

  // TODO: Implement your design here.
  typedef enum logic {
    STOP = 1'b0,
    START = 1'b1
  } fsm;

  fsm state, next_state;

  always_ff @( posedge clk ) begin
    if(reset)begin
      count <= '0;
      state <= STOP;
    end else begin
      state <= next_state;
      if(next_state == START) begin
        if(count == MAX) count <= '0;
        else count <= count + 1'b1;
      // else count <= count;
      end
    end
    
  end


  always_comb begin 
    next_state = state;
    // case (state)
      
    // endcase
    if(stop)begin
      next_state = STOP;
    end else if(start)begin
      next_state = START;
    end
  end
endmodule
