--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_mac10/shared.lua

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
	SWEP.PrintName = "MAC-10"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_mac10")

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.15

	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 180}
	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_suppressor_ins"] = {model = "models/weapons/upgrades/a_suppressor_mac10.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_suppressor_ins"] = {model = "models/weapons/upgrades/w_suppressor_mac10.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-2.1541, -2, 0.6321)
	SWEP.IronsightAng = Vector(0, 0.0578, 0)

	SWEP.CustomizationMenuScale = 0.012
end

SWEP.MuzzleEffect = "muzzleflash_mp5_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_mp5_3rd"

SWEP.Attachments = {
	{header = "Barrel", offset = {500, -200}, atts = {"kk_ins2_suppressor_ins"}},
	--["+reload"] = {header = "Ammo", offset = {500, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = "base_fire",
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
	base_firemode = "base_fireselect",
	base_firemode_empty = "base_fireselect_empty",
	base_firemode_aim = "iron_fireselect",
	base_firemode_empty_aim = "iron_fireselect_empty",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "empty_down",
	base_safe_empty_aim = "iron_empty_down",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
}

SWEP.SpeedDec = 15

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "pistol"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_mac10.mdl"
SWEP.WorldModel		= "models/weapons/w_mac10.mdl"

SWEP.WMPos = Vector(2.5, 4.889, -1.417)
SWEP.WMAng = Vector(-25, -30, 130)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.m26
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2kus
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 32
SWEP.Primary.DefaultClip = 0 --	= 32
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x19MM"

SWEP.FireDelay = 60/1250
SWEP.FireSound = "CW_KK_INS2_NAM_MAC10_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_MP5K_FIRE_SUPPRESSED"
SWEP.Recoil = 0.77

SWEP.HipSpread = 0.035
SWEP.AimSpread = 0.009
SWEP.VelocitySensitivity = 1.5
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 25

SWEP.FirstDeployTime = 2
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.6

SWEP.Chamberable = false

SWEP.WeaponLength = 16 // this things gotta b longer than MP5k

SWEP.KK_INS2_EmptyIdle = false

SWEP.ReloadTimes = {
	base_reload = {2.2, 2.95},
	base_reloadempty = {3.2, 4.55}
}

SWEP.MuzzleVelocity = 366
