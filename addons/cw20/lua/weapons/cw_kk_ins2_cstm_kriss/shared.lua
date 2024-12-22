--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_kriss/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_kriss/shared.lua
--]]
if not CustomizableWeaponry then return end



AddCSLuaFile()

AddCSLuaFile("sh_soundscript.lua")

include("sh_soundscript.lua")



SWEP.magType = "smgMag"



if CLIENT then

	SWEP.DrawCrosshair = false

	SWEP.PrintName = "KRISS Vector"

	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelMovementScale = 1.15

	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/vector.png" )



	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/kriss")



	SWEP.Shell = "KK_INS2_45apc"



	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 180}



	SWEP.AttachmentModelsVM = {

		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/a_suppressor_sec.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_magnifier"] = {model = "models/weapons/upgrades/a_optic_aimp2x.mdl", rLight = true, pos = Vector(0, 0, 1), angle = Angle(90, 0, 90), size = Vector(1, 1, 1), attachment = "Optic"},



		["kk_ins2_aimpoint"] = {model = "models/weapons/upgrades/a_optic_aimpoint.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_elcan"] = {model = "models/weapons/upgrades/a_optic_elcan.mdl", rLight = true, pos = Vector(0, 0, 0.5), angle = Angle(90, 0, 90), size = Vector(1, 1, 1), attachment = "Optic"},

		["kk_ins2_eotech"] = {model = "models/weapons/upgrades/a_optic_eotech.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_kobra"] = {model = "models/weapons/upgrades/a_optic_kobra_l.mdl", pos = Vector(0, 0, 1), angle = Angle(90, 0, 90), size = Vector(1, 1, 1), attachment = "Optic", retSizeMult = 1.2},

		["kk_ins2_po4"] = {model = "models/weapons/upgrades/a_optic_po4x24.mdl", rLight = true, pos = Vector(0, 0, 0.5), angle = Angle(90, 0, 90), size = Vector(1, 1, 1), attachment = "Optic"},



		["kk_ins2_cstm_cmore"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_cmore.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_compm4s"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_compm4s.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_microt1"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_microt1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_acog"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_acog.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_barska"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_barska.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_eotechxps"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_eotechxps.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

	}



	SWEP.AttachmentModelsWM = {

		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/w_sil_sec1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



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



	SWEP.IronsightPos = Vector(-2.7495, -2, 1.097)

	SWEP.IronsightAng = Vector()



	SWEP.KKINS2KobraPos = Vector(-2.7323, -3, 0.4386)

	SWEP.KKINS2KobraAng = Vector()



	SWEP.KKINS2EoTechPos = Vector(-2.7339, -3, 0.5175)

	SWEP.KKINS2EoTechAng = Vector()



	SWEP.KKINS2AimpointPos = Vector(-2.7371, -2, 0.5295)

	SWEP.KKINS2AimpointAng = Vector()



	SWEP.KKINS2ElcanPos = Vector(-2.7389, -3, 0.2062)

	SWEP.KKINS2ElcanAng = Vector()



	SWEP.KKINS2PO4Pos = Vector(-2.6774, -4, 0.6317)

	SWEP.KKINS2PO4Ang = Vector()



	SWEP.KKINS2MagnifierPos = Vector(-2.7338, -3, 0.5288)

	SWEP.KKINS2MagnifierAng = Vector()



	SWEP.KKINS2CSTMCMorePos = Vector(-2.7371, -2, 0.5295)

	SWEP.KKINS2CSTMCMoreAng = Vector()



	SWEP.KKINS2CSTMBarskaPos = Vector(-2.7339, -3, 0.5175)

	SWEP.KKINS2CSTMBarskaAng = Vector()



	SWEP.KKINS2CSTMMicroT1Pos = Vector(-2.7371, -2, 0.5295)

	SWEP.KKINS2CSTMMicroT1Ang = Vector()



	SWEP.KKINS2CSTMEoTechXPSPos = Vector(-2.7339, -3, 0.5175)

	SWEP.KKINS2CSTMEoTechXPSAng = Vector()



	SWEP.KKINS2CSTMCompM4SPos = Vector(-2.7371, -2, 0.5295)

	SWEP.KKINS2CSTMCompM4SAng = Vector()



	SWEP.KKINS2CSTMACOGPos = Vector(-2.7389, -3, 0.2062)

	SWEP.KKINS2CSTMACOGAng = Vector()



	SWEP.CustomizationMenuScale = 0.012

end



SWEP.MuzzleEffect = "muzzleflash_ump_1p_core"

SWEP.MuzzleEffectWorld = "muzzleflash_ump_3rd"



SWEP.Attachments = {

	{header = "Sight", offset = {400, -700}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},

	{header = "Barrel", offset = {-300, -700}, atts = {"kk_ins2_suppressor_sec"}},

	{header = "Lasers", offset = {-500, -200}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},

	{header = "More Sight", offset = {900, -200}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},

	["+use"] = {header = "Sight Contract", offset = {400, -200}, atts = {"kk_ins2_sights_cstm"}},

	--["+reload"] = {header = "Ammo", offset = {0, 300}, atts = {"am_magnum", "am_matchgrade"}}

}



SWEP.Animations = {

	base_pickup = "base_ready",

	base_draw = "base_draw",

	base_fire = "base_fire",

	base_fire_aim = {"iron_fire","iron_fire_a","iron_fire_b","iron_fire_c","iron_fire_d","iron_fire_e","iron_fire_f"},

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



SWEP.SpeedDec = 15



SWEP.Slot = 2

SWEP.SlotPos = 0

SWEP.NormalHoldType = "ar2"

SWEP.RunHoldType = "passive"

SWEP.FireModes = {"auto", "2burst", "semi"}

SWEP.Base = "cw_kk_ins2_base_main"

SWEP.Category = "CW 2.0 KK INS2 EXT"



SWEP.Author			= "Spy"

SWEP.Contact		= ""

SWEP.Purpose		= ""

SWEP.Instructions	= ""



SWEP.ViewModelFOV	= 80

SWEP.ViewModelFlip	= false

SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_cstm_kriss.mdl"

SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_cstm_kriss.mdl"



SWEP.WMPos = Vector(5.471, 0.967, 0.5)

SWEP.WMAng = Vector(-15, 0, 180)



SWEP.Spawnable			= true

SWEP.AdminSpawnable		= true



SWEP.Primary.ClipSize		= 30

SWEP.Primary.DefaultClip = 0 --	= 0

SWEP.Primary.Automatic		= true

SWEP.Primary.Ammo			= "SMG1"



SWEP.FireDelay = 0.0566

SWEP.FireSound = "CW_KK_INS2_UMP45_FIRE"

SWEP.FireSoundSuppressed = "CW_KK_INS2_UMP45_FIRE_SUPPRESSED"

SWEP.Recoil = 1.4



SWEP.HipSpread = 0.035

SWEP.AimSpread = 0.009

SWEP.VelocitySensitivity = 1.5

SWEP.MaxSpreadInc = 0.03

SWEP.SpreadPerShot = 0.005

SWEP.SpreadCooldown = 0.13

SWEP.Shots = 1

SWEP.Damage = 23



SWEP.FirstDeployTime = 2.3

SWEP.DeployTime = 0.6

SWEP.HolsterTime = 0.5



SWEP.WeaponLength = 16



SWEP.MuzzleVelocity = 700



SWEP.ReloadTimes = {

	base_reload = {2.35, 3.15},

	base_reloadempty = {2.8, 4.5},

}



