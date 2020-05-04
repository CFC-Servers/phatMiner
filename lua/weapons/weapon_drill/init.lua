print( "[phatMiner] Rock Drill" )

include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

local DrillSounds = {
	"ambient/machines/pneumatic_drill_1.wav",
	"ambient/machines/pneumatic_drill_2.wav",
	"ambient/machines/pneumatic_drill_3.wav",
}


function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	sound.Play( table.Random( DrillSounds ), self.Owner:GetPos(), 55 )

	self:SetHoldType("physgun")
	self:SendWeaponAnim( ACT_VICTORY_DANCE )

	local bullet = {}
	bullet.Num = self.Primary.NumberofShots
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 0
	bullet.Force = self.Primary.Force
	bullet.Damage = self.Primary.Damage
	bullet.AmmoType = self.Primary.Ammo

	bullet.Distance = 200

	local rnda = self.Primary.Recoil * -1
	local rndb = self.Primary.Recoil * math.random(-1, 1)

	self:ShootEffects()

	self.Owner:FireBullets( bullet )
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )

	local trace = self.Owner:GetEyeTrace()

	if ( trace.HitPos:Distance( self:GetPos() ) < 200 ) then
		local effectdata = EffectData()
		effectdata:SetEntity( self )
		effectdata:SetStart( trace.HitPos )
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetMagnitude( .01 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 1 )
		util.Effect( "cball_bounce", effectdata, true, true )
	end


	self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
end
