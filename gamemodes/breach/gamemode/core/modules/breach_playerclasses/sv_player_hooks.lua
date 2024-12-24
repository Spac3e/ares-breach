local Player = FindMetaTable( "Player" )
util.AddNetworkString("BreachAnnouncer")
util.AddNetworkString("camera_enter")
util.AddNetworkString("camera_swap")
util.AddNetworkString("camera_exit")
util.AddNetworkString("FirstPerson")
util.AddNetworkString("BreachAnnouncerLoud")
util.AddNetworkString("FirstPerson_Remove")
util.AddNetworkString("DropAdditionalArmor")
util.AddNetworkString("NTF_Intro")
util.AddNetworkString("breach_killfeed")
util.AddNetworkString("Shaky_PARTICLEATTACHSYNC")

local mply = FindMetaTable'Player'
local ment = FindMetaTable'Player'

net.Receive("camera_swap", function(len, ply)
	local status = net.ReadBool()

    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then
        return
    end

    local curcam = ply:GetViewEntity()

    local cameras = ents.FindByClass("br_camera")
    local nextcam, prevcam

    for i, v in ipairs(cameras) do
        if v == curcam then
            nextcam = cameras[i + 1]
            prevcam = cameras[i - 1]
            break
        end
    end

    local newcam

    for i, v in ipairs(cameras) do
        if IsValid(v) and not v:GetBroken() then
            if status then
                newcam = nextcam or cameras[1]
            else
                newcam = prevcam or cameras[#cameras]
            end

            if IsValid(newcam) then
                if curcam and curcam:IsPlayer() then
                    curcam:SetEnabled(false)
                end

                ply:SetViewEntity(newcam)

                if newcam:IsPlayer() then
                    newcam:SetEnabled(true)
                end
                
                break
            end
        end
    end
end)

net.Receive("camera_exit", function(len, ply)
	ply:SetViewEntity(NULL)
	ply.br_camera_mode = nil
end)

net.Receive("DropAdditionalArmor", function(len,ply)
	local suka_snimi = net.ReadString()
	if suka_snimi == "armor_big_bag" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingBag() != "" then
				ply:SetMaxSlots(8)
				ply:UnUseBag()
			end
		end
	end
	if suka_snimi == "armor_small_bag" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingBag() != "" then
				ply:SetMaxSlots(8)
				ply:UnUseBag()
			end
		end
	end
	if suka_snimi == "armor_light_armor" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingArmor() != "" then
				ply:UnUseBro()
			end
		end
	end
	if suka_snimi == "armor_light_hat" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingHelmet() != "" then
				ply:UnUseHat()
			end
		end
	end
    if suka_snimi == "armor_heavy_armor" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingArmor() != "" then
				ply:UnUseBro()
			end
		end
	end
	if suka_snimi == "armor_heavy_hat" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingHelmet() != "" then
				ply:UnUseHat()
			end
		end
	end
end)

function Player:SetBottomMessage( msg )
    net.Start( "SetBottomMessage" )
        net.WriteString( msg )
    net.Send( self )
end

function Player:setBottomMessage( msg )
    net.Start( "SetBottomMessage" )
        net.WriteString( msg )
    net.Send( self )
end

function PlayAnnouncer( soundname )
    net.Start( "BreachAnnouncer" )
        net.WriteString( soundname )
	net.Broadcast()
end

function BroadcastStopMusic(ply)
	net.Start("ClientStopMusic")

	if not ply then
		net.Broadcast()
	elseif istable(ply) then
		for _, v in ipairs(ply) do
			net.Send(v)
		end
	elseif IsValid(ply) then
		net.Send(ply)
	end
end

function BroadcastPlayMusic(ply, vsrf_flot)
	net.Start("ClientPlayMusic")
	net.WriteUInt( vsrf_flot, 32 )

	if not ply then
		net.Broadcast()
	elseif istable(ply) then
		for _, v in ipairs(ply) do
			net.Send(v)
		end
	elseif IsValid(ply) then
		net.Send(ply)
	end
end

net.Receive("NTF_Special_1", function(len, ply)
	if ply:GetRoleName() != "NTF Commander" then
		return
	end

	if (ply.ntfsposobka or 0) > CurTime() then
		return
	end

	ply.ntfsposobka = CurTime() + 65

    local team_id = net.ReadUInt(12)

    PlayAnnouncer("nextoren/vo/ntf/camera_receive.ogg")

    local ntf_scan = {}
	local badguyscan = {TEAM_CHAOS, TEAM_GOC, TEAM_GRU, TEAM_USA, TEAM_COTSK, TEAM_DZ}

    for _, v in player.Iterator() do
        if v:GTeam() == team_id then
            table.insert(ntf_scan, v)
        elseif team_id == 22 then
            for _, team in pairs(badguyscan) do
                for _, inteam in ipairs(gteams.GetPlayers(team)) do
                    table.insert(ntf_scan, inteam)
                end
            end
        end
    end

    ply:SetSpecialCD(CurTime() + 65)

    timer.Simple(15, function()
        if #ntf_scan == 0 then
            PlayAnnouncer("nextoren/vo/ntf/camera_notfound.ogg")
            return
        end
        PlayAnnouncer("nextoren/vo/ntf/camera_found_1.ogg")
        net.Start("TargetsToNTFs")
        net.WriteTable(ntf_scan)
        net.WriteUInt(team_id, 12)
        net.Broadcast()
    end)
end)

function GM:PlayerInitialSpawn(ply, transiton)
	ply:SetCanZoom( false )
	ply:SetNoDraw(true)

	player_manager.SetPlayerClass(ply, "class_breach")
    player_manager.OnPlayerSpawn(ply, transiton)
    player_manager.RunClass(ply, "Spawn")

	if timer.Exists( "RoundTime" ) == true then
		net.Start("UpdateTime")
			net.WriteString(tostring(timer.TimeLeft( "RoundTime" )))
		net.Send(ply)
	end

	if ply:IsBot() then
		hook.Run("PlayerReady", ply)
	end

	if gamestarted then
		ply:SendLua( 'gamestarted = true' )
	end

	ply:CompleteAchievement("firsttime")

	ply:ConCommand("music_menu")
end

function GM:PlayerReady( ply )
	ply:SetNWBool("Player_IsPlaying", true)
	
	local spawnpos = table.Random(BREACH.MainMenu_Spawns)

	ply:SetPos(spawnpos[1])
	ply:SetEyeAngles(spawnpos[2])

	ply.ActivePlayer = true
	ply:SetActive(true)
	
	CheckRoundStart()
end

function GM:PlayerSpawn(ply, transiton)
	ply:SetTeam(1)
	ply:SetNoCollideWithTeammates(false)
	
	if not ply.InitialSpawn then
		ply.InitialSpawn = true

		--ply:KillSilent()
		ply:SetSpectator()

		--return
	end

	if not (ply.eflagremoved or nil) then
		if ply:IsPlayer() then
			ply:AddEFlags( -2147483648 )
		else
			ply:RemoveEFlags( -2147483648 )
		end
		
		--ply:SetSpectator()
		ply.eflagremoved = true
	end
	
	for i = 0, ply:GetBoneCount() - 1 do
		ply:ManipulateBoneAngles(ply:LookupBone(ply:GetBoneName(i)), Angle(0, 0, 0))
	end
end

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		if ply.handsmodel != nil then
			info.model = ply.handsmodel
		end
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

util.AddNetworkString("LevelBar")

local function CalculateShitToNormalShit(victim, attacker)
    if not IsValid(attacker) or not IsValid(victim) then
		return
	end

    local distance = attacker:GetPos():Distance(victim:GetPos())

    local meters = math.floor(distance / 100)
    local centimeters = math.floor(distance % 100)

    return "|" .. meters .. "." .. centimeters .. "m| "
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	if ply:GetActiveWeapon() and ply:GetActiveWeapon() != NULL and ply:GTeam() != TEAM_SCP  then
		local wep = ply:GetActiveWeapon():GetClass()

		if wep:find("breach_keycard") or wep:find("cw_kk_ins2") and not wep:find("grenade") then
			ply:ForceDropWeapon(wep)
		end
	end

	ply:AresNotify("l:your_current_exp "..ply:GetNEXP())
	ply:SetupHands()
	ply:AddDeaths(1)
	
	ply.force = dmginfo:GetDamageForce() * math.random( 2, 4 )
	ply.type = dmginfo:GetDamageType()

	if ( attacker && attacker:IsValid() && attacker:IsPlayer() && attacker:GTeam() == TEAM_SCP ) then
		ply.type = attacker:GetRoleName()
	end
	
	local mozhet_razlet_boshkhi = {
		["models/cultist/humans/security/security.mdl"] = true,
		["models/cultist/humans/class_d/class_d.mdl"] = true,
		["models/cultist/humans/class_d/class_d_female.mdl"] = true,
		["models/cultist/humans/class_d/class_d_bor_new.mdl"] = true,
		["models/cultist/humans/class_d/class_d_cleaner.mdl"] = true,
		["models/cultist/humans/class_d/class_d_fat_new.mdl"] = true,
		["models/cultist/humans/sci/scientist.mdl"] = true,
		["models/cultist/humans/sci/scientist_female.mdl"] = true,
		["models/cultist/humans/goc/goc.mdl"] = true,
		["models/cultist/humans/chaos/chaos.mdl"] = true,
		["models/cultist/humans/chaos/fat/chaos_fat.mdl"] = true,
		["models/cultist/humans/mog/special_security.mdl"] = true,
		["models/cultist/humans/mog/head_site.mdl"] = true,
		["models/cultist/humans/mog/mog.mdl"] = true
	}

	local blocked_bonemerges = {
		["models/cultist/humans/mog/head_gear/mog_helmet.mdl"] = true,
		["models/cultist/humans/mog/head_gear/mog_helmet_2.mdl"] = true,
		["models/cultist/humans/security/head_gear/helmet.mdl"] = true,
		["models/cultist/humans/mog/head_gear/mog_helmet.mdl"] = true
	}
	
	local model = ply:GetModel()
	local role = ply:GetRoleName()
	local dmg = dmginfo
	local random = math.random(1,3) == 1

	if ply:LastHitGroup() == HITGROUP_HEAD and mozhet_razlet_boshkhi[model] and dmg:IsBulletDamage() and IsValid(attacker) and attacker:IsPlayer() then
		local weptab = attacker:GetActiveWeapon()

		if weptab.Primary.Ammo == "Shotgun" or weptab.Primary.Ammo == "Revolver" or weptab.Primary.Ammo == "SCP062Ammo" or weptab.Primary.Ammo == "Sniper" then
			for k,v in pairs(ply:LookupBonemerges()) do
				if blocked_bonemerges[v:GetModel()] then
					return
				end
			end
		end

		if model == "models/cultist/humans/chaos/chaos.mdl" and ply:GTeam() == TEAM_CHAOS or
		model == "models/cultist/humans/mog/mog.mdl" and role != "MTF Engineer" or
		model == "models/cultist/humans/security/security.mdl" and role != "Security Rookie" or
		model == "models/cultist/humans/goc/goc.mdl" and role != "GOC Spy" then return end

		if ply.HeadEnt then
			ply.HeadEnt:SetModel("models/cultist/heads/gibs/gib_head.mdl")
			ply.Head_Split = true
		end
	end
end

local scpdeadsounds = {
	["SCP106"] = "nextoren/round_sounds/intercom/scp_contained/106.ogg",
	["SCP049"] = "nextoren/round_sounds/intercom/scp_contained/049.ogg",
	["SCP638"] = "nextoren/round_sounds/intercom/scp_contained/638.ogg",
	["SCP8602"] = "nextoren/round_sounds/intercom/scp_contained/860.ogg",
	["SCP062FR"] = "nextoren/round_sounds/intercom/scp_contained/062fr.ogg",
	["SCP1015RU"] = "nextoren/round_sounds/intercom/scp_contained/1015ru.ogg",
	["SCP035"] = "nextoren/round_sounds/intercom/scp_contained/035.ogg",
	["SCP062DE"] = "nextoren/round_sounds/intercom/scp_contained/062de.ogg",
	["SCP096"] = "nextoren/round_sounds/intercom/scp_contained/096.ogg",
	["SCP542"] = "nextoren/round_sounds/intercom/scp_contained/542.ogg",
	["SCP999"] = "nextoren/round_sounds/intercom/scp_contained/999.ogg",
	["SCP1903"] = "nextoren/round_sounds/intercom/scp_contained/1903.ogg",
	["SCP973"] = "nextoren/round_sounds/intercom/scp_contained/973.ogg",
	["SCP457"] = "nextoren/round_sounds/intercom/scp_contained/457.ogg",
	["SCP173"] = "nextoren/round_sounds/intercom/scp_contained/173.ogg",
	["SCP2012"] = "nextoren/round_sounds/intercom/scp_contained/2012.ogg",
	["SCP082"] = "nextoren/round_sounds/intercom/scp_contained/082.ogg",
	["SCP939"] = "nextoren/round_sounds/intercom/scp_contained/939.ogg",
	["SCP811"] = "nextoren/round_sounds/intercom/scp_contained/811.ogg",
	["SCP682"] = "nextoren/round_sounds/intercom/scp_contained/682.ogg",
	["SCP076"] = "nextoren/round_sounds/intercom/scp_contained/076.ogg",
	["SCP912"] = "nextoren/round_sounds/intercom/scp_contained/912.ogg"
}

function GM:PlayerDeath(victim, inflictor, attacker )
	if victim:GTeam() == TEAM_SCP then
		if victim:GetRoleName() == "SCP939" then
			victim.DeathAnimation = "die"
		elseif victim:GetRoleName() == "SCP682" then
			victim.DeathAnimation = "0_Death_64"
		elseif victim:GetRoleName() == "SCP096" then
			victim.DeathAnimation = "Idle_Passive"
		elseif victim:GetRoleName() == "SCP082" then
			victim.DeathAnimation = "Death_Loot"
		elseif victim:GetRoleName() == "SCP999" then
			victim.DeathAnimation = "die"
		end
	end

	victim:SendLua("HideEQ()")

	if attacker != victim and attacker:IsPlayer() then
		if IsTeamKill(victim, attacker) then
			BREACH.Players:ChatPrint( attacker, true, true, "l:teamkill_you_teamkilled " , victim:Nick() , " " , gteams.GetColor(victim:GTeam()) ,victim:GetRoleName() , " " , Color(255,255,255), " " , victim:SteamID() , "")
			BREACH.Players:ChatPrint( victim, true, true, "l:teamkill_you_have_been_teamkilled " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , "")
			attacker.teamkills = 1 + attacker.kills
		elseif attacker:GTeam() != TEAM_SCP then
			BREACH.Players:ChatPrint( victim, true, true, "l:you_have_been_killed " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , " l:teamkill_report_if_rulebreaker")
			attacker.kills = 1 + attacker.kills
		end
	end

	if victim:GTeam() == TEAM_SCP and scpdeadsounds[victim:GetRoleName()] then
		local deathsound = scpdeadsounds[victim:GetRoleName()]
		timer.Create("SCPDEADLOL" ..deathsound, 12, 1,function()
			PlayAnnouncer(deathsound)
			if timer.Exists("SCPDEADLOL" .. deathsound) then
				timer.Remove("SCPDEADLOL" .. deathsound)
			end
		end)
	end

	victim:SetNWEntity( "RagdollEntityNO", NULL)
	victim:SetNWEntity( "NTF1Entity", NULL)
	victim:SetNWAngle("ViewAngles", Angle(0,0,0))

	for _, v in player.Iterator() do
		if v:GetObserverTarget() == victim then
			v:UnSpectate()
			v:Spectate(OBS_MODE_ROAMING)
			v:SetObserverMode(OBS_MODE_ROAMING)
			v:SpectateEntity(nil)
		end
	end

	CreateLootBox(victim)

	victim:StripAmmo()
	victim:SetUsingBag("")
	victim:SetUsingCloth("")
	victim:SetUsingArmor("")
	victim:SetUsingHelmet("")
	victim:SetSpecialMax(0)
	victim:SetupHands()
	victim:SetNWString("AbilityName", "")
	victim:StopIgniteSequence()
	victim.AbilityTAB = nil
	victim.deathsequence = true
	victim:SendLua("if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end")

	local corpse = victim:GetNWEntity("RagdollEntityNO")

	net.Start("Death_Scene")
	net.WriteBool(true)
	net.WriteEntity(corpse)
	net.Send(victim)

	victim:LevelBar()

 	victim:SetModelScale( 1 )
	local wasteam = victim:GTeam()

	local vicid = victim:SteamID()

	if victim:IsBot() then
		vicid = victim:UserID()
	end


	if victim.Disconnected then
		return
	end

	local tbl_bonemerged = ents.FindByClassAndParent("breach_bonemerge", victim) or {}

	if ( timer.Exists( "NUTSORKYSTYLYAHZ".. vicid ) ) then
		timer.Remove("NUTSORKYSTYLYAHZ".. vicid )
	end

	timer.Create("NUTSORKYSTYLYAHZ" .. vicid, 8, 1, function()
		victim:SetNWEntity("RagdollEntityNO", NULL)

		if not victim:Alive() and victim:GTeam() != TEAM_SPEC then
			victim:SetupNormal()
			victim:SetSpectator()

			if IsValid(corpse) then
				victim:SetPos(corpse:GetPos())				
			end
		end

		victim.deathsequence = false
		timer.Remove("NUTSORKYSTYLYAHZ".. vicid)
	end)

	if victim:GTeam() != TEAM_SCP and victim:GTeam() != TEAM_SPEC and #tbl_bonemerged > 0 then
		for i = 1, #tbl_bonemerged do
			local bonemerge = tbl_bonemerged[i]
			if IsValid(bonemerge) then
				bonemerge:Remove()
			end
		end
	end

	if IsValid(attacker) and IsValid(victim) and attacker:IsPlayer() and attacker != victim then
		local killtable = {CalculateShitToNormalShit(victim, attacker), gteams.GetColor(attacker:GTeam()), attacker:GetRoleName(), " ", Color(255, 255, 255), attacker:GetNamesurvivor() .. "(" .. attacker:Name() .. ")",  " убил ", gteams.GetColor(victim:GTeam()), victim:GetRoleName(), Color(255, 255, 255), victim:GetNamesurvivor() .. "(" .. victim:Name() .. ")",}

		for _, ply in player.Iterator() do
			if ply:GTeam() == TEAM_SPEC then
				net.Start("breach_killfeed")
				net.WriteTable(killtable)
				net.Send(ply)
			end
		end
	end
end

function GM:PlayerDeathThink( ply )
end

function GM:PlayerNoClip( ply, desiredState )
	if ply:GTeam() == TEAM_SPEC and desiredState == true then return true end
end

function GM:PlayerDisconnected( ply )
	ply.Disconnected = true

	if ply:Alive() then
		ply:Kill()
	end
end

-- Voice Control
local voice_distance = 360000 -- 0x57E40 перф апдейт!!
local hear_table = {}

local function CanHear(listener, speaker)
    return listener:EyePos():DistToSqr(speaker:EyePos()) < voice_distance
end

local function CalcVoice(client, players)
    for i = 1, #players do
        local speaker = players[i]
        if client ~= speaker then
            hear_table[client] = hear_table[client] or {}
            hear_table[speaker] = hear_table[speaker] or {}

            if hear_table[client][speaker] == nil then
                local can_hear = CanHear(client, speaker)
                hear_table[client][speaker] = can_hear
                hear_table[speaker][client] = can_hear
            end
        end
    end
end

local function UpdateVoiceTable()
    local players = player.GetAll()

    for i = 1, #players do
		local pl = players[i]
        CalcVoice(pl, players)
    end
end

timer.Create("CalcVoice", .5, 0, function()
    UpdateVoiceTable()
end)

local allowedscp = {
	[role.SCP049] = true,
}

local function hearlogic(listener, talker)
    local talkerrole = talker:GetRoleName()
    local talkerteam = talker:GTeam()
    local listenerteam = listener:GTeam()

	if not listener:GetNWBool("Player_IsPlaying") then
        return false
    end

	if postround then -- так сказано
		return true
	end

    if talkerteam then
        return listenerteam == TEAM_SPEC
    end

    if talker:GetNWBool("IntercomTalking") then
        return true
    end

    if talker.supported then
        return false
    end

    if talkerteam == TEAM_SCP then
        if (allowedscp and allowedscp[talkerrole] and listenerteam ~= TEAM_SCP) or listenerteam == TEAM_DZ then
            return true
        end
        return listenerteam == TEAM_SCP
    end

    if listenerteam == TEAM_SPEC then
        local spectarget = listener:GetObserverTarget()
        if IsValid(spectarget) then
            if spectarget == talker then
                return true
            elseif hear_table and hear_table[spectarget] and hear_table[spectarget][talker] then
                return true
            end
        end
    end

    return hear_table and hear_table[listener] and hear_table[listener][talker] or false
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if not (talker:Alive() and listener:Alive()) then return false end

	return hearlogic(listener, talker)
end

function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, talker)
    if not (talker:Alive() and listener:Alive()) then return false end


	return hearlogic(listener, talker)
end

hook.Add("PlayerSay", "no_support_chat", function(ply, text, teamChat)
	if ply.supported == true then
		return ""
	end
end)

hook.Add("PlayerSay", "Radio_thing", function(ply, text, teamChat)
	if !IsValid(ply) and !ply:GTeam() == TEAM_SPEC then return end
    if not ply:Alive() then return end
    local radio = ply:HasWeapon("item_radio")
	if !radio then return end
    local survname = ply:GetNamesurvivor() or ""
	local check1 = string.find(text, "/r") or string.find(text, "!r") or string.find(text, "/R") or string.find(text, "!R")
    local check2 = text == "/r" or text == "!r" or text == "" or string.find(text, "/R") or string.find(text, "!R") 
	local freq = tonumber( string.sub( tostring( freq ), 1, 5 ) )
	
	--if string.find(text, "l:") then return false end -- фикс легендарного краша через чат, гойда.

    if check1 then
        if !radio then
            ply:AresNotify("l:no_radio")
            return ""
        end

        if ply:GetWeapon("item_radio"):GetEnabled() != true then
            ply:AresNotify("l:turn_up_the_radio")
            return ""
        end

        if check2 then
            ply:AresNotify("l:no_text_radio")
            return ""
        end

        text = string.gsub(text, "[/!]r%s*", "")
		
		if text == "" then
            ply:AresNotify("l:no_text_radio")
            return ""
        end

		ply:EmitSound("nextoren/weapons/radio/squelch.ogg")

        for k, v in player.Iterator() do
			if !v:HasWeapon("item_radio") then return false end
			if v:GetWeapon("item_radio"):GetEnabled() != true then return false end
			if v:GetWeapon("item_radio").Channel == ply:GetWeapon("item_radio").Channel then
            v:AresNotify(Color(7, 19, 185, 210), "l:radio_in_chat ", Color(24, 197, 38), "["..survname.."] ", Color(255, 255, 255), '<"'..text..'">')
			end
        end
		
        return ""
    end
end)


do
    mply.BrGive = mply.BrGive or mply.Give

    function mply:Give(className, bNoAmmo)
        local weapon

        local tr = self:GetEyeTrace()
        local wepent = tr.Entity
        local is_cw = wepent.CW20Weapon

        self.BrWeaponGive = true
        weapon = self:BrGive(className, bNoAmmo)
        self.BrWeaponGive = nil

        local savedammo = wepent.SavedAmmo

        if wepent and is_cw then
            if savedammo and savedammo != 0 then
                weapon:SetClip1(savedammo)
            end

			self:SendLua("LocalPlayer().DoNotPlayInteract = true")

            local loadOrder = {}

            for k, attCategory in pairs(wepent.Attachments) do
                local v = attCategory.last
                local att = CustomizableWeaponry.registeredAttachmentsSKey[attCategory.atts[v]]
                
                if att then
                    local pos = 1

                    if att.dependencies or attCategory.dependencies or (wepent.AttachmentDependencies and wepent.AttachmentDependencies[att.name]) then
                        pos = #loadOrder + 1
                    end

                    table.insert(loadOrder, pos, {category = k, position = v})
                end
            end

			weapon:detachAll()

            for k, v in pairs(loadOrder) do
                weapon:attach(v.category, v.position - 1)
            end

			self:SendLua("LocalPlayer().DoNotPlayInteract = nil")
        end

        if wepent and wepent:GetClass() == "weapon_special_gaus" then
            if wepent.CanCharge != true then
                weapon.CanCharge = false
                weapon.Shooting = false
            end
        end

		if wepent and wepent:GetClass():find("item_medkit_") then
			if wepent.Heal_Left then
				weapon.Heal_Left = wepent.Heal_Left
			end
		end

		if wepent and wepent:GetClass() == "item_drink_294" then
			if wepent.effect then
				weapon.effect = wepent.effect
			end
			if wepent.sip then
				weapon.sip = wepent.sip
			end

			print(weapon.sip, wepent.sip)
		end

        if wepent then
            if wepent.Copied == true then
                weapon.Copied = true
            end
        end

        return weapon
    end

    function mply:BreachGive(classname)
        self:Give(classname)
        timer.Simple(0.1, function()
            self:SelectWeapon(classname)
        end)
    end
end

function GM:PlayerCanPickupWeapon(ply, wep)
    local data = {}
    data.start = ply:GetShootPos()
    data.endpos = data.start + ply:GetAimVector() * 96
    data.filter = ply
    local trace = util.TraceLine(data)

	local tr = ply:GetEyeTrace()
    local wepent = tr.Entity

    if ply:GTeam() != TEAM_SPEC then
        if wep.teams then
            local canuse = true
            for k, v in pairs(wep.teams) do
                if v == ply:GTeam() then
                    canuse = true
                    break 
                end
            end

            if not canuse then
                return true
            end
        end
    end

    if trace.Entity == wep and ply:KeyDown(IN_USE) then
		if (ply:GTeam() == TEAM_SCP || ply:GTeam() == TEAM_SPEC || ply:Health() <= 0) then
			return false
		end
	
		if (ply.NextPickup || 0) > CurTime() then
			return false
		end
	
		if (ply.ForceToGive and weap:GetClass() == ply.ForceToGive) then
			ply.HasWeaponCheck = {class = ply.ForceToGive, ent = weap}
	
			timer.Simple(.1, function()
				if (ply.HasWeaponCheck and ply.HasWeaponCheck.class and !ply:HasWeapon(ply.HasWeaponCheck.class)) then
					if (ply.HasWeaponCheck.ent and ply.HasWeaponCheck.ent:IsValid()) then
						ply.HasWeaponCheck.ent:Remove()
					end
					ply:Give(ply.HasWeaponCheck.class, false)
				end
				ply.HasWeaponCheck = nil
			end)
			ply.ForceToGive = nil
			return true
		end

		if (wepent:IsWeapon() and wepent:GetPos():DistToSqr(ply:GetPos()) <= 6400) then
			local ent_class = wepent:GetClass()
			if (ply:HasWeapon(ent_class)) then
				ply.NextPickup = CurTime() + 1
				BREACH.Players:ChatPrint(ply, true, true, "У Вас уже есть данный предмет.")
				return false
			end
	
			local maximumdefaultslots = ply:GetMaxSlots()
			local maximumitemsslots = 6
			local maximumnotdroppableslots = 6
			local countdefault = 0
			local countitem = 0
			local countnotdropable = 0
			local is_cw = wepent.CW20Weapon
	
			for _, weapon in ipairs(ply:GetWeapons()) do
				if (is_cw and weapon.CW20Weapon and weapon.Primary.Ammo == wepent.Primary.Ammo) then
					ply.NextPickup = CurTime() + 1
					BREACH.Players:ChatPrint(ply, true, true, "У Вас уже есть данный тип оружия.")
					return
				end
				
				if (!weapon.Equipableitem and !weapon.UnDroppable) then
					countdefault = countdefault + 1
				elseif (weapon.Equipableitem) then
					countitem = countitem + 1
				elseif (weapon.UnDroppable) then
					countnotdropable = countnotdropable + 1
				end
			end
	
			if (!wepent.Equipableitem and !wepent.UnDroppable and countdefault >= maximumdefaultslots) then
				ply.NextPickup = CurTime() + 1
				BREACH.Players:ChatPrint(ply, true, true, "Ваш основной инвентарь заполнен.")
				return false
			elseif (wepent.Equipableitem and countitem >= maximumitemsslots) then
				ply.NextPickup = CurTime() + 1
				BREACH.Players:ChatPrint(ply, true, true, "Ваш вторичный инвентарь заполнен.")
				return false
			elseif (wepent.UnDroppable and countnotdropable >= maximumnotdroppableslots) then
				ply.NextPickup = CurTime() + 1
				BREACH.Players:ChatPrint(ply, true, true, "Ваш основной инвентарь заполнен.")
				return false
			end
	
			local physobj = wepent:GetPhysicsObject()
			if (physobj and physobj:IsValid()) then
				physobj:EnableMotion(false)
			end
	
			ply:BrProgressBar("l:progress_wait", 0.5, "nextoren/gui/icons/hand.png", trace.Entity, true, function()
				if (wepent:IsWeapon()) then
					ply:EmitSound("nextoren/charactersounds/inventory/nextoren_inventory_itemreceived.wav", 75, math.random(98, 105), 1, CHAN_STATIC)

					if (ply and ply:IsValid() and not ply:HasWeapon(ent_class)) then

						if is_cw and not ent_class:find("gren") then
							ply:BreachGive(ent_class)
						else
							ply:Give(ent_class, true)
						end

						trace.Entity:Remove()
					end
				end
			end, nil, function()
				if (physobj and physobj:IsValid()) then
					physobj:EnableMotion(true)
				end
			end)
			return false
		end
	end

    return ply.BrWeaponGive
end

function GM:PlayerCanPickupItem( ply, item )
	return ply:GTeam() != TEAM_SPEC
end

function GM:AllowPlayerPickup( ply, ent )
    return false
end

// usesounds = true,
function IsInTolerance( spos, dpos, tolerance )
	if spos == dpos then return true end

	if isnumber( tolerance ) then
		tolerance = { x = tolerance, y = tolerance, z = tolerance }
	end

	local allaxes = { "x", "y", "z" }
	for k, v in pairs( allaxes ) do
		if spos[v] != dpos[v] then
			if tolerance[v] then
				if math.abs( dpos[v] - spos[v] ) > tolerance[v] then
					return false
				end
			else
				return false
			end
		end
	end

	return true
end

function GM:PlayerUse(ply, ent)
	if not IsValid(ply) then
		return
	end

    local role = ply:GetRoleName()
    local gteam = ply:GTeam()
    local ctime = CurTime()

    if gteam == TEAM_SPEC then
        return false
    end

	if not ply.lastuse then
        ply.lastuse = 0
    end

    if ply.lastuse > ctime then
        return false
    end

    local trent = ply:GetEyeTrace().Entity
    local trmodel = trent:GetModel()

    local blockeddoors_scp = {1468, 2245, 1358, 553, 1416, 1016, 2070}

    if gteam == TEAM_SCP and IsValid(ent) and ent:GetClass() == "func_button" and not table.Contains(blockeddoors_scp, ent:EntIndex())  then
        timer.Simple(1, function()
            BreachDoor(ply)
        end)
    end
	
    for _, v in pairs(BUTTONS) do
        if v.pos == ent:GetPos() or (v.tolerance and IsInTolerance(v.pos, ent:GetPos(), v.tolerance)) then

            ply.lastuse = ctime + 1

			local function AccessGranted(ply, ent, sound, nextorenmoment, changekeypad, nomessage)
				if nextorenmoment or v.name == "SCP-914" then
					ent:EmitSound("nextoren/others/access_granted.wav", 65, 100, 1, CHAN_AUTO, 0, 1)
				end
		
				if sound and v.name != "SCP-914" then
					ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg", 40)
				end
		
				if changekeypad then
					ChangeSkinKeypad(ply, ent, true)
				end
		
				if not nomessage then
					ply:SetBottomMessage("l:access_granted")
				end
			end
		
			local function AccessDenied(ply, ent, sound, nextorenmoment, changekeypad, idinaxuy, nomessage)
				if nextorenmoment or v.name == "SCP-914" then
					ent:EmitSound("nextoren/others/access_denied.wav", 67, 100, 1, CHAN_AUTO, 0, 1)
				end
		
				if sound and v.name != "SCP-914" then
					ply:EmitSound("nextoren/weapons/keycard/keycarduse_2.ogg", 42)
				end
		
				if changekeypad then
					ChangeSkinKeypad(ply, ent, false)
				end
		
				if not nomessage then
					if idinaxuy then
						ply:SetBottomMessage("l:keycard_needed")
					else
						ply:SetBottomMessage("l:access_denied")
					end
				end
			end
		
            local keycard = ply:GetActiveWeapon():GetClass() or ""

            if GetGlobalString("RoundName") == "ww2tdm" then
                ply:SetBottomMessage("There's no way back soldier! FIGHT LIKE A MAN!")
                return false
            end

            if v.name == "Комната Д-Блока" and ent:GetClass("func_door") then
                if preparing then
                    ply:SetBottomMessage("l:access_denied")
                    return false
                else
                    return true
                end
            end

			if v.keycardnotrequired then
                if v.custom_access_granted then
                    if v.custom_access_granted(ply, ent) then
                        AccessGranted(ply, ent, false, false, true, true)
                        return true
                    else
                        AccessDenied(ply, ent, false, false, true, false, true)
                        return false
                    end
                end
            end

			if (v.name == "Ворота A" or v.name == "Ворота B" or v.name == "Ворота C" or v.name == "Ворота D" or v.name == "КПП #1" or v.name == "КПП #2" or v.name == "КПП #3" or v.name == "КПП #4") and GetGlobalBool("Evacuation") == true and not m_UIUCanEscape == true then
				AccessGranted(ply, ent, false, false, true, true)
				return true
			end

			if (v.name == "Ворота A" or v.name == "Ворота B" or v.name == "Ворота C" or v.name == "Ворота D") and m_UIUCanEscape == true then
                if keycard == "breach_keycard_support" or keycard == "breach_keycard_crack" or 
                    ply:GetActiveWeapon():GetClass() == "breach_keycard_usa_spy" and ply.TempValues.FBIHackedTerminal then
                    AccessGranted(ply, ent, false, false, true, true)
                    return true
                else
                    AccessDenied(ply, ent, true, false, true)
                    return false
                end
            end

            if v.access then
				local function CheckAccess(ply, v, ent)
					local wep = ply:GetActiveWeapon()
					local keycardlevel = wep.CLevels
			
					if (keycardlevel.CLevel >= v.access.CLevel and v.access.CLevel != 0) then
						AccessGranted(ply, ent, true, false, true)
						return true
					elseif (keycardlevel.CLevelSCI >= v.access.CLevelSCI and v.access.CLevelSCI != 0) then
						AccessGranted(ply, ent, true, false, true)
						return true
					elseif (keycardlevel.CLevelMTF >= v.access.CLevelMTF and v.access.CLevelMTF != 0) then
						AccessGranted(ply, ent, true, false, true)
						return true
					elseif (keycardlevel.CLevelGuard >= v.access.CLevelGuard and v.access.CLevelGuard != 0) then
						AccessGranted(ply, ent, true, false, true)
						return true
					elseif (keycardlevel.CLevelSUP >= v.access.CLevelSUP and v.access.CLevelSUP != 0) then
						AccessGranted(ply, ent, true, false, true)
						return true
					else
						AccessDenied(ply, ent, true, false, true)
						return false
					end
				end			
	
                if v.locked then
                    AccessDenied(ply, ent, false, false, true, true)
                    return false
                end

                if v.evac then
                    AccessGranted(ply, ent, false, false, true)
                    return true
                end

                if keycard == "" or keycard:sub(1, 14) != "breach_keycard" then
                    AccessDenied(ply, ent, false, false, false, true)
                    return false
                end

                if v.name == "Побег О5" or v.name == "Вертолетная Площадка" then
                    if v.custom_access_granted and v.custom_access_granted(ply, ent) then
                        ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                        ply:SetBottomMessage("l:access_granted")
                        ChangeSkinKeypad(ply, ent, true)
                        return true
                    else
                        ply:EmitSound("nextoren/weapons/keycard/keycarduse_2.ogg")
                        ply:SetBottomMessage("l:access_denied")
                        ChangeSkinKeypad(ply, ent, false)
                        return false
                    end
                end

				if v.custom_access_granted then
                    if v.name:find("КПП") then
                        if SCPLockDownHasStarted == true then
                            return CheckAccess(ply, v, ent)
                        else
                            AccessDenied(ply, ent, true, false, true)
                            return false
                        end
                    elseif not v.custom_access_granted(ply, ent) then
                        AccessDenied(ply, ent, true, false, true)
                        return false
                    end
                end

                if v.allowed_keycards then
                    for somekeycard, _ in pairs(v.allowed_keycards) do
                        if somekeycard == keycard then
                            AccessGranted(ply, ent, true, false, true)
                            return true
                        end
                    end
				end

                return CheckAccess(ply, v, ent)
            end
        end
    end
end
	
function GM:CanPlayerSuicide( ply )
	return false
end