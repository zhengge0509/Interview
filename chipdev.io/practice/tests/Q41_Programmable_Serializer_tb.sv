`timescale 1ns/1ps
`include "tb_check.svh"
module programmable_serializer_tb;
  localparam int MAX_WIDTH=16;
  localparam int LENGTH_WIDTH=$clog2(MAX_WIDTH+1);
  logic clk=0,resetn=0,start=0,lsb_first=1,bit_enable=0;
  logic [MAX_WIDTH-1:0] data=0;
  logic [LENGTH_WIDTH-1:0] length=0;
  logic serial_out,valid,busy,done;

  programmable_serializer #(.MAX_WIDTH(MAX_WIDTH)) dut (.*);
  always #5 clk=~clk;

  task automatic start_transfer(input logic [15:0] d,input int len,input logic lsb);
    @(negedge clk); start=1; data=d; length=len; lsb_first=lsb;
    @(posedge clk); #1;
    @(negedge clk); start=0;
  endtask

  task automatic consume_and_expect(input logic expected);
    #1;
    `CHECK_EQ("serializer valid",valid,1);`CHECK_EQ("serializer busy",busy,1);`CHECK_EQ("serializer bit",serial_out,expected);
    bit_enable=1;
    @(posedge clk); #1;
    @(negedge clk);
  endtask

  initial begin
    logic [15:0] lsb_word=16'b0000_0000_0001_0110;
    logic [15:0] msb_word=16'b0000_0000_0000_1101;
    $dumpfile("dump.vcd"); $dumpvars(0,programmable_serializer_tb);
    repeat(2) @(posedge clk); #1 resetn=1;

    bit_enable=0;
    start_transfer(lsb_word,5,1);
    `CHECK_EQ("LSB start valid",valid,1);`CHECK_EQ("LSB start busy",busy,1);`CHECK_EQ("LSB first bit",serial_out,lsb_word[0]);
    repeat(2) begin
      @(posedge clk); #1;
      `CHECK_EQ("disabled bit stable",serial_out,lsb_word[0]);`CHECK_EQ("disabled valid stable",valid,1);
    end

    // Attempted start while busy must be ignored.
    @(negedge clk); start=1; data=16'hFFFF; length=16; bit_enable=0;
    @(posedge clk); #1;
    @(negedge clk); start=0;
    `CHECK_EQ("busy start ignored",serial_out,lsb_word[0]);

    for(int i=0;i<5;i++) consume_and_expect(lsb_word[i]);
    `CHECK_EQ("LSB completion busy",busy,0);`CHECK_EQ("LSB completion valid",valid,0);`CHECK_EQ("LSB completion done",done,1);
    @(posedge clk); #1; `CHECK_EQ("LSB done pulse width",done,0);

    bit_enable=1;
    start_transfer(msb_word,4,0);
    for(int i=3;i>=0;i--) consume_and_expect(msb_word[i]);
    `CHECK_EQ("MSB completion done",done,1);`CHECK_EQ("MSB completion busy",busy,0);`CHECK_EQ("MSB completion valid",valid,0);

    bit_enable=0;
    start_transfer(16'hABCD,0,1);
    `CHECK_EQ("zero length done",done,1);`CHECK_EQ("zero length busy",busy,0);`CHECK_EQ("zero length valid",valid,0);
    @(posedge clk); #1; `CHECK_EQ("zero length done pulse width",done,0);

    `TEST_PASS("Q41");
    $finish;
  end
endmodule
