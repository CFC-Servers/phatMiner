AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Rock"
ENT.Category = "!Mining Entities!" 
ENT.Spawnable = true


PHATMINER_ORE_TYPES = {
	["moon_dust"] = {
		["name"] = "Xen Crystal",
		["desc"] = "Moon dust probably worth something\n if you can find the right man.",
		["model"] = "models/holograms/icosphere.mdl",
		["color"] = Color(255, 10, 191, 200),
		["mat"] = "models/shiny",
		["value"] = 1600,
		["chance"] = 10,
	},
	["stone"] = {
		["name"] = "Stone",
		["desc"] = "A heap of stone.",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(182, 182, 182),
		["mat"] = "models/shiny",
		["value"] = 10,
		["chance"] = 10,
	},
	["gold"] = {
		["name"] = "Gold",
		["desc"] = "Just a rock.",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 0),
		["mat"] = "models/shiny",
		["value"] = 1300,
		["chance"] = 1,
	},
	["phat_stone"] = {
		["name"] = "Phat Stone",
		["desc"] = "Source of the universe.",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(25, 25, 255),
		["mat"] = "models/shiny",
		["value"] = 20000,
		["chance"] = 1,
	},
	["iron_ore"] = {
		["name"] = "Iron",
		["desc"] = "Can be smelted into iron bars and turned into weapons.",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(127, 111, 63),
		["mat"] = "models/debug/debugwhite",
		["value"] = 30,
		["chance"] = 20,
	},
	
	["diamond"] = {
		["name"] = "Diamond",
		["desc"] = "A rare gem",
		["model"] = "models/holograms/icosphere.mdl",
		["color"] = Color(127, 255, 255),
		["mat"] = "models/shiny",
		["value"] = 10000,
		["chance"] = 2,
	},
	
	["sulfur"] = {
		["name"] = "Sulfur",
		["desc"] = "Can be made into gun powder for use in ammunition.",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(235, 255, 0),
		["mat"] = "models/shiny",
		["value"] = 50,
		["chance"] = 15,
	},
	["copper_ore"] = {
		["name"] = "Copper",
		["desc"] = "A precious metal used to make electronics.",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(180, 168, 0),
		["mat"] = "models/shiny",
		["value"] = 35,
		["chance"] = 30,
	},
	["salt"] = {
		["name"] = "Salt",
		["desc"] = "Sodium chloride, primo stuff.",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(255, 255, 255),
		["mat"] = "models/debug/debugwhite",
		["value"] = 5,
		["chance"] = 25,
	},
	["dirt"] = {
		["name"] = "Dirt",
		["desc"] = "Useful.",
		["model"] = "models/props_junk/rock001a.mdl",
		["color"] = Color(127, 111, 63),
		["mat"] = "models/debug/debugwhite",
		["value"] = 1,
		["chance"] = 50,
	},
	
	
	--
	
	--[[todo
	["wood"] = {
		["model"] = "models/props_phx/construct/wood/wood_boardx1.mdl",
		["color"] = Color(105, 63, 27),
		["mat"] = "models/shiny",
		["value"] = 65,
	},
	["logs"] = {
		["model"] = "models/props_phx/construct/wood/wood_boardx1.mdl",
		["color"] = Color(255, 255, 255),
		["mat"] = "models/shiny",
		["value"] = 85,
	},
	["planks"] = {
		["model"] = "models/props_phx/construct/wood/wood_boardx1.mdl",
		["color"] = Color(255, 255, 255),
		["mat"] = "models/shiny",
		["value"] = 100,
	},
	
	--string
	["cotton"] = {
		["model"] = "models/holograms/icosphere2.mdl",
		["color"] = Color(255, 255, 255),
		["mat"] = "models/shiny",
		["value"] = 50,
	},
	["wool"] = {
		["model"] = "models/holograms/icosphere2.mdl",
		["color"] = Color(255, 255, 255),
		["mat"] = "models/shiny",
		["value"] = 100,
	},]]
}