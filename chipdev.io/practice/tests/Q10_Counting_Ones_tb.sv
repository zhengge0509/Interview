`timescale 1ns/1ps
`include "tb_check.svh"
module counting_ones_tb;
  localparam int DATA_WIDTH=16;logic [DATA_WIDTH-1:0] din;logic [$clog2(DATA_WIDTH):0] dout;
  counting_ones #(.DATA_WIDTH(DATA_WIDTH)) dut(.*);
  function automatic int popcount(input logic [DATA_WIDTH-1:0] value);popcount=0;for(int i=0;i<DATA_WIDTH;i++)popcount+=value[i];endfunction
  task automatic check(input logic [DATA_WIDTH-1:0] value);din=value;#1;`CHECK_EQ("population count",dout,popcount(value));endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,counting_ones_tb);
    check(0);check('1);check(16'h0001);check(16'h8000);check(16'hAAAA);check(16'h5555);
    repeat(20)check($urandom);`TEST_PASS("Q10");$finish;
  end
endmodule

