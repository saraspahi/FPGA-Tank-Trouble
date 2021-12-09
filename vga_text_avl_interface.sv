
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
	
	output logic [1:0] game_end,
	
	input logic maze_ready,
	
	input logic [1:0] game_reset,
	input logic [19:0] spawn_pos,
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [7:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);


logic [31:0] data;
logic [31:0] Maze_Reg [600]; // Registers to store maze

logic [5:0] AngleI1,AngleI2;
logic ShootBullet1,ShootBullet2;
logic [7:0] sin1,cos1,sin2, cos2, sin1u,cos1u, sin2u, cos2u;// sin2u1, cos2u1, sin2p, cos2p;
logic [9:0] drawxsig, drawysig, tank1xsig, tank1ysig,tank1sizesig, tank2xsig, tank2ysig, tank2sizesig, Word_ADDR;
logic [14:0] Byte_ADDR;
logic [31:0] keycode;
logic currentMaze,MazeUp,MazeDown,MazeLeft,MazeRight;
assign keycode = keycode_signal;

//always_ff @ (posedge CLK)
//begin 
//if(AVL_WRITE && AVL_CS)
//begin
//		Maze_Reg[AVL_ADDR][31:0] <= AVL_WRITEDATA;
//end
//else if(RESET)
//	begin
//		for(int i = 0; i<600; i++)
//		begin
//			Maze_Reg[i] <= 32'h00000000;
//		end
//	end
//end

logic hit,restart;
assign hit = tank1shot || tank2shot; 
game_states game_states(.CLK(CLK), .RESET(RESET),
                   .tank1shot(tank1shot), .tank2shot(tank2shot), .maze_ready(maze_ready),
                   .keycode(keycode),
                   .title(title),
						 .game_reset(game_reset),
                   .game_end(game_end));




vga_controller v1(.Clk(CLK),.Reset(RESET), .pixel_clk(PIX_CLK), .hs(hs),.vs(vs),.blank(blank),.DrawX(drawxsig),.DrawY(drawysig));

logic [9:0] Tank1XStep,Tank1YStep;
tank1 b1(.Reset(RESET),   //Instantiates tank1 module 
			.game_end(game_end),			  //Resets the tanks with the new location
			.frame_clk(vs),
			.isWallBottom(isWallBottomT1),
			.isWallTop(isWallTopT1),
			.isWallRight(isWallRightT1),
			.isWallLeft(isWallLeftT1),
			.sin(sin1), 
			.cos(cos1),
			.keycode(keycode),
			.TankX(tank1xsig),
			.TankY(tank1ysig),
			.TankS(tank1sizesig),
			.TankXStep(Tank1XStep), 
			.TankYStep(Tank1YStep),
			.ShootBullet(ShootBullet1),
			.Angle(AngleI1));
			
collisionWall collisonWallTank1(.objectX(tank1xsig),.objectY(tank1ysig),.objectS(tank1sizesig),.DrawX(drawxsig),.DrawY(drawysig),
							.X_Motion(Tank1XStep),.Y_Motion(Tank1YStep),.frame_clk(vs),.Reset(RESET),.pixel_clk(PIX_CLK),
							.currentMazePrime(currentMaze),.MazeUpPrime(MazeLeft),.MazeDownPrime(MazeRight),.MazeLeftPrime(MazeUp),.MazeRightPrime(MazeDown),
							.isWallBottom(isWallBottomT1),.isWallTop(isWallTopT1),.isWallRight(isWallRightT1),.isWallLeft(isWallLeftT1));



logic [9:0] Tank2XStep,Tank2YStep;

tank2 b2(.Reset(RESET),   //Instantiates tank2 module 
			.game_end(game_end),
			.spawn_pos(spawn_pos[19:10]),
			.frame_clk(vs),
			.isWallBottom(current),
			.isWallTop(isWallTopT2),
			.isWallRight(isWallRightT2),
			.isWallLeft(isWallLeftT2),
			.sin(sin2), 
			.cos(cos2),
			.keycode(keycode),
			.TankX(tank2xsig),
			.TankY(tank2ysig),
			.TankS(tank2sizesig),
			.TankXStep(Tank2XStep), 
			.TankYStep(Tank2YStep),
			.ShootBullet(ShootBullet2),
			.Angle(AngleI2));
			

collisionWall collisonWallTank2(.objectX(tank2xsig),.objectY(tank2ysig),.objectS(tank2sizesig),.DrawX(drawxsig),.DrawY(drawysig),
							.X_Motion(Tank2XStep),.Y_Motion(Tank2YStep),.frame_clk(vs),.Reset(RESET),.pixel_clk(PIX_CLK),
							.currentMazePrime(currentMaze),.MazeUpPrime(MazeLeft),.MazeDownPrime(MazeRight),.MazeLeftPrime(MazeUp),.MazeRightPrime(MazeDown),
							.isWallBottom(isWallBottomT2),.isWallTop(isWallTopT2),.isWallRight(isWallRightT2),.isWallLeft(isWallLeftT2));
		
logic bullet1_active;
logic[9:0] bullet1_X,bullet1_Y,bullet1_S,bulletTimer1,Bullet1XStep,Bullet1YStep;

//Bullet1 from tank b2
bullet bullet1(.Reset(RESET), 
					.hit(0),
					.frame_clk(vs), 
					.isWallBottom(isWallBottom1),
					.isWallTop(isWallTop1),
					.isWallRight(isWallRight1),
					.isWallLeft(isWallLeft1),
					.create(ShootBullet2), // TODOand bullet is not active then create on
					.tankX(tank2xsig),
					.tankY(tank2ysig),
					.sin(sin2),
					.cos(cos2),
					//Outputs
					.is_bullet_active(bullet1_active),
               .BulletX(bullet1_X),
					.BulletY(bullet1_Y), 
					.BulletS(bullet1_S),
					.bulletTimer(bulletTimer1),
					.BulletXStep(Bullet1XStep),
					.BulletYStep(Bullet1YStep));  // same postion  as the tank once shot
					

collisionWall collisonWallBullet1(.objectX(bullet1_X),.objectY(bullet1_Y),.objectS(bullet1_S),.DrawX(drawxsig),.DrawY(drawysig),
							.X_Motion(Bullet1XStep),.Y_Motion(Bullet1YStep),.frame_clk(vs),.Reset(RESET),.pixel_clk(PIX_CLK),
							.currentMazePrime(currentMaze),.MazeUpPrime(MazeLeft),.MazeDownPrime(MazeRight),.MazeLeftPrime(MazeUp),.MazeRightPrime(MazeDown),
							.isWallBottom(isWallBottom1),.isWallTop(isWallTop1),.isWallRight(isWallRight1),.isWallLeft(isWallLeft1));

//bullet2 from tank 2 active only after bullet1 is active 		
logic [9:0] bullet2_X,bullet2_Y,bullet2_S,bulletTimer2,Bullet2XStep,Bullet2YStep;
logic bullet2_active;

bullet bullet2(.Reset(RESET),
					.hit(0),
					.frame_clk(vs), 
					.isWallBottom(isWallBottom2),
					.isWallTop(isWallTop2),
					.isWallRight(isWallRight2),
					.isWallLeft(isWallLeft2),
					.create(ShootBullet2 && bullet1_active && (bulletTimer1>10'd35)), // TODOand bullet is not active then create on
					.tankX(tank2xsig),
					.tankY(tank2ysig),
					.sin(sin2),
					.cos(cos2),
					//Outputs
					.is_bullet_active(bullet2_active),
               .BulletX(bullet2_X),
					.BulletY(bullet2_Y), 
					.BulletS(bullet2_S),
					.bulletTimer(bulletTimer2),
					.BulletXStep(Bullet2XStep),
					.BulletYStep(Bullet2YStep));  // same postion  as the tank once shot
					
collisionWall collisonWallBullet2(.objectX(bullet2_X),.objectY(bullet2_Y),.objectS(bullet2_S),.DrawX(drawxsig),.DrawY(drawysig),
							.X_Motion(Bullet2XStep),.Y_Motion(Bullet2YStep),.frame_clk(vs),.Reset(RESET),.pixel_clk(PIX_CLK),
							.currentMazePrime(currentMaze),.MazeUpPrime(MazeLeft),.MazeDownPrime(MazeRight),.MazeLeftPrime(MazeUp),.MazeRightPrime(MazeDown),
							.isWallBottom(isWallBottom2),.isWallTop(isWallTop2),.isWallRight(isWallRight2),.isWallLeft(isWallLeft2));
							
//Bullet3 from tank2
logic [9:0] bullet3_X,bullet3_Y,bullet3_S,bulletTimer3,Bullet3XStep,Bullet3YStep;
logic bullet3_active;
							
bullet bullet3(.Reset(RESET), 
					.hit(hit),
					.frame_clk(vs), 
					.isWallBottom(isWallBottom3),
					.isWallTop(isWallTop3),
					.isWallRight(isWallRight3),
					.isWallLeft(isWallLeft3),
					.create(ShootBullet2 && bullet2_active && (bulletTimer2>10'd35)), // TODOand bullet is not active then create on
					.tankX(tank2xsig),
					.tankY(tank2ysig),
					.sin(sin2),
					.cos(cos2),
					//Outputs
					.is_bullet_active(bullet3_active),
               .BulletX(bullet3_X),
					.BulletY(bullet3_Y), 
					.BulletS(bullet3_S),
					.BulletXStep(Bullet3XStep),
					.BulletYStep(Bullet3YStep),
					.bulletTimer(bulletTimer3)); 
					
collisionWall collisonWallBullet3(.objectX(bullet3_X),.objectY(bullet3_Y),.objectS(bullet3_S),.DrawX(drawxsig),.DrawY(drawysig),
							.X_Motion(Bullet3XStep),.Y_Motion(Bullet3YStep),.frame_clk(vs),.Reset(RESET),.pixel_clk(PIX_CLK),
							.currentMazePrime(currentMaze),.MazeUpPrime(MazeLeft),.MazeDownPrime(MazeRight),.MazeLeftPrime(MazeUp),.MazeRightPrime(MazeDown),
							.isWallBottom(isWallBottom3),.isWallTop(isWallTop3),.isWallRight(isWallRight3),.isWallLeft(isWallLeft3));
							
							
//Bullet1 Tank1
//Bullet7 from tank1
logic [9:0] bullet7_X,bullet7_Y,bullet7_S,bulletTimer7,Bullet7XStep,Bullet7YStep;
logic bullet7_active;
							
bullet bullet7(.Reset(RESET), 
					.game_end(game_end),
					.frame_clk(vs), 
					.isWallBottom(isWallBottom7),
					.isWallTop(isWallTop7),
					.isWallRight(isWallRight7),
					.isWallLeft(isWallLeft7),
					.create(ShootBullet1), // TODOand bullet is not active then create on
					.tankX(tank1xsig),
					.tankY(tank1ysig),
					.sin(sin1),
					.cos(cos1),
					
					//Outputs
					.is_bullet_active(bullet7_active),
               .BulletX(bullet7_X),
					.BulletY(bullet7_Y), 
					.BulletS(bullet7_S),
					.BulletXStep(Bullet7XStep),
					.BulletYStep(Bullet7YStep),
					.bulletTimer(bulletTimer7)); 
					
collisionWall collisonWallBullet7(.objectX(bullet7_X),.objectY(bullet7_Y),.objectS(bullet7_S),.DrawX(drawxsig),.DrawY(drawysig),
							.X_Motion(Bullet7XStep),.Y_Motion(Bullet7YStep),.frame_clk(vs),.Reset(RESET),.pixel_clk(PIX_CLK),
							.currentMazePrime(currentMaze),.MazeUpPrime(MazeLeft),.MazeDownPrime(MazeRight),.MazeLeftPrime(MazeUp),.MazeRightPrime(MazeDown),
							.isWallBottom(isWallBottom7),.isWallTop(isWallTop7),.isWallRight(isWallRight7),.isWallLeft(isWallLeft7));
							
//Bullet2 Tank1
//Bullet7 from tank1
logic [9:0] bullet8_X,bullet8_Y,bullet8_S,bulletTimer8,Bullet8XStep,Bullet8YStep;
logic bullet8_active;
							
bullet bullet8(.Reset(RESET), 
					.game_end(game_end),
					.frame_clk(vs), 
					.isWallBottom(isWallBottom8),
					.isWallTop(isWallTop8),
					.isWallRight(isWallRight8),
					.isWallLeft(isWallLeft8),
					.create(ShootBullet1 && bullet7_active && (bulletTimer7>10'd35)), // TODOand bullet is not active then create on
					.tankX(tank1xsig),
					.tankY(tank1ysig),
					.sin(sin1),
					.cos(cos1),
					
					//Outputs
					.is_bullet_active(bullet8_active),
               .BulletX(bullet8_X),
					.BulletY(bullet8_Y), 
					.BulletS(bullet8_S),
					.BulletXStep(Bullet8XStep),
					.BulletYStep(Bullet8YStep),
					.bulletTimer(bulletTimer8)); 
					
collisionWall collisonWallBullet8(.objectX(bullet8_X),.objectY(bullet8_Y),.objectS(bullet8_S),.DrawX(drawxsig),.DrawY(drawysig),
							.X_Motion(Bullet8XStep),.Y_Motion(Bullet8YStep),.frame_clk(vs),.Reset(RESET),.pixel_clk(PIX_CLK),
							.currentMazePrime(currentMaze),.MazeUpPrime(MazeLeft),.MazeDownPrime(MazeRight),.MazeLeftPrime(MazeUp),.MazeRightPrime(MazeDown),
							.isWallBottom(isWallBottom8),.isWallTop(isWallTop8),.isWallRight(isWallRight8),.isWallLeft(isWallLeft8));
							
//Bullet2 Tank1
//Bullet7 from tank1
logic [9:0] bullet9_X,bullet9_Y,bullet9_S,bulletTimer9,Bullet9XStep,Bullet9YStep;
logic bullet9_active;
							
bullet bullet9(.Reset(RESET), 
					.game_end(game_end),
					.frame_clk(vs), 
					.isWallBottom(isWallBottom9),
					.isWallTop(isWallTop9),
					.isWallRight(isWallRight9),
					.isWallLeft(isWallLeft9),
					.create(ShootBullet1 && bullet9_active && (bulletTimer9>10'd35)), // TODOand bullet is not active then create on
					.tankX(tank1xsig),
					.tankY(tank1ysig),
					.sin(sin1),
					.cos(cos1),
					
					//Outputs
					.is_bullet_active(bullet9_active),
               .BulletX(bullet9_X),
					.BulletY(bullet9_Y), 
					.BulletS(bullet9_S),
					.BulletXStep(Bullet9XStep),
					.BulletYStep(Bullet9YStep),
					.bulletTimer(bulletTimer9)); 
					
collisionWall collisonWallBullet9(.objectX(bullet9_X),.objectY(bullet9_Y),.objectS(bullet9_S),.DrawX(drawxsig),.DrawY(drawysig),
							.X_Motion(Bullet9XStep),.Y_Motion(Bullet9YStep),.frame_clk(vs),.Reset(RESET),.pixel_clk(PIX_CLK),
							.currentMazePrime(currentMaze),.MazeUpPrime(MazeLeft),.MazeDownPrime(MazeRight),.MazeLeftPrime(MazeUp),.MazeRightPrime(MazeDown),
							.isWallBottom(isWallBottom9),.isWallTop(isWallTop9),.isWallRight(isWallRight9),.isWallLeft(isWallLeft9));



//Tank  Bullet Collision 
logic tank2shot,tank1shot;

TBCollision tank1BulletCollision(.Tank_X_Pos(tank1xsig),.Tank_Y_Pos(tank1ysig),.Tank_Size(tank1sizesig),.Bullet1_X_Pos(bullet1_X),
											.Bullet1_Y_Pos(bullet1_Y),.isBullet1Active(bullet1_active),.TBCollided(tank1shot));
											
TBCollision tank2BulletCollision(.Tank_X_Pos(tank2xsig),.Tank_Y_Pos(tank2ysig),.Tank_Size(tank2sizesig),.Bullet1_X_Pos(bullet1_X),
											.Bullet1_Y_Pos(bullet1_Y),.isBullet1Active(bullet1_active),.TBCollided(tank2shot));	
					
//angles for tank 1							
sinCos sincos1(.AngleI(AngleI1), .sin(sin1u), .cos(cos1u));
//angles for tank 2
sinCos sincos2(.AngleI(AngleI2), .sin(sin2u), .cos(cos2u));


//Gives the corresponding sin and cos matching the vga coordinate system

angleMux angleTank1(  .Angle(AngleI1),.sin(sin1u),.cos(cos1u),.newSin(sin1), .newCos(cos1));
angleMux angleTank2(  .Angle(AngleI2),.sin(sin2u),.cos(cos2u),.newSin(sin2), .newCos(cos2));

			
//always_comb
//begin 
//	Byte_ADDR[14:0] = drawxsig[9:2]+drawysig[9:2]*160;
//	Word_ADDR[9:0] = Byte_ADDR[14:5];//How to index the ram
//	//Checking if each pixel is a wall or not 
//	currentMaze = Maze_Reg[Word_ADDR][~Byte_ADDR[4:0]];	
//
//	if(Word_ADDR==10'd0)
//	begin 
//		MazeUp = 1; //There is no register up
//	end 
//	else 
//	begin
//		MazeUp = Maze_Reg[Word_ADDR-10'd5][~Byte_ADDR[4:0]];//Go a word address up
//	end 
//	
//	if(Word_ADDR==10'd599)
//	begin 
//		MazeDown = 1; 
//	end 
//	else 
//	begin 
//		MazeDown = Maze_Reg[Word_ADDR+10'd5][~Byte_ADDR[4:0]];//Go a word address down
//	end
//	
//	if(Byte_ADDR == 10'd31)
//	begin 
//		MazeLeft = Maze_Reg[Word_ADDR - 1'b1][5'b00000];
//	end 
//	else 
//	begin 
//		MazeLeft = Maze_Reg[Word_ADDR][~Byte_ADDR[4:0]+3'd1];//Go a word address down ;
//	end 
//	
//	if(Byte_ADDR == 10'd0)
//	begin 
//		MazeRight = Maze_Reg[Word_ADDR + 1'b1][5'b11111];
//	end 
//	else 
//	begin 
//		MazeRight = Maze_Reg[Word_ADDR][~Byte_ADDR[4:0]-3'd1];//Go a word address down ;
//	end
//
//end 




color_mapper c1(.BallX1(tank1xsig),
				   .BallY1(tank1ysig), 
					.CLK(PIX_CLK),
					.Sys_CLK(CLK),
					.maze(currentMaze),  //Change the names to tank instead of ball
					.title(title),
					.DrawX(drawxsig), 
					.DrawY(drawysig), 
					.Ball_size(4'd10),
					.BallX2(tank2xsig),
					.BallY2(tank2ysig),
					
					.Tank1Shot(tank1shot),
					.Tank2Shot(tank2shot),
					
					.sin1(sin1),
					.cos1(cos1),
					.sin2(sin2),
					.cos2(cos2), 
					
					.Red(red),
					.Blue(blue),
					.Green(green),
					.blank(blank),
					//Transformed drawx for tank2
					.DrawXs2Prime(DrawXs2),
					.DrawYs2Prime(DrawYs2),
					
					
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
