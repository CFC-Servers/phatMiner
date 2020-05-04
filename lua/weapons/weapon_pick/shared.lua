AddCSLuaFile()

local ShootSound = Sound("npc/vort/claw_swing2.wav")

SWEP.Base = "weapon_base"
SWEP.PrintName = "Pickaxe"
SWEP.Author = "FubuDuckie"
SWEP.Instructions = "Left = Swing, Right = Open Backpack"
SWEP.Category = "!Mining Entities"
SWEP.Spawnable= true
SWEP.AdminOnly = false
SWEP.DisableDuplicator = true
SWEP.Primary.Damage = 1
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 9999
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 9999
SWEP.Primary.Spread = 0
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 1.2
SWEP.Primary.Force = 250
SWEP.Secondary.Delay = SWEP.Primary.Delay
SWEP.Secondary.TakeAmmo = 0
SWEP.Secondary.ClipSize	=  1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawCrosshair	= true
SWEP.DrawAmmo	= false
SWEP.Weight		= 5
SWEP.AutoSwitchTo 	= true
SWEP.AutoSwitchFrom = true

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"
SWEP.FiresUnderwater = true
SWEP.CSMuzzleFlashes = false

function SWEP:Initialize()
	util.PrecacheSound( ShootSound )
	self:SetHoldType( self.HoldType )
end


function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack() ) then return end

	self:SendWeaponAnim( ACT_VM_HITCENTER )

	local bullet = {}
	bullet.Num = self.Primary.NumberofShots
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 0
	bullet.Force = self.Primary.Force
	bullet.Damage = self.Primary.Damage
	bullet.AmmoType = self.Primary.Ammo

	bullet.Distance = 70


	local rnda = self.Primary.Recoil * -1
	local rndb = self.Primary.Recoil * math.random(-1, 1)

	self:ShootEffects()

	self.Owner:FireBullets( bullet )
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
	self:TakePrimaryAmmo(self.Primary.TakeAmmo)

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end



function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end
