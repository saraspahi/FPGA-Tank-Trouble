module collisionWall(input[9:0] objectX,objectY,objectS,DrawX,DrawY,
							output isWallBottom,isWallTop,isWallRight,isWallLeft);
always_comb 
begin
	if((objectY+objectS)>=10'd470)
	begin
		isWallBottom=1'b1;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	end 
	else if((objectY-objectS)<=20)
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b1;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	
	end 
	else if ((objectX-objectS)<=20)
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b1;
	
	
	end 
	else if ((objectX+objectS)>=10'd635)
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b1;
		isWallLeft=1'b0;
	end 
	else 
	begin 
		isWallBottom=0;
		isWallTop=0;
		isWallRight=0;
		isWallLeft=0;
		
	end 

end 
																
endmodule