`timescale 1ns/1ps
`include "tb_check.svh"
module SIPO_shift_register_tb;
  localparam int DATA_WIDTH=16;logic clk=0,resetn=0,din=0;logic [DATA_WIDTH-1:0] dout,model=0;
  SIPO_shift_register #(.DATA_WIDTH(DATA_WIDTH)) dut(.*);always #5 clk=~clk;
  task automatic send(input logic bit_value);
    @(negedge clk);din=bit_value;@(posedge clk);#1;model=(model<<1)|bit_value;`CHECK_EQ("parallel shift value",dout,model);
  endtask
  initial begin
    logic [15:0] test_word=16'hA53C;
    $dumpfile("dump.vcd");$dumpvars(0,SIPO_shift_register_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset parallel output",dout,0);@(negedge clk);resetn=1;
    for(int i=15;i>=0;i--)send(test_word[i]);`CHECK_EQ("complete serial word",dout,test_word);
    send(1);send(0);
    @(negedge clk);resetn=0;@(posedge clk);#1;model=0;`CHECK_EQ("reset after shifts",dout,model);
    `TEST_PASS("Q08");$finish;
  end
endmodule
