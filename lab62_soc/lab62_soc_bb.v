
module lab62_soc (
	clk_clk,
	game_end_export,
	game_end_port_new_signal,
	hex_digits_export,
	key_external_connection_export,
	keycode_export,
	keycode_port_new_signal,
	leds_export,
	maze_ready_export,
	reset_reset_n,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	spi0_MISO,
	spi0_MOSI,
	spi0_SCLK,
	spi0_SS_n,
	usb_gpx_export,
	usb_irq_export,
	usb_rst_export,
	vga_port_new_signal,
	vga_port_new_signal_1,
	vga_port_new_signal_2,
	vga_port_new_signal_3,
	vga_port_new_signal_4,
	maze_ready_port_new_signal);	

	input		clk_clk;
	input	[1:0]	game_end_export;
	output	[1:0]	game_end_port_new_signal;
	output	[15:0]	hex_digits_export;
	input	[1:0]	key_external_connection_export;
	output	[31:0]	keycode_export;
	input	[31:0]	keycode_port_new_signal;
	output	[13:0]	leds_export;
	output		maze_ready_export;
	input		reset_reset_n;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input		spi0_MISO;
	output		spi0_MOSI;
	output		spi0_SCLK;
	output		spi0_SS_n;
	input		usb_gpx_export;
	input		usb_irq_export;
	output		usb_rst_export;
	output	[7:0]	vga_port_new_signal;
	output	[7:0]	vga_port_new_signal_1;
	output		vga_port_new_signal_2;
	output	[7:0]	vga_port_new_signal_3;
	output		vga_port_new_signal_4;
	input		maze_ready_port_new_signal;
endmodule
