--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_bren/shared.lua

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
	SWEP.PrintName = "Bren Mk2"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_bren_mk2")

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.ShellDelay = 0.1

	SWEP.ShellViewAngleAlign = {Forward = 90, Right = 0, Up = 0}
	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {
		-- ["ani_body"] = {model = "models/weapons/v_bren.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_bren.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_bren.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.0786, -3, 2.3467)
	SWEP.IronsightAng = Vector(-0.053, 0.2252, 0)

	SWEP.CustomizationMenuScale = 0.02
end

SWEP.MuzzleEffect = "muzzleflash_m1919_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_bar_3p"

SWEP.Attachments = {
	{header = "Stock", offset = {1000, 0}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {500, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire_1", "base_fire_2", "base_fire_3"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reload_empty",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
	base_melee = "base_melee_bash",

	bipod_in = "deployed_in",
	bipod_fire = {"deployed_fire_1", "deployed_fire_2"},
	bipod_fire_aim = {"deployed_iron_fire_1","deployed_iron_fire_2"},
	bipod_fire_empty = "deployed_dryfire",
	bipod_fire_empty_aim = "deployed_iron_dryfire",
	bipod_reload = "deployed_reload",
	bipod_reload_empty = "deployed_reload_empty",
	bipod_out = "deployed_out",
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_bren.mdl"
SWEP.WorldModel		= "models/weapons/w_bren.mdl"

SWEP.WMPos = Vector(5, 1, -1.5)
SWEP.WMAng = Vector(-6, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip = 0 --	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".303 British"

SWEP.FireDelay = 60/520
SWEP.FireSound = "CW_KK_INS2_DOI_BREN_FIRE"
SWEP.Recoil = 1.1

SWEP.HipSpread = 0.065
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 2.4
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 60

SWEP.FirstDeployTime = 3
SWEP.DeployTime = 1.4
SWEP.HolsterTime = 0.8

SWEP.Chamberable = false
SWEP.BipodInstalled = true

SWEP.WeaponLength = 28

SWEP.MuzzleVelocity = 743.7

SWEP.ReloadTimes = {
	base_reload = {4, 5.79},
	base_reload_empty = {5.8, 7.76},

	deployed_reload = {4, 5.71},
	deployed_reload_empty = {5.8, 7.56},

	base_melee_bash = {0.5, 1.7},
}
