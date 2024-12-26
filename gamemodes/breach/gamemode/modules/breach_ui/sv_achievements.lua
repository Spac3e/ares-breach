local PLAYER = FindMetaTable("Player")

BreachAchievements = BreachAchievements or {}

if not BREACH.DataBaseSystem then return end

BreachAchievements.AchievementTable = {
    {
        name = "firsttime",
        achievements_name = "Золотой миллениум",
        image = "nextoren/achievements/ahive57.jpg",
        desc = "Добро пожаловать на сервер!",
        color = Color(255,0,0),
        secret = false
    },
    {
        name = "firstdeath",
        achievements_name = "Не так уж и больно",
        image = "nextoren/achievements/ahive62.jpg",
        desc = "Умереть один раз, не так уж и страшно :)",
        color = Color(255,0,0),
        secret = false
    },
    {
        name = "betatester",
        achievements_name = "Бета Тестер",
        image = "nextoren/achievements/ahive128.jpg",
        desc = "Принять участие в бета тестировании сервера",
        color = Color(255,0,0),
        secret = true
    }
    /*
    {
        name = "pointbased",
        achievements_name = "Point Based Achievement",
        image = "nextoren/achievements/ahive200.jpg",
        desc = "Earn enough points to unlock this achievement",
        color = Color(255,215,0),
        secret = false,
        countable = true,
        countnum = 5
    }*/
}

function BreachAchievements.InitDatabase()
    BREACH.DataBaseSystem:Query([[
        CREATE TABLE IF NOT EXISTS `achievements` (
        `id` bigint(20) NOT NULL,
        `achievements` text DEFAULT ''
        );
    ]])
end

-- Achievements
util.AddNetworkString("GetAchievementTable")
util.AddNetworkString("OpenAchievementMenu")
util.AddNetworkString("AchievementBar")

function FindAchievementTableByName(name)
	for i = 1, #BreachAchievements.AchievementTable do
		local tab = BreachAchievements.AchievementTable[i]
		if tab.name == name then return tab end
	end
end

local function AddPlayerToAchievementsTable(ply)
    local steamid = ply:SteamID64()

    local query = "INSERT IGNORE INTO achievements (id, achievements) VALUES (" .. steamid .. ", '[]')"
    BREACH.DataBaseSystem:Query(query)
end

local function GetAchievements(ply, callback)
    local steamid = ply:SteamID64()

    local query = "SELECT achievements FROM achievements WHERE id = " .. steamid

    BREACH.DataBaseSystem:Query(query, function(data)
        if data and data[1] then
            local achstr = data[1].achievements
            local achievementsTable = util.JSONToTable(achstr) or {}

            if callback then
                callback(achievementsTable)
            end
        else
            if callback then
                callback(nil)
            end
        end
    end)
end

local function ClearAchievement(ply, ach)
    local steamid = ply:SteamID64()

    local query =  "UPDATE achievements SET achievements = '[]' WHERE id = " .. steamid

    if ach then
        query = "UPDATE achievements SET achievements = REPLACE(achievements, '[\"" .. ach .. "\"]', '[]') WHERE id = " .. steamid
    end

    BREACH.DataBaseSystem:Query(query)
end

local function HasAchievement(ply, ach, callback)
    local steamid = ply:SteamID64()
    local query = "SELECT achievements FROM achievements WHERE id = " .. steamid

    BREACH.DataBaseSystem:Query(query, function(data)
        local result = false

        if data and data[1] then
            local achstr = data[1].achievements
            local achievementsTable = util.JSONToTable(achstr) or {}

            for _, v in pairs(achievementsTable) do
                if v == ach then
                    result = true
                    break
                end
            end
        end

        if callback then
            callback(result)
        end
    end)
end

local function UpdateAchievementsCount(ply)
    local steamid = ply:SteamID64()
    local query = "SELECT achievements FROM achievements WHERE id = " .. steamid

    BREACH.DataBaseSystem:Query(query, function(data)
        if data and data[1] then
            local achstr = data[1].achievements
            local achievementsTable = util.JSONToTable(achstr) or {}
            local numAchievements = #achievementsTable

            ply:SetNWInt("CompletedAchievements", numAchievements or 0)
        end
    end)
end

local function AddAchievement(ply, ach)
    local steamid = ply:SteamID64()

    GetAchievements(ply, function(currentAchievements)
        if currentAchievements then
            if table.HasValue(currentAchievements, ach) then
                return
            end

            table.insert(currentAchievements, ach)
            local json = util.TableToJSON(currentAchievements)

            local query = "UPDATE achievements SET achievements = '" .. json .. "' WHERE id = " .. steamid

            BREACH.DataBaseSystem:Query(query)

            UpdateAchievementsCount(ply)
        end
    end)
end

function PLAYER:CompleteAchievement(ach)
    local achievementData = FindAchievementTableByName(ach)

    if self:IsBot() then
        return
    end

    HasAchievement(self, ach, function(have)
        if have then
            return
        end
        
        if not achievementData then 
            return 
        end

        AddAchievement(self, ach)

        for _, v in ipairs(player.GetAll()) do
            if v:GTeam() == TEAM_SPEC then
                local white = Color(255, 255, 255)
                local col = achievementData.color or white
                v:AresNotify(self:Name() .. " l:unlocked_achievement ", '"', col, achievementData.achievements_name, white, '"')
            end
        end

        net.Start("AchievementBar")
        net.WriteTable({
            achievements_name = achievementData.achievements_name,
            image = achievementData.image,
            secret = false
        })
        net.Send(self)
    end)
end

function PLAYER:AddToAchievementPoint(ach, points)
    local achievementData = FindAchievementTableByName(ach)

    if self:IsBot() then
        return
    end


    if not achievementData or not achievementData.countnum then
        return
    end

    HasAchievement(self, ach, function(have)
        if have then
            return
        end

        local name = ach

        local curpoints = self:GetNWInt(name, 0)
        local maxpoints = achievementData.countnum - curpoints
    
        points = math.min(points, maxpoints)
    
        local newpoints = curpoints + points
    
        self:SetNWInt(name, newpoints)
    
        if newpoints >= achievementData.countnum then
            self:CompleteAchievement(ach)
        end
    end)
end

BreachAchievements.InitDatabase()

local function SetAchievementTable(ply)
    AddPlayerToAchievementsTable(ply)

    UpdateAchievementsCount(ply)
end

hook.Add("PlayerInitialSpawn", "Breach.Achievements-PlayerInitialSpawn", function(ply)
    if ply:IsBot() then
        return
    end

    SetAchievementTable(ply)
end)

net.Receive("OpenAchievementMenu", function(len, self)
    local ply = net.ReadEntity()
    local tab = BreachAchievements.AchievementTable

    GetAchievements(ply, function(achs)
        local completed = {}

        if achs then
            for _, ach in pairs(achs) do
                local achievementData = FindAchievementTableByName(ach)

                if achievementData then
                    table.insert(completed, {
                        achivid = achievementData.name,
                        count = ply:GetNWInt(achievementData.name, 0)
                    })
                end
            end
        end

        net.Start("OpenAchievementMenu")
            net.WriteEntity(ply)
            net.WriteTable(tab)
            net.WriteTable(completed)
        net.Send(self)
    end)
end)