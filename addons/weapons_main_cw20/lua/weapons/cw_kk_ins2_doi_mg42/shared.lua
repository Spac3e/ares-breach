--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_mg42/shared.lua

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
	SWEP.PrintName = "MG-42"
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_mg42")

	SWEP.NoShells = true

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.ShellEjectVelocity = 50

	SWEP.Shell2 = "KK_INS2_30-06_link"
	SWEP.Shell2Scale = 0.9
	SWEP.Shell2EjectVelocity = 50
	SWEP.Shell2ViewAttachmentID = 2
	SWEP.Shell2ViewAngleAlign = {Forward = 0, Right = 0, Up = 180}
	SWEP.Shell2WorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {
		-- ["ani_body"] = {model = "models/weapons/v_mg42.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		["kk_counter"] = {model = "models/weapons/stattrack.mdl", pos = Vector(-0.0566, 0.3055, 2.8376), angle = Angle(0, 0, -11.6799), size = Vector(0.3137, 0.3137, 0.3137), bone = "MG42"},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.CustomizePos = Vector(6.488, -1.627, -2.821)
	SWEP.CustomizeAng = Vector(17.009, 29.971, 16.669)

	SWEP.IronsightPos = Vector(-2.3595, -2, 0.952)
	SWEP.IronsightAng = Vector(-0.0747, 0.0156, 0)

	SWEP.CustomizationMenuScale = 0.015
end

SWEP.MuzzleEffect = "muzzleflash_mg42_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_mg42_3p"

SWEP.Attachments = {
	--["+reload"] = {header = "Ammo", offset = {200, 600}, atts = {"am_magnum", "am_matchgrade"}}
}

if CustomizableWeaponry_KK.HOME then
	table.insert(SWEP.Attachments, {header = "CSGO", offset = {2100, 200}, atts = {"kk_counter"}})
end

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire_1","base_fire_2"},
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
	bipod_reload_empty_charged = "deployed_reload",
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_mg42.mdl"
SWEP.WorldModel		= "models/weapons/w_mg42.mdl"

SWEP.WMPos = Vector(13.486, 0.5, -3)
SWEP.WMAng = Vector(-5, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2de
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2de

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 250
SWEP.Primary.DefaultClip = 0 --	= 250
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.92x57MM"

SWEP.FireDelay = 60/1200
SWEP.FireSound = "CW_KK_INS2_DOI_MG42_FIRE"
SWEP.Recoil = 1.1

SWEP.HipSpread = 0.065
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 2.4
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 60

SWEP.BipodDeployTime = 2.18
SWEP.BipodUndeployTime = 1.73

SWEP.FirstDeployTime = 3.1
SWEP.DeployTime = 0.9
SWEP.HolsterTime = 0.6

SWEP.Chamberable = false
SWEP.BipodInstalled = true
SWEP.WeaponLength = 26

SWEP.MuzzleVelocity = 740

SWEP.ReloadTimes = {
	base_reload = {6.2, 8.21},
	base_reload_empty = {6.94, 8.96},

	deployed_reload = {6, 7.97},
	deployed_reload_empty = {6.95, 8.96},

	base_melee_bash = {0.6, 1.7},
}
