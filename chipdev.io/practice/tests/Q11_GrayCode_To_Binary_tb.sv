`timescale 1ns/1ps
`include "tb_check.svh"
module graycode_to_binary_tb;
  localparam int W=16; logic [W-1:0] gray,bin; logic [W-1:0] expected;
  graycode_to_binary #(.DATA_WIDTH(W)) dut(.*);
  task automatic check(input logic [W-1:0] value);
    gray=value^(value>>1); expected=value; #1; `CHECK_EQ("Gray-to-binary conversion",bin,expected);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,graycode_to_binary_tb);
    check('0);check('1);check(16'h8000);check(16'h5555);check(16'hAAAA);
    for(int i=0;i<256;i++)check(i[W-1:0]);
    `TEST_PASS("Q11");$finish;
  end
endmodule
