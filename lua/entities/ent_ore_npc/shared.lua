AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Type = "ai"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Ore Trader (NPC)"
ENT.Category = "!Mining Entities"
ENT.Spawnable = true
ENT.AutomaticFrameAdvance = false

PrecacheParticleSystem( "vortigaunt_beam" )


PHATMINER_MAGIC_COMBOS = {
  ["rune_air"] = {
    ["phat_stone"] = 1,
    ["diamond"] = 1,
  },
  ["rune_nature"] = {
    ["phat_stone"] = 1,
    ["dirt"] = 1,
  },
  ["rune_fire"] = {
    ["phat_stone"] = 1,
    ["sulfur"] = 1,
  },
}
