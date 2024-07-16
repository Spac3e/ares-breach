--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_owen_mk2/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_soundscript.lua")
include("sh_soundscript.lua")

SWEP.magType = "smgMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Owen Mk2"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_owen")

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.1

	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 0}
	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {
		-- ["mk0"] = {model = "models/weapons/v_owen.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true},
		-- ["mk2"] = {model = "models/weapons/v_owen_mk2.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},

		-- ["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/a_enfield_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		-- ["kk_ins2_ww2_knife_fat"] = {model = "models/weapons/upgrades/a_enfield_bayonet_spike.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/a_enfield_bayonet.mdl", pos = Vector(-33.1778, -2.5579, 2.3027), angle = Angle(), size = Vector(1, 1, 1), attachment = "muzzle"},
		["kk_ins2_ww2_knife_fat"] = {model = "models/weapons/upgrades/a_enfield_bayonet_spike.mdl", pos = Vector(-3.4993, -0.0013, -1.0586), angle = Angle(), size = Vector(1, 1, 1), attachment = "muzzle"},

		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_owen.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["mk2"] = {model = "models/weapons/v_owen_mk2.mdl", pos = Vector(-23.4612, -4.6237, 8.2823), angle = Angle(0, 90, 0), size = Vector(1.4, 1.4, 1.4), bone = "__INVALIDBONE__", hideVM = true, active = true},
	}

	SWEP.CustomizationMenuScale = 0.013

	SWEP.IronsightPos = Vector(-3.7548, -2, 2.7674)
	SWEP.IronsightAng = Vector(0.1261, 1.1881, -12.9542)
end

SWEP.MuzzleEffect = "muzzleflash_sten_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_sten_3p"

SWEP.Attachments = {
	{header = "Barrel", offset = {-200, -200}, atts = {"kk_ins2_ww2_knife", "kk_ins2_ww2_knife_fat"}},
	{header = "Stock", offset = {800, -200}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {800, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = {"base_fire_1","base_fire_2"},
	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reload_empty",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "base_holster_empty",
	base_firemode = "base_fireselect",
	base_firemode_empty = "base_fireselect_empty",
	base_firemode_aim = "iron_fireselect",
	base_firemode_empty_aim = "iron_fireselect_empty",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint_empty",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "base_down_empty",
	base_safe_empty_aim = "iron_down_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash_empty",
	base_stab = "base_melee_end",
	base_stab_empty = "base_melee_end_empty",
}

SWEP.SpeedDec = 15

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "smg"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
-- SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_owen.mdl"
SWEP.ViewModel		= "models/weapons/cw_kk_doi_c054/v_owen_mk2.mdl"
SWEP.WorldModel		= "models/weapons/w_owen.mdl"

SWEP.WMPos = Vector(10, 1, -2.5)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 33
SWEP.Primary.DefaultClip = 0 --	= 33
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x19MM"

SWEP.FireDelay = 60/700
SWEP.FireSound = "CW_KK_INS2_DOI_OWEN_FIRE"
SWEP.Recoil = 0.56

SWEP.HipSpread = 0.035
SWEP.AimSpread = 0.0153
SWEP.VelocitySensitivity = 1.5
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 25

SWEP.FirstDeployTime = 0.8
SWEP.DeployTime = 0.8
SWEP.HolsterTime = 0.8

SWEP.WeaponLength = 16

SWEP.Chamberable = false
SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 420

SWEP.ReloadTimes = {
	base_reload = {80/33, 3.75},
	base_reload_empty = {80/33, 4.75},

	base_melee_bash = {0.3, 0.9},
	base_melee_bash_empty = {0.3, 0.9},
}
