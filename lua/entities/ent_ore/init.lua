AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )


local rock_models = {
	[1] = "models/props_wasteland/rockcliff01f.mdl",
	[2] = "models/props_wasteland/rockcliff01j.mdl",
	[3] = "models/props_wasteland/rockcliff01k.mdl",
}

local rock_locations = {
	["gm_construct"] = {
		[1] = Vector(0, 0, -100),
		[2] = Vector(0, 250, -100),
		[3] = Vector(0, 500, -100),
		[4] = Vector(0, 750, -100),
		[5] = Vector(0, 1000, -100),
	}
}

local npc_locations = {
	[1] = Vector(250, 0, -100),
}


local HitSound = Sound("physics/glass/glass_bottle_impact_hard1.wav")

hook.Add( "InitPostEntity", "OreCreate", function()

	timer.Simple( 5, function()

		local map = game.GetMap()

		if ( rock_locations[ map ] ) then
			for _, rock in pairs( rock_locations[ map ] ) do

				print( string.format( "[phatMiner] Creating Rock @ %s.", rock ) )

				local new_rock = ents.Create( "ent_ore" )
				new_rock:SetPos( rock )
				new_rock:SetAngles( Angle(0,0,0) )
				new_rock:Spawn()

			end
		else
			print( string.format( "[phatMiner] No rock locations set for %s", map ) )
		end

	end )

end )



function ENT:Initialize()
	self:SetModel( rock_models[ math.random( #rock_models ) ] )
	self:SetColor( Color( 255, 255, 255, 255 ) )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetHealth( 100 )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetModelScale(0)
	self:SetModelScale(1, 2)
	self:SetGravity( 0 )

	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion( false ) end

end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )

	ent:SetHealth( 100 )
	ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Use( activator, caller )
end

function ENT:OnTakeDamage( dmginfo )
	local activator = dmginfo:GetAttacker()

    if ( activator:IsPlayer() ) then
		if (activator:GetActiveWeapon():GetClass() ~= "weapon_pick") then
			activator:ChatPrint( "You need a pickaxe to mine this." )
			return
		end

		local dmg = dmginfo:GetDamage()
		self:SetHealth( self:Health() - dmg )

		local col = self:GetColor()
		col.r = math.Clamp( col.r - dmg, 0, 255 )
		col.g = math.Clamp( col.g - dmg, 0, 255 )
		col.b = math.Clamp( col.b - dmg, 0, 255 )
		self:SetColor( col )

		local rng = math.random(10)
		if (rng < 3) then return end

		self:EmitSound( HitSound )

		local dropped_Ore = ents.Create( "ent_ore_item" )
		dropped_Ore:SetPos( activator:GetEyeTrace().HitPos )
		dropped_Ore:SetModelScale(0)
		dropped_Ore:Spawn()
		dropped_Ore:Activate()
		dropped_Ore:SetModelScale(1, 0.5)
		dropped_Ore:PhysWake()

		local ore, ore_key = table.Random( PHATMINER_ORE_TYPES )

		dropped_Ore:SetModel( ore.model )
		dropped_Ore:SetColor( ore.color )
		dropped_Ore:SetMaterial( ore.mat )

		dropped_Ore._ore_name = ore_key
	end


	local old_model = self:GetModel()
	local old_pos = self:GetPos()
	local old_ang = self:GetAngles()


	local effectdata = EffectData()
	effectdata:SetOrigin( dmginfo:GetDamagePosition() )
	util.Effect( "inflator_magic", effectdata )


	if self.OutofOre then return end
	if self:Health() < 15 then
		self.OutofOre = true

		local explode = ents.Create( "env_explosion" )
		explode:SetPos( self:GetPos() )
		explode:SetKeyValue( "iMagnitude", "80" )
		explode:Fire( "Explode", 0, 0 )
		explode:Remove()
		timer.Simple( 2, function()
			local new_rock = ents.Create( "ent_ore" )
			new_rock:SetModel( old_model )
			new_rock:SetPos( old_pos )
			new_rock:SetAngles( old_ang )
			new_rock:Spawn()
		end )

		self:Remove()
	end

end
