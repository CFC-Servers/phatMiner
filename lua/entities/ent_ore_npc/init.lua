AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

print("[phatMiner] Ore Trader (NPC)")

local sayings = {
	Sound("vo/npc/vortigaunt/dedicate.wav"),
	Sound("vo/npc/vortigaunt/energyempower.wav"),
	Sound("vo/npc/vortigaunt/fmknowsbest.wav"),
	Sound("vo/npc/vortigaunt/mystery.wav"),
}


local models = {
	"models/vortigaunt.mdl",
}

function ENT:Initialize()
	self:SetModel( models[ math.random( #models ) ] )
	self:SetColor( Color(255, 255, 255) )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetHealth(100)
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion( false ) end

	self:SetSequence( 2 )
	self.LastSaid = 0
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
		if (CurTime() > self.LastSaid + 3) then
			self.LastSaid = CurTime()

			--Open ore menu
			activator:ChatPrint( "I'm currently not programmed to do anything else right now... damn." )
		else
			--Asking to trade too fast
		end
	end
end

function ENT:OnTakeDamage( dmginfo )
	local activator = dmginfo:GetAttacker()
    if ( activator:IsPlayer() ) then
		--Smite player with vort beam
	end
end
