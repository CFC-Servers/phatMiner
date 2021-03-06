AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Rock"
ENT.Category = "!Mining Entities"
ENT.Spawnable = true

PHATMINER_ORE_TYPES = {
	["moon_dust"] = {
		["name"] = "Xen Crystal",
		["model"] = "models/holograms/icosphere.mdl",
		["color"] = Color(255, 15, 215, 255),
		["mat"] = "models/shiny",
		["value"] = 1500,
		["chance"] = 1,
	},
	["tin"] = {
		["name"] = "Tin",
		["model"] = "models/holograms/icosphere.mdl",
		["color"] = Color(195, 195, 195, 255),
		["mat"] = "models/shiny",
		["value"] = 50,
		["chance"] = 3,
	},
	["stone"] = {
		["name"] = "Stone",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(182, 182, 182),
		["mat"] = "models/props_wasteland/rockcliff04a",
		["value"] = 10,
		["chance"] = 45,
	},
	["gold"] = {
		["name"] = "Gold",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 35),
		["mat"] = "models/shiny",
		["value"] = 1000,
		["chance"] = 2,
	},
	["phat_stone"] = {
		["name"] = "Phat Stone",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(25, 25, 255),
		["mat"] = "models/shiny",
		["value"] = 6590,
		["chance"] = 1,
	},
	["iron_ore"] = {
		["name"] = "Iron",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(127, 111, 63),
		["mat"] = "models/debug/debugwhite",
		["value"] = 20,
		["chance"] = 20,
	},

	["diamond"] = {
		["name"] = "Diamond",
		["model"] = "models/holograms/icosphere.mdl",
		["color"] = Color(127, 255, 255),
		["mat"] = "models/shiny",
		["value"] = 3200,
		["chance"] = 1,
	},

	["sulfur"] = {
		["name"] = "Sulfur",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(235, 255, 0),
		["mat"] = "models/shiny",
		["value"] = 30,
		["chance"] = 5,
	},
	["copper_ore"] = {
		["name"] = "Copper",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(180, 168, 0),
		["mat"] = "models/shiny",
		["value"] = 25,
		["chance"] = 4,
	},
	["salt"] = {
		["name"] = "Salt",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 255, 100),
		["mat"] = "models/debug/debugwhite",
		["value"] = 3,
		["chance"] = 20,
	},
	["dirt"] = {
		["name"] = "Dirt",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(127, 111, 63),
		["mat"] = "models/props_wasteland/rockcliff02a",
		["value"] = 1,
		["chance"] = 30,
	},

	--Special types

	["egg"] = {
		["name"] = "Easter Egg",
		["model"] = "models/props_phx/misc/egg.mdl",
		["color"] = Color(255, 255, 255),
		["mat"] = "",
		["value"] = 3,
		["chance"] = 0.5,
		["magicFunction"] = function( data, own )

			if (data.HitEntity) then
				data.HitEntity:Respawn()
				data.HitEntity:SetModelScale( 0.5, 1 )
			end

			return "egg+rune_air+rune_fire+rune_nature"

		end
	},

	["rune_air"] = {
		["name"] = "Air Stone",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 255, 200),
		["mat"] = "phoenix_storms/wire/pcb_blue",
		["value"] = 150,
		["chance"] = -1,
		["magicFunction"] = function( data, own )

			if (data.HitEntity) then
				data.HitEntity:SetVelocity( Vector(0, 0, 800) )
			end

			return "rune_air"

		end
	},

	["rune_fire"] = {
		["name"] = "Fire Stone",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 255, 200),
		["mat"] = "phoenix_storms/wire/pcb_red",
		["value"] = 150,
		["chance"] = -1,
		["magicFunction"] = function( data, own )

			if (data.HitEntity) then
				data.HitEntity:Ignite(3)
			end

			return "rune_fire"

		end,
	},

	["rune_nature"] = {
		["name"] = "Nature Stone",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 255, 200),
		["mat"] = "phoenix_storms/wire/pcb_green",
		["value"] = 150,
		["chance"] = -1,
		["magicFunction"] = function( data, own )

			if (data.HitEntity) then
				data.HitEntity:SetHealth( math.Clamp( data.HitEntity:Health() + 15,  0, data.HitEntity:GetMaxHealth() ) )
			end

			return "rune_nature"

		end,
	},
}
