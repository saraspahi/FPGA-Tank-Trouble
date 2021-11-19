//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module color_mapper ( input        [9:0] BallX1, BallY1, DrawX, DrawY, Ball_size,BallX2,BallY2,
                      input [7:0] sin2, cos2,
							 input blank,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball1_on;
	logic ball2_on;
	 
//  Old Ball: Generated square box by checking if the current pixel is within a square of length
//    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 


//     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
//     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
//     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
//	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
//    int DistX, DistY, Size;
//	 assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
	
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

            DrawXs2[15:0] = {XMCsign, XmultCos[45:31]} + {~YMCsign, ~YmultSin[45:31]}+1'b1;
            DrawYs2[15:0] = {XMSsign, XmultSin[45:31]} + {YMCsign, YmultCos[45:31]};
	 end
	 
    always_comb
    begin:Ball_on_proc
        if ((DrawX >= BallX1 - Ball_size) &&
				(DrawX <= BallX1 + Ball_size) &&
				(DrawY >= BallY1 - Ball_size) &&
				(DrawY <= BallY1 + Ball_size))
				begin
            ball1_on = 1'b1;
				ball2_on = 1'b0;
				end
        else if ((DrawXs2[9:0] >= BallX2 - Ball_size) &&
				(DrawXs2[9:0] <= BallX2 + Ball_size) &&
				(DrawYs2[9:0] >= BallY2 - Ball_size ) &&
				(DrawYs2[9:0] <= BallY2 + Ball_size))
				begin
                ball1_on = 1'b0;
					 ball2_on = 1'b1;
				end
			else 
			begin 
			   ball1_on = 1'b0;
				ball2_on = 1'b0;
			end 
     end 
       
    always_comb
    begin:RGB_Display
        if(blank)
        begin
            if (ball1_on == 1'b1)
            begin 
                Red = 8'hff;
                Green = 8'hbb;
                Blue = 8'h00;
            end       
            else if (ball2_on == 1'b1)
            begin 
                Red = 8'hff;
                Green = 8'h00;
                Blue = 8'h00;
            end 
            else 
            begin 
                Red = 8'h55; 
                Green = 8'h55;
                Blue = 8'h55;
            end 
        end
        else
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
    end 
    
endmodule
