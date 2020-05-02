AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

print( "[phatMiner] Items" )

local HitSound = Sound( "physics/glass/glass_bottle_impact_hard1.wav" )


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

	local ent = ents.Create( ClassName )

	ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Use( activator, caller )
	if IsValid( activator ) then
		if ( self._oreID ) then
			if ( activator._phatItems[ self._oreID ] ) then
				activator._phatItems[ self._oreID ] = activator._phatItems[ self._oreID ] + 1
			else
				--tried to pick item before info existed on player
			end
		end

		local tbl = {
			[ self._oreID ] = activator:GetOre( self._oreID )
		}

		net.Start( "phatminer_stats" )
		net.WriteTable( tbl )
		net.Send( activator )

		self:Remove()
	end
end

function ENT:OnTakeDamage( dmginfo )
	local dmg = dmginfo:GetDamage()
	self:SetHealth( self:Health() - dmg )

	if self:Health() < 1 then
		self:Remove()
	end
end

function ENT:PhysicsCollide( data, phys )

end
