--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_webley/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Webley Mk4"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_webley")

	SWEP.Shell = "KK_INS2_762x33"
	SWEP.NoShells = true
	SWEP.ShellScale = 1
	SWEP.ShellEjectVelocity = 50

	SWEP.AttachmentModelsVM = {
		["kk_ins2_revolver_mag"] = {model = "models/weapons/upgrades/a_speedloader_webley.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {}

	-- SWEP.IronsightPos = Vector(-1.9003, 0, 0.4979)
	-- SWEP.IronsightAng = Vector(0, 0, 6.6626)

	SWEP.IronsightPos = Vector(0, 0, 0)
	SWEP.IronsightAng = Vector(0, 0.0802, 0)

	SWEP.CustomizationMenuScale = 0.013

	SWEP.SprintAnimSpeed = 1.1
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true
	SWEP.HUD_MagText = "CYLINDER: "
end

SWEP.MuzzleEffect = "muzzleflash_1911_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_sten_3p"

SWEP.Attachments = {
	{header = "Reload Aid", offset = {500, 0}, atts = {"kk_ins2_revolver_mag"}},
	--["+reload"] = {header = "Ammo", offset = {-300, 200}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	draw = {"base_ready", "base_ready_rare"},

	base_reload_start = "base_reload_start",
	base_reload_start_empty = "base_reload_start",
	base_insert = "base_reload_insert",
	base_reload_end = "base_reload_end",
	base_reload_end_empty = "base_reload_end",
	base_idle = "base_reload_end",

	base_pickup = {"base_ready", "base_ready_rare"},
	base_draw = "base_draw",
	base_fire = {"base_fire", "base_fire2", "base_fire3"},
	base_fire_aim = {"iron_fire_1_preblend","iron_fire_2_preblend"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire_preblend",
	base_reload = "base_reload_speed",
	base_reload_empty = "base_reload_speed",
	base_idle = "base_idle",
	base_idle_aim = "iron_idle_preblend",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down_preblend",
	base_crawl = "base_crawl",
	base_melee = "base_melee_bash",
}

SWEP.SpeedDec = 10

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "pistol"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_webley.mdl"
SWEP.WorldModel		= "models/weapons/w_webley.mdl"

SWEP.WMPos = Vector(5.5, 1.623, -3.5)
SWEP.WMAng = Vector(-3, -5, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip = 0 --	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".380/200"

SWEP.FireDelay = 60/380
SWEP.FireSound = "CW_KK_INS2_DOI_WEBLEY_FIRE"
SWEP.Recoil = 2.86

SWEP.HipSpread = 0.039
SWEP.AimSpread = 0.0085
SWEP.VelocitySensitivity = 1.35
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.02
SWEP.SpreadCooldown = 0.25
SWEP.Shots = 1
SWEP.Damage = 28

SWEP.FirstDeployTime = 1.7
SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.4

SWEP.CanRestOnObjects = false
SWEP.Chamberable = false
SWEP.WeaponLength = 16

SWEP.MuzzleVelocity = 190

SWEP.ReloadTimes = {
	base_reload_start = {24/35, 1.37, KK_INS2_REVOLVER_SLOW_UNLOAD},
	base_reload_insert = {0.4, 1.02},
	base_reload_end = {1.42, 1.42},
	base_reload_speed = {1.8, 3.5, KK_INS2_REVOLVER_SPEED_UNLOAD, 22/33},

	base_melee_bash = {0.3, 0.8},
}

function SWEP:IndividualInitialize()
	self.magType = "NONE"
	self.ShotgunReload = true

	if CLIENT then
		self:setBodygroup(1, self:Clip1())
		self:setBodygroup(2, self:Clip1())
	end
end
