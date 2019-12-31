import global_types::*;
`define max(a,b) ((a > b) ? (a) : (b))

module seaccow_internal (
    input       sys_clk,
    input       reset_n,
    input       avln_st     in,
    input       [17:0] SW,
    output      avln_st     out,
    output [6:0] hex_disp [2*BpW],
    output [8:0]     LEDG
);
    avln_st fifo_out;

    logic ipv4_start;

    find_ipv4_start fip0 (
        .sys_clk(sys_clk),
        .reset_n(reset_n),
        .in(in),
        .packet_start(ipv4_start)
    );


    logic [31:0] ip_header_first_byte;


    localparam IP_ID_SIZE = 16;
    logic [IP_ID_SIZE-1:0] ip_id;
    logic ip_id_valid;
    get_field #(
        .FIELD_SIZE(IP_ID_SIZE),
        .WORD_INDEX(1),
        .OFFSET(0)
    ) 
        get_ip_id (
            .sys_clk(sys_clk),
            .reset_n(reset_n),
            .in(in),
            .start(ipv4_start),
            .field(ip_id),
            .valid(ip_id_valid)
    );
    
    localparam WINDOW_SIZE = 32;
    logic ip_id_found;
    assign LEDG[0] = ip_id_found;
    windowing #(
        .FIELD_SIZE(IP_ID_SIZE),
        .WINDOW_SIZE(WINDOW_SIZE)
    )
        win0 (
            .sys_clk(sys_clk),
            .reset_n(reset_n),
            .valid(ip_id_valid),
            .field(ip_id),
            .found(ip_id_found)
    );

    localparam FIFO_ADDR_SIZE = 16;
    fifo #(
        .ADDR_W(FIFO_ADDR_SIZE)
    )
        f0 (
            .sys_clk(sys_clk),
            .reset_n(reset_n),
            .in(in),
            .SW(SW),
            .out(fifo_out)
    );

    logic drop;
    decision #(
        .CTR_SIZE(FIFO_ADDR_SIZE + 1), 
        .WINDOW_SIZE(WINDOW_SIZE)
    )
        dec0 (
            .sys_clk(sys_clk),
            .reset_n(reset_n),
            .start(ipv4_start),
            .valid(ip_id_valid),
            .found(ip_id_found),
            .in(in),
            .fifo_out(fifo_out),
            .out(out),
            .drop(drop)
    );

    logic [31:0] drop_count;
    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            drop_count <= 0;
        end else begin
            drop_count <= drop_count + (drop & out.sop);
        end
    end
            


    /* /1* logic ip_id_rep_ready; *1/ */
    /* logic [IP_ID_SIZE-1:0] ip_id_rep; */
    /* fast_repetition #(IP_ID_SIZE) rep0( */
    /*     .sys_clk(sys_clk), */
    /*     .reset_n(reset_n), */
    /*     .clear(ip_flags_valid), */
    /*     .valid(ip_id_valid), */
    /*     .field(ip_id), */
    /*     .rep_rate(ip_id_rep), */
    /*     /1* .ready(ip_id_rep_ready) *1/ */
    /* ); */


    `ifndef __ICARUS__
    hex_decoder h0 (
        .data(drop_count),
        .disp(hex_disp)
    );
    `endif
    
    
endmodule

module count_words(
    input                       sys_clk,
    input                       reset_n,
    input avln_st               in,
    input                       start,
    input                       stop,
    input [CNT_SIZE-1:0]        target,
    output                      found

);
    parameter CNT_SIZE = 1;

    logic done;
    logic [CNT_SIZE-1:0] count;
    logic [CNT_SIZE-1:0] counter;

    assign count = start ? '0 : counter;
    assign found = (count == target) & (~done|start) & in.valid;

    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            counter <= 0;
            done <= 1;
        end
        else begin
            if (start) done <= 0;
            if (stop) done <= 1;
            counter <= count + in.valid;
        end
    end
endmodule

module get_field (
    input                       sys_clk,
    input                       reset_n,
    input avln_st               in,
    input                       start,
    output logic [FIELD_SIZE-1:0]   field,
    output logic                valid
);

    parameter FIELD_SIZE = 8;
    parameter WORD_INDEX = 0;
    parameter OFFSET = 0;

    localparam CNT_SIZE = `max($clog2(WORD_INDEX + 1), 1);

    logic found;

    count_words #(CNT_SIZE) cw0 (
        .sys_clk(sys_clk),
        .reset_n(reset_n),
        .in(in),
        .start(start),
        .stop(valid),
        .target(WORD_INDEX[CNT_SIZE-1:0]),
        .found(found)
    );

    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            valid <= 0;
            field <= 0;
        end
        else begin
            if (found) begin
                field <= in.data[W-OFFSET-1:W-OFFSET-FIELD_SIZE];
                valid <= 1;
            end
            else if (valid) valid <= 0;
        end
    end
endmodule


module find_ipv4_start (
    input               sys_clk, 
    input               reset_n,
    input avln_st       in,
    output logic        packet_start
);

    localparam IPV4_ETHERTYPE = 16'h0800;
    localparam VLAN_ETHERTYPE = 16'h8100;
    localparam VLAN2_ETHERTYPE = 16'h9100;

    localparam NO_VLAN_ETHERTYPE_INDEX = 3;
    localparam MAX_VLAN_TAGS = 2;
    localparam CNT_SIZE = `max($clog2(NO_VLAN_ETHERTYPE_INDEX + MAX_VLAN_TAGS + 1), 1);

    logic found, packet_start_comb, notfound;
    logic [$clog2(MAX_VLAN_TAGS+1)-1:0] n_vlan_tags_comb;
    logic [$clog2(MAX_VLAN_TAGS+1)-1:0] n_vlan_tags;
    logic [CNT_SIZE-1:0] ethertype_index;

    assign ethertype_index = CNT_SIZE'(NO_VLAN_ETHERTYPE_INDEX) + n_vlan_tags;

    count_words #(CNT_SIZE) cw0 (
        .sys_clk(sys_clk),
        .reset_n(reset_n),
        .in(in),
        .start(in.sop),
        .stop(packet_start_comb|notfound),
        .target(ethertype_index),
        .found(found)
    );

    always_comb begin
        notfound = 0;
        packet_start_comb = 0;
        n_vlan_tags_comb = n_vlan_tags;
        if (found) begin
            case (in.data[2*B-1:0])
                IPV4_ETHERTYPE:     packet_start_comb = 1;
                VLAN_ETHERTYPE:     n_vlan_tags_comb = 1;
                VLAN2_ETHERTYPE:    n_vlan_tags_comb = 2;
                default:            notfound = 1;
            endcase
        end
    end

    always @(posedge sys_clk or negedge reset_n) begin
        if (~reset_n) begin
            n_vlan_tags <= 0;
            packet_start <= 0;
        end
        else begin
            n_vlan_tags <= n_vlan_tags_comb;
            packet_start <= packet_start_comb;
        end
    end

/*     always_ff @(posedge sys_clk or negedge reset_n) begin */
/*         if (~reset_n) begin */
/*             counter <= 0; */
/*             done <= 1; */
/*             start <= 0; */
/*         end */
/*         else begin */
/*             if (in.sop) done <= 1'b0; */
/*             if (start) begin */
/*                 done <= 1'b1; */
/*                 start <= 1'b0; */
/*             end */

/*             if (in.valid) begin */
/*                 if ((count == ethertype_index) & (~done|in.sop)) begin */
/*                     case (in.data[2*B-1:0]) */
/*                         IPV4_ETHERTYPE:     start <= 1'b1; */
/*                         VLAN_ETHERTYPE:     n_vlan_tags <= 2'd1; */
/*                         VLAN2_ETHERTYPE:    n_vlan_tags <= 2'd2; */
/*                         default:            done <= 1'b1; */
/*                     endcase */
/*                 end */
/*                 counter <= count + 1; */
/*             end */
/*         end */
/*     end */

endmodule
