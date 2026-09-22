`timescale 1ns/1ps
`include "tb_check.svh"
module two_source_serializer_tb;
  localparam int WORD_WIDTH=8;
  logic clk=0,resetn=0;
  logic s0_valid=0,s0_ready;logic [WORD_WIDTH-1:0] s0_data=0;
  logic s1_valid=0,s1_ready;logic [WORD_WIDTH-1:0] s1_data=0;
  logic out_valid,out_ready=0,out_bit,out_last,out_source;

  two_source_serializer #(.WORD_WIDTH(WORD_WIDTH)) dut (.*);
  always #5 clk=~clk;

  task automatic consume_word(input logic [7:0] word,input logic source);
    for(int i=0;i<WORD_WIDTH;i++)begin
      @(negedge clk);out_ready=1;#1;
      `CHECK_EQ("two-source output valid",out_valid,1);`CHECK_EQ("two-source output bit",out_bit,word[i]);
      `CHECK_EQ("two-source output last",out_last,i==WORD_WIDTH-1);`CHECK_EQ("two-source ID",out_source,source);
      if(i==2)begin
        out_ready=0;
        repeat(2)begin @(posedge clk);#1;
          `CHECK_EQ("stalled source bit",out_bit,word[i]);`CHECK_EQ("stalled source ID",out_source,source);`CHECK_EQ("stalled source last",out_last,i==WORD_WIDTH-1);
        end
        @(negedge clk);out_ready=1;
      end
      @(posedge clk);#1;
    end
    @(negedge clk);out_ready=0;
  endtask

  initial begin
    logic [7:0] a=8'hA5,b=8'h3C,c=8'h81;
    $dumpfile("dump.vcd");$dumpvars(0,two_source_serializer_tb);
    repeat(2)@(posedge clk);#1 resetn=1;

    // Both request simultaneously; source 0 has reset priority.
    @(negedge clk);s0_valid=1;s0_data=a;s1_valid=1;s1_data=b;#1;
    `CHECK_EQ("reset priority s0 ready",s0_ready,1);`CHECK_EQ("reset priority s1 ready",s1_ready,0);
    @(posedge clk);#1;@(negedge clk);s0_valid=0;
    consume_word(a,0);

    // Source 1 remained valid and must win the next idle arbitration.
    #1;`CHECK_EQ("next priority s1 ready",s1_ready,1);`CHECK_EQ("next priority s0 ready",s0_ready,0);
    @(posedge clk);#1;@(negedge clk);s1_valid=0;
    consume_word(b,1);

    // After source 1, simultaneous requests must favor source 0 again.
    @(negedge clk);s0_valid=1;s0_data=c;s1_valid=1;s1_data=8'hFF;#1;
    `CHECK_EQ("returned priority s0 ready",s0_ready,1);`CHECK_EQ("returned priority s1 ready",s1_ready,0);
    @(posedge clk);#1;@(negedge clk);s0_valid=0;s1_valid=0;
    consume_word(c,0);

    `CHECK_EQ("two-source idle valid",out_valid,0);
    `TEST_PASS("Q45");
    $finish;
  end
endmodule
