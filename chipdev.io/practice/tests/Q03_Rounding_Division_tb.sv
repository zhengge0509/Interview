`timescale 1ns/1ps
`include "tb_check.svh"
module rounding_division_tb;
  localparam int DIV_LOG2=2,OUT_WIDTH=32,IN_WIDTH=OUT_WIDTH+DIV_LOG2;
  logic [IN_WIDTH-1:0] din;logic [OUT_WIDTH-1:0] dout;
  rounding_division #(.DIV_LOG2(DIV_LOG2),.OUT_WIDTH(OUT_WIDTH),.IN_WIDTH(IN_WIDTH)) dut(.*);
  function automatic logic [OUT_WIDTH-1:0] expected(input logic [IN_WIDTH-1:0] value);
    logic [IN_WIDTH:0] q;logic [IN_WIDTH-1:0] rem;logic [OUT_WIDTH-1:0] max_out;
    begin
      q=value>>DIV_LOG2;rem=value&((1<<DIV_LOG2)-1);max_out='1;
      if(rem>=(1<<(DIV_LOG2-1)))q=q+1;
      expected=(q>max_out)?max_out:q[OUT_WIDTH-1:0];
    end
  endfunction
  task automatic check(input logic [IN_WIDTH-1:0] value);
    din=value;#1;`CHECK_EQ("rounded quotient",dout,expected(value));
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,rounding_division_tb);
    for(int i=0;i<20;i++)check(i);check('1);check('1-1);check('1-2);
    check({OUT_WIDTH{1'b1}}<<DIV_LOG2);check((({OUT_WIDTH{1'b1}}<<DIV_LOG2)-1));
    `TEST_PASS("Q03");$finish;
  end
endmodule

