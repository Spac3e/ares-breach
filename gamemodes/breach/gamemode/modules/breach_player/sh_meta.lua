local PLAYER = FindMetaTable("Player")

function PLAYER:GetUsingCloth()
    return self:GetNWString("_UsingCloth", "")
end

function PLAYER:GetUsingHelmet()
    return self:GetNWString("_UsingHelmet", "")
end

function PLAYER:GetUsingArmor()
    return self:GetNWString("_UsingArmor", "")
end

function PLAYER:GetUsingBag()
    return self:GetNWString("_UsingBag", "")
end

PLAYER.SteamName = PLAYER.SteamName or PLAYER.Nick

function PLAYER:Name()
    return self:SteamName()
end

function PLAYER:GetName()
    return self:Name()
end

function PLAYER:Nick()
    return self:Name()
end