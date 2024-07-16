--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1917/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "SW M1917"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_sw1917")

	SWEP.Shell = "KK_INS2_45apc"
	SWEP.NoShells = true
	SWEP.ShellScale = 1
	SWEP.ShellEjectVelocity = 50

	SWEP.AttachmentModelsVM = {
		["kk_ins2_revolver_mag"] = {model = "models/weapons/upgrades/a_clips_sw1917.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_ww2_stripper"] = {model = "models/weapons/upgrades/a_clips_sw1917.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_sw1917.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.7774, 0, 1.3158)
	SWEP.IronsightAng = Vector(-1.6686, 0.0659, 6)

	SWEP.CustomizationMenuScale = 0.01

	SWEP.SprintAnimSpeed = 1.1
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true
	SWEP.HUD_MagText = "CYLINDER: "
end

SWEP.MuzzleEffect = "muzzleflash_1911_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_sten_3p"

SWEP.Attachments = {
	{header = "Reload Aid", offset = {500, 0}, atts = {/*"kk_ins2_revolver_mag", */"kk_ins2_ww2_stripper"}},
	--["+reload"] = {header = "Ammo", offset = {-300, 200}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_reload_start = "base_reload_start",
	base_reload_start_empty = "base_reload_start_empty",
	base_insert = "base_reload_insert",
	base_reload_end = "base_reload_end",
	base_reload_end_empty = "base_reload_end",
	base_idle = "base_reload_end",

	base_reload = "base_reload_clip",
	base_reload_empty = "base_reload_clip_empty",

	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = {"base_fire", "base_fire2"},
	base_fire_aim = "iron_fire_1",
	base_fire_last = "base_fire_last",
	base_fire_last_aim = "iron_fire_last",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_idle = "iron_idle",
	base_idle_empty = "iron_idle_empty",
	base_holster = "base_holster",
	base_holster_empty = "base_holster_empty",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint_empty",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "base_down_empty",
	base_safe_empty_aim = "iron_down_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash_empty",
}

SWEP.SpeedDec = 10

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "pistol"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_sw1917.mdl"
SWEP.WorldModel		= "models/weapons/w_sw1917.mdl"

SWEP.WMPos = Vector(5.5, 1.623, -3.5)
SWEP.WMAng = Vector(-3, -5, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip = 0 --	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".45 ACP"

SWEP.FireDelay = 1
SWEP.FireSound = "CW_KK_INS2_DOI_WEBLEY_FIRE"
SWEP.Recoil = 2.86

SWEP.HipSpread = 0.039
SWEP.AimSpread = 0.0085
SWEP.VelocitySensitivity = 1.35
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.02
SWEP.SpreadCooldown = 0.25
SWEP.Shots = 1
SWEP.Damage = 30

SWEP.FirstDeployTime = 0.5
SWEP.DeployTime = 0.5
SWEP.HolsterTime = 0.5

SWEP.CanRestOnObjects = false
SWEP.Chamberable = false
SWEP.WeaponLength = 16
SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 190

SWEP.ReloadTimes = {
	base_reload_start = {1.5, 2.2, KK_INS2_REVOLVER_SLOW_UNLOAD},
	base_reload_start_empty = {2.2, 2.9, KK_INS2_REVOLVER_SLOW_UNLOAD},
	base_reload_insert = {0.4, 0.95},
	base_reload_end = {2, 2},

	base_reload_clip = {93/32, 5.4, KK_INS2_REVOLVER_SPEED_UNLOAD, 1.7, 121/32},
	base_reload_clip_empty = {93/32, 6, KK_INS2_REVOLVER_SPEED_UNLOAD, 1.7, 121/32},

	base_melee_bash = {0.3, 0.8},
	base_melee_bash_empty = {0.3, 0.8},
}

function SWEP:IndividualInitialize()
	self.magType = "NONE"
	self.ShotgunReload = true

	if CLIENT then
		self:setBodygroup(1, self:Clip1())
		self:setBodygroup(2, self:Clip1())
	end
end

SWEP.stripperCapacity = 3

function SWEP:canDoStripperClipReload(ammo, mag)
	return self:stripperClipsEnabled()
		and ammo >= self.stripperCapacity * 2
end

function SWEP:getStripperClipAnimation(ammo, mag)
	if mag < 1 then
		return "reload_empty"
	end

	return "reload"
end
