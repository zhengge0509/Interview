`timescale 1ns/1ps
`include "tb_check.svh"
module trailing_zeroes_tb;
  localparam int W=32; logic [W-1:0] din; logic [$clog2(W):0] dout; int expected;
  trailing_zeroes #(.DATA_WIDTH(W)) dut(.*);
  task automatic check(input logic [W-1:0] value);
    din=value; expected=W; for(int i=W-1;i>=0;i--)if(value[i])expected=i; #1;
    `CHECK_EQ("trailing-zero count",dout,expected);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,trailing_zeroes_tb);
    check(0);check(1);check(2);check(32'h80000000);check(32'hFFFFFFFF);check(32'hA5A50000);
    for(int i=0;i<W;i++)check(32'(1)<<i);
    `TEST_PASS("Q12");$finish;
  end
endmodule
