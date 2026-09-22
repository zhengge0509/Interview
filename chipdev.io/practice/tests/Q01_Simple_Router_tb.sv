`timescale 1ns/1ps
`include "tb_check.svh"
module simple_router_tb;
  localparam int DATA_WIDTH=32;
  logic [DATA_WIDTH-1:0] din; logic d_en; logic [1:0] addr;
  logic [DATA_WIDTH-1:0] dout0,dout1,dout2,dout3;
  simple_router #(.DATA_WIDTH(DATA_WIDTH)) dut(.*);
  task automatic check(input logic en,input logic [1:0] a,input logic [31:0] value);
    logic [31:0] e0,e1,e2,e3;
    d_en=en;addr=a;din=value;#1;e0=0;e1=0;e2=0;e3=0;
    if(en)case(a)0:e0=value;1:e1=value;2:e2=value;3:e3=value;endcase
    `CHECK_EQ("dout0",dout0,e0);`CHECK_EQ("dout1",dout1,e1);
    `CHECK_EQ("dout2",dout2,e2);`CHECK_EQ("dout3",dout3,e3);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,simple_router_tb);
    for(int a=0;a<4;a++)check(0,a,32'hA5A50000+a);
    for(int a=0;a<4;a++)check(1,a,32'hDEADBEEF^a);
    check(1,0,0);check(1,3,32'hFFFFFFFF);
    `TEST_PASS("Q01");$finish;
  end
endmodule

