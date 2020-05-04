print("[phatMiner] Magic Finger")

include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

magic_spells = {}
magic_selected = 1

timer.Simple(3, function()
	for k, v in pairs( PHATMINER_ORE_TYPES ) do
		if ( v.magicFunction ) then
			table.insert( magic_spells, v )
		end
	end
end)

util.AddNetworkString( "magic_particle" )

function SWEP:CreateParticle( particleName, parentEnt, ang, seconds )
	net.Start("magic_particle")
	net.WriteString( particleName )
	net.WriteEntity( parentEnt )
	net.WriteAngle( ang or Angle(0,0,0) )
	net.WriteInt( seconds or 5, 32  )
	net.Broadcast()
end

function SWEP:ShootMagic( magic_type, mana_used )
	local owner = self.Owner


	print(magic_spells[ magic_selected ])

	local magic_orb = ents.Create( "ent_magic" )

	magic_orb:SetOwner( owner )
	magic_orb:SetPos( owner:EyePos() + ( owner:GetAimVector() * 16 ) )
	magic_orb:Spawn()
	magic_orb:Activate()

	if (magic_spells[ magic_selected ] ) then
		magic_orb:SetModel( magic_spells[ magic_selected ].model )
		magic_orb:SetColor( magic_spells[ magic_selected ].color )
		magic_orb:SetMaterial( magic_spells[ magic_selected ].mat )

		local spell = magic_spells[ magic_selected ].magicFunction( self )

		if ( spell ) then

			local split_required_runes = string.Explode( "+", spell )

			for _, rune_name in pairs( split_required_runes ) do

				local own_ore_count = owner:GetOre( rune_name )

				if ( own_ore_count > 0 ) then

					owner:SetOre( rune_name, own_ore_count - 1 )

				else

					SafeRemoveEntity( magic_orb )

				end

			end

		else

		end

	end

	timer.Simple(0.01, function()

		if (IsValid(magic_orb)) then
			local phys = magic_orb:GetPhysicsObject()
			if ( !IsValid( phys ) ) then
				magic_orb:Remove()
				return
			end

			phys:EnableGravity(false)

			local velocity = owner:GetAimVector() * 1000
			phys:ApplyForceCenter( velocity )

			timer.Simple( 2.8, function()
				if IsValid( magic_orb ) then
					magic_orb:StopParticles()
					magic_orb:Remove()
				end
			end )
		end
	end)
end


function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	self.Owner:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_PRIMARY, 0 )
	self.Owner:ViewPunch( AngleRand() / 20 )


	self:ShootEffects()

	self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:ShootMagic()
end

function SWEP:SecondaryAttack()

	magic_selected = magic_selected + 1
	if (magic_selected > #magic_spells) then
		magic_selected = 1
	end

	self.Owner:ChatPrint( "Changed spell to: " .. magic_spells[ magic_selected ].name )

	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end
