
include('shared.lua')

ENT.AutomaticFrameAdvance = true
--[[
function ENT:Think()

	self:NextThink( CurTime() )
	return true
end]]

local _background_color = Color(0, 0, 0, 255)

surface.CreateFont('HornyTV_Title', {
	font = 'Arial',
	size = 14,
	weight = 500,
})

surface.CreateFont('HornyTV_Text', {
	font = 'Arial',
	size = 12,
	weight = 500,
})

cl_scp_914_r_status = "       Rough"

net.Receive( "914_status", function()
    cl_scp_914_r_status = net.ReadEntity()
end)

function ENT:Initialize()
	hook.Add('PostDrawTranslucentRenderables', self, function()
		local is_started = self:GetNWBool('StartedHorny', false)

		local position = self:GetPos()
		position = position + self:GetForward() * 8
		position = position + self:GetUp() * 10
		position = position + self:GetRight() * -4

		local rotation = self:GetAngles()
		rotation:RotateAroundAxis(self:GetForward(), 90)
		rotation:RotateAroundAxis(self:GetRight(), 0)
		rotation:RotateAroundAxis(self:GetUp(), 180)

		cam.Start3D2D(position, rotation, 0.25)
			-- draw.RoundedBox(0, 0, 0, 58, 73, Color(ColorRand()))

			if not is_started then
				surface.SetFont('HornyTV_Title')
				surface.SetTextPos(0, 20)
				surface.SetTextColor(255, 255, 255)
				surface.DrawText(cl_scp_914_r_status)

				surface.SetFont('HornyTV_Text')
				surface.SetTextPos(3, 35)
				surface.SetTextColor(255, 255, 255)
				surface.DrawText('Press "E" to use')
			else
				surface.SetDrawColor(_background_color)
				surface.SetMaterial(_background_color)
				surface.DrawTexturedRect(0, 0, 70, 60)
			end
		cam.End3D2D()
	end)
end

net.Receive( "914_OPEN_MENU", function()
  local ply = net.ReadEntity()
	local clrgray = Color( 198, 198, 198, 200 )
	local gradient = Material( "vgui/gradient-r" )
	local weapons_table = {

		[ 1 ] = { name = "Very Fine", class = "   Very Fine" },
		[ 2 ] = { name = "Fine", class = "        Fine" },
		[ 3 ] = { name = "1:1", class = "         1:1" },
		[ 4 ] = { name = "Coarse", class = "      Coarse" },
		[ 5 ] = { name = "Rough", class = "       Rough" }

	}
	BREACH.Demote.MainPanel = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel:SetSize( 256, 256 )
	BREACH.Demote.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
	BREACH.Demote.MainPanel:SetText( "" )
	BREACH.Demote.MainPanel.DieTime = CurTime() + 10
	BREACH.Demote.MainPanel.Paint = function( self, w, h )

		if ( !vgui.CursorVisible() ) then

			gui.EnableScreenClicker( true )

		end

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		if ( self.DieTime <= CurTime() ) then

			self.Disclaimer:Remove()
			self:Remove()
			gui.EnableScreenClicker( false )

		end

		concommand.Add( "close_914_panel", function( ply, cmd, args )
		self.Disclaimer:Remove()
		self:Remove()
		end )

	end

	BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
	BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - ( 128 * 1.5 ) )
	BREACH.Demote.MainPanel.Disclaimer:SetText( "" )

	local client = LocalPlayer()

	BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		draw.DrawText( "Панель управления SCP 914", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
	BREACH.Demote.ScrollPanel:Dock( FILL )

BREACH.Demote.Userss = BREACH.Demote.ScrollPanel:Add( "DButton" )
		BREACH.Demote.Userss:SetText( "" )
		BREACH.Demote.Userss:Dock( TOP )
		BREACH.Demote.Userss:SetSize( 256, 64 )
		BREACH.Demote.Userss:DockMargin( 0, 0, 0, 2 )
		BREACH.Demote.Userss.CursorOnPanel = false
		BREACH.Demote.Userss.gradientalpha = 0

		BREACH.Demote.Userss.Paint = function( self, w, h )

			if ( self.CursorOnPanel ) then

				self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 64 )

			else

				self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 128 )

			end

			draw.RoundedBox( 0, 0, 0, w, h, color_black )
			draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )

			surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
			surface.SetMaterial( gradient )
			surface.DrawTexturedRect( 0, 0, w, h )

			draw.SimpleText( "Запустить Процесс", "HUDFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end

		BREACH.Demote.Userss.OnCursorEntered = function( self )

			self.CursorOnPanel = true

		end

		BREACH.Demote.Userss.OnCursorExited = function( self )

			self.CursorOnPanel = false

		end

		BREACH.Demote.Userss.DoClick = function( self )

			--net.Start( "914_edit_status" )

				--net.WriteString( weapons_table[ i ].class )

			--net.SendToServer()

			--local mystring = "breach_keycard_1"
			--local number = string.len( mystring )
			--print( string.sub( mystring, number, number + 1  ) )

			--cl_scp_914_r_status = weapons_table[ i ].class

			   	net.Start( "914_run" )
				net.WriteEntity( ply )
				net.SendToServer()

			BREACH.Demote.MainPanel.Disclaimer:Remove()
			BREACH.Demote.MainPanel:Remove()
			gui.EnableScreenClicker( false )

		end

	for i = 1, #weapons_table do

		BREACH.Demote.Users = BREACH.Demote.ScrollPanel:Add( "DButton" )
		BREACH.Demote.Users:SetText( "" )
		BREACH.Demote.Users:Dock( TOP )
		BREACH.Demote.Users:SetSize( 256, 64 )
		BREACH.Demote.Users:DockMargin( 0, 0, 0, 2 )
		BREACH.Demote.Users.CursorOnPanel = false
		BREACH.Demote.Users.gradientalpha = 0

		BREACH.Demote.Users.Paint = function( self, w, h )

			if ( self.CursorOnPanel ) then

				self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 64 )

			else

				self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 128 )

			end

			draw.RoundedBox( 0, 0, 0, w, h, color_black )
			draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )

			surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
			surface.SetMaterial( gradient )
			surface.DrawTexturedRect( 0, 0, w, h )

			draw.SimpleText( weapons_table[ i ].name, "HUDFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end

		BREACH.Demote.Users.OnCursorEntered = function( self )

			self.CursorOnPanel = true

		end

		BREACH.Demote.Users.OnCursorExited = function( self )

			self.CursorOnPanel = false

		end

		BREACH.Demote.Users.DoClick = function( self )

    	cl_scp_914_r_status = weapons_table[ i ].class

			net.Start( "914_edit_status" )

        net.WriteString( weapons_table[ i ].name )
				--net.WriteEntity( weapons_table[ i ].name )

			net.SendToServer()

			BREACH.Demote.MainPanel.Disclaimer:Remove()
			BREACH.Demote.MainPanel:Remove()
			gui.EnableScreenClicker( false )

		end

	end

	

end )



function ENT:Draw()
	self:DrawModel()
end
