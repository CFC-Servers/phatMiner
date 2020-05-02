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
local menu_material = Material( "vgui/gradient-l" )

local function createItem( iType, tItem, bShowSell, pParent )

	local ore_button = vgui.Create( "DButton", pParent )
	ore_button:SetFont( "phatlabel" )
	ore_button:SetText( "" )
	ore_button:SetSize( 100, 75 )
	ore_button:Dock( TOP )
	ore_button:SetTextColor( tItem.color )
	ore_button.Paint = function( self )
		local wide, tall = self:GetWide(), self:GetTall()
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, wide, tall )

		draw.SimpleTextOutlined( tItem.name or "Loading...", "phatlabel", 120, 10, tItem.color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER	, 2, Color(0,0,0) )
		draw.SimpleTextOutlined( tItem.amount or "Loading...", "phatlabel", 120, 30, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )

		if ( bShowSellButtons ) then
			draw.SimpleTextOutlined( "$" .. ( tItem.amount or 0 * tItem.value ), "phatlabel", 70, 85, Color(0,255,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
		end

	end

	local ore_model = vgui.Create("DModelPanel", ore_button )
	ore_model:SetPos( -10, -8 )
	ore_model:SetSize( 100, 100 )
	ore_model:SetModel( tItem.model )
	ore_model:SetColor( tItem.color )
	ore_model:SetLookAt( Vector(0 ,0 ,0) )

	function ore_model:LayoutEntity( Entity )
		ore_model:SetFOV(80)

		Entity:SetMaterial( tItem.mat )
		Entity:SetModelScale(5)
	return end


	local sButton = vgui.Create( "DButton", ore_button )
	sButton:SetPos( 126, 4)
	sButton:SetSize( 55, 21 )
	sButton:SetTextColor( Color(255,85,25) )
	sButton:SetFont("GModNotify")
	sButton:SetText( "SELL" )
	sButton.DoClick = function( self )
		net.Start("pm_oreexchange")
		net.WriteTable({
			[ k ] = prButton.tQuantities[ prButton.iQuantity ],
		})
		net.SendToServer()
	end

	local dButton = vgui.Create( "DButton", ore_button )
	dButton:SetPos( 126, 30)
	dButton:SetSize( 55, 21 )
	dButton:SetTextColor( Color(25,85,255) )
	dButton:SetFont("GModNotify")
	dButton:SetText( "DROP" )
	dButton.DoClick = function( self )
		net.Start("pm_dropore")
		net.WriteTable({
			[ k ] = prButton.tQuantities[ prButton.iQuantity ],
		})
		net.SendToServer()
	end

	return ore_button

end

function openMinerMenu( bShowSellButtons )
	if (CurTime() > menu_next) then
		menu_next = CurTime() + 0.5

		if (not menu_ores) then
			local wide, tall = ScrW(), ScrH()

			menu_ores = vgui.Create( "DFrame" )
			menu_ores:SetTitle("")
			menu_ores:SetSize( 200, 600 )
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

			local prButton = vgui.Create( "DButton", menu_ores )
			prButton:SetPos(0, 0)
			prButton:SetFont("DermaLarge")
			prButton:SetTextColor( Color(0, 255, 0) )
			prButton:SetSize(70, 25)
			prButton.iQuantity = 1
			prButton.tQuantities = { [1]=1, [2]=5, [3]=10 }
			prButton:SetText( string.format( "(%ix)",  prButton.tQuantities[ prButton.iQuantity ] ) )

			prButton.DoClick = function( self )
				self.iQuantity = self.iQuantity + 1
				if (self.iQuantity > 3) then
					self.iQuantity = 1
				end

				prButton:SetText( string.format( "(%ix)",  prButton.tQuantities[ prButton.iQuantity ] ) )
			end


			if ( bShowSellButtons ) then
				menu_ores:MakePopup()
			end

			for k, vOre in pairs( PHATMINER_ORE_TYPES ) do
				local ore_button = createItem(1, vOre, bShowSellButtons, menu_ores)
				ore_scroller:Add( ore_button )
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
