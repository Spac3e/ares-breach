local TeamIcons = {
	[ TEAM_CLASSD ] = { mat = Material( "nextoren/gui/roles_icon/class_d.png" ) },
	[ TEAM_SCI ] = { mat = Material( "nextoren/gui/roles_icon/sci.png" ) },
	[ TEAM_SECURITY ] = { mat = Material( "nextoren/gui/roles_icon/sb.png" ) },
	[ TEAM_GUARD ] = { mat = Material( "nextoren/gui/roles_icon/mtf.png" ) },
	[ TEAM_NTF ] = { mat = Material( "nextoren/gui/roles_icon/ntf.png" ) },
	[ TEAM_CHAOS ] = { mat = Material( "nextoren/gui/roles_icon/chaos.png" ) },
	[ TEAM_GOC ] = { mat = Material( "nextoren/gui/roles_icon/goc.png" ) },
	[ TEAM_SPECIAL ] = { mat = Material( "nextoren/gui/roles_icon/sci_special.png" ) },
	[ TEAM_QRT ] = { mat = Material( "nextoren/gui/roles_icon/obr.png" ) },
	[ TEAM_DZ ] = { mat = Material( "nextoren/gui/roles_icon/dz.png" ) },
	[ TEAM_SCP ] = { mat = Material( "nextoren/gui/roles_icon/scp.png" ) },
	[ TEAM_USA ] = { mat = Material( "nextoren/gui/roles_icon/fbi.png" ) },
	[ TEAM_SPEC ] = { mat = Material( "nextoren/gui/roles_icon/sci.png" ) },
	[ TEAM_COTSK ] = { mat = Material( "nextoren/gui/roles_icon/scarlet.png" ) },
}

local clr_gray = Color( 198, 198, 198 )
local clr_green = Color( 0, 180, 0 )

local function UIU_Ending( complete )

	StopMusic()

	local status

	if ( complete ) then

		status = L"l:ending_mission_complete"
		BREACH.Music:Play(BR_MUSIC_UIU_WIN)

	else

		status = L"l:ending_mission_failed"
		BREACH.Music:Play(BR_MUSIC_UIU_LOOSE)

	end

	local client = LocalPlayer()

	local screenwidth, screenheight = ScrW(), ScrH()

	client.Ending_window = vgui.Create( "DPanel" )
	client.Ending_window:SetSize( screenwidth, screenheight )
	client.Ending_window.Name = L"l:cutscene_subject " .. client:GetNamesurvivor()
	if client:GetRoleName() == "UIU Spy" then
		client.Ending_window.Name = client.Ending_window.Name..L", l:cutscene_undercover_agent"
	end
	client.Ending_window.StartTime = CurTime()
	client.Ending_window.Status = L"l:cutscene_status " .. status
	client.Ending_window.Icon_Alpha = 0

	local screenmiddle_w, screenmiddle_h = screenwidth / 2, screenheight / 2

	local name_string_table, status_string_table = string.Explode( "", client.Ending_window.Name, true ), string.Explode( "", client.Ending_window.Status, true )

	local actual_string_1, actual_string_2 = "", ""

	client.Ending_window.Paint = function( self, w, h )
		
		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( self.Icon_Alpha < 255 ) then

			self.Icon_Alpha = math.Approach( self.Icon_Alpha, 255, RealFrameTime() * 256 )

		end

		surface.SetDrawColor( ColorAlpha( color_white, self.Icon_Alpha ) )
		surface.SetMaterial( TeamIcons[ TEAM_USA ].mat )
		surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #status_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. status_string_table[ #actual_string_2 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, desc_clr_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h, desc_clr_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 7 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )

			if ( self.alpha_variable == 0 ) then

				if ( !self.CallFade ) then

					self.CallFade = true
					StopMusic( 10 )

				end

			end

			self:SetAlpha( self.alpha_variable )

		end

	end

end

local goc_icon = Material( "nextoren/gui/roles_icon/goc.png" )
local goc_clr = Color( 0, 198, 198 )

function GOCStart()
	local client = LocalPlayer()
	client:ConCommand( "stopsound" )

	BREACH.Music:Play(BR_MUSIC_SPAWN_GOC)

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 24.2
	CutSceneWindow.Name = BREACH.TranslateString("l:cutscene_subject_name ") .. client:GetNamesurvivor()
	CutSceneWindow.Status = BREACH.TranslateString("l:cutscene_objective l:cutscene_disaster_relief")
	CutSceneWindow.Time = BREACH.TranslateString("l:cutscene_time_after_disaster ")..string.ToMinutesSeconds( GetRoundTime() - cltime )

	local ExplodedString3 = string.Explode( "", CutSceneWindow.Time, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Status, true )
	local ExplodedString = string.Explode( "", CutSceneWindow.Name, true )

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	CutSceneWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		if ( CutSceneWindow.StartTime <= CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, math.Clamp( self.StartAlpha - 40, 0, 255 ) ) )
			surface.SetMaterial( goc_icon )
			surface.DrawTexturedRect( ScrW() / 2 - 201, ScrH() / 2 - 201, 402, 402 )

			if ( CutSceneWindow.StartTime <= CurTime() - 6 ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 20 )
				if self.StartAlpha != 255 and self.DescPlayed != true then
					self.DescPlayed = true
					DrawNewRoleDesc()
					net.Start("ProceedUnfreezeSUP")
					net.SendToServer()
				end

			end

			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = SysTime() + .07
				str = str..ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = SysTime() + .07
				str1 = str1..ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = SysTime() + .07
				str2 = str2..ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 1.2, ColorAlpha( goc_clr, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_red, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( goc_clr, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_red, self.StartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( goc_clr, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_red, self.StartAlpha ) )

		end

		if ( self.StartAlpha <= 0 ) then

			StopMusic( 15 )
			--Show_Spy( client:Team() )
			self:Remove()			

		end

	end

end

local clr_text = Color( 180, 0, 0, 210 )
local onp_icon = TeamIcons[ TEAM_USA ].mat

function ONPStart()

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 2
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_subject_name " .. client:GetNamesurvivor()
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 23 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2 = "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( onp_icon )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 1.9 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_FBI)

		end

		if ( self.StartTime + 1 > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. time_string_table[ #actual_string_2 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
	
		if ( self.StartTime < CurTime() - 4 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end
			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

local dz_icon = TeamIcons[ TEAM_DZ ].mat

function SHStart()
	local clr_text = gteams.GetColor( TEAM_DZ )

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	timer.Simple( .25, function()

		surface.PlaySound( "nextoren/others/interdimension_travel.wav" )

	end )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 25
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_subject_name " .. client:GetNamesurvivor()
	client.Faction_intro.Status = BREACH.TranslateString"l:cutscene_objective l:cutscene_scp_rescue"
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 23 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local status_string_table = string.Explode( "", client.Faction_intro.Status, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2, actual_string_3 = "", "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime - 8 ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( dz_icon )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 6 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play( BR_MUSIC_SPAWN_DZ )

			timer.Simple( 40, function()

				StopMusic( 15 )


			end )

		end

		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #status_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. status_string_table[ #actual_string_2 + 1 ]

		elseif ( actual_string_3:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_3 = actual_string_3 .. time_string_table[ #actual_string_3 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .8, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_3, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 8 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

local cult_icon = TeamIcons[ TEAM_COTSK ].mat

function CultStart()

	local clr_text = gteams.GetColor( TEAM_COTSK )

	local client = LocalPlayer()

	if ( IsValid( client.Faction_intro ) ) then

		client.Faction_intro:Remove()

	end

	client:ConCommand( "stopsound" )

	timer.Simple( .25, function()

		surface.PlaySound( "nextoren/cultist_time_travel.ogg" )

	end )

	client.Faction_intro = vgui.Create( "DPanel" )
	client.Faction_intro:SetSize( ScrW(), ScrH() )
	client.Faction_intro.StartTime = CurTime() + 25
	client.Faction_intro.Name = BREACH.TranslateString"l:cutscene_name " .. client:GetNamesurvivor()
	client.Faction_intro.Status = BREACH.TranslateString"l:cutscene_objective l:cutscene_namaz"
	client.Faction_intro.Time = BREACH.TranslateString"l:cutscene_time_after_disaster " .. string.ToMinutesSeconds( GetRoundTime() - ( cltime - 23 ) )

	local name_string_table = string.Explode( "", client.Faction_intro.Name, true )
	local status_string_table = string.Explode( "", client.Faction_intro.Status, true )
	local time_string_table = string.Explode( "", client.Faction_intro.Time )

	local actual_string_1, actual_string_2, actual_string_3 = "", "", ""

	local screenmiddle_w, screenmiddle_h = ScrW() / 2, ScrH() / 2

	client.Faction_intro.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		if ( ( self.StartTime - 9 ) < CurTime() ) then

			surface.SetDrawColor( ColorAlpha( color_white, 210 ) )
			surface.SetMaterial( cult_icon )
			surface.DrawTexturedRect( screenmiddle_w - 128, screenmiddle_h - 128, 256, 256 )

		end

		if ( ( self.StartTime - 9 ) < CurTime() && !self.MusicPlaying ) then

			self.MusicPlaying = true
			BREACH.Music:Play(BR_MUSIC_SPAWN_CULT)

		end

		if ( self.StartTime > CurTime() ) then return end

		if ( actual_string_1:len() != #name_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_1 = actual_string_1 .. name_string_table[ #actual_string_1 + 1 ]

		elseif ( actual_string_2:len() != #status_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_2 = actual_string_2 .. status_string_table[ #actual_string_2 + 1 ]

		elseif ( actual_string_3:len() != #time_string_table && ( self.NextSymbol || 0 ) < CurTime() ) then

			self.NextSymbol = CurTime() + .025
			actual_string_3 = actual_string_3 .. time_string_table[ #actual_string_3 + 1 ]

		end

		draw.SimpleTextOutlined( actual_string_1, "MainMenuFont", screenmiddle_w, screenmiddle_h * .8, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_2, "MainMenuFont", screenmiddle_w, screenmiddle_h * .9, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( actual_string_3, "MainMenuFont", screenmiddle_w, screenmiddle_h, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )

		if ( self.StartTime < CurTime() - 8 ) then

			if ( !self.alpha_variable ) then

				self.alpha_variable = 255

			end

			self.alpha_variable = math.Approach( self.alpha_variable, 0, RealFrameTime() * 512 )
			if self.alpha_variable != 255 and self.DescPlayed != true then
				self.DescPlayed = true
				DrawNewRoleDesc()
				net.Start("ProceedUnfreezeSUP")
				net.SendToServer()
			end
			self:SetAlpha( self.alpha_variable )

		end

	end

end

local ci_icon = Material( "nextoren/gui/roles_icon/chaos.png" )
local ranktable = {
	[ "CI Commander" ] = "Capt.",
	[ "CI Demoman" ] = "SGT.",
	[ "CI Soldier" ] = "PVT.",
	[ "CI Juggernaut" ] = "CPL."
}

function CutScene()
	if GetGlobalBool("NoCutScenes", false) then return end

	APC_spawn_CI_Cutscene()

	local client = LocalPlayer()
	client:ConCommand( "stopsound" )

	timer.Simple(.4, function()
		BREACH.Music:Play( BR_MUSIC_SPAWN_CHAOS )
	end)

	local rank = ranktable[ client:GetRoleName() ]
	if rank == nil then
		rank = "ERROR"
	end

	local screenwidth, screenheight = ScrW(), ScrH()

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( screenwidth, screenheight )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 16
	CutSceneWindow.Name = rank .." " .. client:GetNamesurvivor()

	CutSceneWindow.Target = "Rescue Class-D Personnel"
	CutSceneWindow.Time = string.ToMinutesSeconds( GetRoundTime() - cltime ) .. " minutes after the Breach Event"

	local ExplodedString = string.Explode( "", CutSceneWindow.Target, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Name, true )
	local ExplodedString3 = string.Explode( "", CutSceneWindow.Time, true )

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	CutSceneWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		surface.SetDrawColor( ColorAlpha( color_white, self.StartAlpha ) )
		surface.SetMaterial( ci_icon )
		surface.DrawTexturedRect( screenwidth / 2 - 128, screenheight / 2 - 128, 256, 256 )

		if ( CutSceneWindow.StartTime <= CurTime() + 15 ) then

			if ( CutSceneWindow.StartTime <= CurTime() + 8 ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 128 )

				if self.StartAlpha != 255 and self.DescPlayed != true then
					self.DescPlayed = true
					DrawNewRoleDesc()
				end

			end

			local n_systime = SysTime()

			if ( ( self.NextSymbol || 0 ) <= n_systime && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = n_systime + .02
				str = str..ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= n_systime && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = n_systime + .02
				str1 = str1..ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbolTime || 0 ) <= n_systime && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = n_systime + .02
				str2 = str2..ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( clr_green, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( clr_green, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( clr_green, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )

		end

		if ( self.StartAlpha <= 0 ) then

			StopMusic( 16 )

			timer.Simple( 12, function()

				client.NoMusic = nil

			end )
			self:Remove()

		end

	end
end

local ci_icon = Material( "nextoren/gui/roles_icon/gru.png" )
local ranktable = {

	[ "GRU Commander" ] = "Капитан",
	[ "GRU Specialist" ] = "Прапорщик",
	[ "GRU Soldier" ] = "Сержант",
	[ "GRU Juggernaut" ] = "Лейтенант"

}

function GRUSpawn()

	local client = LocalPlayer()
	client:ConCommand( "stopsound" )
	
	BREACH.Music:Play( BR_MUSIC_SPAWN_GRU )

	local rank = ranktable[ client:GetRoleName() ]

	if rank == nil then
		rank = "ERROR"
	end

	local screenwidth, screenheight = ScrW(), ScrH()

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( screenwidth, screenheight )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 20
	CutSceneWindow.Name = rank .." " .. client:GetNamesurvivor()
	CutSceneWindow.Target = GRU_Objective || "ERROR!"
	CutSceneWindow.Time = string.ToMinutesSeconds( GetRoundTime() - cltime ) .. " времени после Н.У.С"

	local ExplodedString = utf8.Explode( "", CutSceneWindow.Target, true )
	local ExplodedString2 = utf8.Explode( "", CutSceneWindow.Name, true )
	local ExplodedString3 = utf8.Explode( "", CutSceneWindow.Time, true )

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	CutSceneWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		surface.SetDrawColor( ColorAlpha( color_white, self.StartAlpha ) )
		surface.SetMaterial( ci_icon )
		surface.DrawTexturedRect( screenwidth / 2 - 128, screenheight / 2 - 128, 256, 256 )

		if ( CutSceneWindow.StartTime <= CurTime() + 15 ) then

			if ( CutSceneWindow.StartTime <= CurTime() + 8 ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 128 )
				if self.StartAlpha != 255 and self.DescPlayed != true then
					self.DescPlayed = true
					DrawNewRoleDesc()
					--net.Start("ProceedUnfreezeSUP")
					--net.SendToServer()
				end
			end

			local n_systime = SysTime()

			if ( ( self.NextSymbol || 0 ) <= n_systime && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = n_systime + .08
				str = str..ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= n_systime && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = n_systime + .08
				str1 = str1..ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbolTime || 0 ) <= n_systime && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = n_systime + .08
				str2 = str2..ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( Color(255,0,0), self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( color_black, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( Color(255,0,0), self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( color_black, self.StartAlpha ) )
			--draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( Color(255,0,0), self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( color_black, self.StartAlpha ) )

		end

		if ( self.StartAlpha <= 0 ) then

			StopMusic( 10 )

			timer.Simple( 12, function()

				client.NoAutoMusic = nil

			end )

			--AresNotify("Ваша задача: "..tostring(GRU_Objective))

			self:Remove()

		end

	end

end

local function Ending( status )

	if ( status == "Evacuated by CI" ) then
		status = "l:cutscene_evac_by_ci"
		surface.PlaySound( "nextoren/vo/acp/survivor_escaped_" .. math.random( 1, 3 ) .. ".wav" )

	elseif ( status == "Evacuated by Helicopter" ) then
		status = "l:cutscene_evac_by_heli"
		surface.PlaySound( "nextoren/vo/chopper/chopper_evacuate_evacuated.wav" )

	end

	timer.Simple( 1, function()

		BREACH.Music:Play(BR_MUSIC_ESCAPED)

	end )

	local name



	name = LocalPlayer():GetNamesurvivor() 

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 15
	CutSceneWindow.Name = BREACH.TranslateString"l:cutscene_subject_name " .. name
	CutSceneWindow.Status = BREACH.TranslateString"l:cutscene_status " .. BREACH.TranslateString(status)
	CutSceneWindow.Time = BREACH.TranslateString"l:cutscene_last_report_time " .. tostring( os.date( "%X" ) ) .. " " .. tostring( os.date( "%d/%m/%Y" ) ) .. BREACH.TranslateString" ( l:cutscene_time_after_disaster_for_last_report_time " .. string.ToMinutesSeconds( cltime ) .. " )"

	local ExplodedString = string.Explode( "", CutSceneWindow.Time, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Status, true )
	local ExplodedString3 = string.Explode( "", CutSceneWindow.Name, true )

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	CutSceneWindow.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		if ( CutSceneWindow.StartTime <= CurTime() + 13 ) then

			if ( CutSceneWindow.StartTime <= CurTime() ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 80 )

				if ( self.StartAlpha <= 0 ) then

					StopMusic( 10 )
					self:Remove()

				end

			end

			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = SysTime() + .1
				str = str .. ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = SysTime() + .1
				str1 = str1 .. ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = SysTime() + .1
				str2 = str2 .. ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_green, self.StartAlpha ) )

		end

	end

end

net.Receive( "Ending_HUD", function()

	local status = net.ReadString()

    local client = LocalPlayer()

	local current_team = client:GTeam()

	if ( current_team != TEAM_USA ) then

		Ending( status )

		if ( status == "Subject was seen running out of the ''special'' monorail of the O5 council." ) then

			--BREACH.Music:Play( "sound/nextoren/B1.mp3", 1 )

		end

	else

		if ( status == "l:ending_mission_complete" ) then

			UIU_Ending( true )

		else

			UIU_Ending( false )

		end

	end

end )

local heliModel = Model( "models/comradealex/mgs5/hp-48/hp-48test.mdl" )
local light_origin = Vector( 14883.383789, 13000.545898, -15814.162109 )
local helicopter_angle = Angle( 0, -90, 0 )

function ClientSpawnHelicopter()
    local entcall = LocalPlayer()
    entcall.StopInventory = true

    local dlight = DynamicLight(entcall:EntIndex())
    if dlight then
        dlight.pos = light_origin
        dlight.r = 190
        dlight.g = 0
        dlight.b = 0
        dlight.brightness = 3
        dlight.Size = 900
        dlight.DieTime = CurTime() + 60
    end

    local helicopter = ents.CreateClientside("base_gmodentity")
    helicopter:SetModel(heliModel)
    helicopter:SetPos(light_origin)
    helicopter:SetAngles(helicopter_angle)

    timer.Simple(10, function()
        local snd = CreateSound(helicopter, "nextoren/others/helicopter/apache_hover.wav")
        snd:SetDSP(17)
        snd:Play()
		
        timer.Simple(29, function()
            if entcall and entcall:IsValid() and entcall:IsPlayer() then
                entcall.StopInventory = false
                timer.Simple(23, function()
                    if entcall and entcall:IsValid() and entcall:IsPlayer() then
                        StopMusic(9)
                        timer.Simple(6, function() BREACH.Music:PickGenericSong() end)
						helicopter:StopSound("nextoren/others/helicopter/apache_hover.wav")
                        helicopter:Remove()
                    end
                end)
            end
        end)
    end)

    util.ScreenShake(light_origin, 5, 1, 40, 1024)
    HelicopterStart()
end

function StartSceneClientSide( ply )

	local character = ents.CreateClientside( "base_gmodentity" )
	character:SetPos( Vector( -1981.652466, 5217.017090, 1459.548218 ) )
	character:SetAngles( Angle( 0, -90, 0 ) )
	character:SetModel( "models/cultist/humans/class_d/class_d.mdl" )
	character:Spawn()
	character:SetSequence( "photo_react_blind" )
	character:SetCycle( 0 )
	character:SetPlaybackRate( 1 )
	character.AutomaticFrameAdvance = true
	local cycle = 0
	character.Think = function( self )

		self:NextThink( CurTime() )
		self:SetCycle( math.Approach( cycle, 1, FrameTime() * 0.2 ) )
		cycle = self:GetCycle()
		return true

	end

	ply.InCutscene = true

	ply:SetNWEntity("NTF1Entity", character)

	local CI = ents.CreateClientside("base_gmodentity")
	CI:SetPos(Vector(-1983.983765, 4951.116211, 1459.224365))
	CI:SetAngles(Angle(0, 90, 0))
	CI:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI:SetMoveType(MOVETYPE_NONE)
    CI:SetBodygroup( 0, 0 )
    CI:SetBodygroup( 1, 1 )
	CI:Spawn()
	CI:SetColor( color_black )
	CI:SetSequence("LineIdle02")
	CI:SetPlaybackRate(1)
	CI.OnRemove = function( self )

		if ( self.BoneMergedEnts ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end

	ClientBoneMerge( CI, "models/cultist/humans/chaos/head_gear/beret.mdl" )
	ClientBoneMerge( CI, "models/cultist/humans/balaclavas_new/balaclava_full.mdl" )

	local handsid = CI:LookupAttachment('anim_attachment_RH')
	local hands = CI:GetAttachment( handsid )

	timer.Simple( 0.1, function()

		util.ScreenShake( vector_origin, 200, 100, 10, 355);

		LocalPlayer():ScreenFade(SCREENFADE.IN, color_white, 1, 1.2)

		LocalPlayer():EmitSound( "nextoren/others/bell.ogg" )

		--LocalPlayer():EmitSound( "nextoren/others/ending.ogg" )
	
	end )

	timer.Simple( 1, function()

	LocalPlayer():EmitSound( "nextoren/others/ending.ogg" )
	
	end )

	timer.Simple( 5, function()

		CI:EmitSound( "nextoren/vo/chaos/class_d_alternate_ending.ogg" )

	end )

	timer.Simple( 9, function()
		LocalPlayer():ScreenFade(SCREENFADE.IN, color_white, 1, 1.2)
		LocalPlayer():EmitSound( "nextoren/others/bell.ogg" )
	end )


	CI.AutomaticFrameAdvance = true


	CI.Think = function( self )

		self.NextThink = ( CurTime() )
		if ( self:GetCycle() >= 0.01 ) then self:SetCycle( 0.01 ) end

	end

	local cycle3 = 0
	local CI2 = ents.CreateClientside("base_gmodentity")
	CI2:SetPos(Vector(-1960.850830, 4894.328613, 1459.702515))
	CI2:SetAngles(Angle(0, 94, 0))
	CI2:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI2:SetMoveType(MOVETYPE_NONE)
	CI2:Spawn()
	CI2:SetColor( color_black )
	CI2:SetBodygroup( 0, 1 )
    CI2:SetBodygroup( 1, 0 )
    CI2:SetBodygroup( 2, 1 )
    CI2:SetBodygroup( 4, 0 )
	CI2:SetBodygroup( 5, 0 )
	CI2:SetSequence( "AHL_menuidle_SHOTGUN" )
	CI2:SetPlaybackRate( 1 )
	ClientBoneMerge( CI2, "models/cultist/humans/balaclavas_new/balaclava_full.mdl" )
	ClientBoneMerge( CI2, "models/cultist/humans/chaos/head_gear/helmet.mdl" )
	local handsid2 = CI2:LookupAttachment('anim_attachment_RH')
	local hands2 = CI2:GetAttachment( handsid )
	CI2.AutomaticFrameAdvance = true
	CI2.OnRemove = function( self )

		if ( self.BoneMergedEnts ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end


	local Weapon2 = ents.CreateClientside("base_gmodentity")
	Weapon2:SetModel("models/weapons/w_cw_kk_ins2_rpk_tac.mdl")
	Weapon2:SetPos(hands2.Pos)
	Weapon2:SetAngles(Angle(0,90,0))
	Weapon2:SetMoveType(MOVETYPE_NONE)
	Weapon2:Spawn()

    CI2.Think = function(self)
		if !CI2:IsValid() then return end
		self:NextThink( CurTime() )

		local handsid7 = CI2:LookupAttachment('anim_attachment_RH')
		local hands7 = CI2:GetAttachment( handsid )
        Weapon2:SetPos(hands7.Pos + Vector( 0, 8, 0 ) )
		self:SetCycle( math.Approach( cycle3, 1, FrameTime() * 0.15 ) )
		cycle3 = self:GetCycle()


		--CI2:SetPos(Vector(currentpos.x - 0.5, currentpos.y + 8, currentpos.z))



	end
	local cycle2 = 0
	local CI3 = ents.CreateClientside("base_gmodentity")
	CI3:SetPos(Vector(-2012.675903, 4894.200195, 1459.009277))
	CI3:SetAngles(Angle(0, 70, 0))
	CI3:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI3:SetMoveType(MOVETYPE_NONE)
	CI3:Spawn()
	CI3:SetBodygroup( 0, 1 )
    CI3:SetBodygroup( 1, 0 )
    CI3:SetBodygroup( 2, 1 )
    CI3:SetBodygroup( 4, 0 )
	CI3:SetBodygroup( 5, 0 )
	CI3:SetColor( color_black )
	CI3:SetSequence("MPF_adooridle")
	CI3:SetPlaybackRate(1)
	local handsid3 = CI3:LookupAttachment('anim_attachment_RH')
	local hands3 = CI3:GetAttachment( handsid )
	ClientBoneMerge( CI3, "models/cultist/humans/balaclavas_new/balaclava_full.mdl" )
	ClientBoneMerge( CI3, "models/cultist/humans/chaos/head_gear/helmet.mdl" )

	CI3.AutomaticFrameAdvance = true
	CI3.OnRemove = function( self )

		if ( self.BoneMergedEnts && istable( self.BoneMergedEnts ) ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end

	CI3.Think = function(self)

		self:NextThink( CurTime() )
		self:SetCycle( math.Approach( cycle2, 1, FrameTime() * 0.2 ) )
		cycle2 = self:GetCycle()


	end
	local Weapon3 = ents.CreateClientside("base_gmodentity")
	Weapon3:SetModel("models/weapons/w_cw_kk_ins2_rpk_tac.mdl")
	Weapon3:SetPos(hands3.Pos)
	Weapon3:SetAngles(Angle(0,80,0))
	Weapon3:SetMoveType(MOVETYPE_NONE)
	Weapon3:Spawn()


    timer.Simple( 11, function()

        Weapon2:Remove()
        Weapon3:Remove()
        CI:Remove()
        CI2:Remove()
        CI3:Remove()
		ply.InCutscene = false
		character:Remove()
		ply:SetNWEntity("NTF1Entity", NULL)

    end )

end
concommand.Add("CI_Anim_Escsp", StartSceneClientSide)

