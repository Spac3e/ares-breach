--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_sten_mk2/shared.lua

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
	SWEP.PrintName = "Sten Mk2"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_sten_mk2")

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.1

	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 0}
	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {
		-- ["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_sten_foregrip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		-- ["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_sten_foregrip.mdl", bone = "Weapon", pos = Vector(2.4687, -2.8842, -11.6320), angle = Angle(90, -90, 0), size = Vector(1, 1, 1)},

		-- ["std_barrel"] = {model = "models/weapons/upgrades/a_stenmk2_barrel_standard.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body", active = true},
		["std_barrel"] = {model = "models/weapons/upgrades/a_stenmk2_barrel_standard.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_suppressor_sterling"] = {model = "models/weapons/upgrades/a_stenmk2_silencer.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["std_stock"] = {model = "models/weapons/upgrades/a_stenmk2_stock_standard.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["bg_ar15sturdystock"] = {model = "models/weapons/upgrades/a_stenmk2_stock_alt.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_sten_mk2.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_stenmk2.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_stenmk2.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		-- ["kk_ins2_vertgrip"] = {model = "models/weapons/attachments/w_cw_kk_ins2_cstm_eotechxps.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["std_barrel"] = {model = "models/weapons/upgrades/w_barrel_standard_mk2.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_suppressor_sterling"] = {model = "models/weapons/upgrades/w_silencer_sten.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	-- SWEP.IronsightPos = Vector(-2.3491, 0, 1.7527)
	-- SWEP.IronsightAng = Vector(-0.4149, 0, 0)

	SWEP.IronsightPos = Vector(-2.6229, 0, 2.0622)
	SWEP.IronsightAng = Vector(-0.5089, -0.0389, 8)

	SWEP.CustomizationMenuScale = 0.014
end

SWEP.MuzzleEffect = "muzzleflash_sten_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_sten_3p"

SWEP.StockBGs = {main = 0, regular = 0, heavy = 0, sturdy = 0}

SWEP.Attachments = {
	{header = "Barrel", offset = {-300, -600}, atts = {"kk_ins2_suppressor_sterling"}},
	{header = "Under", offset = {-500, -150}, atts = {"kk_ins2_ww2_sling"}},
	-- {header = "Stock", offset = {1000, 0}, atts = {"bg_ar15sturdystock"}},
	--["+reload"] = {header = "Ammo", offset = {0, 400}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = {"base_fire_1","base_fire_2"},
	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
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

	-- foregrip_pickup = "foregrip_draw",
	-- foregrip_draw = "foregrip_draw",
	-- foregrip_draw_empty = "foregrip_draw_empty",
	-- foregrip_fire = {"foregrip_fire_1","foregrip_fire_2"},
	-- foregrip_fire_aim = {"foregrip_iron_fire_1","foregrip_iron_fire_2","foregrip_iron_fire_3"},
	-- foregrip_fire_last = "foregrip_firelast",
	-- foregrip_fire_last_aim = "foregrip_iron_firelast",
	-- foregrip_fire_empty = "foregrip_dryfire",
	-- foregrip_fire_empty_aim = "foregrip_iron_dryfire",
	-- foregrip_reload = "foregrip_reload",
	-- foregrip_reload_empty = "foregrip_reloadempty",
	-- foregrip_idle = "foregrip_iron_idle",
	-- foregrip_idle_empty = "foregrip_iron_idle_empty",
	-- foregrip_holster = "foregrip_holster",
	-- foregrip_holster_empty = "foregrip_holster_empty",
	-- foregrip_sprint = "foregrip_sprint",
	-- foregrip_sprint_empty = "foregrip_sprint_empty",
	-- foregrip_safe = "foregrip_down",
	-- foregrip_safe_aim = "foregrip_iron_down",
	-- foregrip_safe_empty = "foregrip_down_empty",
	-- foregrip_safe_empty_aim = "foregrip_iron_down_empty",
	-- foregrip_crawl = "foregrip_crawl",
	-- foregrip_crawl_empty = "foregrip_crawl_empty",
}

SWEP.SpeedDec = 15

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
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
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_sten_mk2.mdl"
SWEP.WorldModel		= "models/weapons/w_sten.mdl"

SWEP.WMPos = Vector(9, -1, -4)
SWEP.WMAng = Vector(-10, 0, 90)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 32
SWEP.Primary.DefaultClip = 0 --	= 32
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x19MM"

SWEP.FireDelay = 60/550
SWEP.FireSound = "CW_KK_INS2_DOI_STEN_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_DOI_STEN_FIRE_SUPPRESSED"
SWEP.Recoil = 0.77

SWEP.HipSpread = 0.035
SWEP.AimSpread = 0.009
SWEP.VelocitySensitivity = 1.5
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 25

SWEP.FirstDeployTime = 0.8
SWEP.DeployTime = 0.8
SWEP.HolsterTime = 0.8

SWEP.WeaponLength = 16

SWEP.Chamberable = false
SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 365

SWEP.ReloadTimes = {
	base_reload = {80/33, 3.75},
	base_reloadempty = {80/33, 4.75},

	base_melee_bash = {0.3, 0.9},
	base_melee_bash_empty = {0.3, 0.9},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("std_barrel", !self.ActiveAttachments.kk_ins2_suppressor_sterling)
		self:setElementActive("std_stock", !self.ActiveAttachments.bg_ar15sturdystock)
	end
end
