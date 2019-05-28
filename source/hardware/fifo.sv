import global_types::*;

module fifo (
    input       sys_clk,
    avln_st     in,
    avln_st     out
);
    parameter ADDR_W = 8;
    localparam SIZE = 2 ** ADDR_W;

    logic full;
    logic empty;

    Line in_line;
    Line out_line;

    logic [ADDR_W-1:0] addr;

    Line mem [SIZE];
    

    assign in_line.data  = in.data;
    assign in_line.sop   = in.sop;
    assign in_line.eop   = in.eop;
    assign in_line.empty = in.eop ? in.empty :  in.valid;

    assign out.data  = out_line.data;
    assign out.sop   = out_line.sop;
    assign out.eop   = out_line.eop;
    assign out.empty = out_line.eop ? out_line.empty : 0;
    assign out.valid = out_line.eop ? 1 : out_line.empty[0];

    assign in.ready = out.ready;

    integer i;
    initial begin
        for (i = 0; i < SIZE; i = i +1)
            mem[i] = 0;
    end
    
    always_ff @(posedge sys_clk) begin
        out_line  <= mem[addr];
        mem[addr] <= in_line;
        addr <= addr + 1;
    end
endmodule
