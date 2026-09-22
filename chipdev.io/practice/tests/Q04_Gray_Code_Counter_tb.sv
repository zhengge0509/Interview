`timescale 1ns/1ps
`include "tb_check.svh"
module gray_code_generator_tb;
  localparam int DATA_WIDTH=4;logic clk=0,resetn=0;logic [DATA_WIDTH-1:0] out;
  gray_code_generator #(.DATA_WIDTH(DATA_WIDTH)) dut(.*);always #5 clk=~clk;
  function automatic logic [DATA_WIDTH-1:0] gray(input logic [DATA_WIDTH-1:0] n);gray=n^(n>>1);endfunction
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,gray_code_generator_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset Gray output",out,0);
    @(negedge clk);resetn=1;
    for(int n=1;n<(1<<DATA_WIDTH);n++)begin @(posedge clk);#1;`CHECK_EQ("Gray count",out,gray(n));end
    repeat(2)begin @(posedge clk);#1;`CHECK_EQ("hold at maximum",out,gray({DATA_WIDTH{1'b1}}));end
    @(negedge clk);resetn=0;@(posedge clk);#1;`CHECK_EQ("second reset",out,0);
    `TEST_PASS("Q04");$finish;
  end
endmodule

