--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_arse_suomi/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_arse_suomi/shared.lua
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
	SWEP.PrintName = "SUOMI?"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_suomi")

	SWEP.Shell = "KK_INS2_45apc"
	SWEP.ShellDelay = 0.13

	SWEP.AttachmentModelsVM = {
		["kk_ins2_mag_thom_20"] = {model = "models/weapons/suomi/a_suomi_mag.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_thom_50"] = {model = "models/weapons/suomi/a_suomi_drum.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_mag_thom_20"] = {model = "models/weapons/suomi/w_suomi_mag.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_thom_50"] = {model = "models/weapons/suomi/w_suomi_drum.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-3.0691, -2, 1.4411)
	SWEP.IronsightAng = Vector(-0.035, -0.0044, 0)

end

SWEP.MuzzleEffect = "muzzleflash_mp40_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_mp40_3rd"

SWEP.Attachments = {
	{header = "Magazine", offset = {-50, 500}, atts = {"kk_ins2_mag_thom_50"}},
	----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = "base_fire",
	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_reload_mm = "base_reload_extmag",
	base_reload_empty_mm = "base_reloadempty_extmag",
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
}

SWEP.SpeedDec = 15

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 AR"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/suomi/v_suomi.mdl"
SWEP.WorldModel		= "models/weapons/suomi/w_suomi.mdl"

SWEP.WMPos = Vector(4, 0.395, -2)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 34
SWEP.Primary.DefaultClip = 0 --	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Pistol"

SWEP.FireDelay = 60/980
SWEP.FireSound = "CW_KK_INS2_DOI_THOMPSON_FIRE"
SWEP.Recoil = 0.7

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.7
SWEP.MaxSpreadInc = 0.035
SWEP.SpreadPerShot = 0.006
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 19

SWEP.FirstDeployTime = 1.9
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.Chamberable = false
SWEP.KK_INS2_EmptyIdle = true

SWEP.SightBGs = {main = 0, foldsight = 0}

SWEP.WeaponLength = 16

SWEP.MuzzleVelocity = 285

SWEP.ReloadTimes = {
	base_reload = {2.55, 3.33},
	base_reloadempty = {3.88, 4.76},
	base_reload_extmag = {4.3, 5.48},
	base_reloadempty_extmag = {5.82, 6.92},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("kk_ins2_mag_thom_20", !(self.ActiveAttachments.kk_ins2_mag_thom_30 or self.ActiveAttachments.kk_ins2_mag_thom_50))
	end
end


