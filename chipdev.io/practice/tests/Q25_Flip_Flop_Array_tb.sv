`timescale 1ns/1ps
`include "tb_check.svh"
module flip_flop_array_tb;
  logic[7:0]din=0,dout;logic[2:0]addr=0;logic wr=0,rd=0,clk=0,resetn=0,error;
  flip_flop_array dut(.*);always #5 clk=~clk;
  task automatic op(input bit w,r,input logic[2:0]ad,input logic[7:0]data,input logic[7:0]exp_out,input bit exp_err,string tag);
    @(negedge clk);wr=w;rd=r;addr=ad;din=data;@(posedge clk);#1;`CHECK_EQ({tag," data"},dout,exp_out);`CHECK_EQ({tag," error"},error,exp_err);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,flip_flop_array_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset data",dout,0);`CHECK_EQ("reset error",error,0);@(negedge clk);resetn=1;
    op(0,1,3,0,0,0,"unwritten read");op(1,0,3,8'hA5,0,0,"write address 3");op(0,1,3,0,8'hA5,0,"read address 3");
    op(1,0,7,8'hFF,0,0,"write last address");op(1,1,3,8'h11,0,1,"simultaneous read/write");op(0,1,3,0,8'hA5,0,"error did not alter memory");
    op(0,0,0,0,0,0,"NOP clears outputs");
    @(negedge clk);resetn=0;@(posedge clk);#1;`CHECK_EQ("reset clears data",dout,0);@(negedge clk);resetn=1;op(0,1,3,0,0,0,"reset clears written state");
    `TEST_PASS("Q25");$finish;
  end
endmodule
