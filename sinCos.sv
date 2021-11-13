module sinCos(input[5:0] AngleI,
              output[7:0] sin, cos);


    
    logic [7:0] AnglesCos[45];
    logic [7:0] AnglesSin[45];
	 
    always_comb
    begin

    AnglesCos[ 0 ] = 8'd 16 ;
    AnglesCos[ 1 ] = 8'd 16 ;
    AnglesCos[ 2 ] = 8'd 15 ;
    AnglesCos[ 3 ] = 8'd 15 ;
    AnglesCos[ 4 ] = 8'd 14 ;
    AnglesCos[ 5 ] = 8'd 12 ;
    AnglesCos[ 6 ] = 8'd 11 ;
    AnglesCos[ 7 ] = 8'd 9 ;
    AnglesCos[ 8 ] = 8'd 7 ;
    AnglesCos[ 9 ] = 8'd 5 ;
    AnglesCos[ 10 ] = 8'd 3 ;
    AnglesCos[ 11 ] = 8'd 1 ;
    AnglesCos[ 12 ] = 8'd 2 ;
    AnglesCos[ 13 ] = 8'd 4 ;
    AnglesCos[ 14 ] = 8'd 6 ;
    AnglesCos[ 15 ] = 8'd 8 ;
    AnglesCos[ 16 ] = 8'd 10 ;
    AnglesCos[ 17 ] = 8'd 12 ;
    AnglesCos[ 18 ] = 8'd 13 ;
    AnglesCos[ 19 ] = 8'd 14 ;
    AnglesCos[ 20 ] = 8'd 15 ;
    AnglesCos[ 21 ] = 8'd 16 ;
    AnglesCos[ 22 ] = 8'd 16 ;
    AnglesCos[ 23 ] = 8'd 16 ;
    AnglesCos[ 24 ] = 8'd 16 ;
    AnglesCos[ 25 ] = 8'd 15 ;
    AnglesCos[ 26 ] = 8'd 14 ;
    AnglesCos[ 27 ] = 8'd 13 ;
    AnglesCos[ 28 ] = 8'd 12 ;
    AnglesCos[ 29 ] = 8'd 10 ;
    AnglesCos[ 30 ] = 8'd 8 ;
    AnglesCos[ 31 ] = 8'd 6 ;
    AnglesCos[ 32 ] = 8'd 4 ;
    AnglesCos[ 33 ] = 8'd 2 ;
    AnglesCos[ 34 ] = 8'd 1 ;
    AnglesCos[ 35 ] = 8'd 3 ;
    AnglesCos[ 36 ] = 8'd 5 ;
    AnglesCos[ 37 ] = 8'd 7 ;
    AnglesCos[ 38 ] = 8'd 9 ;
    AnglesCos[ 39 ] = 8'd 11 ;
    AnglesCos[ 40 ] = 8'd 12 ;
    AnglesCos[ 41 ] = 8'd 14 ;
    AnglesCos[ 42 ] = 8'd 15 ;
    AnglesCos[ 43 ] = 8'd 15 ;
    AnglesCos[ 44 ] = 8'd 16 ;

    AnglesSin[ 0 ] = 8'd 0 ;
    AnglesSin[ 1 ] = 8'd 2 ;
    AnglesSin[ 2 ] = 8'd 4 ;
    AnglesSin[ 3 ] = 8'd 7 ;
    AnglesSin[ 4 ] = 8'd 8 ;
    AnglesSin[ 5 ] = 8'd 10 ;
    AnglesSin[ 6 ] = 8'd 12 ;
    AnglesSin[ 7 ] = 8'd 13 ;
    AnglesSin[ 8 ] = 8'd 14 ;
    AnglesSin[ 9 ] = 8'd 15 ;
    AnglesSin[ 10 ] = 8'd 16 ;
    AnglesSin[ 11 ] = 8'd 16 ;
    AnglesSin[ 12 ] = 8'd 16 ;
    AnglesSin[ 13 ] = 8'd 16 ;
    AnglesSin[ 14 ] = 8'd 15 ;
    AnglesSin[ 15 ] = 8'd 14 ;
    AnglesSin[ 16 ] = 8'd 13 ;
    AnglesSin[ 17 ] = 8'd 11 ;
    AnglesSin[ 18 ] = 8'd 9 ;
    AnglesSin[ 19 ] = 8'd 8 ;
    AnglesSin[ 20 ] = 8'd 5 ;
    AnglesSin[ 21 ] = 8'd 3 ;
    AnglesSin[ 22 ] = 8'd 1 ;
    AnglesSin[ 23 ] = 8'd 1 ;
    AnglesSin[ 24 ] = 8'd 3 ;
    AnglesSin[ 25 ] = 8'd 5 ;
    AnglesSin[ 26 ] = 8'd 8 ;
    AnglesSin[ 27 ] = 8'd 9 ;
    AnglesSin[ 28 ] = 8'd 11 ;
    AnglesSin[ 29 ] = 8'd 13 ;
    AnglesSin[ 30 ] = 8'd 14 ;
    AnglesSin[ 31 ] = 8'd 15 ;
    AnglesSin[ 32 ] = 8'd 16 ;
    AnglesSin[ 33 ] = 8'd 16 ;
    AnglesSin[ 34 ] = 8'd 16 ;
    AnglesSin[ 35 ] = 8'd 16 ;
    AnglesSin[ 36 ] = 8'd 15 ;
    AnglesSin[ 37 ] = 8'd 14 ;
    AnglesSin[ 38 ] = 8'd 13 ;
    AnglesSin[ 39 ] = 8'd 12 ;
    AnglesSin[ 40 ] = 8'd 10 ;
    AnglesSin[ 41 ] = 8'd 8 ;
    AnglesSin[ 42 ] = 8'd 7 ;
    AnglesSin[ 43 ] = 8'd 4 ;
    AnglesSin[ 44 ] = 8'd 2 ;

    

	end


endmodule
