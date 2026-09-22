module pipeline_reg #(
    parameter WIDTH = 32
)(
    input logic  clk,
    input logic  rst_n,

    input logic in_valid,
    output logic in_ready,
    input logic [WIDTH-1:0] in_data,

    output logic out_valid, // whether there is data want to output? 
    input logic out_ready,  // whether the other module is ready to receive the data?
    output logic  [WIDTH-1:0] out_data

);

    assign in_ready= !out_valid || out_ready; // whether we can input a data
    always_ff @( posedge clk or negedege rst_n ) begin 
        if(!rst_n) begin
            out_valid <= 1'b0;
        end
        else if (in_ready)begin
            out_valid <= in_valid;
            if(in_valid)begin
                out_data <= in_data;
            end
        end
    end
endmodule