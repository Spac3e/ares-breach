--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_tankshrek/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "RPzB 54"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_panzerschreck")

	SWEP.RearEffectw = true
	SWEP.NoShells = true

	SWEP.AttachmentModelsVM = {
		-- ["ani_body"] = {model = "models/weapons/v_panzerschreck.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/v_panzerschreck.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true,
			materials = {
				[1] = CustomizableWeaponry_KK.ins2.nodrawMatPath,
				[2] = CustomizableWeaponry_KK.ins2.nodrawMatPath,
			}
		},

		["kk_ins2_fnfal_skin2"] = {model = "models/weapons/cw_kk_doi/v_panzerschreck.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, materials = {[1] = "models/cwkkdoi/shrek/clean.mdl"}},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_fnfal_skin2"] = {model = "models/weapons/w_panzerschreck.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, material = "models/cwkkdoi/shrek/clean_w.mdl"},
	}

	-- SWEP.IronsightPos = Vector(-2.3552, 0, 0.7429)
	-- SWEP.IronsightAng = Vector(8.4654, -5.1917, 20)

	SWEP.IronsightPos = Vector(0.0121, 0, 0)
	SWEP.IronsightAng = Vector(0, 0.0527, 0)

	SWEP.SprintAnimSpeed = 1
	SWEP.ViewModelMovementScale_sprint = 0.6
	SWEP.DisableSprintViewSimulation = true

	SWEP.CustomizationMenuScale = 0.02
	SWEP.HUD_MagText = "TUBE: "
end

SWEP.MuzzleEffect = "ins_weapon_rpg_frontblast"
SWEP.MuzzleEffectWorld = "ins_weapon_rpg_frontblast"

SWEP.Chamberable = false
SWEP.WeaponLength = 44

SWEP.Attachments = {
	{header = "Flavor", offset = {500, -200}, atts = {"kk_ins2_fnfal_skin2"}},
	{header = "Stock", offset = {500, 200}, atts = {"kk_ins2_ww2_sling"}},
}

SWEP.Animations = {
	base_insert = "base_reload",

	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = "iron_fire_preblend",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire_preblend",
	base_reload = "base_reload",
	base_reload_empty = "base_reload",
	base_idle = "base_idle",
	base_idle_aim = "iron_idle_preblend",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down_preblend",
	base_crawl = "base_crawl",
	base_melee = "base_melee",
}

SWEP.SpeedDec = 15

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "rpg"
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_panzerschreck.mdl"
SWEP.WorldModel		= "models/weapons/w_panzerschreck.mdl"

SWEP.WMPos = Vector(10, 1, -8)
SWEP.WMAng = Vector(8, 180, 8)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2de
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2de

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip = 0 --	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "88MM Rocket"

SWEP.FireDelay = 0.5
SWEP.FireSound = "CW_KK_INS2_DOI_TANKSHREK_FIRE"
SWEP.Recoil = 0.5

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.9
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.8
SWEP.Shots = 1
SWEP.Damage = 100

SWEP.MuzzleVelocity = 110
SWEP.projectileClass = "cw_kk_ins2_projectile_shrek"
SWEP.hipBulletDelay = 0.4

SWEP.FirstDeployTime = 3.45
SWEP.DeployTime = 1
SWEP.HolsterTime = 1

SWEP.ironFireAnimStartCycle = 0.28

SWEP.ReloadTimes = {
	base_reload = {4.4, 6.43},

	base_melee = {0.3, 1.5},
}
