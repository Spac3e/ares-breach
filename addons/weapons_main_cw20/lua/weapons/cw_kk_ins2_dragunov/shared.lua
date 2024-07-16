--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_dragunov/shared.lua

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
	SWEP.PrintName = "Dragunov"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15
	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/dragunov.png" )

	SWEP.Shell = "KK_INS2_762x33"

	SWEP.AttachmentModelsVM = {
		-- ["kk_ins2_optic_iron"] = {model = "models/weapons/upgrades/a_standard_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		-- ["kk_ins2_optic_rail"] = {model = "models/weapons/upgrades/a_modkit_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_optic_raul"] = {model = "models/weapons/cw_cultist/dragunov/upgrades/a_modkit_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_mag_m1a1_15"] = {model = "models/weapons/cw_cultist/dragunov/upgrades/a_magazine_m1a1_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_m1a1_30"] = {model = "models/weapons/cw_cultist/dragunov/upgrades/a_magazine_m1a1_30.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_suppressor_ins"] = {model = "models/weapons/upgrades/a_suppressor_ins.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_foregrip_ins.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), attachment = "Foregrip"},

		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_magnifier"] = {model = "models/weapons/upgrades/a_optic_aimp2x.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_aimpoint"] = {model = "models/weapons/upgrades/a_optic_aimpoint.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_elcan"] = {model = "models/weapons/upgrades/a_optic_elcan.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_eotech"] = {model = "models/weapons/upgrades/a_optic_eotech_xl.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 1.25},
		["kk_ins2_kobra"] = {model = "models/weapons/upgrades/a_optic_kobra_l.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 1.2},
		["kk_ins2_po4"] = {model = "models/weapons/upgrades/a_optic_po4x24.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_cmore"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_cmore.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_compm4s"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_compm4s.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_microt1"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_microt1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_acog"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_acog.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_barska"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_barska_xl.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 1.25},
		["kk_ins2_cstm_eotechxps"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_eotechxps.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		-- ["kk_ins2_optic_iron"] = {model = "models/weapons/upgrades/w_standard_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		-- ["kk_ins2_optic_rail"] = {model = "models/weapons/upgrades/w_modkit_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_optic_raul"] = {model = "models/weapons/cw_cultist/dragunov/upgrades/w_modkit_m1a1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_mag_m1a1_15"] = {model = "models/weapons/cw_cultist/dragunov/upgrades/w_magazine_m1a1_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_m1a1_30"] = {model = "models/weapons/cw_cultist/dragunov/upgrades/w_magazine_m1a1_30.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_suppressor_ins"] = {model = "models/weapons/upgrades/w_sil_ins1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/w_ins_foregrip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_lam"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_magnifier"] = {model = "models/weapons/upgrades/w_magaim.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_aimpoint"] = {model = "models/weapons/upgrades/w_aimpoint.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_elcan"] = {model = "models/weapons/upgrades/w_elcan.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_eotech"] = {model = "models/weapons/upgrades/w_eotech.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_kobra"] = {model = "models/weapons/upgrades/w_kobra.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_po4"] = {model = "models/weapons/upgrades/w_po.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_cmore"] = {model = "models/weapons/attachments/w_cw_kk_ins2_cstm_cmore.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_compm4s"] = {model = "models/weapons/upgrades/w_aimpoint.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_microt1"] = {model = "models/weapons/upgrades/w_aimpoint.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_acog"] = {model = "models/weapons/attachments/w_cw_kk_ins2_cstm_acog.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_barska"] = {model = "models/weapons/upgrades/w_eotech.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_eotechxps"] = {model = "models/weapons/attachments/w_cw_kk_ins2_cstm_eotechxps.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-2.585, -2, 1.8)
	SWEP.IronsightAng = Vector(0, 0.03, 0)

	SWEP.KKINS2KobraPos = Vector(-2.585, -2, 0.78)
	SWEP.KKINS2KobraAng = Vector()

	SWEP.KKINS2EoTechPos = Vector(-2.585, -2, 0.78)
	SWEP.KKINS2EoTechAng = Vector()

	SWEP.KKINS2AimpointPos = Vector(-2.585, -2, 0.78)
	SWEP.KKINS2AimpointAng = Vector()

	SWEP.KKINS2ElcanPos = Vector(-2.585, -2, 0.78)
	SWEP.KKINS2ElcanAng = Vector()

	SWEP.KKINS2PO4Pos = Vector(-2.585, -2, 0.78)
	SWEP.KKINS2PO4Ang = Vector()

	SWEP.KKINS2MagnifierPos = Vector(-2.585, -2, 0.78)
	SWEP.KKINS2MagnifierAng = Vector()

	SWEP.KKINS2CSTMEoTechXPSPos = Vector(-2.5574921, -2, 1.75)
	SWEP.KKINS2CSTMEoTechXPSAng = Vector()

	SWEP.CustomizationMenuScale = 0.016
end

SWEP.MuzzleEffect = "muzzleflash_akm_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_m14_3rd"

SWEP.Attachments = {
	{header = "Sight", offset = {400, -500}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},
	{header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_suppressor_ins"}},
	--{header = "Under", offset = {-500, 0}, atts = {"kk_ins2_vertgrip"}},
	{header = "Lasers", offset = {200, 300}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},
	{header = "More Sight", offset = {1000, -50}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
	["+use"] = {header = "Sight Contract", offset = {400, -50}, atts = {"kk_ins2_sights_cstm"}},
	--["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = "iron_fire",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_mm = "base_reload_ext",
	base_reload_empty = "base_reloadempty",
	base_reload_empty_mm = "base_reloadempty_ext",
	base_idle = "blend_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",

	foregrip_pickup = "foregrip_ready",
	foregrip_draw = "foregrip_draw",
	foregrip_fire = "foregrip_fire",
	foregrip_fire_aim = "foregrip_iron_fire",
	foregrip_fire_empty = "foregrip_dryfire",
	foregrip_fire_empty_aim = "foregrip_iron_dryfire",
	foregrip_reload = "foregrip_reload",
	foregrip_reload_mm = "foregrip_reload_ext",
	foregrip_reload_empty = "foregrip_reloadempty",
	foregrip_reload_empty_mm = "foregrip_reloadempty_ext",
	foregrip_idle = "blend_idle_foregrip",
	foregrip_holster = "foregrip_holster",
	foregrip_sprint = "foregrip_sprint",
	foregrip_safe = "foregrip_down",
	foregrip_safe_aim = "foregrip_iron_down",
	foregrip_crawl = "foregrip_crawl",
}

SWEP.SpeedDec = 40

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW BREACH"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_cultist/dragunov/v_dragunov.mdl"
SWEP.WorldModel		= "models/weapons/cw_cultist/dragunov/w_dragunov.mdl"

SWEP.WMPos = Vector(4.986, 0.921, -1.038)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip = 0 --	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "AR2"

SWEP.FireDelay = 0.489
SWEP.FireSound = "CW_KK_INS2_DRAGUNOV_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_DRAGUNOV_FIRE_SUPPRESSED"
SWEP.Recoil = 3

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.0064
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.045
SWEP.SpreadPerShot = 0.006
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 160

SWEP.FirstDeployTime = 1.5
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.7

SWEP.SnapToIdlePostReload = false

SWEP.WeaponLength = 20

SWEP.MuzzleVelocity = 607

SWEP.ReloadTimes = {
	base_reload	= {2.25, 3.05},
	base_reloadempty = {2.25, 4.55},
	base_reload_ext	= {2.25, 3.05},
	base_reloadempty_ext = {2.25, 4.55},

	foregrip_reload	= {2.25, 3.05},
	foregrip_reloadempty = {2.25, 4.55},
	foregrip_reload_ext	= {2.25, 3.05},
	foregrip_reloadempty_ext = {2.25, 4.55},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("kk_ins2_mag_m1a1_15", !self.ActiveAttachments.kk_ins2_mag_m1a1_30)
	end
end
