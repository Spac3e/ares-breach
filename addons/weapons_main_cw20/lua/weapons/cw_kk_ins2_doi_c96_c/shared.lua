--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_c96_c/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_soundscript.lua")
include("sh_soundscript.lua")

SWEP.magType = "pistolMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M712 Carbine"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_c96carbine")

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.06
	SWEP.ShellWorldAngleAlign = {Forward = 90, Right = 0, Up = 0}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_c96_barrel_std"] = {model = "models/weapons/upgrades/a_barrel_c96_short.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_c96_barrel_lng"] = {model = "models/weapons/upgrades/a_barrel_c96_long.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_mag_c96_20"] = {model = "models/weapons/upgrades/a_magazine_c96_20.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_c96_40"] = {model = "models/weapons/upgrades/a_magazine_c96_40.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},

		["ani_body"] = {model = "models/weapons/v_c96_carbine.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_c96.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_c96.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_mag_c96_20"] = {model = "models/weapons/upgrades/w_c96carbine_mag_20.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_c96_40"] = {model = "models/weapons/upgrades/w_c96carbine_mag_40.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},
	}

	// long B
	SWEP.LongBarrelPos = Vector(-2.3262, -2, 1.1502)
	SWEP.LongBarrelAng = Vector(0.2202, 0.0439, 0)

	SWEP.IronsightPos = Vector(-2.3259, -2, 1.0722)
	SWEP.IronsightAng = Vector(0.9476, 0.0439, 0)

	SWEP.CustomizationMenuScale = 0.011
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true
end

SWEP.MuzzleEffect = "muzzleflash_mp40_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_mp40_3p"

SWEP.Attachments = {
	{header = "Barrel", offset = {-400, -300}, atts = {"kk_ins2_c96_barrel_lng"}},
	{header = "Magazine", offset = {-400, 200}, atts = {"kk_ins2_mag_c96_40"}},
	{header = "Stock", offset = {500, -300}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {500, 200}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = {"base_fire_1", "base_fire_2", "base_fire_3"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_reload_mm = "base_reload_ext",
	base_reload_empty_mm = "base_reloadempty_ext",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "base_holster_empty",
	base_firemode = "base_fireselect",
	base_firemode_empty = "base_fireselect_empty",
	base_firemode_aim = "iron_fireselect",
	base_firemode_empty_aim = "iron_fireselect_empty",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint_empty",
	base_safe = "base_down",
	base_safe_empty = "base_down_empty",
	base_safe_aim = "iron_down",
	base_safe_empty_aim = "iron_down_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash_empty",
}

SWEP.SpeedDec = 10

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
-- SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_c96_carbine.mdl"
SWEP.ViewModel		= "models/weapons/cw_kk_doi_c054/v_c96_carbine.mdl"
SWEP.WorldModel		= "models/weapons/w_c96_carbine.mdl"

SWEP.WMPos = Vector(5, 1, -1)
SWEP.WMAng = Vector(-8, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2de
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2de

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip = 0 --	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x19MM"

SWEP.FireDelay = 60/1000
SWEP.FireSound = "CW_KK_INS2_DOI_C96_FIRE"
SWEP.Recoil = 0.77

SWEP.HipSpread = 0.034
SWEP.AimSpread = 0.012
SWEP.VelocitySensitivity = 1.2
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.22
SWEP.Shots = 1
SWEP.Damage = 24

SWEP.FirstDeployTime = 0.8
SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.4

SWEP.CanRestOnObjects = false
SWEP.WeaponLength = 16

SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 244

SWEP.ReloadTimes = {
	base_reload = {2.5, 3.14},
	base_reloadempty = {2.5, 4.53},
	base_reload_ext = {2.5, 3.14},
	base_reloadempty_ext = {2.5, 4.53},

	base_melee_bash = {0.3, 0.8},
	base_melee_bash_empty = {0.3, 0.8},
}

if CLIENT then
	function SWEP:updateStandardParts()
		-- self.AttachmentModelsVM.slingpin.ent:SetBodygroup(1,self.ActiveAttachments.kk_ins2_ww2_sling and 1 or 0)

		self:setElementActive("kk_ins2_c96_barrel_std", !self.ActiveAttachments.kk_ins2_c96_barrel_lng)
		self:setElementActive("kk_ins2_mag_c96_20", !self.ActiveAttachments.kk_ins2_mag_c96_40)
	end
end
