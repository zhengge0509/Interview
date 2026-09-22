`timescale 1ns/1ps
`include "tb_check.svh"
module fibonacci_generator_tb;
  localparam int DATA_WIDTH=32;logic clk=0,resetn=0;logic [DATA_WIDTH-1:0] dout;
  logic [DATA_WIDTH-1:0] current,previous,next_value;
  fibonacci_generator #(.DATA_WIDTH(DATA_WIDTH)) dut(.*);always #5 clk=~clk;
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,fibonacci_generator_tb);
    repeat(2)@(posedge clk);#1;current=1;previous=0;`CHECK_EQ("reset Fibonacci value",dout,current);
    @(negedge clk);resetn=1;
    repeat(20)begin
      @(posedge clk);#1;next_value=current+previous;previous=current;current=next_value;
      `CHECK_EQ("Fibonacci value",dout,current);
    end
    @(negedge clk);resetn=0;@(posedge clk);#1;`CHECK_EQ("Fibonacci reset again",dout,1);
    `TEST_PASS("Q09");$finish;
  end
endmodule

