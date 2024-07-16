--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_welrod/shared.lua

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
	SWEP.PrintName = "Welrod Mk2"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_welrod")

	SWEP.NoShells = true
	SWEP.Shell = "KK_INS2_9x19"
	-- SWEP.ShellDelay = 0.9

	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 180}
	SWEP.ShellWorldAngleAlign = {Forward = 90, Right = 0, Up = 0}

	SWEP.AttachmentModelsVM = {
		-- ["ani_body"] = {model = "models/weapons/v_welrod.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},

		-- ["kk_ins2_fnfal_skin2"] = {model = "models/weapons/v_welrod.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, material = "models/weapons/welrod/dosh.mdl"},
	}

	SWEP.AttachmentModelsWM = {
		-- ["kk_ins2_fnfal_skin2"] = {model = "models/weapons/w_welrod.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, material = "models/weapons/welrod/dosh.mdl"},
	}

	SWEP.IronsightPos = Vector(-2.2947, 0, 0.8344)
	SWEP.IronsightAng = Vector(-0.0609, 0, 0)

	SWEP.CustomizationMenuScale = 0.013
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true
end

SWEP.MuzzleEffect = "muzzleflash_suppressed_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_suppressed_1p"

SWEP.Attachments = {
	{header = "Inside", offset = {600, 0}, atts = {"kk_ins2_ww2_bolt"}},
	-- {header = "Flavor", offset = {-200, -250}, atts = {"kk_ins2_fnfal_skin2"}},
	--["+reload"] = {header = "Ammo", offset = {-200, 200}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire_1","base_fire_2","base_fire_3","base_firelast"},
	base_fire_aim = {"iron_fire","iron_firelast"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_bolt = "base_fire_end",
	base_bolt_aim = "iron_fire_end",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
	base_melee = "base_melee_bash",
}

SWEP.SpeedDec = 10

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "revolver"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"bolt"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_welrod.mdl"
SWEP.WorldModel		= "models/weapons/w_welrod.mdl"

SWEP.WMPos = Vector(5, 1.623, -4)
SWEP.WMAng = Vector(-8, -5, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip = 0 --	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".32 ACP"

-- SWEP.KK_INS2_BoltAction = 0.1
SWEP.KK_INS2_EmptyIdle = false
SWEP.CanRestOnObjects = false
SWEP.WeaponLength = 16

SWEP.SuppressedOnEquip = true
SWEP.FireSoundSuppressed = "CW_KK_INS2_DOI_WELROD_FIRE"
SWEP.Recoil = 0.6545

SWEP.HipSpread = 0.034
SWEP.AimSpread = 0.011
SWEP.VelocitySensitivity = 1.2
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.17
SWEP.Shots = 1
SWEP.Damage = 26

-- SWEP.FireDelay = 2.2
SWEP.FireDelay = 0.1
SWEP.ReticleInactivityPostFire = SWEP.FireDelay + 0.2
SWEP.GlobalDelayOnShoot = SWEP.FireDelay

SWEP.FirstDeployTime = 2.2
SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.4

SWEP.MuzzleVelocity = 300

SWEP.ReloadTimes = {
	base_fire_end = {25/30, 2.2},
	iron_fire_end = {25/30, 2.2},
	base_reload = {2.27, 3.17},
	base_reloadempty = {2.27, 4.67},

	base_melee_bash = {0.3, 0.8},
}
