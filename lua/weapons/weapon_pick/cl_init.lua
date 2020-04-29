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
				PHATMINER_ORE_TYPES[ k ].amount = v
			end
		end
	end
end )


local menu_ores = false
local menu_next = CurTime()
local menu_material = Material( "vgui/gradient-r" )

function openMinerMenu( bShowSellButtons )
	if (CurTime() > menu_next) then
		menu_next = CurTime() + 0.5

		if (not menu_ores) then
			local wide, tall = ScrW(), ScrH()

			menu_ores = vgui.Create( "DFrame" )
			menu_ores:SetTitle("")
			menu_ores:SetSize( 150, 600 )
			menu_ores:Dock( RIGHT )
			menu_ores:DockMargin( 0, 0, 0, 0 )
			menu_ores:Center()

			menu_ores.Paint = function( self )
				local wide, tall = self:GetWide(), self:GetTall()
				surface.SetDrawColor( 25, 25, 25, 255 )
				surface.SetMaterial( menu_material )
				surface.DrawTexturedRect( 0, 0, wide, tall )
				surface.SetDrawColor( 25, 25, 25, 100 )
				surface.DrawRect( 0, 0, wide, tall )
			end


			local ore_scroller = vgui.Create( "DScrollPanel", menu_ores )
			ore_scroller:Dock( FILL )

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
				local ore_button = vgui.Create( "DButton", menu_ores )
				ore_button:SetFont( "phatlabel" )
				ore_button:SetText( "" )
				ore_button:SetSize( 100, 100 )
				ore_button:Dock( TOP )
				ore_button:SetTextColor( vOre.color )
				ore_button.Paint = function( self )
					local wide, tall = self:GetWide(), self:GetTall()
					surface.SetDrawColor( 0, 0, 0, 255 )
					surface.DrawOutlinedRect( 0, 0, wide, tall )

					draw.SimpleTextOutlined( vOre.name or "Loading...", "phatlabel", 73, 34, vOre.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER	, 2, Color(0,0,0) )


					draw.SimpleTextOutlined( vOre.amount or "Loading...", "phatlabel", 70, 55, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )

					if ( bShowSellButtons ) then
						draw.SimpleTextOutlined( "Value: " .. ( vOre.amount * vOre.value ) or "Loading...", "phatlabel", 70, 75, Color(0,255,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
					end

				end

				if ( bShowSellButtons ) then

					local sButton = vgui.Create( "DButton", ore_button )
					sButton:Dock( TOP )
					sButton:SetFont( "DermaDefaultBold" )
					sButton:SetTextColor( Color(0,255,0) )
					sButton:SetText( string.format( "Sell 1x %s", vOre.name) )
					sButton.DoClick = function( self )
						net.Start("pm_oreexchange")
						net.WriteTable({
							[ k ] = 1,
						})
						net.SendToServer()
					end

				end

				ore_scroller:Add( ore_button )
			end

			if ( bShowSellButtons ) then
				menu_ores:MakePopup()
			end

		else
			menu_ores:Remove()
			menu_ores = nil
		end
	end
end

function SWEP:SecondaryAttack()
	openMinerMenu()
end

function SWEP:Reload()
	openMinerMenu()
end
