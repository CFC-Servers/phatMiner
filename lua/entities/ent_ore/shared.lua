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
		["color"] = Color(255, 10, 191, 200),
		["mat"] = "models/shiny",
		["value"] = 1600,
		["chance"] = 1,
	},
	["stone"] = {
		["name"] = "Stone",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(182, 182, 182),
		["mat"] = "models/shiny",
		["value"] = 10,
		["chance"] = 45,
	},
	["gold"] = {
		["name"] = "Gold",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 0),
		["mat"] = "models/shiny",
		["value"] = 1300,
		["chance"] = 2,
	},
	["phat_stone"] = {
		["name"] = "Phat Stone",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(25, 25, 255),
		["mat"] = "models/shiny",
		["value"] = 20000,
		["chance"] = 1,
	},
	["iron_ore"] = {
		["name"] = "Iron",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(127, 111, 63),
		["mat"] = "models/debug/debugwhite",
		["value"] = 30,
		["chance"] = 20,
	},

	["diamond"] = {
		["name"] = "Diamond",
		["model"] = "models/holograms/icosphere.mdl",
		["color"] = Color(127, 255, 255),
		["mat"] = "models/shiny",
		["value"] = 10000,
		["chance"] = 1,
	},

	["sulfur"] = {
		["name"] = "Sulfur",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(235, 255, 0),
		["mat"] = "models/shiny",
		["value"] = 50,
		["chance"] = 5,
	},
	["copper_ore"] = {
		["name"] = "Copper",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(180, 168, 0),
		["mat"] = "models/shiny",
		["value"] = 35,
		["chance"] = 4,
	},
	["salt"] = {
		["name"] = "Salt",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 255),
		["mat"] = "models/debug/debugwhite",
		["value"] = 5,
		["chance"] = 20,
	},
	["dirt"] = {
		["name"] = "Dirt",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(127, 111, 63),
		["mat"] = "models/debug/debugwhite",
		["value"] = 1,
		["chance"] = 30,
	},
}
