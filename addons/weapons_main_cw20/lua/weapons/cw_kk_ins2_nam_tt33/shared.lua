--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_tt33/shared.lua

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
	SWEP.PrintName = "TT-33"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_tokarev")

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.06

	SWEP.ShellViewAngleAlign = {Forward = 100, Right = 0, Up = 30}

	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_mag_makarov_8"] = {model = "models/weapons/upgrades/a_nam_magazine_makarov_8.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_makarov_15"] = {model = "models/weapons/upgrades/a_magazine_makarov_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_suppressor_pistol"] = {model = "models/weapons/upgrades/a_suppressor_pistol.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_mak.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_mak.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_m6x"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_m6x.mdl", bone = "Weapon", pos = Vector(-0.051, 1.011, -1.127), angle = Angle(0, -90, 0), size = Vector(0.85, 0.85, 0.85)},

		["kk_ins2_m6x_rail"] = {model = "models/cw2/attachments/lowerpistolrail.mdl", bone = "Weapon", pos = Vector(-0.049, 0.575, -0.477), angle = Angle(0, 90, 0), size = Vector(0.119, 0.119, 0.119),
			material = "models/weapons/attachments/cw_kk_ins2_cstm_m6x/rail_gy",
		},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_suppressor_pistol"] = {model = "models/weapons/upgrades/w_sil_pistol.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_mag_makarov_8"] = {model = "models/weapons/upgrades/w_magazine_makarov_8.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_makarov_15"] = {model = "models/weapons/upgrades/w_magazine_makarov_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_lam"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(0, 180, 0), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-1.6872, 0, 0.2884)
	SWEP.IronsightAng = Vector(-0.0693, 0.046, 0)

	SWEP.CustomizationMenuScale = 0.01
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true
end

SWEP.MuzzleEffect = "muzzleflash_makarov_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_makarov_3rd"

SWEP.Attachments = {
	--["+reload"] = {header = "Ammo", offset = {500, 150}, atts = {"am_magnum", "am_matchgrade"}}
}

local hasBase = CustomizableWeaponry_KK.ins2.isContentMounted4({Folder = "weapons/cw_kk_ins2_base"})
if hasBase then
	SWEP.Attachments = {
		{header = "Lasers", offset = {500, -400}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_m6x"}},
		{header = "Barrel", offset = {-500, -400}, atts = {"kk_ins2_suppressor_pistol"}},
		{header = "Magazine", offset = {-500, 150}, atts = {"kk_ins2_mag_makarov_15"}},
		--["+reload"] = {header = "Ammo", offset = {500, 150}, atts = {"am_magnum", "am_matchgrade"}}
	}
end

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = {"base_fire","base_fire2","base_fire3"},
	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_fire_last",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_mm = "base_reload_extmag",
	base_reload_empty = "base_reloadempty",
	base_reload_empty_mm = "base_reloadempty_extmag",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "empty_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_empty = "empty_down",
	base_safe_aim = "iron_down",
	base_safe_empty_aim = "empty_iron_down",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
}

SWEP.SpeedDec = 10

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "revolver"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_nam_tokarev.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_tokarev.mdl"

SWEP.WMPos = Vector(4.84, 1.608, -1.584)
SWEP.WMAng = Vector(-3, -5, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.rgd5
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2keh
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip = 0 --	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x25MM"

SWEP.FireDelay = 0.1
SWEP.FireSound = "CW_KK_INS2_NAM_TT33_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_MAKAROV_FIRE_SUPPRESSED"
SWEP.Recoil = 0.7

SWEP.HipSpread = 0.038
SWEP.AimSpread = 0.0125
SWEP.VelocitySensitivity = 1
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 23

SWEP.FirstDeployTime = 1.2
SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.4

SWEP.CanRestOnObjects = false
-- SWEP.WeaponLength = 16 // original
SWEP.WeaponLength = 14

SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 480

SWEP.ReloadTimes = {
	base_reload = {2, 2.65},
	base_reloadempty = {2, 2.65},
	base_reload_extmag = {2, 2.65},
	base_reloadempty_extmag = {2, 2.65},
}

if CLIENT then
	function SWEP:updateOtherParts()
		local active = self.ActiveAttachments

		self.AttachmentModelsVM.kk_ins2_mag_makarov_8.active = !active.kk_ins2_mag_makarov_15
	end
end
