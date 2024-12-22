--[[


addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_c4/shared.lua

--]]

if not CustomizableWeaponry then return end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Planted C4"
ENT.Author = "Spy"
ENT.Information = "Planted C4"
ENT.Spawnable = false
ENT.AdminSpawnable = false

-- ENT.BlastDamage = 100
-- ENT.BlastRadius = 434

ENT.BlastDamage = 455
ENT.BlastRadius = 600 // 1200

ENT.KKIN2RCEprojetile = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Detonator")
end

CustomizableWeaponry:addRegularSound("CW_KK_INS2_C4_ENT_BOUNCE", {"weapons/c4/c4_bounce_01.wav", "weapons/c4/c4_bounce_02.wav", "weapons/c4/c4_bounce_03.wav"})
