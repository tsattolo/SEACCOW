	ethernet_pt u0 (
		.clk_clk                                 (<connected-to-clk_clk>),                                 //                               clk.clk
		.reset_reset_n                           (<connected-to-reset_reset_n>),                           //                             reset.reset_n
		.tse_0_mac_mdio_connection_mdc           (<connected-to-tse_0_mac_mdio_connection_mdc>),           //         tse_0_mac_mdio_connection.mdc
		.tse_0_mac_mdio_connection_mdio_in       (<connected-to-tse_0_mac_mdio_connection_mdio_in>),       //                                  .mdio_in
		.tse_0_mac_mdio_connection_mdio_out      (<connected-to-tse_0_mac_mdio_connection_mdio_out>),      //                                  .mdio_out
		.tse_0_mac_mdio_connection_mdio_oen      (<connected-to-tse_0_mac_mdio_connection_mdio_oen>),      //                                  .mdio_oen
		.tse_0_mac_misc_connection_ff_tx_crc_fwd (<connected-to-tse_0_mac_misc_connection_ff_tx_crc_fwd>), //         tse_0_mac_misc_connection.ff_tx_crc_fwd
		.tse_0_mac_misc_connection_ff_tx_septy   (<connected-to-tse_0_mac_misc_connection_ff_tx_septy>),   //                                  .ff_tx_septy
		.tse_0_mac_misc_connection_tx_ff_uflow   (<connected-to-tse_0_mac_misc_connection_tx_ff_uflow>),   //                                  .tx_ff_uflow
		.tse_0_mac_misc_connection_ff_tx_a_full  (<connected-to-tse_0_mac_misc_connection_ff_tx_a_full>),  //                                  .ff_tx_a_full
		.tse_0_mac_misc_connection_ff_tx_a_empty (<connected-to-tse_0_mac_misc_connection_ff_tx_a_empty>), //                                  .ff_tx_a_empty
		.tse_0_mac_misc_connection_rx_err_stat   (<connected-to-tse_0_mac_misc_connection_rx_err_stat>),   //                                  .rx_err_stat
		.tse_0_mac_misc_connection_rx_frm_type   (<connected-to-tse_0_mac_misc_connection_rx_frm_type>),   //                                  .rx_frm_type
		.tse_0_mac_misc_connection_ff_rx_dsav    (<connected-to-tse_0_mac_misc_connection_ff_rx_dsav>),    //                                  .ff_rx_dsav
		.tse_0_mac_misc_connection_ff_rx_a_full  (<connected-to-tse_0_mac_misc_connection_ff_rx_a_full>),  //                                  .ff_rx_a_full
		.tse_0_mac_misc_connection_ff_rx_a_empty (<connected-to-tse_0_mac_misc_connection_ff_rx_a_empty>), //                                  .ff_rx_a_empty
		.tse_0_mac_rgmii_connection_rgmii_in     (<connected-to-tse_0_mac_rgmii_connection_rgmii_in>),     //        tse_0_mac_rgmii_connection.rgmii_in
		.tse_0_mac_rgmii_connection_rgmii_out    (<connected-to-tse_0_mac_rgmii_connection_rgmii_out>),    //                                  .rgmii_out
		.tse_0_mac_rgmii_connection_rx_control   (<connected-to-tse_0_mac_rgmii_connection_rx_control>),   //                                  .rx_control
		.tse_0_mac_rgmii_connection_tx_control   (<connected-to-tse_0_mac_rgmii_connection_tx_control>),   //                                  .tx_control
		.tse_0_mac_status_connection_set_10      (<connected-to-tse_0_mac_status_connection_set_10>),      //       tse_0_mac_status_connection.set_10
		.tse_0_mac_status_connection_set_1000    (<connected-to-tse_0_mac_status_connection_set_1000>),    //                                  .set_1000
		.tse_0_mac_status_connection_eth_mode    (<connected-to-tse_0_mac_status_connection_eth_mode>),    //                                  .eth_mode
		.tse_0_mac_status_connection_ena_10      (<connected-to-tse_0_mac_status_connection_ena_10>),      //                                  .ena_10
		.tse_0_pcs_mac_rx_clock_connection_clk   (<connected-to-tse_0_pcs_mac_rx_clock_connection_clk>),   // tse_0_pcs_mac_rx_clock_connection.clk
		.tse_0_pcs_mac_tx_clock_connection_clk   (<connected-to-tse_0_pcs_mac_tx_clock_connection_clk>),   // tse_0_pcs_mac_tx_clock_connection.clk
		.tse_0_transmit_data                     (<connected-to-tse_0_transmit_data>),                     //                    tse_0_transmit.data
		.tse_0_transmit_endofpacket              (<connected-to-tse_0_transmit_endofpacket>),              //                                  .endofpacket
		.tse_0_transmit_error                    (<connected-to-tse_0_transmit_error>),                    //                                  .error
		.tse_0_transmit_empty                    (<connected-to-tse_0_transmit_empty>),                    //                                  .empty
		.tse_0_transmit_ready                    (<connected-to-tse_0_transmit_ready>),                    //                                  .ready
		.tse_0_transmit_startofpacket            (<connected-to-tse_0_transmit_startofpacket>),            //                                  .startofpacket
		.tse_0_transmit_valid                    (<connected-to-tse_0_transmit_valid>),                    //                                  .valid
		.tse_1_mac_mdio_connection_mdc           (<connected-to-tse_1_mac_mdio_connection_mdc>),           //         tse_1_mac_mdio_connection.mdc
		.tse_1_mac_mdio_connection_mdio_in       (<connected-to-tse_1_mac_mdio_connection_mdio_in>),       //                                  .mdio_in
		.tse_1_mac_mdio_connection_mdio_out      (<connected-to-tse_1_mac_mdio_connection_mdio_out>),      //                                  .mdio_out
		.tse_1_mac_mdio_connection_mdio_oen      (<connected-to-tse_1_mac_mdio_connection_mdio_oen>),      //                                  .mdio_oen
		.tse_1_mac_misc_connection_ff_tx_crc_fwd (<connected-to-tse_1_mac_misc_connection_ff_tx_crc_fwd>), //         tse_1_mac_misc_connection.ff_tx_crc_fwd
		.tse_1_mac_misc_connection_ff_tx_septy   (<connected-to-tse_1_mac_misc_connection_ff_tx_septy>),   //                                  .ff_tx_septy
		.tse_1_mac_misc_connection_tx_ff_uflow   (<connected-to-tse_1_mac_misc_connection_tx_ff_uflow>),   //                                  .tx_ff_uflow
		.tse_1_mac_misc_connection_ff_tx_a_full  (<connected-to-tse_1_mac_misc_connection_ff_tx_a_full>),  //                                  .ff_tx_a_full
		.tse_1_mac_misc_connection_ff_tx_a_empty (<connected-to-tse_1_mac_misc_connection_ff_tx_a_empty>), //                                  .ff_tx_a_empty
		.tse_1_mac_misc_connection_rx_err_stat   (<connected-to-tse_1_mac_misc_connection_rx_err_stat>),   //                                  .rx_err_stat
		.tse_1_mac_misc_connection_rx_frm_type   (<connected-to-tse_1_mac_misc_connection_rx_frm_type>),   //                                  .rx_frm_type
		.tse_1_mac_misc_connection_ff_rx_dsav    (<connected-to-tse_1_mac_misc_connection_ff_rx_dsav>),    //                                  .ff_rx_dsav
		.tse_1_mac_misc_connection_ff_rx_a_full  (<connected-to-tse_1_mac_misc_connection_ff_rx_a_full>),  //                                  .ff_rx_a_full
		.tse_1_mac_misc_connection_ff_rx_a_empty (<connected-to-tse_1_mac_misc_connection_ff_rx_a_empty>), //                                  .ff_rx_a_empty
		.tse_1_mac_rgmii_connection_rgmii_in     (<connected-to-tse_1_mac_rgmii_connection_rgmii_in>),     //        tse_1_mac_rgmii_connection.rgmii_in
		.tse_1_mac_rgmii_connection_rgmii_out    (<connected-to-tse_1_mac_rgmii_connection_rgmii_out>),    //                                  .rgmii_out
		.tse_1_mac_rgmii_connection_rx_control   (<connected-to-tse_1_mac_rgmii_connection_rx_control>),   //                                  .rx_control
		.tse_1_mac_rgmii_connection_tx_control   (<connected-to-tse_1_mac_rgmii_connection_tx_control>),   //                                  .tx_control
		.tse_1_mac_status_connection_set_10      (<connected-to-tse_1_mac_status_connection_set_10>),      //       tse_1_mac_status_connection.set_10
		.tse_1_mac_status_connection_set_1000    (<connected-to-tse_1_mac_status_connection_set_1000>),    //                                  .set_1000
		.tse_1_mac_status_connection_eth_mode    (<connected-to-tse_1_mac_status_connection_eth_mode>),    //                                  .eth_mode
		.tse_1_mac_status_connection_ena_10      (<connected-to-tse_1_mac_status_connection_ena_10>),      //                                  .ena_10
		.tse_1_pcs_mac_rx_clock_connection_clk   (<connected-to-tse_1_pcs_mac_rx_clock_connection_clk>),   // tse_1_pcs_mac_rx_clock_connection.clk
		.tse_1_pcs_mac_tx_clock_connection_clk   (<connected-to-tse_1_pcs_mac_tx_clock_connection_clk>),   // tse_1_pcs_mac_tx_clock_connection.clk
		.tse_1_receive_data                      (<connected-to-tse_1_receive_data>),                      //                     tse_1_receive.data
		.tse_1_receive_endofpacket               (<connected-to-tse_1_receive_endofpacket>),               //                                  .endofpacket
		.tse_1_receive_error                     (<connected-to-tse_1_receive_error>),                     //                                  .error
		.tse_1_receive_empty                     (<connected-to-tse_1_receive_empty>),                     //                                  .empty
		.tse_1_receive_ready                     (<connected-to-tse_1_receive_ready>),                     //                                  .ready
		.tse_1_receive_startofpacket             (<connected-to-tse_1_receive_startofpacket>),             //                                  .startofpacket
		.tse_1_receive_valid                     (<connected-to-tse_1_receive_valid>)                      //                                  .valid
	);

