module bullet ( input Reset, frame_clk, //Faster clock needed
<<<<<<< Updated upstream
						input bullet_active,input angle,
                output [9:0]  BulletX, BulletY, BulletS );
=======
					 input isWallBottom,isWallTop,isWallRight,isWallLeft,
					 input shoot; //coming from some kind of state machine for the buller
					 input [9:0] tankX,tankY,
					 input [5:0] angle,
					 input [] sin, cos;
					 output is_bullet_active,
                output [9:0]  BulletX, BulletY, BulletS);  // same postion  as the tank once shot
					 
logic [9:0] Bullet_Y_Motion, Bullet_X_Motion,X_Motion,Y_Motion;

assign X_Motion = bullet_Step*cos;
assign Y_Motion = bullet_Step*sin;					 
parameter [9:0] bulletXCenter=tankX;
parameter [9:0] bulletYCenter=tankY;
parameter [7:0] bullet_Step=8'b0101_0000;


always_ff @ (posedge Reset or posedge frame_clk )
   begin: Move_Ball
            Bullet_Y_Motion <= X_Motion; //Ball_Y_Step;
				Bullet_X_Motion <= Y_Motion; //Ball_X_Step;
				
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
				
					
				
				



					 
					 
					 

>>>>>>> Stashed changes
endmodule
					 
					 
