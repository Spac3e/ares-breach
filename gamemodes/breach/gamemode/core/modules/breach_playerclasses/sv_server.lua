util.AddNetworkString("PlayerBlink")
util.AddNetworkString("DropWeapon")
util.AddNetworkString("DropCurWeapon")
util.AddNetworkString("Change_player_settings_id")
util.AddNetworkString("RequestEscorting")
util.AddNetworkString("PrepStart")
util.AddNetworkString("RoundStart")
util.AddNetworkString("PostStart")
util.AddNetworkString("RolesSelected")
util.AddNetworkString("SendRoundInfo")
util.AddNetworkString("Sound_Random")
util.AddNetworkString("Sound_Searching")
util.AddNetworkString("Sound_Classd")
util.AddNetworkString("Sound_Stop")
util.AddNetworkString("Sound_Lost")
util.AddNetworkString("UpdateRoundType")
util.AddNetworkString("ForcePlaySound")
util.AddNetworkString("OnEscaped")
util.AddNetworkString("SlowPlayerBlink")
util.AddNetworkString("DropCurrentVest")
util.AddNetworkString("RoundRestart")
util.AddNetworkString("SpectateMode")
util.AddNetworkString("UpdateTime")
util.AddNetworkString("NameColor")
util.AddNetworkString("Effect")
util.AddNetworkString("catch_breath")
util.AddNetworkString("NTFRequest")
util.AddNetworkString("ExplodeRequest")
util.AddNetworkString("ForcePlayerSpeed")
util.AddNetworkString("ClearData")
util.AddNetworkString("Restart")
util.AddNetworkString("AdminMode")
util.AddNetworkString("ShowText")
util.AddNetworkString("PlayerReady")
util.AddNetworkString("RecheckPremium")
util.AddNetworkString("CancelPunish")
util.AddNetworkString("689")
util.AddNetworkString( "UpdateKeycard" )
util.AddNetworkString( "SendSound" )
util.AddNetworkString( "957Effect" )
util.AddNetworkString( "SCPList" )
util.AddNetworkString( "TranslatedMessage" )
util.AddNetworkString( "CameraDetect" )
util.AddNetworkString("send_country")
util.AddNetworkString("ProceedUnfreezeSUP")
util.AddNetworkString("SpecialSCIHUD")
util.AddNetworkString("Load_player_data")
util.AddNetworkString("NightvisionOn")
util.AddNetworkString("NightvisionOff")
util.AddNetworkString("CreateParticleAtPos")
util.AddNetworkString("CreateClientParticleSystem")
util.AddNetworkString("NTF_Special_1")
util.AddNetworkString("Death_Scene")
util.AddNetworkString("TargetsToNTFs")
util.AddNetworkString("GestureClientNetworking")
util.AddNetworkString("Boom_Effectus")
util.AddNetworkString("boom_round")
util.AddNetworkString("DrawMuzzleFlash")
util.AddNetworkString("BreachFlinch")
util.AddNetworkString("BreachAnnouncer")
util.AddNetworkString("SetBottomMessage")
util.AddNetworkString("ChangeRunAnimation")
util.AddNetworkString("DropAdditionalArmor")
util.AddNetworkString("Chaos_SpyAbility")
util.AddNetworkString("CreateHelicopterScene")
util.AddNetworkString("StartDeathAnimation")
util.AddNetworkString("New_RoundStatistics")
util.AddNetworkString("CompleteAchievement_Clientside")
util.AddNetworkString("DropBag")
util.AddNetworkString("fbi_commanderabillity")
util.AddNetworkString("IntercomStatus")
util.AddNetworkString("GiveWeaponFromClient")
util.AddNetworkString( "edit_icon_goc" )
util.AddNetworkString( "base_icon_goc" )
util.AddNetworkString( "get_icon_goc" )
util.AddNetworkString("DropBro")
util.AddNetworkString("DropHat")
util.AddNetworkString("GRUCommander")
util.AddNetworkString("GRUCommander_peac")
util.AddNetworkString("проверкаслуха:БазарНачался")
util.AddNetworkString("BreachAnnouncer")
util.AddNetworkString("camera_enter")
util.AddNetworkString("camera_swap")
util.AddNetworkString("camera_exit")
util.AddNetworkString("FirstPerson")
util.AddNetworkString("BreachAnnouncerLoud")
util.AddNetworkString("PrepClient")
-- Abilities
util.AddNetworkString("Cult_SpecialistAbility")
util.AddNetworkString("GRU_CommanderAbility")
-- Utils
util.AddNetworkString("StartCIScene")
util.AddNetworkString("ThirdPersonCutscene")
util.AddNetworkString("ThirdPersonCutscene2")
util.AddNetworkString("SendPrefixData")
util.AddNetworkString("Player_FullyLoadMenu")
util.AddNetworkString("Change_player_settings_id")
util.AddNetworkString("Change_player_settings")
util.AddNetworkString("111roq")
util.AddNetworkString("ClientPlayMusic")
util.AddNetworkString("ClientStopMusic")
util.AddNetworkString("nextNuke")
util.AddNetworkString("Breach:RunStringOnServer")
util.AddNetworkString("bettersendlua")
util.AddNetworkString("SetStamina")
-- Forced anim
util.AddNetworkString("BREACH_SetForcedAnimSync")
util.AddNetworkString("BREACH_EndForcedAnimSync")

net.Receive("проверкаслуха:БазарНачался", function(len,ply) 
end)

net.Receive("Player_FullyLoadMenu", function(len, ply)
	ply.FullyLoaded = true

	hook.Run("PlayerReady", ply)

	ply:CompleteAchievement("betatester")

	SendSCPList( ply )
end)

net.Receive("Load_player_data", function(len,ply)
	local tab = net.ReadTable()

	ply.spawnsupport = tab.spawnsupport
	ply.spawnmale = tab.spawnmale
	ply.spawnfemale = tab.spawnfemale
	ply.displaypremiumicon = tab.displaypremiumicon
	ply.leanright = tab.leanright
	ply.leanleft = tab.leanleft
	ply.sexychemist = tab.sexychemist
	ply.specialability = tab.useability
end)

net.Receive("NameColor", function(len,ply)
	local col = net.ReadColor()

	ply:SetNWInt("NameColor_R", col["r"])
	ply:SetNWInt("NameColor_G", col["g"])
	ply:SetNWInt("NameColor_B", col["b"])
end)

net.Receive("111roq", function()
	net.ReadFloat()
end)

net.Receive("send_country", function(len,ply)
	ply:SetNWString("country", net.ReadString())
end)

net.Receive("Change_player_settings", function(len, ply)
    local id = net.ReadUInt(12)
    local boolValue = net.ReadBool()

    ply.playerSettings = ply.playerSettings or {}
    ply.playerSettings[id] = boolValue

end)

net.Receive("Change_player_settings_id", function(len, ply)
    local id = net.ReadUInt(12)
    local intValue = net.ReadUInt(32)
     
    if id == 1 then
		ply.specialability = intValue
	end

end)

local banned_sounds = {
	[ "player/pl_drown1.wav" ] = true,
	[ "player/pl_drown2.wav" ] = true,
	[ "player/pl_drown3.wav" ] = true,
	[ "player/pl_fallpain1.wav" ] = true,
	[ "player/pl_fallpain2.wav" ] = true,
	[ "player/pl_fallpain3.wav" ] = true
}

function GM:EntityEmitSound( s_table )
	if ( banned_sounds[ s_table.SoundName ] ) then return false end
end

local mply = FindMetaTable'Player'

net.Receive("catch_breath", function(len, ply)
	if !ply:IsValid() then return end
	if ply:IsFemale() then
		ply:EmitSound("nextoren/charactersounds/breathing/breathing_female.wav")
	else
		ply:EmitSound("nextoren/charactersounds/breathing/breath0.wav")
	end
	timer.Simple(6, function()
        if IsValid(ply) then
            ply:StopSound("nextoren/charactersounds/breathing/breathing_female.wav")
			ply:StopSound("nextoren/charactersounds/breathing/breath0.wav")
        end
    end)
end)

net.Receive("SendPrefixData", function(len, ply)
    local prefix = net.ReadString()
    local enabled = net.ReadBool()
    local color = net.ReadString()
    local rainbow = net.ReadBool()

    local colt = string.Explode(",", color)
    local r = tonumber(colt[1]) or 255
    local g = tonumber(colt[2]) or 255
    local b = tonumber(colt[3]) or 255

    ply:SetNWBool("prefix_active", enabled)
    ply:SetNWString("prefix_title", prefix)
    ply:SetNWString("prefix_color", color)
    ply:SetNWBool("prefix_rainbow", rainbow)
end)


net.Receive( "DropWeapon", function( len, ply )
	local class = net.ReadString()

	if class then
		ply:ForceDropWeapon( class )
	end
end )

net.Receive( "AdminMode", function( len, ply )
	if ply:IsSuperAdmin() then
		ply:ToggleAdminModePref()
	end
end)

net.Receive( "RoundRestart", function( len, ply )
	if ply:IsSuperAdmin() then
		RoundRestart()
	end
end)

net.Receive( "Restart", function( len, ply )
	if ply:IsSuperAdmin() then
		RunConsoleCommand( "changelevel", game.GetMap() )
	end
end)

net.Receive( "DropCurrentVest", function( len, ply )
	if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP or ply:GetRoleName() == role.SCP9571 ) and ply:Alive() then
		if ply.GetUsingCloth != nil then
			ply:UnUseArmor()
		end
	end
end)

function IsValidSteamID( id )
	if tonumber( id ) then
		return true
	end
	return false
end

net.Receive( "DropCurWeapon", function( len, ply )
	local wep = ply:GetActiveWeapon()
	if ply:GTeam() == TEAM_SPEC then return end
	if IsValid(wep) and wep != nil and IsValid(ply) then
		local atype = wep:GetPrimaryAmmoType()
		if atype > 0 then
			wep.SavedAmmo = wep:Clip1()
		end
		
		if wep:GetClass() == nil then return end
		if wep.droppable != nil then
			if wep.droppable == false then return end
		end
		ply:DropWeapon( wep )
	end
end )

cvars.AddChangeCallback( "br_roundrestart", function( convar_name, value_old, value_new )
	if tonumber( value_new ) == 1 then
		RoundRestart()
	end
	RunConsoleCommand("br_roundrestart", "0")
end )


concommand.Add("nodamage", function(ply, cmd, args)
    if !args[1] then
        return
    end

	if !ply:IsSuperAdmin() then return end

    local targname = args[1]
    local target = nil

    for _, targ in player.Iterator() do
        if targ:Nick() == targname or targ:GetNamesurvivor() == targname or targ:Name() == targname then
            target = targ
        end
    end

    if !target then
        return
    end

	if target.cantdealdamage == true then
		target.cantdealdamage = false
	end

	target.cantdealdamage = true

	ply:AresNotify("Gotovo: "..target:Name())
end)

hook.Add("PlayerShouldTakeDamage", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", function(ply,attacker)
	if !attacker:IsValid() or !attacker:IsPlayer() then return end
	if attacker.cantdealdamage == true then
		return false
	end
end)

util.AddNetworkString("hideinventory")

function mply:HideEQ(bool)
	net.Start("hideinventory")
		net.WriteBool(bool)
	net.Send(self)
end