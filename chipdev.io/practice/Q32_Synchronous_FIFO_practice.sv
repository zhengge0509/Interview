/*
 * Q32 — Parameterized Synchronous FIFO
 *
 * Design a single-clock FIFO with parameterized data width and power-of-two depth.
 * - resetn is an active-low synchronous reset. After reset, empty=1, full=0, and count=0.
 * - Accept a push when push=1 and space is available. Store din at the tail.
 * - Accept a pop when pop=1 and data is available. Remove the oldest entry.
 * - dout continuously presents the oldest valid entry (first-word fall-through behavior).
 * - A simultaneous push and pop normally leaves count unchanged.
 * - When full, a simultaneous push and pop must accept both operations: pop the old head and
 *   append din in the same cycle. A push without a pop must be rejected while full.
 * - When empty, a simultaneous push and pop accepts only the push; the new item becomes visible
 *   after the clock edge. A pop without a push has no effect while empty.
 * - full, empty, and count must never indicate an impossible occupancy.
 */
module synchronous_fifo #(
  parameter int DATA_WIDTH = 8,
  parameter int DEPTH = 8,
  parameter int COUNT_WIDTH = $clog2(DEPTH + 1)
) (
  input  logic                   clk,
  input  logic                   resetn,
  input  logic                   push,
  input  logic                   pop,
  input  logic [DATA_WIDTH-1:0]  din,
  output logic [DATA_WIDTH-1:0]  dout,
  output logic                   full,
  output logic                   empty,
  output logic [COUNT_WIDTH-1:0] count
);

  // TODO: Implement your design here.
  logic [DATA_WIDTH - 1 :0] fifo [0:DEPTH-1];
  logic [$clog2(DEPTH):0]head,tail;
  parameter int INDEX_WIDTH =  $clog2(DEPTH);
  logic [COUNT_WIDTH-1:0] next_count;

  always_ff @( posedge clk ) begin
    if(!resetn)begin
      for(int i =0 ; i < DEPTH ; i++)begin
        fifo[i] <= '0;
      end
      head <= '0;
      tail <= '0;
      count <= '0;
    end else begin
      // dout <= fifo[head]; // c
      count <= next_count;
      if(push)begin
        if(pop && full)begin
          head <= head + 1'b1;
          fifo[tail[INDEX_WIDTH-1 : 0]] <= din;
          tail <= tail + 1'b1;
        end else if(!full)begin
          fifo[tail[INDEX_WIDTH-1 : 0]] <= din;
          tail <= tail + 1'b1;
          // count <= c
        end
      end
      if(pop && !empty)begin
        // fifo[head[INDEX_WIDTH-1:0]];
        head <= head + 1'b1;
      end
      // if(pop && push && full)begin
      //   head <= head + 1'b1;
      //   fifo[tail[INDEX_WIDTH-1 : 0]] = din;
      //   tail <= tail + 1'b1;
      // end
    end
  end

assign full = (head[$clog2(DEPTH)-1:0] == tail[$clog2(DEPTH)-1:0]) && (head[$clog2(DEPTH)] != tail[$clog2(DEPTH)]);
assign empty = (head == tail);
assign dout  = fifo[head[INDEX_WIDTH-1:0]];
always_comb begin
  next_count = count;
  casez ({push,full,pop,empty})
    4'b100?: next_count = next_count + 1'b1;
    4'b1011: next_count = next_count + 1'b1;
    4'b0?10: next_count = next_count - 1'b1;
    // 4'b1110: next_count = next_count - 1'b1;
    default: next_count = next_count;
  endcase
end
endmodule

