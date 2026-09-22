/*
 * Q25 — Flip-Flop Array
 *
 * Implement a synchronous array containing eight 8-bit entries, addressed by a 3-bit addr.
 * - resetn is an active-low synchronous reset. Clear every entry, the written-valid state,
 *   dout, and error.
 * - wr=1, rd=0: write din to addr on the rising edge; set dout=0 and error=0.
 * - rd=1, wr=0: read addr; return dout=0 if that location has not been written since reset.
 * - wr=1, rd=1: perform no read or write; set error=1 and dout=0.
 * - wr=0, rd=0: NOP; set dout=0 and error=0.
 * - All output behavior is clocked/synchronous.
 */
module flip_flop_array
  (input  logic [7:0] din,
   input  logic [2:0] addr,
   input  logic       wr,
   input  logic       rd,
   input  logic       clk,
   input  logic       resetn,
   output logic [7:0] dout,
   output logic       error);

  // TODO: Implement your design here.
  logic [7:0] register [0:7];
  always_ff @( posedge clk ) begin
    if(!resetn)begin
      dout <='0;
      error <= '0;
      for(int i =0 ; i < 8 ; i++)begin
        register[i] <= '0;  
      end
    end else begin
      if(wr && !rd)begin
        register[addr] <= din;
        dout <= '0;
        error <= '0;
      end else if (rd && !wr)begin
        if(register[addr] != '0) dout <= register[addr];
        else dout <= '0;
        error <= '0;
      end else if (wr && rd)begin
        dout <= '0;
        error <= 1'b1;
      end else if (!wr && !rd)begin
        //NOP
        dout <= '0;
        error <= '0;
      end
    end
  end
endmodule
