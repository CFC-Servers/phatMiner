AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

print("[phatMiner] Xen Magic (Projectile)")

local HitSound = Sound("weapons/stunstick/spark1.wav")
local RemoveSound = Sound("npc/roller/mine/rmine_explode_shock1.wav")


local pl_meta = FindMetaTable("Player")


function ENT:PhysicsCollide(data, physobj)

	if (magic_spells[ magic_selected ]) then
		data.Entity = self
		magic_spells[ magic_selected ].magicFunction( data )
	end

	if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then
		local pitch = 32 + 128 - 10
		sound.Play( HitSound, self:GetPos(), 75, math.random( pitch - 10, pitch + 10 ), math.Clamp( data.Speed / 150, 0, 1 ) )
	end

	local cur_velocity = physobj:GetVelocity()
	local next_velocity = cur_velocity * 0.5
	physobj:SetVelocity( next_velocity )
end

function ENT:RebuildPhysics()
	self.ConstraintSystem = nil

	local size = 10
	self:PhysicsInitSphere( size, "metal_bouncy" )
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

	self:PhysWake()
end

function ENT:Initialize()

	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:SetMaterial( "models/debugwhite" )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetHealth(100)
	self:RebuildPhysics()

	self:SetModelScale(0, 1.5)

	--[[local light = ents.Create( "gmod_light" )
	light:SetModelScale(0)
	light:SetPos( self:GetPos() )
	light:SetParent( self )
	light:SetBrightness( 10 )
	light:SetOn( 1 )
	light:SetLightSize( 256 )
	light:SetColor( self:GetColor() )
	light:Spawn()]]

	sound.Play( HitSound, self:GetPos(), 75, 100, 1 )
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )

	ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Use( activator, caller )
end

function ENT:OnTakeDamage( dmginfo )
end
