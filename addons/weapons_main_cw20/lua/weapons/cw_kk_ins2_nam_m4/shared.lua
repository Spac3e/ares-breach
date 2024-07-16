--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m4/shared.lua

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
	SWEP.PrintName = "M607"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_m607")

	SWEP.Shell = "KK_INS2_556x45"
	SWEP.ShellDelay = 0.06

	SWEP.AttachmentModelsVM = {
		["std_mag"] = {model = "models/weapons/upgrades/a_magazine_m607_20.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_m1a1_30"] = {model = "models/weapons/upgrades/a_magazine_m607_30.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_suppressor_ins"] = {model = "models/weapons/upgrades/a_suppressor_ins.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_foregrip_ins.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), attachment = "Foregrip"},
	}

	SWEP.AttachmentModelsWM = {
		["std_mag"] = {model = "models/weapons/upgrades/w_magazine_m607_20.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_m1a1_30"] = {model = "models/weapons/upgrades/w_magazine_m607_30.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_suppressor_ins"] = {model = "models/weapons/upgrades/w_sil_ins1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/w_ins_foregrip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	-- SWEP.IronsightPos = Vector(-2.4916, -3, 0.629)
	-- SWEP.IronsightAng = Vector(-0.223, 0.0476, 0)

	SWEP.IronsightPos = Vector(-2.1216, -5, 0.6372)
	SWEP.IronsightAng = Vector(-0.1894, 0.0392, 0)

	SWEP.CustomizationMenuScale = 0.014
end

SWEP.MuzzleEffect = "muzzleflash_m16_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_m16_3rd"

SWEP.Attachments = {
	-- {header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_suppressor_ins"}},
	-- {header = "Under", offset = {-500, 0}, atts = {"kk_ins2_vertgrip"}},
	{header = "Magazine", offset = {-50, 500}, atts = {"kk_ins2_mag_m1a1_30"}},
	----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_3", "iron_fire_4"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_reload_mm = "base_reload_ext",
	base_reload_empty_mm = "base_reloadempty_ext",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_firemode = "base_fireselect",
	base_firemode_aim = "iron_fireselect",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 30

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
SWEP.ViewModel		= "models/weapons/v_nam_m607.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_m607.mdl"

SWEP.WMPos = Vector(5.018, 0.711, -0.743)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.m26
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2kus
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip = 0 --	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45MM"

SWEP.FireDelay = 0.066666666666667
SWEP.FireSound = "CW_KK_INS2_NAM_M4_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_MK18_FIRE_SUPPRESSED"
SWEP.Recoil = 1.1025

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 39

SWEP.FirstDeployTime = 2.6
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.7

SWEP.WeaponLength = 20

SWEP.MuzzleVelocity = 808

SWEP.ReloadTimes = {
	base_reload = {84/30, 4.1},
	base_reloadempty = {84/30, 4.8},
	base_reload_ext = {84/30, 4.2},
	base_reloadempty_ext = {84/30, 4.9},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("std_mag", !self.ActiveAttachments.kk_ins2_mag_m1a1_30)
	end
end
