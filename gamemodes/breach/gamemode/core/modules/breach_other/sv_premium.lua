require('mysqloo')

local PLAYER = FindMetaTable('Player')

PREMIUM = PREMIUM or {}

PREMIUM.Infinite = 1067519911673
PREMIUM.Day = false

local db = mysqloo.connect("localhost", "root", "", "breach", 3306)

function db:onConnected()
    PREMIUM.InitializePlayerDatabase()
end

db:connect()

function PREMIUM.InitializePlayerDatabase()
    local query = db:query('CREATE TABLE IF NOT EXISTS breach_premium (SteamID VARCHAR(255) NOT NULL PRIMARY KEY, Duration BIGINT);')

    function query:onSuccess(data)
        PREMIUM.AddPlayer('steamId_example', PREMIUM.Infinite)
    end

    query:start()
end

function PREMIUM.DropTable()
    local query = db:query('DROP TABLE IF EXISTS breach_premium;')

    function query:onSuccess(data)
        PREMIUM.InitializePlayerDatabase()
    end

    query:start()
end

function PLAYER:SetPremium(time)
    self:SetUserGroup("premium")

    if time then
        self:AresNotify("l:premium_unlocked_pt1" .. " " .. time .. " l:premium_unlocked_pt2")
    end
end

function PLAYER:DisablePremium()
    self:SetUserGroup("user")

    self:AresNotify("l:premium_expired")
end

function PREMIUM.Get(callback)
    local query = db:query('SELECT * FROM breach_premium;')

    function query:onSuccess(data)
        callback(data)
    end

    function query:onError(err)
        callback({})
    end

    query:start()
end

function PREMIUM.FindPlayer(SID, callback)
    local query = db:query('SELECT SteamID FROM breach_premium WHERE SteamID = "' .. db:escape(SID) .. '";')

    function query:onSuccess(data)
        callback(#data > 0)
    end

    function query:onError(err)
        callback(false)
    end

    query:start()
end

function PREMIUM.AddPlayer(SID, DUR)
    SID = tostring(SID)
    DUR = tonumber(DUR) or 0

    if DUR == 0 then
        DUR = PREMIUM.Infinite
    end

    local origdur = DUR
    DUR = os.time() + (DUR * 86400)

    local query = db:query('INSERT INTO breach_premium (SteamID, Duration) VALUES ("' .. db:escape(SID) .. '", ' .. DUR .. ') ON DUPLICATE KEY UPDATE Duration = VALUES(Duration);')

    function query:onSuccess(data)
        local pl = player.GetBySteamID(SID)

        if IsValid(pl) then
            pl:SetPremium(origdur)
        end
    end

    query:start()
end

function PREMIUM.GetDuration(SID, callback)
    local query = db:query('SELECT Duration FROM breach_premium WHERE SteamID = "' .. db:escape(SID) .. '";')

    function query:onSuccess(data)
        if #data > 0 then
            callback(tonumber(data[1].Duration))
        else
            callback(0)
        end
    end

    function query:onError(err)
        callback(0)
    end

    query:start()
end

function PREMIUM.ExtendPlayer(SID, DUR)
    SID = tostring(SID)
    DUR = tonumber(DUR) or 0

    PREMIUM.FindPlayer(SID, function(exists)
        if not exists then return end

        if DUR == 0 then
            DUR = PREMIUM.Infinite
        end

        PREMIUM.GetDuration(SID, function(currentDur)
            local newDur = currentDur + (DUR * 86400)

            local query = db:query('UPDATE breach_premium SET Duration = ' .. newDur .. ' WHERE SteamID = "' .. db:escape(SID) .. '";')

            query:start()
        end)
    end)
end

function PREMIUM.Think()
    PREMIUM.Get(function(data)
        for k, v in pairs(data) do
            if os.time() >= tonumber(v.Duration) then
                local query = db:query('DELETE FROM breach_premium WHERE SteamID = "' .. db:escape(v.SteamID) .. '";')

                function query:onSuccess(data)
                    local pl = player.GetBySteamID(v.SteamID)

                    if IsValid(pl) then
                        pl:DisablePremium()
                    end
                end
                
                query:start()
            end
        end
    end)
end

function PREMIUM:OnJoin(ply)
    PREMIUM.FindPlayer(ply:SteamID(), function(isPremium)
        if not isPremium and ply:GetUserGroup() == 'premium' then
            ply:DisablePremium()
        elseif isPremium and not ply:IsPremium() then
            ply:SetPremium()
        end

        if PREMIUM.Day and not ply:IsPremium() then
            ply:SetPremium()
        end
    end)
end

hook.Add("PlayerInitialSpawn", "Breach.Premium-PlayerInitialSpawn", function(ply)
    PREMIUM:OnJoin(ply)
end)

PREMIUM.InitializePlayerDatabase()
