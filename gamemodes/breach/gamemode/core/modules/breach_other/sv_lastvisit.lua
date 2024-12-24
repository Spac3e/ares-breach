if not BREACH.DataBaseSystem then return end

local function TimeString(time)
    local diff = os.time() - time
    local minute = 60
    local hour = 3600
    local day = 86400
    local week = 604800

    if diff < minute then
        return "менее минуты назад"
    elseif diff < hour then
        local minutes = math.floor(diff / minute)
        return minutes .. (minutes == 1 and " минуту назад" or " минут назад")
    elseif diff < day then
        local hours = math.floor(diff / hour)
        return hours .. (hours == 1 and " час назад" or " часов назад")
    elseif diff < week then
        local days = math.floor(diff / day)
        return days .. (days == 1 and " день назад" or " дней назад")
    else
        local weeks = math.floor(diff / week)
        return weeks .. (weeks == 1 and " неделю назад" or " недель назад")
    end
end

local function SendMessage(visit, ply)
    for _, v in ipairs(player.GetAll()) do
        if v:GTeam() != TEAM_SPEC or v == ply then
            return
        end

        if visit then
            local visitTime = os.time({
                year = tonumber(string.sub(visit, 1, 4)),
                month = tonumber(string.sub(visit, 6, 7)),
                day = tonumber(string.sub(visit, 9, 10)),
                hour = tonumber(string.sub(visit, 12, 13)),
                min = tonumber(string.sub(visit, 15, 16)),
                sec = tonumber(string.sub(visit, 18, 19))
            })
            
            local visitstring = TimeString(visitTime)

            v:AresNotify(ply:Name() .. " зашёл на сервер, последний визит " .. visitstring)
        else
            v:AresNotify("Встрейчайте " .. ply:Name() .. ", он здесь впервые!")
        end
    end
end

local function lastvisitfunc(ply)
    if ply:IsBot() then
        return
    end

    local steamid = ply:SteamID64()
    local escapedSteamID = BREACH.DataBaseSystem:Escape(steamid)

    local queryStr = string.format(
        [[
        INSERT INTO breach_visits (steamid, visit) 
        VALUES (%s, CURRENT_TIMESTAMP)
        ON DUPLICATE KEY UPDATE visit = CURRENT_TIMESTAMP;
        ]],
        escapedSteamID
    )

    local query = BREACH.DataBaseSystem:Query(queryStr)
    query.onSuccess = function(q, data)
        SendMessage(true, ply)
    end
    query.onError = function(q, errorText)
        BREACH.DataBaseSystem:Error("Failed to update or insert last visit: " .. errorText)
    end
    query:start()
end


hook.Add("Initialize", "BREACH.LastVisit.Initialize", function()
    BREACH.DataBaseSystem:Query([[
        CREATE TABLE IF NOT EXISTS `breach_visits` (
            `steamid` bigint(20) NOT NULL,
            `visit` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`steamid`)
        );
    ]])
end)

hook.Add("PlayerInitialSpawn", "BREACH.Lastvisit-PlayerInitialSpawn", lastvisitfunc)