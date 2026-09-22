/*
 * Q26 — Three-Entry Multi-Bit FIFO / Streaming Buffer
 *
 * Using the supplied interface, implement a write-only FIFO buffer with a fixed depth of 3
 * and DATA_WIDTH bits per entry.
 * - resetn is an active-low synchronous reset. Clear the contents and occupancy.
 * - When wr=1 and the buffer is not full, append din and increment occupancy.
 * - When wr=1 and the buffer is full, discard the oldest entry, shift the remaining entries
 *   forward, append din, and remain full.
 * - When wr=0, do not change the contents or occupancy. This interface has no read/pop input.
 * - dout continuously presents the oldest entry. empty/full indicate occupancy=0/3.
 * - Because there is no pop operation, the buffer remains full after first filling until reset.
 */
module multi_bit_fifo #(parameter DATA_WIDTH=8)
  (input  logic                  clk,
   input  logic                  resetn,
   input  logic [DATA_WIDTH-1:0] din,
   input  logic                  wr,
   output logic [DATA_WIDTH-1:0] dout,
   output logic                  empty,
   output logic                  full);

  // TODO: Implement your design here.
  logic [DATA_WIDTH - 1:0]fifo [0:2];
  logic [2:0]head, tail, count;
  always_ff @( posedge clk ) begin 
    if(!resetn)begin
      head <= '0;
      tail <= '0;
      for(int i =0; i < 3 ; i ++)begin
        fifo[i] <= '0;
      end
      // count <= '0;
    end else begin
      if(wr)begin
        if(!full) begin
        end else begin
          if(tail[1:0] == 'd2) begin
            tail <= 'd0; 
            tail[2] <= ~tail[2];
          end
          else tail <= tail + 1'b1;
          // tail <= tail + 1'b1;
        end
        fifo[head[1:0]] <= din;
        if(head[1:0] == 'd2) begin
          head <= 'd0; 
          head[2] <= ~head[2]; 
        end
        else head <= head + 1'b1;
        // head <= head + 1'b1;
      end
    end
  end


  assign empty = (head == tail);
  assign full = ((tail[2] != head[2]) && (tail[1:0] == head [1:0]));
  // assign full = ((head + 1'b1) % 3 == tail);
  assign dout = fifo[tail[1:0]];
  // assign count = (head >= tail) ? (head - tail) : (head - tail + 'd3);
endmodule
