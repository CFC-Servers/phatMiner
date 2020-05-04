
--add to darkrpmodification/jobs.lua
--[[TEAM_MINER = DarkRP.createJob( "Miner", {
	color = Color(252, 255, 0, 255),
	model = {"models/player/Group03/Female_01.mdl"},
	description = "Mine the earth for gems and ore.",
	weapons = {"weapon_pick"},
	command = "miner",
	max = 0,
	salary = 160,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = true,
	category = "Citizens"
}) ]]


--[[ --add to darkrpmodification/shipments.lua
DarkRP.createShipment("Pickaxe", {
    model = "models/weapons/w_crowbar.mdl",
    entity = "weapon_pick",
    price = 10000,
    amount = 5,
    separate = true,
    pricesep = 1100,
    noship = false,
    allowed = {TEAM_MINER},
})

DarkRP.createShipment("Tesla Drill", {
    model = "models/weapons/w_physics.mdl",
    entity = "weapon_drill",
    price = 50000,
    amount = 5,
    separate = true,
    pricesep = 11000,
    noship = false,
    allowed = {TEAM_MINER},
})


]]
