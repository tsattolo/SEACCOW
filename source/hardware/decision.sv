import global_types::*;

module decision (
    input       sys_clk,
    input       reset_n,
    input       found,
    avln_st     in,
    avln_st     fifo_out,
    avln_st     out
);

    parameter FOUND_DELAY = 4;
    parameter CTR_SIZE = 10;
    parameter WINDOW_SIZE = 32;

    localparam N_WND = $clog2(WINDOW_SIZE);
    localparam ADDR_SIZE = CTR_SIZE - N_WND;
    localparam MEM_SIZE = 2 ** ADDR_SIZE;

    logic [ADDR_SIZE-1:0] raddr;
    logic [ADDR_SIZE-1:0] waddr;

    assign raddr = out_counter[CTR_SIZE-1-:ADDR_SIZE];
    assign waddr = found_counter[CTR_SIZE-1-:ADDR_SIZE];

    logic [FOUND_DELAY-1:0] sop_sr;
    logic [CTR_SIZE-1:0] found_counter;
    logic [CTR_SIZE-1:0] out_counter;
    logic mem[MEM_SIZE];
    
    logic drop;

    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n)  begin
            sop_sr <= 0;
            out_counter <= 0;
            found_counter <= 0;
        end
        else begin
            sop_sr <= {in.sop, sop_sr[FOUND_DELAY-1:1]}
            found_counter <= found_counter + sop_sr[0];
            mem[waddr] <= found;

            out_counter <= out_counter + out.sop;
            drop <= mem[raddr];

            out.data <= fifo_out.data;
            out.sop <= fifo_out.sop;
            out.eop <= fifo_out.eop;
            out.empty <= fifo_out.empty;
            out.valid <= fifo_out.valid & ~drop;
        end
        
    end
endmodule
