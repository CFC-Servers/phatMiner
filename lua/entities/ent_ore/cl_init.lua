include( "shared.lua" )


function ENT:Draw()

	self:DrawModel()

	--[[local mins, maxs = self:GetModelBounds() --gross
	local pos = self:GetPos() + Vector( 0, 0, maxs.z + 15 )
	local col = self:GetColor()
	
	local loc_ang = LocalPlayer():EyeAngles()
	loc_ang:RotateAroundAxis( loc_ang:Forward(), 90 )
	loc_ang:RotateAroundAxis( loc_ang:Right(), 90 )
	
	col.a = 255
	
	cam.Start3D2D( pos, Angle(0, loc_ang.y, 90), 0.33 )
		--draw.RoundedBox( 4, 0, 0, 127.5, 20, Color( 0, 0, 0, 100 ) )
		--draw.RoundedBox( 4, 1, 1, self:Health()/2, 18, col )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, 127.5, 16 )
		surface.SetDrawColor( col )
		surface.DrawRect( 1, 1, self:Health()/2-2, 14, col )
		draw.DrawText( "Ore", "BudgetLabel", 25, 0, Color(255,255,255), TEXT_ALIGN_LEFT )
	cam.End3D2D()]]

end