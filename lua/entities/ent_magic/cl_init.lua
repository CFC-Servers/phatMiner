include( "shared.lua" )


local sprite_pos = Vector( 0, 0, 0 )
local sprite_material = Material( "sprites/strider_blackball" )
local sprite_color = Color( 255, 255, 255, 255 )

function ENT:Draw()

	self:DrawModel()
	

	local mins, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector( 0, 0, maxs.z + 15 )
	local col = self:GetColor()
	
	local loc_ang = LocalPlayer():EyeAngles()
	loc_ang:RotateAroundAxis( loc_ang:Forward(), 90 )
	loc_ang:RotateAroundAxis( loc_ang:Right(), 90 )
	
	col.a = 255
	
	cam.Start3D2D( pos, Angle(0, loc_ang.y, 90), 3 )
		--draw.DrawText( "Magic", "TargetID", 0, 0, col, TEXT_ALIGN_CENTER )
	cam.End3D2D()
	
	cam.Start3D()
		--render.SetMaterial( sprite_material )
		--render.DrawSprite( self:GetPos(), 16, 16, sprite_color )
	cam.End3D()

end