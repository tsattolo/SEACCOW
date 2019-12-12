package global_types;
    parameter B = 8;
    parameter W = 32;
    localparam BpW = W / B;

    /* `define max(a,b) = ((a > b) ? (a) : (b)); */
    function integer max (integer a, integer b);
        return a > b ? a : b;
    endfunction

    typedef logic [W-1:0] Word;
    typedef struct packed {
        Word data;
        logic sop;
        logic eop;
        logic [$clog2(BpW)-1:0] empty;
    } Line;

    /* typedef struct packed { */
    /*     Word data; */
    /*     logic sop; */
    /*     logic eop; */
    /*     logic [$clog2(BpW)-1:0] empty; */
    /* } avln_st; */

endpackage

interface avln_st;
    logic [W-1:0] data;
    logic sop;
    logic eop;
    logic [$clog2(BpW)-1:0] empty;
    logic valid;
    logic ready;
endinterface


