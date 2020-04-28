print("Pickaxe")
include( "shared.lua" )
AddCSLuaFile("shared.lua")


util.AddNetworkString( "phatminer_stats" )



hook.Add("Initialize", "phatMiner-Initialize", function()
	if ( sql.TableExists("pm_oredata") ) then
		print( "[phatMiner] Table Exists...." )
	else
		local query = "CREATE TABLE pm_oredata ( unique_id varchar(255), moon_dust int, stone int, phat_stone int, iron_ore int, diamond int, sulfur int, copper_ore int, salt int, dirt int, gold int )"
		local result = sql.Query( query )
		print( "[phatMiner] " .. tostring(result ) )
	end
end)

hook.Add("PlayerInitialSpawn", "phatMiner-Spawn", function( pl, transition )

	local uid = pl:AccountID()
	
	local result = sql.Query("SELECT moon_dust, stone, phat_stone, iron_ore, diamond, sulfur, copper_ore, salt, dirt, gold FROM pm_oredata WHERE unique_id = '" .. uid .. "'")
	if (result) then
		print( "[phatMiner] PLAYER EXISTS -> ".. pl:Nick())
		
		pl._phatItems = {}
		
		for k, v in pairs( PHATMINER_ORE_TYPES ) do
		
			local amount = sql.QueryValue( string.format( "SELECT %s FROM pm_oredata WHERE unique_id = '".. uid .. "'", k) )
			
			
			pl._phatItems[ k ] = amount
			
		end
		
		PrintTable( pl._phatItems )
	else
		sql.Query("INSERT INTO pm_oredata ('unique_id', 'moon_dust', 'phat_stone', 'iron_ore', 'diamond', 'sulfur', 'copper_ore', 'salt', 'dirt', 'gold')VALUES ('".. uid .."', '5', '0', '10', '0', '0', '0', '0', '0', '0')")
		local result = sql.Query("SELECT unique_id, moon_dust, stone, phat_stone, iron_ore, diamond, sulfur, copper_ore, salt, dirt, gold FROM pm_oredata WHERE unique_id = '" .. uid .. "'")
		if (result) then
			print("[phatMiner] Creating player -> ".. pl:Nick())

		else
			print("[phatMiner] Creating player 2 -> ".. pl:Nick())
		end
	end


end)