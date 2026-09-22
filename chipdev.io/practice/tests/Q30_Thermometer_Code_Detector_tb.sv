`timescale 1ns/1ps
`include "tb_check.svh"
module thermometer_code_detector_tb;
  localparam int W=8;logic[W-1:0]codeIn;logic isThermometer,expected;int transitions;
  thermometer_code_detector #(.DATA_WIDTH(W)) dut(.*);
  task automatic check(input logic[W-1:0]value);
    codeIn=value;transitions=0;for(int i=1;i<W;i++)if(value[i]!=value[i-1])transitions++;expected=(transitions==1);#1;
    `CHECK_EQ("thermometer validity",isThermometer,expected);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,thermometer_code_detector_tb);
    for(int v=0;v<(1<<W);v++)check(v[W-1:0]);
    `TEST_PASS("Q30");$finish;
  end
endmodule
