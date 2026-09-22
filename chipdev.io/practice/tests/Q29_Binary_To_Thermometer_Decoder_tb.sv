`timescale 1ns/1ps
`include "tb_check.svh"
module binary_to_thermometer_decoder_tb;
  logic[7:0]din;logic[255:0]dout,expected;binary_to_thermometer_decoder dut(.*);
  task automatic check(input logic[7:0]value);
    din=value;expected='0;for(int i=0;i<=value;i++)expected[i]=1;#1;`CHECK_EQ("binary-to-thermometer",dout,expected);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,binary_to_thermometer_decoder_tb);
    check(0);check(1);check(7);check(8'h7F);check(8'hFE);check(8'hFF);
    `TEST_PASS("Q29");$finish;
  end
endmodule
