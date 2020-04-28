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
	local stat_name = net.ReadString()
	local amount = net.ReadInt(23)
	if (PHATMINER_ORE_TYPES) then 
		PHATMINER_ORE_TYPES[ stat_name ].amt = amount
	end
end )


local menu_ores = false
local menu_next = CurTime()
local menu_material = Material( "vgui/gradient-r" )

function SWEP:Reload()


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
			
			menu_ores.OnRemove = function()
				PHATMINER_HOVERED = false
			end
			
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
				ore_button:SetText( vOre.name )
				ore_button:SetSize( 100, 100 )
				ore_button:Dock( TOP )
				ore_button:SetTextColor( vOre.color )
				ore_button.Paint = function( self )
					local wide, tall = self:GetWide(), self:GetTall()
					surface.SetDrawColor(0, 0, 0, 255)
					surface.DrawOutlinedRect(0, 0, wide, tall)

					
					draw.SimpleTextOutlined( vOre.amt or "0", "phatlabel", 64, 64, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0, Color(0,0,0) )		
					
					if ( self:IsHovered() ) then 
						PHATMINER_HOVERED = self
					end
				
				end
				
				
				
				ore_scroller:Add( ore_button )
			end
		else 
			menu_ores:Remove()
			menu_ores = nil
		end 
	end
end 