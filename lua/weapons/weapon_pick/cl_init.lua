include("shared.lua")

surface.CreateFont( "phatlabel", {
	font = "Consolas",
	extended = false,
	size = 21,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = true,
	outline = false,
})



net.Receive( "phatminer_stats", function(len)
	local stat_table = net.ReadTable()

	if (PHATMINER_ORE_TYPES) then
		for k, v in pairs( stat_table ) do
			if (PHATMINER_ORE_TYPES[ k ]) then
				PHATMINER_ORE_TYPES[ k ].amount = tonumber(v)
			end
		end
	end
end )

MENU_ORES = MENU_ORES or {}
MENU_ORES.Panel = false
MENU_ORES.NextOpen = CurTime()
MENU_ORES.Material = Material( "vgui/gradient-l" )


MENU_ORES.createItem = function( iType, tItem, bShowDetail, pParent )

	local rAmount = ( tItem.amount or 1 ) * tItem.value
	local sAmount = 1

	local ore_button = vgui.Create( "DButton", pParent )
	ore_button:SetFont( "phatlabel" )
	ore_button:SetText( "" )
	ore_button:SetSize( 120, 75 )
	ore_button:Dock( TOP )
	ore_button:DockMargin( 5, 0, 0, 0 )
	ore_button:SetTextColor( tItem.color )

	if ( bShowDetail ) then
		ore_button.Paint = function( self )
			local wide, tall = self:GetWide(), self:GetTall()
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( 0, 0, wide, tall )
			draw.SimpleTextOutlined( sAmount, "phatlabel", 158, 30, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
			draw.SimpleTextOutlined( tItem.name or "Loading...", "phatlabel", 158, 10, tItem.color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER	, 2, Color(0,0,0) )
			draw.SimpleTextOutlined( string.format( "%s", tItem.amount ), "phatlabel", 76, 58, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
			draw.SimpleTextOutlined( string.format( "$%s", string.Comma( sAmount * tItem.value ) ), "phatlabel", 158, 48, Color(0,255,25), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
		end
	else
		ore_button.Paint = function( self )
			draw.SimpleTextOutlined( string.format( "%s", tItem.amount ), "phatlabel", 76, 58, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
		end
	end

	local ore_model = vgui.Create("DModelPanel", ore_button )
	ore_model:SetPos( 10, -8 )
	ore_model:SetSize( 100, 100 )
	ore_model:SetModel( tItem.model )
	ore_model:SetColor( tItem.color )
	ore_model:SetLookAt( Vector( 0 ,0 ,0 ) )
	ore_model:SetFOV(80)

	function ore_model:LayoutEntity( Entity )
		Entity:SetMaterial( tItem.mat )
		Entity:SetModelScale(5)
	end


	if ( bShowDetail ) then
		local bOreMinus = vgui.Create( "DButton", ore_button )
		bOreMinus:SetPos( 70, 45)
		bOreMinus:Dock( LEFT )
		bOreMinus:SetSize( 25, 25 )
		bOreMinus:SetTextColor( Color(255,0,0) )
		bOreMinus:SetFont("GModNotify")
		bOreMinus:SetText( "" )
		bOreMinus:SetIcon( "icon16/delete.png" )
		bOreMinus.DoClick = function( self )
			sAmount = math.Clamp( sAmount - 1, 0, tItem.amount )
		end

		local bOreAdd = vgui.Create( "DButton", ore_button )
		bOreAdd:SetPos( 140, 45)
		bOreAdd:Dock( RIGHT )
		bOreAdd:SetSize( 25, 25 )
		bOreAdd:SetTextColor( Color(0,255,0) )
		bOreAdd:SetFont("GModNotify")
		bOreAdd:SetText( "" )
		bOreAdd:SetIcon( "icon16/add.png" )
		bOreAdd.DoClick = function( self )
			sAmount = math.Clamp( sAmount + 1, 0, tItem.amount )
		end

		local bSell = vgui.Create( "DButton", ore_button )
		bSell:SetPos( 118, 60)
		bSell:SetSize( 40, 15 )
		bSell:SetTextColor( Color(0,200,0) )
		bSell:SetFont("DebugFixed")
		bSell:SetText( "SELL" )
		bSell.DoClick = function( self )
			net.Start("pm_oreexchange")
				net.WriteTable({
					[ iType ] = sAmount,
				})
				net.SendToServer()
		end

		local bDrop = vgui.Create( "DButton", ore_button )
		bDrop:SetPos( 26, 0)
		bDrop:SetSize( 40, 15 )
		bDrop:SetTextColor( Color(0,0,200) )
		bDrop:SetFont("DebugFixed")
		bDrop:SetText( "DROP" )
		bDrop.DoClick = function( self )
			net.Start("pm_dropore")
				net.WriteTable({
					[ iType ] = sAmount,
				})
				net.SendToServer()
		end

	end

	return ore_button

end


function openMinerMenu( bShowSellButtons )
	if ( CurTime() > MENU_ORES.NextOpen ) then
		MENU_ORES.NextOpen = CurTime() + 0.5

		if ( ValidPanel( MENU_ORES.Panel ) ) then
			MENU_ORES.Panel:MakePopup()
		else
			local wide, tall = ScrW(), ScrH()

			MENU_ORES.Panel = vgui.Create( "DFrame" )
			MENU_ORES.Panel:SetTitle("")
			MENU_ORES.Panel:SetSize( 200, 600 )
			MENU_ORES.Panel:Dock( RIGHT )
			MENU_ORES.Panel:DockMargin( 0, 0, 0, 0 )
			MENU_ORES.Panel:Center()

			MENU_ORES.Panel.Paint = function( self )
				local wide, tall = self:GetWide(), self:GetTall()
				surface.SetDrawColor( 25, 25, 25, 255 )
				surface.SetMaterial( MENU_ORES.Material )
				surface.DrawTexturedRect( 0, 0, wide, tall )
				surface.SetDrawColor( 25, 25, 25, 100 )
				surface.DrawRect( 0, 0, wide, tall )
			end

			local ore_scroller = vgui.Create( "DScrollPanel", MENU_ORES.Panel )
			ore_scroller:Dock( FILL )
			ore_scroller:DockMargin( 0, 0, 0, 0 )

			local sbar = ore_scroller:GetVBar()
			sbar:SetWidth(10)

			function sbar:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
			end
			function sbar.btnUp:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 100))
			end
			function sbar.btnDown:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 100))
			end
			function sbar.btnGrip:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
			end


			for k, vOre in pairs( PHATMINER_ORE_TYPES ) do
				if (vOre.amount and vOre.amount > 0) then
					local ore_button = MENU_ORES.createItem( k, vOre, true, MENU_ORES.Panel )
					ore_scroller:Add( ore_button )
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	openMinerMenu()
end

function SWEP:Reload()
	openMinerMenu()
end
