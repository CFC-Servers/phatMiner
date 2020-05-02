print("[phatMiner] Pickaxe (Weapon)")
include( "shared.lua" )
AddCSLuaFile("shared.lua")


util.AddNetworkString( "phatminer_stats" )
local pmeta = FindMetaTable( "Player" )


function pmeta:GetOre( tOre )
	if ( self._phatItems[ tOre ] ) then
		return tonumber( self._phatItems[ tOre ] )
	else
		print( string.format( "[phatMiner] We tried to retrieve data before it existed on Player: %s, Type: %s.", self:AccountID(), tOre ) )
	end
end

function pmeta:SetOre( tOre, amt )
		if ( self._phatItems[ tOre ] ) then
			self._phatItems[ tOre ] = amt
		else
			print( string.format( "[phatMiner] We tried to set data before it existed on Player: %s, Type: %s.", self:AccountID(), tOre ) )
		end
end

timer.Create( "phatMiner-UpdateStats", 30, 0, function()
	for _, ply in pairs( player.GetAll() ) do

		if ( ply._phatItems ) then
			--Commit to sql if stats have loaded correctly

			--
			local moon_dust = ply:GetOre("moon_dust")
			local stone = ply:GetOre("stone")
			local phat_stone = ply:GetOre("phat_stone")
			local iron_ore = ply:GetOre("iron_ore")
			local diamond = ply:GetOre("diamond")
			local sulfur = ply:GetOre("sulfur")
			local copper_ore = ply:GetOre("copper_ore")
			local salt = ply:GetOre("salt")
			local dirt = ply:GetOre("dirt")
			local gold = ply:GetOre("gold")
			local tin = ply:GetOre("tin")

			--magic runes
			local egg = ply:GetOre("egg")
			local rune_air = ply:GetOre("rune_air")
			local rune_fire = ply:GetOre("rune_fire")
			local rune_nature = ply:GetOre("rune_nature")

			sql.Query("UPDATE pm_oredata SET moon_dust = ".. moon_dust ..", stone = ".. stone ..", phat_stone = "..phat_stone.. ", iron_ore = ".. iron_ore ..", diamond = ".. diamond ..", sulfur = ".. sulfur..", copper_ore = ".. copper_ore..", salt = "..salt..", dirt = "..dirt..", gold = "..gold..", tin = "..tin.. ", egg = "..egg..", rune_air = "..rune_air..", rune_fire = "..rune_fire..", rune_nature = "..rune_nature.." WHERE uid = '".. ply:AccountID() .."'")


			net.Start("phatminer_stats")
			net.WriteTable( ply._phatItems )
			net.Send( ply )

		end

	end
end )

hook.Add("Initialize", "phatMiner-Initialize", function()
	if ( sql.TableExists("pm_oredata") ) then
		print( "[phatMiner SQL] Table Exists...." )
	else
		local result = sql.Query( "CREATE TABLE pm_oredata ( uid varchar(255), moon_dust int, stone int, phat_stone int, iron_ore int, diamond int, sulfur int, copper_ore int, salt int, dirt int, gold int, tin int, egg int, rune_air int, rune_fire int, rune_nature int )" )
		print( "[phatMiner SQL] " .. tostring(result) .. "->" .. sql.LastError() )
	end
end)

hook.Add("PlayerInitialSpawn", "phatMiner-Spawn", function( pl, transition )

	local uid = pl:AccountID()

	local result = sql.Query("SELECT uid FROM pm_oredata WHERE uid = '" .. uid .. "'")
	if (result) then
		print( "[phatMiner] PLAYER EXISTS -> ".. pl:Nick() .. "->" .. sql.LastError())
	else
		local result = sql.Query("INSERT INTO pm_oredata ('uid', 'moon_dust', 'stone', 'phat_stone', 'iron_ore', 'diamond', 'sulfur', 'copper_ore', 'salt', 'dirt', 'gold', 'tin', 'egg', 'rune_air', 'rune_fire', 'rune_nature') VALUES ('".. uid .."', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' )")

		local result2 = sql.Query("SELECT uid, moon_dust, stone, phat_stone, iron_ore, diamond, sulfur, copper_ore, salt, dirt, gold, tin, egg, rune_air, rune_fire, rune_nature FROM pm_oredata WHERE uid = '" .. uid .. "'")
		if (result) then
			print("[phatMiner] Created player -> ".. pl:Nick( ).. "->" .. sql.LastError())

		else
			print("[phatMiner] Error creating player -> ".. pl:Nick() .. "->" .. sql.LastError())
		end
	end

	pl._phatItems = {}

	--load ore stats
	for k, v in pairs( PHATMINER_ORE_TYPES ) do
		local amount = sql.QueryValue( string.format( "SELECT %s FROM pm_oredata WHERE uid = '".. uid .. "'", k) )
		pl._phatItems[ k ] = amount
	end

	--[[load rune stats
	for k, v in pairs( PHATMINER_ITEM_TYPES ) do
		local amount = sql.QueryValue( string.format( "SELECT %s FROM pm_oredata WHERE uid = '".. uid .. "'", k) )
		pl._phatItems[ k ] = amount
	end]]

end)
