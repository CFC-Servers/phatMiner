AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local Sound = Sound("physics/glass/glass_bottle_impact_hard1.wav")


local mega_rocks = {
	[1] = "models/props_wasteland/rockcliff_cluster01b.mdl"
}

local large_rocks = {
	[1] = "models/props_wasteland/rockcliff05b.mdl",
	[2] = "models/props_wasteland/rockcliff05a.mdl",
	[3] = "models/props_wasteland/rockcliff05e.mdl",
	[4] = "models/props_wasteland/rockcliff05f.mdl",
	[5] = "models/props_wasteland/rockcliff_cluster03c.mdl",
}

local medium_rocks = {
	[1] = "models/props_wasteland/rockcliff01f.mdl",
	[2] = "models/props_wasteland/rockcliff01j.mdl",
	[3] = "models/props_wasteland/rockcliff01k.mdl",
}

local small_rocks = {
	[1] = "models/props_canal/rock_riverbed01a.mdl",
	[2] = "models/props_canal/rock_riverbed01b.mdl",
	[3] = "models/props_canal/rock_riverbed01c.mdl",
	[4] = "models/props_canal/rock_riverbed01d.mdl",
	[5] = "models/props_canal/rock_riverbed02c.mdl",
}

local rock_locations = {
	[1] = {
		["pos"] = Vector(0, 0, 0),
		["type"] = "stone",
		["ent"] = false,
	},
}

hook.Add( "InitPostEntity", "OreCreate", function()
	timer.Simple( 2, function()
		for _, rock in pairs( rock_locations ) do
			
			local mdl = medium_rocks[ math.random( #medium_rocks ) ] 
			print(mdl)
		
			print( string.format( "[T] Creating Rock @ %s.", rock.pos ) )

		
			local new_rock = ents.Create( "ent_ore" )
			new_rock:SetPos( rock.pos )
			new_rock:SetAngles( Angle(0,0,0) )
			new_rock:SetModel( medium_rocks[ math.random( #medium_rocks ) ] )
			new_rock:Spawn()
		
		end
	end )
end )


--This is for pre-defining entites as ore in hammer map editor
--[[timer.Create( "ore_setup", 1, 0, function() 
	local rocks = ents.FindByName("map_ore" )
	
	for key, rock in pairs( rocks ) do

		if ( rock:GetClass() == "ent_ore" ) then return end

		rock:Remove()
		
		local model = rock:GetModel()
		local health = rock:Health()
		local pos = rock:GetPos()
		local ang = rock:GetAngles()
	
		print( string.format("[R] Rock: %i, Health=%i, Pos=%s", key, health, tostring(pos) ) )
		
		local new_rock = ents.Create( "ent_ore" )
		new_rock:SetPos( pos )
		new_rock:SetAngles( ang )
		new_rock:SetModel( model )
		new_rock:Spawn()

	end
end )]]


local models = {
	"models/props_junk/watermelon01.mdl",
}

local colors = {
	Color(255, 255, 255, 255),

}

function ENT:Initialize()
	self:SetModel( medium_rocks[ math.random( #medium_rocks ) ] )
	self:SetColor( colors[ math.random( #colors ) ] )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetHealth(100)
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion( false ) end
	
	self:SetGravity( 0 )
	
	
	local mins, maxs = self:GetModelBounds()
	local orig_pos = self:GetPos()
	local new_pos = Vector( orig_pos.x, orig_pos.y, orig_pos.z - maxs.z - 50 )
	
	self:SetPos( new_pos )
	self:SetModelScale(0)
	self:SetModelScale(1, 10)

	timer.Create( "OrePopup_"..self:EntIndex(), 0.05, orig_pos.z, function()
		if IsValid(self) then
			new_pos.z = math.Approach( new_pos.z, orig_pos.z, 1 )
			self:SetModelScale(new_pos.z/orig_pos.z)
			self:SetPos( new_pos )
		end
	end )	
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local size = math.random( 16, 48 )
	local ent = ents.Create( ClassName )
	
	ent:SetPos( tr.HitPos + tr.HitNormal * size )
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
		--col.a = math.Clamp( col.a - dmg, 0, 255 )
		self:SetColor( col )
		
		local rng = math.random(-activator:GetNWInt("exp_mining"), 100)
		if (rng < 5) then return end
	
		self:EmitSound( Sound )
		--local health = activator:Health()
		--activator:SetHealth( health + 1 )
		
		local dropped_Ore = ents.Create( "ent_ore_item" )
		dropped_Ore:SetPos( activator:GetEyeTrace().HitPos ) 
		dropped_Ore:SetModelScale(0)
		dropped_Ore:Spawn()
		dropped_Ore:Activate()
		dropped_Ore:SetModelScale(1,0.25)
		dropped_Ore:PhysWake()
		
		local ore, ore_key = table.Random( PHATMINER_ORE_TYPES )
		
		dropped_Ore:SetModel( ore.model )
		dropped_Ore:SetColor( ore.color )
		dropped_Ore:SetMaterial( ore.mat )
		
		dropped_Ore:SetNWString( "ore_name", ore_key )
		
		
		local experience = activator:GetNWInt("exp_mining")
		activator:SetNWInt("exp_mining", experience + 1)
	end
	

	
	
	local old_model = self:GetModel()
	local old_pos = self:GetPos()
	local old_ang = self:GetAngles()
	
	local effectdata1 = EffectData()
	effectdata1:SetScale( 20 )
	effectdata1:SetRadius( 6 )
	effectdata1:SetEntity( self )
	effectdata1:SetOrigin( dmginfo:GetDamagePosition() )
	effectdata1:SetMagnitude( 1 )
	util.Effect( "TeslaHitBoxes", effectdata1 )
	
	
	local effectdata = EffectData()
	effectdata:SetOrigin( dmginfo:GetDamagePosition() )
	util.Effect( "inflator_magic", effectdata )
	
	if self.OutofOre then return end
	
	if self:Health() < 15 then
		self.OutofOre = true -- infinite loop
		
		
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