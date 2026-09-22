`timescale 1ns/1ps
`include "tb_check.svh"
module reversing_bits_tb;
  localparam int DATA_WIDTH=32;logic [DATA_WIDTH-1:0] din,dout;
  reversing_bits #(.DATA_WIDTH(DATA_WIDTH)) dut(.*);
  function automatic logic [DATA_WIDTH-1:0] reverse(input logic [DATA_WIDTH-1:0] value);
    for(int i=0;i<DATA_WIDTH;i++)reverse[i]=value[DATA_WIDTH-1-i];
  endfunction
  task automatic check(input logic [DATA_WIDTH-1:0] value);din=value;#1;`CHECK_EQ("bit-reversed value",dout,reverse(value));endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,reversing_bits_tb);
    check(0);check('1);check(32'h00000001);check(32'h80000000);check(32'hA5C33C81);
    repeat(10)check($urandom);`TEST_PASS("Q05");$finish;
  end
endmodule

