--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1911/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "pistolMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1911"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_m1911")

	SWEP.Shell = "KK_INS2_45apc"
	SWEP.ShellDelay = 0.06

	SWEP.ShellViewAngleAlign = {Forward = 180, Right = 0, Up = -30}

	SWEP.AttachmentModelsVM = {}
	SWEP.AttachmentModelsWM = {}

	-- SWEP.IronsightPos = Vector(-1.8248, 0, 0.3468)
	-- SWEP.IronsightAng = Vector(0.7758, 0.0761, 6.2803)

	SWEP.IronsightPos = Vector(0.0005, 0, 0.1039)
	SWEP.IronsightAng = Vector(-0.3153, 0.0226, 0)

	SWEP.CustomizationMenuScale = 0.01
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true
end

SWEP.MuzzleEffect = "muzzleflash_1911_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_sten_3p"

SWEP.Attachments = {
	-- {header = "Magazine", offset = {-500, 150}, atts = {"kk_ins2_mag_m1911_15"}},
	--["+reload"] = {header = "Ammo", offset = {500, 150}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = {"base_fire","base_fire2","base_fire3"},
	base_fire_aim = {"iron_fire_preblend","iron_fire2_preblend","iron_fire3_preblend"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast_preblend",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire_preblend",
	base_reload = "base_reload",
	base_reload_mm = "base_reload_extmag",
	base_reload_empty = "base_reloadempty",
	base_reload_empty_mm = "base_reloadempty_extmag",
	base_reload_empty_lulz = "base_reloadempty_null",
	base_idle = "base_idle",
	base_idle_aim = "iron_idle_preblend",
	base_idle_empty = "iron_empty",
	base_idle_empty_aim = "iron_empty_preblend",
	base_holster = "base_holster",
	base_holster_empty = "empty_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_empty = "empty_down",
	base_safe_aim = "iron_down_preblend",
	base_safe_empty_aim = "empty_iron_down_preblend",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
	base_melee = "base_melee_bash",
	base_melee_empty = "empty_melee_bash",
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_m1911.mdl"
SWEP.WorldModel		= "models/weapons/w_cw_kk_doi_m1911.mdl"

SWEP.WMPos = Vector(5.309, 1.623, -1.616)
SWEP.WMAng = Vector(-3, -5, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip = 0 --	= 7
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".45 ACP"

SWEP.FireDelay = 0.1
SWEP.FireSound = "CW_KK_INS2_DOI_M1911_FIRE"
SWEP.Recoil = 1

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.013
SWEP.VelocitySensitivity = 1.25
SWEP.MaxSpreadInc = 0.036
SWEP.SpreadPerShot = 0.0125
SWEP.SpreadCooldown = 0.22
SWEP.Shots = 1
SWEP.Damage = 31

SWEP.FirstDeployTime = 2.5
SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.4

SWEP.CanRestOnObjects = false
SWEP.WeaponLength = 16

SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 251

SWEP.ReloadTimes = {
	base_reload = {1.9, 2.6},
	base_reloadempty = {1.9, 3.3},
	base_reload_extmag = {1.9, 2.6},
	base_reloadempty_extmag = {1.9, 3.3},
	base_reloadempty_null = {1.9, 3.4},

	base_melee_bash = {0.3, 0.8},
	empty_melee_bash = {0.3, 0.8},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("kk_ins2_mag_m1911_8", !self.ActiveAttachments.kk_ins2_mag_m1911_15)
	end
end

SWEP.reloadProgressAnimsRaw = {
	base_reload_empty_lulz = true
}

SWEP.reticleInactivityCallbacksRaw = {
	["base_reload_empty_lulz"] = 0.1
}

function SWEP:overrideReloadAnim(prefix, suffix)
	if self:Clip1() > 0 then
		return "base_reload"
	end

	if math.random(100) == 82 then
		return "base_reload_empty_lulz"
	end

	return "base_reload_empty"
end
