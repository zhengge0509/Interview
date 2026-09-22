`timescale 1ns/1ps
`include "tb_check.svh"
module multi_bit_fifo_tb;
  logic clk=0,resetn=0,wr=0;logic[7:0]din=0,dout;logic empty,full;
  multi_bit_fifo #(.DATA_WIDTH(8)) dut(.*);always #5 clk=~clk;
  task automatic push(input logic[7:0]value,input logic[7:0]exp_out,input bit exp_full,string tag);
    @(negedge clk);wr=1;din=value;@(posedge clk);#1;`CHECK_EQ({tag," oldest"},dout,exp_out);`CHECK_EQ({tag," empty"},empty,0);`CHECK_EQ({tag," full"},full,exp_full);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,multi_bit_fifo_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset dout",dout,0);`CHECK_EQ("reset empty",empty,1);`CHECK_EQ("reset full",full,0);@(negedge clk);resetn=1;
    push(8'h11,8'h11,0,"first push");push(8'h22,8'h11,0,"second push");push(8'h33,8'h11,1,"fill depth three");
    @(negedge clk);wr=0;din=8'hEE;@(posedge clk);#1;`CHECK_EQ("idle holds oldest",dout,8'h11);`CHECK_EQ("idle stays full",full,1);
    push(8'h44,8'h22,1,"full overwrites oldest");push(8'h55,8'h33,1,"second full overwrite");
    @(negedge clk);resetn=0;wr=0;@(posedge clk);#1;`CHECK_EQ("reset after full",dout,0);`CHECK_EQ("reset empty flag",empty,1);
    `TEST_PASS("Q26");$finish;
  end
endmodule
