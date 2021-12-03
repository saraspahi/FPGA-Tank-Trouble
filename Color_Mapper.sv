

module color_mapper ( input [9:0] BallX1, BallY1, DrawX, DrawY, Ball_size,BallX2,BallY2,
                      input [7:0] sin2, cos2,
							 input blank, CLK,
							 input maze,
                      output logic [7:0]  Red, Green, Blue, 
							 //bullet1from tank2
							 input [9:0]Bullet1X,Bullet1Y,Bullet1S,
							 input is_bullet1_active,
							 //bullet2from tank2
							 input [9:0]Bullet2X,Bullet2Y,Bullet2S,
							 input is_bullet2_active,
							 input [9:0]Bullet3X,Bullet3Y,Bullet3S,
							 input is_bullet3_active
							 );
    
	logic[9:0] Red_New, Green_New, Blue_New;
	

	
    logic[63:0] XmultCos, YmultSin, XmultSin, YmultCos;
	 logic[31:0] DrawXs2, DrawYs2, BallY2e, BallX2e, DrawXe, DrawYe, sin2e, cos2e, BallXsp, BallYsp;
	 logic XMCsign, YMCsign, XMSsign, YMSsign;
    

	 always_comb
	 begin
            // sign extend ball cords    
			BallY2e[31:0] = {6'b0, BallY2, 16'b0};
			BallX2e[31:0] = {6'b0, BallX2, 16'b0};
            // sign extend draw cords
	        DrawXe[31:0] = {6'b0, DrawX, 16'b0};
            DrawYe[31:0] = {6'b0, DrawY, 16'b0};
            // sign extend cos sin
			cos2e[31:0] = {{12{cos2[7]}}, cos2[7:0], 12'h0};
			sin2e[31:0] = {{12{sin2[7]}}, sin2[7:0], 12'h0};

			BallXsp[31:0] = DrawXe + ~BallX2e+1'b1;
			BallYsp[31:0] = DrawYe + ~BallY2e+1'b1;
            
            XMCsign = BallXsp[31]^cos2e[31];
            YMCsign = BallYsp[31]^cos2e[31];
            XMSsign = BallXsp[31]^sin2e[31];
            YMSsign = BallYsp[31]^sin2e[31];

            XmultCos[63] = XMCsign; 
            XmultSin[63] = XMSsign;
				YmultCos[63] = YMCsign; 
            YmultSin[63] = YMSsign; 

				XmultCos[62:0] = BallXsp[30:0]*cos2e[30:0]; 
            XmultSin[62:0] = BallXsp[30:0]*sin2e[30:0];
				YmultCos[62:0] = BallYsp[30:0]*cos2e[30:0]; 
            YmultSin[62:0] = BallYsp[30:0]*sin2e[30:0]; 

            DrawXs2[15:0] = {{6{XMCsign}}, XmultCos[41:32]} + {{6{~YMCsign}}, ~YmultSin[41:32]}+1'b1 +BallX2;
            DrawYs2[15:0] = {{6{XMSsign}}, XmultSin[41:32]} + {{6{YMCsign}}, YmultCos[41:32]} + BallY2;
	 end
	 
	 
	 
	 
//Check only for maze ........	 
//    always_comb
//    begin
//	 if(blank)
//	 begin 
//	     if (maze)
//		  begin
//          Red = 8'hff;
//          Green = 8'hbb;
//			 Blue = 8'h00;
//			 end
//			else 
//			begin
//			 Red = 8'hff;
//          Green = 8'hff;
//			 Blue = 8'hff;
//			 end
//			 end
//	else
//	begin
//			 Red = 8'h00;
//          Green = 8'h00;
//			 Blue = 8'h00;
//			 end
//			
//		 
//	 
//	 
//	 end 

	always_ff@(posedge CLK)
	begin
		Red <= Red_New;
		Green <= Green_New;
		Blue <= Blue_New;
	end

	 

    always_comb
    begin
	 
	 if(blank)
	 
	 begin
	 //draws the head of the tank1
	 		if((DrawX >= BallX1) &&
				(DrawX <= BallX1 + Ball_size) &&
				(DrawY >= BallY1 - 3'b110) &&
				(DrawY <= BallY1 + 3'b110))
				begin
					Red_New = 8'h55;
					Green_New = 8'h55;
					Blue_New = 8'h00;
				end
	 //Draws the body of tank1
			else if ((DrawX >= BallX1 - Ball_size) &&
				(DrawX <= BallX1 + Ball_size) &&
				(DrawY >= BallY1 - Ball_size) &&
				(DrawY <= BallY1 + Ball_size))
            begin 
                Red_New = 8'hff;
                Green_New = 8'hbb;
                Blue_New = 8'h00;
            end
			//Draws bullet1 from tank 2	
			else if((DrawX >= Bullet1X - Bullet1S) &&
				(DrawX <= Bullet1X + Bullet1S) &&
				(DrawY >= Bullet1Y - Bullet1S) &&
				(DrawY <= Bullet1Y + Bullet1S)&& is_bullet1_active)
				begin 
					Red_New = 8'h00;
					Green_New = 8'h00;
					Blue_New = 8'h00;
				end 
			//Draws bullet2 from tank2
			else if((DrawX >= Bullet2X - Bullet2S) &&
				(DrawX <= Bullet2X + Bullet2S) &&
				(DrawY >= Bullet2Y - Bullet2S) &&
				(DrawY <= Bullet2Y + Bullet2S) && is_bullet2_active)
				begin 
					Red_New = 8'h00;
					Green_New = 8'h00;
					Blue_New = 8'h00;
				end 
						//Draws bullet2 from tank2
			else if((DrawX >= Bullet3X - Bullet3S) &&
				(DrawX <= Bullet3X + Bullet3S) &&
				(DrawY >= Bullet3Y - Bullet3S) &&
				(DrawY <= Bullet3Y + Bullet3S) && is_bullet3_active)
				begin 
					Red_New = 8'h00;
					Green_New = 8'h00;
					Blue_New = 8'h00;
				end 
				
				
		 		//Draws the head of tank 2	
		  else if((DrawXs2[9:0] >= BallX2) &&
				(DrawXs2[9:0] <= BallX2 + Ball_size) &&
				(DrawYs2[9:0] >= BallY2 - 3'b110) &&
				(DrawYs2[9:0] <= BallY2 + 3'b110))
				begin
					Red_New = 8'h55;
					Green_New = 8'h55;
					Blue_New = 8'h00;
				end
		 //Draws the body of tank 2

        else if ((DrawXs2[9:0] >= BallX2 - Ball_size) &&
				(DrawXs2[9:0] <= BallX2 + Ball_size) &&
				(DrawYs2[9:0] >= BallY2 - Ball_size) &&
				(DrawYs2[9:0] <= BallY2 + Ball_size))
				begin
					Red_New = 8'hff;
					Green_New = 8'h00;
					Blue_New = 8'h00;
				end 
        //Draws the background
			else 
			begin 
                Red_New = 8'h55; 
                Green_New = 8'h55;
                Blue_New = 8'h55;
			end 
			end
			
	 else 
	 begin 
	     Red_New = 8'h00;
        Green_New = 8'h00;
        Blue_New = 8'h00;
	 
	 end
     end 
       

     
    
endmodule
