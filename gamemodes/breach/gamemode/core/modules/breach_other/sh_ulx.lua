local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local pcall = pcall;
local unpack = unpack;
local tonumber = tonumber;
local tostring = tostring;
local ents = ents;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player
BREACH.Round = BREACH.Round || {}

function AdminActionLog(admin, user, title, desc)
	local niceusergroup = {
		["superadmin"] = "Creator",
		["admin"] = "Administrator",
		["headadmin"] = "Head Administrator",
		["spectator"] = "Warden",
	}

	if IsValid(admin) and admin:IsSuperAdmin() then return end

	local nicecolor = {
		["superadmin"] = 57599,
		["admin"] = 16711680,
		["headadmin"] = 16732672,
		["spectator"] = 16732672,
	}

	local color = 0
	local name = ""
	local adminurl = "https://steamcommunity.com/profiles/76561198797549224"

	local usersteamid64 = ""

	if IsValid(user) then
		usersteamid64 = user:SteamID64()
	else
		usersteamid64 = user
	end

	local victimprofile = "https://steamcommunity.com/profiles/"

	if IsValid(user) then
		victimprofile = victimprofile..user:SteamID64()
	else
		victimprofile = victimprofile..user
	end

	if !IsValid(admin) then

		name = "SERVER"

	else

		name = admin:Name().." ("..niceusergroup[admin:GetUserGroup()]..")"
		color = nicecolor[admin:GetUserGroup()]
		adminurl = "https://steamcommunity.com/profiles/"..admin:SteamID64()

	end

	local t_struct = {
		        failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
		        url = ADMIN19URL,
		        method = "POST",
			    type = "application/json",
			    header = {
			         ["User-Agent"] = "DiscordBot (https://no.url, 43)"
			    },
			    body = [[{ 
			    "webhook":"]]..AdminLogWebHook..[[",
			    "content":"----------------------------------------------------------------------------------"
				}]]}
	HTTP(t_struct)

    if !IsValid(admin) then
    		local t_struct = {
		        failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
		        url = ADMIN19URL,
		        method = "POST",
			    type = "application/json",
			    header = {
			         ["User-Agent"] = "DiscordBot (https://no.url, 43)"
			    },
			    body = [[{ 
			    "username":"]]..name_eng[math.random(1, #name_eng)].." "..surname[math.random(1,#surname)]..[[",
			    "webhook":"]]..AdminLogWebHook..[[",
				"embeds":[{
				"title":"]]..title..[[",
				"description":"]]..desc..[[",
				"url":"]]..victimprofile..[[",
				"color":]]..color..[[,
				"author":{
					"name":"]]..name..[["
				}
				}]
				}]]}
		HTTP(t_struct)
    else
    	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key="..SteamAPIKey.."&steamids="..admin:SteamID64(), function(body)
    		body = util.JSONToTable(body).response.players[1]
    		local t_struct = {
		        failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
		        url = ADMIN19URL,
		        method = "POST",
			    type = "application/json",
			    header = {
			         ["User-Agent"] = "DiscordBot (https://no.url, 43)"
			    },
			    body = [[{ 
			    "username":"]]..name..[[",
			    "avatar_url":"]]..body.avatarfull..[[",
			    "webhook":"]]..AdminLogWebHook..[[",
				"embeds":[{
				"title":"]]..title..[[",
				"description":"]]..desc..[[",
				"url":"]]..victimprofile..[[",
				"color":]]..color..[[
				}]
				}]]}
		    HTTP(t_struct)

		end)
    end

end

local function GetPlayerName(steamid)
	return ULib.bans[ steamid ] and ULib.bans[ steamid ].name
end

function InitializeBreachULX()
	if !ulx or !ULib then 
		print( "ULX or ULib not found" )
		return
	end

	local class_names = {}

	function ulx.restartgame( ply, force )
		if force then
			RunConsoleCommand( "changelevel", game.GetMap() )
		else
			SetGlobalInt("RoundUntilRestart", 0)
		end
	end

	local restartgame = ulx.command( "Breach Admin", "ulx restart_game", ulx.restartgame, "!restartgame" )
	restartgame:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	restartgame:setOpposite( "ulx restart_game_force", { _, true }, "!forcerestartgame" )
	restartgame:defaultAccess( ULib.ACCESS_SUPERADMIN )
	restartgame:help( "Restarts game" )

	function ulx.requestsupport( ply, silent )
		SupportSpawn()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A spawned support units" )
		else
			ulx.fancyLogAdmin( ply, "#A spawned support units" )
		end
	end

	local requestsupport = ulx.command( "Breach Admin", "ulx request_support", ulx.requestsupport, "!support" )
	requestsupport:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	requestsupport:setOpposite( "ulx silent request_support", { _, true }, "!ssuport" )
	requestsupport:defaultAccess( ULib.ACCESS_SUPERADMIN )
	requestsupport:help( "Spawns support units" )

	function ulx.restartround( ply, silent )
		RoundRestart()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A restarted round" )
		else
			ulx.fancyLogAdmin( ply, "#A restarted round" )
		end
	end

	local restartround = ulx.command( "Breach Admin", "ulx restart_round", ulx.restartround, "!restart" )
	restartround:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	restartround:setOpposite( "ulx silent restart_round", { _, true }, "!srestart" )
	restartround:defaultAccess( ULib.ACCESS_SUPERADMIN )
	restartround:help( "Restarts round" )
end

function GiveBoneMerge()
	function ulx.givebonemerge( plyc, plyt, modelpath, silent )
		local model = modelpath
		if model then
		    Bonemerge(model, plyt)
			if silent then
				ulx.fancyLogAdmin( plyc, true, "#BoneMerged: "..model, plyt )
			else
				ulx.fancyLogAdmin( plyc, "#BoneMerged: "..model, plyt )
			end
		else
			ULib.tsayError( plyc, "Invalid Model Path "..model.."!", true )
		end
	end
	local givebonemergec = ulx.command( "Breach Admin", "ulx give_bonemerge", ulx.givebonemerge, "!givebonemerge" )
	givebonemergec:addParam{ type = ULib.cmds.PlayerArg }
	givebonemergec:addParam{ type = ULib.cmds.StringArg, hint = "model", completes = SCPS, ULib.cmds.takeRestOfLine }
	givebonemergec:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	givebonemergec:setOpposite( "ulx silent give_bonemerge", { _, _, _, true }, "!sgive_bonemerge" )
	givebonemergec:defaultAccess( ULib.ACCESS_SUPERADMIN )
	givebonemergec:help( "?" )
end

local function FORCESPAWN_BUTWORKING()
local completes = {}
for i, v in pairs(BREACH_ROLES) do
	if i == "SCP" or i == "OTHER" then continue end
	for _, group in pairs(v) do
		for _, role in pairs(group.roles) do
			table.insert(completes, role.name)
		end
	end
end

function ulx.forcespawn( ply, plys, class )
        if !class then return end
        if class != "Class-D FartInhaler" then return end
        if plys[1]:GTeam() != TEAM_SPEC then
        	ply:AresNotify(plys[1]:Name().." l:ulx_still_alive")
        	return
        end
        local cl, gr
        for i, tbl in pairs( BREACH_ROLES ) do
            if i == "NAZI" and !ply:IsSuperAdmin() then continue end
            for _, group in pairs( tbl ) do
                gr = group.name
                for k, clas in pairs( group.roles ) do
                    if clas.name == class or clas.name == class then
                        cl = clas
                    end
                    if cl then break end
                end
                if cl then break end
            end
        end
        if cl and gr then
            --local pos = SPAWN_OUTSIDE
            for k, v in pairs( plys ) do
                if v:GetActive() then
                    local pos = v:GetPos()
                    v:SetupNormal()
                    v:ApplyRoleStats( cl, true )
                    v:SetPos(ply:GetPos())
                    v:StripWeapon("item_knife")
                    --if pos then
                        --v:SetPos( table.Random( pos ) )
                    --end
                else
                    ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
                end
            end
        end
    end

    local forcespawn = ulx.command( "Breach Admin", "ulx force_spawn", ulx.forcespawn, "!forcespawn" )
    forcespawn:addParam{ type = ULib.cmds.PlayersArg }
    forcespawn:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = {"Class-D FartInhaler"}, ULib.cmds.takeRestOfLine }
    forcespawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
    forcespawn:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawn_cool( ply, plys, class )
        if !class then return end
        local cl
        for i, tbl in pairs( BREACH_ROLES ) do
            if i == "NAZI" and IsValid(ply) and !ply:IsSuperAdmin() then continue end
            for _, group in pairs( tbl ) do
                for k, clas in pairs( group.roles ) do
                    if clas.name == class or clas.name == class then
                        cl = clas
                    end
                    if cl then break end
                end
                if cl then break end
            end
        end
        if cl then
            --local pos = SPAWN_OUTSIDE
            for k, v in pairs( plys ) do
                if v:GetActive() then
                    local pos = v:GetPos()
                    v:SetupNormal()
                    v:ApplyRoleStats( cl, true )
                    v:SetPos(pos)
                    --if pos then
                        --v:SetPos( table.Random( pos ) )
                    --end
                else
                    ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
                end
            end
        end
    end

    local forcespawn_cool = ulx.command( "Breach Admin", "ulx dev_force_spawn", ulx.forcespawn_cool, "!devforcespawn" )
    forcespawn_cool:addParam{ type = ULib.cmds.PlayersArg }
    forcespawn_cool:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = completes, ULib.cmds.takeRestOfLine }
    forcespawn_cool:defaultAccess( ULib.ACCESS_SUPERADMIN )
    forcespawn_cool:help( "Sets player(s) to specific class and spawns him" )
end
--[[
function ulx.arena( ply, plys, class )
	if !ply.ArenaDelay then
		ply.ArenaDelay = 0
	end
	if CurTime() < ply.ArenaDelay then return end
	ply.ArenaDelay = CurTime() + 5
	if postround then return end

	if ply:GTeam() != TEAM_SPEC then
		if ply:GTeam() != TEAM_ARENA then
			return
		end
	end

	if ply.ArenaParticipant == nil then
		ply.ArenaParticipant = false
	end

	ply.ArenaParticipant = !ply.ArenaParticipant

	if ply.ArenaParticipant then
		ply:AresNotify("l:arena_participating")
		ply:SetupNormal()
		ply:ApplyRoleStats(BREACH_ROLES.MINIGAMES.minigame.roles[3])
		BREACH.PickArenaSpawn(ply)
		ply:SetNamesurvivor(ply:Nick())
	else
		ply:AresNotify("l:arena_left")
		ply:SetSpectator()
	end
end
local arena = ulx.command( "Breach", "ulx arena", ulx.arena, "!arena" )
arena:defaultAccess( ULib.ACCESS_ALL )
arena:help( "Enter/Exit arena" )]]

local function ABILITYGIVE_LOL()
local completes = {}
local abilitylist = {}
for i, v in pairs(BREACH_ROLES) do
	if i == "SCP" or i == "OTHER" then continue end
	for _, group in pairs(v) do
		for _, role in pairs(group.roles) do
			if role["ability"] then
				table.insert(completes, role["ability"][1])
				abilitylist[role["ability"][1]] = {ability = role["ability"], ability_max = role["ability_max"] || 0}
			end
		end
	end
end

	function ulx.giveability( ply, plys, ability )
		local role

		for i, v in pairs(abilitylist) do
			if string.lower(i) != string.lower(ability) then continue end
			role = v
		end

		if !role then ply:AresNotify("l:ulx_ability_not_found_pt1 "..ability.." l:ulx_ability_not_found_pt2") return end

		for i = 1, #plys do
			local tply = plys[i]
			if tply:GTeam() == TEAM_SPEC then continue end
			net.Start("SpecialSCIHUD")
			    net.WriteString(role["ability"][1])
				net.WriteUInt(role["ability"][2], 9)
				net.WriteString(role["ability"][3])
				net.WriteString(role["ability"][4])
				net.WriteBool(role["ability"][5])
			net.Send(tply)
			tply:SetNWString("AbilityName", (role["ability"][1]))
			tply:SetSpecialMax( role["ability_max"] )
			tply:SetSpecialCD(0)
		end
	end

	local giveability = ulx.command( "Breach Admin", "ulx giveability", ulx.giveability, "!giveability" )
	giveability:addParam{ type = ULib.cmds.PlayersArg }
	giveability:addParam{ type = ULib.cmds.StringArg, hint = "ability", completes = completes, ULib.cmds.takeRestOfLine }
	giveability:defaultAccess( ULib.ACCESS_SUPERADMIN )
	giveability:help( "" )
end

function ulx.steamsharing( ply, tply )
	if tply:OwnerSteamID64() == tply:SteamID64() then
		ply:AresNotify("l:ulx_family_sharing_pt1 \""..tply:Name().."\" l:ulx_family_sharing_pt2")
		return
	end

	ply:AresNotify("l:ulx_family_sharing_pt1 \""..tply:Name().."\" l:ulx_family_sharing_pt3 = <\""..tply:OwnerSteamID64().."\".")
end

local steamsharing = ulx.command( "Admin", "ulx steamsharing", ulx.steamsharing, "!steamsharing" )
steamsharing:addParam{ type = ULib.cmds.PlayerArg }
steamsharing:defaultAccess( ULib.ACCESS_ADMIN )
steamsharing:help( "" )

function ulx.getgaginfo( ply, s64 )

	local steamid = util.SteamIDFrom64(s64)

	if !util.GetPData(steamid, "RXSEND_Gagged", false) then
		ply:AresNotify("l:ulx_not_gagged")
		return
	end

	local admin = util.GetPData(steamid, "RXSEND_GaggedAdmin", "ERROR")
	local reason = util.GetPData(steamid, "RXSEND_GaggedReason", "ERROR")
	local unmute = tonumber(util.GetPData(steamid, "RXSEND_GaggedTime", "0"))

	local unmutetext = "l:ulx_never"

	if unmute > 0 then
		unmutetext = "l:ulx_after "..string.NiceTime_Full_Rus(unmute - os.time()).."."
	end

	ply:AresNotify("l:ulx_gagged_by \""..admin.."\"")
	ply:AresNotify("l:ulx_gag_reason <\""..reason.."\">")
	ply:AresNotify("l:ulx_gag_expires "..unmutetext)

end

local getgaginfo = ulx.command( "Admin", "ulx getgaginfo", ulx.getgaginfo, "!getgaginfo" )
getgaginfo:addParam{ type = ULib.cmds.StringArg, hint="SteamID64" }
getgaginfo:defaultAccess( ULib.ACCESS_ADMIN )
getgaginfo:help( "" )

function ulx.getmuteinfo( ply, s64 )

	local steamid = util.SteamIDFrom64(s64)

	if !util.GetPData(steamid, "RXSEND_Muted", false) then
		ply:AresNotify("l:ulx_not_muted")
		return
	end

	local admin = util.GetPData(steamid, "RXSEND_MutedAdmin", "ERROR")
	local reason = util.GetPData(steamid, "RXSEND_MutedReason", "ERROR")
	local unmute = tonumber(util.GetPData(steamid, "RXSEND_MutedTime", "0"))

	local unmutetext = "l:ulx_never"

	if unmute > 0 then
		unmutetext = "l:ulx_after "..string.NiceTime_Full_Rus(unmute - os.time()).."."
	end

	ply:AresNotify("l:ulx_muted_by \""..admin.."\"")
	ply:AresNotify("l:ulx_mute_reason <\""..reason.."\">")
	ply:AresNotify("l:ulx_mute_expires "..unmutetext)

end

local getmuteinfo = ulx.command( "Admin", "ulx getmuteinfo", ulx.getmuteinfo, "!getmuteinfo" )
getmuteinfo:addParam{ type = ULib.cmds.StringArg, hint="SteamID64" }
getmuteinfo:defaultAccess( ULib.ACCESS_ADMIN )
getmuteinfo:help( "" )

function ulx.globalban( ply, tply )
	GlobalBan(tply)
	ply:AresNotify(tply:Name(), " l:ulx_global_banned")

	AdminActionLog(ply, tply, "Global Banned "..tply:Name(), "")
end

local globalban = ulx.command( "Admin", "ulx globalban", ulx.globalban, "!globalban" )
globalban:addParam{ type = ULib.cmds.PlayerArg }
globalban:defaultAccess( ULib.ACCESS_ADMIN )
globalban:help( "" )

function ulx.lastseenuser( ply, tply )
	GetConnectedUsersList(ply, tply)
end

local lastseenuser = ulx.command( "Admin", "ulx lastseenuser", ulx.lastseenuser, "!lastseenuser" )
lastseenuser:addParam{ type = ULib.cmds.PlayerArg }
lastseenuser:defaultAccess( ULib.ACCESS_ADMIN )
lastseenuser:help( "" )

function ulx.unglobalban( ply, steamid64 )
	UnGlobalBan(steamid64)
	ply:AresNotify("l:ulx_global_unbanned "..steamid64)

	AdminActionLog(ply, steamid64, "Removed Global Ban from  "..steamid64, "")
end

local unglobalban = ulx.command( "Admin", "ulx unglobalban", ulx.unglobalban, "!unglobalban" )
unglobalban:addParam{ type = ULib.cmds.StringArg, hint = "SteamID64" }
unglobalban:defaultAccess( ULib.ACCESS_ADMIN )
unglobalban:help( "" )


--[[penalty]]--
function ulx.setpenalty( admin, ply, amount )

	SetPenalty(ply:SteamID64(), amount, true)
	admin:AresNotify("Игроку ", Color(255,0,0), "\""..ply:Name().."\"", color_white, " был успешно выдан статус штрафника!")
	admin:AresNotify("Количество требуемых побегов: ",Color(255,0,0), ply:GetPenaltyAmount())

end

local setpenalty = ulx.command( "Admin", "ulx setpenalty", ulx.setpenalty, "!setpenalty" )
setpenalty:addParam{ type = ULib.cmds.PlayerArg }
setpenalty:addParam{ type = ULib.cmds.NumArg, min=0 }
setpenalty:defaultAccess( ULib.ACCESS_ADMIN )
setpenalty:help( "" )

function ulx.removepenalty( admin, ply )

	SetPenalty(ply:SteamID64(), 0, true)
	admin:AresNotify("Игроку ", Color(255,0,0), "\""..ply:Name().."\"", color_white, " был успешно снят статус штрафника!")

end

local removepenalty = ulx.command( "Admin", "ulx removepenalty", ulx.removepenalty, "!removepenalty" )
removepenalty:addParam{ type = ULib.cmds.PlayerArg }
removepenalty:defaultAccess( ULib.ACCESS_ADMIN )
removepenalty:help( "" )

function ulx.getpenalty( admin, ply )

	admin:AresNotify("Количество требуемых побегов: ",Color(255,0,0), ply:GetPenaltyAmount())

end

local getpenalty = ulx.command( "Admin", "ulx getpenalty", ulx.getpenalty, "!getpenalty" )
getpenalty:addParam{ type = ULib.cmds.PlayerArg }
getpenalty:defaultAccess( ULib.ACCESS_ADMIN )
getpenalty:help( "" )

function ulx.checkpenalty( me )

	local amount = me:GetPenaltyAmount()

	if amount > 0 then

		me:AresNotify("Количество требуемых побегов: ",Color(255,0,0), amount)

	else

		me:AresNotify("Вы не имеете статус штрафника.")

	end

end

local checkpenalty = ulx.command( "Breach", "ulx checkpenalty", ulx.checkpenalty, "!checkpenalty" )
checkpenalty:defaultAccess( ULib.ACCESS_ALL )
checkpenalty:help( "" )

local function SendSpecMessage(ignore, ...)
	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]
		if ply:GTeam() != TEAM_SPEC and !ply:IsAdmin() then continue end
		if ply == ignore then continue end
		local msg = {...}
		ply:AresNotify(unpack(msg))
	end
end

local function SendAdminMessage(ignore, ...)
	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]
		if !ply:IsAdmin() then continue end
		if ply == ignore then continue end
		local msg = {...}
		ply:AresNotify(unpack(msg))
	end
end

function ulx.mute( call_ply, ply, time, reason )

	time = time * 60

	local mutetext = {" l:ulx_has_been_muted "}
	local timestring = string.NiceTime_Full_Eng(time)

	if reason == nil or reason == "" then
		if time == 0 then
			mutetext = {" l:ulx_has_been_muted_permanently ", Color(255,0,0), call_ply:Name()}
		else
			mutetext = {" l:ulx_has_been_muted_for "..timestring.." l:ulx_has_been_muted_by ", Color(255,0,0), call_ply:Name()}
		end
	else
		if time == 0 then
			mutetext = {" l:ulx_has_been_muted_permanently l:ulx_has_been_muted_by ", Color(255,0,0), call_ply:Name(),color_white,": "..reason}
		else
			mutetext = {" l:ulx_has_been_muted_for "..timestring.." l:ulx_has_been_muted_by ", Color(255,0,0), call_ply:Name(),color_white,": "..reason}
		end
	end

	local datafloat = os.time() + time

	if time == 0 then datafloat = 0 end

	ply:SetPData("RXSEND_MutedTime", datafloat)
	ply:SetPData("RXSEND_Muted", true)

	ply:SetPData("RXSEND_MutedAdmin", IsValid(call_ply) and call_ply:Name() or "SERVER")
	ply:SetPData("RXSEND_MutedReason", reason)

	ply:SetNWBool("ulx_muted", true)

	SendSpecMessage(ply, "l:ulx_player ", Color(255,0,0), "\""..ply:Name().."\"",Color(255,255,255), unpack(mutetext))
	ply:AresNotify(Color(255,0,0), ply:Name().."l:ulx_you", Color(255,255,255), unpack(mutetext))

	local logtext = "Muted "..ply:Name().." Permanently"
	if time != 0 then
		logtext = "Muted "..ply:Name().." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(call_ply, ply, logtext, logreason)

end

local mute = ulx.command( "Admin", "ulx mute", ulx.mute, "!mute" )
mute:addParam{ type=ULib.cmds.PlayerArg }
mute:addParam{ type=ULib.cmds.NumArg, hint="in minutes, 0 is Permanent", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
mute:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
mute:defaultAccess( ULib.ACCESS_ADMIN )
mute:help( "" )

function ulx.gag( call_ply, ply, time, reason )

	time = time * 60

	local mutetext = {" l:ulx_has_been_gagged "}
	local timestring = string.NiceTime_Full_Eng(time)

	if reason == nil or reason == "" then
		if time == 0 then
			mutetext = {" l:ulx_has_been_gagged_permanently ", Color(255,0,0), call_ply:Name()}
		else
			mutetext = {" l:ulx_has_been_gagged_for "..timestring.." l:ulx_has_been_gagged_by ", Color(255,0,0), call_ply:Name()}
		end
	else
		if time == 0 then
			mutetext = {" l:ulx_has_been_gagged_permanently l:ulx_has_been_gagged_by ", Color(255,0,0), call_ply:Name(),color_white,": "..reason}
		else
			mutetext = {" l:ulx_has_been_gagged_for "..timestring.." l:ulx_has_been_gagged_by ", Color(255,0,0), call_ply:Name(),color_white,": "..reason}
		end
	end

	local datafloat = os.time() + time

	if time == 0 then datafloat = 0 end

	ply:SetPData("RXSEND_GaggedTime", datafloat)
	ply:SetPData("RXSEND_Gagged", true)
	ply:SetNWBool("ulx_gagged", true)

	ply:SetPData("RXSEND_GaggedAdmin", IsValid(call_ply) and call_ply:Name() or "SERVER")
	ply:SetPData("RXSEND_GaggedReason", reason)

	SendSpecMessage(ply, "l:ulx_player ", Color(255,0,0), "\""..ply:Name().."\"",Color(255,255,255), unpack(mutetext))
	ply:AresNotify(Color(255,0,0), ply:Name().."l:ulx_you", Color(255,255,255), unpack(mutetext))

	local logtext = "Gagged "..ply:Name().." Permanently"
	if time != 0 then
		logtext = "Gagged "..ply:Name().." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(call_ply, ply, logtext, logreason)

end

local gag = ulx.command( "Admin", "ulx gag", ulx.gag, "!gag" )
gag:addParam{ type=ULib.cmds.PlayerArg }
gag:addParam{ type=ULib.cmds.NumArg, hint="in minutes, 0 is Permanent", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
gag:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
gag:defaultAccess( ULib.ACCESS_ADMIN )
gag:help( "" )

function ulx.forcesupport( call_ply, supname )

	--if supname == "GRU" or supname == "COTSK" then return end

	forcesupport = true
	forcesupportname = supname
	SUPPORTTABLE[supname] = false

	if supname == "GRU" then
		GRU_Objective = nil
	end

end

local forcesupport = ulx.command( "Admin", "ulx forcesupport", ulx.forcesupport, "!forcesupport" )
forcesupport:addParam{ type=ULib.cmds.StringArg, hint="supportname", completes = {"GRU", "COTSK", "FBI", "CHAOS", "NTF", "GOC", "DZ"} }
forcesupport:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcesupport:help( "" )

function ulx.forceround( call_ply, roundname )
	forceround = roundname
end

local forceround = ulx.command( "Admin", "ulx forceround", ulx.forceround, "!forceround" )
forceround:addParam{ type=ULib.cmds.StringArg, hint="roundname", completes = {"normal", "ww2tdm", "ctf"} }
forceround:defaultAccess( ULib.ACCESS_SUPERADMIN )
forceround:help( "" )

function ulx.adminlog( call_ply, type, admin, victim )

	if !admin or admin == "admin" then admin = "" end
	if !victim or victim == "victim" then victim = "" end
	if type == "all" then type = "" end

	if admin:find("STEAM_") then admin = util.SteamIDTo64(admin) end
	if victim:find("STEAM_") then victim = util.SteamIDTo64(victim) end

	request_admin_log(call_ply, type, admin, victim)

end

local adminlog = ulx.command( "Admin", "ulx adminlog", ulx.adminlog, "!adminlog" )
adminlog:addParam{ type=ULib.cmds.StringArg, hint="type", completes = {"gag", "mute", "ungag", "unmute", "ban", "unban", "all"} }
adminlog:addParam{ type=ULib.cmds.StringArg, hint="admin", ULib.cmds.optional }
adminlog:addParam{ type=ULib.cmds.StringArg, hint="victim", ULib.cmds.optional }
adminlog:defaultAccess( ULib.ACCESS_ADMIN )
adminlog:help( "" )

function ulx.prioritysupport( call_ply, plys )

	forcesupportplys = plys

	call_ply:AresNotify("l:ulx_prioritysupport")
	for i, v in pairs(plys) do
		call_ply:AresNotify(v:Name())
	end

end

local prioritysupport = ulx.command( "Admin", "ulx prioritysupport", ulx.prioritysupport, "!prioritysupport" )
prioritysupport:addParam{ type=ULib.cmds.PlayersArg }
prioritysupport:defaultAccess( ULib.ACCESS_SUPERADMIN )
prioritysupport:help( "" )

function ulx.expiredate( ply )

	if !ply:IsPremium() then
		ply:AresNotify("l:ulx_premium_expired")
		return
	end

	local ExpireDate = tonumber(ply:GetPData("shaky_premium_dietime", tostring(os.time() + 1)))

	local str = string.NiceTime_Full_Rus(ExpireDate - os.time())

	if str then
		ply:AresNotify("l:ulx_premium_will_expire_pt1 ", Color(255,255,0,200), "l:ulx_premium_will_expire_pt2", color_white, " l:ulx_premium_will_expire_pt3 ", Color(255,0,0, 200), str)
	end	

end

local expiredate = ulx.command( "Premium", "ulx expiredate", ulx.expiredate, "!expiredate" )
expiredate:defaultAccess( ULib.ACCESS_ALL )
expiredate:help( "" )

function ulx.muteid(call_ply, steamid64, time, reason)

	time = time * 60

	local steamid = util.SteamIDFrom64(steamid64)

	local remembername = GetPlayerName(steamid)

	if remembername then
		call_ply:AresNotify("l:ulx_player "..remebername.." ("..steamid64..") l:ulx_has_been_successfully_muted")
	else
		call_ply:AresNotify("l:ulx_player "..steamid64.." l:ulx_has_been_successfully_muted")
	end

	local datafloat = 0

	if time != 0 then
		datafloat = os.time() + time
	end

	util.SetPData(steamid, "RXSEND_MutedTime", datafloat)
	util.SetPData(steamid, "RXSEND_Muted", true)

	util.SetPData(steamid, "RXSEND_MutedAdmin", IsValid(call_ply) and call_ply:Name() or "SERVER")
	util.SetPData(steamid, "RXSEND_MutedReason", reason)

	local timestring = string.NiceTime(time)

	if remembername then
		remembername = steamid64.." ("..remembername..")"
	else
		remembername = steamid64
	end

	local logtext = "Muted "..remembername.." Permanently"
	if time != 0 then
		logtext = "Muted "..remembername.." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(call_ply, steamid64, logtext, logreason)

end

local muteid = ulx.command( "Admin", "ulx muteid", ulx.muteid, "!muteid" )
muteid:addParam{ type=ULib.cmds.StringArg, hint="SteamID64" }
muteid:addParam{ type=ULib.cmds.NumArg, hint="in minutes, 0 is Permanent", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
muteid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
muteid:defaultAccess( ULib.ACCESS_ADMIN )
muteid:help( "" )

if SERVER then
	util.AddNetworkString("FUNNY_PIC_NET")
else
	net.Receive("FUNNY_PIC_NET", function()
		local emg = net.ReadString()
		local ripbozo = net.ReadBool()

		local img = vgui.Create("DImage")
		img:SetSize(ScrW(), ScrH())

		local mat = LOUNGE_CHAT.GetDownloadedImage(emg)
			if (mat) then
				img.m_Image = mat
				--img:SetSize(mat:Width(), mat:Height())
				--img:Center()
			else
		LOUNGE_CHAT.DownloadImage(
			emg,
				function(mat)
					if (IsValid(img)) then
						img.m_Image = mat
						--img:SetSize(mat:Width(), mat:Height())
						--img:Center()
					end
				end
			)
        end

		img.Paint = function(self, w, h)
			if self.m_Image then
				if !self.disappear then
					self.disappear = true
					surface.PlaySound("nextoren/others/horror/horror_" .. math.random(0, 16) .. ".ogg")
					self:AlphaTo(0, 5, 0, function() self:Remove() end)
				end
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(self.m_Image)
				surface.DrawTexturedRect(0,0,w,h)
			end
		end

		timer.Simple(10, function() img:Remove() end)

	end)
end

function ulx.funnypic(call_ply, plys, img)

	net.Start("FUNNY_PIC_NET")
	net.WriteString(img)
	net.Send(plys)

end

local funnypic = ulx.command( "Breach Admin", "ulx funnypic", ulx.funnypic, "!funnypic" )
funnypic:addParam{ type=ULib.cmds.PlayersArg }
funnypic:addParam{ type=ULib.cmds.StringArg, hint="Image url (MUST BE IMGUR)" }
funnypic:defaultAccess( ULib.ACCESS_SUPERADMIN )
funnypic:help( "" )

function ulx.gagid(call_ply, steamid64, time, reason)

	time = time * 60

	local steamid = util.SteamIDFrom64(steamid64)

	local remembername = GetPlayerName(steamid)

	if remembername then
		call_ply:AresNotify("l:ulx_player "..remebername.." ("..steamid64..") l:ulx_has_been_successfully_gagged")
	else
		call_ply:AresNotify("l:ulx_player "..steamid64.." l:ulx_has_been_successfully_gagged")
	end

	local datafloat = 0

	if time != 0 then
		datafloat = os.time() + time
	end

	util.SetPData(steamid, "RXSEND_GaggedTime", datafloat)
	util.SetPData(steamid, "RXSEND_Gagged", true)

	util.SetPData(steamid, "RXSEND_GaggedAdmin", IsValid(call_ply) and call_ply:Name() or "SERVER")
	util.SetPData(steamid, "RXSEND_GaggedReason", reason)

	local timestring = string.NiceTime(time)

	if remembername then
		remembername = steamid64.." ("..remembername..")"
	else
		remembername = steamid64
	end

	local logtext = "Gagged "..remembername.." Permanently"
	if time != 0 then
		logtext = "Gagged "..remembername.." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(call_ply, steamid64, logtext, logreason)

end

local gagid = ulx.command( "Admin", "ulx gagid", ulx.gagid, "!gagid" )
gagid:addParam{ type=ULib.cmds.StringArg, hint="SteamID64" }
gagid:addParam{ type=ULib.cmds.NumArg, hint="in minutes, 0 is Permanent", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
gagid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
gagid:defaultAccess( ULib.ACCESS_ADMIN )
gagid:help( "" )

function ulx.unmute(call_ply, ply)

	local adminname = "SERVER"

	if IsValid(call_ply) then
		adminname = call_ply:Name()
	end
	
	ply:AresNotify("l:ulx_admin \""..adminname.."\" l:ulx_they_removed_mute_from_you")
	if IsValid(call_ply) then call_ply:AresNotify("l:ulx_player \""..ply:Name().."\" l:ulx_has_been_sucessfully_unmuted") end

	ply:RemovePData("RXSEND_Muted")
	ply:RemovePData("RXSEND_MutedTime")
	ply:SetNWBool("ulx_muted", false)

	local logtext = "Unmuted "..ply:Name()
	local logreason = ""
	AdminActionLog(call_ply, ply, logtext, logreason)

end

local unmute = ulx.command( "Admin", "ulx unmute", ulx.unmute, "!unmute" )
unmute:addParam{ type=ULib.cmds.PlayerArg }
unmute:defaultAccess( ULib.ACCESS_ADMIN )
unmute:help( "" )

function ulx.ungag(call_ply, ply)

	local adminname = "SERVER"

	if IsValid(call_ply) then
		adminname = call_ply:Name()
	end
	
	ply:AresNotify("l:ulx_admin \""..adminname.."\" l:ulx_they_removed_gag_from_you")
	if IsValid(call_ply) then call_ply:AresNotify("l:ulx_player \""..ply:Name().."\" l:ulx_has_been_sucessfully_ungagged") end

	ply:RemovePData("RXSEND_Gagged")
	ply:RemovePData("RXSEND_GaggedTime")
	ply:SetNWBool("ulx_gagged", false)

	local logtext = "Ungagged "..ply:Name()
	local logreason = ""
	AdminActionLog(call_ply, ply, logtext, logreason)

end

local ungag = ulx.command( "Admin", "ulx ungag", ulx.ungag, "!ungag" )
ungag:addParam{ type=ULib.cmds.PlayerArg }
ungag:defaultAccess( ULib.ACCESS_ADMIN )
ungag:help( "" )

function ulx.unmuteid(call_ply, steamid64)

	local steamid = util.SteamIDFrom64(steamid64)
	
	local remembername = GetPlayerName(steamid)

	util.RemovePData(steamid, "RXSEND_Muted")
	util.RemovePData(steamid, "RXSEND_MutedTime")

	local user = player.GetBySteamID64(steamid64)

	if IsValid(user) then
		user:SetNWBool("ulx_muted", false)
	end

	if IsValid(call_ply) then
		if remembername then
			call_ply:AresNotify("l:ulx_player ", steamid64," ("..remembername..") l:ulx_has_been_sucessfully_unmuted")
		else
			call_ply:AresNotify("l:ulx_player "..steamid64.." l:ulx_has_been_sucessfully_unmuted")
		end
	end

	local logtext = "Unmuted "..steamid64
	if remembername then
		logtext = "Unmuted "..steamid64.." ("..remembername..")"
	end
	AdminActionLog(call_ply, steamid64, logtext, "")

end

local unmuteid = ulx.command( "Admin", "ulx unmuteid", ulx.unmuteid, "!unmuteid" )
unmuteid:addParam{ type=ULib.cmds.StringArg, hint="SteamID64" }
unmuteid:defaultAccess( ULib.ACCESS_ADMIN )
unmuteid:help( "" )

function ulx.ungagid(call_ply, steamid64)

	local steamid = util.SteamIDFrom64(steamid64)
	
	local remembername = GetPlayerName(steamid)

	if remembername then
		call_ply:AresNotify("l:ulx_player ", steamid64," ("..remembername..") l:ulx_has_been_sucessfully_ungagged")
	else
		call_ply:AresNotify("l:ulx_player "..steamid64.." l:ulx_has_been_sucessfully_ungagged")
	end

	util.RemovePData(steamid, "RXSEND_Gagged")
	util.RemovePData(steamid, "RXSEND_GaggedTime")

	local logtext = "Ungagged "..steamid64
	if remembername then
		logtext = "Ungagged "..steamid64.." ("..remembername..")"
	end
	AdminActionLog(call_ply, steamid64, logtext, "")

end

local ungagid = ulx.command( "Admin", "ulx ungagid", ulx.ungagid, "!ungagid" )
ungagid:addParam{ type=ULib.cmds.StringArg, hint="SteamID64" }
ungagid:defaultAccess( ULib.ACCESS_ADMIN )
ungagid:help( "" )

if SERVER then
	util.AddNetworkString("change_ignore_state")
else
	net.Receive("change_ignore_state", function()
		local ply = net.ReadEntity()
		local client = LocalPlayer()
		local name = ply:Name()
		if client:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SPEC then
			--но зачем?
			--name = ply:GetNamesurvivor()
		end
		if ply:IsMuted() then
			chat.AddText(Color(0, 255, 0), "[Ares Breach] ", Color(255, 255, 255), BREACH.TranslateString("l:ulx_unignore ")..name)
		else
			if client:GTeam() != TEAM_SPEC then
				if !(client:GTeam() == TEAM_SCP and ply:GTeam() == TEAM_SCP) then
					chat.AddText(Color(0, 255, 0), "[Ares Breach] ", Color(255, 255, 255), BREACH.TranslateString("l:clientside_mute_spec_only"))
					return
				end
			end
			chat.AddText(Color(0, 255, 0), "[Ares Breach] ", Color(255, 255, 255), BREACH.TranslateString("l:ulx_ignore ")..name)
		end
		ply:SetMuted(!ply:IsMuted())
	end)

end

function ulx.ignore(call_ply, send_ply)

	net.Start("change_ignore_state")
	net.WriteEntity(send_ply)
	net.Send(call_ply)

end

local ignore = ulx.command( "Admin", "ulx ignore", ulx.ignore, "!ignore" )
ignore:addParam{ type=ULib.cmds.PlayerArg }
ignore:defaultAccess( ULib.ACCESS_ALL )
ignore:help( "" )

if SERVER then

	hook.Add("PlayerInitialSpawn", "RXSEND_MuteSpawn", function(ply)
		if ply:GetPData("RXSEND_Muted", false) then
			ply:SetNWBool("ulx_muted", true)
		end
		if ply:GetPData("RXSEND_Gagged", false) then
			ply:SetNWBool("ulx_gagged", true)
		end
	end)

	local nextthink = 0

	hook.Add("Think", "RXSEND_MuteThink", function()

		if CurTime() < nextthink then return end

		nextthink = CurTime() + 60

		local plys = player.GetAll()

		for i = 1, #plys do

			local ply = plys[i]

			local mutetime = tonumber(ply:GetPData("RXSEND_MutedTime", 0))
			local gagtime = tonumber(ply:GetPData("RXSEND_GaggedTime", 0))

			if ply:GetNWBool("ulx_muted", false) then

				if mutetime != 0 then

					if mutetime <= os.time() then

						ply:AresNotify("l:ulx_your_mute_expired")

						SendAdminMessage(nil, "Player ".."\""..ply:Name().."\" has been unmuted: Punishment time is over.")

						ply:RemovePData("RXSEND_MutedTime")
						ply:RemovePData("RXSEND_Muted")
						ply:SetNWBool("ulx_muted", false)

					end


				end

			end

			if ply:GetNWBool("ulx_gagged", false) then

				if gagtime != 0 then

					if gagtime <= os.time() then

						ply:AresNotify("l:ulx_your_gag_expired")

						SendAdminMessage(nil, "Player ".."\""..ply:Name().."\" has been ungagged: Punishment time is over.")

						ply:RemovePData("RXSEND_GaggedTime")
						ply:RemovePData("RXSEND_Gagged")
						ply:SetNWBool("ulx_gagged", false)

					end


				end

			end

		end

	end)

end

function SetupForceSCP()
	if !ulx or !ULib then 
		print( "ULX or ULib not found" )
		return
	end
	
	function ulx.forcescp( plyc, plyt, scp, silent )
		if !scp then return end
		if !plyt:GetActive() then
			ULib.tsayError( plyc, "Player "..plyt:GetName().." is inactive! Forced spawn failed", true )
			return
		end
		--for k, v in pairs( SPCS ) do
			--if v.name == scp then
				--v.func( plyt )
		local scp_obj = GetSCP( scp )
		if scp_obj then
			plyt:SetupNormal()
			scp_obj:SetupPlayer( plyt )

			if silent then
				ulx.fancyLogAdmin( plyc, true, "#A force spawned #T as "..scp, plyt )
			else
				ulx.fancyLogAdmin( plyc, "#A force spawned #T as "..scp, plyt )
			end
				--break
			--end
		else
			ULib.tsayError( plyc, "Invalid SCP "..scp.."!", true )
		end
	end

	local forcescp = ulx.command( "Breach Admin", "ulx force_scp", ulx.forcescp, "!forcescp" )
	forcescp:addParam{ type = ULib.cmds.PlayerArg }
	forcescp:addParam{ type = ULib.cmds.StringArg, hint = "SCP name", completes = SCPS, ULib.cmds.takeRestOfLine }
	forcescp:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcescp:setOpposite( "ulx silent force_scp", { _, _, _, true }, "!sforcescp" )
	forcescp:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcescp:help( "Sets player to specific SCP and spawns him" )
end

function setsurvivorname()
	function ulx.setsurvivorname( plyc, plys, survname )
		for _, plyt in ipairs(plys) do
			plyt:SetNamesurvivor(survname)
		end
	end

	local setsurvivorname = ulx.command( "Breach Admin", "ulx setsurvivorname", ulx.setsurvivorname, "!setsurvivorname" )
	setsurvivorname:addParam{ type = ULib.cmds.PlayersArg }
	setsurvivorname:addParam{ type = ULib.cmds.StringArg, hint = "Survivor name", ULib.cmds.takeRestOfLine }
	setsurvivorname:defaultAccess( ULib.ACCESS_SUPERADMIN )
	setsurvivorname:help( "funneh name" )
end

--GiveBoneMerge()
InitializeBreachULX()
SetupForceSCP()
FORCESPAWN_BUTWORKING()
ABILITYGIVE_LOL()
setsurvivorname()