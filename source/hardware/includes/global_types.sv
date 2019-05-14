package global_types;
    parameter B = 8;
    parameter W = 32;

    typedef logic [W-1:0] Word;
    typedef struct packed {
        Word data;
        logic sop;
        logic eop;
        logic [$clog2(W/B)-1:0] empty;
    } Line;

endpackage

interface avln_st;
    Line  line;
    logic valid;
    logic ready;
endinterface


