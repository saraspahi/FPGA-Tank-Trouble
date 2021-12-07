

module bullet ( input Reset, frame_clk,hit,
					input isWallBottom,isWallTop,isWallRight,isWallLeft,create,
					input [9:0] tankX,tankY,
               input [7:0] sin, cos,
					output is_bullet_active,
					input [31:0] keycode,
               output [9:0]  BulletX, BulletY, BulletS,BulletXStep,BulletYStep,
					output [15:0] bulletTimer);
    
   logic [9:0] Bullet_X_Pos, Bullet_Y_Pos, Bullet_Size;
	logic [9:0] Bullet_X_Motion, Bullet_Y_Motion, Bullet_X_Motion1, Bullet_Y_Motion1;
	logic [5:0] Angle_Motion,Angle_new;
	logic creation_flag;
	logic [15:0]timer,timer2; //timer is to dissapear bullet, timer2 is to make the bullet active after some time
	
	logic [7:0] key;
   logic [15:0] Bullet_X_Comp, Bullet_Y_Comp;
	logic signX, signY;
	
	logic [7:0] sinBullet;
	logic [7:0] cosBullet;
   

    parameter [9:0] Bullet_X_Center=0;  // Center position on the X axis
    parameter [9:0] Bullet_Y_Center=0;  // Center position on the Y axis
    parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis
    parameter [7:0] Bullet_X_Step=8'b0010_0000;    
	 parameter [7:0] Bullet_Y_Step=8'b0010_0000; 
	 

   				//angle counter clockwise step 1 corresponds to 4 degrees. 22 is 360 set to 0

    assign Bullet_Size = 1;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Bullet
        if (Reset)  // Asynchronous Reset
        begin 
            Bullet_Y_Motion <= 10'd0; //Ball_Y_Step;
				Bullet_X_Motion <= 10'd0; //Ball_X_Step;
				Bullet_X_Pos <= Bullet_Y_Center;
				Bullet_Y_Pos <= Bullet_X_Center;
			   is_bullet_active<=0;
				timer<=0;
				timer2<=0;

        end 
		  else
		  begin 
		       //The flag drives the logic below
				if(create)
					begin 
				creation_flag<=1;
					end 
				else 
					begin
				creation_flag<=0;
					end 
				
				//Create bullet,save the shooting angle 
			   if (creation_flag && !is_bullet_active) 
					begin

					is_bullet_active<=1'b1;
					//save the sin and cos at the moment of creation and calc direction
					sinBullet<=sin;
					cosBullet<=cos;
					
					signX = Bullet_X_Step[7] ^ cos[7];
					signY = Bullet_Y_Step[7] ^ sin[7];
					Bullet_X_Comp[15:0] = Bullet_X_Step[6:0]*cos[6:0];
					Bullet_Y_Comp[15:0] = Bullet_Y_Step[6:0]*sin[6:0];
					//The steps to take according to angle
					Bullet_Y_Motion[9:0] =  {{6{~signY}},~Bullet_Y_Comp[10:7]}+1;
					Bullet_X_Motion[9:0] =  {{6{signX}},Bullet_X_Comp[10:7]};
					
					
					Bullet_X_Motion1[9:0] <= Bullet_X_Motion[9:0];
					Bullet_Y_Motion1[9:0] <= Bullet_Y_Motion[9:0];
					
					
					Bullet_X_Pos<=tankX+Bullet_X_Motion[9:0] + Bullet_X_Motion[9:0] + Bullet_X_Motion[9:0] + Bullet_X_Motion[9:0] + Bullet_X_Motion[9:0];//add offset based on angle needs start out of the tanks body for collisions to work???
																	//Multiply by a different step size in the beginning
					Bullet_Y_Pos<=tankY+Bullet_Y_Motion[9:0] + Bullet_Y_Motion[9:0] + Bullet_Y_Motion[9:0] + Bullet_Y_Motion[9:0] + Bullet_Y_Motion[9:0];
//					timer2<=timer2+1'b1;
//					if(timer2>=16'd5)
//							is_bullet_active<=1'b1;
//					else 
//							is_bullet_active=is_bullet_active;
					end
				else if (is_bullet_active)
				begin
				
		//Collision logic 
							
				if(isWallBottom ==1'b1)
					begin
					Bullet_Y_Motion = ~Bullet_Y_Motion+1'b1;
					Bullet_X_Motion = Bullet_X_Motion;				

					
					end
				else if(isWallTop == 1'b1)
					begin 
				
					Bullet_Y_Motion = ~Bullet_Y_Motion+1'b1;
					Bullet_X_Motion = Bullet_X_Motion;

					end 
				else if (isWallRight==1'b1)
					begin 
					Bullet_Y_Motion = Bullet_Y_Motion;
					Bullet_X_Motion = ~Bullet_X_Motion+1'b1;

					end 
					
				else if (isWallLeft==1'b1)
					begin 
					Bullet_Y_Motion = Bullet_Y_Motion;
					Bullet_X_Motion = ~Bullet_X_Motion+1'b1;

					end 
				else
					begin
					
					Bullet_Y_Motion = Bullet_Y_Motion;
					Bullet_X_Motion = Bullet_X_Motion;
					end 
					//Counter to make the bullet dissapear after some time
					timer<=timer+1'b1;
				
					Bullet_X_Pos<=Bullet_X_Pos+Bullet_X_Motion;
					Bullet_Y_Pos<=Bullet_Y_Pos+Bullet_Y_Motion;
					
										
					if(timer>=16'd1000)
					begin 
						is_bullet_active=1'b0;
						timer<=16'd0;
					end
					else 
					begin 
						is_bullet_active=is_bullet_active;
						
					end
				end 
			end
		end
 
     
    assign BulletX = Bullet_X_Pos;
   
    assign BulletY = Bullet_Y_Pos;
   
    assign BulletS = Bullet_Size;
	 
	 assign bulletTimer = timer;
	 
	 assign BulletXStep = Bullet_X_Motion;
	 
	 assign BulletYStep = Bullet_Y_Motion;

    

endmodule



					 
					 
