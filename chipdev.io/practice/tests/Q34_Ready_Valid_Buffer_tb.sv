`timescale 1ns/1ps
`include "tb_check.svh"
module ready_valid_buffer_tb;
  localparam int DATA_WIDTH = 8;
  logic clk = 0;
  logic resetn = 0;
  logic in_valid = 0;
  logic in_ready;
  logic [DATA_WIDTH-1:0] in_data = 0;
  logic out_valid;
  logic out_ready = 0;
  logic [DATA_WIDTH-1:0] out_data;

  ready_valid_buffer #(.DATA_WIDTH(DATA_WIDTH)) dut (.*);
  always #5 clk = ~clk;

  task automatic drive(
    input logic iv,
    input logic [7:0] id,
    input logic ordy
  );
    @(negedge clk);
    in_valid = iv;
    in_data = id;
    out_ready = ordy;
    @(posedge clk);
    #1;
  endtask

  task automatic expect_state(input logic ev,input logic [7:0] ed,input logic er,string tag);
    `CHECK_EQ({tag," out_valid"},out_valid,ev);
    if(ev) `CHECK_EQ({tag," out_data"},out_data,ed);
    `CHECK_EQ({tag," in_ready"},in_ready,er);
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, ready_valid_buffer_tb);

    repeat (2) @(posedge clk);
    #1 resetn = 1;
    expect_state(0,0,1,"reset");

    // Capture A while downstream is stalled.
    drive(1, 8'hA1, 0);
    expect_state(1,8'hA1,0,"capture first item");

    // Backpressure: changing in_data must not change held out_data.
    drive(1, 8'hB2, 0);
    expect_state(1,8'hA1,0,"stalled output stable");

    // Consume A and replace it with B on the same edge.
    drive(1, 8'hB2, 1);
    expect_state(1,8'hB2,1,"consume and replace");

    // Consume B without replacement.
    drive(0, 0, 1);
    expect_state(0,0,1,"become empty");

    // Sustained one-item-per-cycle throughput.
    drive(1, 8'hC3, 1);
    expect_state(1,8'hC3,1,"C transfer");
    drive(1, 8'hD4, 1);
    expect_state(1,8'hD4,1,"D transfer");
    drive(0, 0, 1);
    expect_state(0,0,1,"final drain");

    `TEST_PASS("Q34");
    $finish;
  end
endmodule
