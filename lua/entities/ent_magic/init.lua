AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

print("[phatMiner] Xen Magic (Projectile)")

local HitSound = Sound("weapons/stunstick/spark1.wav")
local RemoveSound = Sound("npc/roller/mine/rmine_explode_shock1.wav")


local pl_meta = FindMetaTable("Player")

--todo: change to use runes per spell vs mana per spell
function pl_meta:UseMana( amount )
	local mana = self:GetNWInt("mana")
	if (mana > 0) then
		self:SetNWInt("mana", mana - amount)
	end
end


local magic_types = {
	[1] = {
		["name"] = "Physics ball",
		["model"] = "models/holograms/icosphere.mdl",
		["color"] = Color(0, 255, 255, 255),
		["init"] = function(ent, pl)
			--pl:UseMana(5)
			ent:Ignite()

			function ent:PhysicsCollide(col, collider)
				if ( col.HitEntity ) then
					local phys = col.HitEntity:GetPhysicsObject()
					if (phys) then
						phys:SetVelocity( Vector(0, 0, 500) )
					end
				end
			end


		end,
	},

	[2] = {
		["name"] = "Fire Wave",
		["model"] = "models/holograms/icosphere.mdl",
		["color"] = Color(255, 93, 0, 255),
		["init"] = function(ent, pl)

			function ent:PhysicsCollide(col, collider)
				if ( col.HitEntity ) then
					local explode = ents.Create( "env_explosion" )
					explode:SetOwner( pl )
					explode:AddFlags( 4096 )
					explode:SetPos( ent:GetPos() )
					explode:SetKeyValue( "iMagnitude", "5" )
					explode:Fire( "Explode", 0, 0 )
					explode:Remove()
				end
			end

		end,
	},
}

function ENT:SetMagicType( num_type, pl )
	self.magicType = num_type
	self:SetColor( magic_types[ num_type ].color )
	self:SetModel( magic_types[ num_type ].model )
	self:SetModelScale( magic_types[ num_type ].scale or 1, 3 )

	magic_types[ num_type ].init( self, pl )

	util.SpriteTrail( self, 0, magic_types[ num_type ].color, true, 128, 1, 0.1, 2, "trails/laser" )
end

local models = {
	"models/holograms/hq_icosphere.mdl",
}

local colors = {
	Color(0, 255, 255, 255),
}

function ENT:RebuildPhysics()
	self.ConstraintSystem = nil

	local size = 10
	self:PhysicsInitSphere( size, "metal_bouncy" )
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

	self:PhysWake()
end

function ENT:PhysicsCollide(data, physobj)
	--Play sound
	if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then
		local pitch = 32 + 128 - 10
		sound.Play( HitSound, self:GetPos(), 75, math.random( pitch - 10, pitch + 10 ), math.Clamp( data.Speed / 150, 0, 1 ) )
	end

	--Add bounce
	local old_speed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local cur_velocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	old_speed = math.max( cur_velocity:Length(), old_speed )
	local next_velocity = next_velocity * old_speed * 0.1
	physobj:SetVelocity( next_velocity )
end

function ENT:Initialize()

	if not (self.magicType) then
		print("Magic created without type")
		self:Remove()
	end

	self:SetMaterial( "models/debugwhite" )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetHealth(100)
	self:RebuildPhysics()

	local light = ents.Create( "gmod_light" )
	light:SetModelScale(0)
	light:SetPos( self:GetPos() )
	light:SetParent( self )
	light:SetBrightness( 10 )
	light:SetOn( 1 )
	light:SetLightSize( 256 )
	light:SetColor( self:GetColor() )
	light:Spawn()

	sound.Play( HitSound, self:GetPos(), 75, 100, 1 )
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
end

function ENT:OnTakeDamage( dmginfo )
end
