module collisionWall(input[9:0] objectX,objectY,objectS,X_Motion,Y_Motion,DrawX,DrawY, 
							input currentMaze,MazeUp,MazeDown,MazeLeft,MazeRight, //Checks the current pixel and up down right left
							output isWallBottom,isWallTop,isWallRight,isWallLeft);

logic objectOn,UpLeft,DownRight,UpRight,DownLeft,Wall_On;	
					
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
objectOn=1'b0;
end 

always_comb 
begin 
if(objectOn && currentMaze)
begin 
Wall_On = objectOn && currentMaze;
end
end

//always_ff(Reset )
//begin 
//
//
//end 
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
	if((objectY+objectS)>=10'd479)
	begin
		isWallBottom=1'b1;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	end 
	else if((objectY-objectS)<=0)
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b1;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	
	end 
	else if ((objectX-objectS)<=0)
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b1;
	end 
	else if ((objectX+objectS)>=10'd639)
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b1;
		isWallLeft=1'b0;
	end 
	else if (currentMaze )// objectOn&& UpLeft && (MazeUp || MazeDown)
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b0;
		end
//	else if (objectOn && currentMaze && UpLeft && (MazeLeft || MazeRight))
//	begin 
//		isWallBottom=1'b0;
//		isWallTop=1'b1;
//		isWallRight=1'b0;
//		isWallLeft=1'b0;
//	end 
//	else if (objectOn && currentMaze && UpRight && (MazeUp || MazeDown))
//	begin 
//		isWallBottom=1'b0;
//		isWallTop=1'b0;
//		isWallRight=1'b1;
//		isWallLeft=1'b0;
//		end
//	else if (objectOn && currentMaze && UpRight && (MazeLeft || MazeRight))
//	begin 
//		isWallBottom=1'b0;
//		isWallTop=1'b1;
//		isWallRight=1'b0;
//		isWallLeft=1'b0;
//	end 
//		else if (objectOn && currentMaze && DownLeft && (MazeUp || MazeDown))
//	begin 
//		isWallBottom=1'b0;
//		isWallTop=1'b0;
//		isWallRight=1'b0;
//		isWallLeft=1'b1;
//	end
//	else if (objectOn && currentMaze && DownLeft && (MazeLeft || MazeRight))
//	begin 
//		isWallBottom=1'b1;
//		isWallTop=1'b0;
//		isWallRight=1'b0;
//		isWallLeft=1'b0;
//	end 
//	else if (objectOn && currentMaze && DownRight && (MazeUp || MazeDown))
//	begin 
//		isWallBottom=1'b0;
//		isWallTop=1'b0;
//		isWallRight=1'b1;
//		isWallLeft=1'b0;
//	end
//	else if (objectOn && currentMaze && DownRight && (MazeLeft || MazeRight))
//	begin 
//		isWallBottom=1'b1;
//		isWallTop=1'b0;
//		isWallRight=1'b0;
//		isWallLeft=1'b0;
//	end 
	else 
	begin 
		isWallBottom=1'b0;
		isWallTop=1'b0;
		isWallRight=1'b0;
		isWallLeft=1'b0;
	end

end 
																
endmodule