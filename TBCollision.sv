//Input all 12 bullets and the position of the tank 


module TBCollision(input [9:0] Tank_X_Pos,Tank_Y_Pos,Tank_Size,Bullet1_X_Pos,Bullet1_Y_Pos,isBullet1Active,
                     output TBCollided);
always_comb
begin 
if((Bullet1_X_Pos<=Tank_X_Pos+ Tank_Size)&&(Bullet1_X_Pos>=Tank_X_Pos - Tank_Size)&&
	(Bullet1_Y_Pos<=Tank_Y_Pos+ Tank_Size)&&(Bullet1_Y_Pos>=Tank_Y_Pos- Tank_Size)&&isBullet1Active)
begin 
	TBCollided = 1'b1;

end 

else TBCollided = 1'b0;


end 
endmodule 