module angleMux(  input [5:0] Angle,
					input [7:0] sin,cos,
					output [7:0] newSin, newCos);
						
//Mux that takes care of the negative sines and cosines in different quadrants
always_comb
begin
   
   if(Angle<23 && Angle>11)
	begin
       newCos[7:0] = ~cos[7:0]+1'b1;
		 newSin = sin[7:0];
	end
   else if(Angle>22 && Angle<34)
   begin
       newCos[7:0] = ~cos[7:0]+1'b1;
       newSin[7:0] = ~sin[7:0]+1'b1;
   end
   else if(Angle>33)
   begin
       newCos[7:0] = cos[7:0];
       newSin[7:0] = ~sin[7:0]+1'b1;
   end
   else
   begin
       newCos[7:0] = cos[7:0];
       newSin[7:0] = sin[7:0];
   end
end




endmodule 
