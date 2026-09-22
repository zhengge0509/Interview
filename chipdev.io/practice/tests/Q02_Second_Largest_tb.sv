`timescale 1ns/1ps
`include "tb_check.svh"
module second_largest_tb;
  localparam int DATA_WIDTH=32;logic clk=0,resetn=0;logic [31:0] din=0,dout;
  logic [31:0] model_first,model_second;
  second_largest #(.DATA_WIDTH(DATA_WIDTH)) dut(.*);always #5 clk=~clk;
  task automatic reset_dut;
    @(negedge clk);resetn=0;@(posedge clk);#1;model_first=0;model_second=0;
    `CHECK_EQ("reset second-largest",dout,model_second);resetn=1;
  endtask
  task automatic send(input logic [31:0] value);
    @(negedge clk);din=value;@(posedge clk);#1;
    if(value>model_first)begin model_second=model_first;model_first=value;end
    else if(value>model_second)model_second=value;
    `CHECK_EQ("second-largest after input",dout,model_second);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,second_largest_tb);model_first=0;model_second=0;
    reset_dut();send(2);send(6);send(0);send(14);send(12);send(1);
    reset_dut();send(1);send(2);send(3);send(3);send(3);
    reset_dut();send(32'hFFFFFFFF);send(32'hFFFFFFFE);send(32'hFFFFFFFF);
    `TEST_PASS("Q02");$finish;
  end
endmodule
