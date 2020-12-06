module fast_repetition (
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
    localparam SIZE = 2 ** FIELD_SIZE;
    localparam WORD_SIZE = N_REP * N_CLR;
    localparam INITIAL_MASK = WORD_SIZE'((1 << N_REP) - 1);

    logic [WORD_SIZE-1:0] mem [SIZE];
    logic [WORD_SIZE-1:0] mem_out;
    logic [WORD_SIZE-1:0] mem_in;
    logic [WORD_SIZE-1:0] mask;
    logic [WORD_SIZE-1:0] rep_incr;
    logic [WORD_SIZE-1:0] threshold;
    logic threshold_reached;
    
    logic [FIELD_SIZE-1:0] raddr;
    logic [FIELD_SIZE-1:0] waddr;
    logic [FIELD_SIZE-1:0] count;
    logic raddr_valid, out_valid, count_incr, bypass;
    logic [2:0] clear_d;

    assign threshold_reached = (mem_out & mask) == threshold;
    assign mem_in = threshold_reached ? threshold : (mem_out + rep_incr) & mask;

    assign count_incr = (threshold_reached | bypass) & out_valid;
    assign rep_rate = count;

    `ifdef __ICARUS__
    initial begin
        for (int i = 0; i < SIZE; i++)
            mem[i] = 0;
    end
    `endif
    
    
    
    always @(posedge sys_clk, negedge reset_n) begin
        if (~reset_n) begin
            raddr <= 0;
            waddr <= 0;
            count <= 0;
            raddr_valid <= 0;
            out_valid <= 0;
            mem_out <= 0;
            mask <= INITIAL_MASK;
            rep_incr <= 1;
            threshold <= REPETION_THRESHOLD;
            bypass <= 0;
            clear_d <= 0;
        end 
        else begin
            clear_d <= {clear_d[1:0], clear};
            if (clear_d[0]) begin
                mask <= {mask[WORD_SIZE-N_REP-1:0], mask[WORD_SIZE-1:WORD_SIZE-N_REP]};     
                rep_incr <= {rep_incr[WORD_SIZE-N_REP-1:0], rep_incr[WORD_SIZE-1:WORD_SIZE-N_REP]};   
                threshold <= {threshold[WORD_SIZE-N_REP-1:0], threshold[WORD_SIZE-1:WORD_SIZE-N_REP]};   
            end

            if (valid) begin
                raddr <= field;
                raddr_valid <= 1;
            end 
            else begin
                raddr_valid <= 0;
            end
            
            if (raddr_valid) begin
                waddr <= raddr;
                mem_out <= mem[raddr];
                out_valid <= 1;
                bypass <= (waddr == raddr) & out_valid;
            end
            else begin
                out_valid <= 0;
                bypass <= 0;
            end
            
            if (out_valid) begin
                mem[waddr] <= mem_in;
            end
            count <= (clear_d[1] ? '0 : count) + count_incr;
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
    parameter THRESHOLD = 1;

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

    fast_repetition #(FIELD_SIZE) rep0(
        .sys_clk(sys_clk),
        .reset_n(reset_n),
        .clear(clear),
        .valid(valid),
        .field(field),
        .rep_rate(rep_rate)
    );


endmodule
