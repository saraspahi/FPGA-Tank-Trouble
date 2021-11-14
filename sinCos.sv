module sinCos(input[5:0] AngleI,
              output[7:0] sin, cos);


    
    logic [7:0] AnglesCos[45];
    logic [7:0] AnglesSin[45];
	 
    always_comb
    begin
    
    AnglesSin[0] = 8'b0000_0000;  
    AnglesSin[1] = 8'b0000_0010 ;                                                                                                                                                                           
    AnglesSin[2] = 8'b0000_0100 ;                                                                                                                                                                           
    AnglesSin[3] = 8'b0000_0111 ;
    AnglesSin[4] = 8'b0000_1000 ;
    AnglesSin[5] = 8'b0000_1010 ;
    AnglesSin[6] = 8'b0000_1100 ;
    AnglesSin[7] = 8'b0000_1101 ;
    AnglesSin[8] = 8'b0000_1110 ;
    AnglesSin[9] = 8'b0000_1111 ;
    AnglesSin[10] = 8'b0001_0000 ;
    AnglesSin[11] = 8'b0001_0000 ;
    AnglesSin[12] = 8'b0001_0000 ;
    AnglesSin[13] = 8'b0001_0000 ;
    AnglesSin[14] = 8'b0000_1111 ;
    AnglesSin[15] = 8'b0000_1110 ;
    AnglesSin[16] = 8'b0000_1101 ;
    AnglesSin[17] = 8'b0000_1011 ;
    AnglesSin[18] = 8'b0000_1001 ;
    AnglesSin[19] = 8'b0000_1000 ;
    AnglesSin[20] = 8'b0000_0101 ;
    AnglesSin[21] = 8'b0000_0011 ;
    AnglesSin[22] = 8'b0000_0001 ;
    AnglesSin[23] = 8'b0000_0001 ;
    AnglesSin[24] = 8'b0000_0011 ;
    AnglesSin[25] = 8'b0000_0101 ;
    AnglesSin[26] = 8'b0000_1000 ;
    AnglesSin[27] = 8'b0000_1001 ;
    AnglesSin[28] = 8'b0000_1011 ;
    AnglesSin[29] = 8'b0000_1101 ;
    AnglesSin[30] = 8'b0000_1110 ;
    AnglesSin[31] = 8'b0000_1111 ;
    AnglesSin[32] = 8'b0001_0000 ;
    AnglesSin[33] = 8'b0001_0000 ;
    AnglesSin[34] = 8'b0001_0000 ;
    AnglesSin[35] = 8'b0001_0000 ;
    AnglesSin[36] = 8'b0000_1111 ;
    AnglesSin[37] = 8'b0000_1110 ;
    AnglesSin[38] = 8'b0000_1101 ;
    AnglesSin[39] = 8'b0000_1100 ;
    AnglesSin[40] = 8'b0000_1010 ;
    AnglesSin[41] = 8'b0000_1000 ;
    AnglesSin[42] = 8'b0000_0111 ;
    AnglesSin[43] = 8'b0000_0100 ;
    AnglesSin[44] = 8'b0000_0010 ;

    AnglesCos[0] = 8'b0001_0000;
    AnglesCos[1] = 8'b0001_0000;
    AnglesCos[2] = 8'b0000_1111;
    AnglesCos[3] = 8'b0000_1111;
    AnglesCos[4] = 8'b0000_1110;
    AnglesCos[5] = 8'b0000_1100;
    AnglesCos[6] = 8'b0000_1011;
    AnglesCos[7] = 8'b0000_1001;
    AnglesCos[8] = 8'b0000_0111;
    AnglesCos[9] = 8'b0000_0101;
    AnglesCos[10] = 8'b0000_0011;
    AnglesCos[11] = 8'b0000_0001;
    AnglesCos[12] = 8'b0000_0010;
    AnglesCos[13] = 8'b0000_0100;
    AnglesCos[14] = 8'b0000_0110;
    AnglesCos[15] = 8'b0000_1000;
    AnglesCos[16] = 8'b0000_1010;
    AnglesCos[17] = 8'b0000_1100;
    AnglesCos[18] = 8'b0000_1101;
    AnglesCos[19] = 8'b0000_1110;
    AnglesCos[20] = 8'b0000_1111;
    AnglesCos[21] = 8'b0001_0000;
    AnglesCos[22] = 8'b0001_0000;
    AnglesCos[23] = 8'b0001_0000;
    AnglesCos[24] = 8'b0001_0000;
    AnglesCos[25] = 8'b0000_1111;
    AnglesCos[26] = 8'b0000_1110;
    AnglesCos[27] = 8'b0000_1101;
    AnglesCos[28] = 8'b0000_1100;
    AnglesCos[29] = 8'b0000_1010;
    AnglesCos[30] = 8'b0000_1000;
    AnglesCos[31] = 8'b0000_0110;
    AnglesCos[32] = 8'b0000_0100;
    AnglesCos[33] = 8'b0000_0010;
    AnglesCos[34] = 8'b0000_0001;
    AnglesCos[35] = 8'b0000_0011;
    AnglesCos[36] = 8'b0000_0101;
    AnglesCos[37] = 8'b0000_0111;
    AnglesCos[38] = 8'b0000_1001;
    AnglesCos[39] = 8'b0000_1011;
    AnglesCos[40] = 8'b0000_1100;
    AnglesCos[41] = 8'b0000_1110;
    AnglesCos[42] = 8'b0000_1111;
    AnglesCos[43] = 8'b0000_1111;
    AnglesCos[44] = 8'b0001_0000;
	 end

	
	assign sin = AnglesSin[AngleI][7:0];
	assign cos = AnglesCos[AngleI][7:0];

endmodule
