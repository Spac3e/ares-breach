--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_python/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Colt Python"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_python")

	SWEP.Shell = "KK_INS2_762x33"
	SWEP.NoShells = true
	SWEP.ShellScale = 2

	SWEP.AttachmentModelsVM = {
		["std_barrel"] = {model = "models/weapons/upgrades/a_python_short.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["bg_regularbarrel"] = {model = "models/weapons/upgrades/a_python_standard.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["bg_longbarrelmr96"] = {model = "models/weapons/upgrades/a_python_long.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_revolver_mag"] = {model = "models/weapons/upgrades/a_speedloader_python.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["std_barrel"] = {model = "models/weapons/upgrades/w_python_short.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["bg_regularbarrel"] = {model = "models/weapons/upgrades/w_python_standard.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["bg_longbarrelmr96"] = {model = "models/weapons/upgrades/w_python_long.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-1.1145, 0, 0.4052)
	SWEP.IronsightAng = Vector(-0.0044, -0.0618, 0)

	SWEP.CustomizationMenuScale = 0.01

	SWEP.SprintAnimSpeed = 1.1
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true
	SWEP.HUD_MagText = "CYLINDER: "
end

SWEP.MuzzleEffect = "muzzleflash_m9_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_m9_3rd"

SWEP.BarrelBGs = {main = 0, regular = 0, long = 0, short = 0}

SWEP.Attachments = {
	{header = "Barrel", offset = {-400, -400}, atts = {"bg_regularbarrel", "bg_longbarrelmr96"}},
	{header = "Reload Aid", offset = {500, -400}, atts = {"kk_ins2_revolver_mag"}},
	--["+reload"] = {header = "Ammo", offset = {500, 150}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_reload_start = {"base_reload_start", "base_reload_start2", "base_reload_start3", "base_reload_start4"},
	base_reload_start_empty = {"base_reload_start", "base_reload_start2", "base_reload_start3", "base_reload_start4"},
	base_insert = "base_reload_insert",
	base_reload_end = "base_reload_end",
	base_reload_end_empty = "base_reload_end",

	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire","base_fire2"},
	base_fire_aim = {"iron_fire", "iron_fire2", "iron_fire3"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = {"base_reload_speed", "base_reload_speed2", "base_reload_speed3", "base_reload_speed4"},
	base_reload_empty = {"base_reload_speed", "base_reload_speed2", "base_reload_speed3", "base_reload_speed4"},
	base_idle = "base_idle",
	base_idle_aim = "base_idle",
	base_holster = "base_holster",
	base_sprint = {"base_sprint", "base_sprint2", "base_sprint3"},
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 10

SWEP.Slot = 1
SWEP.SlotPos = 1
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
SWEP.ViewModel		= "models/weapons/v_pythonrev.mdl"
SWEP.WorldModel		= "models/weapons/w_pythonrev.mdl"

SWEP.WMPos = Vector(5.309, 1.623, -1.616)
SWEP.WMAng = Vector(-3, -5, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.m26
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2kus
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip = 0 --	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".357 Magnum"

SWEP.FireDelay = 60/380
SWEP.FireSound = "CW_KK_INS2_NAM_PYTHON_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_REVOLVER_FIRE_SUPPRESSED"
SWEP.Recoil = 2.6

SWEP.HipSpread = 0.039
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.35
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.02
SWEP.SpreadCooldown = 0.25
SWEP.Shots = 1
SWEP.Damage = 38

SWEP.FirstDeployTime = 2.5
SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.5

SWEP.CanRestOnObjects = false
SWEP.Chamberable = false
SWEP.WeaponLength = 16

SWEP.MuzzleVelocity = 470

SWEP.ReloadTimes = {
	base_reload_start = {1.75, 2.45, KK_INS2_REVOLVER_SLOW_UNLOAD},
	base_reload_start2 = {1.75, 2.45, KK_INS2_REVOLVER_SLOW_UNLOAD},
	base_reload_start3 = {1.75, 2.45, KK_INS2_REVOLVER_SLOW_UNLOAD},
	base_reload_start4 = {1.75, 2.45, KK_INS2_REVOLVER_SLOW_UNLOAD},
	base_reload_insert = {0.2, 1.25},
	base_reload_end = {1.39, 1.39},

	base_reload_speed = {3, 4.39, KK_INS2_REVOLVER_SPEED_UNLOAD, 1.75},
	base_reload_speed2 = {3, 4.39, KK_INS2_REVOLVER_SPEED_UNLOAD, 1.75},
	base_reload_speed3 = {3, 4.39, KK_INS2_REVOLVER_SPEED_UNLOAD, 1.75},
	base_reload_speed4 = {3, 4.39, KK_INS2_REVOLVER_SPEED_UNLOAD, 1.75},
}

function SWEP:IndividualInitialize()
	self.magType = "NONE"
	self.ShotgunReload = true

	if CLIENT then
		self:setBodygroup(1, self:Clip1())
		self:setBodygroup(2, self:Clip1())
	end
end

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("std_barrel", self:getActiveAttachmentInCategory(1) == nil)
	end
end
