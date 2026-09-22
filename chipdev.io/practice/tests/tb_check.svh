`ifndef CHIPDEV_TB_CHECK_SVH
`define CHIPDEV_TB_CHECK_SVH

`define CHECK_EQ(TAG, ACTUAL, EXPECTED) \
  begin \
    $display("[CHECK] %-36s actual=0x%0h expected=0x%0h", TAG, ACTUAL, EXPECTED); \
    if ((ACTUAL) !== (EXPECTED)) \
      $fatal(1, "[FAIL] %s: actual=0x%0h expected=0x%0h", TAG, ACTUAL, EXPECTED); \
  end

`define CHECK_TRUE(TAG, CONDITION) \
  begin \
    $display("[CHECK] %-36s actual=%0b expected=1", TAG, (CONDITION)); \
    if (!(CONDITION)) $fatal(1, "[FAIL] %s", TAG); \
  end

`define TEST_PASS(NAME) \
  $display("%s PASS: all expected outputs matched", NAME)

`endif
