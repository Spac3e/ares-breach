--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m60/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "brMag"

SWEP.TSGlass = Material("models/weapons/nam/optics/lense_rt")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M60"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_m60")

	SWEP.NoShells = true

	SWEP.Shell = "KK_INS2_556x45"
	SWEP.ShellEjectVelocity = 50

	SWEP.Shell2 = "KK_INS2_30-06_link"
	SWEP.Shell2Scale = 0.7
	SWEP.Shell2EjectVelocity = 50
	SWEP.Shell2ViewAttachmentID = 3
	SWEP.Shell2ViewAngleAlign = {Forward = 0, Right = 0, Up = -90}
	SWEP.Shell2WorldAngleAlign = {Forward = 0, Right = 0, Up = -90}

	SWEP.AttachmentModelsVM = {}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-1.7534, -3, 0.6472)
	SWEP.IronsightAng = Vector(-0.1947, 0.0136, 0)

	SWEP.CustomizationMenuScale = 0.019
end

SWEP.MuzzleEffect = "muzzleflash_m14_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_m14_3rd"

SWEP.Attachments = {
	-- {header = "Sight", offset = {400, -500}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_scope_m40", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},
	-- {header = "Sight", offset = {400, -500}, atts = {"kk_ins2_scope_m82", "kk_ins2_scope_m40"}},
	-- {header = "More Sight", offset = {1000, -50}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
	-- ["+use"] = {header = "Sight Contract", offset = {400, -50}, atts = {"kk_ins2_sights_cstm"}},
	----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire_1","base_fire_2","base_fire_3"},
	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3","iron_fire_4"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_close = "base_reload_half",
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
	bipod_reload_close = "deployed_reload_half",
	bipod_reload_empty = "deployed_reload_empty",
	bipod_out = "deployed_out",
}

SWEP.SpeedDec = 40

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
SWEP.ViewModel		= "models/weapons/v_nam_m60.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_m60.mdl"

SWEP.WMPos = Vector(4.072, 0.924, -1.537)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.m26
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2kus
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip = 0 --	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x51MM"

SWEP.FireDelay = 60/650
SWEP.FireSound = "CW_KK_INS2_NAM_M60_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_M14_FIRE_SUPPRESSED"
SWEP.Recoil = 1.6

SWEP.HipSpread = 0.055
SWEP.AimSpread = 0.002
SWEP.VelocitySensitivity = 2.1
SWEP.MaxSpreadInc = 0.07
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.12
SWEP.Shots = 1
SWEP.Damage = 64

SWEP.FirstDeployTime = 1.7
SWEP.DeployTime = 1.6
SWEP.HolsterTime = 0.8

SWEP.BipodDeployTime = 1.45
SWEP.BipodUndeployTime = 1.45

SWEP.WeaponLength = 28

SWEP.Chamberable = false
SWEP.BipodInstalled = true

SWEP.MuzzleVelocity = 853

SWEP.ReloadTimes = {
	base_reload = {9, 10.4},
	base_reload_half = {10, 11.4},
	base_reload_empty = {10.9, 12.3},

	base_melee_bash = {0.6, 1.7},

	deployed_reload = {8.3, 9.5},
	deployed_reload_half = {9.2, 10.5},
	deployed_reload_empty = {10, 11.3},
}

SWEP.reloadProgressAnimsRaw = {
	base_reload_close = true,
	bipod_reload_close = true
}

SWEP.reticleInactivityCallbacksRaw = {
	["base_reload_close"] = 0.1,
	["bipod_reload_close"] = 0.1,
}

function SWEP:overrideReloadAnim(prefix, suffix)
	local clip = self:Clip1()

	if clip > 15 then
		return prefix .. "reload" .. suffix
	elseif clip > 0 then
		return prefix .. "reload_close" .. suffix
	end

	return prefix .. "reload_empty" .. suffix
end
