	component lab62_soc is
		port (
			clk_clk                        : in    std_logic                     := 'X';             -- clk
			game_end_export                : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			game_end_port_new_signal       : out   std_logic_vector(1 downto 0);                     -- new_signal
			game_reset_export              : out   std_logic_vector(1 downto 0);                     -- export
			hex_digits_export              : out   std_logic_vector(15 downto 0);                    -- export
			key_external_connection_export : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			keycode_export                 : out   std_logic_vector(31 downto 0);                    -- export
			keycode_port_new_signal        : in    std_logic_vector(31 downto 0) := (others => 'X'); -- new_signal
			leds_export                    : out   std_logic_vector(13 downto 0);                    -- export
			maze_ready_export              : out   std_logic;                                        -- export
			maze_ready_port_new_signal     : in    std_logic                     := 'X';             -- new_signal
			reset_reset_n                  : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk                  : out   std_logic;                                        -- clk
			sdram_wire_addr                : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba                  : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n               : out   std_logic;                                        -- cas_n
			sdram_wire_cke                 : out   std_logic;                                        -- cke
			sdram_wire_cs_n                : out   std_logic;                                        -- cs_n
			sdram_wire_dq                  : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm                 : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n               : out   std_logic;                                        -- ras_n
			sdram_wire_we_n                : out   std_logic;                                        -- we_n
			spi0_MISO                      : in    std_logic                     := 'X';             -- MISO
			spi0_MOSI                      : out   std_logic;                                        -- MOSI
			spi0_SCLK                      : out   std_logic;                                        -- SCLK
			spi0_SS_n                      : out   std_logic;                                        -- SS_n
			usb_gpx_export                 : in    std_logic                     := 'X';             -- export
			usb_irq_export                 : in    std_logic                     := 'X';             -- export
			usb_rst_export                 : out   std_logic;                                        -- export
			vga_port_new_signal            : out   std_logic_vector(7 downto 0);                     -- new_signal
			vga_port_new_signal_1          : out   std_logic_vector(7 downto 0);                     -- new_signal_1
			vga_port_new_signal_2          : out   std_logic;                                        -- new_signal_2
			vga_port_new_signal_3          : out   std_logic_vector(7 downto 0);                     -- new_signal_3
			vga_port_new_signal_4          : out   std_logic;                                        -- new_signal_4
			game_reset_port_new_signal     : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- new_signal
			spawn_pos_port_new_signal      : in    std_logic_vector(19 downto 0) := (others => 'X'); -- new_signal
			spawn_pos_export               : out   std_logic_vector(19 downto 0)                     -- export
		);
	end component lab62_soc;

	u0 : component lab62_soc
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                     clk.clk
			game_end_export                => CONNECTED_TO_game_end_export,                --                game_end.export
			game_end_port_new_signal       => CONNECTED_TO_game_end_port_new_signal,       --           game_end_port.new_signal
			game_reset_export              => CONNECTED_TO_game_reset_export,              --              game_reset.export
			hex_digits_export              => CONNECTED_TO_hex_digits_export,              --              hex_digits.export
			key_external_connection_export => CONNECTED_TO_key_external_connection_export, -- key_external_connection.export
			keycode_export                 => CONNECTED_TO_keycode_export,                 --                 keycode.export
			keycode_port_new_signal        => CONNECTED_TO_keycode_port_new_signal,        --            keycode_port.new_signal
			leds_export                    => CONNECTED_TO_leds_export,                    --                    leds.export
			maze_ready_export              => CONNECTED_TO_maze_ready_export,              --              maze_ready.export
			maze_ready_port_new_signal     => CONNECTED_TO_maze_ready_port_new_signal,     --         maze_ready_port.new_signal
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                   reset.reset_n
			sdram_clk_clk                  => CONNECTED_TO_sdram_clk_clk,                  --               sdram_clk.clk
			sdram_wire_addr                => CONNECTED_TO_sdram_wire_addr,                --              sdram_wire.addr
			sdram_wire_ba                  => CONNECTED_TO_sdram_wire_ba,                  --                        .ba
			sdram_wire_cas_n               => CONNECTED_TO_sdram_wire_cas_n,               --                        .cas_n
			sdram_wire_cke                 => CONNECTED_TO_sdram_wire_cke,                 --                        .cke
			sdram_wire_cs_n                => CONNECTED_TO_sdram_wire_cs_n,                --                        .cs_n
			sdram_wire_dq                  => CONNECTED_TO_sdram_wire_dq,                  --                        .dq
			sdram_wire_dqm                 => CONNECTED_TO_sdram_wire_dqm,                 --                        .dqm
			sdram_wire_ras_n               => CONNECTED_TO_sdram_wire_ras_n,               --                        .ras_n
			sdram_wire_we_n                => CONNECTED_TO_sdram_wire_we_n,                --                        .we_n
			spi0_MISO                      => CONNECTED_TO_spi0_MISO,                      --                    spi0.MISO
			spi0_MOSI                      => CONNECTED_TO_spi0_MOSI,                      --                        .MOSI
			spi0_SCLK                      => CONNECTED_TO_spi0_SCLK,                      --                        .SCLK
			spi0_SS_n                      => CONNECTED_TO_spi0_SS_n,                      --                        .SS_n
			usb_gpx_export                 => CONNECTED_TO_usb_gpx_export,                 --                 usb_gpx.export
			usb_irq_export                 => CONNECTED_TO_usb_irq_export,                 --                 usb_irq.export
			usb_rst_export                 => CONNECTED_TO_usb_rst_export,                 --                 usb_rst.export
			vga_port_new_signal            => CONNECTED_TO_vga_port_new_signal,            --                vga_port.new_signal
			vga_port_new_signal_1          => CONNECTED_TO_vga_port_new_signal_1,          --                        .new_signal_1
			vga_port_new_signal_2          => CONNECTED_TO_vga_port_new_signal_2,          --                        .new_signal_2
			vga_port_new_signal_3          => CONNECTED_TO_vga_port_new_signal_3,          --                        .new_signal_3
			vga_port_new_signal_4          => CONNECTED_TO_vga_port_new_signal_4,          --                        .new_signal_4
			game_reset_port_new_signal     => CONNECTED_TO_game_reset_port_new_signal,     --         game_reset_port.new_signal
			spawn_pos_port_new_signal      => CONNECTED_TO_spawn_pos_port_new_signal,      --          spawn_pos_port.new_signal
			spawn_pos_export               => CONNECTED_TO_spawn_pos_export                --               spawn_pos.export
		);

