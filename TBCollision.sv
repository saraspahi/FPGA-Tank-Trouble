//Input all 6 bullets and the position of the tank 


module TBCollision(input [9:0] Tank_X_Pos,Tank_Y_Pos,Tank_Size,Bullet1_X_Pos,Bullet1_Y_Pos,isBullet1Active,
						 input [9:0] Bullet2_X_Pos,Bullet2_Y_Pos,isBullet2Active,
						 input [9:0] Bullet3_X_Pos,Bullet3_Y_Pos,isBullet3Active,
						 input [9:0] Bullet7_X_Pos,Bullet7_Y_Pos,isBullet7Active,
						 input [9:0] Bullet8_X_Pos,Bullet8_Y_Pos,isBullet8Active,
						 input [9:0] Bullet9_X_Pos,Bullet9_Y_Pos,isBullet9Active,
						 
                   output TBCollided);
always_comb
begin 
if(((Bullet1_X_Pos<=Tank_X_Pos+ Tank_Size)&&(Bullet1_X_Pos>=Tank_X_Pos - Tank_Size)&&
	(Bullet1_Y_Pos<=Tank_Y_Pos+ Tank_Size)&&(Bullet1_Y_Pos>=Tank_Y_Pos- Tank_Size)&&isBullet1Active)
	|| ((Bullet2_X_Pos<=Tank_X_Pos+ Tank_Size)&&(Bullet2_X_Pos>=Tank_X_Pos - Tank_Size)&&
	(Bullet2_Y_Pos<=Tank_Y_Pos+ Tank_Size)&&(Bullet2_Y_Pos>=Tank_Y_Pos- Tank_Size)&&isBullet2Active)
	|| ((Bullet3_X_Pos<=Tank_X_Pos+ Tank_Size)&&(Bullet3_X_Pos>=Tank_X_Pos - Tank_Size)&&
	(Bullet3_Y_Pos<=Tank_Y_Pos+ Tank_Size)&&(Bullet3_Y_Pos>=Tank_Y_Pos- Tank_Size)&&isBullet3Active)
	|| ((Bullet7_X_Pos<=Tank_X_Pos+ Tank_Size)&&(Bullet7_X_Pos>=Tank_X_Pos - Tank_Size)&&
	(Bullet7_Y_Pos<=Tank_Y_Pos+ Tank_Size)&&(Bullet7_Y_Pos>=Tank_Y_Pos- Tank_Size)&&isBullet7Active)
	|| ((Bullet8_X_Pos<=Tank_X_Pos+ Tank_Size)&&(Bullet8_X_Pos>=Tank_X_Pos - Tank_Size)&&
	(Bullet8_Y_Pos<=Tank_Y_Pos+ Tank_Size)&&(Bullet8_Y_Pos>=Tank_Y_Pos- Tank_Size)&&isBullet8Active)
	|| ((Bullet9_X_Pos<=Tank_X_Pos+ Tank_Size)&&(Bullet9_X_Pos>=Tank_X_Pos - Tank_Size)&&
	(Bullet9_Y_Pos<=Tank_Y_Pos+ Tank_Size)&&(Bullet9_Y_Pos>=Tank_Y_Pos- Tank_Size)&&isBullet9Active))
begin 
	TBCollided = 1'b1;

end 

else TBCollided = 1'b0;


end 
endmodule 