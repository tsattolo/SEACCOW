import global_types::*;

module decision (
    input               sys_clk,
    input               reset_n,
    input               start,
    input               valid,
    input               found,
    input  avln_st      in,
    input  avln_st      fifo_out,
    output avln_st      out,
    output              drop
);

    parameter CTR_SIZE = 24;
    parameter WINDOW_SIZE = 32;
    parameter FOUND_DELAY = 4;

    localparam N_WND = $clog2(WINDOW_SIZE);
    localparam ADDR_SIZE = CTR_SIZE - N_WND;
    localparam SIZE = 2 ** ADDR_SIZE;

    logic [ADDR_SIZE-1:0] raddr;
    logic [ADDR_SIZE-1:0] waddr;

    logic [CTR_SIZE-1:0] out_counter;
    logic [CTR_SIZE-1:0] frame_counter;
    logic [CTR_SIZE-1:0] start_counter;
    logic [CTR_SIZE-1:0] valid_counter[FOUND_DELAY];
    logic mem[SIZE];

    logic window_not_cleared, found_d;
    
    /* logic drop; */
    avln_st fifo_out_d;

    assign raddr = out_counter[CTR_SIZE-1-:ADDR_SIZE];
    assign drop = mem[raddr];

    `ifdef __ICARUS__
    initial begin
        for (int i = 0; i < SIZE; i++)
            mem[i] = 0;
    end
    `endif
    
    
    integer i;
    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n)  begin
            out_counter <= 0;
            frame_counter <= 0;
            start_counter <= 0;
            fifo_out_d <= 0;
            out <= 0;
            window_not_cleared <= 0;
            found_d <= 0;
        end
        else begin
            if (start) 
                start_counter <= frame_counter;
            if (valid)
                valid_counter[0] <= start_counter;

            for (i = 0; i < FOUND_DELAY-1; i++)
                valid_counter[i+1] <= valid_counter[i];

            found_d <= found;

            if(in.sop) begin
                window_not_cleared <= 1'b1;
            end

            if (found) begin
                waddr <= valid_counter[FOUND_DELAY-1][CTR_SIZE-1-:ADDR_SIZE];
            end
            else if (in.sop | window_not_cleared) begin
                waddr <= frame_counter[CTR_SIZE-1-:ADDR_SIZE];
                window_not_cleared <= 1'b0;
            end

            mem[waddr] <= found_d;

            frame_counter <= frame_counter + in.sop;
            out_counter <= out_counter + fifo_out.sop;

            fifo_out_d <= fifo_out;
            out.data <= fifo_out_d.data;
            out.sop <= fifo_out_d.sop;
            out.eop <= fifo_out_d.eop;
            out.empty <= fifo_out_d.empty;
            out.valid <= fifo_out_d.valid & ~drop;
        end
        
    end

    
endmodule
