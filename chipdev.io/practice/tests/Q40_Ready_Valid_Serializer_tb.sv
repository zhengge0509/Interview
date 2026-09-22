`timescale 1ns/1ps
`include "tb_check.svh"
module ready_valid_serializer_tb;
  localparam int DATA_WIDTH = 8;
  logic clk=0, resetn=0, in_valid=0, in_ready;
  logic [DATA_WIDTH-1:0] in_data=0;
  logic out_valid, out_ready=0, out_bit, out_last;

  ready_valid_serializer #(.DATA_WIDTH(DATA_WIDTH)) dut (.*);
  always #5 clk=~clk;

  task automatic load_word(input logic [7:0] word);
    @(negedge clk); in_valid=1; in_data=word; #1;
    `CHECK_EQ("serializer input ready",in_ready,1);
    @(posedge clk); #1;
    @(negedge clk); in_valid=0;
  endtask

  task automatic check_current(input logic bit_value,input logic last_value);
    #1;
    `CHECK_EQ("serial output valid",out_valid,1);`CHECK_EQ("serial output bit",out_bit,bit_value);`CHECK_EQ("serial output last",out_last,last_value);
  endtask

  initial begin
    logic [7:0] a=8'b1011_0010;
    logic [7:0] b=8'b0101_1101;
    $dumpfile("dump.vcd"); $dumpvars(0,ready_valid_serializer_tb);
    repeat(2) @(posedge clk); #1 resetn=1;
    `CHECK_EQ("reset input ready",in_ready,1);`CHECK_EQ("reset output valid",out_valid,0);

    load_word(a);
    for(int i=0;i<DATA_WIDTH;i++) begin
      @(negedge clk);
      out_ready=0;
      check_current(a[i],i==DATA_WIDTH-1);
      if(i==2) begin
        repeat(2) begin
          @(posedge clk); #1;
          `CHECK_EQ("stalled output bit",out_bit,a[i]);`CHECK_EQ("stalled output last",out_last,i==DATA_WIDTH-1);
          @(negedge clk);
        end
      end
      out_ready=1;
      if(i==DATA_WIDTH-1) begin
        in_valid=1; in_data=b; #1;
        `CHECK_EQ("ready on final transfer",in_ready,1);
      end
      check_current(a[i],i==DATA_WIDTH-1);
      @(posedge clk); #1;
    end

    `CHECK_EQ("replacement valid",out_valid,1);`CHECK_EQ("replacement first bit",out_bit,b[0]);`CHECK_EQ("replacement last",out_last,0);
    @(negedge clk); in_valid=0;

    for(int i=0;i<DATA_WIDTH;i++) begin
      out_ready=1; check_current(b[i],i==DATA_WIDTH-1);
      @(posedge clk); #1;
      if(i<DATA_WIDTH-1) @(negedge clk);
    end
    `CHECK_EQ("idle output valid",out_valid,0);`CHECK_EQ("idle input ready",in_ready,1);
    `TEST_PASS("Q40");
    $finish;
  end
endmodule
