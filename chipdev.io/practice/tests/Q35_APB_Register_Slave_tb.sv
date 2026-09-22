`timescale 1ns/1ps
`include "tb_check.svh"
module apb_register_slave_tb;
  logic PCLK = 0;
  logic PRESETn = 0;
  logic PSEL = 0;
  logic PENABLE = 0;
  logic PWRITE = 0;
  logic [7:0] PADDR = 0;
  logic [31:0] PWDATA = 0;
  logic [3:0] PSTRB = 0;
  logic [31:0] PRDATA;
  logic PREADY, PSLVERR;

  apb_register_slave dut (.*);
  always #5 PCLK = ~PCLK;

  task automatic apb_write(
    input logic [7:0] addr,
    input logic [31:0] data,
    input logic [3:0] strb,
    input logic expected_error
  );
    @(negedge PCLK);
    PSEL=1; PENABLE=0; PWRITE=1; PADDR=addr; PWDATA=data; PSTRB=strb;
    @(posedge PCLK); #1;
    `CHECK_EQ("APB write setup PREADY",PREADY,0);`CHECK_EQ("APB write setup PSLVERR",PSLVERR,0);
    @(negedge PCLK); PENABLE=1;
    #1;
    `CHECK_EQ("APB write access PREADY",PREADY,1);`CHECK_EQ("APB write access PSLVERR",PSLVERR,expected_error);
    @(posedge PCLK); #1;
    @(negedge PCLK); PSEL=0; PENABLE=0; PWRITE=0; PSTRB=0;
  endtask

  task automatic apb_read(
    input logic [7:0] addr,
    input logic [31:0] expected_data,
    input logic expected_error
  );
    @(negedge PCLK);
    PSEL=1; PENABLE=0; PWRITE=0; PADDR=addr;
    @(posedge PCLK); #1;
    `CHECK_EQ("APB read setup PREADY",PREADY,0);`CHECK_EQ("APB read setup PSLVERR",PSLVERR,0);
    @(negedge PCLK); PENABLE=1;
    #1;
    `CHECK_EQ("APB read access PREADY",PREADY,1);`CHECK_EQ("APB read access PSLVERR",PSLVERR,expected_error);
    if (!expected_error) `CHECK_EQ("APB read data",PRDATA,expected_data);
    @(posedge PCLK); #1;
    @(negedge PCLK); PSEL=0; PENABLE=0;
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, apb_register_slave_tb);

    repeat (2) @(posedge PCLK);
    #1 PRESETn = 1;

    apb_read(8'h00, 32'h00000000, 0);
    apb_write(8'h00, 32'hDEADBEEF, 4'b1111, 0);
    apb_read(8'h00, 32'hDEADBEEF, 0);
    apb_write(8'h00, 32'h0000AA00, 4'b0010, 0);
    apb_read(8'h00, 32'hDEADAAEF, 0);

    apb_write(8'h04, 32'h12345678, 4'b1111, 0);
    apb_read(8'h04, 32'h12345678, 0);

    apb_write(8'h02, 32'hFFFFFFFF, 4'b1111, 1);
    apb_read(8'h02, 32'h00000000, 1);
    apb_read(8'h00, 32'hDEADAAEF, 0);
    apb_read(8'h10, 32'h00000000, 1);

    `TEST_PASS("Q35");
    $finish;
  end
endmodule
