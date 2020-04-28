AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

print("[T] Xen Trader (NPC)")

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
		--self:PhysWake()
		
		self:SetSequence( 2 )
		self.LastSaid = 0
		
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
		if (CurTime() > self.LastSaid + 3) then
			self.LastSaid = CurTime()
			
			
			local ore_count = activator:GetNWInt("unrefined_ore")
			
			if (ore_count > 0) then
				activator:SetNWInt( "unrefined_ore", 0 )
				self:EmitSound( sayings[ math.random( #sayings) ] )
				
				local exp_mining = activator:GetNWInt("exp_mining")
				activator:SetNWInt("exp_mining", exp_mining + 10 * ore_count )
				
				local money = activator:GetNWInt("money")
				activator:SetNWInt("money", money + ore_count*10 )
				
				
				local chat_string = string.format("The trader gives you ($%i)", ore_count*10)
				activator:ChatPrint( chat_string )
				--Award exp
			else
				--Player has no ore
			end
		else
			--Asking to trade too fast
		end
	end
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