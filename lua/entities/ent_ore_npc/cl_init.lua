include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()

	local mins, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector( 0, 0, maxs.z )
	
	
	local loc_ang = LocalPlayer():EyeAngles()
	loc_ang:RotateAroundAxis( loc_ang:Forward(), 90 )
	loc_ang:RotateAroundAxis( loc_ang:Right(), 90 )
	
	cam.Start3D2D( pos, Angle(0, loc_ang.y, 90), 0.2 )
		draw.DrawText( "Ore Exchange", "TargetID", 0, 0, Color(225, 225, 0), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end