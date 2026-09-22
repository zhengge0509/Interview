/*
 * Q02 — Second Largest
 *
 * Accept one unsigned din value on every rising edge of clk. Continuously track the
 * largest and second-largest values observed, and drive the second-largest value on dout.
 * - resetn is an active-low synchronous reset. Reset both tracked values to 0.
 * - If a new din is greater than the current largest value, the old largest value becomes second largest.
 * - Otherwise, if din is greater than the current second-largest value, update the second-largest value.
 * - Under the reference behavior, duplicate values may occupy both positions; this is not
 *   the second-largest distinct value.
 */
module second_largest #(parameter DATA_WIDTH = 32)
  (
    input  logic [DATA_WIDTH-1:0] din,
    input  logic                  clk,
    input  logic                  resetn,
    output logic [DATA_WIDTH-1:0] dout
   );

  // TODO: Implement your design here.
    logic [DATA_WIDTH-1:0] first, second;
    always_ff @(posedge clk) begin
      if(!resetn)begin
        // d_out <= '0;
        first <= '0;
        second <= '0;
      end else begin
        if(din > first) begin
          second <= first;
          first <= din;
        end
        else if (din > second && din <= first)begin
          second <= din;
        end

      end
    end
    assign dout = second;
endmodule
