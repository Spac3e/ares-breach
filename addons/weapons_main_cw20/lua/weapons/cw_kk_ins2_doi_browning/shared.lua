--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_browning/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "lmgBox"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1919A6 Browning"
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_m1919")

	SWEP.NoShells = true

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.ShellEjectVelocity = 50

	SWEP.Shell2 = "KK_INS2_30-06_link"
	SWEP.Shell2Scale = 0.7
	SWEP.Shell2EjectVelocity = 50
	SWEP.Shell2ViewAttachmentID = 2
	SWEP.Shell2ViewAngleAlign = {Forward = 0, Right = 0, Up = 180}
	SWEP.Shell2WorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.9629, -2, 1.275)
	SWEP.IronsightAng = Vector(0, 0.0457, 0)

	SWEP.CustomizationMenuScale = 0.018
end

SWEP.MuzzleEffect = "muzzleflash_m1919_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_bar_3p"

SWEP.Attachments = {
	--["+reload"] = {header = "Ammo", offset = {900, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire_1", "base_fire_2"},
	base_fire_aim = {"iron_fire_1","iron_fire_2"},
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
	bipod_fire = {"deployed_fire_1","deployed_fire_2"},
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_m1919.mdl"
SWEP.WorldModel		= "models/weapons/w_m1919.mdl"

SWEP.WMPos = Vector(15.986, 0.921, -6.038)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 250
SWEP.Primary.DefaultClip = 0 --	= 250
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".30-06"

SWEP.FireDelay = 60/500
SWEP.FireSound = "CW_KK_INS2_DOI_BROWNING_FIRE"
SWEP.Recoil = 1.1

SWEP.HipSpread = 0.065
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 2.4
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 60

SWEP.FirstDeployTime = 3.1
SWEP.DeployTime = 0.9
SWEP.HolsterTime = 0.6

SWEP.BipodDeployTime = 2
SWEP.BipodUndeployTime = 1.5

SWEP.Chamberable = false
SWEP.BipodInstalled = true
SWEP.WeaponLength = 24

SWEP.MuzzleVelocity = 850

SWEP.ReloadTimes = {
	base_reload = {5.5, 7.33},
	base_reload_empty = {4.7, 8.58},

	deployed_reload = {5.5, 7.33},
	deployed_reload_empty = {4.7, 8.58},

	base_melee_bash = {0.6, 1.6},
}
