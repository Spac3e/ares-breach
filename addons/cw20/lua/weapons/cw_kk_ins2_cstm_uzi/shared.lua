if not CustomizableWeaponry then return end



AddCSLuaFile()

AddCSLuaFile("sh_soundscript.lua")

include("sh_soundscript.lua")



SWEP.magType = "smgMag"



if CLIENT then

	SWEP.DrawCrosshair = false

	SWEP.CSMuzzleFlashes = true

	SWEP.PrintName = "Uzi"

	SWEP.ViewModelMovementScale = 1.15

	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/uzi.png" )



	SWEP.Shell = "KK_INS2_9x19"

	SWEP.ShellDelay = 0.1



	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}



	SWEP.AttachmentModelsVM = {

		["kk_ins2_optic_rail"] = {model = "models/weapons/upgrades/a_modkit_04.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_suppressor_ins"] = {model = "models/weapons/upgrades/a_suppressor_ins.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band_l.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_magnifier"] = {model = "models/weapons/upgrades/a_optic_aimp2x_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},



		["kk_ins2_aimpoint"] = {model = "models/weapons/upgrades/a_optic_aimpoint_m.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_elcan"] = {model = "models/weapons/upgrades/a_optic_elcan_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_eotech"] = {model = "models/weapons/upgrades/a_optic_eotech_m.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_kobra"] = {model = "models/weapons/upgrades/a_optic_kobra.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_po4"] = {model = "models/weapons/upgrades/a_optic_po4x24_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},



		["kk_ins2_cstm_cmore"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_cmore_m.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_cstm_compm4s"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_compm4s_m.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_cstm_microt1"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_microt1_m.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_cstm_acog"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_acog_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_cstm_barska"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_barska_m.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_cstm_eotechxps"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_eotechxps_m.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

	}



	SWEP.AttachmentModelsWM = {

		["kk_ins2_optic_rail"] = {model = "models/weapons/upgrades/w_modkit_4.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_suppressor_ins"] = {model = "models/weapons/upgrades/w_sil_ins1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/w_laser_ins.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/w_laser_ins.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



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



	SWEP.IronsightPos = Vector(-2.1604, -2, 0.7765)

	SWEP.IronsightAng = Vector(-0.192, 0.05, 0)


	SWEP.KKINS2KobraPos = Vector(-2.1713, -2, -0.0186)

	SWEP.KKINS2KobraAng = Vector()



	SWEP.KKINS2EoTechPos = Vector(-2.1676, -2, 0.0134)

	SWEP.KKINS2EoTechAng = Vector()



	SWEP.KKINS2AimpointPos = Vector(-2.1587, -2, 0.016)

	SWEP.KKINS2AimpointAng = Vector()



	SWEP.KKINS2ElcanPos = Vector(-2.1636, -1, -0.2588)

	SWEP.KKINS2ElcanAng = Vector()



	SWEP.KKINS2PO4Pos = Vector(-2.1113, -1, 0.1031)

	SWEP.KKINS2PO4Ang = Vector()



	SWEP.KKINS2MagnifierPos = Vector(-2.1605, -1, 0.0125)

	SWEP.KKINS2MagnifierAng = Vector()



	SWEP.KKINS2CSTMBarskaPos = Vector(-2.1541, -2, -0.0095)

	SWEP.KKINS2CSTMBarskaAng = Vector()



	SWEP.KKINS2CSTMCMorePos = Vector(-2.1587, -2, 0.016)

	SWEP.KKINS2CSTMCMoreAng = Vector()



	SWEP.CustomizationMenuScale = 0.011

end



SWEP.MuzzleEffect = "muzzleflash_pistol_red"

SWEP.MuzzleEffectWorld = "muzzleflash_ar2_npc"



SWEP.Attachments = {

	{header = "Sight", offset = {300, -500}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},

--	{header = "Barrel", offset = {-300, -500}, atts = {"kk_ins2_suppressor_ins"}},

	{header = "Lasers", offset = {-500, 0}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},

	{header = "More Sight", offset = {800, 0}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},

	["+use"] = {header = "Sight Contract", offset = {300, 0}, atts = {"kk_ins2_sights_cstm"}},

	--["+reload"] = {header = "Ammo", offset = {0, 500}, atts = {"am_magnum", "am_matchgrade"}}

}



SWEP.Animations = {

	base_pickup = "base_ready",

	base_draw = "base_draw",

	base_draw_empty = "empty_draw",

	base_fire = "base_fire",

	base_fire_aim = {"iron_fire","iron_fire_a","iron_fire_b","iron_fire_c","iron_fire_d","iron_fire_e","iron_fire_f"},

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

}



SWEP.SpeedDec = 15



SWEP.Slot = 2

SWEP.SlotPos = 0

SWEP.NormalHoldType = "ar2"

SWEP.RunHoldType = "passive"

SWEP.FireModes = {"auto"}

SWEP.Base = "cw_kk_ins2_base_main"

SWEP.Category = "CW 2.0 KK INS2 EXT"



SWEP.Author			= "Spy"

SWEP.Contact		= ""

SWEP.Purpose		= ""

SWEP.Instructions	= ""



SWEP.ViewModelFOV	= 70

SWEP.ViewModelFlip	= false

SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_cstm_uzi.mdl"

SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_cstm_uzi.mdl"



SWEP.WMPos = Vector(5.176, 0.889, -1.417)

SWEP.WMAng = Vector(-10, 0, 180)



SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.f1

SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.gurkha



SWEP.Spawnable			= true

SWEP.AdminSpawnable		= true



SWEP.Primary.ClipSize		= 32

SWEP.Primary.DefaultClip	= 0

SWEP.Primary.Automatic		= true

SWEP.Primary.Ammo			= "Pistol"



SWEP.FireDelay = 60/400

SWEP.FireSound = "CW_KK_INS2_MP40_FIRE"

SWEP.FireSoundSuppressed = "CW_KK_INS2_MP40_FIRE_SUPPRESSED"

SWEP.Recoil = 1.3



SWEP.HipSpread = 0.035

SWEP.AimSpread = 0.009

SWEP.VelocitySensitivity = 1.5

SWEP.MaxSpreadInc = 0.03

SWEP.SpreadPerShot = 0.005

SWEP.SpreadCooldown = 0.13

SWEP.Shots = 1

SWEP.Damage = 24



SWEP.FirstDeployTime = 2.9

SWEP.DeployTime = 0.8

SWEP.HolsterTime = 0.6



SWEP.Chamberable = false



SWEP.WeaponLength = 16



SWEP.KK_INS2_EmptyIdle = true



SWEP.MuzzleVelocity = 400



SWEP.ReloadTimes = {

	base_reload = {2.55, 3.62},

	base_reloadempty = {4.3, 5.68},

}

