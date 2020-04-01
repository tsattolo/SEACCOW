module repetition (
    input       sys_clk,
    input       reset_n,
    input       clear,
    input       valid,
    input       [FIELD_SIZE-1:0] field,
    output      [FIELD_SIZE-1:0]  rep_rate
);
    parameter FIELD_SIZE = 16;
    parameter REPETION_THRESHOLD = 1;
    parameter N_CLR = 3;

    localparam N_REP = 1; //$clog2(REPETION_THRESHOLD);
    localparam WORD_SIZE = N_REP;
    localparam MEM_POOL_SIZE = 4; //Power of two

    logic [$clog2(MEM_POOL_SIZE)-1:0] curr;
    logic done [MEM_POOL_SIZE];

    logic [WORD_SIZE-1:0] mem_out[MEM_POOL_SIZE];
    logic [WORD_SIZE-1:0] mem_in;
    logic threshold_reached;
    
    logic [FIELD_SIZE-1:0] raddr;
    logic [FIELD_SIZE-1:0] waddr [MEM_POOL_SIZE];

    logic [FIELD_SIZE-1:0] count;
    logic raddr_valid, out_valid, count_incr, bypass;
    logic [2:0] clear_d;

    assign threshold_reached = mem_out[curr] == N_REP;
    assign mem_in = threshold_reached ? N_REP : mem_out[curr] + 1'b1;

    assign count_incr = (threshold_reached | bypass) & out_valid;
    assign rep_rate = count;

    genvar i;
    generate
        for (i = 0; i < MEM_POOL_SIZE; i++) begin : pool
            pool_mem #(FIELD_SIZE, WORD_SIZE) mem (
                .sys_clk(sys_clk),
                .reset_n(reset_n),
                .rden(i == curr && raddr_valid),
                .wen((i == curr && out_valid) || (i != curr && ~done[i])),
                .waddr(waddr[i]),
                .raddr(raddr),
                .mem_in(i == curr ? mem_in : '0),
                .mem_out(mem_out[i])
            );
            
            /* if (i == curr) begin */
            /*     if (raddr_valid) begin */
            /*         mem_out[i] <= mem[i][raddr]; */
            /*     end */
            /*     if (out_valid) begin */
            /*         mem[i][waddr[i]] <= mem_in; */
            /*     end */
            /* end */ 
            /* else begin */
            /*     if (~done[i]) begin */
            /*         mem[i][waddr[i]] <= 0; */
            /*     end */
            /* end */
        end
    endgenerate



    integer j;
    always @(posedge sys_clk, negedge reset_n) begin
        if (~reset_n) begin
            count <= 0;
            raddr_valid <= 0;
            out_valid <= 0;
            /* mem_out <= 0; */
            bypass <= 0;
            clear_d <= 0;
            curr <= 0;
            raddr <= 0;
            for (int i = 0; i < MEM_POOL_SIZE; i++) begin
                waddr[i] <= 0;
            end
        end 
        else begin
            for (j = 0; j < MEM_POOL_SIZE; j++) begin
                if (j != curr && ~|clear_d)  begin
                    if (~done[j]) begin
                        {done[j], waddr[j]} <= waddr[j] + 1'b1;
                    end
                end
            end

            clear_d <= {clear_d[1:0], clear};
            if (clear_d[1]) begin
                waddr[curr] <= 0;
                done[curr] <= 0;
                curr <= curr + 1'b1; 
            end

            if (valid) begin
                raddr <= field;
                raddr_valid <= 1;
            end 
            else begin
                raddr_valid <= 0;
            end
            
            if (raddr_valid) begin
                waddr[curr  + clear_d[1]] <= raddr;
                out_valid <= 1;
                bypass <= (waddr[curr] == raddr) & out_valid & ~clear_d[1];
            end
            else begin
                out_valid <= 0;
                bypass <= 0;
            end
            count <= clear_d[2] ? '0 : (count + count_incr);
        end
    end
endmodule

module pool_mem(
    input       sys_clk,
    input       reset_n,
    input       wen,
    input       rden,
    input       [FIELD_SIZE-1:0] waddr,
    input       [FIELD_SIZE-1:0] raddr,
    input       [WORD_SIZE-1:0] mem_in,
    output reg  mem_out
);
    parameter FIELD_SIZE = 16;
    parameter WORD_SIZE = 1;
    localparam SIZE = 2 ** FIELD_SIZE;

    logic [WORD_SIZE-1:0] mem [SIZE];

    `ifdef __ICARUS__
    initial begin
        for (int k = 0; k < SIZE; k++)
            mem[k] = 0;
    end
    `endif
    
    

    always @(posedge sys_clk, negedge reset_n) begin
        if (~reset_n) begin
            mem_out <= 0;
        end
        else begin
            if (wen) begin
                mem[waddr] <= mem_in;
            end
            if (rden) begin
                mem_out <= mem[raddr];
            end
        end
    end
endmodule
    



module windowing (
    input       sys_clk,
    input       reset_n,
    input       valid,
    input       [FIELD_SIZE-1:0] field,
    output reg  found
);
    parameter FIELD_SIZE = 16;
    parameter WINDOW_SIZE = 32;         // Must be power of 2
    parameter THRESHOLD = 5;

    localparam N_WND = $clog2(WINDOW_SIZE);

    logic [N_WND-1:0] window_count;
    logic [FIELD_SIZE-1:0] rep_rate;
    logic clear;
    
    assign clear = &window_count & valid;
    
    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            window_count <= 0;
            found <= 0;
        end
        else begin
            if (valid) begin
                window_count <= window_count + 1'b1;
            end
            found <= rep_rate >= THRESHOLD;
        end
    end

    /* repetition #(8) rep0( */
    repetition #(FIELD_SIZE) rep0(
        .sys_clk(sys_clk),
        .reset_n(reset_n),
        .clear(clear),
        .valid(valid),
        .field(field),
        .rep_rate(rep_rate)
    );


endmodule
