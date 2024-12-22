--[[


addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_molotov/shared.lua

--]]

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Thrown incendiary grenade"
ENT.Author = "Spy"
ENT.Information = "Thrown incendiary grenade"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.fuseParticles = "molotov_trail"
PrecacheParticleSystem(ENT.fuseParticles)
