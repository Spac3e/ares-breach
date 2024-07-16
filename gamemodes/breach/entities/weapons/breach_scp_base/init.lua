AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("Ability_ClientsideCooldown")
util.AddNetworkString("GestureClientNetworking")
util.AddNetworkString("ForbidTalant")

function SWEP:Cooldown(abil, time)
    --[[if self.AbilityIcons[abil].CooldownTime <= CurTime() then
        self.AbilityIcons[abilityIndex].CooldownTime = CurTime() + cooldownTime
        return true
    else
        return false
    end--]]
    net.Start("Ability_ClientsideCooldown")
    net.WriteUInt(abil,4)
    net.WriteFloat(time)
    net.WriteEntity(self.Owner:GetActiveWeapon())
    net.Send(self.Owner)
end