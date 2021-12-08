


module tank2 ( input Reset, frame_clk,hit,
					input isWallBottom,isWallTop,isWallRight,isWallLeft,
					input [1:0] game_end,
               input [7:0] sin, cos,
					input [31:0] keycode,
					input [9:0] spawn_pos,
               output [9:0]  TankX, TankY, TankS,TankXStep,TankYStep,
					output ShootBullet,
					output [5:0] Angle );
    
   logic [9:0] Tank_X_Pos, Tank_Y_Pos,Tank_Size,timer;
	logic [9:0] Tank_X_Motion, Tank_Y_Motion;
	logic [5:0] Angle_new, Angle_Motion;
	
	logic [7:0] key;
    logic [15:0] Tank_X_Comp, Tank_Y_Comp;
	 logic signX, signY,ShootBulletP;
    always_comb
    begin
		  signX = Tank_X_Step[7] ^ cos[7];
		  signY = Tank_Y_Step[7] ^ sin[7];
        Tank_X_Comp[15:0] = Tank_X_Step[6:0]*cos[6:0];
        Tank_Y_Comp[15:0] = Tank_Y_Step[6:0]*sin[6:0];
    end    

    parameter [9:0] Tank_X_Center=300;  // Center position on the X axis
    parameter [9:0] Tank_Y_Center=250;  // Center position on the Y axis
    parameter [9:0] Tank_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Tank_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Tank_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Tank_Y_Max=479;     // Bottommost point on the Y axis
    parameter [7:0] Tank_X_Step=8'b0011_0000;      // Step size on the X axis
    parameter [7:0] Tank_Y_Step=8'b0011_0000;      // Step size on the Y axis
    parameter [5:0] AngleStep= 5'b00001;				//angle counter clockwise step 1 corresponds to 4 degrees. 22 is 360 set to 0

    assign Tank_Size = 10;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin
        if (Reset)  // Asynchronous Reset
        begin 
            Tank_Y_Motion = 10'd0; //Ball_Y_Step;
				Tank_X_Motion = 10'd0; //Ball_X_Step;
				Angle_Motion =  5'd0;	      //Ball angle step;
				Tank_Y_Pos = Tank_Y_Center;
				Tank_X_Pos = Tank_X_Center;
				Angle_new = 0;
				ShootBulletP= 0;

        end
		  	else if(game_end>0)
				begin 
            Tank_Y_Motion = 10'd0; //Ball_Y_Step;
				Tank_X_Motion =  10'd0; //Ball_X_Step;
				Angle_Motion =  5'd0;	      //Ball angle step;
				Tank_Y_Pos[9:0] = {spawn_pos[9:5],5'h0};
				Tank_X_Pos[9:0] = {spawn_pos[4:0],5'h0};
				Angle_new = 0;
				ShootBulletP =0;
				end
		  else if(hit)
		  begin 
            Tank_Y_Motion = 10'd0; //Ball_Y_Step;
				Tank_X_Motion =  10'd0; //Ball_X_Step;
				Angle_Motion =  5'd0;	      //Ball angle step;
				Tank_Y_Pos = Tank_Y_Center;
				Tank_X_Pos = Tank_X_Center;
				Angle_new = 0;
				ShootBulletP =0;
				end

        else 
        begin 
		  			if(isWallBottom || isWallTop || isWallRight || isWallLeft )
					begin 
				   Tank_Y_Pos[9:0] = Tank_Y_Pos + ~Tank_Y_Motion+1'b1;  // Update ball position
				   Tank_X_Pos[9:0] = Tank_X_Pos + ~Tank_X_Motion+1'b1 ;
					end 
					else
					begin
					Tank_Y_Motion = 10'd0 ;  // Tank is somewhere in the middle, don't move
					Tank_X_Motion = 10'd0;
					Angle_Motion = 5'd0;
					end


				 
				 if ((keycode[31:24] ==8'h52 )||(keycode[23:16]==8'h52)||(keycode[15:8] ==8'h52)||(keycode[7:0]==8'h52))//up
//					  key <= 8'h52;
					begin
					if(isWallBottom || isWallTop || isWallRight || isWallLeft )//up
					begin 
				   Tank_Y_Pos[9:0] = Tank_Y_Pos + ~Tank_Y_Motion+1'b1 ;  // Update ball position
				   Tank_X_Pos[9:0] = Tank_X_Pos + ~Tank_X_Motion+1'b1 ;
						ShootBulletP = 0;						Angle_Motion = 0;

					end 
					else
					begin
			
					Tank_Y_Motion[9:0] =  {{6{~signY}},~Tank_Y_Comp[10:7]} + 1'b1;//up 
					Tank_X_Motion[9:0] =  {{6{signX}},Tank_X_Comp[10:7]};
					Angle_Motion = 0;
					ShootBulletP = 0;
					end
					end
				 else if ((keycode[31:24] ==8'h51 )||(keycode[23:16]==8'h51)||(keycode[15:8] ==8'h51)||(keycode[7:0]==8'h51))//down
//					  key <= 8'h51;
				 begin 
				 	if(isWallBottom || isWallTop || isWallRight || isWallLeft )//down
					begin 
				   Tank_Y_Pos[9:0] = Tank_Y_Pos + ~Tank_Y_Motion+1'b1;  // Update ball position
				   Tank_X_Pos[9:0] = Tank_X_Pos + ~Tank_X_Motion+1'b1;
					Angle_Motion = 0;
					ShootBulletP = 0;
					end 
					else
					begin
                  
					Tank_Y_Motion[9:0] = {{6{signY}},Tank_Y_Comp[10:7]};//down
					Tank_X_Motion[9:0] = {{6{~signX}}, ~Tank_X_Comp[10:7]} + 1'b1;
					Angle_Motion = 0;
					ShootBulletP = 0;
					end


				 end
				 else if ((keycode[31:24] ==8'h50 )||(keycode[23:16]==8'h50)||(keycode[15:8] ==8'h50)||(keycode[7:0]==8'h50))//right increase angle
//					  key <= 8'h50;
				 begin 
				 				 
					if(isWallBottom || isWallTop || isWallRight || isWallLeft )
					begin 
				   Tank_Y_Pos[9:0] = Tank_Y_Pos + ~Tank_Y_Motion+1'b1;  // Update ball position
				   Tank_X_Pos[9:0] = Tank_X_Pos + ~Tank_X_Motion+1'b1;
					Angle_Motion = 0;
					ShootBulletP =0;
					end 
					else 		
					begin
					Tank_X_Motion = 0;
					Tank_Y_Motion= 0;
					Angle_Motion =  1;
					ShootBulletP =0;
					end
				 
				 end
				 else if ((keycode[31:24] ==8'h4f )||(keycode[23:16]==8'h4f)||(keycode[15:8] ==8'h4f)||(keycode[7:0]==8'h4f))//left decrease angle
//					  key <= 8'h4f;
				 begin 
				 	if(isWallBottom || isWallTop || isWallRight || isWallLeft )
					begin 
				   Tank_Y_Pos[9:0] = Tank_Y_Pos + ~Tank_Y_Motion+1'b1 ;  // Update ball position
				   Tank_X_Pos[9:0] = Tank_X_Pos + ~Tank_X_Motion+1'b1;
					Angle_Motion = 0;
					ShootBulletP = 0;
					end 
					else
							
					begin
					Tank_X_Motion = 0;//D
					Tank_Y_Motion = 0;
					Angle_Motion =  -1;      
					ShootBulletP = 0;
					end
				 
				 
				 end
				 else if ((keycode[31:24] ==8'h2c )||(keycode[23:16]==8'h2c)||(keycode[15:8] ==8'h2c)||(keycode[7:0]==8'h2c))//shoot
//					  key <= 8'h2c;
				 begin 
				 					 
						Tank_Y_Motion = 10'd0 ;  // Tank is somewhere in the middle, don't move
						Tank_X_Motion = 10'd0;
						Angle_Motion = 5'd0;
						ShootBulletP = 1;
						timer = timer+1'b1;
	
				 
				 end
				 else 
//					  key <= 8'h00; 
				begin 
						ShootBulletP =0;
						timer=10'd0;
				
				end 
					
				 
//				 case (key)
//					8'h50 : begin
//					if(isWallBottom || isWallTop || isWallRight || isWallLeft )
//					begin 
//				   Tank_Y_Pos[9:0] = ( TankPrevY);  // Update ball position
//				   Tank_X_Pos[9:0] = ( TankPrevX);
//						Angle_Motion <= 0;
//						ShootBulletP <=0;
//					end 
//					else 		
//					begin
//						Tank_X_Motion <= 0;
//						Tank_Y_Motion<= 0;
//						Angle_Motion <=  AngleStep;
//						ShootBulletP <=0;
//					end
//					end
//					        
//					8'h4f : begin
//					if(isWallBottom || isWallTop || isWallRight || isWallLeft )
//					begin 
//				   Tank_Y_Pos[9:0] = (TankPrevY);  // Update ball position
//				   Tank_X_Pos[9:0] = (TankPrevX);
//						Angle_Motion <= 0;
//						ShootBulletP <=0;
//					end 
//					else
//							
//					begin
//						Tank_X_Motion <= 0;//D
//						Tank_Y_Motion <= 0;
//						Angle_Motion <=  ~(AngleStep) + 1;      // Descreases the angle
//						ShootBulletP <=0;
//					end
//					end
//							  
//					8'h52 : begin
//					if(isWallBottom || isWallTop || isWallRight || isWallLeft )//up
//					begin 
//				   Tank_Y_Pos[9:0] = (TankPrevY);  // Update ball position
//				   Tank_X_Pos[9:0] = (TankPrevX);
//						Angle_Motion <= 0;
//						ShootBulletP <=0;
//					end 
//					else
//					begin
//			
//					Tank_Y_Motion[9:0] <=  {{6{~signY}},~Tank_Y_Comp[10:7]} + 1'b1;//up 
//					Tank_X_Motion[9:0] <=  {{6{signX}},Tank_X_Comp[10:7]};
//					Angle_Motion <=0;
//					ShootBulletP <=0;
//					end
//					end
//							  
//					8'h51 : begin
//					if(isWallBottom || isWallTop || isWallRight || isWallLeft )//down
//					begin 
//				   Tank_Y_Pos[9:0] = (TankPrevY);  // Update ball position
//				   Tank_X_Pos[9:0] = (TankPrevX);
//						Angle_Motion <= 0;
//						ShootBulletP <=0;
//					end 
//					else
//					begin
//                  
//						Tank_Y_Motion[9:0] <= {{6{signY}},Tank_Y_Comp[10:7]};//down
//						Tank_X_Motion[9:0] <= {{6{~signX}}, ~Tank_X_Comp[10:7]} + 1'b1;
//						Angle_Motion <=0;
//						ShootBulletP <=0;
//					end
//					end
//								
//					8'h2c : begin
//							  begin 
//							  		Tank_Y_Motion <= 10'd0 ;  // Tank is somewhere in the middle, don't move
//									Tank_X_Motion <= 10'd0;
//									Angle_Motion <= 5'd0;
//									ShootBulletP <= 1;
//									timer <=timer+1'b1;
//								end 
//								end
//								  
//					default:begin 
//								ShootBulletP <=0;
//								timer<=10'd0;
//							end
//			   endcase
				 
				 Tank_Y_Pos[9:0] = (Tank_Y_Pos[9:0] + Tank_Y_Motion[9:0]);  // Update ball position
				 Tank_X_Pos[9:0] = (Tank_X_Pos[9:0] + Tank_X_Motion[9:0]);
				 //Angle_new = Angle_new + Angle_Motion;    
		
				 
				 if(Angle_new ==45)
					Angle_new <= 0;
				 else if(Angle_new >44 || Angle_new<0)
					Angle_new <= 44;
             else
					Angle_new <= Angle_new + Angle_Motion; 

      
			
		end  
    end
       
    assign TankX = Tank_X_Pos;
	 
    assign TankY = Tank_Y_Pos;
	 
    assign TankS = Tank_Size;
	 
	 assign TankXStep = Tank_X_Motion;
	 
	 assign TankYStep = Tank_Y_Motion;
	 
	 assign Angle = Angle_new;
	
	 assign ShootBullet= ShootBulletP;
	
    
endmodule
