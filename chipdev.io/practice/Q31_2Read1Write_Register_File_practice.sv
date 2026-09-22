/*
 * Q31 — Two-Read/One-Write Register File
 *
 * Implement a synchronous register file with 32 entries of DATA_WIDTH bits, one write port,
 * and two read ports.
 * - resetn is an active-low synchronous reset. Clear the register file, written-valid bits,
 *   outputs, and collision.
 * - wen1, ren1, and ren2 enable the wad1 write, rad1 read, and rad2 read ports, respectively.
 * - Return 0 when reading a location that has not been written since reset.
 * - At the start of each non-reset cycle, default dout1, dout2, and collision to 0; only return
 *   values for reads requested during that cycle.
 * - If any two enabled operations use the same address in one cycle, assert collision and perform
 *   none of that cycle's reads or writes.
 * - If all enabled addresses differ, one write and two reads may complete in the same cycle.
 * - Preserve the original address widths. With the default DATA_WIDTH=16, addresses are 5 bits
 *   wide and can address all 32 entries.
 */
module tworead1write_register_file #(parameter DATA_WIDTH=16)
  (input  logic                          clk,
   input  logic                          resetn,
   input  logic [DATA_WIDTH-1:0]         din,
   input  logic [$clog2(DATA_WIDTH):0]   wad1,
   input  logic [$clog2(DATA_WIDTH):0]   rad1, //addr
   input  logic [$clog2(DATA_WIDTH):0]   rad2, //addr
   input  logic                          wen1, //enable
   input  logic                          ren1, //enable
   input  logic                          ren2, //enable
   output logic [DATA_WIDTH-1:0]         dout1,
   output logic [DATA_WIDTH-1:0]         dout2,
   output logic                          collision);

  // TODO: Implement your design here.
  typedef struct packed {
    logic [DATA_WIDTH-1:0] data;
    logic wr;
  } register_pack;
  logic collsion_condition;

  register_pack register[0:31];
  always_ff @( posedge clk ) begin
    if(!resetn)begin
      dout1 <= '0;
      dout2 <= '0;
      collision <= '0;
      for(int i =0 ;i < 32 ; i++)begin
        register[i] <= '0;
      end
    end else begin
      collision <= collsion_condition;
      if(collsion_condition)begin
        dout1 <= '0;
        dout2 <= '0;
      end
      if(!collsion_condition)begin
        if(wen1)begin
          register[wad1].data <= din;
          register[wad1].wr <= 1'b1;
        end 
        if (ren1)begin
          if(!register[rad1].wr)dout1 <= '0;
          else dout1 <= register[rad1].data;
        end else dout1 <= '0;
        if (ren2)begin
          if(!register[rad2].wr)dout2 <= '0;
          else dout2 <= register[rad2].data;
        end else dout2 <= '0;
      end


    end
  
  end


  assign collsion_condition = ((wen1 && ren1) && (wad1 == rad1) ||
                              (wen1 && ren2) && (wad1 == rad2) ||
                              (ren1 && ren2) && (rad1 == rad2));


endmodule
