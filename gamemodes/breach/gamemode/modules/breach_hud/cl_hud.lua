local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player

/*
local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudDeathNotice = true,
	CHudPoisonDamageIndicator = true,
	CHudSquadStatus = true,
	CHudWeaponSelection = true,
	CHudCrosshair = true,
	CHudDamageIndicator = true,
	CHUDQuickInfo = true,
	CHudVoiceStatus = true,
	CHUDAutoAim = true,
	CHudVoiceSelfStatus = true,
	CHudChat = true
} */


local custom_vector = Vector( 1, 1, 1 )

hook.Remove("HUDPaint", "BreachTEST")

local ANGLE = FindMetaTable( "Angle" )

local client = LocalPlayer()

net.Receive("create_Headshot", function(len)

	local en = net.ReadEntity()
	local origin = net.ReadVector()
	local Normal = net.ReadVector()

	local efdata = EffectData()
	efdata:SetEntity(en)
	efdata:SetOrigin(origin)
	efdata:SetNormal(Normal)
	util.Effect( "headshot", efdata )

end)

local clr_green = Color( 0, 255, 0 )

function NewProgressLevelBar( stats, my_xp )

	local client = LocalPlayer()
	local total_exp = 0

	for _, v in ipairs( stats ) do

		v.value = math.floor( v.value )

		total_exp = total_exp + v.value

	end

	--[[
	if ( client:GetUserGroup() == "premium" ) then

		stats[ #stats + 1 ] = { reason = "Premium bonus", value = math.abs( total_exp ) }

	end]]

	table.SortByMember( stats, "value", true )

	if ( !BREACH.Level ) then

		BREACH.Level = {}

	end

	local screenwidth, screenheight = ScrW(), ScrH()

	BREACH.Level.main_panel = vgui.Create( "DPanel" )
	BREACH.Level.main_panel:SetSize( screenwidth * .6, 32 )
	BREACH.Level.main_panel:SetPos( screenwidth * .2, screenheight * .85 )
	BREACH.Level.main_panel.StartValue =  my_xp || 0
	BREACH.Level.main_panel.Value = my_xp || 0
	BREACH.Level.main_panel.DebugTime = CurTime() + 15
	BREACH.Level.main_panel.Maximum = client:RequiredEXP()
	BREACH.Level.main_panel.Removing = false

	BREACH.Level.main_panel.Paint = function( self, w, h )

		if ( self.Removing || self.DebugTime < CurTime() ) then

			self:SetAlpha( math.Approach( self:GetAlpha(), 0, RealFrameTime() * 512 ) )

			if ( self:GetAlpha() == 0 ) then

				self:Remove()
                BREACH.Level.main_panel = nil
                BREACH.Level.EXP_Panel_Child = nil
                BREACH.Level.EXP_Panel_Table = nil

			end

		end

		draw.RoundedBox( 0, 0, 0, w, h, color_black )

		draw.RoundedBox( 0, 2, 2, w * ( self.Value / self.Maximum ) - 4, h - 4, color_white )

		draw.SimpleText( self.Value .. " / " .. self.Maximum, "HUDFontTitle", w / 2, h / 2, clr_green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	BREACH.Level.EXP_Panel_Table = stats

	BREACH.Level.EXP_Panel = vgui.Create( "DPanel" )
	BREACH.Level.EXP_Panel:SetSize( screenwidth * .6, 128 )
	BREACH.Level.EXP_Panel:SetPos( screenwidth * .2, screenheight * .85 - 128 )
	BREACH.Level.EXP_Panel.Paint = function( self, w, h ) end

	BREACH.Level.EXP_Panel_Child = {}

	local exp_panel_width, exp_panel_height = BREACH.Level.EXP_Panel:GetSize()
	for i = 1, #BREACH.Level.EXP_Panel_Table do

		BREACH.Level.EXP_Panel_Child[ i ] = vgui.Create( "DPanel", BREACH.Level.EXP_Panel )
		BREACH.Level.EXP_Panel_Child[ i ].Value = BREACH.Level.EXP_Panel_Table[ i ].value
		BREACH.Level.EXP_Panel_Child[ i ].Reason = BREACH.Level.EXP_Panel_Table[ i ].reason
		BREACH.Level.EXP_Panel_Child[ i ].ID = i

		if ( BREACH.Level.EXP_Panel_Child[ i ].Value < 0 ) then

			BREACH.Level.EXP_Panel_Child[ i ].clr = Color( 255, 0, 0 )

		else

			BREACH.Level.EXP_Panel_Child[ i ].clr = Color( 0, 255, 0 )

		end

		surface.SetFont( "HUDFont" )

		local text_to_print

		if ( BREACH.Level.EXP_Panel_Child[ i ].Value > 0 ) then

			text_to_print = BREACH.Level.EXP_Panel_Child[ i ].Reason .. " +" .. BREACH.Level.EXP_Panel_Child[ i ].Value

		else

			text_to_print = BREACH.Level.EXP_Panel_Child[ i ].Reason .. " -" .. BREACH.Level.EXP_Panel_Child[ i ].Value

		end

		local reason_width, reason_height = surface.GetTextSize( text_to_print )

		BREACH.Level.EXP_Panel_Child[ i ]:SetPos( exp_panel_width / 2, exp_panel_height / 2 - reason_height / 2 )
		BREACH.Level.EXP_Panel_Child[ i ]:SetSize( reason_width+1000, reason_height )
		BREACH.Level.EXP_Panel_Child[ i ].CreationTime = RealTime() + 3

		if ( i == 1 ) then

			BREACH.Level.EXP_Panel_Child[ i ].Play = true

		end

		BREACH.Level.EXP_Panel_Child[ i ].Paint = function( self, w, h )

			if ( self.ShouldMove ) then

				self.ShouldMove = false
				self:MoveTo( exp_panel_width / 2, exp_panel_height / 2 - reason_height / 2, .1, 0, -1, function()

					self.Play = true

				end )

			end

            if ( !IsValid( BREACH.Level.EXP_Panel ) ) then

                self:Remove()

            end

			if ( !self.Play ) then

				if ( !self.PosSet ) then

					self.PosSet = true
					self:SetPos( exp_panel_width / 2, exp_panel_height / 2 - reason_height / 2 - ( reason_height * ( i - 1 ) ) )

				end

				self.font = "LevelBarLittle"
				self:SetAlpha( 100 )

			else

				self:SetAlpha( 255 )
				self.font = "LevelBar"

			end

			if ( self.Play && self.CreationTime < RealTime() ) then

				if ( !self.ToReach ) then

					self.ToReach = BREACH.Level.main_panel.Value + self.Value

				end

                if ( !BREACH.Level.main_panel ) then self:Remove() return end

				BREACH.Level.main_panel.Value = math.Round( math.Approach( BREACH.Level.main_panel.Value, self.ToReach, RealFrameTime() * 1024 ) )

				if ( BREACH.Level.main_panel.Value >= BREACH.Level.main_panel.Maximum ) then

					self.ToReach = self.ToReach - BREACH.Level.main_panel.Value

					BREACH.Level.main_panel.Value = 0
					BREACH.Level.main_panel.Maximum = client:RequiredEXP() + (client:RequiredEXP() / client:GetNLevel())
					BREACH.Level.main_panel.StartValue = 0

				end

				if ( BREACH.Level.main_panel.Value == self.ToReach && !self.StartMoving ) then

					self.StartMoving = true

					self:MoveTo( exp_panel_width / 2, exp_panel_height, .5, 0, -1, function()

						table.remove( BREACH.Level.EXP_Panel_Child, self.ID )

						for k, v in ipairs( BREACH.Level.EXP_Panel_Child ) do

                            v.ID = k

							if ( k != 1 ) then

								BREACH.Level.EXP_Panel_Child[ k ]:MoveTo( exp_panel_width / 2, exp_panel_height / 2 - reason_height / 2 - ( reason_height * ( k - 1 ) ), .1, 0, -1, function() end )

							end

						end

						if ( BREACH.Level.EXP_Panel_Child[ 1 ] ) then

							BREACH.Level.EXP_Panel_Child[ 1 ].ShouldMove = true

						end

						if ( #BREACH.Level.EXP_Panel_Child == 0 ) then

							BREACH.Level.main_panel.Removing = true

							BREACH.Level.EXP_Panel:Remove()

                            if ( BREACH.Level && BREACH.Level.EXP_Panel ) then

							  BREACH.Level.EXP_Panel = nil

                            end

						end

						self:Remove()

					end )

				end

			end

			surface.SetFont( self.font )
			surface.SetTextColor( self.clr )
			surface.SetTextPos( 0, 0 )

			if ( self.clr == color_white ) then

				if ( self.ToReach ) then

					surface.DrawText( BREACH.TranslateString(self.Reason) .. " " .. self.ToReach - BREACH.Level.main_panel.Value )

				else

					surface.DrawText( BREACH.TranslateString(self.Reason) .. " " .. self.Value )

				end

			else

				if ( !self.ToReach ) then

					surface.DrawText( BREACH.TranslateString(self.Reason) .. " " .. self.Value )

				else

					surface.DrawText( BREACH.TranslateString(self.Reason) .. " " .. self.ToReach - BREACH.Level.main_panel.Value )

				end

			end

		end

	end

end

local banned_Teams = {

  [ TEAM_SPEC ] = true,
  [ TEAM_SCP ] = true

}

local LCSpacing = -30
local wepclr = Color( 198, 198, 198, 210 )
local txtclr = Color( 127, 127, 127, 180 )

local scp_049_text_col1 = Color( 0, 180, 127, 180 )
local scp_049_text_col2 = Color( 200, 127, 127, 180 )
local chaoscolor = Color(29, 81, 56)

hook.Add("PreDrawOutlines", "CHAOS_SPY", function()

	local client = LocalPlayer()
  local client_team = client:GTeam()
  --local cl_pos = client:GetPos()

  local plys = player.GetAll()
  if client_team == TEAM_CHAOS or client_team == TEAM_CLASSD then
	  for i = 1, #plys do

	  	local ply = plys[i]

	  	if ply == client then continue end
	  	if ply:GetRoleName() != role.SECURITY_Spy then continue end
	  	if ply:Health() < 0 then continue end

	  	--if ply:GetPos():DistToSqr(cl_pos) > 25000 then continue end

			local entstab = ply:LookupBonemerges()
			entstab[#entstab + 1] = ply

			outline.Add(entstab, chaoscolor, OUTLINE_MODE_VISIBLE)

	  end
	end
end)

local green = Color(0, 255, 0)
local black = Color(0, 0, 0)
local red = Color(255, 0, 0)
local backgroundmat = Material( "nextoren_hud/inventory/menublack.png" )
hook.Add("HUDPaint", "DrawBoxInfoOnRagdoll", function()

  local client = LocalPlayer()
  local client_team = client:GTeam()

  if ( banned_Teams[ client_team ] && client:GetRoleName() != "SCP049" || client:Health() <= 0 ) then return end

	local tr = client:GetEyeTrace()

	local ent = tr.Entity

	if ( !( ent && ent:IsValid() ) ) then return end

  local is_wep = ent:IsWeapon()

  if ( ent:GetClass() != "prop_ragdoll" && !is_wep ) then return end

	local Distance = ent:GetPos():DistToSqr( client:GetPos() )

  if ( Distance <= 6400 && is_wep ) then

    local tab = { ent }
    outline.Add( tab, wepclr, OUTLINE_MODE_VISIBLE )

  elseif ( Distance <= 2500 && client:HasWeapon( "weapon_scp_049_redux" ) ) then

    local tab = { ent }
    outline.Add( tab, wepclr, OUTLINE_MODE_VISIBLE )

    local screenheight = ScrH()

    local x_text = ScrW() / 2

	if ent:GetNWBool("Death_SCP049_IsVictim", false) then
		if ent:GetNWBool("Death_SCP049_CanRessurect", false) then
    		draw.SimpleText( "Жертва всё ещё жива.", "LC.MenuFont", x_text, screenheight / 2.6, scp_049_text_col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    		draw.SimpleText( "Нажмите \"Е\" для превращения игрока в своего прислужника", "LC.MenuFont", x_text, screenheight / 2.3, txtclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    		draw.SimpleText( "Нажмите \"R\" для убийства игрока ( Это восстановит Вам 125 здоровья )", "LC.MenuFont", x_text, screenheight / 2, scp_049_text_col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "Жертва погибла", "LC.MenuFont", x_text, screenheight / 2, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	elseif ( Distance <= 2500 && !IsValid( LC_LootMenu ) && client_team != TEAM_SCP ) then

    local tab = { ent }
    local bnmrgtab = ents.FindByClassAndParent("breach_bonemerge", ent)
	if istable(bnmrgtab) then
		tab = bnmrgtab
		tab[#tab + 1] = ent
	end
		outline.Add( tab, wepclr, OUTLINE_MODE_VISIBLE )

    local screenwidth, screenheight = ScrW(), ScrH()

    local middle_w = screenwidth / 2
    local middle_h = screenheight / 2

    draw.Blur(middle_w-175, middle_h-28, 350, 75)
		surface.SetDrawColor( 0, 0, 0, 100)
		surface.DrawRect( middle_w-176, middle_h-29, 352, 77)
		surface.SetMaterial(backgroundmat)
		surface.DrawTexturedRect( middle_w-175, middle_h-28, 350, 75)

		local body_time = ent:GetNWInt("DiedWhen", false)
		local minutes = BREACH.TranslateString("l:body_cant_determine_death_time")
		if body_time then
			local timesincedeath = os.time() - body_time
			minutes = timesincedeath / 60

			if minutes < 1 then
				minutes = BREACH.TranslateString("l:body_died_right_now")
			else
				minutes = math.Round(minutes)
				local lastdigit = math.floor(minutes%10)
				local realstring
				if minutes >= 10 and minutes <= 20 or lastdigit > 4 then
					realstring = "  l:body_minutes_ago"
				elseif lastdigit == 1 then
					realstring = "  l:body_1minute_ago"
				elseif lastdigit > 1 and lastdigit < 5 then
					realstring = "  l:body_2to4minutes_ago"
				end

				minutes = BREACH.TranslateString("l:body_death_happened  "..math.Round(minutes)..realstring)
			end
		end

		draw.SimpleTextOutlined( ent:GetNWString("SurvivorName", ""), "HUDFont", middle_w, screenheight / 2.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, black)
    	draw.SimpleTextOutlined(BREACH.TranslateString(ent:GetNWString("DeathReason1", "l:body_death_unknown")), "HUDFont", middle_w, screenheight / 1.95 + 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, black)
		draw.SimpleTextOutlined( BREACH.TranslateString(ent:GetNWString("DeathReason2", "")), "HUDFont", middle_w, screenheight / 1.95 + 18, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, black)
		draw.SimpleText( input.LookupBinding("+use") and string.upper(input.LookupBinding("+use")) or "+use", "HUDFont", middle_w + LCSpacing-5, middle_h - 15, green, 0, 1)
		draw.SimpleTextOutlined( BREACH.TranslateString(" - l:body_search"), "HUDFont", middle_w + LCSpacing, middle_h - 15, color_white, 0, 1, 0.5, black)
		draw.SimpleTextOutlined( minutes, "HUDFont", middle_w, middle_h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, black)

	end

end)

net.Receive("LevelBar", function()
	local client = LocalPlayer()
	local stats = net.ReadTable()
	local exp = net.ReadUInt(32)
	NewProgressLevelBar(stats, exp)
end)

local Dead_Body = false
local Death_Scene = false
local Death_Blur_Intensity = 0
local Death_Desaturation_Intensity = 1

--local alpha_color = 0
--local final_color = 255
local clr_blood = Color(102, 0, 0)
local clr_red = Color(255, 0, 0)
local clr_gray = Color( 198, 198, 198 )
function CorpsedMessage(msg)
	--[[
	alpha_color = 0
	final_color = 255
    hook.Add( "HUDPaint", "CorpsedMessage", function()
		alpha_color = math.Approach(alpha_color, final_color, RealFrameTime() * 256)
		if alpha_color == final_color then
			if !timer.Exists("SetCorpsedMesage_Hold") then
				timer.Create("SetCorpsedMesage_Hold", 2.5, 1, function()
					final_color = 0
				end)
			end
		end
			if msg2 == false then
        draw.SimpleText( msg3, "ScoreboardContent", ScrW() / 2, ScrH() / 2, Color(102, 0, 0, alpha_color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( msg, "ScoreboardContent", ScrW() / 2, ScrH() / 2-20, Color(102, 0, 0, alpha_color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
       else
       	draw.SimpleText( msg3, "ScoreboardContent", ScrW() / 2, ScrH() / 2, Color(102, 0, 0, alpha_color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( msg2, "ScoreboardContent", ScrW() / 2, ScrH() / 2-20, Color(col.r, col.g, col.b, alpha_color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( msg, "ScoreboardContent", ScrW() / 2, ScrH() / 2-20-20, Color(102, 0, 0, alpha_color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
    end )

	timer.Remove("SetCorpsedMessage_Disappear")
	timer.Remove("SetCorpsedMesage_Hold")

    timer.Create( "SetCorpsedMessage", 5, 1, function()
        hook.Remove( "HUDPaint", "CorpsedMessage" )
    end )
	--]]

	local col = gteams.GetColor(LocalPlayer():GTeam())

	if !msg then
		msg = BREACH.TranslateString("l:cutscene_kia")
	end

	local name

	if LocalPlayer():GTeam() == TEAM_SCP then
		name = BREACH.TranslateString("l:cutscene_subject ")..GetLangRole(LocalPlayer():GetRoleName())
	else
		name = BREACH.TranslateString("l:cutscene_subject_name ")..LocalPlayer():GetNamesurvivor().. " - "..GetLangRole(LocalPlayer():GetRoleName())
	end

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 8
	CutSceneWindow.Name = name
	CutSceneWindow.Status = BREACH.TranslateString("l:cutscene_status ")..msg
	CutSceneWindow.Time = BREACH.TranslateString("l:cutscene_last_report_time ") .. tostring( os.date( "%X" ) ) .. " " .. tostring( os.date( "%d/%m/%Y" ) ) .. BREACH.TranslateString" ( l:cutscene_time_after_disaster_for_last_report_time " .. string.ToMinutesSeconds( cltime ) .. " )"

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

		--draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		if ( CutSceneWindow.StartTime <= CurTime() + 6 ) then

			if ( CutSceneWindow.StartTime <= CurTime() ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 80 )

				if ( self.StartAlpha <= 0 ) then

					StopMusic( 10 )
					self:Remove()

				end

			end

			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = SysTime() + .03
				str = str .. ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = SysTime() + .03
				str1 = str1 .. ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = SysTime() + .03
				str2 = str2 .. ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( col, self.StartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blood, self.StartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( clr_gray, self.StartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blood, self.StartAlpha ) )

		end

	end
end

local function FirstPerson_CutScene(ply, pos, angles, fov)
	if Dead_Body then
		local target = Dead_Body

		if !IsValid(target) then
			return
		end

		local head = target:GetAttachment( target:LookupAttachment( "eyes" ) )
		local view = {}
		if head then
			view.origin = head.Pos + head.Ang:Forward() * -5
			view.angles = head.Ang
		end
		local target = Dead_Body

		if !timer.Exists("DeathScene_RestoreHead_"..target:EntIndex()) then
			timer.Create("DeathScene_RestoreHead_"..target:EntIndex(), 8, 1, function()
				if !IsValid(target) then
					return
				end

				Dead_Body = false

				local matrix

				  for bone = 0, ( target:GetBoneCount() || 1 ) do
					if target:GetBoneName( bone ):lower():find( "head" ) then
						  matrix = target:GetBoneMatrix( bone )
						  target:ManipulateBoneScale(bone, Vector(1,1,1))
						  break
					end
				  end

				  if ( IsValid( matrix ) ) then
					matrix:SetScale(Vector(1,1,1))
				end
			end)
		end
		Death_Blur_Intensity = math.Approach(Death_Blur_Intensity, 10, 0.05)
		Death_Desaturation_Intensity = math.Approach(Death_Desaturation_Intensity, 0, 0.01)

		local matrix

		  for bone = 0, ( target:GetBoneCount() || 1 ) do
			if target:GetBoneName( bone ):lower():find( "head" ) then
				  matrix = target:GetBoneMatrix( bone )
				  target:ManipulateBoneScale(bone, vector_origin)
				  break
			end
		  end

		  if ( IsValid( matrix ) ) then
			matrix:SetScale( vector_origin )
		end
		view.fov = fov
		view.drawviewer = true
		return view
	end

	if ply && ply:GetNWEntity("NTF1Entity", NULL) != NULL then
		local target = ply:GetNWEntity("NTF1Entity", NULL)
		local view = {}
		local head = target:GetAttachment( target:LookupAttachment( "eyes" ) )
		if head then
			if target == ply then
				view.origin = head.Pos + head.Ang:Up() * 5 + head.Ang:Forward() * 5
				view.angles = head.Ang

			elseif target:GetClass() == "ntf_cutscene_2" then
				view.origin = head.Pos
				view.angles = head.Ang - Angle(0, -70, 0)
			else
				view.origin = head.Pos + head.Ang:Forward() * -5
				view.angles = head.Ang
			end
		end

		view.fov = fov
		view.drawviewer = true
		return view

	end

	--[[
	if ply and Dead_Body then
		local target = Dead_Body
		local view = {}
		local head = target:GetAttachment( target:LookupAttachment( "eyes" ) )
		Death_Blur_Intensity = math.Approach(Death_Blur_Intensity, 10, 0.05)
		Death_Desaturation_Intensity = math.Approach(Death_Desaturation_Intensity, 0, 0.01)
		if head then
				view.origin = head.Pos + head.Ang:Forward() * -5
				view.angles = head.Ang
		end

		local matrix

	  for bone = 0, ( Dead_Body:GetBoneCount() || 1 ) do

	    if Dead_Body:GetBoneName( bone ):lower():find( "head" ) then

	      matrix = Dead_Body:GetBoneMatrix( bone )
	      Dead_Body:ManipulateBoneScale(bone, vector_origin)

	      break

	    end

	  end

	  	if ( IsValid( matrix ) ) then

	    	matrix:SetScale( vector_origin )

    	end
		view.fov = fov
		view.drawviewer = false
		return view

	end
	--]]
end
hook.Add( "CalcView", "FirstPerson_CutScene", FirstPerson_CutScene )

hook.Add( "CalcView", "firstpersondeathkk", function( ply, origin, angles, fov )

  if ( ply:GetNWEntity( "NTF1Entity" ) == NULL ) then return end

	local ragdoll = ply:GetNWEntity( "NTF1Entity" )

	if ( !( ragdoll && ragdoll:IsValid() ) ) then return end
	local head = ragdoll:LookupAttachment( "eyes" )
	head = ragdoll:GetAttachment( head )

	local view = {}

	if ( !head || !head.Pos ) then return end

	if ( !ragdoll.BonesRattled ) then

	  ragdoll.BonesRattled = true
	  ragdoll:InvalidateBoneCache()
	  ragdoll:SetupBones()
	  local matrix

	  -- Breaks bonemerge bone 'head' position, overall - not soo needed, does nothing.
	  --[[
	  for bone = 0, ( ragdoll:GetBoneCount() || 1 ) do

	    if ragdoll:GetBoneName( bone ):lower():find( "head" ) then

	      matrix = ragdoll:GetBoneMatrix( bone )
	      ragdoll:ManipulateBoneScale(bone, vector_origin)

	      break

	    end

	  end
	  --]]

	  if ( IsValid( matrix ) ) then

	    matrix:SetScale( vector_origin )

    end

	end

	view.origin = head.Pos + head.Ang:Up() * 5 + head.Ang:Forward() * 5
	view.angles = head.Ang
  	view.drawviewer = true

	return view
end )

local Death_Anims = {
	"wos_bs_shared_death_neck_slice",
	"wos_bs_shared_death_belly_slice_side",
	"wos_bs_shared_death_belly_slice",
}

function Death_Scene( ply )
	if LocalPlayer():GTeam() == TEAM_ARENA then
		return
	end

	LocalPlayer():SetNWEntity("NTF1Entity", NULL)

	StopMusic()

	local camtorag = net.ReadBool()
	local sent_rag = net.ReadEntity()

	if LocalPlayer():GTeam() == TEAM_SCP then
		camtorag = true
	end

	hook.Run("CalcView", LocalPlayer(), EyePos(), EyeAngles(), LocalPlayer():GetFOV(), 0, 0)

	if !camtorag then

	Death_Scene = true
	Dead_Body = ents.CreateClientside( "base_gmodentity" )
	Death_Blur_Intensity = 0
	Death_Desaturation_Intensity = 1
		
	local dead_pos = LocalPlayer():GetPos()

	Dead_Body:SetPos( dead_pos )

	Dead_Body:SetAngles( Angle(0, LocalPlayer():GetAngles().y, 0) )
	
	Dead_Body:SetModel(  LocalPlayer():GetModel()  )
	Dead_Body:SetBodyGroups(LocalPlayer():GetBodyGroupsString())
	Dead_Body:Spawn()
	local sequence = table.Random( Death_Anims )
	Dead_Body:SetSequence(  sequence  )
	Dead_Body:SetCycle( 0 )
	Dead_Body:SetPlaybackRate( 0.5 )
	Dead_Body.AutomaticFrameAdvance = true
	
	Dead_Body.Think = function( self )
	
		self:NextThink( CurTime() )
	
		self:SetCycle( math.Approach( cycle, 1, FrameTime() * 0.4 ) )
	
		cycle = self:GetCycle()
	
		return true
	
	end

	end

	if camtorag then
		Dead_Body = sent_rag
	end

	LocalPlayer():SetNoDraw(true)
	LocalPlayer():SetDSP(35)

	timer.Simple(1.5, function()
		LocalPlayer():SetDSP(31)
	end)

	timer.Simple(2, function()
		if LocalPlayer():GTeam() == TEAM_SCP then
			CorpsedMessage()
		else
			CorpsedMessage()
		end
	end)
	
	local cycle = 0

	LocalPlayer():ScreenFade( SCREENFADE.OUT, color_black, 4, 4.1)
	timer.Simple( 8, function()
		LocalPlayer():SetDSP(0)
		Death_Blur_Intensity = 0
		Death_Desaturation_Intensity = 1
		Death_Scene = false
		Dead_Body = false
		LocalPlayer():SetNWEntity("RagdollEntityNO", NULL)
		LocalPlayer():SetNWEntity("NTF1Entity", NULL)

		if IsValid(Dead_Body) then
			LocalPlayer():SetNoDraw(false)
			if !camtorag then
		    	Dead_Body:Remove()
			end
		    Dead_Body = false
			show_spec_role = true
			if show_spec_role then
				DrawNewRoleDesc()
				show_spec_role = false
			end
		end
		if IsValid(LocalPlayer():GetNWEntity("RagdollEntityNO")) then
			for _, bnmrg in pairs(LocalPlayer():GetNWEntity("RagdollEntityNO"):LookupBonemerges()) do
				bnmrg:SetNoDraw(false)
			end
			LocalPlayer():GetNWEntity("RagdollEntityNO"):SetNoDraw(false)
		end
	end )
	if !camtorag then
		timer.Create("FINDRAGDOLLBODY", FrameTime(), 9999, function()
			if IsValid(LocalPlayer():GetNWEntity("RagdollEntityNO")) then
				for _, bnmrg in pairs(LocalPlayer():GetNWEntity("RagdollEntityNO"):LookupBonemerges()) do
					bnmrg:SetNoDraw(true)
				end
				LocalPlayer():GetNWEntity("RagdollEntityNO"):SetNoDraw(true)
				timer.Remove("FINDRAGDOLLBODY")
			end
		end)
		LocalPlayer():SetNWEntity("NTF1Entity", Dead_Body)
	else
		--local rag = LocalPlayer():GetNWEntity("RagdollEntityNO")
		local rag = LocalPlayer():GetNWEntity("NTF1Entity")
		local times = 0
		timer.Create("FINDRAGDOLLBODY", FrameTime(), 9999, function()
			if IsValid(LocalPlayer():GetNWEntity("RagdollEntityNO")) then
				LocalPlayer():SetNWEntity("NTF1Entity", LocalPlayer():GetNWEntity("RagdollEntityNO"))
				timer.Remove("FINDRAGDOLLBODY")
				if IsValid(rag) then
					rag:ManipulateBoneScale(rag:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
				end
			end
			timer.Simple(8, function()
				if IsValid(rag) then
					rag:ManipulateBoneScale(rag:LookupBone("ValveBiped.Bip01_Head1"), Vector(1,1,1))
					local head = rag:GetAttachment( rag:LookupAttachment( "eyes" ) )

					local matrix

	  				for bone = 0, ( rag:GetBoneCount() || 1 ) do
	    				if rag:GetBoneName( bone ):lower():find( "head" ) then
	      					matrix = rag:GetBoneMatrix( bone )
	      					rag:ManipulateBoneScale(bone, Vector(1,1,1))
	      					break
	    				end
	  				end

	  				if ( IsValid( matrix ) ) then
	    				matrix:SetScale( Vector(1,1,1) )
    				end
				end
			end)
		end)
		if !camtorag then
			Dead_Body:Remove()
		end
	end

	BREACH.Music:Play(BR_MUSIC_DEATH)
end
net.Receive("Death_Scene", Death_Scene)
  
function ANGLE:CalculateVectorDot( vec )



	local x = self:Forward():DotProduct( vec )

	local y = self:Right():DotProduct( vec )

	local z = self:Up():DotProduct( vec )



	return Vector( x, y, z )



end

function GM:DrawDeathNotice( x,  y )
end

SCPMarkers = {}

tab_scarlet = {
	["$pp_colour_addr"] = 0.07,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 2,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local client = LocalPlayer()

function Scarlet_King_Shake()

	util.ScreenShake( Vector(0, 0, 0), 2, 2, 10, 1000 )

	surface.PlaySound( "nextoren/others/helicopter/helicopter_distant_explosion.wav" )

end

hook.Add("Think", "Check_Scarlet_Skybox", function()
	if GetGlobalBool("Scarlet_King_Scarlet_Skybox", false) then
		if ( ( NextShake || 0 ) >= CurTime() ) then return end
	
		NextShake = CurTime() + 50

	    Scarlet_King_Shake()
	end
end)

local bloomtab = {
	pp_bloom_passes = "0",
	pp_bloom_darken = "0.20",
	pp_bloom_multiply = "0.15",
	pp_bloom_sizex = "6.42",
	pp_bloom_sizey = "4.65",
	pp_bloom_color = "20.00",
	pp_bloom_color_r = "255",
	pp_bloom_color_g = "0",
	pp_bloom_color_b = "0"
}

local outsidescarlettab = {
	["$pp_colour_addr"] = 0.07,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 2,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local outsidenoscarlettab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local notoutsidetab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.01,
	["$pp_colour_contrast"] = 0.7,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local evactab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.01,
	["$pp_colour_contrast"] = 0.9,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local forscptab = {
	["$pp_colour_addr"] = 0.05,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.01,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local generatorsactivated = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.01,
	["$pp_colour_contrast"] = 1.2,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local _DrawColorModify = DrawColorModify

local scpvision = CreateConVar("breach_config_scp_red_screen", 1, FCVAR_ARCHIVE, "Enables the red screen for SCP", 0, 1)

hook.Add( "RenderScreenspaceEffects", "ToytownEffect", function()

    --DrawBloom( 0.55, 1, 9, 9, 5, 1, 1.1, 1.1, 1 )
    --DrawSharpen( 1.2, 0.2 )

	local client = LocalPlayer()
	local tab2
		if OUTSIDE_BUFF and OUTSIDE_BUFF( client:GetPos() ) then

			if GetGlobalBool("Scarlet_King_Scarlet_Skybox", false) then
				tab2 = outsidescarlettab
			else
				tab2 = outsidenoscarlettab
			end
		else
			tab2 = notoutsidetab
		end

	if BREACH["Round"] and BREACH["Round"]["GeneratorsActivated"] and !client:Outside() then
		tab2 = generatorsactivated
	end

	if GetGlobalBool("Evacuation_HUD", false) and !client:Outside() then
		tab2 = evactab
		tab2["$pp_colour_addr"] = Pulsate(1.4) * 0.04
		tab2["$pp_colour_colour"] = 1 + Pulsate(1.4) * 0.4
	end

	local oldcolor = tab2["$pp_colour_colour"]
	if Dead_Body then
		local tab2 = table.Copy(tab2)
    DrawToyTown(Death_Blur_Intensity, ScrH())
    tab2["$pp_colour_colour"] = Death_Desaturation_Intensity
  end

  if client:GTeam() == TEAM_SCP and GetConVar("breach_config_scp_red_screen"):GetBool() then
  	tab2 = forscptab
  end

	_DrawColorModify( tab2 )

	tab2["$pp_colour_colour"] = oldcolor

end )

local clr = color_white
local clr1 = Color( 255, 69, 0 )

local hud_style = CreateConVar("breach_config_hud_style", 0, FCVAR_ARCHIVE, "Changes your HUD style", 0, 1)
local hide_title = CreateConVar("breach_config_hide_title", 0, FCVAR_ARCHIVE, "Disable bottom title", 0, 1)

local red = Color(255,0,0)

local function BreachVersionIndicator()

	local widthz = ScrW()
	local heightz = ScrH()

	if ( LocalPlayer():Health() <= 0 ) then return end
	if clang == nil then return end
	if LocalPlayer():GetInDimension() then return end
	if hide_title:GetInt() == 1 then return end
	local clang = clang

	draw.SimpleText( clang.bugs, "ScoreboardContent", widthz * 0.5, heightz * 0.96, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( clang.version_title, "ScoreboardContent", widthz * 0.5, heightz * 0.99, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( clang.version, "ScoreboardContent", widthz * 0.5, heightz * 0.974, clr1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end
hook.Add( "HUDPaintBackground", "BreachVersionIndicator", BreachVersionIndicator )

local clrgray = Color( 198, 198, 198 )
local clrgray2 = Color( 180, 180, 180 )
local clrred = Color( 255, 0, 0 )
local clrred2 = Color( 198, 0, 0 )

local BREACH = BREACH || {}

local function ShowAbillityDesc( name, text, cooldown, x, y )

	if ( BREACH.Abilities && IsValid( BREACH.Abilities.TipWindow ) ) then
  
	  BREACH.Abilities.TipWindow:Remove()
  
	end
  
	  if ( !BREACH.Abilities ) then
  
		  BREACH.Abilities = {}
  
	  end
  
	surface.SetFont( "ChatFont_new" )
	local _, stringheight = surface.GetTextSize( text )
	BREACH.Abilities.TipWindow = vgui.Create( "DPanel" )
	BREACH.Abilities.TipWindow:SetAlpha( 0 )
	BREACH.Abilities.TipWindow:SetPos( x + 10, ScrH() - 80  )
	BREACH.Abilities.TipWindow:SetSize( 180, stringheight + 76 )
	BREACH.Abilities.TipWindow:SetText( "" )
	BREACH.Abilities.TipWindow:MakePopup()
	BREACH.Abilities.TipWindow.Paint = function( self, w, h )
  
	  if ( !vgui.CursorVisible() ) then
  
		self:Remove()
  
	  end
  
	  self:SetPos( gui.MouseX() + 15, gui.MouseY() )
	  if ( self && self:IsValid() && self:GetAlpha() <= 0 ) then
  
		self:SetAlpha( 255 )
  
	  end
	  DrawBlurPanel( self )
	  draw.OutlinedBox( 0, 0, w, h, 2, clrgray2 )
	  drawMultiLine( name, "ChatFont_new", w, 16, 5, 3, clrred, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
  
	  local namewidth, nameheight = surface.GetTextSize( name )
	  drawMultiLine( text, "ChatFont_new", w-10, 16, 5, nameheight * 1.2, clrgray, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
  
	  surface.DrawLine( 0, nameheight * 1.15, w, nameheight * 1.15 )
	  surface.DrawLine( 0, nameheight * 1.15 + 1, w, nameheight * 1.15 + 1 )
  
	  draw.SimpleText( L"l:abilities_cd "..cooldown, "ChatFont_new", w - 8, 3, clrred2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
  
	end
  
  end
  
  local darkgray = Color( 105, 105, 105 )
  function DrawSpecialAbility( tbl )
  
	  local client = LocalPlayer()
  
	client.AbilityKey = string.upper(input.GetKeyName(GetConVar("breach_config_useability"):GetInt()))
	client.AbilityKeyCode = GetConVar("breach_config_useability"):GetInt()
  
	  local name, current_team = client:GetNamesurvivor(), client:GTeam()
  
	  if ( IsValid( BREACH.Abilities ) ) then
  
		  BREACH.Abilities.HumanSpecial:Remove()
  
	  end
  
	  if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end
	  if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end
  
	  BREACH.Abilities = {}
	  BREACH.Abilities.HumanSpecial = vgui.Create( "DPanel" )
	  BREACH.Abilities.HumanSpecial:SetSize( 64, 64 )
	  BREACH.Abilities.HumanSpecial:SetPos( ScrW() / 2 - 32, ScrH() / 1.2 )
	  BREACH.Abilities.HumanSpecial:SetText( "" )
	  BREACH.Abilities.HumanSpecial:SetAlpha( 0 )
	  BREACH.Abilities.HumanSpecial.CreationTime = CurTime()
	  BREACH.Abilities.HumanSpecial.Alpha = 0
	  BREACH.Abilities.HumanSpecial.OnRemove = function()
  
		  gui.EnableScreenClicker( false )
		  if ( BREACH.Abilities && IsValid( BREACH.Abilities.TipWindow ) ) then
  
			  BREACH.Abilities.TipWindow:Remove()
  
		  end
  
	  end
  
	  local iconmat = Material( tbl.Icon )
	  local is_countable = tbl.Countable
  
	  BREACH.Abilities.HumanSpecial.Paint = function( self, w, h )
  
		  if ( client:Health() <= 0 || client:GTeam() == TEAM_SPEC || ( name != client:GetNamesurvivor() and client:GetRoleName() != role.ClassD_Hitman ) || current_team != client:GTeam() ) then
  
			  client.SpecialTable = nil
			  BREACH.Abilities = nil
  
			  self:Remove()
  
			  return
		  end
  
		  if ( IsValid( INTRO_PANEL ) && INTRO_PANEL:IsVisible() ) then return end
  
		  local cTime = CurTime()
  
		  if ( self.Alpha < 255 && self.CreationTime < ( cTime - 4 ) ) then
  
			  self.Alpha = math.Approach( self.Alpha, 255, FrameTime() * 256 )
			  self:SetAlpha( self.Alpha )
  
		  end
  
		  surface.SetDrawColor( color_white )
		  surface.SetMaterial( iconmat )
		  surface.DrawTexturedRect( 0, 0, w, h )
  
		  if ( self.OverridePaintFunc && isfunction( self.OverridePaintFunc ) ) then
  
			  self:OverridePaintFunc( w, h )
  
			  return
		  end
  
		  if ( client.AbilityKeyCode && ( input.IsMouseDown(client.AbilityKeyCode) or input.IsKeyDown( client.AbilityKeyCode ) ) ) then
  
			  surface.SetDrawColor( ColorAlpha( clrgray2, 60 ) )
			  surface.DrawRect( 0, 0, w, h )
  
		  end
  
		  if ( client:GetSpecialCD() > cTime || self.Blocked ) then
  
			  draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( darkgray, 190 ) )
  
			  if ( !self.Blocked ) then
  
				  draw.SimpleTextOutlined( math.Round( client:GetSpecialCD() - cTime ), "ChatFont_new", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )
  
			  end
  
		  end
  
		  draw.SimpleTextOutlined( client.AbilityKey, "ChatFont_new", w - 6, 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1.5, color_black )
  
		  if ( is_countable ) then
  
			  local n_max = client:GetSpecialMax() || 0
  
			  draw.SimpleTextOutlined( tostring( n_max ), "ChatFont_new", 8, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, color_black )
  
			  if ( !self.Blocked && n_max <= 0 ) then
  
				  self.Blocked = true
  
			  elseif ( self.Blocked && n_max > 0 ) then
  
				  self.Blocked = nil
  
			  end
  
		  end
  
		  if ( input.IsKeyDown( KEY_F3 ) ) then
  
			  if ( ( self.NextCall || 0 ) >= CurTime() ) then return end
  
			  self.NextCall = CurTime() + 1
  
			   if ( vgui.CursorVisible() ) then
  
				  gui.EnableScreenClicker( false )
  
			  else
  
				  gui.EnableScreenClicker( true )
  
			  end
  
		  end
  
	  end
  
	  BREACH.Abilities.HumanSpecialButt = vgui.Create( "DButton", BREACH.Abilities.HumanSpecial )
	  BREACH.Abilities.HumanSpecialButt:SetSize( 64, 64 )
	  BREACH.Abilities.HumanSpecialButt:SetText( "" )
	  BREACH.Abilities.HumanSpecialButt.Paint = function() end
	  BREACH.Abilities.HumanSpecialButt.OnCursorEntered = function()
  
		  ShowAbillityDesc( L(tbl.Name), L(tbl.Description), tostring( tbl.Cooldown ), gui.MouseX(), gui.MouseY() )
  
	  end
	  BREACH.Abilities.HumanSpecialButt.OnCursorExited = function()
  
		  if ( BREACH.Abilities && IsValid( BREACH.Abilities.TipWindow ) ) then
  
		  BREACH.Abilities.TipWindow:Remove()
  
		end
  
	  end
  
  end
  

function BulletsLeft()

	local client = LocalPlayer()

	if ( client:GetRoleName() != "CI Juggernaut" ) then return end

	local wep = client:GetWeapon( "cw_cultist_machinegun_m60" )

	if ( !( wep && wep:IsValid() ) ) then return end

	wep.Primary.Ammo = "AR2"

	if IsValid(BREACH.Abilities.HumanSpecial) then
	function BREACH.Abilities.HumanSpecial.OverridePaintFunc( self, w, h )

		if ( !( wep && wep:IsValid() ) || client:GetRoleName() != "CI Juggernaut" ) then

			self.OverridePaintFunc = nil

			return
		end

		local counter = client:GetAmmoCount( "AR2" ) + wep:Clip1()

		if ( counter <= 0 ) then

			wep.Primary.Ammo = "AR2"
			self.OverridePaintFunc = nil

			return
		end

		draw.RoundedBox( 0, 0, -h + ( h * ( 1 - counter / 200 ) ), w, h, color_black )
		draw.SimpleText( counter, "bauhaus_16", 33, 34, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( counter, "bauhaus_16", 32, 32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end
end

end

hook.Add("HUDPaint", "ci_fat_jug_jugger_varus_barus_cock_ass_moron_sucker_suck_dick_ass_bitch", function()
	local w, h = ScrW(), ScrH()
	local ply = LocalPlayer()
	if ply:GetRoleName() != "CI Juggernaut" then return end	
	BulletsLeft()
end)


local info1 = Material( "breach/info_mtf.png")
hook.Add( "HUDPaint", "Breach_DrawHUD", function()
	for i, v in ipairs( SCPMarkers ) do
		local scr = v.data.pos:ToScreen()

		if scr.visible then
			surface.SetDrawColor( Color( 255, 100, 100, 200 ) )
			//surface.DrawRect( scr.x - 5, scr.y - 5, 10, 10 )
			surface.DrawPoly( {
				{ x = scr.x, y = scr.y - 10 },
				{ x = scr.x + 5, y = scr.y },
				{ x = scr.x, y = scr.y + 10 },
				{ x = scr.x - 5, y = scr.y },
			} )

			draw.Text( {
				text = v.data.name,
				font = "HUDFont",
				color = Color( 255, 100, 100, 200 ),
				pos = { scr.x, scr.y + 10 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )

			draw.Text( {
				text = math.Round( v.data.pos:Distance( LocalPlayer():GetPos() ) * 0.019 ) .. "m",
				font = "HUDFont",
				color = Color( 255, 100, 100, 200 ),
				pos = { scr.x, scr.y + 25 },
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_TOP,
			} )
		end

		if v.time < CurTime() then
			table.remove( SCPMarkers, i )
		end
	end

	if disablehud then return end

	if shoulddrawinfo == true then
		if LocalPlayer():GTeam() == TEAM_SPEC then
			timer.Simple(0.1, function()
				DrawNewRoleDesc()
			end)
		else
			local client = LocalPlayer()
			if (client:GTeam() != TEAM_QRT and client:GTeam() != TEAM_GUARD and ( client:GTeam() != TEAM_DZ or client:GetRoleName() == role.SCI_SpyDZ ) and client:GTeam() != TEAM_NTF and ( client:GTeam() != TEAM_USA or client:GetRoleName() == role.SCI_SpyUSA ) and client:GTeam() != TEAM_GRU and ( client:GTeam() != TEAM_GOC or client:GetRoleName() == role.ClassD_GOCSpy ) and client:GTeam() != TEAM_COTSK and ( client:GTeam() != TEAM_CHAOS or client:GetRoleName() == role.SECURITY_Spy )) or client:GetRoleName() == role.NTF_Pilot then
				DrawNewRoleDesc()
			end

		end

		shoulddrawinfo = false
	end
	if isnumber(drawendmsg) then
		local ndtext = clang.lang_end2
		if drawendmsg == 2 then
			ndtext = clang.lang_end3
		end
			shoulddrawinfo = false
	else
		if isnumber(shoulddrawescape) then
			if CurTime() > lastescapegot then
				shoulddrawescape = nil
			end
			if clang.escapemessages[shoulddrawescape] then
				local tab = clang.escapemessages[shoulddrawescape]
				draw.TextShadow( {
					text = tab.main,
					pos = { ScrW() / 2, ScrH() / 15 },
					font = "ImpactBig",
					color = tab.clr,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
				draw.TextShadow( {
					text = string.Replace( tab.txt, "{t}", string.ToMinutesSecondsMilliseconds(esctime) ),
					pos = { ScrW() / 2, ScrH() / 15 + 45 },
					font = "ImpactSmall",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
				draw.TextShadow( {
					text = tab.txt2,
					pos = { ScrW() / 2, ScrH() / 15 + 75 },
					font = "ImpactSmall",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
			end
		end
	end
end )

local halo_team = false

net.Receive("NTF_Special_1", function()
    local team = net.ReadUInt( 8 )
	local client = LocalPlayer()
    halo_team = {} 
    for _, v in player.Iterator() do
        if v:GTeam() == team then
            table.insert(halo_team, v)

			local bonemerged_tbl = ents.FindByClassAndParent("breach_bonemerge", v)

			if ( bonemerged_tbl && bonemerged_tbl:IsValid() ) then

				for i = 1, #bonemerged_tbl do

					halo_team[ #halo_team + 1 ] = bonemerged_tbl[i]

				end

			end
        end
    end
    timer.Simple(15, function()
        halo_team = false
    end)
	local outline_clr = Color( 255, 12, 0, 210 )
	hook.Add( "PreDrawOutlines", "Draw_ntf", function()
		if client:GTeam() == TEAM_NTF then
			if ( #halo_team > 0 && halo_team != false ) then
	
				outline.Add( halo_team, outline_clr, 0 )
		
			end
		end
		if halo_team == false or #halo_team < 0 then
			hook.Remove("PreDrawOutlines", "Draw_ntf")
		end
	end)

end)

BREACH.Demote = BREACH.Demote || {}

function SCP062de_Menu()

	if Select_Menu_enabled then return end

	local clrgray = Color( 198, 198, 198, 200 )
	local gradient = Material( "vgui/gradient-r" )

	local weapons_table = {

		[ 1 ] = { name = "MP40", class = "cw_kk_ins2_doi_mp40" },
		[ 2 ] = { name = "K98", class = "cw_kk_ins2_doi_k98k" },
		[ 3 ] = { name = "G43", class = "cw_kk_ins2_doi_g43" }

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

			net.Start( "GiveWeaponFromClient" )

				net.WriteString( weapons_table[ math.random( 1, #weapons_table ) ].class )

			net.SendToServer()

			self.Disclaimer:Remove()
			self:Remove()
			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
	BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - ( 128 * 1.5 ) )
	BREACH.Demote.MainPanel.Disclaimer:SetText( "" )

	local client = LocalPlayer()

	BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		draw.DrawText( "ВЫБЕРИТЕ ОРУЖИЕ", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( client:GetRoleName() != "SCP062DE" || client:Health() <= 0 ) then

			if ( IsValid( BREACH.Demote.MainPanel ) ) then

				BREACH.Demote.MainPanel:Remove()

			end

			self:Remove()

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
	BREACH.Demote.ScrollPanel:Dock( FILL )

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

			net.Start( "GiveWeaponFromClient" )

				net.WriteString( weapons_table[ i ].class )

			net.SendToServer()

			BREACH.Demote.MainPanel.Disclaimer:Remove()
			BREACH.Demote.MainPanel:Remove()
			gui.EnableScreenClicker( false )

		end

	end

end

BREACH.Demote = BREACH.Demote || {}

local lockedcolor = Color(155,0,0)

net.Receive("SelectRole_Sync", function(len)

	local data = net.ReadTable()

	if BREACH.Demote and BREACH.Demote.MainPanel then
		BREACH.SelectedRoles = data
	end	

end)

function Select_Supp_Menu(team)

	local clrgray = Color( 198, 198, 198, 200 )
	local gradient = Material( "vgui/gradient-r" )

	if LocalPlayer():GetRoleName() == role.Chaos_Demo or LocalPlayer():GetRoleName() == role.GRU_Commander or LocalPlayer():GetRoleName() == role.Cult_Commander then
		BREACH.Player:ChatPrint( true, true, "Так-как вы являетесь важной для фракции ролью, вы не можете сменить ее" )
		return
	end

	BREACH.Player:ChatPrint( true, true, "Из-за того что ваш Премиум Статус активирован, вы можете сменить роль" )
	BREACH.Player:ChatPrint( true, true, "Чтобы отменить выбор, нажмите \"BACKSPACE\"" )

	local tab
	if team == TEAM_GOC then
		tab = BREACH_ROLES.GOC.goc.roles
	elseif team == TEAM_CHAOS then
		tab = BREACH_ROLES.CHAOS.chaos.roles
	elseif team == TEAM_USA then
		tab = BREACH_ROLES.FBI.fbi.roles
	elseif team == TEAM_NTF then
		tab = BREACH_ROLES.NTF.ntf.roles
	elseif team == TEAM_DZ then
		tab = BREACH_ROLES.DZ.dz.roles
	elseif team == TEAM_GRU then
		tab = BREACH_ROLES.GRU.gru.roles
	elseif team == TEAM_COTSK then
		tab = BREACH_ROLES.COTSK.cotsk.roles
	end

	Select_Menu_enabled = true

	local weapons_table = {
	}

	for id, role in pairs(tab) do
		weapons_table[#weapons_table + 1] = {name = GetLangRole(role.name), class = role.name, id = id, max = role.max, level = role.level}
	end

	BREACH.Demote.MainPanel = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel:SetSize( 256, 262 )
	BREACH.Demote.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
	BREACH.Demote.MainPanel:SetText( "" )
	BREACH.Demote.MainPanel.DieTime = CurTime() + 65
	BREACH.Demote.MainPanel.Paint = function( self, w, h )

		if ( !vgui.CursorVisible() ) then

			gui.EnableScreenClicker( true )

		end

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		if ( self.DieTime <= CurTime() ) then

			self.Disclaimer:Remove()
			self:Remove()

			Select_Menu_enabled = false

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
	BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - ( 128 * 1.5 ) )
	BREACH.Demote.MainPanel.Disclaimer:SetText( "" )

	BREACH.Demote.MainPanel:SetAlpha(0)
	BREACH.Demote.MainPanel:AlphaTo(255,0.5)

	BREACH.Demote.MainPanel.Disclaimer:SetAlpha(0)
	BREACH.Demote.MainPanel.Disclaimer:AlphaTo(255,1)

	local client = LocalPlayer()

	BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		local plys = player.GetAll()

		draw.DrawText( "СМЕНА РОЛИ", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( client:GTeam() != team || client:Health() <= 0 || input.IsKeyDown(KEY_BACKSPACE) ) then

			if ( IsValid( BREACH.Demote.MainPanel ) ) then

				BREACH.Demote.MainPanel:Remove()

			end

			self:Remove()

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
	BREACH.Demote.ScrollPanel:Dock( FILL )

	for i = 1, #weapons_table do

		if weapons_table[i].class == role.UIU_Clocker and LocalPlayer():GetRoleName() != role.UIU_Clocker then continue end

		BREACH.Demote.Users = BREACH.Demote.ScrollPanel:Add( "DButton" )
		BREACH.Demote.Users:SetText( "" )
		BREACH.Demote.Users:Dock( TOP )
		BREACH.Demote.Users:SetSize( 256, 64 )
		BREACH.Demote.Users:DockMargin( 0, 0, 0, 2 )
		BREACH.Demote.Users.CursorOnPanel = false
		BREACH.Demote.Users.gradientalpha = 0

		BREACH.Demote.Users.CharPanel = vgui.Create("DModelPanel", BREACH.Demote.Users)

		local char = BREACH.Demote.Users.CharPanel

		local ang = Angle(0,25,0)

		function char:LayoutEntity(ent)
			ent:SetAngles(ang)
			return
		end

		function char:RunAnimation(ent)
		end

		BREACH.Demote.Users.CharPanel:SetSize(60,60)
		BREACH.Demote.Users.CharPanel:SetPos(1,1)


		-- load model
		char:SetModel(tab[weapons_table[i].id].model)

		char:SetDirectionalLight(BOX_TOP, Color(0, 0, 0))
		char:SetDirectionalLight(BOX_FRONT, Color(15, 15, 15))
		char:SetDirectionalLight(BOX_RIGHT, Color(255, 255, 255))
		char:SetDirectionalLight(BOX_LEFT, Color(0, 0, 0))

		local head

		if tab[weapons_table[i].id].head then
			head = char:BoneMerged(tab[weapons_table[i].id].head)
		end

		if tab[weapons_table[i].id].usehead then
			head = char:BoneMerged("models/cultist/heads/male/male_head_1.mdl")
		end

		if tab[weapons_table[i].id].headgear then
			head = char:BoneMerged(tab[weapons_table[i].id].headgear)
		end

		for bid = 0, 9 do
			if tab[weapons_table[i].id]["bodygroup"..bid] then
				char.Entity:SetBodygroup(bid, tab[weapons_table[i].id]["bodygroup"..bid])
			end
		end

		char.Entity:SetSequence(char.Entity:LookupSequence("ragdoll"))

		local eyepos = char.Entity:GetBonePosition(char.Entity:LookupBone("ValveBiped.Bip01_Head1"))

		eyepos:Add(Vector(0, 0, 2))	-- Move up slightly

		char:SetLookAt(eyepos)

		char:SetFOV(35)

		char:SetCamPos(eyepos-Vector(-25, 0, 0))	-- Move cam in front of eyes

		char.Entity:SetEyeTarget(eyepos-Vector(-12, 0, 0))


		local locked = false
		local lockreason = 0

		if LocalPlayer():GetNLevel() < weapons_table[i].level then
			locked = true
			lockreason = 1
		end

		local players = player.GetAll()

		local amount = 0

		BREACH.Demote.Users.Think = function( self )

			if lockreason == 1 then return end

			amount = 0

			for id = 1, #players do

				if players[id]:GetRoleName() == weapons_table[i].class then

					amount = amount + 1

				end

			end

			if BREACH.SelectedRoles then

				for id, selected in pairs(BREACH.SelectedRoles) do

					if id == weapons_table[i].id then

						amount = amount + selected

					end

				end

			end

			if amount >= weapons_table[i].max then
				locked = true
				lockreason = 2
			else
				locked = false
				lockreason = 0
			end

		end

		BREACH.Demote.Users.Paint = function( self, w, h )

			if locked then
				self:SetCursor("arrow")
			else
				self:SetCursor("hand")
			end

			if ( self.CursorOnPanel and !locked ) then

				self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 64 )

			else

				self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 128 )

			end

			draw.RoundedBox( 0, 0, 0, w, h, color_black )
			draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )

			surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
			surface.SetMaterial( gradient )
			surface.DrawTexturedRect( 0, 0, w, h )

			if weapons_table[ i ].class == LocalPlayer():GetRoleName() then
				draw.SimpleText( "CURRENT:", "BudgetLabel", w / 2, 15, ColorAlpha(color_white, 55), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( weapons_table[ i ].name, "HUDFont", w / 2, h / 2, ColorAlpha(color_white, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			elseif !locked then
				draw.SimpleText( weapons_table[ i ].name, "HUDFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				if lockreason == 1 then
					draw.SimpleText( "REQUIRED LEVEL: "..weapons_table[ i ].level, "BudgetLabel", w / 2, 15, Color(50+Pulsate(1)*105,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "ALREADY TAKEN", "BudgetLabel", w / 2, 15, Color(50+Pulsate(1)*105,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( weapons_table[ i ].name, "HUDFont", w / 2, h / 2, lockedcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

		end

		BREACH.Demote.Users.OnCursorEntered = function( self )

			self.CursorOnPanel = true

		end

		BREACH.Demote.Users.OnCursorExited = function( self )

			self.CursorOnPanel = false

		end

		BREACH.Demote.Users.DoClick = function( self )

			if locked then return end

			if weapons_table[ i ].class == LocalPlayer():GetRoleName() then
				BREACH.Demote.MainPanel.Disclaimer:Remove()
				BREACH.Demote.MainPanel:Remove()
				gui.EnableScreenClicker( false )
				return
			end

			amount = 0

			for id = 1, #players do

				if players[id]:GetRoleName() == weapons_table[i].class then

					amount = amount + 1

				end

			end

			if amount >= weapons_table[i].max then
				return
			end

			net.Start( "changesupport" )

				net.WriteUInt( weapons_table[ i ].id, 4 )

			net.SendToServer()

			timer.Simple(0.5, function() DrawNewRoleDesc() end)

			BREACH.Demote.MainPanel.Disclaimer:Remove()
			BREACH.Demote.MainPanel:Remove()

			gui.EnableScreenClicker( false )

		end

	end

end

BREACH.Demote = BREACH.Demote || {}

Select_Menu_enabled = Select_Menu_enabled || false

function Select_SCP_Menu(tab)

	local clrgray = Color( 198, 198, 198, 200 )
	local gradient = Material( "vgui/gradient-r" )

	Select_Menu_enabled = true

	local weapons_table = {
	}

	for _, scp in ipairs(tab) do
		weapons_table[#weapons_table + 1] = {name = GetLangRole(scp), class = scp}
	end

	BREACH.Demote.MainPanel = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel:SetSize( 256, 256 )
	BREACH.Demote.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
	BREACH.Demote.MainPanel:SetText( "" )
	BREACH.Demote.MainPanel.DieTime = CurTime() + 65
	BREACH.Demote.MainPanel.Paint = function( self, w, h )

		if ( !vgui.CursorVisible() ) then

			gui.EnableScreenClicker( true )

		end

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		if ( self.DieTime <= CurTime() ) then

			self.Disclaimer:Remove()
			self:Remove()

			Select_Menu_enabled = false

			gui.EnableScreenClicker( false )

		end

	end

	BREACH.Demote.MainPanel.Disclaimer = vgui.Create( "DPanel" )
	BREACH.Demote.MainPanel.Disclaimer:SetSize( 256, 64 )
	BREACH.Demote.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - ( 128 * 1.5 ) )
	BREACH.Demote.MainPanel.Disclaimer:SetText( "" )

	local client = LocalPlayer()

	BREACH.Demote.MainPanel.Disclaimer.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
		draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

		local plys = player.GetAll()

		draw.DrawText( "ВЫБЕРИТЕ SCP", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( client:GTeam() != TEAM_SCP || client:Health() <= 0 || input.IsKeyDown(KEY_BACKSPACE) ) then

			if ( IsValid( BREACH.Demote.MainPanel ) ) then

				BREACH.Demote.MainPanel:Remove()

			end

			self:Remove()

			Select_Menu_enabled = false

			gui.EnableScreenClicker( false )

			if client:GetRoleName() == "SCP062DE" then
				SCP062de_Menu()
			end

		end

	end

	BREACH.Demote.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.Demote.MainPanel )
	BREACH.Demote.ScrollPanel:Dock( FILL )

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

			net.Start( "SelectSCPClientside" )

				net.WriteString( weapons_table[ i ].class )

			net.SendToServer()

			timer.Simple(1, function()
				if client:GetRoleName() == "SCP062DE" then
					SCP062de_Menu()
				end
			end)

			BREACH.Demote.MainPanel.Disclaimer:Remove()
			BREACH.Demote.MainPanel:Remove()

			Select_Menu_enabled = false

			gui.EnableScreenClicker( false )

		end

	end

end

net.Receive("SCPSelect_Menu", function(len)
	local tab = net.ReadTable()
	Select_SCP_Menu(tab)
end)

net.Receive( "ShowText", function( len )
	local com = net.ReadString()
	if com == "vote_fail" then
		LocalPlayer():PrintMessage( HUD_PRINTTALK, clang.votefail )
	elseif	com == "text_punish" then
		local name = net.ReadString()
		LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( clang.votepunish, name ) )
		LocalPlayer():PrintMessage( HUD_PRINTTALK, clang.voterules )
	elseif	com == "text_punish_end" then
		local data = net.ReadTable()
		local result
		if data.punish then 
			result = clang.punish
		else 
			result = clang.forgive
		end
		local vp, vf = data.punishvotes, data.forgivevotes
		//print( vp, vf )
		LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( clang.voteresult, data.punished, result ) )
		LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format( clang.votes, vp + vf, vp, vf ) )
	elseif com == "text_punish_cancel" then
		LocalPlayer():PrintMessage( HUD_PRINTTALK, clang.votecancel )
	end
end)

--[[ADMIN SYSTEM]]--[[

surface.CreateFont( "cmd_showup_font_1", {
	font = "Univers LT Std 47 Cn Lt",
	size = 20,
	weight = 0,
	antialias = true,
	extended = true,
	shadow = false,
	outline = false,
  
})

surface.CreateFont( "cmd_showup_font_2", {
	font = "Univers LT Std 47 Cn Lt",
	size = 19,
	weight = 0,
	antialias = true,
	extended = true,
	italic = true,
	shadow = false,
	outline = false,
  
})

local curtext = ""

BREACH.COMMANDS = BREACH.COMMANDS

function GetCmdList()

	if debug_frequentupdate then
		BREACH.COMMANDS = nil
	end

	if BREACH.COMMANDS == nil then

		BREACH.COMMANDS = {}

		for i, v in pairs(ulx.cmdsByCategory) do

			for _, cmd in ipairs(v) do
				if cmd.say_cmd then
					for _, say_cmd in ipairs(cmd.say_cmd) do
						BREACH.COMMANDS[#BREACH.COMMANDS + 1] = {
							say_cmd = say_cmd,
							category = cmd.category,
							args = {}
						}

						for _, arg in ipairs(cmd.args) do
							local type = "NONE"

							if arg.type == ULib.cmds.PlayerArg then
								type = "PlayerArg"
							elseif arg.type == ULib.cmds.PlayersArg then
								type = "PlayersArg"
							elseif arg.type == ULib.cmds.NumArg and table.HasValue(arg, ULib.cmds.allowTimeString) then
								type = "TimeArg"
							elseif arg.type == ULib.cmds.NumArg then
								type = "NumArg"
							elseif arg.type == ULib.cmds.BoolArg then
								type = "BoolArg"
							elseif arg.type == ULib.cmds.StringArg then
								type = "StringArg"
							elseif arg.type == ULib.cmds.BaseArg then
								type = "BaseArg"
							elseif arg.type == ULib.cmds.CallingPlayerArg then
								continue
							end

							local argtab = {
								type = type,
								istime = table.HasValue(arg, ULib.cmds.allowTimeString),
								min = arg.min,
								max = arg.max,
								optional = table.HasValue(arg, ULib.cmds.optional),
								hint = arg.hint,
							}

							BREACH.COMMANDS[#BREACH.COMMANDS].args[#BREACH.COMMANDS[#BREACH.COMMANDS].args + 1] = argtab

						end
					end
				end
			end

		end

	end

	return BREACH.COMMANDS

end

local updatetext = ""

hook.Add("ChatTextChanged", "cmds_handletext", function(text)
	curtext = text
	if updatetext != "" then
		if updatetext == curtext then return end
		return updatetext
	end
end)

local cmd_clr_neutral = color_white
local cmd_clr_right = Color(0, 204, 45, 255)
local cmd_clr_wrong = Color(255, 102, 102,200)
local cmd_clr_shadow = Color(0,0,0, 125)

hook.Remove("HUDPaint", "cmds_showup")

hook.Add("DrawOverlay", "cmds_showup", function()

	if !curtext:StartWith("!") or curtext == "!" then return end

	if !BREACH.COMMANDS then
		GetCmdList()
		return
	end

	if input.IsKeyDown(KEY_TAB) then
		updatetext = "TEST"
		return
	end

	local x, y = chat.GetChatBoxPos()
	local w, h = chat.GetChatBoxSize()

	local errorin = 0

	local splittext = string.Explode(" ", curtext, false)

	x = x + 10

	y = y + h + 5

	--draw.DrawText(string text, string font = DermaDefault, number x = 0, number y = 0, table color = Color( 255, 255, 255, 255 ), number xAlign = TEXT_ALIGN_LEFT)

	local w_offset = 0
	local w_offset_prev = 0

	local cmd_clr = cmd_clr_neutral
	local completes_clr = cmd_clr_neutral
	local helptext_clr = cmd_clr_neutral

	local helptext = ""

	local completes = {}

	local lastid = 0

	for i = 1, #splittext do

			lastid = i

			surface.SetFont("cmd_showup_font_1")
			local the_w = surface.GetTextSize(splittext[i].." ")

			local color = cmd_clr
			local haveerror = false

			if i == 1 then
				local cmdsfound = {}
				for cd = 1, #BREACH.COMMANDS do
					local cmd = BREACH.COMMANDS[cd]
					if cmd.say_cmd:StartWith(splittext[1]) then
						cmdsfound[#cmdsfound + 1] = cmd.say_cmd
						completes[i] = cmdsfound
						if #cmdsfound >= 12 then break end
					end
				end

				helptext = ""
			end

			local foundcmd = false

			if i == 1 then
				local foundcmd = false
				for cmdiu = 1, #BREACH.COMMANDS do
					local cmd = BREACH.COMMANDS[cmdiu]
					if cmd.say_cmd == splittext[1] then
						foundcmd = true
						break
					end
				end
			end

			if completes[i] and #completes[i] > 0 then
				if #completes[i] == 1 then
					completes_clr = cmd_clr_right
				else
					completes_clr = color_white
				end
			else
				if i == 1 or !foundcmd then
					haveerror = true
					helptext_clr = cmd_clr_wrong
					helptext = "No command found!"
				end
			end

			if haveerror then
				color = cmd_clr_wrong
			end

			draw.DrawText(splittext[i], "cmd_showup_font_1", x+2+w_offset, y+2, cmd_clr_shadow, TEXT_ALIGN_TOP)
			draw.DrawText(splittext[i], "cmd_showup_font_1", x+w_offset, y, color, TEXT_ALIGN_TOP)

			print(w_offset)

			w_offset_prev = w_offset
			w_offset = w_offset + the_w

		end

		if completes[lastid] then
			for id = 1, #completes[lastid] do
				draw.DrawText(completes[lastid][id], "cmd_showup_font_2", x+w_offset_prev, y+30+(id-1)*20, completes_clr, TEXT_ALIGN_TOP)
			end
		end

		if helptext != "" then
				--draw.DrawText(helptext, "cmd_showup_font_1", x+2+w_offset, y+32, cmd_clr_shadow, TEXT_ALIGN_TOP)
			draw.DrawText(helptext, "cmd_showup_font_2", x, y+30, helptext_clr, TEXT_ALIGN_TOP)
		end

end)]]