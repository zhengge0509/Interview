`timescale 1ns/1ps
`include "tb_check.svh"
module onehot_detector_tb;
  localparam int W=32;logic [W-1:0] din;logic onehot,expected;
  onehot_detector #(.DATA_WIDTH(W)) dut(.*);
  task automatic check(input logic [W-1:0] value);
    din=value;expected=(value!=0)&&((value&(value-1))==0);#1;`CHECK_EQ("one-hot classification",onehot,expected);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,onehot_detector_tb);
    check(0);check('1);check(32'h80000001);check(32'hAAAAAAAA);
    for(int i=0;i<W;i++)check(32'(1)<<i);
    `TEST_PASS("Q13");$finish;
  end
endmodule
