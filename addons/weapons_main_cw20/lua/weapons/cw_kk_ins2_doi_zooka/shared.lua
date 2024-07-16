--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_zooka/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1A1 'zooka"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_bazooka")

	SWEP.RearEffectw = true
	SWEP.NoShells = true

	SWEP.BackupSights = {
		["nil"] = {
			Vector(-1.4887, 0, -1.3139),
			Vector(7.5622, -0.9048, 13.5897)
		},
	}

	SWEP.AttachmentModelsVM = {
		["ani_body"] = {model = "models/weapons/v_bazooka.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},

		["h347"] = {model = "models/weapons/upgrades/a_warhead_bazooka_1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_ammo_m10"] = {model = "models/weapons/upgrades/a_warhead_bazooka_2.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {}

	-- SWEP.IronsightPos = Vector(-1.7264, 0, -0.281)
	-- SWEP.IronsightAng = Vector(7.5622, -0.9048, 13.5897)

	SWEP.IronsightPos = Vector()
	SWEP.IronsightAng = Vector()

	-- SWEP.ActualSightPos = Vector(-1.7264, 0, -0.281)
	-- SWEP.ActualSightAng = Vector(7.5622, -0.9048, 13.5897)

	-- SWEP.SightBackUpPos = Vector(-1.4887, 0, -1.3139)
	-- SWEP.SightBackUpAng = Vector(7.5622, -0.9048, 13.5897)

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
	{header = "Ammo", offset = {600, -200}, atts = {"kk_ins2_ammo_m10"}},
	-- {header = "Stock", offset = {600, 200}, atts = {"kk_ins2_ww2_sling"}},
}

SWEP.KK_INS2_EmptyIdle = true

SWEP.Animations = {
	base_insert = "base_reload",

	base_pickup = "base_ready",
	base_pickup_mm = "base_ready_phosphorus",
	base_draw = "base_draw",
	base_draw_empty = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = "iron_fire_preblend",
	base_fire_last = "base_fire",
	base_fire_last_aim = "iron_fire_preblend",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire_preblend",
	base_reload = "base_reload",
	base_reload_empty = "base_reload",
	base_reload_empty_mm = "base_reload_phosphorus",
	base_idle = "base_idle",
	base_idle_aim = "iron_idle_preblend",
	base_idle_empty = "base_idle",
	base_idle_empty_aim = "iron_idle_preblend",
	base_holster = "base_holster",
	base_holster_empty = "base_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down_preblend",
	base_safe_empty = "base_down",
	base_safe_empty_aim = "iron_down_preblend",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl",
	base_melee = "base_melee",
	base_melee_empty = "base_melee",
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_bazooka.mdl"
SWEP.WorldModel		= "models/weapons/w_bazooka.mdl"

SWEP.WMPos = Vector(-5, 0, -0.5)
SWEP.WMAng = Vector(8, 180, -180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip = 0 --	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "M6A1 Rocket"

SWEP.FireDelay = 0.5
SWEP.FireSound = "CW_KK_INS2_DOI_ZOOKA_FIRE"
SWEP.Recoil = 1

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.9
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.8
SWEP.Shots = 1
SWEP.Damage = 100

SWEP.MuzzleVelocity = 80
SWEP.projectileClass = "cw_kk_ins2_projectile_m6a1"
SWEP.hipBulletDelay = 0.3

SWEP.FirstDeployTime = 6.9 // so long
SWEP.DeployTime = 1
SWEP.HolsterTime = 1

SWEP.ironFireAnimStartCycle = 0.28

SWEP.ReloadTimes = {
	base_ready = {4.7, 6.87},
	base_ready_phosphorus = {4.7, 6.87},
	base_reload = {4.4, 6.43},
	base_reload_phosphorus = {4.4, 6.43},

	base_melee = {0.3, 1.4},
}

SWEP.reloadProgressAnimsRaw = {
	base_pickup = true,
	base_pickup_mm = true
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("h347", !self.ActiveAttachments.kk_ins2_ammo_m10)
	end
end
