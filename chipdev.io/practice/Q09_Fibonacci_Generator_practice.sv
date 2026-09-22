/*
 * Q09 — Fibonacci Generator
 *
 * Generate the Fibonacci sequence, advancing once per clock cycle.
 * - resetn is an active-low synchronous reset. Set dout=1 on reset.
 * - After reset is released, the outputs are 1, 2, 3, 5, 8, 13, ... . This can be modeled
 *   with the internal initial values previous=0 and current=1, followed by an update each cycle.
 * - Arithmetic is limited to DATA_WIDTH bits; overflow may be truncated naturally.
 */
module fibonacci_generator #(parameter DATA_WIDTH=32)
  (input  logic                  clk,
   input  logic                  resetn,
   output logic [DATA_WIDTH-1:0] dout);

  // TODO: Implement your design here.
  logic [DATA_WIDTH-1:0] previous, current;
  always_ff @( posedge clk ) begin
    if(!resetn)begin
      dout <= 1;
      previous <= '0;
      current <= 1;
    end else begin
      dout <= previous + current;
      previous <= current;
      current <= previous + current;
    end

  end
endmodule
