print("[phatMiner] Magic Finger")
include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )



local magic_maxTypes = 2
SWEP.magic_Selected = 1

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

	if (magic_type == 1) or (magic_type == 2) then

		local magic_orb = ents.Create( "ent_magic" )
		magic_orb:SetOwner( owner )
		magic_orb:SetMagicType( magic_type or 1, self.Owner )
		magic_orb:SetPos( owner:EyePos() + ( owner:GetAimVector() * 16 ) )
		magic_orb:Spawn()
		magic_orb:Activate()

		local phys = magic_orb:GetPhysicsObject()
		if ( !IsValid( phys ) ) then
			magic_orb:Remove()
			return
		end

		phys:EnableGravity(false)

		local velocity = owner:GetAimVector()
		phys:ApplyForceCenter( velocity )

		if (magic_type == 2) then
			timer.Simple( 0.0001, function()
				ParticleEffectAttach( "fire_large_01", PATTACH_ABSORIGIN_FOLLOW, magic_orb, -1 )
			end )


		timer.Simple( 3, function()
			if IsValid( magic_orb ) then
				magic_orb:StopParticles()
				magic_orb:Remove()
			end
		end )
	end

end


function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	self.Owner:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_PRIMARY, 0 )

	local bullet = {}
	bullet.Num = self.Primary.NumberofShots
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 0
	bullet.Force = self.Primary.Force
	bullet.Damage = self.Primary.Damage
	bullet.AmmoType = self.Primary.Ammo

	bullet.Distance = 0

	local rnda = self.Primary.Recoil * -1
	local rndb = self.Primary.Recoil * math.random(-1, 1)

	self:ShootEffects()

	self.Owner:FireBullets( bullet )
	--self:EmitSound(ShootSound)
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
	self:TakePrimaryAmmo(self.Primary.TakeAmmo)

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self:ShootMagic( self.magic_Selected )
end

function SWEP:SecondaryAttack()
	self.magic_Selected = self.magic_Selected + 1
	if self.magic_Selected > magic_maxTypes then self.magic_Selected = 1 end

	self.Owner:ChatPrint( "Changed spell to: " .. self.magic_Selected )

	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end
