module sinCos(input[5:0] AngleI,
              output[15:0] sin, cos);


    
    logic [7:0] AnglesCos[45];
    logic [7:0] AnglesSin[45];
	 
	 always_comb
	 begin

    AnglesSin[ 0 ] = 8'd 0 ;
    AnglesSin[ 1 ] = 8'd 36 ;
    AnglesSin[ 2 ] = 8'd 71 ;
    AnglesSin[ 3 ] = 8'd 104 ;
    AnglesSin[ 4 ] = 8'd 136 ;
    AnglesSin[ 5 ] = 8'd 165 ;
    AnglesSin[ 6 ] = 8'd 190 ;
    AnglesSin[ 7 ] = 8'd 212 ;
    AnglesSin[ 8 ] = 8'd 230 ;
    AnglesSin[ 9 ] = 8'd 243 ;
    AnglesSin[ 10 ] = 8'd 252 ;
    AnglesSin[ 11 ] = 8'd 256 ;
    AnglesSin[ 12 ] = 8'd 255 ;
    AnglesSin[ 13 ] = 8'd 248 ;
    AnglesSin[ 14 ] = 8'd 237 ;
    AnglesSin[ 15 ] = 8'd 222 ;
    AnglesSin[ 16 ] = 8'd 202 ;
    AnglesSin[ 17 ] = 8'd 178 ;
    AnglesSin[ 18 ] = 8'd 150 ;
    AnglesSin[ 19 ] = 8'd 120 ;
    AnglesSin[ 20 ] = 8'd 88 ;
    AnglesSin[ 21 ] = 8'd 53 ;
    AnglesSin[ 22 ] = 8'd 18 ;
    AnglesSin[ 23 ] = 8'd 18 ;
    AnglesSin[ 24 ] = 8'd 53 ;
    AnglesSin[ 25 ] = 8'd 88 ;
    AnglesSin[ 26 ] = 8'd 120 ;
    AnglesSin[ 27 ] = 8'd 150 ;
    AnglesSin[ 28 ] = 8'd 178 ;
    AnglesSin[ 29 ] = 8'd 202 ;
    AnglesSin[ 30 ] = 8'd 222 ;
    AnglesSin[ 31 ] = 8'd 237 ;
    AnglesSin[ 32 ] = 8'd 248 ;
    AnglesSin[ 33 ] = 8'd 255 ;
    AnglesSin[ 34 ] = 8'd 256 ;
    AnglesSin[ 35 ] = 8'd 252 ;
    AnglesSin[ 36 ] = 8'd 243 ;
    AnglesSin[ 37 ] = 8'd 230 ;
    AnglesSin[ 38 ] = 8'd 212 ;
    AnglesSin[ 39 ] = 8'd 190 ;
    AnglesSin[ 40 ] = 8'd 165 ;
    AnglesSin[ 41 ] = 8'd 136 ;
    AnglesSin[ 42 ] = 8'd 104 ;
    AnglesSin[ 43 ] = 8'd 71 ;
    AnglesSin[ 44 ] = 8'd 36 ;

    AnglesCos[ 0 ] = 8'd 256 ;
    AnglesCos[ 1 ] = 8'd 254 ;
    AnglesCos[ 2 ] = 8'd 246 ;
    AnglesCos[ 3 ] = 8'd 234 ;
    AnglesCos[ 4 ] = 8'd 217 ;
    AnglesCos[ 5 ] = 8'd 196 ;
    AnglesCos[ 6 ] = 8'd 171 ;
    AnglesCos[ 7 ] = 8'd 143 ;
    AnglesCos[ 8 ] = 8'd 112 ;
    AnglesCos[ 9 ] = 8'd 79 ;
    AnglesCos[ 10 ] = 8'd 44 ;
    AnglesCos[ 11 ] = 8'd 9 ;
    AnglesCos[ 12 ] = 8'd 27 ;
    AnglesCos[ 13 ] = 8'd 62 ;
    AnglesCos[ 14 ] = 8'd 96 ;
    AnglesCos[ 15 ] = 8'd 128 ;
    AnglesCos[ 16 ] = 8'd 158 ;
    AnglesCos[ 17 ] = 8'd 184 ;
    AnglesCos[ 18 ] = 8'd 207 ;
    AnglesCos[ 19 ] = 8'd 226 ;
    AnglesCos[ 20 ] = 8'd 241 ;
    AnglesCos[ 21 ] = 8'd 250 ;
    AnglesCos[ 22 ] = 8'd 255 ;
    AnglesCos[ 23 ] = 8'd 255 ;
    AnglesCos[ 24 ] = 8'd 250 ;
    AnglesCos[ 25 ] = 8'd 241 ;
    AnglesCos[ 26 ] = 8'd 226 ;
    AnglesCos[ 27 ] = 8'd 207 ;
    AnglesCos[ 28 ] = 8'd 184 ;
    AnglesCos[ 29 ] = 8'd 158 ;
    AnglesCos[ 30 ] = 8'd 128 ;
    AnglesCos[ 31 ] = 8'd 96 ;
    AnglesCos[ 32 ] = 8'd 62 ;
    AnglesCos[ 33 ] = 8'd 27 ;
    AnglesCos[ 34 ] = 8'd 9 ;
    AnglesCos[ 35 ] = 8'd 44 ;
    AnglesCos[ 36 ] = 8'd 79 ;
    AnglesCos[ 37 ] = 8'd 112 ;
    AnglesCos[ 38 ] = 8'd 143 ;
    AnglesCos[ 39 ] = 8'd 171 ;
    AnglesCos[ 40 ] = 8'd 196 ;
    AnglesCos[ 41 ] = 8'd 217 ;
    AnglesCos[ 42 ] = 8'd 234 ;
    AnglesCos[ 43 ] = 8'd 246 ;
    AnglesCos[ 44 ] = 8'd 254 ;
    

end
  assign cos = {7'b0, AnglesCos[AngleI][7:0]};
  assign sin = {7'b0, AnglesSin[AngleI][7:0]};
endmodule
