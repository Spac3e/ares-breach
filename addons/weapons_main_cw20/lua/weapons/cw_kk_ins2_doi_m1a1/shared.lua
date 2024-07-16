--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1a1/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "arMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1A1 Carbine"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/cosmetic_m1carbine_para")

	SWEP.Shell = "KK_INS2_762x33"
	SWEP.ShellDelay = 0.06

	SWEP.AttachmentModelsVM = {
		["kk_ins2_optic_iron"] = {model = "models/cwkkdoi/upgrades/a_iron_m1a1_s.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_optic_rail"] = {model = "models/cwkkdoi/upgrades/a_iron_m1a1_l.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_mag_m1a1_15"] = {model = "models/cwkkdoi/upgrades/a_magazine_m1a1_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_m1a1_30"] = {model = "models/cwkkdoi/upgrades/a_magazine_m1a1_30.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_ww2_knife"] = {model = "models/cwkkdoi/upgrades/a_m1a1_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_m1a1para.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_m1a1para.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/cwkkdoi/upgrades/a_sling_m1a1para.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_optic_iron"] = {model = "models/cwkkdoi/upgrades/w_iron_m1a1_s.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_optic_rail"] = {model = "models/cwkkdoi/upgrades/w_iron_m1a1_l.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_mag_m1a1_15"] = {model = "models/cwkkdoi/upgrades/w_magazine_m1a1_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_m1a1_30"] = {model = "models/cwkkdoi/upgrades/w_magazine_m1a1_30.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_ww2_knife"] = {model = "models/cwkkdoi/upgrades/w_bayonet_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	-- SWEP.ForegripOverridePos = {
		-- none = {
			-- ["FoldingStock"] = {pos = Vector(), angle = Angle()},
		-- },

		-- stoq = {
			-- ["FoldingStock"] = {pos = Vector(), angle = Angle(0, 180, 0)},
		-- }
	-- }

	-- SWEP.ForegripParent = "stoq"
	-- SWEP.ForegripOverride = true

	SWEP.IronsightPos = Vector(-2.4773, -3, 1.2686)
	SWEP.IronsightAng = Vector(0, 0.0355, 0)

	SWEP.FoldSightPos = Vector(-2.4768, -3, 1.1628)
	SWEP.FoldSightAng = Vector(0.2625, 0.0213, 0)

	SWEP.CustomizationMenuScale = 0.016
end

SWEP.MuzzleEffect = "muzzleflash_m1carbine_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_sten_3p"

SWEP.Attachments = {
	{header = "Sight", offset = {400, -500}, atts = {"bg_foldsight"}},
	{header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_ww2_knife"}},
	{header = "Magazine", offset = {-200, 600}, atts = {"kk_ins2_mag_m1a1_30"}},
	{header = "Stock", offset = {1000, 0}, atts = {"kk_ins2_ww2_sling"}},
	----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_mm = "base_reload_ext",
	base_reload_empty = "base_reloadempty",
	base_reload_empty_mm = "base_reloadempty_ext",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_sprint_knife = "base_sprint_melee",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
	base_melee = "base_melee_bash",
	base_stab = "base_melee_end",

}

SWEP.SpeedDec = 40

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_m1a1para.mdl"
SWEP.WorldModel		= "models/cwkkdoi/w_m1a1para.mdl"

SWEP.WMPos = Vector(5, 0.5, -0.538)
SWEP.WMAng = Vector(-5, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip = 0 --	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".30 Carbine"

SWEP.FireDelay = 60/600
SWEP.FireSound = "CW_KK_INS2_DOI_M1A1_FIRE"
SWEP.Recoil = 0.99

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.0064
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.045
SWEP.SpreadPerShot = 0.006
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 41

SWEP.FirstDeployTime = 2
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.6

SWEP.ReloadSpeed = 1

SWEP.SnapToIdlePostReload = false

SWEP.SightBGs = {main = 0, foldsight = 0}

SWEP.WeaponLength = 20

SWEP.MuzzleVelocity = 607

SWEP.ReloadTimes = {
	base_reload = {71/35, 3.9},
	base_reloadempty = {78/35, 5.4},
	base_reload_ext = {71/35, 3.9},
	base_reloadempty_ext = {78/35, 5.4},

	base_melee_bash = {0.3, 1},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("kk_ins2_mag_m1a1_15", !self.ActiveAttachments.kk_ins2_mag_m1a1_30)
	end
end
