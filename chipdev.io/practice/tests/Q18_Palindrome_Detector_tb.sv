`timescale 1ns/1ps
`include "tb_check.svh"
module palindrome_detector_tb;
  localparam int W=32;logic [W-1:0] din;logic dout,expected;
  palindrome_detector #(.DATA_WIDTH(W)) dut(.*);
  task automatic check(input logic [W-1:0] value);
    din=value;expected=1;for(int i=0;i<W/2;i++)if(value[i]!=value[W-1-i])expected=0;#1;`CHECK_EQ("palindrome classification",dout,expected);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,palindrome_detector_tb);
    check(0);check('1);check(32'h80000001);check(32'hA55AA55A);check(32'h80000000);check(32'h12345678);
    `TEST_PASS("Q18");$finish;
  end
endmodule
