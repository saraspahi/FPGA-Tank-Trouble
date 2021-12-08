

module color_mapper ( input [9:0] BallX1, BallY1, DrawX, DrawY, Ball_size,BallX2,BallY2,
                      input Tank2Shot, Tank1Shot,                                 
                      input [7:0] sin2, cos2,
							 input blank, CLK, Sys_CLK,
							 input maze,
							 input title,
                      output logic [7:0]  Red, Green, Blue, 
							 //bullet1from tank2
							 input [9:0]Bullet1X,Bullet1Y,Bullet1S,
							 input is_bullet1_active,
							 //bullet2from tank2
							 input [9:0]Bullet2X,Bullet2Y,Bullet2S,
							 input is_bullet2_active,
							 input [9:0]Bullet3X,Bullet3Y,Bullet3S,
							 input is_bullet3_active,
							 output logic [9:0] DrawXs2Prime,DrawYs2Prime
							 );
    
	 logic[9:0] Red_New, Green_New, Blue_New;
	

	title title_screen(.clock(Sys_CLK), .address(TitleADDR), .q(PalletI));
	red_tank blerim(.clock(Sys_CLK), .address(TankADDR), .q(PalletIR));
	
	logic [23:0] Pallet[8];
	always_comb
	begin
	 Pallet[0] = 24'hFF3131;
	 Pallet[1] = 24'h312D2B;
	 Pallet[2] = 24'h878685;
	 Pallet[3] = 24'h9B9DA0;
	 Pallet[4] = 24'hFFE100;
	 Pallet[5] = 24'hFF00D6;
	 Pallet[6] = 24'h000000;
	 Pallet[7] = 24'hFFFFFF;
	end
	
    logic[63:0] XmultCos, YmultSin, XmultSin, YmultCos;
	 logic [15:0] DrawXs2,DrawYs2;
	 logic[31:0] BallY2e, BallX2e, DrawXe, DrawYe, sin2e, cos2e, BallXsp, BallYsp;
	 logic[19:0] TitleADDR;
	 logic[2:0] PalletI, PalletIR;
	 logic[8:0] TankADDR, TankADDRY;
	 logic[9:0] TankXSp, TankYY, TankXY;
	 logic[9:0] TankYSp;
	 logic XMCsign, YMCsign, XMSsign, YMSsign;
    
	
	 always_comb
	 begin
			
			TankXSp[9:0] = DrawXs2[9:0] - BallX2[9:0] + Ball_size[9:0];
			TankYSp[9:0] = DrawYs2[9:0] - BallY2[9:0] + Ball_size[9:0];
			
			TankADDR = TankXSp[4:0] + TankYSp[4:0]*5'd20;
			
			TankXY[9:0] = DrawX[9:0] - BallX1[9:0] + Ball_size[9:0];
			TankYY[9:0] = DrawY[9:0] - BallY1[9:0] + Ball_size[9:0];
			
			TankADDRY = TankXSp[4:0] + TankYSp[4:0]*5'd20;
			
			TitleADDR = DrawX + DrawY*10'd640;
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
				
				DrawXs2Prime[9:0] = DrawXs2[9:0];
				DrawYs2Prime[9:0] = DrawYs2[9:0];
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
			
			if(title)
			begin 
					Red_New = Pallet[PalletI[2:0]][23:16];
					Green_New = Pallet[PalletI[2:0]][15:8];
					Blue_New = Pallet[PalletI[2:0]][7:0];
			end
			else if(maze)
			begin 
					Red_New = 8'h00;
					Green_New = 8'h00;
					Blue_New = 8'h00;
			end
	 
	 //draws the head of the tank1
			else if((DrawX >= BallX1) &&
				(DrawX <= BallX1 + Ball_size) &&
				(DrawY >= BallY1 - 3'b110) &&
				(DrawY <= BallY1 + 3'b110) && !Tank1Shot)
				begin
					Red_New = 8'h00;
					Green_New = 8'hFF;
					Blue_New = 8'hFF;
				end
	 //Draws the body of tank1
			else if ((DrawX >= BallX1 - Ball_size) &&
				(DrawX <= BallX1 + Ball_size) &&
				(DrawY >= BallY1 - Ball_size) &&
				(DrawY <= BallY1 + Ball_size) && !Tank1Shot)
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
//		  else if((DrawXs2[9:0] >= BallX2) &&
//				(DrawXs2[9:0] <= BallX2 + Ball_size) &&
//				(DrawYs2[9:0] >= BallY2 - 3'b110) &&
//				(DrawYs2[9:0] <= BallY2 + 3'b110) && !Tank2Shot)
//				begin
//					Red_New = 8'h00;
//					Green_New = 8'hFF;
//					Blue_New = 8'hFF;
//				end
		 //Draws the body of tank 2

        else if ((DrawXs2[9:0] >= BallX2 - Ball_size) &&
				(DrawXs2[9:0] <= BallX2 + Ball_size) &&
				(DrawYs2[9:0] >= BallY2 - Ball_size) &&
				(DrawYs2[9:0] <= BallY2 + Ball_size - 1) && !Tank2Shot)
				begin
					if(PalletIR != 3'd5)
					begin
						Red_New = Pallet[PalletIR[2:0]][23:16];
						Green_New = Pallet[PalletIR[2:0]][15:8];
						Blue_New = Pallet[PalletIR[2:0]][7:0];
					end
					else
					begin
						Red_New = 8'h55; 
						Green_New = 8'h55;
						Blue_New = 8'h55;
					end
				end 
//			 else if ((DrawX[9:0] >= 10'd200 - Ball_size) &&
//				(DrawX[9:0] <= 10'd200 + Ball_size) &&
//				(DrawY[9:0] >= 10'd40 - Ball_size) &&
//				(DrawY[9:0] <= 10'd40 + Ball_size - 1) && !Tank2Shot)
//				begin
//					if(PalletIR != 3'd5)
//					begin
//						Red_New = Pallet[PalletIY[2:0]][23:16];
//						Green_New = Pallet[PalletIY[2:0]][15:8];
//						Blue_New = Pallet[PalletIY[2:0]][7:0];
//					end
//					else
//					begin
//						Red_New = 8'h55; 
//						Green_New = 8'h55;
//						Blue_New = 8'h55;
//					end
//				end 
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
