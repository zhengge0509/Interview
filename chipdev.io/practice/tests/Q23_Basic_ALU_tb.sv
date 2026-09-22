`timescale 1ns/1ps
`include "tb_check.svh"
module basic_alu_tb;
  localparam int W=4;logic[W-1:0]a,b,a_plus_b,a_minus_b,not_a,a_and_b,a_or_b,a_xor_b;
  basic_alu #(.DATA_WIDTH(W)) dut(.*);
  task automatic check(input logic[W-1:0]av,bv);
    a=av;b=bv;#1;`CHECK_EQ("addition (truncated)",a_plus_b,W'(a+b));`CHECK_EQ("subtraction (wrap)",a_minus_b,W'(a-b));
    `CHECK_EQ("bitwise NOT",not_a,~a);`CHECK_EQ("bitwise AND",a_and_b,a&b);`CHECK_EQ("bitwise OR",a_or_b,a|b);`CHECK_EQ("bitwise XOR",a_xor_b,a^b);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,basic_alu_tb);
    for(int av=0;av<(1<<W);av++)for(int bv=0;bv<(1<<W);bv++)check(av[W-1:0],bv[W-1:0]);
    `TEST_PASS("Q23");$finish;
  end
endmodule
