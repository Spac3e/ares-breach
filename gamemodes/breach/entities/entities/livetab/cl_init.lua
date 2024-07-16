include('shared.lua')

surface.CreateFont( "LiveTabMainFont", {

	font = "lztextinfo(RUS BY LYAJKA)",
	size = 45,
	weight = 700,
	antialias = true,
	shadow = false,
	outline = false,

} )

surface.CreateFont( "LiveTabMainFont_small", {

	font = "lztextinfo(RUS BY LYAJKA)",
	size = 35,
	weight = 700,
	antialias = true,
	shadow = false,
	outline = false,

} )

surface.CreateFont( "LiveTabMainFont_verysmall", {

	font = "lztextinfo(RUS BY LYAJKA)",
	size = 15,
	weight = 700,
	antialias = true,
	shadow = false,
	outline = false,

} )

local PizzaDay = Material( "nextoren/ads/pizza" )
local nukeicon = Material( "nextoren/nuke/nuke_redux" )
local Emergencybroadcasticon = Material( "nextoren_hud/overlay/broadcast.png" )

local clr_red = Color( 255, 0, 0 )

ENT.Statistics = {}

function ENT:UpdateFakeStats()

	self.Statistics = {}

	local players = player.GetAll()

	for i = 1, #players do

		local player = players[ i ]

		if ( player:GTeam() != TEAM_SPEC && player:Health() > 0 && !player:Outside() ) then

			local team = player:GTeam() + math.random( 1, 2 )

			if ( !self.Statistics[ team ] ) then

				self.Statistics[ team ] = 1

				continue
			end

			self.Statistics[ team ] = self.Statistics[ team ] + 1

		end

	end

end

function ENT:UpdateStats()

	self.Statistics = {}

	local players = player.GetAll()

	for i = 1, #players do

		local player = players[ i ]

		if ( player:GTeam() != TEAM_SPEC && player:Health() > 0 && !player:Outside() ) then

			local team = player:GTeam()

			if ( !self.Statistics[ team ] ) then

				self.Statistics[ team ] = 1

				continue
			end

			self.Statistics[ team ] = self.Statistics[ team ] + 1

		end

	end

end

local status = Color( 100, 100, 0 )
local channel_clr = Color( 0, 0, 180, 180 )
local max_distance = 300 * 300

function ENT:Draw()

	self:DrawModel()
--	local Distance = LocalPlayer():GetPos():DistToSqr( self:GetPos() )

	if ( LocalPlayer():IsLineOfSightClear( self ) ) then

		local oang = self:GetAngles()
	  local ang = self:GetAngles()

	  local pos = self:GetPos()

		local br_status = self:GetBroadcastStatus()

	  ang:RotateAroundAxis( oang:Up(), 90 )
	  ang:RotateAroundAxis( oang:Right(), -90 )
	  ang:RotateAroundAxis( oang:Up(), 90 )

	  cam.Start3D2D( pos + oang:Up() * 11 + oang:Right() * -3, ang, 0.07 )

			if ( preparing and br_status != true ) then

				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( PizzaDay )
				surface.DrawTexturedRect( -347, -32, 694, 380 )
			elseif ( br_status and br_status == true ) then

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( Emergencybroadcasticon )
				surface.DrawTexturedRect( -340, -38, 694, 380 )


			elseif ( GetGlobalBool( "NukeTime" ) ) then

				if ( timer.Exists( "NukeTimer" ) ) then

					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( nukeicon )
					surface.DrawTexturedRect( -54, 8, 128, 128 )

					draw.SimpleText( string.ToMinutesSeconds( timer.TimeLeft( "NukeTimer" ) ), "LZTextBig", 10, 190, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					draw.SimpleText( "Alpha warhead emergency detonation sequence engaged", "LiveTabMainFont_verysmall", 0, 260, Color( 255 * Fluctuate( 3 ), 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				else

					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( nukeicon )
					surface.DrawTexturedRect( -118, -12, 256, 256 )

				end

			else

				if ( ( self.NextStatsUpdate || 0 ) < CurTime() ) then

					self.NextStatsUpdate = CurTime() + 3

					if ( ( Monitors_Activated || 0 ) < 2 ) then

						self:UpdateStats()

					else

						self:UpdateFakeStats()

					end

				end

				if ( !self.SupportChannel ) then

					self.SupportChannel = tostring( math.Round( self:GetSupportChannel(), 1 ) )

				end

				draw.SimpleText( "MAIN INFO", "LiveTabMainFont", 0, 2, status, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Foundation OS v 1.0", "DermaDefaultBold", 280, -25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTE )
				draw.SimpleText( self.SupportChannel, "LiveTabMainFont", 295, 16, channel_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTE )
				draw.SimpleText( string.ToMinutesSeconds( cltime ), "LiveTabMainFont", 280, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Science Personnel: " .. ( self.Statistics[ TEAM_SCI ] || 0 ) + ( self.Statistics[ TEAM_SPECIAL ] || 0 ), "LiveTabMainFont_small", 0, 60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Millitary Personnel: " .. ( self.Statistics[ TEAM_GUARD ] || 0 ) + ( self.Statistics[ TEAM_CB ] || 0 ) + ( self.Statistics[ TEAM_OBR ] || 0 ), "LiveTabMainFont_small", 0, 130, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Class-D Personnel: " .. ( self.Statistics[ TEAM_CLASSD ] || 0 ), "LiveTabMainFont_small", 0, 200, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Unknown subjects: " .. ( self.Statistics[ TEAM_DZ ] || 0 ) + ( self.Statistics[ TEAM_CHAOS ] || 0 ) + ( self.Statistics[ TEAM_GOC ] || 0 ), "LiveTabMainFont_small", 0, 270, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				--[[if ( ( self.Statistics[ TEAM_SCP ] || 0 ) > 0 ) then

					draw.SimpleText( "SCP-Objects detected", "LiveTabMainFont_small", 0, 340, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				end]]--

			end
		cam.End3D2D()

	end

end
