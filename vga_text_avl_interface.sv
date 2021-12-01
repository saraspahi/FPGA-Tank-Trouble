

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
	
	input logic [31:0] keycode_signal, 		//The interface needs the keycode signal as input to display 
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [7:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);


logic [31:0] data;

logic [5:0] AngleI1,AngleI2;
logic ShootBullet1,ShootBullet2;
logic [7:0] sin2, cos2, sin2u, cos2u, sin2u1, cos2u1, sin2p, cos2p;
logic [9:0] drawxsig, drawysig, ballxsig1, ballysig1, ballxsig2, ballysig2, ballsizesig, Word_ADDR;
logic [14:0] Byte_ADDR;
logic [31:0] keycode;
logic maze;
assign keycode = keycode_signal;

vga_controller v1(.Clk(CLK),.Reset(RESET), .pixel_clk(PIX_CLK), .hs(hs),.vs(vs),.blank(blank),.DrawX(drawxsig),.DrawY(drawysig));

tank1 b1(.Reset(RESET),
			.frame_clk(vs),
			.sin(sin2), 
			.cos(cos2),
			.keycode(keycode),
			.BallX(ballxsig1),
			.BallY(ballysig1),
			.BallS(ballsizesig1),
			.ShootBullet(ShootBullet1),
			.Angle(AngleI1));

tank2 b2(.Reset(RESET),   //Instantiates tank2 module 
			.frame_clk(vs),
			.sin(sin2), 
			.cos(cos2),
			.keycode(keycode),
			.BallX(ballxsig2),
			.BallY(ballysig2),
			.BallS(ballsizesig2),
			.ShootBullet(ShootBullet2),
			.Angle(AngleI2)
			);
			
			
logic bullet1_active;
logic[9:0] bullet1_X,	bullet1_Y,	bullet1_S	;
//Bullet from tank b2
bullet bullet1(.Reset(RESET), 
					.frame_clk(vs), 
					.isWallBottom(0),
					.isWallTop(0),
					.isWallRight(0),
					.isWallLeft(0),
					.create(ShootBullet2), //coming from some kind of state machine for the bullet whenever the shoot key is pressed
					.tankX(ballxsig2),
					.tankY(ballysig2),
					.angle(AngleI2),
					.sin(sin2),
					.cos(cos2),
					.is_bullet_active(bullet1_active),
               .BulletX(bullet1_X),
					.BulletY(bullet1_Y), 
					.BulletS(bullet1_S));  // same postion  as the tank once shot

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


//Ram stores the maze 
ram1 ram0(.byteena_a(AVL_BYTE_EN), 
			.clock(CLK), 
			.data(AVL_WRITEDATA), 
			.rdaddress(Word_ADDR), 
			.wraddress(AVL_ADDR), 
			.wren(AVL_WRITE && AVL_CS),
			.q(data));
			
always_comb
begin 
	Byte_ADDR[14:0] = drawxsig[9:2]+drawysig[9:2]*160;
	Word_ADDR[9:0] = Byte_ADDR[14:5];//How to index the ram
	maze = data[Byte_ADDR[4:0]];

end 


color_mapper  c1(.BallX1(ballxsig1),
					.CLK(PIX_CLK),
					.maze(maze),.BallY1(ballysig1),
					.DrawX(drawxsig), 
					.DrawY(drawysig), 
					.Ball_size(4'd10),
					.BallX2(ballxsig2),
					.BallY2(ballysig2), 
					.sin2(sin2),
					.cos2(cos2), 
					.Red(red),
					.Blue(blue),
					.Green(green),
					.blank(blank),
					
					
					//bullet1data
					.Bullet1X(bullet1_X),
					.Bullet1Y(bullet1_X),
					.Bullet1S(bullet1_X),
					.is_bullet1_active(bullet1_active));

endmodule
