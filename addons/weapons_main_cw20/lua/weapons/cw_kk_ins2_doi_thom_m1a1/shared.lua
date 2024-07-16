--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_thom_m1a1/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "smgMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1A1 Thompson"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_thompson_m1a1")

	SWEP.Shell = "KK_INS2_45apc"
	SWEP.ShellDelay = 0.08

	SWEP.AttachmentModelsVM = {
		["kk_ins2_optic_iron"] = {model = "models/weapons/upgrades/a_iron_thompson_m1a1_1.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), merge = true, active = true},
		["kk_ins2_optic_rail"] = {model = "models/weapons/upgrades/a_iron_thompson_m1a1_2.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_thompson_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_thompson_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_thompson_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		-- ["handguard"] = {model = "models/weapons/upgrades/w_thompson_standard.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		-- ["mag"] = {model = "models/weapons/upgrades/w_thompson_mag_30.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
	}

	SWEP.IronsightPos = Vector(-2.2506, -2, 1.0881)
	SWEP.IronsightAng = Vector(-0.1194, 0.019, 0)

	SWEP.FoldSightPos = Vector(-2.2506, -2, 1.0881)
	SWEP.FoldSightAng = Vector(-0.1194, 0.019, 0)

end

SWEP.MuzzleEffect = "muzzleflash_thompson_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_thompson_3p"

SWEP.Attachments = {
	{header = "Sight", offset = {450, -200}, atts = {"bg_foldsight"}},
	{header = "Stock", offset = {1000, 200}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {-200, 200}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire", "base_fire_2", "base_fire_3"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = {"base_reloadempty_1", "base_reloadempty_2"},
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_firemode = "base_fireselect",
	base_firemode_aim = "iron_fireselect",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
	base_melee = "base_melee_bash",
}

SWEP.SpeedDec = 15

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_thompson_m1a1.mdl"
SWEP.WorldModel		= "models/weapons/w_thompson_m1a1.mdl"

SWEP.WMPos = Vector(4, 0.395, -2)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip = 0 --	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".45 ACP"

SWEP.FireDelay = 60/700
SWEP.FireSound = "CW_KK_INS2_DOI_THOM_M1A1_FIRE"
SWEP.Recoil = 0.7

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.7
SWEP.MaxSpreadInc = 0.035
SWEP.SpreadPerShot = 0.006
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 33

SWEP.FirstDeployTime = 1.9
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.Chamberable = false

SWEP.SightBGs = {main = 0, foldsight = 0}

SWEP.WeaponLength = 16

SWEP.MuzzleVelocity = 285

SWEP.ReloadTimes = {
	base_reload = {2.55, 3.33},
	base_reloadempty_1 = {3.88, 4.76},
	base_reloadempty_2 = {3.88, 4.76},

	base_melee_bash = {0.3, 0.9},
}
