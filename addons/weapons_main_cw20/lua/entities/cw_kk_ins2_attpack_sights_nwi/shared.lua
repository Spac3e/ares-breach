--[[


addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_attpack_sights_nwi/shared.lua

--]]

if not CustomizableWeaponry then return end

ENT.Type = "anim"
ENT.Base = "cw_attpack_base"
ENT.PrintName = "[INS2] Sights: NWI"
ENT.PackageText = "Sight Contract: NWI"
ENT.Category = "CW 2.0 Attachments"
ENT.Author = "Spy"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.attachments = {
	"kk_ins2_magnifier",
	"kk_ins2_scope_mosin",
	"kk_ins2_scope_m40",
	"kk_ins2_po4",
	"kk_ins2_elcan",
	"kk_ins2_aimpoint",
	"kk_ins2_eotech",
	"kk_ins2_kobra",
}
