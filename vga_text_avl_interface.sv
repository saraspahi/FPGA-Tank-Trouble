/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	input logic [31:0] keycode_signal, 
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [7:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);


logic [31:0] data;
logic [5:0] AngleI2;
logic [7:0] sin2, cos2, sin2u, cos2u, sin2u1, cos2u1, sin2p, cos2p;
logic [9:0] drawxsig, drawysig, ballxsig1, ballysig1, ballxsig2, ballysig2, ballsizesig, Word_ADDR;
logic [14:0] Byte_ADDR;
logic [31:0] keycode;
logic maze;
assign keycode = keycode_signal;

vga_controller v1(.Clk(CLK),.Reset(RESET),.hs(hs),.vs(vs),.blank(blank),.DrawX(drawxsig),.DrawY(drawysig));

tank1 b1(.Reset(RESET),.frame_clk(vs),.keycode(keycode),.BallX(ballxsig1),.BallY(ballysig1),.BallS(ballsizesig1));

tank2 b2(.Reset(RESET),.frame_clk(vs),.sin(sin2), .cos(cos2),.keycode(keycode),.BallX(ballxsig2),.BallY(ballysig2),.BallS(ballsizesig2),.Angle(AngleI2));

sinCos sincos1(.AngleI(AngleI2), .sin(sin2u), .cos(cos2u));
sinCos sincos2(.AngleI(6'd44 + ~AngleI2 + 1'b1), .sin(sin2u1), .cos(cos2u1));


//Mux that takes care of the negative sines and cosines in different quadrants
always_comb
begin
   
   if(AngleI2<23 && AngleI2>11)
	begin
       cos2[7:0] = ~cos2u[7:0]+1'b1;
		 sin2 = sin2u[7:0];
		 cos2p[7:0] = ~cos2u1[7:0]+1'b1;
		 sin2p[7:0] = sin2u1[7:0];
	end
   else if(AngleI2>22 && AngleI2<34)
   begin
       cos2[7:0] = ~cos2u[7:0]+1'b1;
       sin2[7:0] = ~sin2u[7:0]+1'b1;
		 cos2p[7:0] = ~cos2u1[7:0]+1'b1;
       sin2p[7:0] = ~sin2u1[7:0]+1'b1;
   end
   else if(AngleI2>33)
   begin
       cos2[7:0] = cos2u[7:0];
       sin2[7:0] = ~sin2u[7:0]+1'b1;
		 cos2p[7:0] = cos2u1[7:0];
       sin2p[7:0] = ~sin2u1[7:0]+1'b1;
   end
   else
   begin
       cos2[7:0] = cos2u[7:0];
       sin2[7:0] = sin2u[7:0];
		 cos2p[7:0] = cos2u1[7:0];
       sin2p[7:0] = sin2u1[7:0];
   end
end


ram1 ram(.clock(CLK),.data(AVL_WRITEDATA),.rdaddress(Word_ADDR),.wraddresss(AVL_ADDR),.wren(AVL_WRITE && AVL_CS),.q(data));

always_comb
begin 
	Byte_ADDR[14:0] = drawxsig[9:2]+drawysig[9:2]*160;
	Word_ADDR[9:0] = Byte_ADDR[14:5];
	maze = data[Byte_ADDR[4:0]];

end 




color_mapper  c1(.BallX1(ballxsig1),.maze(maze),.BallY1(ballysig1),.DrawX(drawxsig), .DrawY(drawysig), .Ball_size(4'd10),
						.BallX2(ballxsig2),.BallY2(ballysig2), .sin2(sin2), .cos2(cos2), .Red(red),.Blue(blue),.Green(green), .blank(blank));

endmodule
