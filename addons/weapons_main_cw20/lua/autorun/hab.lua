--PreLoad
AddCSLuaFile( )

concommand.Add( "hab_debug", function( player, command, args )

	print( "_______________________________________" )
	print( "HAB Version:	"  ..  ( hab and hab.version or "Not Loaded" ) ) -- Version
	print( "---------------------------------------" )
	print( "Dedicated:	"  ..  tostring(game.IsDedicated( ) ) ) --Server?	
	print( "Singleplayer:	"  ..  tostring(game.SinglePlayer( ) ) ) --Singleplayer?
	print( "---------------------------------------" )
	print( "Map:	" .. game.GetMap( ) ) --Map Info
	print( "Ver:	" .. game.GetMapVersion( ) ) --Map Info
	print( "---------------------------------------" )
	print( "Players: " .. player.GetCount( ) ) -- Number of Players
	print( "Entities: " .. ents.GetCount( ) ) -- Number of Entities
	print( "OS:		" .. ( system.IsWindows( ) and "Windows" or system.IsLinux( ) and "Linux" or system.IsOSX( ) and "OSX" or "Undefined" ) ) -- OS?
	print( "Uptime:		" .. system.AppTime( ) ) -- Game Uptine
	print( "Country:	" .. system.GetCountry( ) ) -- System Country
	print( "---------------------------------------" )
	print( "Debug Called By " .. ( SERVER and "Server" or CLIENT and "Client" ) .. " On [" .. GetHostName( ) .. "]" ) -- Who Done it?
	print( "_______________________________________" )

end )

if game.SinglePlayer( ) then

	timer.Simple( 3.2, function( )

		if CLIENT then

			local sw, sh = ScrW( ), ScrH( )

			ErrorPannel = vgui.Create( "DFrame" )
				ErrorPannel:SetTitle( "HAB Not Loaded" )
				ErrorPannel:SetSize( sw * 0.8, sh * 0.8 )

				local w, h = ErrorPannel:GetWide( ), ErrorPannel:GetTall( )
				local x,y = ErrorPannel:GetSize( )

				ErrorPannel:ShowCloseButton( true )
				ErrorPannel:SetDraggable( false )
				ErrorPannel:SetDeleteOnClose( true )
				ErrorPannel:SetBackgroundBlur( true )
				ErrorPannel:Center( )
				ErrorPannel:MakePopup( )

			local html = vgui.Create( "DHTML" )
				html:SetParent( ErrorPannel )
				html:SetPos( w * 0.005, h * 0.03 )
				html:SetSize( x * 0.99,y * 0.96 )
				html:SetAllowLua( true )
				html:OpenURL( "http://steamcommunity.com/workshop/filedetails/discussion/853439552/135507548128987991/" )

		end

		if SERVER then

			PrintMessage( HUD_PRINTTALK, "HAB cannot be loaded into SinglePlayer!" )

		end

	end )

	hab = nil

	return

end

--Load
AddCSLuaFile( "hab/base.lua" )
include( "hab/base.lua" )