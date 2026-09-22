/*
 * Q20 — Divide-by-Even Clock Divider
 *
 * Generate three synchronous, approximately 50% duty-cycle divided clocks from clk:
 * div2, div4, and div6.
 * - resetn is an active-low synchronous reset. All three outputs are 0 after reset.
 * - div2 toggles after every input cycle, producing a period of 2 cycles.
 * - div4 remains low for 2 cycles and high for 2 cycles, producing a period of 4 cycles.
 * - div6 remains low for 3 cycles and high for 3 cycles, producing a period of 6 cycles.
 * - Output phase must match the behavior described above, beginning low after reset.
 */
module divide_by_evens_clock_divider
  (input  logic clk,
   input  logic resetn,
   output logic div2,
   output logic div4,
   output logic div6);

  // TODO: Implement your design here.
  logic [1:0] counter_4, count4_first;
  logic [2:0] counter_6;
  logic first;

  always_ff @(posedge clk) begin
    if(!resetn)begin
      div2 <= '0;
      div4 <= '0;
      div6 <= '0;
      counter_4 <= '0;
      counter_6 <= '0;
      count4_first <= '0;
      first <= '0;
    end else begin
      counter_4 <= counter_4 + 1'b1;
      counter_6 <= counter_6 + 1'b1;
      if(!first) count4_first  <= count4_first + 1'b1; first <= 1'b1;
      if(count4_first == 2'd1)first <= 1'b1;
      div2 <= !div2;

      if(counter_4 == 2'd2)begin
        counter_4 <= 2'd1;
        div4 <= !div4;
      end
      else if(counter_4 == 2'd0)begin
        div4 <= !div4;
      end 


      if(counter_6 == 3'd3)begin
        counter_6 <= 3'd1;
        div6 <= !div6;
      end 
      else if(counter_6 == 3'd0)begin
        div6 <= !div4;
      end
    end
  end

endmodule
