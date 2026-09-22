`timescale 1ns/1ps
`include "tb_check.svh"
module glitch_free_clock_mux_tb;
  logic clk0 = 0;
  logic clk1 = 0;
  logic resetn = 0;
  logic sel = 0;
  logic clk_out;
  time last_transition = 0;
  int rising_edges = 0;

  glitch_free_clock_mux dut (.*);
  always #5 clk0 = ~clk0;
  always #7 clk1 = ~clk1;

  always @(clk_out) begin
    if (resetn && last_transition != 0)
      `CHECK_TRUE("clock phase is at least 5 ns",($time-last_transition)>=5);
    if (resetn) last_transition = $time;
  end

  always @(posedge clk_out) if (resetn) rising_edges++;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, glitch_free_clock_mux_tb);

    #3 resetn = 1;
    #13 sel = 1;  // Change selection while clk0 is high and clk1 is low.
    #70 sel = 0;
    #73 sel = 1;
    #70;

    `CHECK_TRUE("at least eight output rising edges",rising_edges>=8);

    resetn = 0;
    #1;
    `CHECK_EQ("clock output during reset",clk_out,0);

    `TEST_PASS("Q39");
    $finish;
  end
endmodule
