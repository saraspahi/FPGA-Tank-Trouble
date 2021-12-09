module collisionWall(input[9:0] objectX,objectY,objectS,X_Motion,Y_Motion,DrawX,DrawY, 
							input frame_clk,Reset, pixel_clk,hit,
							input currentMazePrime,MazeUpPrime,MazeDownPrime,MazeLeftPrime,MazeRightPrime, //Checks the current pixel and up down right left
							output isWallBottom,isWallTop,isWallRight,isWallLeft);

logic objectOn,UpLeft,DownRight,UpRight,DownLeft,Wall_On,currentMaze,MazeUp,MazeDown,MazeLeft,MazeRight;	
logic currentMaze1,MazeUp1,MazeDown1,MazeLeft1,MazeRight1,currentMaze2,MazeUp2,MazeDown2,MazeLeft2,MazeRight2;
					
always_comb
begin 
if((DrawX >= objectX - objectS) &&
				(DrawX <= objectX + objectS) &&
				(DrawY >= objectY - objectS) &&
				(DrawY <= objectY + objectS))
begin
objectOn=1'b1;
end
else 
begin
objectOn=1'b0;
end 
end

always_comb 
begin 
if(objectOn && currentMazePrime)

Wall_On = 1;
else 
Wall_On = 0;

end


always_ff @(posedge Reset or posedge pixel_clk )
begin 
if(Reset )
begin 
	currentMaze1=0;
	MazeUp1=0;
	MazeDown1=0;
	MazeLeft1=0;
	MazeRight1=0;

end 
else if ((DrawX==0) && (DrawY==0))  
begin 

	currentMaze1=0;
	MazeUp1=0;
	MazeDown1=0;
	MazeLeft1=0;
	MazeRight1=0;
end
else 
begin
if(Wall_On)
begin 
	currentMaze1=Wall_On;
	MazeUp1=MazeUpPrime;
	MazeDown1=MazeDownPrime;
	MazeLeft1=MazeLeftPrime;
	MazeRight1=MazeRightPrime;

end
else 
begin 
	currentMaze1=currentMaze1;
	MazeUp1=MazeUp1;
	MazeDown1=MazeDown1;
	MazeLeft1=MazeLeft1;
	MazeRight1=MazeRight1;
end

end
end 


always_ff @(posedge Reset or negedge frame_clk)
begin 
if(Reset)
begin 

	currentMaze2=0;
	MazeUp2=0;
	MazeDown2=0;
	MazeLeft2=0;
	MazeRight2=0;

end
else if ((DrawX==0) && (DrawY==0))  //Does this set everythin to 0
begin 

	currentMaze2=0;
	MazeUp2=0;
	MazeDown2=0;
	MazeLeft2=0;
	MazeRight2=0;
end
else 
begin 
	currentMaze2=currentMaze1;
	MazeUp2=MazeUp1;
	MazeDown2=MazeDown1;
	MazeLeft2=MazeLeft1;
	MazeRight2=MazeRight1;
end 

end 

assign currentMaze = currentMaze2;
assign MazeUp = MazeUp2;
assign MazeDown = MazeDown2;
assign MazeLeft = MazeLeft2;
assign MazeRight = MazeRight2; 


always_comb
begin 
if(X_Motion[9]==1'b1 && Y_Motion[9]==1'b1)
begin 
	UpLeft = 1'b1;
	DownRight = 1'b0;
	UpRight = 1'b0;
	DownLeft=1'b0;
	
end
else if (X_Motion[9]==1'b0 && Y_Motion[9]==1'b0)
begin
	UpLeft = 1'b0;
	DownRight = 1'b1;
	UpRight = 1'b0;
	DownLeft=1'b0;
end
else if (X_Motion[9]==1'b0 && Y_Motion[9]==1'b1)
begin
	UpLeft = 1'b0;
	DownRight = 1'b0;
	UpRight = 1'b1;
	DownLeft=1'b0;
end
else 
	UpLeft = 1'b0;
	DownRight = 1'b0;
	UpRight = 1'b0;
	DownLeft = 1'b1;
end 



always_comb 
begin
	if((objectY+objectS)>=10'd475)
	begin
		isWallBottom=1'b1;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	end 
	else if((objectY-objectS)<=4)
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b1;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	
	end 
	else if ((objectX-objectS)<=4)
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
	else if (currentMaze && UpLeft && (MazeUp || MazeDown) ) 
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b1;
		isWallRight=1'b0;
		isWallLeft=1'b0;
		end
	else if ( currentMaze && UpLeft && (MazeLeft || MazeRight))
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b1;
	end 
	else if ( currentMaze && UpRight && (MazeUp || MazeDown))
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b1;
		isWallRight=1'b0;
		isWallLeft=1'b0;
		end
	else if ( currentMaze && UpRight && (MazeLeft || MazeRight))
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b1;
		isWallLeft=1'b0;
	end 
		else if ( currentMaze && DownLeft && (MazeUp || MazeDown))
	begin 
		isWallBottom=1'b1;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	end
	else if ( currentMaze && DownLeft && (MazeLeft || MazeRight))
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b1;
	end 
	else if ( currentMaze && DownRight && (MazeUp || MazeDown))
	begin 
		isWallBottom=1'b1;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	end
	else if ( currentMaze && DownRight && (MazeLeft || MazeRight))
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b1;
		isWallLeft=1'b0;
	end 
	else 
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	end

end 
																
endmodule