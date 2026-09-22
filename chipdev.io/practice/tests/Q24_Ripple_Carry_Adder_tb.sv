`timescale 1ns/1ps
`include "tb_check.svh"
module ripple_carry_adder_tb;
  localparam int W=8;logic[W-1:0]a,b,cout_int;logic[W:0]sum,expected;logic[W-1:0]expected_carry;
  ripple_carry_adder #(.DATA_WIDTH(W)) dut(.*);
  task automatic check(input logic[W-1:0]av,bv);
    logic carry;a=av;b=bv;expected={1'b0,av}+{1'b0,bv};carry=0;
    for(int i=0;i<W;i++)begin carry=(av[i]&bv[i])|(av[i]&carry)|(bv[i]&carry);expected_carry[i]=carry;end
    #1;`CHECK_EQ("ripple sum including carry",sum,expected);`CHECK_EQ("per-stage carries",cout_int,expected_carry);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,ripple_carry_adder_tb);
    check(0,0);check('1,1);check(8'hFF,1);check(8'h55,8'hAA);check(8'h7F,1);
    for(int i=0;i<50;i++)check($urandom,$urandom);
    `TEST_PASS("Q24");$finish;
  end
endmodule
