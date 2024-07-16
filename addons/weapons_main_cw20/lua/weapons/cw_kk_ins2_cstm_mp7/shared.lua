--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_mp7/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_mp7/shared.lua
--]]
if not CustomizableWeaponry then return end



AddCSLuaFile()

AddCSLuaFile("sh_soundscript.lua")

include("sh_soundscript.lua")



SWEP.magType = "smgMag"



if CLIENT then

	SWEP.DrawCrosshair = false

	SWEP.PrintName = "HK MP7"

	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelMovementScale = 1.15



	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/mp7")



	SWEP.Shell = "KK_INS2_9x19"

	SWEP.ShellDelay = 0.06

	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}



	SWEP.AttachmentModelsVM = {

		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/a_suppressor_sec.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), attachment = "Suppressor"},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



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

		["kk_ins2_optic_rail"] = {model = "models/weapons/upgrades/w_modkit_5.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



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



	SWEP.IronsightPos = Vector(-2.1674, -1, 0.5516)

	SWEP.IronsightAng = Vector(0.1782, 0, 0)



	SWEP.KKINS2KobraPos = Vector(-2.1707, -2, 0.0617)

	SWEP.KKINS2KobraAng = Vector()



	SWEP.KKINS2EoTechPos = Vector(-2.1746, -2, 0.0971)

	SWEP.KKINS2EoTechAng = Vector()



	SWEP.KKINS2AimpointPos = Vector(-2.1753, -2, 0.0949)

	SWEP.KKINS2AimpointAng = Vector(0.0332, 0, 0)



	SWEP.KKINS2ElcanPos = Vector(-2.1716, -3, -0.1786)

	SWEP.KKINS2ElcanAng = Vector()



	SWEP.KKINS2PO4Pos = Vector(-2.1221, -4, 0.1812)

	SWEP.KKINS2PO4Ang = Vector()



	SWEP.KKINS2MagnifierPos = Vector(-2.1699, -3, 0.0933)

	SWEP.KKINS2MagnifierAng = Vector()



	SWEP.CustomizationMenuScale = 0.012

end



SWEP.MuzzleEffect = "muzzleflash_mp5_1p_core"

SWEP.MuzzleEffectWorld = "muzzleflash_mp5_3rd"



SWEP.Attachments = {

	{header = "Sight", offset = {300, -700}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},

	{header = "Barrel", offset = {-300, -700}, atts = {"kk_ins2_suppressor_sec"}},

	{header = "Lasers", offset = {-500, -200}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},

	{header = "More Sight", offset = {800, -200}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},

	["+use"] = {header = "Sight Contract", offset = {300, -200}, atts = {"kk_ins2_sights_cstm"}},

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

SWEP.FireModes = {"auto", "3burst", "semi"}

SWEP.Base = "cw_kk_ins2_base"

SWEP.Category = "CW 2.0 KK INS2 EXT"



SWEP.Author			= "Spy"

SWEP.Contact		= ""

SWEP.Purpose		= ""

SWEP.Instructions	= ""



SWEP.ViewModelFOV	= 80

SWEP.ViewModelFlip	= false

SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_cstm_mp7.mdl"

SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_cstm_mp7.mdl"



SWEP.WMPos = Vector(5.471, 0.967, -1.344)

SWEP.WMAng = Vector(-10, 0, 180)



SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)



SWEP.Primary.ClipSize		= 40

SWEP.Primary.DefaultClip = 0 --	= 0

SWEP.Primary.Automatic		= true

SWEP.Primary.Ammo			= "SMG1"



SWEP.FireDelay = 0.119

SWEP.FireSound = "CW_KK_INS2_MP5K_FIRE"

SWEP.FireSoundSuppressed = "CW_KK_INS2_MP5K_FIRE_SUPPRESSED"

SWEP.Recoil = 1.59



SWEP.HipSpread = 0.035

SWEP.AimSpread = 0.009

SWEP.VelocitySensitivity = 1.5

SWEP.MaxSpreadInc = 0.03

SWEP.SpreadPerShot = 0.005

SWEP.SpreadCooldown = 0.13

SWEP.Shots = 1

SWEP.Damage = 39



SWEP.FirstDeployTime = 1.6

SWEP.DeployTime = 0.8

SWEP.HolsterTime = 0.5



SWEP.WeaponLength = 16



SWEP.MuzzleVelocity = 735



SWEP.ReloadTimes = {

	base_reload = {2.3, 3.1},

	base_reloadempty = {2.35, 4.66},

}



