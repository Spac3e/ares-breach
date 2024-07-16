AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/mishka/models/scp1025.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    self:PhysWake()
    self:AddEFlags(EFL_NO_DAMAGE_FORCES)
    self.BlockDrag = true
    self:SetUseType(SIMPLE_USE)
end


local kashli_na_vbr = {
    "nextoren/unity/cough1.ogg",
    "nextoren/unity/cough2.ogg",
    "nextoren/unity/cough3.ogg"
}
ENT.Disease = {
    [1] = {
        name = "Простуде",
        Effect = function(pl) pl:SetBottomMessage("Ваше горло начинает сильно болеть.") timer.Create("decease" .. pl:SteamID64(), 20, 0, function() pl:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)]) end) end
    },
    [2] = {
        name = "Ветрянке",
        Effect = function(pl) pl:SetBottomMessage("Вы чувствуете зуд по всему телу.") timer.Create("decease" .. pl:SteamID64(), 20, 0, function() pl:SetBottomMessage("Вы чувствуете зуд по всему телу.") end) end
    },
    [3] = {
        name = "Раке лёгких",
        Effect = function(pl) pl:SetStaminaScale(0.1) end
    },
    [4] = {
        name = "Аппендиците",
        Effect = function(pl) pl:SetStaminaScale(0.1) end
    },
    [5] = {
        name = "Астме",
        Effect = function(pl) pl:SetStaminaScale(0.1) end
    },
    [6] = {
        name = "Инфаркте",
        Effect = function(pl) timer.Create("decease" .. pl:SteamID64(), 20, 0, function() pl:Kill() end) end
    }
}

ENT.NextUse = 0
function ENT:Use(activator)
    if activator:GTeam() == TEAM_SCP or activator:GTeam() == TEAM_SPEC then return end

    if activator.used1025 then
        return
    end

    activator.used1025 = true

    if self.NextUse > CurTime() then return end
    self.NextUse = CurTime() + 1
    local randomindx = math.random(1, #self.Disease)
    net.Start("CreatePage")
    net.WriteInt(randomindx - 1, 3)
    net.Send(activator)
    self.Disease[randomindx].Effect(activator)
    
    activator:AresNotify("Вы прочитали о " .. self.Disease[randomindx].name)
end