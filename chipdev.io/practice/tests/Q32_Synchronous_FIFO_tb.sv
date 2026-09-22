`timescale 1ns/1ps
`include "tb_check.svh"
module synchronous_fifo_tb;
  localparam int DATA_WIDTH = 8;
  localparam int DEPTH = 4;
  localparam int COUNT_WIDTH = $clog2(DEPTH + 1);

  logic clk = 0;
  logic resetn = 0;
  logic push = 0;
  logic pop = 0;
  logic [DATA_WIDTH-1:0] din = 0;
  logic [DATA_WIDTH-1:0] dout;
  logic full, empty;
  logic [COUNT_WIDTH-1:0] count;

  synchronous_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) dut (.*);
  always #5 clk = ~clk;

  task automatic apply(input logic p, input logic q, input logic [7:0] data);
    @(negedge clk);
    push = p;
    pop = q;
    din = data;
    @(posedge clk);
    #1;
  endtask

  task automatic expect_state(
    input int expected_count,
    input logic expected_empty,
    input logic expected_full,
    input logic [7:0] expected_dout
  );
    `CHECK_EQ("FIFO count", count, expected_count);
    `CHECK_EQ("FIFO empty", empty, expected_empty);
    `CHECK_EQ("FIFO full", full, expected_full);
    if (!expected_empty) `CHECK_EQ("FIFO oldest data", dout, expected_dout);
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, synchronous_fifo_tb);

    repeat (2) @(posedge clk);
    #1;
    resetn = 1;
    expect_state(0, 1, 0, 0);

    apply(1, 0, 8'h11); expect_state(1, 0, 0, 8'h11);
    apply(1, 0, 8'h22); expect_state(2, 0, 0, 8'h11);
    apply(1, 0, 8'h33); expect_state(3, 0, 0, 8'h11);
    apply(1, 0, 8'h44); expect_state(4, 0, 1, 8'h11);

    apply(1, 0, 8'h99); expect_state(4, 0, 1, 8'h11);
    apply(1, 1, 8'h55); expect_state(4, 0, 1, 8'h22);

    apply(0, 1, 0); expect_state(3, 0, 0, 8'h33);
    apply(0, 1, 0); expect_state(2, 0, 0, 8'h44);
    apply(0, 1, 0); expect_state(1, 0, 0, 8'h55);
    apply(0, 1, 0); expect_state(0, 1, 0, 0);
    apply(0, 1, 0); expect_state(0, 1, 0, 0);

    apply(1, 1, 8'h66); expect_state(1, 0, 0, 8'h66);
    apply(0, 1, 0); expect_state(0, 1, 0, 0);

    `TEST_PASS("Q32");
    $finish;
  end
endmodule
