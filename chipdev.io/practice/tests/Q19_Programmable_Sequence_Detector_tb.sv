`timescale 1ns/1ps
`include "tb_check.svh"
module programmable_sequence_detector_tb;
  logic clk=0,resetn=0,din=0,seen;logic [4:0]init=5'b10101,target,history=0;int count=0;
  programmable_sequence_detector dut(.*);always #5 clk=~clk;
  task automatic send(input bit value,string tag);
    @(negedge clk);din=value;@(posedge clk);#1;
    if(count==0)target=init;history={history[3:0],value};count++;
    `CHECK_EQ(tag,seen,(count>=5)&&(history==target));
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,programmable_sequence_detector_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset seen",seen,0);@(negedge clk);resetn=1;
    send(1,"capture init and bit 1");init=5'b00000;send(0,"init change ignored");send(1,"partial target");send(0,"partial target");send(1,"first match");
    send(0,"overlap progress");send(1,"overlap progress");send(0,"overlap progress");send(1,"overlap match");
    @(negedge clk);resetn=0;@(posedge clk);#1;history=0;count=0;`CHECK_EQ("reset clears history",seen,0);
    `TEST_PASS("Q19");$finish;
  end
endmodule
