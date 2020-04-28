include( "shared.lua" )


function ENT:Draw()

	self:DrawModel()

	--[[local new_pos = self:GetPos()
	
	local mins, maxs = self:GetModelBounds()
	local pos = new_pos + Vector( 0, 0, maxs.z + 10 )
	local col = self:GetColor()
	
	
	local loc_ang = LocalPlayer():EyeAngles()
	loc_ang:RotateAroundAxis( loc_ang:Forward(), 90 )
	loc_ang:RotateAroundAxis( loc_ang:Right(), 90 )

	
	cam.Start3D2D( pos, Angle(0, loc_ang.y, 90), 0.2 )
		draw.DrawText( self:GetNWString("ore_name") or "Unknown", "phatlabel", 0, 0, col, TEXT_ALIGN_CENTER )
	cam.End3D2D()]]

end