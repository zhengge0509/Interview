`timescale 1ns/1ps
`include "tb_check.svh"
module full_adder_tb;
  logic a,b,cin,sum,cout;logic [1:0]expected;full_adder dut(.*);
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,full_adder_tb);
    for(int v=0;v<8;v++)begin {a,b,cin}=v[2:0];#1;expected=a+b+cin;`CHECK_EQ("full-adder {carry,sum}",{cout,sum},expected);end
    `TEST_PASS("Q22");$finish;
  end
endmodule
