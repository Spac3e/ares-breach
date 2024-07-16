--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_ithaca/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Ithaca M37"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_ithaca")

	SWEP.NoShells = true
	SWEP.Shell = "KK_INS2_12guage"
	-- SWEP.ShellDelay = 13/30

	SWEP.ShellViewAngleAlign = {Forward = 90, Right = 0, Up = 0}

	SWEP.AttachmentModelsVM = {
		["knife_fold"] = {model = "models/weapons/upgrades/a_iron_ithaca.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/a_ithaca_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_ithaca.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_ithaca.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_ithaca.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_zf41"] = {model = "models/weapons/upgrades/a_optic_kk_zf41.mdl", rLight = true, pos = Vector(-0.0104, -5.7704, 0.655), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), bone = "Weapon"},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/w_ithaca_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-2.0952, -2.5, 1.2975)
	SWEP.IronsightAng = Vector(0.2605, -0.0341, 0)

	SWEP.KKINS2ScopeZF41Pos = Vector(-2.028, 4, 0.8911)
	SWEP.KKINS2ScopeZF41Ang = Vector(0, 0.0208, 0)

	SWEP.CustomizationMenuScale = 0.019
end

SWEP.MuzzleEffect = "muzzleflash_ithica_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_ithica_3p"

SWEP.Attachments = {
	-- {header = "Sight", offset = {500, -500}, atts = {"kk_ins2_scope_zf41"}},
	{header = "Stock", offset = {800, -200}, atts = {"kk_ins2_ww2_sling"}},
	{header = "Barrel", offset = {-200, -200}, atts = {"kk_ins2_ww2_knife"}},
	{header = "Inside", offset = {-200, 300}, atts = {"kk_ins2_ww2_bolt"}},
	--["+reload"] = {header = "Ammo", offset = {800, 300}, atts = {"am_slugrounds", "am_flechetterounds"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire_1", "base_fire_2", "base_firelast"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_last"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_bolt = {"base_fire_cock_1", "base_fire_cock_2"},
	base_bolt_aim = {"iron_fire_cock_1", "iron_fire_cock_2"},
	base_reload_start = "base_reload_start",
	base_reload_start_empty = "base_reload_start_empty",
	base_insert = "base_reload_insert",
	base_reload_end = "base_reload_end",
	base_reload_end_empty = "base_reload_end_empty",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_sprint_knife = "base_sprint_melee",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
	base_melee = "base_melee_bash",
	base_stab = "base_melee_end",
}

SWEP.SpeedDec = 15

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"pump"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_ithaca.mdl"
SWEP.WorldModel		= "models/weapons/w_ithaca.mdl"

SWEP.WMPos = Vector(12, 0.5, -2.8)
SWEP.WMAng = Vector(-15, 3, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip = 0 --	= 9
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12 Gauge"

SWEP.FireDelay = 0.3
SWEP.FireSound = "CW_KK_INS2_DOI_ITHC_FIRE"
SWEP.Recoil = 2

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.4
SWEP.MaxSpreadInc = 0.02
SWEP.ClumpSpread = 0.02
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.85
SWEP.Shots = 12
SWEP.Damage = 11

SWEP.FirstDeployTime = 2.2
SWEP.DeployTime = 0.8
SWEP.HolsterTime = 0.6

SWEP.Chamberable = true
SWEP.SnapToIdlePostReload = false
SWEP.ShotgunReload = true
SWEP.ReticleInactivityPostFire = SWEP.FireDelay + 0.2
SWEP.GlobalDelayOnShoot = SWEP.FireDelay

SWEP.WeaponLength = 18

SWEP.MuzzleVelocity = 381

SWEP.ReloadTimes = {
	base_fire_cock_1 = {7/35, 0.7},
	base_fire_cock_2 = {7/35, 0.7},
	iron_fire_cock_1 = {7/35, 0.7},
	iron_fire_cock_2 = {7/35, 0.7},

	base_reload_start = {0.6, 0.6},
	base_reload_start_empty = {1.9, 2.59, KK_INS2_SHOTGUN_LOAD_FIRST},
	base_reload_insert = {15/42, 0.88},
	base_reload_end = {0.66, 0.66},
	base_reload_end_empty = {0.66, 0.66},

	base_melee_bash = {0.3, 1},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("knife_fold", !self.ActiveAttachments.kk_ins2_ww2_knife)
	end
end
