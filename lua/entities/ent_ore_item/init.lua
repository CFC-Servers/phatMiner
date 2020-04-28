AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

print("[T] Resource Items")

local Sound = Sound("physics/glass/glass_bottle_impact_hard1.wav")


local models = {
	"models/holograms/cube.mdl",
}

local colors = {
	Color(255, 255, 255, 255),
}

function ENT:Initialize()
	self:SetModel( "models/props_junk/rock001a.mdl" )
	self:SetMaterial( "models/props_wasteland/rockcliff02b" )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetHealth(100)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion( true ) end
	self:PhysWake()
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
	if IsValid( activator ) then
		activator:SetNWInt( "ore_collected", activator:GetNWInt( "ore_collected" ) + 1 )
	end
	self:Remove()
	
	local experience = activator:GetNWInt("experience")
	activator:SetNWInt("experience", experience + 1)
end

function ENT:OnTakeDamage( dmginfo )

	local activator = dmginfo:GetAttacker()
    if ( activator:IsPlayer() ) then
		self:EmitSound( Sound )
		local health = activator:Health()
		activator:SetHealth( health + 1 )
	end
	
	
	local dmg = dmginfo:GetDamage()
	self:SetHealth( self:Health() - dmg )
	
	if self:Health() < 1 then
		self:Remove()
	end
	
end