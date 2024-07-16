if not util.IsBinaryModuleInstalled("gdiscord") then return end


local disabled = true

if disabled then
    return
end

require("gdiscord")

local mapimage = {
    ["ares_site19_supreme"] = "site19"
}

local maptext = {
    ["ares_site19_supreme"] = "ares_site19_supreme"
}

local image = "default"
local discord_id = ""
local refresh_time = 60
local discord_start = discord_start or -1

function DiscordUpdate()
    local ply = LocalPlayer()

    local rpc_data = {}
    local ip = game.GetIPAddress()

    if ip == "loopback" then
        rpc_data["state"] = "Local Server"
    else
        -- rpc_data["state"] = string.Replace(ip, ":27015", "")
        rpc_data["state"] = "Dedicated Server"
    end

    rpc_data["partySize"] = player.GetCount()
    rpc_data["partyMax"] = game.MaxPlayers()

    rpc_data["details"] = "Map: " .. maptext[game.GetMap()] or ""
    rpc_data["startTimestamp"] = discord_start

    rpc_data["largeImageKey"] = mapimage[game.GetMap()] or ""
    rpc_data["largeImageText"] = maptext[game.GetMap()] or ""

    rpc_data["buttonPrimaryLabel"] = "Connect"
    rpc_data["buttonPrimaryUrl"] = "steam://connect/" .. ip

    rpc_data["buttonSecondaryLabel"] = "Discord"
    rpc_data["buttonSecondaryUrl"] = "https://discord.gg/aresproject"

    DiscordUpdateRPC(rpc_data)
end

hook.Add("Initialize", "UpdateDiscordStatus", function()
    timer.Simple(5, function()
        discord_start = os.time()

        DiscordRPCInitialize(discord_id)
        DiscordUpdate()

        if timer.Exists("DiscordRPCTimer") then timer.Remove("DiscordRPCTimer") end

        timer.Create("DiscordRPCTimer", refresh_time, 0, DiscordUpdate)
    end)
end)
