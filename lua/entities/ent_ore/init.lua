AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )


local rock_locations = {
	["gm_construct"] = {
		[1] = Vector(0, 0, -85),
		[2] = Vector(0, 250, -85),
		[3] = Vector(0, 500, -85),
		[4] = Vector(0, 750, -85),
		[5] = Vector(0, 1000, -85),
	}
}

local npc_locations = {
	["gm_construct"] = {
		[1] = Vector(200, 500, -150),
	}
}


local rock_models = {
	[1] = {m="models/props_wasteland/rockcliff01f.mdl",v=Vector(0,0,25)},
	[2] = {m="models/props_wasteland/rockcliff01j.mdl",v=Vector(0,0,25)},
	[3] = {m="models/props_wasteland/rockcliff01k.mdl",v=Vector(0,0,0)},
	[4] = {m="models/props_wasteland/rockcliff01f.mdl",v=Vector(0,0,25)},
	[5] = {m="models/props_wasteland/rockcliff07b.mdl",v=Vector(0,0,55)},
}

local HitSounds = {
	"physics/glass/glass_bottle_impact_hard1.wav",
	"physics/glass/glass_bottle_impact_hard2.wav",
	"physics/glass/glass_bottle_impact_hard3.wav",
}

hook.Add( "InitPostEntity", "OreCreate", function()
	timer.Simple( 3, function()
		local map = game.GetMap()

		if ( rock_locations[ map ] ) then
			for _, rock in pairs( rock_locations[ map ] ) do
				print( string.format( "[phatMiner] Creating Rock @ %s.", rock ) )

				local new_rock = ents.Create( "ent_ore" )
				new_rock:SetPos( rock )
				new_rock:SetAngles( Angle(0,math.random(0, 180),0) )
				new_rock:Spawn()

			end
		else
			print( string.format( "[phatMiner] No rock locations set for %s. (Check phatMiner/lua/entities/ent_ore/init.lua)", map ) )
		end


		if ( npc_locations[ map ] ) then
			for _, npc in pairs( npc_locations[ map ] ) do
				print( string.format( "[phatMiner] Creating NPC @ %s.", npc ) )

				local new_npc = ents.Create( "ent_ore_npc" )
				new_npc:SetPos( npc )
				new_npc:SetAngles( Angle( 0, 0, 0 ) )
				new_npc:Spawn()
				new_npc:SetHealth( 5000 )

				new_npc:DropToFloor()
			end
		else
			print( string.format( "[phatMiner] No npc locations set for %s. (Check phatMiner/lua/entities/ent_ore/init.lua)", map ) )
		end

	end )

end )


function ENT:Initialize()

	local rock_preset = rock_models[ math.random( #rock_models ) ]

	self:SetModel( rock_preset.m )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetHealth( 100 )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	--self:SetModelScale(0)
	--self:SetModelScale(1, 2)
	self:SetGravity( 0 )

	self:SetPos( self:GetPos() + rock_preset.v )

	self:DropToFloor()

	--[[timer.Create( "rock_emerge_"..self:EntIndex(), 0.01, rock_preset.v.z, function()
		self:SetPos( self:GetPos() + Vector(0, 0, 1 ) )
	end )]]

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
			local weapon_class = activator:GetActiveWeapon():GetClass()
		if (weapon_class ~= "weapon_pick" and weapon_class ~= "weapon_drill") then
			activator:ChatPrint( "You need a pickaxe to mine this." )
			return
		end

		local rng = math.random(10)
		if (rng < 3) then return end --Check mining skill level here

		local dmg = dmginfo:GetDamage()
		self:SetHealth( self:Health() - dmg )

		local col = self:GetColor()
		col.r = math.Clamp( col.r - dmg, 0, 255 )
		col.g = math.Clamp( col.g - dmg, 0, 255 )
		col.b = math.Clamp( col.b - dmg, 0, 255 )
		self:SetColor( col )

		local vHitPos = activator:GetEyeTrace().HitPos

		sound.Play( table.Random( HitSounds ), vHitPos )

		local dropped_Ore = ents.Create( "ent_ore_item" )
		dropped_Ore:SetPos( vHitPos )
		dropped_Ore:SetModelScale(0)
		dropped_Ore:Spawn()
		dropped_Ore:Activate()
		dropped_Ore:SetModelScale(1, 0.5)
		dropped_Ore:PhysWake()


		local ore, ore_key = table.Random( PHATMINER_ORE_TYPES )

		while (math.random(0, 100) > ore.chance) do
			ore, ore_key = table.Random( PHATMINER_ORE_TYPES )
		end


		dropped_Ore._oreID = ore_key
		dropped_Ore:SetModel( ore.model )
		dropped_Ore:SetColor( ore.color )
		dropped_Ore:SetMaterial( ore.mat )
	end


	local old_model = self:GetModel()
	local old_pos = self:GetPos()
	local old_ang = self:GetAngles()


	local effectdata = EffectData()
	effectdata:SetOrigin( dmginfo:GetDamagePosition() )
	util.Effect( "inflator_magic", effectdata )

	if self.OutofOre then return end
	if ( self:Health() < 15 ) then
		self.OutofOre = true

		local explode = ents.Create( "env_explosion" )
		explode:SetPos( self:GetPos() )
		explode:SetKeyValue( "iMagnitude", "80" )
		explode:Fire( "Explode", 0, 0 )
		explode:Remove()

		if not ( self.noRespawn ) then
			timer.Simple( 2, function()
				local new_rock = ents.Create( "ent_ore" )
				new_rock:SetModel( old_model )
				new_rock:SetPos( old_pos )
				new_rock:SetAngles( old_ang )
				new_rock:Spawn()
			end )
		end

		self:Remove()
	end

end
