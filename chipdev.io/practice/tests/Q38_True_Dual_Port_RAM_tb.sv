`timescale 1ns/1ps
`include "tb_check.svh"
module true_dual_port_ram_tb;
  localparam int DATA_WIDTH = 8;
  localparam int ADDR_WIDTH = 4;

  logic clk = 0;
  logic resetn = 0;
  logic en_a = 0, we_a = 0;
  logic [ADDR_WIDTH-1:0] addr_a = 0;
  logic [DATA_WIDTH-1:0] wdata_a = 0;
  logic [DATA_WIDTH-1:0] rdata_a;
  logic en_b = 0, we_b = 0;
  logic [ADDR_WIDTH-1:0] addr_b = 0;
  logic [DATA_WIDTH-1:0] wdata_b = 0;
  logic [DATA_WIDTH-1:0] rdata_b;
  logic collision;

  true_dual_port_ram #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (.*);
  always #5 clk = ~clk;

  task automatic cycle;
    @(posedge clk);
    #1;
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, true_dual_port_ram_tb);

    repeat (2) @(posedge clk);
    #1 resetn = 1;

    // Initialize address 3 from port A.
    @(negedge clk); en_a=1; we_a=1; addr_a=3; wdata_a=8'hAA; en_b=0; we_b=0;
    cycle();
    @(negedge clk); we_a=0; addr_a=3;
    cycle();
    `CHECK_EQ("port A readback",rdata_a,8'hAA);

    // Concurrent writes to different addresses.
    @(negedge clk);
    en_a=1; we_a=1; addr_a=4; wdata_a=8'h44;
    en_b=1; we_b=1; addr_b=5; wdata_b=8'h55;
    cycle();
    `CHECK_EQ("different-address collision",collision,0);

    @(negedge clk); we_a=0; addr_a=4; we_b=0; addr_b=5;
    cycle();
    `CHECK_EQ("independent port A read",rdata_a,8'h44);`CHECK_EQ("independent port B read",rdata_b,8'h55);

    // Same-address dual write must be suppressed and report collision.
    @(negedge clk);
    en_a=1; we_a=1; addr_a=3; wdata_a=8'hA3;
    en_b=1; we_b=1; addr_b=3; wdata_b=8'hB3;
    cycle();
    `CHECK_EQ("same-address collision",collision,1);`CHECK_EQ("collision port A read-first",rdata_a,8'hAA);`CHECK_EQ("collision port B read-first",rdata_b,8'hAA);

    @(negedge clk); we_a=0; we_b=0; addr_a=3; addr_b=3;
    cycle();
    `CHECK_EQ("suppressed write port A",rdata_a,8'hAA);`CHECK_EQ("suppressed write port B",rdata_b,8'hAA);

    `TEST_PASS("Q38");
    $finish;
  end
endmodule
