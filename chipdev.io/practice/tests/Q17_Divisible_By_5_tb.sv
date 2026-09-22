`timescale 1ns/1ps
`include "tb_check.svh"
module divisible_by_5_tb;
  logic clk=0,resetn=0,din=0,dout;int remainder=0;logic [19:0] bits=20'hD2A5F;
  divisible_by_5 dut(.*);always #5 clk=~clk;
  task automatic send(input bit value);
    @(negedge clk);din=value;@(posedge clk);#1;remainder=(remainder*2+value)%5;`CHECK_EQ("binary prefix divisible by 5",dout,remainder==0);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,divisible_by_5_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset output",dout,0);@(negedge clk);resetn=1;
    for(int i=19;i>=0;i--)send(bits[i]);send(0);send(1);send(0);
    @(negedge clk);resetn=0;@(posedge clk);#1;remainder=0;`CHECK_EQ("reset remainder",dout,0);
    `TEST_PASS("Q17");$finish;
  end
endmodule
