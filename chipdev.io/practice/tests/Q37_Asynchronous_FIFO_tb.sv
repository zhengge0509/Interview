`timescale 1ns/1ps
`include "tb_check.svh"
module asynchronous_fifo_tb;
  localparam int DATA_WIDTH = 8;
  localparam int ADDR_WIDTH = 3;
  localparam int DEPTH = 1 << ADDR_WIDTH;

  logic wr_clk = 0;
  logic wr_resetn = 0;
  logic wr_en = 0;
  logic [DATA_WIDTH-1:0] wr_data = 0;
  logic full;
  logic rd_clk = 0;
  logic rd_resetn = 0;
  logic rd_en = 0;
  logic [DATA_WIDTH-1:0] rd_data;
  logic empty;

  asynchronous_fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (.*);
  always #3 wr_clk = ~wr_clk;
  always #5 rd_clk = ~rd_clk;

  task automatic write_word(input logic [7:0] value);
    int timeout = 0;
    while (full && timeout < 20) begin @(posedge wr_clk); timeout++; end
    `CHECK_EQ("FIFO has write space",full,0);
    @(negedge wr_clk); wr_en = 1; wr_data = value;
    @(posedge wr_clk); #1;
    @(negedge wr_clk); wr_en = 0;
  endtask

  task automatic read_and_expect(input logic [7:0] expected);
    int timeout = 0;
    while (empty && timeout < 30) begin @(posedge rd_clk); timeout++; end
    `CHECK_EQ("FIFO has readable data",empty,0);
    @(negedge rd_clk); rd_en = 1;
    @(posedge rd_clk); #1;
    `CHECK_EQ("asynchronous FIFO read data",rd_data,expected);
    @(negedge rd_clk); rd_en = 0;
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, asynchronous_fifo_tb);

    #2;
    wr_resetn = 0;
    rd_resetn = 0;
    #19;
    wr_resetn = 1;
    rd_resetn = 1;
    repeat (3) @(posedge wr_clk);
    repeat (3) @(posedge rd_clk);

    write_word(8'h11);
    write_word(8'h22);
    write_word(8'h33);
    write_word(8'h44);
    read_and_expect(8'h11);
    read_and_expect(8'h22);
    read_and_expect(8'h33);
    read_and_expect(8'h44);

    repeat (4) @(posedge wr_clk);
    for (int i = 0; i < DEPTH; i++) write_word(8'h80 + i);
    @(posedge wr_clk); #1;
    `CHECK_EQ("full after DEPTH writes",full,1);

    // A blocked extra write must not overwrite unread data.
    @(negedge wr_clk); wr_en = 1; wr_data = 8'hFF;
    @(posedge wr_clk); #1;
    @(negedge wr_clk); wr_en = 0;

    for (int i = 0; i < DEPTH; i++) read_and_expect(8'h80 + i);
    repeat (4) @(posedge rd_clk);
    #1;
    `CHECK_EQ("empty after all reads",empty,1);

    `TEST_PASS("Q37");
    $finish;
  end
endmodule
