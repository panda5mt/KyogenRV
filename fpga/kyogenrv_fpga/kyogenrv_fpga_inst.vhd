	component kyogenrv_fpga is
		port (
			clk_clk                          : in  std_logic                     := 'X'; -- clk
			kyogenrv_0_expc_readdata         : out std_logic_vector(31 downto 0);        -- readdata
			pio_0_external_connection_export : out std_logic_vector(31 downto 0);        -- export
			reset_reset_n                    : in  std_logic                     := 'X'  -- reset_n
		);
	end component kyogenrv_fpga;

	u0 : component kyogenrv_fpga
		port map (
			clk_clk                          => CONNECTED_TO_clk_clk,                          --                       clk.clk
			kyogenrv_0_expc_readdata         => CONNECTED_TO_kyogenrv_0_expc_readdata,         --           kyogenrv_0_expc.readdata
			pio_0_external_connection_export => CONNECTED_TO_pio_0_external_connection_export, -- pio_0_external_connection.export
			reset_reset_n                    => CONNECTED_TO_reset_reset_n                     --                     reset.reset_n
		);

