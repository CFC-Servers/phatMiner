AddCSLuaFile()

SWEP.PrintName = "Tesla Drill"
SWEP.Author = "FubuDuckie"
SWEP.Instructions = "Left = Drill Rock"
SWEP.Category = "!Mining Entities"
SWEP.Spawnable= true
SWEP.AdminOnly = false
SWEP.Base = "weapon_base"
SWEP.Primary.Damage = 3
SWEP.Primary.TakeAmmo = 0
SWEP.Primary.ClipSize = 5000
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 5000
SWEP.Primary.Spread = 0
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0
SWEP.Primary.Delay = 0.6
SWEP.Primary.Force = 500
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo	= true
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.UseHands = true
SWEP.HoldType = "normal"
SWEP.FiresUnderwater = true
SWEP.CSMuzzleFlashes = false

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end
