--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_mp40/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "smgMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "MP40"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.1

	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 180}
	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_mp40.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.5062, -2, 0.5482)
	SWEP.IronsightAng = Vector(0.2105, 0.0425, 0)

end

SWEP.MuzzleEffect = "muzzleflash_vollmer"
SWEP.MuzzleEffectWorld = "muzzleflash_vollmer"

SWEP.Attachments = {
	{header = "Stock", offset = {900, 100}, atts = {"kk_ins2_ww2_sling"}},
	["+reload"] = {header = "Ammo", offset = {-200, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = {"base_fire", "base_fire2", "base_fire3"},
	base_fire_aim = {"iron_fire","iron_fire_a","iron_fire_b","iron_fire_c","iron_fire_d","iron_fire_e","iron_fire_f"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "empty_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "empty_down",
	base_safe_empty_aim = "iron_empty_down",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
	base_melee = "base_melee_bash",
	base_melee_empty = "empty_melee_bash",
}

SWEP.SpeedDec = 15

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "mp40"
SWEP.RunHoldType = "mp40"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "(GERMAN) WW2"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_mp40.mdl"
SWEP.WorldModel		= "models/weapons/w_mp40.mdl"

SWEP.WMPos = Vector(5.176, 0.889, -1.417)
SWEP.WMAng = Vector(-10, 0, 180)

-- SWEP.NormalHoldType = "cw_kk_dods_mp40"
-- SWEP.WMPos = Vector(4, 2, -1)
-- SWEP.WMAng = Vector(5, -5, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2de
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2de

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 32
SWEP.Primary.DefaultClip    = 9999
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.FireDelay = 60/500
SWEP.FireSound = "CW_KK_INS2_DOI_MP40_FIRE"
SWEP.Recoil = 3.5

SWEP.HipSpread = 0.060
SWEP.AimSpread = 0.009
SWEP.VelocitySensitivity = 1.5
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 18

SWEP.FirstDeployTime = 1.7
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.Chamberable = false

SWEP.WeaponLength = 16 // this things gotta b longer than MP5k

SWEP.KK_INS2_EmptyIdle = true

SWEP.ReloadTimes = {
	base_reload = {2.2, 2.95},
	base_reloadempty = {3.2, 4.55},

	base_melee_bash = {0.3, 0.9},
	empty_melee_bash = {0.3, 0.9},
}

SWEP.MuzzleVelocity = 400
