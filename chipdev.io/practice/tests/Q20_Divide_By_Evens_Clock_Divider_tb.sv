`timescale 1ns/1ps
`include "tb_check.svh"
module divide_by_evens_clock_divider_tb;
  logic clk=0,resetn=0,div2,div4,div6;int count=0;
  divide_by_evens_clock_divider dut(.*);always #5 clk=~clk;
  task automatic check_outputs(string tag);
    `CHECK_EQ({tag," div2"},div2,(count%2)==1);`CHECK_EQ({tag," div4"},div4,((count%4)==1)||((count%4)==2));
    `CHECK_EQ({tag," div6"},div6,((count%6)>=1)&&((count%6)<=3));
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,divide_by_evens_clock_divider_tb);
    repeat(2)@(posedge clk);#1;check_outputs("reset");@(negedge clk);resetn=1;
    repeat(24)begin @(posedge clk);#1;count++;check_outputs("divider phase");end
    @(negedge clk);resetn=0;@(posedge clk);#1;count=0;check_outputs("midrun reset");
    `TEST_PASS("Q20");$finish;
  end
endmodule
