//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 7: 0]   VGA_R,
      output   [ 7: 0]   VGA_G,
      output   [ 7: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs, game_end;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig1, ballysig1, ballxsig2, ballysig2, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [31:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
//	//HEX drivers to convert numbers to HEX output
//	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
//	assign HEX4[7] = 1'b1;
//	
//	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
//	assign HEX3[7] = 1'b1;
//	
//	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
//	assign HEX1[7] = 1'b1;
//	
//	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
//	assign HEX0[7] = 1'b1;
//	
//	//fill in the hundreds digit as well as the negative sign
//	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
//	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
//	assign VGA_R = Red[7:4];
//	assign VGA_B = Blue[7:4];
//	assign VGA_G = Green[7:4];
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (KEY[0]),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		
		//keycodee input to the keycode port 
		.keycode_port_new_signal(keycode1),
		
		.game_end_export(game_end),
		.game_end_port_new_signal(game_end),
		
		.maze_ready_export(maze_ready),
		.maze_ready_port_new_signal(maze_ready),
		
		.game_reset_export(game_reset),
		.game_reset_port_new_signal(game_reset),
		
		.spawn_pos_export(spawn_pos),
		.spawn_pos_port_new_signal(spawn_pos),
		//VGA
		.vga_port_new_signal_2 (VGA_HS),
		.vga_port_new_signal_1 (VGA_G),
		.vga_port_new_signal (VGA_B),
		.vga_port_new_signal_3 (VGA_R),
		.vga_port_new_signal_4 (VGA_VS)
		
		
	 );
	 
	 logic [31:0] keycode1;
	 assign keycode1=keycode;
//always_comb
//begin 
//HEX0=keycode[31:28];
//HEX1=keycode[27:24];
//HEX2=keycode[23:20];
//HEX4=keycode[19:16];
//end 
//
//localparam ball_size = 100;
//
//logic [5:0] AngleI2;
//logic [7:0] sin2, cos2, sin2u, cos2u, sin2u1, cos2u1, sin2p, cos2p;
//
//vga_controller v1(.Clk(MAX10_CLK1_50),.Reset(Reset_h),.hs(VGA_HS),.vs(VGA_VS),.pixel_clk(VGA_Clk),.blank(blank),.sync(sync),.DrawX(drawxsig),.DrawY(drawysig));
////instantiate a vga_controller, ball, and color_mapper here with the ports.
////What is the frame clock?
//
//tank1 b1(.Reset(Reset_h),.frame_clk(VGA_VS),.keycode(keycode),.BallX(ballxsig1),.BallY(ballysig1),.BallS(ballsizesig1));
//
//tank2 b2(.Reset(Reset_h),.frame_clk(VGA_VS),.sin(sin2), .cos(cos2),.keycode(keycode),.BallX(ballxsig2),.BallY(ballysig2),.BallS(ballsizesig2),.Angle(AngleI2));
//
//sinCos sincos1(.AngleI(AngleI2), .sin(sin2u), .cos(cos2u));
//sinCos sincos2(.AngleI(6'd44 + ~AngleI2 + 1'b1), .sin(sin2u1), .cos(cos2u1));
//
//
////Mux that takes care of the negative sines and cosines in different quadrants
//always_comb
//begin
//   
//   if(AngleI2<23 && AngleI2>11)
//	begin
//       cos2[7:0] = ~cos2u[7:0]+1'b1;
//		 sin2 = sin2u[7:0];
//		 cos2p[7:0] = ~cos2u1[7:0]+1'b1;
//		 sin2p[7:0] = sin2u1[7:0];
//	end
//   else if(AngleI2>22 && AngleI2<34)
//   begin
//       cos2[7:0] = ~cos2u[7:0]+1'b1;
//       sin2[7:0] = ~sin2u[7:0]+1'b1;
//		 cos2p[7:0] = ~cos2u1[7:0]+1'b1;
//       sin2p[7:0] = ~sin2u1[7:0]+1'b1;
//   end
//   else if(AngleI2>33)
//   begin
//       cos2[7:0] = cos2u[7:0];
//       sin2[7:0] = ~sin2u[7:0]+1'b1;
//		 cos2p[7:0] = cos2u1[7:0];
//       sin2p[7:0] = ~sin2u1[7:0]+1'b1;
//   end
//   else
//   begin
//       cos2[7:0] = cos2u[7:0];
//       sin2[7:0] = sin2u[7:0];
//		 cos2p[7:0] = cos2u1[7:0];
//       sin2p[7:0] = sin2u1[7:0];
//   end
//end
//
//
//
//color_mapper  c1(.BallX1(ballxsig1),.BallY1(ballysig1),.DrawX(drawxsig), .DrawY(drawysig), .Ball_size(4'd10),
//						.BallX2(ballxsig2),.BallY2(ballysig2), .sin2(sin2), .cos2(cos2), .Red(Red),.Blue(Blue),.Green(Green), .blank(blank));

endmodule
