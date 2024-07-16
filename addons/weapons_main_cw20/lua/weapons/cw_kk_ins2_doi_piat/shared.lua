--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_piat/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "PIAT"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_piat")

	SWEP.MuzzleEffect = false
	-- SWEP.RearEffectw = true
	SWEP.NoShells = true

	SWEP.BackupSights = {
		["nil"] = {
			Vector(-3.5442, 0, 1.9215),
			Vector(-4.1281, 0.0421, -6)
		},
	}

	SWEP.AttachmentModelsVM = {
		-- ["ani_body"] = {model = "models/weapons/v_piat.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
	}

	SWEP.AttachmentModelsWM = {}

	-- SWEP.IronsightPos = Vector(-3.5949, 0, 1.4701)
	-- SWEP.IronsightAng = Vector(-2.3778, 0.006, -7)

	SWEP.IronsightPos = Vector()
	SWEP.IronsightAng = Vector()

	SWEP.SprintAnimSpeed = 1
	SWEP.ViewModelMovementScale_sprint = 0.6
	SWEP.DisableSprintViewSimulation = true

	SWEP.CustomizationMenuScale = 0.013
	SWEP.HUD_MagText = "TUBE: "
end

SWEP.Chamberable = false
SWEP.WeaponLength = 44

SWEP.Attachments = {
	-- {header = "Stock", offset = {400, -200}, atts = {"kk_ins2_ww2_sling"}},
}

SWEP.KK_INS2_EmptyIdle = true

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = "base_fire",
	base_fire_aim = "iron_fire_preblend",
	base_fire_last = "base_fire",
	base_fire_last_aim = "iron_fire_preblend",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire_preblend",
	base_reload = "base_reload",
	base_reload_empty = "base_reload",
	base_idle = "base_idle",
	base_idle_aim = "iron_idle_preblend",
	base_idle_empty = "empty_idle",
	base_idle_empty_aim = "empty_iron_idle_preblend",
	base_holster = "base_holster",
	base_holster_empty = "empty_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down_preblend",
	base_safe_empty = "empty_down",
	base_safe_empty_aim = "iron_down_empty_preblend",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
	base_melee = "base_melee",
	base_melee_empty = "empty_melee",
}

SWEP.SpeedDec = 15

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"single"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.AimViewModelFOV = 30
SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_piat.mdl"
SWEP.WorldModel		= "models/weapons/w_piat.mdl"

SWEP.WMPos = Vector(10, 1, -4.5)
SWEP.WMAng = Vector(-4, 0, -180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip = 0 --	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "PIAT Bomb"

SWEP.FireDelay = 0.5
SWEP.FireSound = "CW_KK_INS2_DOI_PIAT_FIRE"
SWEP.Recoil = 0.5

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.9
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.8
SWEP.Shots = 1
SWEP.Damage = 100

SWEP.MuzzleVelocity = 76
SWEP.projectileClass = "cw_kk_ins2_projectile_piat"
SWEP.hipBulletDelay = 0.25

SWEP.FirstDeployTime = 1.4
SWEP.DeployTime = 1.5
SWEP.HolsterTime = 1.4

SWEP.ReloadTimes = {
	base_reload = {2.7, 4.4},

	base_melee = {0.3, 1.4},
	empty_melee = {0.3, 1.4},
}
