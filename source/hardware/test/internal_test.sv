`include "global_types.sv"
import global_types::*;

module internal_test();
    logic clk = 0;
    logic reset_n = 0;
    avln_st rx;

    always #5 clk = ~clk;


    initial begin
        #25 reset_n = 1;
    end

    integer f, rc, sop, eop, data;
    string filename = "packets.dat";

    f = $fopen(filename, "r");
    always @(negedge clk) begin
        if ($feof(f)) 
            $finish(0);
        rc = $fscanf(f, "%x %x %x", sop, eop, data);
        if (rc != 3)
            $display("fscanf failed");
    end

    assign rx.data = data;
    assign rx.sop = sop;
    assign rx.eop = eop;
    assign rx.empty = 0;
    assign rx.valid = 1;


    seaccow_internal si0(
            .sys_clk(sys_clk),
            .reset_n(reset_n),
            .in(rx),
            .out(),
            .hex_disp(),
            .LEDG()
    );

endmodule
