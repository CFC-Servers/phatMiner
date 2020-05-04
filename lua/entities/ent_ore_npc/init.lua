AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

print("[phatMiner] Ore Trader (NPC)")

util.AddNetworkString( "pm_oreexchange" )
util.AddNetworkString( "pm_openmenu" )
util.AddNetworkString( "pm_dropore" )

net.Receive( "pm_dropore", function( len, ply )
	local oreTable = net.ReadTable()

	for oreType, amt in pairs( oreTable ) do
		if ( PHATMINER_ORE_TYPES[ oreType ] ) then

			if ( amt > 10 ) then
				ply:ChatPrint( string.format( "You can drop 10 %s at a time.", oreType ) )
				amt = 10
			end

			amt = math.abs( amt )

			if ( ply:GetOre( oreType ) >= amt ) then

				for i = 0, amt do
					local dropped_Ore = ents.Create( "ent_ore_item" )
					dropped_Ore:SetPos( ply:GetPos() )
					dropped_Ore:Spawn()
					dropped_Ore:Activate()
					dropped_Ore:PhysWake()

					dropped_Ore._oreID = oreType
					dropped_Ore:SetModel( PHATMINER_ORE_TYPES[ oreType ].model )
					dropped_Ore:SetColor( PHATMINER_ORE_TYPES[ oreType ].color )
					dropped_Ore:SetMaterial( PHATMINER_ORE_TYPES[ oreType ].mat )
				end

				ply:SetOre( oreType, ply:GetOre( oreType ) - amt )

			end
		end
	end
end )

net.Receive( "pm_oreexchange", function(len, ply)
	local oreTable = net.ReadTable()
	local entsNear = ents.FindInSphere( ply:GetPos(), 240 )
	local foundTrader = false

	for _, ent in pairs( entsNear ) do
		if (ent:GetClass() == "ent_ore_npc") then
			foundTrader = true
		end
	end

	if ( foundTrader ) then
		local salePrice = 0
		local saleCount = 0

		for oreType, amt in pairs( oreTable ) do
			if ( PHATMINER_ORE_TYPES[ oreType ] ) then

				amt = math.abs( amt )

				if ( ply:GetOre( oreType ) >= amt ) then
					saleCount = saleCount + amt

					--take ore
					ply:SetOre( oreType, ply:GetOre( oreType ) - amt )

					--add money
					local balance = PHATMINER_ORE_TYPES[ oreType ].value * amt
					ply:addMoney( balance )

					salePrice = salePrice + balance

					ply:ChatPrint( string.format( "Sold %i %s(s) for $%i.", amt, oreType, balance ) )
				else
					ply:ChatPrint( string.format( "You don't have enough %s to complete this offer.", oreType ) )
				end
			end
		end
		--ply:ChatPrint( string.format( "Sale complete, sold %i items for a total of $%i.", saleCount, salePrice ) )
	else

		ply:ChatPrint( "Sorry theres no ore trader nearby." )
	end
end )



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
		if ( CurTime() > self.LastSaid + 2 ) then
			self.LastSaid = CurTime()

			--Open ore menu
			net.Start( "pm_openmenu" )
			net.Send( activator )
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
