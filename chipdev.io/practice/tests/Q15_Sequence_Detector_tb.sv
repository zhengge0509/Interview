`timescale 1ns/1ps
`include "tb_check.svh"
module sequence_detector_tb;
  logic clk=0,resetn=0,din=0,dout;logic [3:0] history=0;
  sequence_detector dut(.*);always #5 clk=~clk;
  task automatic send(input bit value,string tag);
    @(negedge clk);din=value;@(posedge clk);#1;history={history[2:0],value};`CHECK_EQ(tag,dout,history==4'b1010);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,sequence_detector_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset output",dout,0);@(negedge clk);resetn=1;
    send(1,"prefix 1");send(0,"prefix 10");send(1,"prefix 101");send(0,"first 1010");
    send(1,"overlap prefix 101");send(0,"overlapping 1010");send(0,"non-match");send(1,"non-match");
    @(negedge clk);resetn=0;@(posedge clk);#1;history=0;`CHECK_EQ("midstream reset",dout,0);
    `TEST_PASS("Q15");$finish;
  end
endmodule
