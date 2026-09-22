// today if the input clock is 100 MHZ, the question want to design a clock divier that can 
// output an clock signal which is 25MHz

module clk_divier(
    input logic clk_100mhz,
    input logic rst_n,
    output logic clk_25mhz
);

logic [1:0] counter;
always_ff @(posedge clk_100mhz or negedge rst_n) begin
    if(!rst_n)begin
        counter <= 2'b00;
        clk_25mhz <= 1'b0;
    end
    if(counter == 2'b10)begin
        clk_25mhz <= ~clk_25mhz;
        counter <= 2'b00;
    end
    else begin
        counter <= counter + 1'b1;
    end
end 
endmodule