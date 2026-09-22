`timescale 1ns/1ps
`include "tb_check.svh"
module PISO_shift_register_tb;
  localparam int DATA_WIDTH=16;logic clk=0,resetn=0,din_en=0,dout;logic [DATA_WIDTH-1:0] din=0;
  PISO_shift_register #(.DATA_WIDTH(DATA_WIDTH)) dut(.*);always #5 clk=~clk;
  task automatic load(input logic [DATA_WIDTH-1:0] word);
    @(negedge clk);din_en=1;din=word;@(posedge clk);#1;`CHECK_EQ("load outputs bit 0",dout,word[0]);
  endtask
  task automatic shift_expect(input logic expected);
    @(negedge clk);din_en=0;din=$urandom;@(posedge clk);#1;`CHECK_EQ("serial output bit",dout,expected);
  endtask
  initial begin
    logic [15:0] a=16'hB2A5,b=16'h0003;
    $dumpfile("dump.vcd");$dumpvars(0,PISO_shift_register_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset serial output",dout,0);@(negedge clk);resetn=1;
    load(a);for(int i=1;i<DATA_WIDTH;i++)shift_expect(a[i]);shift_expect(0);
    load(16'hFFFF);load(b);for(int i=1;i<DATA_WIDTH;i++)shift_expect(b[i]);
    @(negedge clk);resetn=0;@(posedge clk);#1;`CHECK_EQ("reset during transfer",dout,0);
    `TEST_PASS("Q07");$finish;
  end
endmodule

