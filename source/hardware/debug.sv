import global_types::*;


module display_frame (
    input       sys_clk,
    input       reset_n,
    
    avln_st     in,
    avln_st     out,

    input  [17:0] SW,
    input  [3:0] KEY,
    output [7:0] LEDG,
    output [6:0] hex_disp [2*BpW]
);
    logic [16:0] count;
    logic [16:0] counter;

    Word word;
    logic sopc;
    logic eopc;
    logic [1:0] emptyc;

    assign LEDG[0] = count == SW[16:0];
    assign LEDG[3] = sopc;
    assign LEDG[4] = eopc;
    assign LEDG[6:5] = emptyc; 


    assign count = in.sop & SW[17] ? 0 : counter;

    always_ff @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin 
            counter <=0;
            word <= 0;
            sopc <= 0;
            eopc <= 0;
            emptyc <= 0;
        end
        else begin
            if (~KEY[1]) begin
                word <= 0;
                counter <= 0;
                sopc <= 0;
                eopc <= 0;
                emptyc <= 0;
            end
            else if (in.valid) begin 
                if (count == SW[16:0]) begin
                    word <= in.data;
                    sopc <= in.sop;
                    eopc <= in.eop;
                    emptyc <= in.empty;
                end
                counter <= count + 1;
            end
        end
    end

    hex_decoder h0 (
        .data(word),
        .disp(hex_disp)
    );
endmodule

module hex_decoder(
    input Word  data,
    output [6:0] disp [2*BpW]

);
    logic [2*BpW-1:0][B/2-1:0] nibbles;
    assign nibbles = data;

    genvar i;
    generate
        for (i = 0; i < 2*BpW; i = i + 1) begin : gen_hex
            always_comb begin
                case (nibbles[i])
                    4'h0 : disp[i] = ~7'b0111111;
                    4'h1 : disp[i] = ~7'b0000110;
                    4'h2 : disp[i] = ~7'b1011011;
                    4'h3 : disp[i] = ~7'b1001111;
                    4'h4 : disp[i] = ~7'b1100110;
                    4'h5 : disp[i] = ~7'b1101101;
                    4'h6 : disp[i] = ~7'b1111101;
                    4'h7 : disp[i] = ~7'b0000111;
                    4'h8 : disp[i] = ~7'b1111111;
                    4'h9 : disp[i] = ~7'b1101111;
                    4'hA : disp[i] = ~7'b1110111;
                    4'hB : disp[i] = ~7'b1111100;
                    4'hC : disp[i] = ~7'b0111001;
                    4'hD : disp[i] = ~7'b1011110;
                    4'hE : disp[i] = ~7'b1111001;
                    4'hF : disp[i] = ~7'b1110001;
                endcase
            end
        end
    endgenerate

endmodule
