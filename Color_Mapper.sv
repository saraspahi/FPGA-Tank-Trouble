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


module  color_mapper ( input        [9:0] BallX1, BallY1, DrawX, DrawY, Ball_size,BallX2,BallY2,
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
        else 
        if ((DrawX >= BallX2 - Ball_size) &&
				(DrawX <= BallX2 + Ball_size) &&
				(DrawY >= BallY2 - Ball_size) &&
				(DrawY <= BallY2 + Ball_size))
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
        if ((ball1_on || ball2_on) == 1'b1)
        begin 
            Red = 8'hff;
            Green = 8'h55;
            Blue = 8'h00;
        end       
        else 
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h7f - DrawX[9:3];
        end      
    end 
    
endmodule
