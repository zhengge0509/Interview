module master_slave_controller #(
    parameter int ADDR_W = 32,
    parameter int DATA_W = 32,
    parameter int DEPTH  = 8

)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  allocate,
    input  logic [ADDR_W - 1 : 0] addr_from_master,
    output logic [$clog2(DEPTH)- 1 : 0] tag_to_slave,
    output logic [ADDR_W - 1 : 0] addr_to_slave,
    // output logic                        push_valid,
    input  logic [$clog2(DEPTH)- 1 : 0] tag_from_slave,
    input  logic                        slave_to_controller_valid,
    input  logic [DATA_W - 1 : 0] data_from_slave,

    output logic [DATA_W - 1 : 0] data_to_master,
    input  logic                  master_ready,
    output logic                  pop_valid

);
    typedef struct packed {
        logic [ADDR_W  - 1 :0]addr;
        logic [DATA_W - 1 : 0]data;
        logic complete_tag;
        logic [$clog2(DEPTH)-1:0] tag;
    } controller_packet;

    controller_packet fifo [DEPTH];
    logic [$clog2(DEPTH)-1:0] head,tail;
    logic [$clog2(DEPTH)-1:0] next_head, next_tail;
    logic  retire;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            for(int i = 0 ; i< DEPTH; i++)begin
                fifo[i] <= '0;
            end
            head <= '0;
            tail <= '0;
            push_valid <= '0;
            // pop_valid <= '0;
            tag_to_slave <= '0;
            addr_to_slave <= '0;
        end else begin
        
            else if(allocate)begin
                fifo[tail].addr <= addr_from_master;
                fifo[tail].complete_tag <= 1'b0;
                tag_to_slave <= tail;
                // push_valid <= 1'b1;
                addr_to_slave <= addr_from_master;
            end
            
            if(retire)begin
                // data_to_master <= fifo[head].data;
                // pop_valid <= 1'b1;
                fifo[head].complete_tag <= '0;
            end

            if(slave_to_controller_valid)begin
                fifo[tag_from_slave].data <= data_from_slave;
                fifo[tag_from_slave].complete_tag <= 1'b1;
            end
            head <= next_head;
            tail <= next_tail;
        end
    end

    always_comb begin
        next_tail = tail;
        next_head = head;
        case ({allocate, retire})
            2'b10: next_tail = next_tail + 1'b1;
            2'b01: next_head = next_head + 1'b1;
            2'b11: next_tail = next_tail + 1'b1;  next_head = next_head + 1'b1;
            default: 
        endcase
    end

    assign pop_valid = (fifo[head].complete_tag == 1);
    assign data_to_master = fifo[head].data;
    assign retire = (pop_valid && master_ready);
endmodule


// master 輸出in-order 的read address -> controller -> slave, but slave is able to return the data out-of-order,
// this contoller is used to be a module that can return to the master in-order
