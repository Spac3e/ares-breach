--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_vz58/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "arMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Vzor 58"
	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_vz58")

	SWEP.Shell = "KK_INS2_545x39"
	SWEP.ShellDelay = 0.03

	SWEP.AttachmentModelsVM = {}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-1.3393, -3, 1.0158)
	SWEP.IronsightAng = Vector(-0.2236, 0.0571, 0)

	SWEP.CustomizationMenuScale = 0.016
end

SWEP.MuzzleEffect = "muzzleflash_akm_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_akm_3rd"

SWEP.Attachments = {
	-- {header = "Sight", offset = {400, -450}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},
	-- {header = "Barrel", offset = {-100, -450}, atts = {"kk_ins2_pbs5"}},
	-- {header = "Under", offset = {-400, 0}, atts = {"kk_ins2_vertgrip", "kk_ins2_gl_gp25"}},
	-- {header = "Lasers", offset = {200, 400}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},
	-- {header = "More Sight", offset = {1000, 0}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
	-- ["+use"] = {header = "Sight Contract", offset = {400, -0}, atts = {"kk_ins2_sights_cstm"}},
	----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = "base_fire",
	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3"},
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
	base_firemode_aim = "iron_fireselect",
	base_firemode_empty = "base_fireselect_empty",
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

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
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
SWEP.ViewModel		= "models/weapons/v_nam_vz58.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_vz58.mdl"

SWEP.WMPos = Vector(5.666, 0.66, -1.055)
SWEP.WMAng = Angle(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.rgd5
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2keh
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip = 0 --	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x39MM"

SWEP.FireDelay = 60/800
SWEP.FireSound = "CW_KK_INS2_NAM_VZ58_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_AKM_FIRE_SUPPRESSED"
SWEP.Recoil = 1.2

SWEP.HipSpread = 0.043
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 40

SWEP.FirstDeployTime = 2.5
SWEP.DeployTime = 0.9
SWEP.HolsterTime = 0.9

SWEP.WeaponLength = 22

SWEP.MuzzleVelocity = 705

SWEP.KK_INS2_EmptyIdle = true

SWEP.ReloadTimes = {
	base_reload = {2.85, 3.8},
	base_reloadempty = {3, 4.6},
}
