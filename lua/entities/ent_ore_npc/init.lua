AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

print("[phatMiner] Ore Trader (NPC)")

util.AddNetworkString( "pm_oreexchange" )
util.AddNetworkString( "pm_openmenu" )
util.AddNetworkString( "pm_dropore" )

net.Receive( "pm_dropore", function( len, ply )

	if ( ply.lastCommand and CurTime() > ply.lastCommand + 1 ) then
		ply.lastCommand = CurTime()

		local oreTable = net.ReadTable()

		PrintTable(oreTable)

		for oreType, amt in pairs( oreTable ) do
			if ( PHATMINER_ORE_TYPES[ oreType ] ) then

				amt = math.abs( amt )

				if ( amt > 5 ) then
					ply:ChatPrint( string.format( "You can drop 5 %s at a time.", oreType ) )
					amt = 5
				end

				if ( ply:GetOre( oreType ) >= amt ) then

					for i = 1, amt do
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
	else
		ply:ChatPrint( "Slow down, these rocks are heavy.")
	end
end )

net.Receive( "pm_oreexchange", function(len, ply)

	if ( ply.lastCommand and CurTime() > ply.lastCommand + 0.5 ) then
		ply.lastCommand = CurTime()

		local oreTable = net.ReadTable()
		local entsNear = ents.FindInSphere( ply:GetPos(), 240 )
		local foundTrader = false

		for _, ent in pairs( entsNear ) do
			if ( ent:GetClass() == "ent_ore_npc" ) then
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

			ply:ChatPrint( "Theres no ore trader nearby." )
		end
	else
		ply:ChatPrint( "I can't hold all these stones, please slow down." )
	end
end )



local sayings = {
	"vo/npc/vortigaunt/dedicate.wav",
	"vo/npc/vortigaunt/energyempower.wav",
	"vo/npc/vortigaunt/fmknowsbest.wav",
	"vo/npc/vortigaunt/mystery.wav",
}


local models = {
	"models/vortigaunt.mdl",
}

function ENT:Initialize()
	self:SetModel( models[ math.random( #models ) ] )
	self:SetColor( Color(255, 255, 255) )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetHealth( 65535 )
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
		if ( CurTime() > self.LastSaid + 1.5 ) then
			self.LastSaid = CurTime()

			--Open ore menu
			net.Start( "pm_openmenu" )
			net.Send( activator )


			--sound.Play( table.Random( sayings ), self:GetPos() )
		else
			--Asking to trade too fast
		end
	end
end

function ENT:OnTakeDamage( dmginfo )
	local activator = dmginfo:GetAttacker()
    if ( activator:IsPlayer() ) then
		--Smite player with vort beam

		sound.Play( "npc/vort/vort_pain3.wav", self:GetPos() )

		timer.Simple( 5, function()
			self:ResetSequence( "zapattack1" )

			local look_angle = ( activator:GetPos() - self:GetPos() ):Angle()
			look_angle.p = 0
			look_angle.r = 0

			self:SetAngles( look_angle )

			timer.Simple( 1, function()
				util.ParticleTracerEx( "vortigaunt_beam", self:GetPos() + Vector(0,0,45), activator:GetPos() + Vector(0, 0, 30), true, 0, -1 )

				timer.Simple( 0.4, function()
					self:ResetSequence( 2 )

					activator:TakeDamage( activator:Health() / 2, self, self )
				end )
			end )
		end )
	end
end
