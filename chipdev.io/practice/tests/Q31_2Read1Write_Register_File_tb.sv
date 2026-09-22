`timescale 1ns/1ps
`include "tb_check.svh"
module tworead1write_register_file_tb;
  localparam int W=16;logic clk=0,resetn=0;logic[W-1:0]din=0,dout1,dout2;logic[$clog2(W):0]wad1=0,rad1=0,rad2=0;logic wen1=0,ren1=0,ren2=0,collision;
  tworead1write_register_file #(.DATA_WIDTH(W)) dut(.*);always #5 clk=~clk;
  task automatic op(input bit w,r1,r2,input int wa,ra1,ra2,input logic[W-1:0]data,input logic[W-1:0]e1,e2,input bit ec,string tag);
    @(negedge clk);wen1=w;ren1=r1;ren2=r2;wad1=wa;rad1=ra1;rad2=ra2;din=data;@(posedge clk);#1;
    `CHECK_EQ({tag," dout1"},dout1,e1);`CHECK_EQ({tag," dout2"},dout2,e2);`CHECK_EQ({tag," collision"},collision,ec);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,tworead1write_register_file_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset dout1",dout1,0);`CHECK_EQ("reset dout2",dout2,0);`CHECK_EQ("reset collision",collision,0);@(negedge clk);resetn=1;
    op(0,1,1,0,2,31,0,0,0,0,"unwritten dual read");op(1,0,0,2,0,0,16'h2222,0,0,0,"write address 2");op(1,0,0,31,0,0,16'hF00D,0,0,0,"write address 31");
    op(0,1,1,0,2,31,0,16'h2222,16'hF00D,0,"two distinct reads");op(0,0,0,0,0,0,0,0,0,0,"NOP clears outputs");
    op(1,1,0,2,2,0,16'hAAAA,0,0,1,"write/read1 collision");op(0,1,0,0,2,0,0,16'h2222,0,0,"collision suppresses write");
    op(0,1,1,0,31,31,0,0,0,1,"read/read collision");op(1,1,1,7,2,31,16'h7777,16'h2222,16'hF00D,0,"three distinct operations");
    op(1,0,1,31,0,31,16'hAAAA,0,0,1,"write/read2 collision");op(0,1,0,0,7,0,0,16'h7777,0,0,"verify prior legal write");
    @(negedge clk);resetn=0;@(posedge clk);#1;`CHECK_EQ("final reset",dout1,0);`CHECK_EQ("final reset collision",collision,0);
    `TEST_PASS("Q31");$finish;
  end
endmodule
