--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_stg44/shared.lua

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
	SWEP.PrintName = "STG-44"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_stg44")

	SWEP.Shell = "KK_INS2_762x33"
	SWEP.ShellDelay = 0.06

	SWEP.AttachmentModelsVM = {
		["kk_ins2_scope_zf41"] = {model = "models/weapons/upgrades/a_optic_zf4.mdl", rLight = true, pos = Vector(0.0161, -4.2041, 5.964), angle = Angle(0, -90, 0), size = Vector(1.2, 1.2, 1.2), bone = "STG44"},

		-- ["ani_body"] = {model = "models/weapons/v_stg44.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_stg44.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_stg44.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_scope_zf41"] = {model = "models/weapons/upgrades/w_scope_g43.mdl", pos = Vector(5.218, -1.0885, 7.1822), angle = Angle(3.6414, -3.9709, 0), size = Vector(1.1, 1.1, 1.1), bone = "R Hand"},
	}

	SWEP.IronsightPos = Vector(-2.316, -2, 0.5705)
	SWEP.IronsightAng = Vector(0.2536, 0.0368, 0)

	SWEP.KKINS2ScopeZF41Pos = Vector(-2.3215, -0, -0.1577)
	SWEP.KKINS2ScopeZF41Ang = Vector(0, 0.0186, 0)

	SWEP.CustomizationMenuScale = 0.02
end

SWEP.MuzzleEffect = "muzzleflash_stg44_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_stg44_3p"

SWEP.Attachments = {
	{header = "Sight", offset = {500, -500}, atts = {"kk_ins2_scope_zf41"}},
	{header = "Stock", offset = {1000, 0}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {500, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire", "base_fire2", "base_fire3"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
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

SWEP.SpeedDec = 30

SWEP.Slot = 3
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_stg44.mdl"
SWEP.WorldModel		= "models/weapons/w_stg44.mdl"

SWEP.WMPos = Vector(11, 1, -1)
SWEP.WMAng = Vector(-6, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2de
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2de

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip = 0 --	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.92x33MM"

SWEP.FireDelay = 60/600
SWEP.FireSound = "CW_KK_INS2_DOI_STG44_FIRE"
SWEP.Recoil = 0.9975

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 45

SWEP.FirstDeployTime = 2.2
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.WeaponLength = 22

SWEP.MuzzleVelocity = 685

SWEP.ReloadTimes = {
	base_reload = {64/30, 3.3},
	base_reloadempty = {76/31.8, 5},

	base_melee_bash = {0.3, 1},
}
