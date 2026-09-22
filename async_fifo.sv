// EMPTY 
=========
read pointer === write pointer

FULL

write pointer == read pointer + FIFO + DEPTH


write domain

wr_bin
   ↓
wr_gray
   ↓
2FF synchronizer
   ↓
wr_gray_sync

====================== CDC

Read domain

rd_gray

read domain => empty_next = (rd_gray_next == wr_gray_sync);
empty 一定要在read domain 判斷嗎？

=====================================================

Full 
write 1 → wr_ptr = 0001
write 2 → wr_ptr = 0010
...
write 7 → wr_ptr = 0111
write 8 → wr_ptr = 1000

address bits:
wr_ptr[2:0] = 1000 wrap bit different

rd_ptr[2:0] = 0000


但是在gray code時
rd_bin = 0011 = 3 -> rd_gray = 0010
wr_bin = 1011 = 11 -> wr_gray = 1110
11-3=8

0010 -> 1110 最上面兩個bits 做invert -> {~rd_gray_sync[3:2], rd_gray_sync[1:0]}
