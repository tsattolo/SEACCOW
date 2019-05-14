	component ethernet_pt is
		port (
			clk_clk                                 : in  std_logic                     := 'X';             -- clk
			reset_reset_n                           : in  std_logic                     := 'X';             -- reset_n
			tse_0_mac_mdio_connection_mdc           : out std_logic;                                        -- mdc
			tse_0_mac_mdio_connection_mdio_in       : in  std_logic                     := 'X';             -- mdio_in
			tse_0_mac_mdio_connection_mdio_out      : out std_logic;                                        -- mdio_out
			tse_0_mac_mdio_connection_mdio_oen      : out std_logic;                                        -- mdio_oen
			tse_0_mac_misc_connection_ff_tx_crc_fwd : in  std_logic                     := 'X';             -- ff_tx_crc_fwd
			tse_0_mac_misc_connection_ff_tx_septy   : out std_logic;                                        -- ff_tx_septy
			tse_0_mac_misc_connection_tx_ff_uflow   : out std_logic;                                        -- tx_ff_uflow
			tse_0_mac_misc_connection_ff_tx_a_full  : out std_logic;                                        -- ff_tx_a_full
			tse_0_mac_misc_connection_ff_tx_a_empty : out std_logic;                                        -- ff_tx_a_empty
			tse_0_mac_misc_connection_rx_err_stat   : out std_logic_vector(17 downto 0);                    -- rx_err_stat
			tse_0_mac_misc_connection_rx_frm_type   : out std_logic_vector(3 downto 0);                     -- rx_frm_type
			tse_0_mac_misc_connection_ff_rx_dsav    : out std_logic;                                        -- ff_rx_dsav
			tse_0_mac_misc_connection_ff_rx_a_full  : out std_logic;                                        -- ff_rx_a_full
			tse_0_mac_misc_connection_ff_rx_a_empty : out std_logic;                                        -- ff_rx_a_empty
			tse_0_mac_rgmii_connection_rgmii_in     : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rgmii_in
			tse_0_mac_rgmii_connection_rgmii_out    : out std_logic_vector(3 downto 0);                     -- rgmii_out
			tse_0_mac_rgmii_connection_rx_control   : in  std_logic                     := 'X';             -- rx_control
			tse_0_mac_rgmii_connection_tx_control   : out std_logic;                                        -- tx_control
			tse_0_mac_status_connection_set_10      : in  std_logic                     := 'X';             -- set_10
			tse_0_mac_status_connection_set_1000    : in  std_logic                     := 'X';             -- set_1000
			tse_0_mac_status_connection_eth_mode    : out std_logic;                                        -- eth_mode
			tse_0_mac_status_connection_ena_10      : out std_logic;                                        -- ena_10
			tse_0_pcs_mac_rx_clock_connection_clk   : in  std_logic                     := 'X';             -- clk
			tse_0_pcs_mac_tx_clock_connection_clk   : in  std_logic                     := 'X';             -- clk
			tse_0_transmit_data                     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- data
			tse_0_transmit_endofpacket              : in  std_logic                     := 'X';             -- endofpacket
			tse_0_transmit_error                    : in  std_logic                     := 'X';             -- error
			tse_0_transmit_empty                    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- empty
			tse_0_transmit_ready                    : out std_logic;                                        -- ready
			tse_0_transmit_startofpacket            : in  std_logic                     := 'X';             -- startofpacket
			tse_0_transmit_valid                    : in  std_logic                     := 'X';             -- valid
			tse_1_mac_mdio_connection_mdc           : out std_logic;                                        -- mdc
			tse_1_mac_mdio_connection_mdio_in       : in  std_logic                     := 'X';             -- mdio_in
			tse_1_mac_mdio_connection_mdio_out      : out std_logic;                                        -- mdio_out
			tse_1_mac_mdio_connection_mdio_oen      : out std_logic;                                        -- mdio_oen
			tse_1_mac_misc_connection_ff_tx_crc_fwd : in  std_logic                     := 'X';             -- ff_tx_crc_fwd
			tse_1_mac_misc_connection_ff_tx_septy   : out std_logic;                                        -- ff_tx_septy
			tse_1_mac_misc_connection_tx_ff_uflow   : out std_logic;                                        -- tx_ff_uflow
			tse_1_mac_misc_connection_ff_tx_a_full  : out std_logic;                                        -- ff_tx_a_full
			tse_1_mac_misc_connection_ff_tx_a_empty : out std_logic;                                        -- ff_tx_a_empty
			tse_1_mac_misc_connection_rx_err_stat   : out std_logic_vector(17 downto 0);                    -- rx_err_stat
			tse_1_mac_misc_connection_rx_frm_type   : out std_logic_vector(3 downto 0);                     -- rx_frm_type
			tse_1_mac_misc_connection_ff_rx_dsav    : out std_logic;                                        -- ff_rx_dsav
			tse_1_mac_misc_connection_ff_rx_a_full  : out std_logic;                                        -- ff_rx_a_full
			tse_1_mac_misc_connection_ff_rx_a_empty : out std_logic;                                        -- ff_rx_a_empty
			tse_1_mac_rgmii_connection_rgmii_in     : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rgmii_in
			tse_1_mac_rgmii_connection_rgmii_out    : out std_logic_vector(3 downto 0);                     -- rgmii_out
			tse_1_mac_rgmii_connection_rx_control   : in  std_logic                     := 'X';             -- rx_control
			tse_1_mac_rgmii_connection_tx_control   : out std_logic;                                        -- tx_control
			tse_1_mac_status_connection_set_10      : in  std_logic                     := 'X';             -- set_10
			tse_1_mac_status_connection_set_1000    : in  std_logic                     := 'X';             -- set_1000
			tse_1_mac_status_connection_eth_mode    : out std_logic;                                        -- eth_mode
			tse_1_mac_status_connection_ena_10      : out std_logic;                                        -- ena_10
			tse_1_pcs_mac_rx_clock_connection_clk   : in  std_logic                     := 'X';             -- clk
			tse_1_pcs_mac_tx_clock_connection_clk   : in  std_logic                     := 'X';             -- clk
			tse_1_receive_data                      : out std_logic_vector(31 downto 0);                    -- data
			tse_1_receive_endofpacket               : out std_logic;                                        -- endofpacket
			tse_1_receive_error                     : out std_logic_vector(5 downto 0);                     -- error
			tse_1_receive_empty                     : out std_logic_vector(1 downto 0);                     -- empty
			tse_1_receive_ready                     : in  std_logic                     := 'X';             -- ready
			tse_1_receive_startofpacket             : out std_logic;                                        -- startofpacket
			tse_1_receive_valid                     : out std_logic                                         -- valid
		);
	end component ethernet_pt;

	u0 : component ethernet_pt
		port map (
			clk_clk                                 => CONNECTED_TO_clk_clk,                                 --                               clk.clk
			reset_reset_n                           => CONNECTED_TO_reset_reset_n,                           --                             reset.reset_n
			tse_0_mac_mdio_connection_mdc           => CONNECTED_TO_tse_0_mac_mdio_connection_mdc,           --         tse_0_mac_mdio_connection.mdc
			tse_0_mac_mdio_connection_mdio_in       => CONNECTED_TO_tse_0_mac_mdio_connection_mdio_in,       --                                  .mdio_in
			tse_0_mac_mdio_connection_mdio_out      => CONNECTED_TO_tse_0_mac_mdio_connection_mdio_out,      --                                  .mdio_out
			tse_0_mac_mdio_connection_mdio_oen      => CONNECTED_TO_tse_0_mac_mdio_connection_mdio_oen,      --                                  .mdio_oen
			tse_0_mac_misc_connection_ff_tx_crc_fwd => CONNECTED_TO_tse_0_mac_misc_connection_ff_tx_crc_fwd, --         tse_0_mac_misc_connection.ff_tx_crc_fwd
			tse_0_mac_misc_connection_ff_tx_septy   => CONNECTED_TO_tse_0_mac_misc_connection_ff_tx_septy,   --                                  .ff_tx_septy
			tse_0_mac_misc_connection_tx_ff_uflow   => CONNECTED_TO_tse_0_mac_misc_connection_tx_ff_uflow,   --                                  .tx_ff_uflow
			tse_0_mac_misc_connection_ff_tx_a_full  => CONNECTED_TO_tse_0_mac_misc_connection_ff_tx_a_full,  --                                  .ff_tx_a_full
			tse_0_mac_misc_connection_ff_tx_a_empty => CONNECTED_TO_tse_0_mac_misc_connection_ff_tx_a_empty, --                                  .ff_tx_a_empty
			tse_0_mac_misc_connection_rx_err_stat   => CONNECTED_TO_tse_0_mac_misc_connection_rx_err_stat,   --                                  .rx_err_stat
			tse_0_mac_misc_connection_rx_frm_type   => CONNECTED_TO_tse_0_mac_misc_connection_rx_frm_type,   --                                  .rx_frm_type
			tse_0_mac_misc_connection_ff_rx_dsav    => CONNECTED_TO_tse_0_mac_misc_connection_ff_rx_dsav,    --                                  .ff_rx_dsav
			tse_0_mac_misc_connection_ff_rx_a_full  => CONNECTED_TO_tse_0_mac_misc_connection_ff_rx_a_full,  --                                  .ff_rx_a_full
			tse_0_mac_misc_connection_ff_rx_a_empty => CONNECTED_TO_tse_0_mac_misc_connection_ff_rx_a_empty, --                                  .ff_rx_a_empty
			tse_0_mac_rgmii_connection_rgmii_in     => CONNECTED_TO_tse_0_mac_rgmii_connection_rgmii_in,     --        tse_0_mac_rgmii_connection.rgmii_in
			tse_0_mac_rgmii_connection_rgmii_out    => CONNECTED_TO_tse_0_mac_rgmii_connection_rgmii_out,    --                                  .rgmii_out
			tse_0_mac_rgmii_connection_rx_control   => CONNECTED_TO_tse_0_mac_rgmii_connection_rx_control,   --                                  .rx_control
			tse_0_mac_rgmii_connection_tx_control   => CONNECTED_TO_tse_0_mac_rgmii_connection_tx_control,   --                                  .tx_control
			tse_0_mac_status_connection_set_10      => CONNECTED_TO_tse_0_mac_status_connection_set_10,      --       tse_0_mac_status_connection.set_10
			tse_0_mac_status_connection_set_1000    => CONNECTED_TO_tse_0_mac_status_connection_set_1000,    --                                  .set_1000
			tse_0_mac_status_connection_eth_mode    => CONNECTED_TO_tse_0_mac_status_connection_eth_mode,    --                                  .eth_mode
			tse_0_mac_status_connection_ena_10      => CONNECTED_TO_tse_0_mac_status_connection_ena_10,      --                                  .ena_10
			tse_0_pcs_mac_rx_clock_connection_clk   => CONNECTED_TO_tse_0_pcs_mac_rx_clock_connection_clk,   -- tse_0_pcs_mac_rx_clock_connection.clk
			tse_0_pcs_mac_tx_clock_connection_clk   => CONNECTED_TO_tse_0_pcs_mac_tx_clock_connection_clk,   -- tse_0_pcs_mac_tx_clock_connection.clk
			tse_0_transmit_data                     => CONNECTED_TO_tse_0_transmit_data,                     --                    tse_0_transmit.data
			tse_0_transmit_endofpacket              => CONNECTED_TO_tse_0_transmit_endofpacket,              --                                  .endofpacket
			tse_0_transmit_error                    => CONNECTED_TO_tse_0_transmit_error,                    --                                  .error
			tse_0_transmit_empty                    => CONNECTED_TO_tse_0_transmit_empty,                    --                                  .empty
			tse_0_transmit_ready                    => CONNECTED_TO_tse_0_transmit_ready,                    --                                  .ready
			tse_0_transmit_startofpacket            => CONNECTED_TO_tse_0_transmit_startofpacket,            --                                  .startofpacket
			tse_0_transmit_valid                    => CONNECTED_TO_tse_0_transmit_valid,                    --                                  .valid
			tse_1_mac_mdio_connection_mdc           => CONNECTED_TO_tse_1_mac_mdio_connection_mdc,           --         tse_1_mac_mdio_connection.mdc
			tse_1_mac_mdio_connection_mdio_in       => CONNECTED_TO_tse_1_mac_mdio_connection_mdio_in,       --                                  .mdio_in
			tse_1_mac_mdio_connection_mdio_out      => CONNECTED_TO_tse_1_mac_mdio_connection_mdio_out,      --                                  .mdio_out
			tse_1_mac_mdio_connection_mdio_oen      => CONNECTED_TO_tse_1_mac_mdio_connection_mdio_oen,      --                                  .mdio_oen
			tse_1_mac_misc_connection_ff_tx_crc_fwd => CONNECTED_TO_tse_1_mac_misc_connection_ff_tx_crc_fwd, --         tse_1_mac_misc_connection.ff_tx_crc_fwd
			tse_1_mac_misc_connection_ff_tx_septy   => CONNECTED_TO_tse_1_mac_misc_connection_ff_tx_septy,   --                                  .ff_tx_septy
			tse_1_mac_misc_connection_tx_ff_uflow   => CONNECTED_TO_tse_1_mac_misc_connection_tx_ff_uflow,   --                                  .tx_ff_uflow
			tse_1_mac_misc_connection_ff_tx_a_full  => CONNECTED_TO_tse_1_mac_misc_connection_ff_tx_a_full,  --                                  .ff_tx_a_full
			tse_1_mac_misc_connection_ff_tx_a_empty => CONNECTED_TO_tse_1_mac_misc_connection_ff_tx_a_empty, --                                  .ff_tx_a_empty
			tse_1_mac_misc_connection_rx_err_stat   => CONNECTED_TO_tse_1_mac_misc_connection_rx_err_stat,   --                                  .rx_err_stat
			tse_1_mac_misc_connection_rx_frm_type   => CONNECTED_TO_tse_1_mac_misc_connection_rx_frm_type,   --                                  .rx_frm_type
			tse_1_mac_misc_connection_ff_rx_dsav    => CONNECTED_TO_tse_1_mac_misc_connection_ff_rx_dsav,    --                                  .ff_rx_dsav
			tse_1_mac_misc_connection_ff_rx_a_full  => CONNECTED_TO_tse_1_mac_misc_connection_ff_rx_a_full,  --                                  .ff_rx_a_full
			tse_1_mac_misc_connection_ff_rx_a_empty => CONNECTED_TO_tse_1_mac_misc_connection_ff_rx_a_empty, --                                  .ff_rx_a_empty
			tse_1_mac_rgmii_connection_rgmii_in     => CONNECTED_TO_tse_1_mac_rgmii_connection_rgmii_in,     --        tse_1_mac_rgmii_connection.rgmii_in
			tse_1_mac_rgmii_connection_rgmii_out    => CONNECTED_TO_tse_1_mac_rgmii_connection_rgmii_out,    --                                  .rgmii_out
			tse_1_mac_rgmii_connection_rx_control   => CONNECTED_TO_tse_1_mac_rgmii_connection_rx_control,   --                                  .rx_control
			tse_1_mac_rgmii_connection_tx_control   => CONNECTED_TO_tse_1_mac_rgmii_connection_tx_control,   --                                  .tx_control
			tse_1_mac_status_connection_set_10      => CONNECTED_TO_tse_1_mac_status_connection_set_10,      --       tse_1_mac_status_connection.set_10
			tse_1_mac_status_connection_set_1000    => CONNECTED_TO_tse_1_mac_status_connection_set_1000,    --                                  .set_1000
			tse_1_mac_status_connection_eth_mode    => CONNECTED_TO_tse_1_mac_status_connection_eth_mode,    --                                  .eth_mode
			tse_1_mac_status_connection_ena_10      => CONNECTED_TO_tse_1_mac_status_connection_ena_10,      --                                  .ena_10
			tse_1_pcs_mac_rx_clock_connection_clk   => CONNECTED_TO_tse_1_pcs_mac_rx_clock_connection_clk,   -- tse_1_pcs_mac_rx_clock_connection.clk
			tse_1_pcs_mac_tx_clock_connection_clk   => CONNECTED_TO_tse_1_pcs_mac_tx_clock_connection_clk,   -- tse_1_pcs_mac_tx_clock_connection.clk
			tse_1_receive_data                      => CONNECTED_TO_tse_1_receive_data,                      --                     tse_1_receive.data
			tse_1_receive_endofpacket               => CONNECTED_TO_tse_1_receive_endofpacket,               --                                  .endofpacket
			tse_1_receive_error                     => CONNECTED_TO_tse_1_receive_error,                     --                                  .error
			tse_1_receive_empty                     => CONNECTED_TO_tse_1_receive_empty,                     --                                  .empty
			tse_1_receive_ready                     => CONNECTED_TO_tse_1_receive_ready,                     --                                  .ready
			tse_1_receive_startofpacket             => CONNECTED_TO_tse_1_receive_startofpacket,             --                                  .startofpacket
			tse_1_receive_valid                     => CONNECTED_TO_tse_1_receive_valid                      --                                  .valid
		);

