/*
 * Q01 — Simple Router
 *
 * Design an enabled 1-to-4 combinational data router.
 * - When d_en=1, route din to exactly one output according to addr:
 *     2'b00 -> dout0, 2'b01 -> dout1, 2'b10 -> dout2, 2'b11 -> dout3
 * - Every unselected output must be 0.
 * - When d_en=0, all four outputs must be 0.
 * - No clock or reset is required. Outputs must update combinationally when an input changes.
 */
module simple_router #(parameter DATA_WIDTH=32)
  (input  logic [DATA_WIDTH-1:0] din,
   input  logic                  d_en,
   input  logic [1:0]            addr,
   output logic [DATA_WIDTH-1:0] dout0,
   output logic [DATA_WIDTH-1:0] dout1,
   output logic [DATA_WIDTH-1:0] dout2,
   output logic [DATA_WIDTH-1:0] dout3);

  // TODO: Implement your design here.
  always_comb begin 
    dout0 = (d_en & addr == 2'b00) ? din : '0;
    dout1 = (d_en & addr == 2'b01) ? din : '0;
    dout2 = (d_en & addr == 2'b10) ? din : '0;
    dout3 = (d_en & addr == 2'b11) ? din : '0;
  end

endmodule
