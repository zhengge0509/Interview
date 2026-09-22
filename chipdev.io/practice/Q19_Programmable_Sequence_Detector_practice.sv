/*
 * Q19 — Programmable Sequence Detector
 *
 * Detect a programmable 5-bit pattern in the serial input din.
 * - resetn is an active-low synchronous reset. Clear the shift history and valid-bit count.
 * - Capture init on the first rising edge after reset is released. Later changes to init must
 *   not affect the captured target.
 * - Shift din into a 5-bit history on every cycle. seen cannot assert until at least five bits arrive.
 * - Assert seen whenever the five most recent bits equal the target. Overlapping matches are allowed.
 * - According to the supplied testbench, capture the first din bit on the same edge that captures init.
 */
module programmable_sequence_detector
  (input  logic       clk,
   input  logic       resetn,
   input  logic [4:0] init,
   input  logic       din,
   output logic       seen);

  // TODO: Implement your design here.
  logic [4:0] history,target;
  logic [2:0] count;
  logic five_bits;

  always_ff @( posedge clk ) begin
    if(!resetn)begin
      // seen <= '0;
      target <= '0;
      history <= '0;
      count  <= '0;
      // five_bits <= '0;
    end else begin
      // if(count == 3'd5)begin
      //   five_bits = 1'b1;
      // end
      if(!five_bits && count <= 3'd5)begin
        count <= count + 1;
      end 
      if(count == 3'd0)begin
        target <= init;
      end
      history <= (history << 1) | {4'd0, din};
    end
  end
  assign seen = (five_bits && history == target);
  assign five_bits = (count == 3'd5);
endmodule
