`timescale 1ns/1ps
`include "tb_check.svh"
module stopwatch_timer_tb;
  localparam int W=4,MAX=5;logic clk=0,reset=1,start=0,stop=0;logic [W-1:0] count;int model=0;bit running=0;
  stopwatch_timer #(.DATA_WIDTH(W),.MAX(MAX)) dut(.*);always #5 clk=~clk;
  task automatic step(input bit s,input bit p,string tag);
    @(negedge clk);start=s;stop=p;@(posedge clk);#1;
    if(p)running=0;else if(s)running=1;
    if(running&&!p)model=(model==MAX)?0:model+1;
    `CHECK_EQ(tag,count,model);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,stopwatch_timer_tb);
    repeat(2)@(posedge clk);#1;`CHECK_EQ("reset count",count,0);@(negedge clk);reset=0;
    step(0,0,"idle holds zero");step(1,0,"start begins counting");step(0,0,"latched running state");
    step(0,1,"stop priority");step(0,0,"stopped holds");
    step(1,1,"simultaneous start/stop: stop wins");step(1,0,"restart");repeat(5)step(0,0,"count and wrap");
    @(negedge clk);reset=1;@(posedge clk);#1;model=0;running=0;`CHECK_EQ("reset while running",count,0);
    `TEST_PASS("Q14");$finish;
  end
endmodule
