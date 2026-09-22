`timescale 1ns/1ps
`include "tb_check.svh"
module dot_product_tb;
  logic[7:0]din=0;logic clk=0,resetn=0;logic[17:0]dout;logic run;
  dot_product dut(.*);always #5 clk=~clk;
  task automatic word(input logic[7:0]value,input bit exp_run,string tag);
    @(negedge clk);din=value;@(posedge clk);#1;`CHECK_EQ({tag," run"},run,exp_run);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,dot_product_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset result",dout,0);`CHECK_EQ("reset ready/run",run,1);resetn=1;
    word(1,0,"A0");word(2,0,"A1");word(3,0,"A2");word(4,0,"B0");word(5,0,"B1");word(6,1,"B2 completes");`CHECK_EQ("first dot product",dout,32);
    word(8'hFF,0,"next A0");word(8'hFF,0,"next A1");word(8'hFF,0,"next A2");word(8'hFF,0,"next B0");word(8'hFF,0,"next B1");word(8'hFF,1,"next B2");
    `CHECK_EQ("maximum dot product",dout,18'(3*255*255));
    `TEST_PASS("Q28");$finish;
  end
endmodule
