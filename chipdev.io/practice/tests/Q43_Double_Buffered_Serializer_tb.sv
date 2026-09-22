`timescale 1ns/1ps
`include "tb_check.svh"
module double_buffered_serializer_tb;
  localparam int DATA_WIDTH=8;
  logic clk=0,resetn=0,in_valid=0,in_ready;
  logic [DATA_WIDTH-1:0] in_data=0;
  logic out_valid,out_ready=0,out_bit,out_last;

  double_buffered_serializer #(.DATA_WIDTH(DATA_WIDTH)) dut (.*);
  always #5 clk=~clk;

  task automatic push_word(input logic [7:0] word);
    @(negedge clk);in_valid=1;in_data=word;#1;
    `CHECK_EQ("double buffer input ready",in_ready,1);
    @(posedge clk);#1;@(negedge clk);in_valid=0;
  endtask

  task automatic consume_bit(input logic expected,input logic expected_last);
    out_ready=1;#1;
    `CHECK_EQ("double buffer output valid",out_valid,1);`CHECK_EQ("double buffer output bit",out_bit,expected);`CHECK_EQ("double buffer output last",out_last,expected_last);
    @(posedge clk);#1;@(negedge clk);
  endtask

  initial begin
    logic [7:0] a=8'hA5,b=8'h3C,c=8'h81;
    $dumpfile("dump.vcd");$dumpvars(0,double_buffered_serializer_tb);
    repeat(2)@(posedge clk);#1 resetn=1;

    push_word(a);
    push_word(b); // Accepted while A is active.
    #1;`CHECK_EQ("both slots occupied ready",in_ready,0);

    // Stall A bit 0 and verify stability.
    out_ready=0;#1;
    `CHECK_EQ("A active valid",out_valid,1);`CHECK_EQ("A active bit",out_bit,a[0]);
    repeat(2)begin @(posedge clk);#1;`CHECK_EQ("stalled A bit",out_bit,a[0]);`CHECK_EQ("stalled A valid",out_valid,1);end
    @(negedge clk);

    for(int i=0;i<DATA_WIDTH;i++) consume_bit(a[i],i==DATA_WIDTH-1);
    `CHECK_EQ("A-to-B valid",out_valid,1);`CHECK_EQ("A-to-B first bit",out_bit,b[0]);

    // B is active, so the pending slot is available for C.
    out_ready=0;
    push_word(c);
    for(int i=0;i<DATA_WIDTH;i++) consume_bit(b[i],i==DATA_WIDTH-1);
    `CHECK_EQ("B-to-C valid",out_valid,1);`CHECK_EQ("B-to-C first bit",out_bit,c[0]);
    for(int i=0;i<DATA_WIDTH;i++) consume_bit(c[i],i==DATA_WIDTH-1);

    `CHECK_EQ("double buffer idle valid",out_valid,0);`CHECK_EQ("double buffer idle ready",in_ready,1);
    `TEST_PASS("Q43");
    $finish;
  end
endmodule
