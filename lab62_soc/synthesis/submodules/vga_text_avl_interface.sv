
//Todo change the names of the signals for tanks 
//create a module with the multiplexer for cos 
//flashing when turning fix
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
logic [31:0] Maze_Reg [600]; // Registers to store maze

logic [5:0] AngleI1,AngleI2;
logic ShootBullet1,ShootBullet2;
logic [7:0] sin1,cos1,sin2, cos2, sin2u, cos2u, sin2u1, cos2u1, sin2p, cos2p;
logic [9:0] drawxsig, drawysig, ballxsig1, ballysig1, ballxsig2, ballysig2, ballsizesig, Word_ADDR;
logic [14:0] Byte_ADDR;
logic [31:0] keycode;
logic maze;
assign keycode = keycode_signal;

always_ff @ (posedge CLK)
begin 
if(AVL_WRITE && AVL_CS)
begin
		Maze_Reg[AVL_ADDR][31:0] <= AVL_WRITEDATA;
end
else if(RESET)
	begin
		for(int i = 0; i<600; i++)
		begin
			Maze_Reg[i] <= 32'h00000000;
		end
	end
end


vga_controller v1(.Clk(CLK),.Reset(RESET), .pixel_clk(PIX_CLK), .hs(hs),.vs(vs),.blank(blank),.DrawX(drawxsig),.DrawY(drawysig));

tank1 b1(.Reset(RESET),
			.frame_clk(vs),
			.sin(sin1), 
			.cos(cos1),
			.keycode(keycode),
			.TankX(ballxsig1),
			.TankY(ballysig1),
			.TankS(ballsizesig1),
			.ShootBullet(ShootBullet1),
			.Angle(AngleI1));

logic [9:0] timer;
tank2 b2(.Reset(RESET),   //Instantiates tank2 module 
			.frame_clk(vs),
			.sin(sin2), 
			.cos(cos2),
			.keycode(keycode),
			.TankX(ballxsig2),
			.TankY(ballysig2),
			.TankS(ballsizesig2),
			.ShootBullet(ShootBullet2),
			.Angle(AngleI2));
			
			

		
logic bullet1_active;
logic[9:0] bullet1_X,bullet1_Y,bullet1_S,bulletTimer1	;

//Bullet1 from tank b2
bullet bullet1(.Reset(RESET), 
					.frame_clk(vs), 
					.isWallBottom(isWallBottom1),
					.isWallTop(isWallTop1),
					.isWallRight(isWallRight1),
					.isWallLeft(isWallLeft1),
					.create(ShootBullet2), // TODOand bullet is not active then create on
					.tankX(ballxsig2),
					.tankY(ballysig2),
					.sin(sin2),
					.cos(cos2),
					//Outputs
					.is_bullet_active(bullet1_active),
               .BulletX(bullet1_X),
					.BulletY(bullet1_Y), 
					.BulletS(bullet1_S),
					.bulletTimer(bulletTimer1));  // same postion  as the tank once shot
					

collisionWall collisonWallBullet1(.objectX(bullet1_X),.objectY(bullet1_Y),.objectS(bullet1_S),.DrawX(drawxsig),.DrawY(drawysig),
							.isWallBottom(isWallBottom1),.isWallTop(isWallTop1),.isWallRight(isWallRight1),.isWallLeft(isWallLeft1));

//bullet2 from tank 2 active only after bullet1 is active 		
logic [9:0] bullet2_X,bullet2_Y,bullet2_S,bulletTimer2;
logic bullet2_active;

bullet bullet2(.Reset(RESET), 
					.frame_clk(vs), 
					.isWallBottom(isWallBottom2),
					.isWallTop(isWallTop2),
					.isWallRight(isWallRight2),
					.isWallLeft(isWallLeft2),
					.create(ShootBullet2 && bullet1_active && (bulletTimer1>10'd35)), // TODOand bullet is not active then create on
					.tankX(ballxsig2),
					.tankY(ballysig2),
					.sin(sin2),
					.cos(cos2),
					//Outputs
					.is_bullet_active(bullet2_active),
               .BulletX(bullet2_X),
					.BulletY(bullet2_Y), 
					.BulletS(bullet2_S),
					.bulletTimer(bulletTimer2));  // same postion  as the tank once shot
					
collisionWall collisonWallBullet2(.objectX(bullet2_X),.objectY(bullet2_Y),.objectS(bullet2_S),.DrawX(drawxsig),.DrawY(drawysig),
							.isWallBottom(isWallBottom2),.isWallTop(isWallTop2),.isWallRight(isWallRight2),.isWallLeft(isWallLeft2));
							
//Bullet3 from tank2
logic [9:0] bullet3_X,bullet3_Y,bullet3_S,bulletTimer3;
logic bullet3_active;
							
bullet bullet3(.Reset(RESET), 
					.frame_clk(vs), 
					.isWallBottom(isWallBottom3),
					.isWallTop(isWallTop3),
					.isWallRight(isWallRight3),
					.isWallLeft(isWallLeft3),
					.create(ShootBullet2 && bullet2_active && (bulletTimer2>10'd35)), // TODOand bullet is not active then create on
					.tankX(ballxsig2),
					.tankY(ballysig2),
					.sin(sin2),
					.cos(cos2),
					//Outputs
					.is_bullet_active(bullet3_active),
               .BulletX(bullet3_X),
					.BulletY(bullet3_Y), 
					.BulletS(bullet3_S),
					.bulletTimer(bulletTimer3)); 
					
collisionWall collisonWallBullet3(.objectX(bullet3_X),.objectY(bullet3_Y),.objectS(bullet3_S),.DrawX(drawxsig),.DrawY(drawysig),
							.isWallBottom(isWallBottom3),.isWallTop(isWallTop3),.isWallRight(isWallRight3),.isWallLeft(isWallLeft3));

							
//angles for tank 1							
sinCos sincos1(.AngleI(AngleI1), .sin(sin1u), .cos(cos1u));
//angles for tank 2
sinCos sincos2(.AngleI(AngleI2), .sin(sin2u), .cos(cos2u));


//Gives the corresponding sin and cos matching the vga coordinate system

angleMux angleTank1(  .Angle(AngleI1),.sin(sin1u),.cos(cos1u),.newSin(sin1), .newCos(cos1));
angleMux angleTank2(  .Angle(AngleI2),.sin(sin2u),.cos(cos2u),.newSin(sin2), .newCos(cos2));


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


////Ram stores the maze 
//ram1 ram0(.byteena_a(AVL_BYTE_EN), 
//			.clock(CLK), 
//			.data(AVL_WRITEDATA), 
//			.rdaddress(Word_ADDR), 
//			.wraddress(AVL_ADDR), 
//			.wren(AVL_WRITE && AVL_CS),
//			.q(data));


			
always_comb
begin 
	Byte_ADDR[14:0] = drawxsig[9:2]+drawysig[9:2]*160;
	Word_ADDR[9:0] = Byte_ADDR[14:5];//How to index the ram
	maze = Maze_Reg[Word_ADDR][~Byte_ADDR[4:0]];

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
					.Bullet1Y(bullet1_Y),
					.Bullet1S(bullet1_S),
					.is_bullet1_active(bullet1_active),
					
					//bullet2data
					.Bullet2X(bullet2_X),
					.Bullet2Y(bullet2_Y),
					.Bullet2S(bullet2_S),
					.is_bullet2_active(bullet2_active),
					
					//bullet3data
					.Bullet3X(bullet3_X),
					.Bullet3Y(bullet3_Y),
					.Bullet3S(bullet3_S),
					.is_bullet3_active(bullet3_active),
					);

endmodule
