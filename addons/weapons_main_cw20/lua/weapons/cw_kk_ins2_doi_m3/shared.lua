--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m3/shared.lua

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
	SWEP.PrintName = "M3 Grease Gun"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_m3greasegun")

	SWEP.Shell = "KK_INS2_45apc"
	SWEP.ShellDelay = 0.13

	SWEP.AttachmentModelsVM = {
		["kk_ins2_hoovy"] = {model = "models/weapons/upgrades/a_flash_hider_m3.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), merge = true},

		["paypay2"] = {model = "models/weapons/upgrades/a_stock_extended_m3.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), merge = true, active = true},
		-- ["paypay"] = {model = "models/weapons/upgrades/a_stock_collapsed_m3.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_m3greasegun.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_m3.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_m3.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.5062, -2, 1.2973)
	SWEP.IronsightAng = Vector(-0.0021, 0.0392, 6)

end

SWEP.MuzzleEffect = "muzzleflash_sten_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_sten_3p"

SWEP.Attachments = {
	{header = "Barrel", offset = {-400, -100}, atts = {"kk_ins2_hoovy"}},
	{header = "Stock", offset = {600, -100}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {-300, 400}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = {"base_fire", "base_fire_2", "base_fire_3"},
	base_fire_aim = {"iron_fire", "iron_fire_a", "iron_fire_b"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "empty_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "empty_down",
	base_safe_empty_aim = "iron_empty_down",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
	base_melee = "base_melee_bash",
	base_melee_empty = "empty_melee_bash",
}

SWEP.SpeedDec = 15

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "smg"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_m3greasegun.mdl"
SWEP.WorldModel		= "models/weapons/w_m3greasegun.mdl"

SWEP.WMPos = Vector(11, 1.5, -4)
SWEP.WMAng = Vector(-10, -4, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip = 0 --	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".45 ACP"

SWEP.FireDelay = 60/450
SWEP.FireSound = "CW_KK_INS2_DOI_GREASE_FIRE"
SWEP.Recoil = 0.7

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.7
SWEP.MaxSpreadInc = 0.035
SWEP.SpreadPerShot = 0.006
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 35

SWEP.FirstDeployTime = 2.5
SWEP.DeployTime = 0.8
SWEP.HolsterTime = 0.7

SWEP.Chamberable = false
SWEP.KK_INS2_EmptyIdle = true

SWEP.SightBGs = {main = 0, foldsight = 0}

SWEP.WeaponLength = 16

SWEP.MuzzleVelocity = 280

SWEP.ReloadTimes = {
	base_reload = {2.4, 3.35},
	base_reloadempty = {2.4, 4.75},

	base_melee_bash = {0.3, 0.9},
	empty_melee_bash = {0.3, 0.9},
}

-- if CLIENT then
	-- function SWEP:updateStandardParts()
		-- self:setElementActive("paypay2", !self.ActiveAttachments.kk_ins2_ww2_sling)
	-- end
-- end
