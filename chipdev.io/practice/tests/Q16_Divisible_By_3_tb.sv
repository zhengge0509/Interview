`timescale 1ns/1ps
`include "tb_check.svh"
module divisible_by_3_tb;
  logic clk=0,resetn=0,din=0,dout;int remainder=0;logic [15:0] bits=16'h9C36;
  divisible_by_3 dut(.*);always #5 clk=~clk;
  task automatic send(input bit value);
    @(negedge clk);din=value;@(posedge clk);#1;remainder=(remainder*2+value)%3;`CHECK_EQ("binary prefix divisible by 3",dout,remainder==0);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,divisible_by_3_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset output",dout,0);@(negedge clk);resetn=1;
    for(int i=15;i>=0;i--)send(bits[i]);
    send(0);send(0);send(1);
    @(negedge clk);resetn=0;@(posedge clk);#1;remainder=0;`CHECK_EQ("reset remainder",dout,0);
    `TEST_PASS("Q16");$finish;
  end
endmodule
