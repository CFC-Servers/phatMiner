AddCSLuaFile()

local ShootSound = Sound("npc/vort/claw_swing2.wav")
game.AddParticles( "particles/vortigaunt_fx.pcf" )
game.AddParticles( "particles/fire_01.pcf" )
game.AddParticles( "particles/gmod_effects.pcf" )

PrecacheParticleSystem( "fire_jet_01" )
PrecacheParticleSystem( "vortigaunt_glow_charge_cp1" )

SWEP.PrintName = "Magic Finger"
SWEP.Author = "FubuDuckie"
SWEP.Instructions = "Left = Shoot, Right = Switch Action"
SWEP.Category = "!Mining Entities"
SWEP.Spawnable= true
SWEP.AdminOnly = false
SWEP.Base = "weapon_base"
SWEP.Primary.Damage = 0
SWEP.Primary.TakeAmmo = -1
SWEP.Primary.ClipSize = 9999
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 9999
SWEP.Primary.Spread = 0
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0
SWEP.Primary.Delay = 1
SWEP.Primary.Force = 200
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo	= true
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = ""
SWEP.UseHands  = true
SWEP.HoldType = "magic"
SWEP.FiresUnderwater = true
SWEP.CSMuzzleFlashes = false

function SWEP:Initialize()
	util.PrecacheSound( ShootSound )
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end
