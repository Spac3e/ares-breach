/*
BREACH.AntiCheat = BREACH.AntiCheat or {}
BREACH.Relay = BREACH.Relay or {}
local ac_tag = "[PEEDORAS]"
AdminLogWebHook = "https://discord.com/api/webhooks/1209119898647797770/730fuYtGUDsV0EUpInfEMP5Qn7m01caOkw5VmArCVhBfEN4vKh8xpdW1RRbXPU_mEF7-"

function BREACH.AntiCheat.PlayerLoaded(ply)
	ply.JoinTimeAC = CurTime()
	ply.PlayerFullyAuthenticated = true
	ply:ConCommand("music_menu")
end

function BREACH.AntiCheat:KickPlayer(ply, reason)
	if !IsValid(ply) then
		return
	end

	reason = tostring(reason) or ''

	reason = reason .. '\n' .. 'You have to wait until map change before you can join'

	ply:Kick(ac_tag..' '..reason)
end

local whitelist = {}

function GM:PlayerInitialSpawn(client)
    local steamid64 = client:SteamID64()

    if !client:IsBot() and client:OwnerSteamID64() != steamid64 and !whitelist[steamid64] then
        BREACH.AntiCheat:KickPlayer(client,'Family Shared account')
    end
end

hook.Add('PlayerInitialSpawn', 'BREACH.AntiCheat:PlayerLoaded', BREACH.AntiCheat.PlayerLoaded)

function LogTeamChangeFromBreach(ply, b, a)
	local id = tostring( ply:SteamID64() )
	
	local msg = "Смена команды | ".. gteams.GetName(b) .. ' - ' .. ply:GetRoleName() .. ' | '.. gteams.GetName(a)

	if a == b then
		msg = "Смена команды | " .. gteams.GetName(b) .. ' - ' .. ply:GetRoleName()
	end

	local co = coroutine.create( function() 
		local form = {
			["username"] = ply:Name() ..' ' ..ply:SteamID(),
			["content"] = msg,
			["avatar_url"] = tmpAvatars[id],
			["url"] = aresDiscord.keys.main,
			["color"] = 6009554,
			["allowed_mentions"] = {
				["parse"] = {}
			},
		}
		
		aresDiscord.SendMessage(form)
	end )

	if tmpAvatars[id] == nil then 
		aresDiscord.GetAvatar( id, co )
	else 
		coroutine.resume( co )
	end
end

function BREACH.Relay:SendRoundStats(state)
	local до_рестарта = GetGlobalInt("RoundUntilRestart", 10)

	if state == "продолжай" then
		msg = "Рестарт, раундов "..до_рестарта or 0
	end

    if state == "закончи" then
		msg = "Рестарт"
	end
	
	local form = {
		["username"] = "Peasant",
		["content"] = msg,
		["url"] = "https://discord.com/api/webhooks/1215345070312661062/NYE8kmKp-6ShfoG9OFNcuPqSywO3PkUuoyYAfqva2yv9H2D7w1P9g_AwyguZPWKdtQYp",
		["color"] = 6009554,
		["allowed_mentions"] = {
			["parse"] = {}
		},
	}
	
	aresDiscord.SendMessage(form)
end*/
