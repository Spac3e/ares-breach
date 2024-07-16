--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_svd/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.TSGlass = Material("models/weapons/nam/optics/lense_rt")

SWEP.magType = "brMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "SVD"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_svd")

	SWEP.Shell = "KK_INS2_762x54"
	-- SWEP.NoShells = true
	SWEP.ShellDelay = 0

	SWEP.BackupSights = {
		["kk_ins2_elcan"] = {
			Vector(-2.8208, -12, -1.1186),
			Vector(-0.4986, 0, 0)
		},
	}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_bipod"] = {model = "models/weapons/upgrades/a_bipod_sks.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_foregrip_ins.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), attachment = "Foregrip"},

		["kk_ins2_scope_nam_pso"] = {model = "models/weapons/upgrades/a_pso1.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_bipod"] = {model = "models/weapons/upgrades/w_bipod_mosin.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/w_ins_foregrip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_nam_pso"] = {model = "models/weapons/upgrades/w_pso1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-2.0166, -2, 0.5294)
	SWEP.IronsightAng = Vector(0.0934, -0.0015, 0)

	SWEP.KKINS2NAMPSOPos = Vector(-1.9652, -1, -0.0041)
	SWEP.KKINS2NAMPSOAng = Vector(0, 0, 0)

	SWEP.CustomizationMenuScale = 0.017
end

SWEP.MuzzleEffect = "muzzleflash_sks_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_sks_3rd"

SWEP.Attachments = {
	{header = "Sight", offset = {500, -450}, atts = {"kk_ins2_scope_nam_pso"}},
	--["+reload"] = {header = "Ammo", offset = {1100, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

local hasBase = CustomizableWeaponry_KK.ins2.isContentMounted4({Folder = "weapons/cw_kk_ins2_base"})
if hasBase then
	SWEP.Attachments = {
		{header = "Sight", offset = {500, -450}, atts = {"kk_ins2_scope_nam_pso"}},
		{header = "Under", offset = {-500, 0}, atts = {"kk_ins2_bipod", "kk_ins2_vertgrip"}},
		--["+reload"] = {header = "Ammo", offset = {1100, 500}, atts = {"am_magnum", "am_matchgrade"}}
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
	base_idle_aim = "base_idle",
	base_idle_empty = "empty_idle",
	base_idle_empty_aim = "empty_idle",
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

	foregrip_pickup = "foregrip_ready",
	foregrip_draw = "foregrip_draw",
	foregrip_draw_empty = "foregrip_empty_draw",
	foregrip_fire = "foregrip_fire",
	foregrip_fire_aim = "foregrip_iron_fire_b",
	foregrip_fire_last = "foregrip_firelast",
	foregrip_fire_last_aim = "foregrip_iron_firelast_b",
	foregrip_fire_empty = "foregrip_dryfire",
	foregrip_fire_empty_aim = "foregrip_iron_dryfire_b",
	foregrip_reload = "foregrip_reload",
	foregrip_reload_empty = "foregrip_reloadempty",
	foregrip_idle = "foregrip_holster",
	foregrip_idle_empty = "foregrip_empty_idle",
	foregrip_holster = "foregrip_holster",
	foregrip_holster_empty = "foregrip_empty_holster",
	foregrip_sprint = "foregrip_sprint",
	foregrip_sprint_empty = "foregrip_empty_sprint",
	foregrip_safe = "foregrip_down",
	foregrip_safe_aim = "foregrip_iron_down",
	foregrip_safe_empty = "foregrip_empty_down",
	foregrip_safe_empty_aim = "foregrip_empty_iron_down",
	foregrip_crawl = "foregrip_crawl",
	foregrip_crawl_empty = "foregrip_empty_crawl",

	bipod_in = "deployed_in",
	bipod_in_empty = "deployed_empty_in",
	bipod_fire = "deployed_fire",
	bipod_fire_aim = "deployed_iron_fire",
	-- bipod_fire_last = "deployed_firelast",
	bipod_fire_last = "deployed_iron_fire_last",
	bipod_fire_last_aim = "deployed_iron_fire_last",
	bipod_fire_empty = "deployed_dryfire",
	bipod_fire_empty_aim = "deployed_iron_dryfire",
	bipod_reload = "deployed_reload",
	bipod_reload_empty = "deployed_reloadempty",
	bipod_idle = "deployed_fire",
	bipod_idle_aim = "deployed_fire",
	bipod_idle_empty = "deployed_fire",
	bipod_idle_empty_aim = "deployed_fire",
	bipod_out = "deployed_out",
	bipod_out_empty = "deployed_empty_out",
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
SWEP.ViewModel		= "models/weapons/v_nam_svd.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_svd.mdl"

SWEP.WMPos = Vector(6.136, 0.786, -1.713)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.rgd5
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2keh
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip = 0 --	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x54MMR"

SWEP.FireDelay = 60/300
SWEP.FireSound = "CW_KK_INS2_NAM_SVD_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_MOSIN_FIRE_SUPPRESSED"
SWEP.Recoil = 2.5

SWEP.HipSpread = 0.075
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 2.5
SWEP.MaxSpreadInc = 0.2
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 2
SWEP.Shots = 1
SWEP.Damage = 63

SWEP.FirstDeployTime = 1.7
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.8

SWEP.BipodDeployTime = 1.15
SWEP.BipodUndeployTime = 1.15

SWEP.SnapToIdlePostReload = false

SWEP.KK_INS2_EmptyIdle = true

SWEP.WeaponLength = 38

SWEP.MuzzleVelocity = 830

SWEP.ReloadTimes = {
	base_reload = {2.55, 3.2},
	base_reloadempty = {2.85, 4.5},

	foregrip_reload = {2.55, 3.2},
	foregrip_reloadempty = {2.85, 4.5},

	deployed_reload = {2.55, 3.2},
	deployed_reloadempty = {2.85, 4.5},
}
