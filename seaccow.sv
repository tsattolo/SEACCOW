module seaccow (
    // Clock
    input         CLOCK_50,
    
    // KEY
    input  [3: 0] KEY,
    input  [17:0] SW,
        
    // LED
    output  [8:0] LEDG,
    output  [17:0] LEDR,

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
    );

endmodule
