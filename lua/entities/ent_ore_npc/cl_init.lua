include( "shared.lua" )

--todo: vaccuum clean this file

function ENT:Draw()
	self:DrawModel()

	local mins, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector( 0, 0, maxs.z )


	local loc_ang = LocalPlayer():EyeAngles()
	loc_ang:RotateAroundAxis( loc_ang:Forward(), 90 )
	loc_ang:RotateAroundAxis( loc_ang:Right(), 90 )

	cam.Start3D2D( pos, Angle(0, loc_ang.y, 90), 0.2 )
		draw.DrawText( "Ore Exchange", "TargetID", 0, 0, Color(255, 255, 0), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

MENU_CRAFTING = MENU_CRAFTING or {}
MENU_CRAFTING.Panel = false

local function openCraftMenu()
	if (  ValidPanel( MENU_CRAFTING.Panel ) ) then
		MENU_CRAFTING.Panel:MakePopup()
	else
		local wide, tall = ScrW(), ScrH()

		MENU_CRAFTING.Panel = vgui.Create( "DFrame" )
		MENU_CRAFTING.Panel:SetTitle("Crafting Menu")
		MENU_CRAFTING.Panel:SetSize( 400, 400 )
		MENU_CRAFTING.Panel:Center()
		MENU_CRAFTING.Panel.Paint = function( self )
			local wide, tall = self:GetWide(), self:GetTall()
			surface.SetDrawColor( 25, 25, 25, 200 )
			surface.DrawRect( 0, 0, wide, tall )
			surface.SetDrawColor( 25, 25, 25, 100 )
			surface.DrawRect( 0, 0, wide, tall )
		end

		MENU_CRAFTING.Panel:MakePopup()

		local craft_scroll = vgui.Create( "DScrollPanel", MENU_CRAFTING.Panel )
		craft_scroll:Dock( FILL )
		craft_scroll:DockMargin( 0, 0, 0, 0 )

		for kCombo, vKombo in pairs( PHATMINER_MAGIC_COMBOS ) do
			local bCombo = vgui.Create( "DButton", MENU_CRAFTING.Panel )
			bCombo:SetFont( "phatlabel" )
			bCombo:SetText( "" )
			bCombo:SetSize( 200, 80 )
			bCombo:Dock( TOP )
			bCombo:DockMargin( 1, 1, 1, 1 )
			bCombo:SetTextColor( PHATMINER_ORE_TYPES[ kCombo ].col )
			bCombo.Paint = function( self )
				draw.SimpleTextOutlined(  "=", "phatlabel", 225, 35, PHATMINER_ORE_TYPES[ kCombo ].col , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER	, 2, Color(0,0,0) )
				draw.SimpleTextOutlined( PHATMINER_ORE_TYPES[ kCombo ].name or "Loading...", "phatlabel", 265, 7, PHATMINER_ORE_TYPES[ kCombo ].col , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER	, 2, Color(0,0,0) )
			end

			local bCraft = vgui.Create( "DButton", bCombo )
			bCraft:SetFont( "DebugFixed" )
			bCraft:SetText( "Craft" )
			bCraft:SetSize( 60, 60 )
			bCraft:Dock( RIGHT )
			bCraft:DockMargin( 0, 0, 0, 0 )
			bCraft:SetTextColor( Color(225, 0, 0) )

			local mOutput = MENU_ORES.createItem( kCombo, PHATMINER_ORE_TYPES[ kCombo ], false, bCombo )
			mOutput:SetPos(140, 0)
			mOutput:Dock( RIGHT )

			local iCount = 0
			for kOre, vOre in pairs( vKombo ) do
				iCount = iCount + 1

				local mIngredient = MENU_ORES.createItem( kOre, PHATMINER_ORE_TYPES[ kOre ], false, bCombo )
				mIngredient:SetPos( iCount * 2, -10 )
				mIngredient:Dock( LEFT )
				mIngredient:DockMargin(-22, 0, 0, 0)
			end


			craft_scroll:Add( bCombo )
		end
	end
end

net.Receive( "pm_openmenu", function()
	openMinerMenu()
	openCraftMenu()
end )
