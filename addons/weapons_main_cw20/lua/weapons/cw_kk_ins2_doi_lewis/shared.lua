--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_lewis/shared.lua

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
	SWEP.PrintName = "Lewis gun"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_lewis")

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.ShellDelay = 0.1

	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = -22}
	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 0}

	SWEP.AttachmentModelsVM = {
		-- ["ani_body"] = {model = "models/weapons/v_lewis.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_lewis.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-3.3295, -2, 2.1344)
	SWEP.IronsightAng = Vector(-0.0648, 0.0265, 0)

	SWEP.CustomizationMenuScale = 0.02
end

SWEP.MuzzleEffect = "muzzleflash_m1919_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_bar_3p"

SWEP.Attachments = {
	-- {header = "Stock", offset = {1000, 0}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {500, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = {"base_fire_1", "base_fire_2"},
	base_fire_aim = {"iron_fire_1","iron_fire_2"},
	base_fire_last = "base_fire_last",
	base_fire_last_aim = "iron_fire_last",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "base_holster_empty",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint_empty",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "base_down_empty",
	base_safe_empty_aim = "iron_down_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash",

	bipod_in = "deployed_in",
	bipod_in_empty = "deployed_in",
	bipod_fire = {"deployed_fire_1", "deployed_fire_2"},
	bipod_fire_aim = {"deployed_iron_fire_1", "deployed_iron_fire_2"},
	bipod_fire_last = "deployed_fire_last",
	bipod_fire_last_aim = "deployed_iron_fire_last",
	bipod_fire_empty = "deployed_dryfire",
	bipod_fire_empty_aim = "deployed_iron_dryfire",
	bipod_reload = "deployed_reload",
	bipod_reload_empty = "deployed_reload_empty",
	bipod_out = "deployed_out",
	bipod_out_empty = "deployed_out",
}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/kk_doi/v_lewis.mdl"
SWEP.WorldModel		= "models/weapons/w_lewis.mdl"

SWEP.WMPos = Vector(14.5, 1, -4)
SWEP.WMAng = Vector(-6, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 47
SWEP.Primary.DefaultClip = 0 --	= 47
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".303 British"

SWEP.FireDelay = 60/600
SWEP.FireSound = "CW_KK_INS2_DOI_LEWIS_FIRE"
SWEP.Recoil = 1.1

SWEP.HipSpread = 0.065
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 2.4
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 60

SWEP.FirstDeployTime = 3.5
SWEP.DeployTime = 1.4
SWEP.HolsterTime = 0.8

SWEP.Chamberable = false
SWEP.BipodInstalled = true
SWEP.KK_INS2_EmptyIdle = true

SWEP.WeaponLength = 28

SWEP.MuzzleVelocity = 740

SWEP.ReloadTimes = {
	base_reload = {170/34.5, 6.52},
	base_reloadempty = {158/34.5, 7.42},

	deployed_reload = {170/35.5, 6.34},
	deployed_reload_empty = {158/35.5, 7.21},

	base_melee_bash = {0.5, 1.7},
}
