--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_svt40/shared.lua

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
	SWEP.PrintName = "SVT-40"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_svt40")

	SWEP.Shell = "KK_INS2_762x39"
	SWEP.ShellDelay = 0.03

	SWEP.AttachmentModelsVM = {
		["kk_ins2_bipod"] = {model = "models/weapons/upgrades/a_bipod_sks.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_foregrip_ins.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), attachment = "Foregrip"},

		["kk_ins2_scope_mosin"] = {model = "models/weapons/upgrades/a_optic_svt40_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_bipod"] = {model = "models/weapons/upgrades/w_bipod_mosin.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/w_ins_foregrip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_mosin"] = {model = "models/weapons/upgrades/w_scope_svt.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-2.2386, -2, 1.6034)
	SWEP.IronsightAng = Vector(0.0305, 0.003, 0)

	SWEP.KKINS2ScopeMosinPos = Vector(-2.2171, 0, 0.8822)
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
		-- {header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_pbs1"}},
		{header = "Under", offset = {-500, 0}, atts = {"kk_ins2_bipod", "kk_ins2_vertgrip"}},
		-- {header = "Lasers", offset = {125, 300}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},
		-- {header = "More Sight", offset = {1000, -50}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
		-- ["+use"] = {header = "Sight Contract", offset = {400, -50}, atts = {"kk_ins2_sights_cstm"}},
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
	bipod_fire_last = "deployed_firelast",
	bipod_fire_empty = {"deployed_dryfire","deployed_empty_dryfire"},
	bipod_fire_aim = "deployed_iron_fire",
	bipod_fire_last_aim = "deployed_iron_fire_last",
	bipod_fire_empty_aim = "deployed_iron_dryfire",
	bipod_reload = "deployed_reload",
	bipod_reload_empty = "deployed_reloadempty",
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
SWEP.ViewModel		= "models/weapons/v_nam_svt40.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_svt40.mdl"

SWEP.WMPos = Vector(3, 1.009, 0)
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

SWEP.FireDelay = 60/600
SWEP.FireSound = "CW_KK_INS2_NAM_SVT40_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_MOSIN_FIRE_SUPPRESSED"
SWEP.Recoil = 1.08

SWEP.HipSpread = 0.075
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 2.5
SWEP.MaxSpreadInc = 0.2
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 2
SWEP.Shots = 1
SWEP.Damage = 63

SWEP.FirstDeployTime = 1.5
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.7

SWEP.RecoilToSpread = 0.8

SWEP.BipodDeployTime = 1.15
SWEP.BipodUndeployTime = 1.15

SWEP.SnapToIdlePostReload = false

SWEP.WeaponLength = 22

SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 840

SWEP.ReloadTimes = {
	base_reload = {2.3, 3.3},
	base_reloadempty = {2.3, 4.6},

	foregrip_reload = {2.3, 3.3},
	foregrip_reloadempty = {2.3, 4.6},

	deployed_reload = {2.3, 3.3},
	deployed_reloadempty = {2.3, 4.6},
}
