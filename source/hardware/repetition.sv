module repetition (
    input       sys_clk,
    input       reset_n,
    input       clear,
    input       valid,
    input       [FIELD_SIZE -1:0] field,
    output      [FIELD_SIZE-1:0]  rep_rate,
    output      ready
);
    parameter FIELD_SIZE = 16;
    localparam SIZE = 2 ** FIELD_SIZE;
    
    logic initiate_clear, clearing;

    logic mem[SIZE];
    logic [FIELD_SIZE-1:0] raddr;
    logic [FIELD_SIZE-1:0] waddr;
    logic [FIELD_SIZE-1:0] count;

    logic mem_out, raddr_valid, out_valid, incr, bypass;


    assign initiate_clear = clear & ~clearing;
    assign ready = ~clearing & ~clear & reset_n;
    assign incr = mem_out | bypass;
    assign rep_rate = count;
    
    always @(posedge sys_clk, negedge reset_n) begin

        if (~reset_n) begin
            raddr <= 0;
            waddr <= 0;
            count <= 0;
            clearing <= 0;
            raddr_valid <= 0;
            out_valid <= 0;
            mem_out <= 0;
        end 
        else begin
            if (initiate_clear) begin
                raddr <= 0;
                waddr <= 0;
                count <= 0;
                clearing <= 1;
                raddr_valid <= 0;
                out_valid <= 0;
                bypass <= 0;
            end
            else if (clearing) begin
                waddr <= waddr + 1'b1;
                mem[waddr] <= 0;
                if (&waddr) clearing <= 0;
            end
            else begin
            
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
                    mem[waddr] <= 1;
                    count <= count + incr;
                end
            end
        end
    end



endmodule
