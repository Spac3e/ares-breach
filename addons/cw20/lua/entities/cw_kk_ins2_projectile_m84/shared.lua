--[[


addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_m84/shared.lua

--]]

if not CustomizableWeaponry then return end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Thrown smoke grenade"
ENT.Author = "Spy"
ENT.Information = "Thrown smoke grenade"
ENT.Spawnable = false
ENT.AdminSpawnable = false

CustomizableWeaponry:addRegularSound("CW_KK_INS2_M84_ENT_BOUNCE", {"weapons/m84/m84_bounce_01.wav", "weapons/m84/m84_bounce_02.wav", "weapons/m84/m84_bounce_03.wav"})
