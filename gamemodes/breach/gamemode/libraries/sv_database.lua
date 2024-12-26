local success = pcall(require, "mysqloo")

if not success then
    return
end

if not sqloo then
    error("Something went wrong, looks like sqloo table isn't defined")
end

local MYSQL_INFO = {
    host = "localhost",
    user = "root",
    pass = "",
    name = "breach",
    port = 3306,
}

BREACH.DataBaseSystem = sqloo.Create(MYSQL_INFO.host, MYSQL_INFO.user, MYSQL_INFO.pass, MYSQL_INFO.name, MYSQL_INFO.port)

hook.Add("sqloo.OnConnected", "BREACH.Sqloo.Connected", function()
    BREACH.DataBaseSystem:Success("Successfuly connected")
end)

function BREACH.DataBaseSystem:Initialize()
    BREACH.DataBaseSystem:Query([[
        CREATE TABLE IF NOT EXISTS `breach_data` (
            steamid BIGINT NOT NULL,
            level INT NOT NULL,
            exp INT NOT NULL,
            PRIMARY KEY (`steamid`)
        );
    ]])
end

function BREACH.DataBaseSystem:LoadPlayer(ply, callback)
    if not IsValid(ply) then
        return
    end

    if ply:IsBot() then
        return
    end

    local steamid = ply:SteamID64()
    local query = string.format("SELECT exp, level FROM breach_data WHERE steamid = %s", steamid)

    BREACH.DataBaseSystem:Query(query, function(result)
        if result and #result > 0 then
            ply:SetNEXP(tonumber(result[1].exp))
            ply:SetNLevel(tonumber(result[1].level))
        else
            local insert = string.format("INSERT INTO breach_data (steamid, exp, level) VALUES (%s, 0, 0)", steamid)
            BREACH.DataBaseSystem:Query(insert)
            ply:SetNEXP(0)
            ply:SetNLevel(0)
        end
    end)
    
    ply:SetElo(tonumber(ply:GetPData("breach_elo", 0)))
	ply:SetNEscapes(tonumber(ply:GetPData("breach_escapes", 0)))
	ply:SetNDeaths(tonumber(ply:GetPData("breach_deaths", 0)))
	ply:SetPenaltyAmount( tonumber( ply:GetPData( "breach_penalty", 0 ) ) )

	if callback and isfunction(callback) then
        callback()
	end
end

hook.Add("PlayerDisconnected", "savebreachdata", function(ply)
    ply:SaveExp()
    ply:SaveLevel()
end)

BREACH.DataBaseSystem:Initialize()