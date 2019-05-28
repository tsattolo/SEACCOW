import global_types::*;

module seaccow_internal (
    input       sys_clk,
    input       reset_n,
    avln_st     in,
    avln_st     out,
    output [6:0] hex_disp [2*BpW]
);
    logic ipv4_start;

    find_ipv4_start fip0 (
            .sys_clk(sys_clk),
            .reset_n(reset_n),
            .in(in),
            .start(ipv4_start)
    );


    logic [31:0] ip_header_first_byte;
    logic valid;

    get_field #(32,1,0 ) g0 (
            .sys_clk(sys_clk),
            .reset_n(reset_n),
            .in(in),
            .start(ipv4_start),
            .field(ip_header_first_byte),
            .valid(valid)
    );
    

    hex_decoder h0 (
        .data(ip_header_first_byte),
        /* .data(W'(ip_header_first_byte)), */
        .disp(hex_disp)
    );
    
    
    
    fifo f0 (
            .sys_clk(sys_clk),
            .in(in),
            .out(out)
    );



endmodule

module count_words(
    input                       sys_clk,
    input                       reset_n,
    avln_st                     in,
    input                       start,
    input                       target,
    output                      found

);
    parameter CNT_SIZE = 1;

    logic done;
    logic [CNT_SIZE-1:0] count;
    logic [CNT_SIZE-1:0] counter;

    assign count = start ? 0 : counter;
    assign found = (count == target) & (~done|start);

    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            counter <= 0;
            done <= 1;
        end
        else begin
            if (start) done <= 1'b0;
            if (found) done <= 1'b1;
            counter <= count + in.valid;
        end
    end
endmodule

module get_field (
    input                       sys_clk,
    input                       reset_n,
    avln_st                     in,
    input                       start,
    output logic [N_BITS-1:0]   field,
    output logic                valid
);

    parameter N_BITS = 8;
    parameter WORD_INDEX = 0;
    parameter OFFSET = 0;


    localparam CNT_SIZE = max($clog2(WORD_INDEX + 1), 1);

    logic done;
    logic [CNT_SIZE-1:0] count;
    logic [CNT_SIZE-1:0] counter;

    assign count = start ? 0 : counter;

    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            counter <= 0;
            done <= 1;
            valid <= 0;
            field <= 0;
        end
        else begin
            if (start) done <= 1'b0;
            
            if (valid) begin
                done <= 1'b1;
                valid <= 1'b0;
            end
    
            if (in.valid) begin
                if ((count == WORD_INDEX) & (~done|start)) begin
                    field <= in.data[W-1-OFFSET-:N_BITS];
                    valid <= 1'b1;
                end 
                counter <= count + 1;
            end
        end
        
    end

    

endmodule


module find_ipv4_start (
    input               sys_clk,
    input               reset_n,
    avln_st             in,
    output logic        start
);

    localparam IPV4_ETHERTYPE = 16'h0800;
    localparam VLAN_ETHERTYPE = 16'h8100;
    localparam VLAN2_ETHERTYPE = 16'h9100;

    localparam NO_VLAN_ETHERTYPE_INDEX = 3;
    localparam MAX_VLAN_TAGS = 2;
    localparam CNT_SIZE = max($clog2(NO_VLAN_ETHERTYPE_INDEX + MAX_VLAN_TAGS + 1), 1);

    logic done;
    logic [$clog2(MAX_VLAN_TAGS+1)-1:0] n_vlan_tags;           //  for vlan tags
    logic [CNT_SIZE-1:0] count;
    logic [CNT_SIZE-1:0] counter;
    logic [CNT_SIZE-1:0] ethertype_index;


    assign ethertype_index = NO_VLAN_ETHERTYPE_INDEX + n_vlan_tags;
    assign count = in.sop ? 0 : counter;

    always_ff @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            counter <= 0;
            done <= 1;
            start <= 0;
        end
        else begin
            if (in.sop) done <= 1'b0;
            if (start) begin
                done <= 1'b1;
                start <= 1'b0;
            end

            if (in.valid) begin
                if ((count == ethertype_index) & (~done|in.sop)) begin
                    case (in.data[2*B-1:0])
                        IPV4_ETHERTYPE:     start <= 1'b1;
                        VLAN_ETHERTYPE:     n_vlan_tags <= 2'd1;
                        VLAN2_ETHERTYPE:    n_vlan_tags <= 2'd2;
                        default:            done <= 1'b1;
                    endcase
                end
                counter <= count + 1;
            end
        end
        
    end
endmodule



