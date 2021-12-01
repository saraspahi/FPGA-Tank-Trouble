//Controls the bullet fired by the player 
//Each tank can have 3 bullets at the same time in the screen 


module bullet ( input Reset, frame_clk, //Faster clock needed
					 input isWallBottom,isWallTop,isWallRight,isWallLeft,
					 input create, //coming from some kind of state machine for the bullet whenever the shoot key is pressed
					 input [9:0] tankX,tankY,
					 input [5:0] angle,
					 input [7:0] sin, cos,
					 output is_bullet_active,
                output [9:0]  BulletX, BulletY, BulletS);  // same postion  as the tank once shot
					 
logic [9:0] Bullet_Y_Motion, Bullet_X_Motion,X_Motion,Y_Motion;
logic [9:0] Bullet_X_Pos, Bullet_Y_Pos, Bullet_Size;
logic [8:0] bulletLife;

					 

parameter [7:0] bullet_Step=8'b0101_0000;
parameter [2:0] Bullet_size = 2'd5; 
assign X_Motion = bullet_Step*cos;
assign Y_Motion = bullet_Step*sin;



always_ff @ (posedge Reset or posedge frame_clk )
   begin 
	
		if(Reset)
			begin 
			is_bullet_active<=0;
			//bulletLife <=9'd240; //Do sth with the life

			
			end 
		else if(create==1'b1)
			begin
			is_bullet_active<=1;
			//bulletLife<=bulletLife-1;
			Bullet_X_Pos <= tankX;
			Bullet_Y_Pos<= tankY;
         Bullet_Y_Motion <= Y_Motion; //Ball_Y_Step;
			Bullet_X_Motion <= X_Motion; //Ball_X_Step;
			end
		else 
		begin 
			
				is_bullet_active <=1;
				if(isWallBottom ==1'b1)
					begin
					Bullet_Y_Motion <= ~Bullet_Y_Motion+1'b1;
					Bullet_X_Motion <= Bullet_X_Motion;
					end
				else if(isWallTop == 1'b1)
					begin 
				
					Bullet_Y_Motion <= ~Bullet_Y_Motion+1'b1;
					Bullet_X_Motion <= Bullet_X_Motion;
					end 
				else if (isWallRight==1'b1)
					begin 
					Bullet_Y_Motion <= Bullet_Y_Motion;
					Bullet_X_Motion <= ~Bullet_X_Motion+1;
					end 
					
				else if (isWallLeft==1'b1)
					begin 
					Bullet_Y_Motion <= Bullet_Y_Motion;
					Bullet_X_Motion <= ~Bullet_X_Motion+1;
					end 
				else
					begin
					
					Bullet_Y_Motion <= Bullet_Y_Motion;
					Bullet_X_Motion <= Bullet_X_Motion;
					end 
				end
				
			Bullet_Y_Pos[9:0] <= (Bullet_Y_Pos[9:0] + Bullet_Y_Motion[9:0]);  // Update ball position
			Bullet_X_Pos[9:0] <= (Bullet_X_Pos[9:0] + Bullet_X_Motion[9:0]);
			
			
			end 
		 
				
//		always_comb	
//		begin	
//		if(bulletLife==0)
//			begin 
//			is_bullet_active=0;
//			end
//		end
		
	assign BulletX=Bullet_X_Pos;
	assign BulletY=Bullet_Y_Pos;
	assign BulletS=Bullet_Size;
					
			
endmodule
					 
					 
