`timescale 1ns/1ps
`include "tb_check.svh"
module fizzbuzz_tb;
  localparam int FIZZ=2,BUZZ=3,MAX_CYCLES=20;logic clk=0,resetn=0,fizz,buzz,fizzbuzz;int count=0;
  fizzbuzz #(.FIZZ(FIZZ),.BUZZ(BUZZ),.MAX_CYCLES(MAX_CYCLES)) dut(
    .clk       (clk),
    .resetn    (resetn),
    .fizz      (fizz),
    .buzz      (buzz),
    .fizz_buzz (fizzbuzz)
  );
  always #5 clk=~clk;
  task automatic check(string tag);
    logic expected_fizz;
    logic expected_buzz;
    logic expected_fizzbuzz;
    expected_fizz     = ((count % FIZZ) == 0);
    expected_buzz     = ((count % BUZZ) == 0);
    expected_fizzbuzz = expected_fizz && expected_buzz;

    $display("[Q21 CHECK] %-18s resetn=%0b model_count=%0d (FIZZ=%0d, BUZZ=%0d)",
             tag, resetn, count, FIZZ, BUZZ);
    $display("            expected: fizz=%0b buzz=%0b fizz_buzz=%0b",
             expected_fizz, expected_buzz, expected_fizzbuzz);
    $display("            actual  : fizz=%0b buzz=%0b fizz_buzz=%0b",
             fizz, buzz, fizzbuzz);

    if (fizz !== expected_fizz)
      $fatal(1, "[Q21 FAIL] fizz mismatch at model_count=%0d: actual=%0b expected=%0b",
             count, fizz, expected_fizz);
    if (buzz !== expected_buzz)
      $fatal(1, "[Q21 FAIL] buzz mismatch at model_count=%0d: actual=%0b expected=%0b",
             count, buzz, expected_buzz);
    if (fizzbuzz !== expected_fizzbuzz)
      $fatal(1, "[Q21 FAIL] fizz_buzz mismatch at model_count=%0d: actual=%0b expected=%0b",
             count, fizzbuzz, expected_fizzbuzz);
  endtask
  initial begin
    $dumpfile("dump.vcd");$dumpvars(0,fizzbuzz_tb);
    repeat(2)@(posedge clk);#1;check("reset count zero");@(negedge clk);resetn=1;
    repeat(MAX_CYCLES+3)begin @(posedge clk);#1;count=(count==MAX_CYCLES-1)?0:count+1;check("counter cycle");end
    @(negedge clk);resetn=0;@(posedge clk);#1;count=0;check("midrun reset");
    `TEST_PASS("Q21");$finish;
  end
endmodule
