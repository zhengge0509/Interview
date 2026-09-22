`timescale 1ns/1ps
`include "tb_check.svh"
module edge_detector_tb;
  logic clk=0,resetn=0,din=0,dout;edge_detector dut(.*);always #5 clk=~clk;
  task automatic sample(input logic value,input logic expected);
    @(negedge clk);din=value;@(posedge clk);#1;`CHECK_EQ("rising-edge pulse",dout,expected);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,edge_detector_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset output",dout,0);
    @(negedge clk);resetn=1;
    sample(0,0);sample(1,1);sample(1,0);sample(1,0);sample(0,0);sample(1,1);sample(0,0);
    @(negedge clk);resetn=0;din=1;@(posedge clk);#1;`CHECK_EQ("reset priority",dout,0);
    @(negedge clk);resetn=1;@(posedge clk);#1;`CHECK_EQ("high input after reset",dout,1);
    `TEST_PASS("Q06");$finish;
  end
endmodule

