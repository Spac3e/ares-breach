--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1912/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1912"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/cw_kk_ins2_doi_m1912")

	SWEP.NoShells = true
	SWEP.Shell = "KK_INS2_12guage"
	-- SWEP.ShellDelay = 13/30

	SWEP.AttachmentModelsVM = {}
	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.004, -2, 1.0358)
	SWEP.IronsightAng = Vector(0.3819, 0.0619, 0)

	SWEP.CustomizationMenuScale = 0.015
end

SWEP.MuzzleEffect = "muzzleflash_ithica_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_ithica_3p"

SWEP.Attachments = {
	-- {header = "Stock", offset = {1000, 0}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_slugrounds", "am_flechetterounds"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire_1", "base_fire_2"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_bolt = {"base_fire_cock_1", "base_fire_cock_2"},
	base_bolt_aim = {"iron_fire_cock_1", "iron_fire_cock_2"},
	base_reload_start = "base_reload_start",
	base_reload_start_empty = "base_reload_start_empty",
	base_insert = "base_reload_insert",
	base_reload_end = "base_reload_end",
	base_reload_end_empty = "base_reload_end_empty",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 15

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"pump"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_cw_kk_doi_m1912.mdl"
SWEP.WorldModel		= "models/weapons/w_cw_kk_doi_m1912.mdl"

SWEP.WMPos = Vector(4.763, 0.935, -2.445)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip = 0 --	= 9
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12 Gauge"

SWEP.FireDelay = 0.3
SWEP.FireSound = "CW_KK_INS2_DOI_M1912_FIRE"
SWEP.Recoil = 2

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.4
SWEP.MaxSpreadInc = 0.02
SWEP.ClumpSpread = 0.02
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.85
SWEP.Shots = 12
SWEP.Damage = 11

SWEP.FirstDeployTime = 2.2
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.Chamberable = true
SWEP.SnapToIdlePostReload = false
SWEP.ShotgunReload = true
SWEP.ReticleInactivityPostFire = SWEP.FireDelay + 0.2
SWEP.GlobalDelayOnShoot = SWEP.FireDelay

SWEP.WeaponLength = 18

SWEP.MuzzleVelocity = 381

SWEP.ReloadTimes = {
	base_fire_cock_1 = {2/24, 0.5},
	base_fire_cock_2 = {2/24, 0.5},
	iron_fire_cock_1 = {4/35, 0.5},
	iron_fire_cock_2 = {4/35, 0.5},

	base_reload_start = {0.6, 0.6},
	base_reload_start_empty = {2.25, 2.89, KK_INS2_SHOTGUN_LOAD_FIRST},
	base_reload_insert = {15/36, 0.72},
	base_reload_end = {0.6, 0.6},
	base_reload_end_empty = {0.6, 0.6},
}
