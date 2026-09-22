`timescale 1ns/1ps
`include "tb_check.svh"
module round_robin_arbiter_tb;
  localparam int N = 4;
  logic clk = 0;
  logic resetn = 0;
  logic [N-1:0] req = 0;
  logic [N-1:0] grant;

  round_robin_arbiter #(.N(N)) dut (.*);
  always #5 clk = ~clk;

  task automatic set_and_expect(input logic [N-1:0] requests, input logic [N-1:0] expected);
    @(negedge clk);
    req = requests;
    #1;
    `CHECK_EQ("round-robin grant", grant, expected);
    @(posedge clk);
    #1;
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, round_robin_arbiter_tb);

    repeat (2) @(posedge clk);
    #1 resetn = 1;

    // With all requesters active, grants must rotate 0,1,2,3.
    set_and_expect(4'b1111, 4'b0001);
    set_and_expect(4'b1111, 4'b0010);
    set_and_expect(4'b1111, 4'b0100);
    set_and_expect(4'b1111, 4'b1000);

    // No request must preserve the current pointer (which is back at requester 0).
    set_and_expect(4'b0000, 4'b0000);
    set_and_expect(4'b1010, 4'b0010);
    set_and_expect(4'b1010, 4'b1000);

    // A single persistent requester is always granted and grant remains one-hot.
    set_and_expect(4'b0100, 4'b0100);
    set_and_expect(4'b0100, 4'b0100);

    `CHECK_EQ("grant is one-hot", $onehot(grant), 1);
    `CHECK_EQ("grant is subset of request", grant & ~req, '0);

    `TEST_PASS("Q33");
    $finish;
  end
endmodule
