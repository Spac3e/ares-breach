--[[


addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_attpack_lights/shared.lua

--]]

if not CustomizableWeaponry then return end

ENT.Type = "anim"
ENT.Base = "cw_attpack_base"
ENT.PrintName = "[INS2] Lights-Lasers"
ENT.PackageText = "Lasers and Flashlights"
ENT.Category = "CW 2.0 Attachments"
ENT.Author = "Spy"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.attachments = {
	"kk_ins2_anpeq15",
	"kk_ins2_m6x",
	"kk_ins2_lam",
	"kk_ins2_flashlight",
}
