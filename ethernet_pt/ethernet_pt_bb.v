
module ethernet_pt (
	clk_clk,
	reset_reset_n,
	tse_0_mac_mdio_connection_mdc,
	tse_0_mac_mdio_connection_mdio_in,
	tse_0_mac_mdio_connection_mdio_out,
	tse_0_mac_mdio_connection_mdio_oen,
	tse_0_mac_misc_connection_ff_tx_crc_fwd,
	tse_0_mac_misc_connection_ff_tx_septy,
	tse_0_mac_misc_connection_tx_ff_uflow,
	tse_0_mac_misc_connection_ff_tx_a_full,
	tse_0_mac_misc_connection_ff_tx_a_empty,
	tse_0_mac_misc_connection_rx_err_stat,
	tse_0_mac_misc_connection_rx_frm_type,
	tse_0_mac_misc_connection_ff_rx_dsav,
	tse_0_mac_misc_connection_ff_rx_a_full,
	tse_0_mac_misc_connection_ff_rx_a_empty,
	tse_0_mac_rgmii_connection_rgmii_in,
	tse_0_mac_rgmii_connection_rgmii_out,
	tse_0_mac_rgmii_connection_rx_control,
	tse_0_mac_rgmii_connection_tx_control,
	tse_0_mac_status_connection_set_10,
	tse_0_mac_status_connection_set_1000,
	tse_0_mac_status_connection_eth_mode,
	tse_0_mac_status_connection_ena_10,
	tse_0_pcs_mac_rx_clock_connection_clk,
	tse_0_pcs_mac_tx_clock_connection_clk,
	tse_1_mac_mdio_connection_mdc,
	tse_1_mac_mdio_connection_mdio_in,
	tse_1_mac_mdio_connection_mdio_out,
	tse_1_mac_mdio_connection_mdio_oen,
	tse_1_mac_misc_connection_ff_tx_crc_fwd,
	tse_1_mac_misc_connection_ff_tx_septy,
	tse_1_mac_misc_connection_tx_ff_uflow,
	tse_1_mac_misc_connection_ff_tx_a_full,
	tse_1_mac_misc_connection_ff_tx_a_empty,
	tse_1_mac_misc_connection_rx_err_stat,
	tse_1_mac_misc_connection_rx_frm_type,
	tse_1_mac_misc_connection_ff_rx_dsav,
	tse_1_mac_misc_connection_ff_rx_a_full,
	tse_1_mac_misc_connection_ff_rx_a_empty,
	tse_1_mac_rgmii_connection_rgmii_in,
	tse_1_mac_rgmii_connection_rgmii_out,
	tse_1_mac_rgmii_connection_rx_control,
	tse_1_mac_rgmii_connection_tx_control,
	tse_1_mac_status_connection_set_10,
	tse_1_mac_status_connection_set_1000,
	tse_1_mac_status_connection_eth_mode,
	tse_1_mac_status_connection_ena_10,
	tse_1_pcs_mac_rx_clock_connection_clk,
	tse_1_pcs_mac_tx_clock_connection_clk);	

	input		clk_clk;
	input		reset_reset_n;
	output		tse_0_mac_mdio_connection_mdc;
	input		tse_0_mac_mdio_connection_mdio_in;
	output		tse_0_mac_mdio_connection_mdio_out;
	output		tse_0_mac_mdio_connection_mdio_oen;
	input		tse_0_mac_misc_connection_ff_tx_crc_fwd;
	output		tse_0_mac_misc_connection_ff_tx_septy;
	output		tse_0_mac_misc_connection_tx_ff_uflow;
	output		tse_0_mac_misc_connection_ff_tx_a_full;
	output		tse_0_mac_misc_connection_ff_tx_a_empty;
	output	[17:0]	tse_0_mac_misc_connection_rx_err_stat;
	output	[3:0]	tse_0_mac_misc_connection_rx_frm_type;
	output		tse_0_mac_misc_connection_ff_rx_dsav;
	output		tse_0_mac_misc_connection_ff_rx_a_full;
	output		tse_0_mac_misc_connection_ff_rx_a_empty;
	input	[3:0]	tse_0_mac_rgmii_connection_rgmii_in;
	output	[3:0]	tse_0_mac_rgmii_connection_rgmii_out;
	input		tse_0_mac_rgmii_connection_rx_control;
	output		tse_0_mac_rgmii_connection_tx_control;
	input		tse_0_mac_status_connection_set_10;
	input		tse_0_mac_status_connection_set_1000;
	output		tse_0_mac_status_connection_eth_mode;
	output		tse_0_mac_status_connection_ena_10;
	input		tse_0_pcs_mac_rx_clock_connection_clk;
	input		tse_0_pcs_mac_tx_clock_connection_clk;
	output		tse_1_mac_mdio_connection_mdc;
	input		tse_1_mac_mdio_connection_mdio_in;
	output		tse_1_mac_mdio_connection_mdio_out;
	output		tse_1_mac_mdio_connection_mdio_oen;
	input		tse_1_mac_misc_connection_ff_tx_crc_fwd;
	output		tse_1_mac_misc_connection_ff_tx_septy;
	output		tse_1_mac_misc_connection_tx_ff_uflow;
	output		tse_1_mac_misc_connection_ff_tx_a_full;
	output		tse_1_mac_misc_connection_ff_tx_a_empty;
	output	[17:0]	tse_1_mac_misc_connection_rx_err_stat;
	output	[3:0]	tse_1_mac_misc_connection_rx_frm_type;
	output		tse_1_mac_misc_connection_ff_rx_dsav;
	output		tse_1_mac_misc_connection_ff_rx_a_full;
	output		tse_1_mac_misc_connection_ff_rx_a_empty;
	input	[3:0]	tse_1_mac_rgmii_connection_rgmii_in;
	output	[3:0]	tse_1_mac_rgmii_connection_rgmii_out;
	input		tse_1_mac_rgmii_connection_rx_control;
	output		tse_1_mac_rgmii_connection_tx_control;
	input		tse_1_mac_status_connection_set_10;
	input		tse_1_mac_status_connection_set_1000;
	output		tse_1_mac_status_connection_eth_mode;
	output		tse_1_mac_status_connection_ena_10;
	input		tse_1_pcs_mac_rx_clock_connection_clk;
	input		tse_1_pcs_mac_tx_clock_connection_clk;
endmodule
