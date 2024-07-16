--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_sks/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "arMag"

SWEP.TSGlass = Material("models/weapons/nam/optics/pu/lense_rt")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "SKS"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_sks")

	SWEP.Shell = "KK_INS2_762x39"
	SWEP.ShellDelay = 0.03

	SWEP.AttachmentModelsVM = {
		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_mosin"] = {model = "models/weapons/upgrades/a_optic_pu_sks.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_lam"] = {model = "models/weapons/upgrades/w_laser_ins.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/w_laser_ins.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_mosin"] = {model = "models/weapons/upgrades/w_optic_pu_sks.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-1.3824, -2, 0.9608)
	SWEP.IronsightAng = Vector(0.1564, 0.0462, 0)

	SWEP.KKINS2ScopeMosinPos = Vector(-1.3349, 1, 0.2709)
	SWEP.KKINS2ScopeMosinAng = Vector(0, 0, 0)

	SWEP.CustomizationMenuScale = 0.017
end

SWEP.MuzzleEffect = "muzzleflash_sks_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_sks_3rd"

SWEP.Attachments = {
	{header = "Sight", offset = {400, -500}, atts = {"kk_ins2_scope_mosin"}},
	----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

local hasBase = CustomizableWeaponry_KK.ins2.isContentMounted4({Folder = "weapons/cw_kk_ins2_base"})
if hasBase then
	SWEP.Attachments = {
		{header = "Sight", offset = {400, -500}, atts = {"kk_ins2_scope_mosin"}},
		{header = "Lasers", offset = {125, 300}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},
		----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
	}
end

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = "base_fire",
	base_fire_aim = "iron_fire",
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
}

SWEP.SpeedDec = 40

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_nam_sks.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_sks.mdl"

SWEP.WMPos = Vector(15, 1.009, -3)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.rgd5
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2keh
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip = 0 --	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x39MM"

SWEP.FireDelay = 60/600
SWEP.FireSound = "CW_KK_INS2_NAM_SKS_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_SKS_FIRE_SUPPRESSED"
SWEP.Recoil = 1.08

SWEP.HipSpread = 0.043
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 42

SWEP.FirstDeployTime = 1.3
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.6

SWEP.RecoilToSpread = 0.8

SWEP.BipodDeployTime = 1.15
SWEP.BipodUndeployTime = 1.15

SWEP.SnapToIdlePostReload = false

SWEP.WeaponLength = 22

SWEP.KK_INS2_EmptyIdle = true
SWEP.Chamberable = false

SWEP.MuzzleVelocity = 735

SWEP.ReloadTimes = {
	base_reload = {4.3, 6.5},
	base_reloadempty = {3.3, 5.4},
}
