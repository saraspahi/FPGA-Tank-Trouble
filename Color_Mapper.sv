

module color_mapper ( input [9:0] BallX1, BallY1, DrawX, DrawY, Ball_size,BallX2,BallY2,
                      input Tank2Shot, Tank1Shot,                                 

							 input blank, CLK, Sys_CLK,
							 input [7:0] sin2, cos2, sin1,cos1,

							 input maze,
							 input title, t1wscreen, t2wscreen,
                      output logic [7:0]  Red, Green, Blue, 
							 //bullet1from tank2
							 input [9:0]Bullet1X,Bullet1Y,Bullet1S,
							 input is_bullet1_active,
							 //bullet2from tank2
							 input [9:0]Bullet2X,Bullet2Y,Bullet2S,
							 input is_bullet2_active,
							 input [9:0]Bullet3X,Bullet3Y,Bullet3S,
							 input is_bullet3_active,
							 input [9:0] Bullet7X,Bullet7Y,Bullet7S,
							 input is_bullet7_active,
							 input [9:0] Bullet8X,Bullet8Y,Bullet8S,
							 input is_bullet8_active,
							 input [9:0] Bullet9X,Bullet9Y,Bullet9S,
							 input is_bullet9_active,
							 output logic [9:0] DrawXs2Prime,DrawYs2Prime
							 );
							 
							 
    
	 logic[9:0] Red_New, Green_New, Blue_New;
	
	    logic[63:0] XmultCos1, YmultSin1, XmultSin1, YmultCos1;
	 logic [15:0] DrawXs1,DrawYs1;
	 logic[31:0]TankY1e, TankX1e, DrawXe1, DrawYe1, sin1e, cos1e, Tank1Xsp, Tank1Ysp;
	 logic XMCsign1, YMCsign1, XMSsign1, YMSsign1;
    

	 always_comb
	 begin
            // sign extend ball cords    
			TankY1e[31:0] = {6'b0, BallY1, 16'b0};
			TankX1e[31:0] = {6'b0, BallX1, 16'b0};
            // sign extend draw cords
	      DrawXe1[31:0] = {6'b0, DrawX, 16'b0};
         DrawYe1[31:0] = {6'b0, DrawY, 16'b0};
            // sign extend cos sin
			cos1e[31:0] = {{12{cos1[7]}}, cos1[7:0], 12'h0};
			sin1e[31:0] = {{12{sin1[7]}}, sin1[7:0], 12'h0};

			Tank1Xsp[31:0] = DrawXe1 + ~TankX1e+1'b1;
			Tank1Ysp[31:0] = DrawYe1 + ~TankY1e+1'b1;
            
            XMCsign1 = Tank1Xsp[31]^cos1e[31];
            YMCsign1 = Tank1Ysp[31]^cos1e[31];
            XMSsign1 = Tank1Xsp[31]^sin1e[31];
            YMSsign1 = Tank1Ysp[31]^sin1e[31];

            XmultCos1[63] = XMCsign1; 
            XmultSin1[63] = XMSsign1;
				YmultCos1[63] = YMCsign1; 
            YmultSin1[63] = YMSsign1; 

				XmultCos1[62:0] = Tank1Xsp[30:0]*cos1e[30:0]; 
            XmultSin1[62:0] = Tank1Xsp[30:0]*sin1e[30:0];
				YmultCos1[62:0] = Tank1Ysp[30:0]*cos1e[30:0]; 
            YmultSin1[62:0] = Tank1Ysp[30:0]*sin1e[30:0]; 

            DrawXs1[15:0] = {{6{XMCsign1}}, XmultCos1[41:32]} + {{6{~YMCsign1}}, ~YmultSin1[41:32]}+1'b1 +BallX1;
            DrawYs1[15:0] = {{6{XMSsign1}}, XmultSin1[41:32]} + {{6{YMCsign1}}, YmultCos1[41:32]} + BallY1;
	 end
	

	title title_screen(.clock(Sys_CLK), .address(TitleADDR), .q(PalletI));
	red_tank blerim(.clock(Sys_CLK), .address(TankADDR), .q(PalletIR));
	t2ws     blerimw(.clock(Sys_CLK), .address(W2ADDR), .q(PalletIWS2));
	t1ws     saraw(.clock(Sys_CLK), .address(W1ADDR), .q(PalletIWS1));
	
	yellow_tank sara(.clock(Sys_CLK), .address(TankADDRY), .q(PalletIY));
	
	
	
	logic [23:0] Pallet[8];
	always_comb
	begin
	 Pallet[0] = 24'hFF3131;
	 Pallet[1] = 24'h312222;
	 Pallet[2] = 24'h878888;
	 Pallet[3] = 24'h9B9DAA;
	 Pallet[4] = 24'hFFEE00;
	 Pallet[5] = 24'hFF00D6;
	 Pallet[6] = 24'h000000;
	 Pallet[7] = 24'hFFFFFF;
	end
	
	logic [23:0] PalletW[8];
	always_comb
	begin
	 PalletW[0] = 24'hFF3131;
	 PalletW[1] = 24'h312222;
	 PalletW[2] = 24'h878888;
	 PalletW[3] = 24'h9B9DAA;
	 PalletW[4] = 24'hFFEE00;
	 PalletW[5] = 24'hFF00D6;
	 PalletW[6] = 24'h000000;
	 PalletW[7] = 24'hFFFFFF;
	end
	
    logic[63:0] XmultCos2, YmultSin2, XmultSin2, YmultCos2;
	 logic [15:0] DrawXs2,DrawYs2;
	 logic[19:0] TitleADDR;
	 logic[2:0] PalletI, PalletIR, PalletIY, PalletIWS2, PalletIWS1;
	 logic[8:0] TankADDR, TankADDRY;
	 
	 logic[13:0] W2ADDR, W1ADDR;

	 logic [9:0] TankXSp,TankYSp,TankXY,TankYY, W2XSp, W2YSp, W1XSp, W1YSp;


	 logic[31:0] TankY2e, TankX2e, DrawXe2, DrawYe2, sin2e, cos2e, Tank2Xsp, Tank2Ysp;
	 logic XMCsign2, YMCsign2, XMSsign2, YMSsign2;

    
	
	 always_comb
	 begin
			
			TankXSp[9:0] = DrawXs2[9:0] - BallX2[9:0] + Ball_size[9:0];
			TankYSp[9:0] = DrawYs2[9:0] - BallY2[9:0] + Ball_size[9:0];
			
			TankADDR = TankXSp[4:0] + TankYSp[4:0]*5'd20;
			
			TankXY[9:0] = DrawXs1[9:0] - BallX1[9:0] + Ball_size[9:0];
			TankYY[9:0] = DrawYs1[9:0] - BallY1[9:0] + Ball_size[9:0];
			
			TankADDRY = TankXY[4:0] + TankYY[4:0]*5'd20;
			
			TitleADDR = DrawX + DrawY*10'd640;
			
			W2XSp[9:0] = DrawX[9:0] - 10'd320 + 10'd160;
			W2YSp[9:0] = DrawY[9:0] - 10'd240 + 10'd90;
			
			W2ADDR = W2XSp[7:0] + W2YSp[7:0]*7'd160;
			
			W1XSp[9:0] = DrawX[9:0] - 10'd320 + 10'd160;
			W1YSp[9:0] = DrawY[9:0] - 10'd240 + 10'd90;
			
			W1ADDR = W1XSp[7:0] + W1YSp[7:0]*7'd160;
			
            // sign extend ball cords    
			TankY2e[31:0] = {6'b0, BallY2, 16'b0};
			TankX2e[31:0] = {6'b0, BallX2, 16'b0};
            // sign extend draw cords
	      DrawXe2[31:0] = {6'b0, DrawX, 16'b0};
         DrawYe2[31:0] = {6'b0, DrawY, 16'b0};
            // sign extend cos sin
			cos2e[31:0] = {{12{cos2[7]}}, cos2[7:0], 12'h0};
			sin2e[31:0] = {{12{sin2[7]}}, sin2[7:0], 12'h0};

			Tank2Xsp[31:0] = DrawXe2 + ~TankX2e+1'b1;
			Tank2Ysp[31:0] = DrawYe2 + ~TankY2e+1'b1;

            XMCsign2 = Tank2Xsp[31]^cos2e[31];
            YMCsign2 = Tank2Ysp[31]^cos2e[31];
            XMSsign2 = Tank2Xsp[31]^sin2e[31];
            YMSsign2 = Tank2Ysp[31]^sin2e[31];

            XmultCos2[63] = XMCsign2; 
            XmultSin2[63] = XMSsign2;
				YmultCos2[63] = YMCsign2; 
            YmultSin2[63] = YMSsign2; 

				XmultCos2[62:0] = Tank2Xsp[30:0]*cos2e[30:0]; 
            XmultSin2[62:0] = Tank2Xsp[30:0]*sin2e[30:0];
				YmultCos2[62:0] = Tank2Ysp[30:0]*cos2e[30:0]; 
            YmultSin2[62:0] = Tank2Ysp[30:0]*sin2e[30:0]; 

            DrawXs2[15:0] = {{6{XMCsign2}}, XmultCos2[41:32]} + {{6{~YMCsign2}}, ~YmultSin2[41:32]}+1'b1 +BallX2;
            DrawYs2[15:0] = {{6{XMSsign2}}, XmultSin2[41:32]} + {{6{YMCsign2}}, YmultCos2[41:32]} + BallY2;
				DrawXs2Prime = DrawXs2[9:0];
				DrawYs2Prime = DrawYs2[9:0];
	 end	

    


	 


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
			else if(t2wscreen)
			begin 
				if ((DrawX[9:0] >= 10'd320 - 10'd160) &&
				(DrawX[9:0] <= 10'd320 + 10'd160) &&
				(DrawY[9:0] >= 10'd240 - 10'd90) &&
				(DrawY[9:0] <= 10'd240 + 10'd90))
				begin
					Red_New = PalletW[PalletIWS2[2:0]][23:16];
					Green_New = PalletW[PalletIWS2[2:0]][15:8];
					Blue_New = PalletW[PalletIWS2[2:0]][7:0];
				end
				else
				begin
						Red_New = 8'hFF; 
						Green_New = 8'hFF;
						Blue_New = 8'hFF;
				end
			end
			else if(t1wscreen)
			begin 
				if ((DrawX[9:0] >= 10'd320 - 10'd160) &&
				(DrawX[9:0] <= 10'd320 + 10'd160) &&
				(DrawY[9:0] >= 10'd240 - 10'd90) &&
				(DrawY[9:0] <= 10'd240 + 10'd90))
				begin
					Red_New = PalletW[PalletIWS1[2:0]][23:16];
					Green_New = PalletW[PalletIWS1[2:0]][15:8];
					Blue_New = PalletW[PalletIWS1[2:0]][7:0];
				end
				else
				begin
						Red_New = 8'hFF; 
						Green_New = 8'hFF;
						Blue_New = 8'hFF;
				end
			end
			else if(maze)
			begin 
					Red_New = DrawX + DrawY;
					Green_New = DrawX;
					Blue_New = DrawY;
			end
	 

			else if ((DrawXs1[9:0]>= BallX1 - Ball_size) &&
				(DrawXs1[9:0] <= BallX1 + Ball_size) &&
				(DrawYs1[9:0] >= BallY1 - Ball_size) &&
				(DrawYs1[9:0] <= BallY1 + Ball_size) && !Tank1Shot)
            begin 
					if(PalletIY != 3'd5)
					begin
						Red_New = Pallet[PalletIY[2:0]][23:16];
						Green_New = Pallet[PalletIY[2:0]][15:8];
						Blue_New = Pallet[PalletIY[2:0]][7:0];
					end
					else
					begin
						Red_New = 8'hFF; 
						Green_New = 8'hFF;
						Blue_New = 8'hFF;
					end
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
						//Draws bullet3 from tank2
			else if((DrawX >= Bullet3X - Bullet3S) &&
				(DrawX <= Bullet3X + Bullet3S) &&
				(DrawY >= Bullet3Y - Bullet3S) &&
				(DrawY <= Bullet3Y + Bullet3S) && is_bullet3_active)
				begin 
					Red_New = 8'h00;
					Green_New = 8'h00;
					Blue_New = 8'h00;
				end 
			//Draws bullet7 from tank7
			else if((DrawX >= Bullet7X - Bullet7S) &&
				(DrawX <= Bullet7X + Bullet7S) &&
				(DrawY >= Bullet7Y - Bullet7S) &&
				(DrawY <= Bullet7Y + Bullet7S) && is_bullet7_active)
				begin 
					Red_New = 8'h00;
					Green_New = 8'h00;
					Blue_New = 8'h00;
				end 
			//Draws bullet8 from tank8
			else if((DrawX >= Bullet8X - Bullet8S) &&
				(DrawX <= Bullet8X + Bullet8S) &&
				(DrawY >= Bullet8Y - Bullet8S) &&
				(DrawY <= Bullet8Y + Bullet8S) && is_bullet8_active)
				begin 
					Red_New = 8'h00;
					Green_New = 8'h00;
					Blue_New = 8'h00;
				end 
													//Draws bullet7 from tank7
			else if((DrawX >= Bullet9X - Bullet9S) &&
				(DrawX <= Bullet9X + Bullet9S) &&
				(DrawY >= Bullet9Y - Bullet9S) &&
				(DrawY <= Bullet9Y + Bullet9S) && is_bullet9_active)
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
						Red_New = 8'hFF; 
						Green_New = 8'hFF;
						Blue_New = 8'hFF;
					end
				end 
			// The tank next to the score
			 else if ((DrawX[9:0] >= 10'd460 - Ball_size) &&
				(DrawX[9:0] <= 10'd460 + Ball_size) &&
				(DrawY[9:0] >= 10'd40 - Ball_size) &&
				(DrawY[9:0] <= 10'd40 + Ball_size - 1) && !Tank2Shot)
				begin
						Red_New = 8'hFF;
						Green_New = 8'h00;
						Blue_New = 8'h00;
				end
				
			 else if ((DrawX[9:0] >= 10'd180 - Ball_size) &&
				(DrawX[9:0] <= 10'd180 + Ball_size) &&
				(DrawY[9:0] >= 10'd40 - Ball_size) &&
				(DrawY[9:0] <= 10'd40 + Ball_size - 1) && !Tank2Shot)
				begin
						Red_New = 8'hFF;
						Green_New = 8'hFF;
						Blue_New = 8'h00;
				end 
        //Draws the background
			else 
			begin 
                Red_New = 8'hFF; 
                Green_New = 8'hFF;
                Blue_New = 8'hFF;
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
