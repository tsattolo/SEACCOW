`include "global_types.sv"
import global_types::*;

module seaccow (
    // Clock
    input         CLOCK_50,
    
    // KEY
    input  [3: 0] KEY,
    input  [17:0] SW,
        
    // LED
    output  [8:0] LEDG,
    output  [17:0] LEDR,

    // HEX
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [6:0] HEX6,
    output [6:0] HEX7,

    // Ethernet 0
    output        ENET0_GTX_CLK,
    output        ENET0_MDC,
    inout         ENET0_MDIO,
    output        ENET0_RESET_N,
    input         ENET0_RX_CLK,
    input  [3: 0] ENET0_RX_DATA,
    input         ENET0_RX_DV,
    output [3: 0] ENET0_TX_DATA,
    output        ENET0_TX_EN,

    // Ethernet 1
    output        ENET1_GTX_CLK,
    output        ENET1_MDC,
    inout         ENET1_MDIO,
    output        ENET1_RESET_N,
    input         ENET1_RX_CLK,
    input  [3: 0] ENET1_RX_DATA,
    input         ENET1_RX_DV,
    output [3: 0] ENET1_TX_DATA,
    output        ENET1_TX_EN
);

    wire sys_clk, clk_125, clk_25, clk_2p5, core_reset_n;
    wire tx_clk_0, mdio_oen_0, mdio_out_0, eth_mode_0, ena_10_0;
    wire tx_clk_1, mdio_oen_1, mdio_out_1, eth_mode_1, ena_10_1;
    
    
    assign ENET0_MDIO = mdio_oen_0 ? 1'bz : mdio_out_0;
    assign ENET1_MDIO = mdio_oen_1 ? 1'bz : mdio_out_1;
    assign ENET0_RESET_N = core_reset_n;
    assign ENET1_RESET_N = core_reset_n;

    assign tx_clk_0 = eth_mode_0 ? clk_125 :       // GbE Mode   = 125MHz clock
                      ena_10_0   ? clk_2p5 :       // 10Mb Mode  = 2.5MHz clock
                                   clk_25;         // 100Mb Mode = 25 MHz clock

    assign tx_clk_1 = eth_mode_1 ? clk_125 :       // GbE Mode   = 125MHz clock
                      ena_10_1   ? clk_2p5 :       // 10Mb Mode  = 2.5MHz clock
                                   clk_25;         // 100Mb Mode = 25 MHz clock

    my_pll pll_inst(
        .areset	(~KEY[0]),
        .inclk0	(CLOCK_50),
        .c0	(sys_clk),
        .c1	(clk_125),
        .c2	(clk_25),
        .c3	(clk_2p5),
        .locked	(core_reset_n)
    ); 
	
    ddio_out ddio_out_0(
            .datain_h(1'b1),
            .datain_l(1'b0),
            .outclock(tx_clk_0),
            .dataout(ENET1_GTX_CLK)
    );

    ddio_out ddio_out_1(
            .datain_h(1'b1),
            .datain_l(1'b0),
            .outclock(tx_clk_1),
            .dataout(ENET0_GTX_CLK)
    );


    avln_st tx_0(), rx_1();
    wire [5:0] rx_error; 
	
    ethernet_pt pt_inst (
        .clk_clk                                (sys_clk),      
        .reset_reset_n                          (core_reset_n), 

        .tse_0_mac_rgmii_connection_rgmii_in    (ENET0_RX_DATA),
        .tse_0_mac_rgmii_connection_rgmii_out   (ENET0_TX_DATA),
        .tse_0_mac_rgmii_connection_rx_control  (ENET0_RX_DV),  
        .tse_0_mac_rgmii_connection_tx_control  (ENET0_TX_EN),  
        .tse_0_pcs_mac_rx_clock_connection_clk  (ENET0_RX_CLK), 
        .tse_0_pcs_mac_tx_clock_connection_clk  (tx_clk_0),     
        .tse_0_mac_status_connection_eth_mode   (eth_mode_0),   
        .tse_0_mac_status_connection_ena_10     (ena_10_0),     
        .tse_0_mac_mdio_connection_mdc          (ENET0_MDC),    
        .tse_0_mac_mdio_connection_mdio_in      (ENET0_MDIO),   
        .tse_0_mac_mdio_connection_mdio_out     (mdio_out_0),   
        .tse_0_mac_mdio_connection_mdio_oen     (mdio_oen_0),   

        .tse_1_mac_rgmii_connection_rgmii_in    (ENET1_RX_DATA),
        .tse_1_mac_rgmii_connection_rgmii_out   (ENET1_TX_DATA),
        .tse_1_mac_rgmii_connection_rx_control  (ENET1_RX_DV),  
        .tse_1_mac_rgmii_connection_tx_control  (ENET1_TX_EN),  
        .tse_1_pcs_mac_rx_clock_connection_clk  (ENET1_RX_CLK), 
        .tse_1_pcs_mac_tx_clock_connection_clk  (tx_clk_1),     
        .tse_1_mac_status_connection_eth_mode   (eth_mode_1),   
        .tse_1_mac_status_connection_ena_10     (ena_10_1),     
        .tse_1_mac_mdio_connection_mdc          (ENET1_MDC),    
        .tse_1_mac_mdio_connection_mdio_in      (ENET1_MDIO),   
        .tse_1_mac_mdio_connection_mdio_out     (mdio_out_1),   
        .tse_1_mac_mdio_connection_mdio_oen     (mdio_oen_1),   

	.tse_0_transmit_data            (tx_0.data),
	.tse_0_transmit_startofpacket   (tx_0.sop),
	.tse_0_transmit_endofpacket     (tx_0.eop),
	.tse_0_transmit_empty           (tx_0.empty),
	.tse_0_transmit_error           (0),
	.tse_0_transmit_ready           (tx_0.ready),
	.tse_0_transmit_valid           (tx_0.valid),

	.tse_1_receive_data             (rx_1.data),
	.tse_1_receive_endofpacket      (rx_1.eop),
	.tse_1_receive_startofpacket    (rx_1.sop),
	.tse_1_receive_empty            (rx_1.empty),
	.tse_1_receive_error            (rx_error),
	.tse_1_receive_ready            (rx_1.ready),
	.tse_1_receive_valid            (rx_1.valid)

    );


    seaccow_internal si0(
            .sys_clk(sys_clk),
            .reset_n(core_reset_n),
            .in(rx_1),
            .out(tx_0),
            .hex_disp('{HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7}),
    );

    /* display_frame d0( */
    /*         .sys_clk(sys_clk), */
    /*         .reset_n(core_reset_n), */
    /*         .in(rx_1), */
    /*         .out(tx_0), */
    /*         .hex_disp('{HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7}), */
    /*         .SW(SW), */
    /*         .KEY(KEY), */
    /*         .LEDG(LEDG) */
    /* ); */


    // Error checking
    reg rx_error_reg;
    reg empty_error;
    always_ff @(posedge sys_clk or negedge core_reset_n) begin
        if (~core_reset_n) begin
            rx_error_reg <= 0;
            empty_error <= 0;
        end
        else begin 
            if (rx_error[0])
                rx_error_reg <= 1;
            if (|rx_1.empty & ~rx_1.eop)
                empty_error <= 1;
        end
    end
    assign LEDR[0] = rx_error_reg;
    assign LEDR[1] = empty_error;
    assign LEDR[2] = ~core_reset_n;

endmodule
