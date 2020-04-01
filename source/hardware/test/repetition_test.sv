module repetition_test ();
    localparam FIELD_SIZE = 16;

    logic clk = 0;
    logic reset_n = 0;

    logic valid = 0, ready, clear = 0;

    logic [FIELD_SIZE-1:0] field ;
    logic [FIELD_SIZE-1:0] rep_rate;
    logic [FIELD_SIZE-1:0] nreps;
    
    always #5 clk = ~clk;

    /* reg [15:0] data [0:3]; */
    /* int i; */
    /* initial begin */
    /*     $readmemh("reptest_data", data); */
    /*     for (i=0; i < 4; i=i+1) */
    /*         $display("%d:%h",i,data[i]); */
    /* end */

    integer f, rc, line;
    string filename;
    int dump = 0;
    initial begin
        if(!$value$plusargs("FN=%s", filename))
            $warning(1);

        if(!$value$plusargs("dump=%d", dump))
            $warning(1);

        if (dump) begin
            $dumpfile("repetition_test.vcd");
            $dumpvars(0,repetition_test);
        end
        f = $fopen(filename, "r");
        rc = $fscanf(f, "%d\n", nreps);
        if (rc != 1) begin 
            $display("fscanf failed");
        end
        #25 reset_n = 1;
    end

    int endticks = 0;
    always @(negedge clk) begin
        if ($feof(f)) begin
            valid = 0;
            endticks += 1;
            if (endticks == 4)
                if(rep_rate == nreps) begin
                    $display("Passed, %d reps found %d expected", rep_rate, nreps);
                    $finish(0);
                end
                else begin 
                    $display("Failed, %d reps found %d expected", rep_rate, nreps);
                    $finish(1);
                end
        end
        else if(ready) begin
            rc = $fscanf(f, "%d\n", line);
            if (rc != 1) begin 
                $display("fscanf failed");
            end
            valid = 1;
            field  = line;
            if (line < 0) begin
                clear = 1;
                rc = $fscanf(f, "%d\n", field);
                if (rc != 1) begin 
                    $display("fscanf failed");
                end
            end
            else begin 
                clear = 0;
                field = line;

            end
        end
        /* $display("ready:%x", ready); */
        /* $display("%x,%d,%d", field[FIELD_SIZE-1:0], rep_rate[FIELD_SIZE-1:0], valid); */
        /* $display("rr:%d\n", rep_rate); */

    end

    repetition #(FIELD_SIZE) rep0(
        .sys_clk(clk),
        .reset_n(reset_n),
        .clear(clear),
        .valid(valid),
        .field(field),
        .rep_rate(rep_rate)
        /* .ready(ready) */
    );
    assign ready = reset_n;


endmodule
