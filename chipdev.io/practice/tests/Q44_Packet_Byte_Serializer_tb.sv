`timescale 1ns/1ps
`include "tb_check.svh"
module packet_byte_serializer_tb;
  localparam int MAX_PAYLOAD_BYTES=4;
  localparam int LENGTH_WIDTH=$clog2(MAX_PAYLOAD_BYTES+1);
  logic clk=0,resetn=0,in_valid=0,in_ready;
  logic [15:0] header=0;
  logic [LENGTH_WIDTH-1:0] payload_length=0;
  logic [MAX_PAYLOAD_BYTES*8-1:0] payload=0;
  logic out_valid,out_ready=0,out_last;
  logic [7:0] out_byte;

  packet_byte_serializer #(.MAX_PAYLOAD_BYTES(MAX_PAYLOAD_BYTES)) dut (.*);
  always #5 clk=~clk;

  task automatic load_packet(input logic [15:0] h,input int len,input logic [31:0] p);
    @(negedge clk);in_valid=1;header=h;payload_length=len;payload=p;#1;
    `CHECK_EQ("packet input ready",in_ready,1);
    @(posedge clk);#1;@(negedge clk);in_valid=0;
  endtask

  task automatic consume_byte(input logic [7:0] expected,input logic expected_last);
    out_ready=1;#1;
    `CHECK_EQ("packet output valid",out_valid,1);`CHECK_EQ("packet output byte",out_byte,expected);`CHECK_EQ("packet output last",out_last,expected_last);
    @(posedge clk);#1;@(negedge clk);
  endtask

  initial begin
    logic [7:0] checksum_a,checksum_b;
    $dumpfile("dump.vcd");$dumpvars(0,packet_byte_serializer_tb);
    checksum_a=8'h12^8'h34^8'hA1^8'hB2^8'hC3;
    checksum_b=8'h55^8'h66;
    repeat(2)@(posedge clk);#1 resetn=1;

    load_packet(16'h1234,3,32'h00C3B2A1);
    consume_byte(8'hA5,0);
    consume_byte(8'h12,0);

    // Stall on the low header byte.
    out_ready=0;#1;
    `CHECK_EQ("pre-stall valid",out_valid,1);`CHECK_EQ("pre-stall byte",out_byte,8'h34);`CHECK_EQ("pre-stall last",out_last,0);
    repeat(2)begin @(posedge clk);#1;`CHECK_EQ("stalled packet byte",out_byte,8'h34);`CHECK_EQ("stalled packet last",out_last,0);end
    @(negedge clk);
    consume_byte(8'h34,0);
    consume_byte(8'hA1,0);
    consume_byte(8'hB2,0);
    consume_byte(8'hC3,0);

    // Accept a zero-payload packet on the checksum transfer edge.
    in_valid=1;header=16'h5566;payload_length=0;payload=0;out_ready=1;#1;
    `CHECK_EQ("checksum boundary ready",in_ready,1);`CHECK_EQ("checksum boundary byte",out_byte,checksum_a);`CHECK_EQ("checksum boundary last",out_last,1);
    @(posedge clk);#1;
    `CHECK_EQ("next packet valid",out_valid,1);`CHECK_EQ("next packet sync byte",out_byte,8'hA5);`CHECK_EQ("next packet last",out_last,0);
    @(negedge clk);in_valid=0;
    consume_byte(8'hA5,0);
    consume_byte(8'h55,0);
    consume_byte(8'h66,0);
    consume_byte(checksum_b,1);

    `CHECK_EQ("packet idle valid",out_valid,0);`CHECK_EQ("packet idle ready",in_ready,1);
    `TEST_PASS("Q44");
    $finish;
  end
endmodule
