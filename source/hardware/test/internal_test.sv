`include "global_types.sv"
import global_types::*;

module internal_test();
    logic clk = 0;
    logic reset_n = 0;
    avln_st rx;

    always #5 clk = ~clk;


    initial begin
        f = $fopen("packets.dat", "r");
        $dumpfile("internal.vcd");
        $dumpvars(0,internal_test);
        #20 reset_n = 1;
    end

    integer f, rc, sop, eop, data, end_count = 0;

    always @(negedge clk) begin
        if (reset_n) begin
            if ($feof(f)) begin 
                end_count = end_count + 1;
                if (end_count == 2 ** 16)
                    $finish(0);
            end
            else begin
                rc = $fscanf(f, "%x %x %x\n", sop, eop, data);
                if (rc != 3)
                    $display("fscanf failed");
            end
        end
    end

    assign rx.data = data;
    assign rx.sop = sop;
    assign rx.eop = eop;
    assign rx.empty = 0;
    assign rx.valid = 1;


    seaccow_internal si0(
            .sys_clk(clk),
            .reset_n(reset_n),
            .in(rx),
            .out(),
            .hex_disp(),
            .LEDG()
    );

endmodule
