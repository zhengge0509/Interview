/*
 * Q24 — Ripple-Carry Adder
 *
 * Build a DATA_WIDTH-bit ripple-carry adder using only chained 1-bit full adders.
 * - a and b are unsigned DATA_WIDTH-bit inputs. The least-significant stage has carry-in=0.
 * - sum is DATA_WIDTH+1 bits wide; its MSB is the final carry-out.
 * - cout_int[i] exposes the carry-out of full-adder stage i.
 * - The focus is structural/generate connectivity rather than directly writing a wide a+b expression.
 */
module full_adder
  (input  logic x,
   input  logic y,
   input  logic cin,
   output logic sum_fa,
   output logic cout_fa);

  // TODO: Implement the 1-bit full adder.
  assign sum_fa = x ^ y ^ cin;
  assign cout_fa = (x & y) | ((x ^ y)&cin);

endmodule

module ripple_carry_adder #(parameter DATA_WIDTH=8)
  (input  logic [DATA_WIDTH-1:0] a,
   input  logic [DATA_WIDTH-1:0] b,
   output logic [DATA_WIDTH:0]   sum,
   output logic [DATA_WIDTH-1:0] cout_int);

  // TODO: Chain DATA_WIDTH full_adder instances.
  logic [DATA_WIDTH:0]carry;
  assign carry[0] = 1'b0;
  generate
    for(genvar i = 0 ; i < DATA_WIDTH ; i++)begin
      full_adder fa(
        .x (a[i]),
        .y (b[i]),
        .cin (carry[i]),
        .sum_fa (sum[i]),
        .cout_fa (carry[i+1])
      );
    end 
  endgenerate

  assign sum[DATA_WIDTH] = carry[DATA_WIDTH];
  assign cout_int = carry[DATA_WIDTH:1];

endmodule



//         a[0] b[0]        a[1] b[1]        a[2] b[2]        a[3] b[3]
//           │    │           │    │           │    │           │    │
//           ▼    ▼           ▼    ▼           ▼    ▼           ▼    ▼
// cin=0 ──► FA0 ──c[0]────► FA1 ──c[1]────► FA2 ──c[2]────► FA3 ──c[3]
//            │                │                │                │
//          sum[0]           sum[1]           sum[2]           sum[3]