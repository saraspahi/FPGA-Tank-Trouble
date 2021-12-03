//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module tank1 ( input Reset, frame_clk,
					input [31:0] keycode,
					input [7:0] sin, cos,
               output [9:0]  TankX, TankY, TankS,
					output ShootBullet,
					output [5:0] Angle);//inxe
    
    logic [9:0] Tank_X_Pos,Tank_X_Motion, Tank_Y_Pos, Tank_Y_Motion,Tank_Size;
	 logic [7:0] key;
	 
    parameter [9:0] Tank_X_Center=320;  // Center position on the X axis
    parameter [9:0] Tank_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Tank_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Tank_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Tank_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Tank_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Tank_X_Step=1;      // Step size on the X axis
    parameter [9:0] Tank_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 10;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Tank_Y_Motion <= 10'd0; //Ball_Y_Step;
				Tank_X_Motion <= 10'd0; //Ball_X_Step;
				Tank_Y_Pos <= Tank_Y_Center;
				Tank_X_Pos <= Tank_X_Center;
        end
           
        else 
        begin 
			
					  Tank_Y_Motion <= 10'd0;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  Tank_X_Motion <= 10'd0;
				 
				 if ((keycode[31:24] ==8'h04 )||(keycode[23:16]==8'h04)||(keycode[15:8] ==8'h04)||(keycode[7:0]==8'h04))
					  key <= 8'h04;
				 else if ((keycode[31:24] ==8'h07 )||(keycode[23:16]==8'h07)||(keycode[15:8] ==8'h07)||(keycode[7:0]==8'h07))
					  key <= 8'h07;
				 else if ((keycode[31:24] ==8'h16 )||(keycode[23:16]==8'h16)||(keycode[15:8] ==8'h16)||(keycode[7:0]==8'h16))
					  key <= 8'h16;
				 else if ((keycode[31:24] ==8'h1A )||(keycode[23:16]==8'h1A)||(keycode[15:8] ==8'h1A)||(keycode[7:0]==8'h1A))
					  key <= 8'h1A;
				 else 
					  key <= 8'h00;
					  
				 
				 case (key)
					8'h04 : begin
							
								begin
									Tank_X_Motion <= -1;//A
									Tank_Y_Motion<= 0;
								end
							  end
					        
					8'h07 : begin
						
								begin
									Tank_X_Motion <= 1;//D
									Tank_Y_Motion <= 0;
								end
							  end

							  
					8'h16 : begin

							  begin
									Tank_Y_Motion <= 1;//S
									Tank_X_Motion <= 0;
								end
							 end
							  
					8'h1A : begin

								begin
									Tank_Y_Motion <= -1;//W
									Tank_X_Motion <= 0;
								end
							 end	  
					default: ;
			   endcase
				 
				 Tank_Y_Pos <= (Tank_Y_Pos + Tank_Y_Motion);  // Update ball position
				 Tank_X_Pos <= (Tank_X_Pos + Tank_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign TankX = Tank_X_Pos;
   
    assign TankY = Tank_Y_Pos;
   
    assign TankS = Tank_Size;
    

endmodule
