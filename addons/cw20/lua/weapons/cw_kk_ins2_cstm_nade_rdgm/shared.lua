--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_nade_rdgm/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_nade_rdgm/shared.lua
--]]
if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_soundscript.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "RDG-M Smoke Grenade"
	SWEP.CSMuzzleFlashes = true

	SWEP.IconLetter = "P"

	SWEP.AttachmentModelsVM = {}
    SWEP.SelectIcon = surface.GetTextureID("vgui/entities/rdgm")
	SWEP.ViewModelMovementScale = 0.8
	SWEP.DisableSprintViewSimulation = true

	SWEP.ForegripOverridePos = {
		none = {
			["Pin_F1"] = {pos = Vector(), angle = Angle()},
			["Pin_2_F1"] = {pos = Vector(), angle = Angle()},
			["Pin_Pull"] = {pos = Vector(), angle = Angle()},
			["Weapon_F1"] = {pos = Vector(), angle = Angle()},
			["Spoon_F1"] = {pos = Vector(), angle = Angle()}
		},

		throwfix = {
			["Pin_F1"] = {pos = Vector(0, 0, -20), angle = Angle()},
			["Pin_2_F1"] = {pos = Vector(0, 0, -20), angle = Angle()},
			["Pin_Pull"] = {pos = Vector(0, 0, -20), angle = Angle()},
			["Weapon_F1"] = {pos = Vector(0, 0, -20), angle = Angle()},
			["Spoon_F1"] = {pos = Vector(0, 0, -20), angle = Angle()}
		}
	}

	SWEP.ForegripParent = "none"
	SWEP.ForegripOverride = true

	SWEP.HUD_3D2DBone = 54
end

SWEP.Attachments = CustomizableWeaponry_KK.ins2.slowGrenadeMenu

SWEP.CanRestOnObjects = false
SWEP.projectileClass = "cw_kk_ins2_projectile_m18"

SWEP.Animations = {
	pullpin = "pullbackhigh",
	throw = "throw",

	pull_cook = "pullbackhighbake",
	throw_cook = "bakethrow",

	pull_short = "pullbacklow",
	throw_short = "lowthrow",

	base_idle = "base_idle",
	base_draw = "base_draw",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 5

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "grenade"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base_nade"
SWEP.Category = "CW 2.0 KK INS2 EXT"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_rdgm.mdl"
SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_rdgm.mdl"

SWEP.WMPos = Vector(3.891, 2.295, -1.765)
SWEP.WMAng = Angle(-28.962, 155.365, 180)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.Ammo			= "Smoke Grenades"

SWEP.fuseTime = 4

SWEP.timeToThrow = 0.9

SWEP.timeToThrowCook = 1.3

SWEP.timeToThrowShort = 0.9

if CLIENT then
	CustomizableWeaponry_KK.ins2.welementThink:add("cw_kk_ins2_cstm_nade_rdgm", "grenade")

	function SWEP:updateOtherParts()
		-- self.ForegripOverride = (string.find(self.Sequence, "throw") != nil) // nope
		self.ForegripParent = (string.find(self.Sequence, "throw") != nil) and "throwfix" or "none"
	end
end


