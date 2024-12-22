surface.CreateFont( "Jack_VoiceFont", {
 font = "Arial",
 size = VoiceChatMeter.FontSize or 17,
 weight = 550,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = true,
 additive = false,
 outline = true
} )

local isgradientenabled = CreateClientConVar("br_gradient_voice_chat", 0, true, false, "", 0, 1)
local shouldshowchars = CreateClientConVar("br_voicechat_showalive", 1, true, false, "", 0, 1)

/*---------------------------------------------------------------------------
           Starting DarkRP specific stuff
---------------------------------------------------------------------------*/
surface.CreateFont ("DarkRPHUD1", { -- Just incase the font doesn't exist
size = 16,
weight = 600,
antialias = true,
shadow = true,
font = "DejaVu Sans"})

local receivers = receivers
local currentChatText = currentChatText || {}
local receiverConfigs = receiverConfigs || {
	[""] = { -- The default config decides who can hear you when you speak normally
		text = "talk",
		hearFunc = function(ply)
			if GAMEMODE.Config.alltalk then return nil end

			return LocalPlayer():GetPos():Distance(ply:GetPos()) < 250
		end
	}
}

local currentConfig = currentConfig || receiverConfigs[""] -- Default config is normal talk

local function AddChatReceiver(prefix, text, hearFunc)
	receiverConfigs[prefix] = {
		text = text,
		hearFunc = hearFunc
	}
end

AddChatReceiver("speak", "speak", function(ply)
	if not LocalPlayer().DRPIsTalking then return nil end
	if LocalPlayer():GetPos():Distance(ply:GetPos()) > 550 then return false end

	return not GAMEMODE.Config.dynamicvoice or ((ply.IsInRoom and ply:IsInRoom()) or (ply.isInRoom and ply:isInRoom()))
end)

local function drawChatReceivers()
	if not receivers then return end

	local x, y = chat.GetChatBoxPos()
	y = y - 21

	-- No one hears you
	if #receivers == 0 then
		draw.WordBox(2, x, y, "Noone can hear you speak", "DarkRPHUD1", Color(0,0,0,160), Color(255,0,0,255))
		return
	-- Everyone hears you
	elseif #receivers == #player.GetAll() - 1 then
		draw.WordBox(2, x, y, "Everyone can hear you speak", "DarkRPHUD1", Color(0,0,0,160), Color(0,255,0,255))
		return
	end

	draw.WordBox(2, x, y - (#receivers * 21), "Players who can hear you speak:", "DarkRPHUD1", Color(0,0,0,160), Color(0,255,0,255))
	for i = 1, #receivers, 1 do
		if not IsValid(receivers[i]) then
			receivers[i] = receivers[#receivers]
			receivers[#receivers] = nil
			continue
		end

		draw.WordBox(2, x, y - (i - 1)*21, receivers[i]:Nick(), "DarkRPHUD1", Color(0,0,0,160), Color(255,255,255,255))
	end
end

local function chatGetRecipients()
	if not currentConfig then return end

	receivers = receivers || {}
	for _, ply in pairs(player.GetAll()) do
		if not IsValid(ply) or ply == LocalPlayer() then continue end

		local val = currentConfig.hearFunc(ply, currentChatText)

		-- Return nil to disable the chat recipients temporarily.
		if val == nil then
			receivers = nil
			return
		elseif val == true then
			table.insert(receivers, ply)
		end
	end
end
/*---------------------------------------------------------------------------
            End DarkRP Specific stuff
---------------------------------------------------------------------------*/

local emoticons = {
	--["superadmin"] = Material("icon16/script_edit.png"),
	["spectator"] = Material("icon16/rosette.png"),
	["headadmin"] = Material("icon16/fire.png"),
	["admin"] = Material("icon16/shield.png"),
	["premium"] = Material("icon16/medal_gold_1.png"),
}

Jack = Jack || {}
Jack.Talking = Jack.Talking || {}

local clr_white_gray = Color( 210, 210, 210 )

local function PickColorForPlayer(ply)
	local color = gteams.GetColor(ply:GTeam())
	if !isgradientenabled:GetBool() then
		return false
	end
	if ply:GTeam() == TEAM_SPEC then if ply:IsAdmin() and ply:IsSuperAdmin() then return Color(255,0,0) else return Color(255,255,255,0) end end
	if ply:GTeam() == TEAM_SCP then return gteams.GetColor(TEAM_SCP) end
	if LocalPlayer():GTeam() == TEAM_GOC and ply:GTeam() == TEAM_GOC then return gteams.GetColor(TEAM_GOC) end
	if ( LocalPlayer():GTeam() == TEAM_SCP or LocalPlayer():GTeam() == TEAM_DZ ) and ply:GTeam() == TEAM_DZ then return gteams.GetColor(TEAM_DZ) end
	if LocalPlayer():GTeam() == TEAM_CHAOS and ply:GTeam() == TEAM_CHAOS then return gteams.GetColor(TEAM_CHAOS) end
	if ply:GetModel():find("/goc/") then color = gteams.GetColor(TEAM_GOC) end
	if ply:GetModel():find("/sci/") and ply:GTeam() != TEAM_GUARD then color = gteams.GetColor(TEAM_SCI) end
	if ply:GetModel():find("class_d_cleaner") then return gteams.GetColor(TEAM_SCI) end
	if ply:GetModel():find("/class_d/") then color = gteams.GetColor(TEAM_CLASSD) end
	if ply:GetModel():find("/mog/") then color = gteams.GetColor(TEAM_GUARD) end
	if ply:GetModel():find("/security/") then color = gteams.GetColor(TEAM_CB) end
	if ply:GTeam() == TEAM_USA then color = Color(255,255,255) end
	return color
end

function Jack.StartVoice(ply)

	if !ply:IsValid() or !ply.Team then return false end
	if !ply.GTeam then return false end
	if ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_SPEC and (!LocalPlayer():IsAdmin() or LocalPlayer():GTeam() != TEAM_SPEC) and ply != LocalPlayer() then return false end
	if ply:GTeam() == TEAM_SCP and LocalPlayer():GTeam() != TEAM_SCP and LocalPlayer():GTeam() != TEAM_SPEC then return false end
	if GetConVar("breach_config_screenshot_mode"):GetInt() == 1 then return false end
	if ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP and !shouldshowchars:GetBool() and ply != LocalPlayer() then return false end
	for k,v in pairs(Jack.Talking) do if v.Owner == ply then v:Remove() Jack.Talking[k] = nil break end end
	if ply != LocalPlayer() and LocalPlayer():GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP and LocalPlayer():GTeam() != TEAM_SCP and !LocalPlayer():CanSeeEnt(ply) then return false end
	if ply:GetPos():DistToSqr(LocalPlayer():GetPos()) > 200000 and ply:GTeam() != TEAM_SPEC and LocalPlayer():GTeam() != TEAM_SCP then return false end

	local plyteam = ply:GTeam()
	local IsSeen = ( ( LocalPlayer():CanSeeEnt(ply) and !ply:GetNoDraw() ) or ply == LocalPlayer() or ( ply:GTeam() == TEAM_SCP and LocalPlayer():GTeam() == TEAM_SCP ) )
	if LocalPlayer():GTeam() == TEAM_SPEC then
		IsSeen = true
	end
	local CurID = 1
	local client = LocalPlayer()
	local plycol = PickColorForPlayer(ply)
	local gradient = Material("vgui/gradient-l")
	local W,H = 60,VoiceChatMeter.SizeY or 40
	local TeamClr,CurName = team.GetColor(ply:Team()),ply:Name()
	local test_width = CurName

	if ply:GetNWBool("prefix_active") and ply:GTeam() == TEAM_SPEC then
		test_width = "["..ply:GetNWBool("prefix_title", "").."] "..test_width
	end
	surface.SetFont("Jack_VoiceFont")
	local eqeq, eqeq2 = surface.GetTextSize(test_width)
	W = W + eqeq + 10
	W = math.max(W, 250)

	// The name panel itself
	local ToAdd = 0

	if #Jack.Talking != 0 then
		for i=1,#Jack.Talking+3 do
			if !Jack.Talking[i] or !Jack.Talking[i]:IsValid() then
				ToAdd = -(i-1)*(H+4)
				CurID = i
				break
			end
		end
	end

	if !VoiceChatMeter.StackUp then ToAdd = -ToAdd end

	local NameBar,Fade,Go = vgui.Create("DPanel"),0,1
	NameBar:SetSize(W,H)
	local StartPos = (VoiceChatMeter.SlideOut and ((VoiceChatMeter.PosX < .5 and -W) or ScrW())) or (ScrW()*VoiceChatMeter.PosX-(VoiceChatMeter.Align == 1 and 0 or W))
	NameBar:SetPos(StartPos,ScrH()*VoiceChatMeter.PosY+ToAdd)
	local colalph = 20
	if plyteam == TEAM_USA then colalph = 45 end
	local radius = 20
	local noradius = false
	if plyteam != TEAM_SPEC then radius = 5 noradius = true end
	if VoiceChatMeter.SlideOut then NameBar:MoveTo((ScrW()*VoiceChatMeter.PosX-(VoiceChatMeter.Align == 1 and 0 or W)),ScrH()*VoiceChatMeter.PosY+ToAdd,VoiceChatMeter.SlideTime) end
	NameBar.Paint = function(s,w,h)
	--draw.RoundedBoxEx(number cornerRadius, number x, number y, number width, number height, table color, boolean roundTopLeft = false, boolean roundTopRight = false, boolean roundBottomLeft = false, boolean roundBottomRight = false)
		draw.RoundedBoxEx(radius,0,0,w,h,Color(0,0,0,180*Fade), true, noradius, true, noradius)
		draw.RoundedBoxEx(radius,2,2,w-4,h-4,Color(0,0,0,180*Fade), true, noradius, true, noradius)
		if plycol then
			if plyteam != TEAM_SPEC and IsSeen then
				surface.SetDrawColor(ColorAlpha(plycol, colalph))
				surface.SetMaterial(gradient)
				surface.DrawTexturedRect(2, 2, w-4,h-4)
			elseif plyteam == TEAM_SPEC then
				surface.SetDrawColor(ColorAlpha(plycol, colalph))
				surface.SetMaterial(gradient)
				surface.DrawTexturedRect(2, 2, w-4,h-4)
			end
		end
	end
	NameBar.Owner = ply

	// Initialize stuff for this think function
	local maintextbar = vgui.Create("DPanel", NameBar)
	local NameTxt
	maintextbar.Paint = function() end
	local prefixbar
	if ply:GetNWBool("prefix_active", false) and ply:GTeam() == TEAM_SPEC then
		--NameBar:SetWide(NameBar:GetWide()+30)
		prefixbar = vgui.Create("DLabel",maintextbar)
		local str = ply:GetNWString("prefix_title", "")
		local colt = string.Explode(",", ply:GetNWString("prefix_color", "255,255,255"))
		local color = Color(tonumber(colt[1]), tonumber(colt[2]), tonumber(colt[3]))
		prefixbar:SetFont("Jack_VoiceFont")
		prefixbar:SetText("["..str.."] ")
		prefixbar:Dock(LEFT)
		prefixbar:SetColor(color)
		prefixbar.rainbow = ply:GetNWBool("prefix_rainbow", false)
		prefixbar.m_iHue = 0
		prefixbar.m_iRate = 72
		prefixbar.Think = function(self)
			if self.rainbow then
				self.m_iHue = (self.m_iHue + FrameTime() * math.min(720, self.m_iRate)) % 360
				self:SetTextColor(HSVToColor(self.m_iHue, 1, 1))
			end
		end
		prefixbar:SizeToContents()
		prefixbar.Paint = function(self, w, h)
			self:SetAlpha(NameTxt:GetAlpha())
			draw.DrawText(self:GetText(), self:GetFont(), 0, 0, self:GetTextColor(), TEXT_ALIGN_LEFT)
			return true
		end
	end
	NameTxt = vgui.Create("DLabel",maintextbar)
	local Av
	if ply:GTeam() == TEAM_SPEC then
		Av = vgui.Create("AvatarImage",NameBar)
	else
		Av = vgui.Create("DModelPanel",NameBar)
	end

	// How the voice volume meters work
	local angle_front = Angle( 0, 90, 0 )
	local vec_offset = Vector( 0, 0, -30 )
	function NameBar:Think()
		if !ply:IsValid() then NameBar:Remove() Jack.Talking[CurID] = nil return false end
		if !Jack.Talking[CurID] then NameBar:Remove() return false end
		if self.Next and CurTime()-self.Next < .02 then return false end
		if Jack.Talking[CurID].fade then if Go != 0 then Go = 0 end if Fade <= 0 then Jack.Talking[CurID]:Remove() Jack.Talking[CurID] = nil end end
		if Fade < Go and Fade != 1 then Fade = Fade+VoiceChatMeter.FadeAm NameTxt:SetAlpha(Fade*255) if plyteam == TEAM_SPEC then Av:SetAlpha(Fade*255) end elseif Fade > Go and Go != 1 then Fade = Fade-VoiceChatMeter.FadeAm NameTxt:SetAlpha(Fade*255) if plyteam == TEAM_SPEC then Av:SetAlpha(Fade*255) end end

		self.Next = CurTime()
		local CurVol = ply:VoiceVolume()*1.05

		local multiplier = 1/GetConVar("voice_scale"):GetFloat()
		CurVol = CurVol*multiplier

		local VolBar,Clr = vgui.Create("DPanel",NameBar),Color(255*(CurVol),255*(1-CurVol),0,190)
		VolBar:SetSize(5,(self:GetTall()-6)*(CurVol))
		VolBar:SetPos(self:GetTall()-6,(self:GetTall()-6)*(1-CurVol)+3)
		VolBar.Think = function(sel)
			if sel.Next and CurTime()-sel.Next < .02 then return false end
			sel.Next = CurTime()

			local X,Y = sel:GetPos()
			if X > NameBar:GetWide()+14 then sel:Remove() return end

			sel:SetPos(X+6,Y)
		end
		VolBar.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(Clr.r,Clr.g,Clr.b,Clr.a*Fade))

		end
		VolBar:MoveToBack()
		VolBar:SetZPos(5)
	end

	-- The player's avatar

	if plyteam == TEAM_SPEC then
		Av:SetPos(4,4)
		Av:SetSize(NameBar:GetTall()-8,NameBar:GetTall()-8)
		Av:SetPlayer(ply)
	else
		Av:SetPos(4,4)
		Av:SetSize(NameBar:GetTall()-8,NameBar:GetTall()-8)
		if IsSeen then
			Av:SetModel(ply:GetModel())
			Av.Entity:SetSkin(ply:GetSkin())
			for i = 0, 9 do
				Av.Entity:SetBodygroup(i, ply:GetBodygroup(i))
			end
		else
			Av:SetModel("models/cultist/humans/class_d/class_d.mdl")
			Av.Entity:SetMaterial("lights/white001")
			Av:SetColor( clr_white_gray )
		end
		local iSeq = Av.Entity:LookupSequence("idle_all_01")
		if iSeq <= 0 then iSeq = Av.Entity:LookupSequence("idle_all_01") end
		if iSeq <= 0 then iSeq = Av.Entity:LookupSequence("idle_all_01") end
		if iSeq > 0 then Av.Entity:ResetSequence(iSeq) end
		Av:SetFOV( 10 );

		--Av.__LayoutEntity = Av.__LayoutEntity or Av.LayoutEntity;

			function Av:LayoutEntity(ent)

				if IsValid(Av.HeadModel) and IsValid(Av.HeadModelPanel) then
					local flex = Av.HeadModel:GetFlexIDByName( "Mounth" )
					Av.HeadModelPanel:SetFlexWeight(flex, Av.HeadModel:GetFlexWeight(flex))
				end

				--self.__LayoutEntity(self, ent)

			end

			local eyepos = Av.Entity:GetBonePosition(Av.Entity:LookupBone("ValveBiped.Bip01_Head1") || 0)

			if !isnumber(Av.Entity:LookupBone("ValveBiped.Bip01_Head1")) then eyepos = Av.Entity:GetAttachment(Av.Entity:LookupAttachment("eyes")) and Av.Entity:GetAttachment(Av.Entity:LookupAttachment("eyes")).Pos || Vector(0, 0, 0) end

			eyepos:Add(Vector(0, 0, 2))	-- Move up slightly

			Av.Entity:SetAngles(Angle(0,0,0))

			Av:SetCamPos(eyepos-Vector(-65, 0, 0))	-- Move cam in front of eyes

			Av:SetLookAt(eyepos)

			Av.Entity:SetEyeTarget(eyepos-Vector(-65, 0, 0))

			local bnmrgtable = ents.FindByClassAndParent("breach_bonemerge", ply)
			if !IsSeen then
				Av:BoneMerged("models/cultist/heads/male/head_main_1.mdl")
				for i = 1, #Av.Entity.BoneMergedEnts do
					local bnmrg = Av.Entity.BoneMergedEnts[i]
					bnmrg:SetMaterial("lights/white001")
					bnmrg:SetColor( clr_white_gray )
				end
			end
			if istable(bnmrgtable) and IsSeen then
				for _, bnmrg in pairs(bnmrgtable) do
					if !IsValid(bnmrg) then continue end
					local headface = bnmrg:GetSubMaterial(0)
					if CORRUPTED_HEADS[bnmrg:GetModel()] then
						headface = bnmrg:GetSubMaterial(1)
					end
					--if bnmrg:GetModel():find("head_main_1") or bnmrg:GetModel():find("balaclava") then if bnmrg:GetModel():find("head_main_1_3") or bnmrg:GetModel():find("head_main_1_4") then headface = bnmrg:GetSubMaterial(2) else headface = bnmrg:GetSubMaterial(0) end end

					if bnmrg:GetModel():find("male_head") or bnmrg:GetModel():find("fat") or mouth_allowed_models[bnmrg:GetModel()] then
						Av.HeadModel = bnmrg
					end

					local bnmrg_av = Av:BoneMerged(bnmrg:GetModel(), headface, bnmrg:GetInvisible(), bnmrg:GetSkin())
					if Av.HeadModel == bnmrg then
						Av.HeadModelPanel = Av.Entity.BoneMergedEnts[ #Av.Entity.BoneMergedEnts ]
					end

				end
			end
			if ply:GTeam() == TEAM_SCP and !ply:GetModel():find("/scp/") then Av:MakeZombie() end
	end
  
  if plyteam == TEAM_SPEC then
	    Av:SetPaintedManually(true)
	end
  siz = NameBar:GetTall()-8,NameBar:GetTall()-8
	local hsiz = siz * 0.5
  local sin, cos, rad = math.sin, math.cos, math.rad
  local rad0 = rad(0)
  local function DrawCircle(x, y, radius, seg)
  	local cir = {
  		{x = x, y = y}
  	}

  	for i = 0, seg do
  		local a = rad((i / seg) * -360)
  		table.insert(cir, {x = x + sin(a) * radius, y = y + cos(a) * radius})
  	end

  	table.insert(cir, {x = x + sin(rad0) * radius, y = y + cos(rad0) * radius})
  	surface.DrawPoly(cir)
  end
  local pnl = vgui.Create("DPanel", NameBar)
  pnl:SetSize(NameBar:GetTall()-2,NameBar:GetTall()-2)
  pnl:SetPos(4,4)
  pnl:SetDrawBackground(true)
  pnl.Paint = function(w,h)
  	
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    draw.NoTexture()
    surface.SetDrawColor(color_black)
    DrawCircle(hsiz, hsiz, hsiz, hsiz)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

   if plyteam == TEAM_SPEC then
	    Av:PaintManual()
	end

    render.SetStencilEnable(false)
    render.ClearStencil()
  end


	// Admin tags and the such
	local NameStr = ply:Name()
	if VoiceChatMeter.UseTags then
		local Is
    local rankd = ply:GetUserGroup()
    local steamid = ply:SteamID64()
		for k,v in pairs(VoiceChatMeter.Tags) do if ply:IsUserGroup(k) then Is = v end end
		--if !Is and ply:IsSuperAdmin() then Is = "[СА]" --[[elseif !Is and ply:IsAdmin() then Is = "[А]"]] end

		if Is then NameStr = Is .. " " .. NameStr end
	end
  local rankdс = ply:GetUserGroup()
  local clr = Color(255,255,255,240)
  --[[
  if ply:IsAdmin() then
    clr = Color(255,0,0,240)
  end
  --]]
  --if ply:IsAdmin() then clr = Color(255,0,0,240) end
  --if ply:IsSuperAdmin() then clr = Color(0, 255, 255, 240) end
  --if ply:SteamID64() == "76561198300184275" then clr = Color(148, 0, 211) end
  --if ply:SteamID64() == "76561198375622897" then clr = Color(255,255,0) NameStr = "[ЖЕНЩИНА] "..ply:Nick() end

  --if ply:SteamID64() == "76561198956439759" then
  	--clr = Color(116, 1, 113)
  --end


  if NEXTOREN_YOUTUBERS[ply:SteamID64()] and ply:GTeam() == TEAM_SPEC then
  	--clr = Color(255,0,0)
  	NameStr = "[YouTuber] "..ply:Nick()
  end


  if ply:IsPremium() and ply:GTeam() == TEAM_SPEC then
	  clr = GetClientColor(ply)
	end

  if plyteam != TEAM_SPEC and plyteam != TEAM_SCP then
  	if IsSeen then
	  NameStr = ply:GetNamesurvivor()
	else
		NameStr = "Неизвестный"
		if client:GetPos():DistToSqr(ply:GetPos()) > 562500 then NameStr = "Неизвестный #"..tostring(math.floor(util.SharedRandom(ply:GetNamesurvivor(), 100, 999))) end
		if ply:GetNWBool("IntercomTalking", false) then NameStr = "(INTERCOM) Неизвестный" end
	end
	if LocalPlayer():IsAdmin() and ply != LocalPlayer() then NameStr = NameStr.." ("..ply:Nick()..")" end
  	clr = Color(255,255,255, 240)
  end


  
	-- The player's name
	maintextbar:SetPos(maintextbar:GetTall()+17,H*.25)
	NameTxt:Dock(LEFT)
	NameTxt:SetAlpha(0)
	NameTxt:SetFont("Jack_VoiceFont")
	NameTxt:SetText(NameStr)
	maintextbar:SetSize(400,20)
	NameTxt:SizeToContents()
	NameTxt:SetWide(NameTxt:GetWide()+5)
	NameTxt:SetColor(clr)
	--maintextbar:SetZPos(8)
	--maintextbar:MoveToFront()
	--maintextbar:MoveToBack()

	if ( emoticons[ply:GetUserGroup()] or NEXTOREN_YOUTUBERS[ply:SteamID64()] ) and ply:GTeam() == TEAM_SPEC then

		if ply:GetUserGroup() != "premium" or ( ply:GetUserGroup() == "premium" and ply:GetNWBool("display_premium_icon", true) ) or NEXTOREN_YOUTUBERS[ply:SteamID64()] then

			local icon = vgui.Create("DPanel", NameBar)
		  icon:SetSize(NameTxt:GetTall()-4,NameTxt:GetTall()-2)
		  icon:SetPos(40,10)
		  maintextbar:SetX(maintextbar:GetX() + 18)
		  local icon_mg = emoticons[ply:GetUserGroup()]
		  if NEXTOREN_YOUTUBERS[ply:SteamID64()] then
		  	icon_mg = Material("icon16/user_red.png")
		  end
		  icon.Paint = function(self, w, h)

		  	icon:SetAlpha(NameTxt:GetAlpha())

		  	surface.SetDrawColor(color_white)
		  	surface.SetMaterial(icon_mg)
		  	surface.DrawTexturedRect(0,0,w,h)

			end

		end

	end

	-- Hand up-to-face animation



	Jack.Talking[CurID] = NameBar

	return false
end
hook.Add("PlayerStartVoice","Jack's Voice Meter Addon Start",Jack.StartVoice)

function Jack.EndVoice(ply)
	for k,v in pairs(Jack.Talking) do if v.Owner == ply then Jack.Talking[k].fade = true break end end

	if DarkRP and ply == LocalPlayer() then
		hook.Remove("Think", "DarkRP_chatRecipients")
		hook.Remove("HUDPaint", "DarkRP_DrawChatReceivers")
		ply.DRPIsTalking = false
	end

	// More TTT specific stuff
	if (VOICE and VOICE.SetStatus) then
		if IsValid(ply) and not no_reset then
			ply.traitor_gvoice = false
		end

		if ply == LocalPlayer() then
			VOICE.SetSpeaking(false)
		end
	end
end
hook.Add("PlayerEndVoice","Jack's Voice Meter Addon End",Jack.EndVoice)

hook.Add("HUDShouldDraw","Remove old voice cards",function(elem) if elem == "CHudVoiceStatus" || elem == "CHudVoiceSelfStatus" then return false end end)


