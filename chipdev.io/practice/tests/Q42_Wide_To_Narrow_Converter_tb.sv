`timescale 1ns/1ps
`include "tb_check.svh"
module wide_to_narrow_converter_tb;
  localparam int IN_WIDTH=32, OUT_WIDTH=8;
  logic clk=0,resetn=0,in_valid=0,in_ready;
  logic [IN_WIDTH-1:0] in_data=0;
  logic out_valid,out_ready=0,out_last;
  logic [OUT_WIDTH-1:0] out_data;

  wide_to_narrow_converter #(.IN_WIDTH(IN_WIDTH),.OUT_WIDTH(OUT_WIDTH)) dut (.*);
  always #5 clk=~clk;

  task automatic load(input logic [31:0] word);
    @(negedge clk);in_valid=1;in_data=word;#1;
    `CHECK_EQ("converter input ready",in_ready,1);
    @(posedge clk);#1;@(negedge clk);in_valid=0;
  endtask

  task automatic check_beat(input logic [7:0] expected,input logic expected_last);
    #1;
    `CHECK_EQ("converter output valid",out_valid,1);`CHECK_EQ("converter output data",out_data,expected);`CHECK_EQ("converter output last",out_last,expected_last);
  endtask

  initial begin
    logic [31:0] a=32'h44332211,b=32'hAABBCCDD;
    $dumpfile("dump.vcd");$dumpvars(0,wide_to_narrow_converter_tb);
    repeat(2)@(posedge clk);#1 resetn=1;
    load(a);
    for(int i=0;i<4;i++)begin
      @(negedge clk);out_ready=0;check_beat(a[i*8+:8],i==3);
      if(i==1)begin
        repeat(2)begin @(posedge clk);#1;`CHECK_EQ("stalled beat data",out_data,8'h22);`CHECK_EQ("stalled beat last",out_last,0);end
        @(negedge clk);
      end
      out_ready=1;
      if(i==3)begin in_valid=1;in_data=b;#1;`CHECK_EQ("same-cycle input ready",in_ready,1);end
      check_beat(a[i*8+:8],i==3);@(posedge clk);#1;
    end
    `CHECK_EQ("next word valid",out_valid,1);`CHECK_EQ("next word first beat",out_data,8'hDD);`CHECK_EQ("next word first last",out_last,0);
    @(negedge clk);in_valid=0;
    for(int i=0;i<4;i++)begin
      out_ready=1;check_beat(b[i*8+:8],i==3);@(posedge clk);#1;if(i<3)@(negedge clk);
    end
    `CHECK_EQ("converter idle valid",out_valid,0);`CHECK_EQ("converter idle ready",in_ready,1);
    `TEST_PASS("Q42");
    $finish;
  end
endmodule
