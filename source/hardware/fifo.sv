import global_types::*;

module fifo (
    input       sys_clk,
    input       reset_n,
    input       avln_st     in,
    input       [17:0] SW,
    output      avln_st     out
);
    parameter ADDR_W = 16;
    parameter FLUSH_COUNT_SIZE = 24;
    localparam SIZE = 2 ** ADDR_W;

    Line in_line;
    Line out_line;

    logic [ADDR_W-1:0] addr;

    Line mem [SIZE];
    
    logic ovalid;
    logic valid_after_reset;
    logic flush;
    logic [FLUSH_COUNT_SIZE-1:0] flush_count;

    assign in_line.data  = in.data;
    assign in_line.sop   = in.sop;
    assign in_line.eop   = in.eop;
    assign in_line.empty = in.eop ? in.empty :  in.valid;

    assign out.data  = out_line.data;
    assign out.sop   = out_line.sop & ovalid;
    assign out.eop   = out_line.eop & ovalid;
    assign out.empty = out_line.eop ? out_line.empty : '0;
    assign out.valid = (out_line.eop ? '1 : out_line.empty[0]) & ovalid;
 
    `ifdef __ICARUS__
    initial begin
        for (int i = 0; i < SIZE; i++)
            mem[i] = 0;
    end
    `endif

    assign flush = (SW[0] | &flush_count) & ~SW[1];
    
    
    always_ff @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            addr <= 0;
            out_line <= 0;
            flush_count <= 0;
            valid_after_reset <= 0;
            ovalid <= 0;
        end
        else if (in.valid | flush) begin
            out_line  <= mem[addr];
            mem[addr] <= in_line;
            addr <= addr + 1'b1;
            ovalid <= valid_after_reset;
            flush_count <= flush_count >> in.valid;
            valid_after_reset <= &addr | valid_after_reset;
        end
        else begin
            ovalid <= 1'b0;
            flush_count <= flush_count + 1'b1;
        end
    end
endmodule
