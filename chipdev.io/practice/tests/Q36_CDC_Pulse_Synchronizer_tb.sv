`timescale 1ns/1ps
`include "tb_check.svh"
module cdc_pulse_synchronizer_tb;
  logic src_clk = 0;
  logic dst_clk = 0;
  logic src_resetn = 0;
  logic dst_resetn = 0;
  logic src_pulse = 0;
  logic dst_pulse;
  int received = 0;
  logic previous_dst_pulse = 0;

  cdc_pulse_synchronizer dut (.*);
  always #3 src_clk = ~src_clk;
  always #5 dst_clk = ~dst_clk;

  always @(posedge dst_clk) begin
    if (!dst_resetn) begin
      received <= 0;
      previous_dst_pulse <= 0;
    end else begin
      if (dst_pulse) received <= received + 1;
      if (dst_pulse) `CHECK_EQ("previous destination pulse",previous_dst_pulse,0);
      previous_dst_pulse <= dst_pulse;
    end
  end

  task automatic send_source_pulse;
    @(negedge src_clk);
    src_pulse = 1;
    @(negedge src_clk);
    src_pulse = 0;
  endtask

  task automatic wait_and_expect(input int expected);
    repeat (7) @(posedge dst_clk);
    #1;
    `CHECK_EQ("received destination pulse count",received,expected);
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, cdc_pulse_synchronizer_tb);

    #2;
    src_resetn = 0;
    dst_resetn = 0;
    #17;
    src_resetn = 1;
    dst_resetn = 1;

    send_source_pulse();
    wait_and_expect(1);
    send_source_pulse();
    wait_and_expect(2);
    send_source_pulse();
    wait_and_expect(3);

    `CHECK_EQ("destination pulse returns low",dst_pulse,0);
    `TEST_PASS("Q36");
    $finish;
  end
endmodule
