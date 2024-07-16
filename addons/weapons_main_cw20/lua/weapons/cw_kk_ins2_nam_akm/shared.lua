--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_akm/shared.lua

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
	SWEP.PrintName = "AKM"
	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_akm")

	SWEP.Shell = "KK_INS2_762x39"

	SWEP.AttachmentModelsVM = {
		["kk_ins2_optic_rail"] = {model = "models/weapons/upgrades/a_modkit_06.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_pbs1"] = {model = "models/weapons/upgrades/a_suppressor_ak.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_foregrip_ins.mdl", pos = Vector(0, 0, -0.2752), angle = Angle(0, -90, 0), size = Vector(0.5, 0.5, 0.5), attachment = "Foregrip"},
		["kk_ins2_gl_gp25"] = {model = "models/weapons/upgrades/a_gl_gp25.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_magnifier"] = {model = "models/weapons/upgrades/a_optic_aimp2x.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_aimpoint"] = {model = "models/weapons/upgrades/a_optic_aimpoint.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_elcan"] = {model = "models/weapons/upgrades/a_optic_elcan_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},
		["kk_ins2_eotech"] = {model = "models/weapons/upgrades/a_optic_eotech.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_kobra"] = {model = "models/weapons/upgrades/a_optic_kobra_l.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 1.2},
		["kk_ins2_po4"] = {model = "models/weapons/upgrades/a_optic_po4x24.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_cmore"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_cmore.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_compm4s"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_compm4s.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_microt1"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_microt1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_acog"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_acog_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},
		["kk_ins2_cstm_barska"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_barska.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_eotechxps"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_eotechxps.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_pgo7"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_pgo7.mdl", bone = "Weapon", pos = Vector(0.453, -3.218, -0.301), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_optic_rail"] = {model = "models/weapons/upgrades/w_modkit_6.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_pbs1"] = {model = "models/weapons/upgrades/w_sil_ins1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/w_ins_foregrip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_gl_gp25"] = {model = "models/weapons/upgrades/w_gp25.mdl", attachment = "gl", pos = Vector(-10.75,0.2,0), angle = Angle(0, 0, -90), size = Vector(1, 1, 1)},

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

	SWEP.IronsightPos = Vector(-1.6165, -3, 0.4936)
	SWEP.IronsightAng = Vector(1.2084, 0.0477, 0)

	SWEP.KKINS2KobraPos = Vector(-1.6519, -2, -0.1356)
	SWEP.KKINS2KobraAng = Vector(0, -0.0261, 0)

	SWEP.KKINS2EoTechPos = Vector(-1.6439, 0, -0.0596)
	SWEP.KKINS2EoTechAng = Vector(0.0551, -0.0905, 0)

	SWEP.KKINS2AimpointPos = Vector(-1.637, 0, -0.0554)
	SWEP.KKINS2AimpointAng = Vector(0.0359, -0.0169, 0)

	SWEP.KKINS2ElcanPos = Vector(-1.639, -2, -0.1729)
	SWEP.KKINS2ElcanAng = Vector(0, 0, 0)

	SWEP.KKINS2MagnifierPos = Vector(-1.6359, -2, -0.0727)
	SWEP.KKINS2MagnifierAng = Vector(0, 0, 0)

	SWEP.KKINS2PO4Pos = Vector(-1.5807, -3, 0.0296)
	SWEP.KKINS2PO4Ang = Vector(0, 0, 0)

	SWEP.CustomizationMenuScale = 0.016
end

SWEP.MuzzleEffect = "muzzleflash_akm_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_akm_3rd"

SWEP.Attachments = {
	----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

local hasBase = CustomizableWeaponry_KK.ins2.isContentMounted4({Folder = "weapons/cw_kk_ins2_base"})
if hasBase then
	SWEP.Attachments = {
		{header = "Sight", offset = {400, -450}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},
		{header = "Barrel", offset = {-100, -450}, atts = {"kk_ins2_pbs1"}},
		-- {header = "Under", offset = {-400, 0}, atts = {"kk_ins2_vertgrip", "kk_ins2_gl_gp25"}},
		{header = "More Sight", offset = {1000, 0}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
		["+use"] = {header = "Sight Contract", offset = {400, -0}, atts = {"kk_ins2_sights_cstm"}},
		----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
	}
end

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = {"iron_fire1","iron_fire2","iron_fire3","iron_fire4"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_firemode = "base_fireselect",
	base_firemode_aim = "iron_fireselect",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",

}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_nam_akm.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_akm.mdl"

SWEP.WMPos = Vector(5.666, 0.66, -1.055)
SWEP.WMAng = Angle(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.rgd5
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2keh
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip = 0 --	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x39MM"

SWEP.FireDelay = 60/600
SWEP.FireSound = "CW_KK_INS2_NAM_AKM_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_AKM_FIRE_SUPPRESSED"
SWEP.Recoil = 1.2

SWEP.HipSpread = 0.043
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 40

SWEP.FirstDeployTime = 2
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.6

SWEP.WeaponLength = 22

SWEP.MuzzleVelocity = 715

SWEP.ReloadTimes = {
	base_reload = {2.2, 3.2},
	base_reloadempty = {2.2, 4.35},

	foregrip_reload = {2.2, 3.15},
	foregrip_reloadempty = {2.2, 4.35},

	gl_reload = {2.2, 3.15},
	gl_reloadempty = {2.2, 4.35},

	glsetup_in = {0.6, 0.6},
	glsetup_out = {0.7, 0.7},

	glsetup_reload = {1.75, 2.67}
}
