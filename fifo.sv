module fifo(#parameter DEPTH = 8

    input logic clk,
    input logic rst_n,
    input logic wr_en,
    input logic [31:0]wr_data,
    input logic rd_en,
    output logic [31:0]rd_data,
    output logic full,
    output logic empty
);

logic [31:0] fifo [0:DEPTH-1];
logic [$clog2(DEPTH):0]count;
logic [$clog2(DEPTH)-1:0]rd_ptr,wr_ptr;


assign empty = (rd_ptr == wr_ptr)? 1'b1: 1'b0;
// assign count = (wr_ptr >= rd_ptr) ? (wr_ptr - rd_ptr) : (wr_ptr - rd_ptr + DEPTH); // wr_ptr = 0 , rd_ptr = 1
assign full = (count == DEPTH) ? 1'b1 : 1'b0;

always_ff @( posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        wr_ptr <= '0;
        rd_ptr <= '0;
        count <= '0;
    end
    else begin
        case ({wr_en && !full , rd_en && !empty})
            2'b10:begin
                fifo[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
                count <= count + 1'b1;
            end
            2'b01: begin
                rd_data <= fifo[rd_data];
                rd_ptr <= rd_data + 1'b1;
                count <= count - 1'b1;
            end
            2'b11:begin
                fifo[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
                rd_data <= fifo[rd_data];
                rd_ptr <= rd_data + 1'b1;
                count <= count;
            end
            default: begin
                count <= count;
            end
        endcase
        // if(wr_en && !full)begin
        //     fifo[wr_ptr] <= wr_data;
        //     // if(wr_ptr == DEPTH - 1)begin
        //     //     wr
        //     // end
        //     // end
        //     wr_ptr <= (wr_ptr + 1'b1) % DEPTH;

        // end
        // if(rd_en && !empty)begin
        //     rd_data <= fifo[rd_ptr];
        //     rd_ptr <= (rd_ptr + 1'b1) % DEPTH;
        // end

    end
end
endmodule