--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_famas/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_famas/shared.lua
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

	SWEP.PrintName = "FAMAS"

	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelMovementScale = 1.15

	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/famas (2).png" )



	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/famas")



	SWEP.Shell = "KK_INS2_556x45"

	SWEP.ShellDelay = 0.06

    function SWEP:updateStandardParts()

        self:setElementActive("kk_ins2_suppressor_sec", self.ActiveAttachments.kk_ins2_suppressor_sec)

    end

	SWEP.AttachmentModelsVM = {

		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/a_suppressor_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_foregrip_sec2.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), attachment = "Foregrip"},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_magnifier"] = {model = "models/weapons/upgrades/a_optic_aimp2x_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},



		["kk_ins2_aimpoint"] = {model = "models/weapons/upgrades/a_optic_aimpoint.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_elcan"] = {model = "models/weapons/upgrades/a_optic_elcan_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_eotech"] = {model = "models/weapons/upgrades/a_optic_eotech.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_kobra"] = {model = "models/weapons/upgrades/a_optic_kobra_l.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 1.2},

		["kk_ins2_po4"] = {model = "models/weapons/upgrades/a_optic_po4x24_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},



		["kk_ins2_cstm_cmore"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_cmore.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_compm4s"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_compm4s.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_microt1"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_microt1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_acog"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_acog_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_cstm_barska"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_barska.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_cstm_eotechxps"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_eotechxps.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

	}



	SWEP.AttachmentModelsWM = {

		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/w_sil_sec1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/w_foregrip_sec2.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



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



	SWEP.IronsightPos = Vector(-2.5871, -3, 0.6307)

	SWEP.IronsightAng = Vector(-0.4127, 0.03, 0)



	SWEP.KKINS2KobraPos = Vector(-2.6006, -2, -1.2304)

	SWEP.KKINS2KobraAng = Vector()



	SWEP.KKINS2EoTechPos = Vector(-2.6023, -2, -1.1429)

	SWEP.KKINS2EoTechAng = Vector()



	SWEP.KKINS2AimpointPos = Vector(-2.6056, -3, -1.1184)

	SWEP.KKINS2AimpointAng = Vector()



	SWEP.KKINS2ElcanPos = Vector(-2.5995, -3, -1.2309)

	SWEP.KKINS2ElcanAng = Vector()



	SWEP.KKINS2PO4Pos = Vector(-2.5506, -5, -0.8741)

	SWEP.KKINS2PO4Ang = Vector()



	SWEP.KKINS2MagnifierPos = Vector(-2.5994, -5, -1.1321)

	SWEP.KKINS2MagnifierAng = Vector()



	SWEP.CustomizationMenuScale = 0.015

end



SWEP.MuzzleEffect = "muzzleflash_m16_1p_core"

SWEP.MuzzleEffectWorld = "muzzleflash_m16_3rd"



SWEP.Attachments = {

	{header = "Sight", offset = {400, -500}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},

	{header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_suppressor_sec"}},

	{header = "Under", offset = {-500, -100}, atts = {"kk_ins2_vertgrip"}},

	{header = "Lasers", offset = {0, 300}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},

	{header = "More Sight", offset = {1000, -50}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},

	["+use"] = {header = "Sight Contract", offset = {400, -50}, atts = {"kk_ins2_sights_cstm"}},

	--["+reload"] = {header = "Ammo", offset = {700, 400}, atts = {"am_magnum", "am_matchgrade"}}

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



	foregrip_pickup = "foregrip_ready",

	foregrip_draw = "foregrip_draw",

	foregrip_fire = "foregrip_fire",

	foregrip_fire_aim = {"foregrip_iron_fire","foregrip_iron_fire_a","foregrip_iron_fire_b","foregrip_iron_fire_c","foregrip_iron_fire_d","foregrip_iron_fire_e","foregrip_iron_fire_f"},

	foregrip_fire_empty = "foregrip_dryfire",

	foregrip_fire_empty_aim = "foregrip_iron_dryfire_b",

	foregrip_reload = "foregrip_reload",

	foregrip_reload_empty = "foregrip_reloadempty",

	foregrip_idle = "foregrip_holster",

	foregrip_holster = "foregrip_holster",

	foregrip_firemode = "foregrip_fireselect",

	foregrip_firemode_aim = "foregrip_iron_fireselect",

	foregrip_sprint = "foregrip_sprint",

	foregrip_safe = "foregrip_down",

	foregrip_safe_aim = "foregrip_iron_down",

	foregrip_crawl = "foregrip_crawl",

}



SWEP.SpeedDec = 5



SWEP.Slot = 3

SWEP.SlotPos = 0

SWEP.NormalHoldType = "ar2"

SWEP.RunHoldType = "passive"

SWEP.FireModes = {"auto", "3burst", "semi"}

SWEP.Base = "cw_kk_ins2_base_main"

SWEP.Category = "CW 2.0 KK INS2 EXT"



SWEP.Author			= "Spy"

SWEP.Contact		= ""

SWEP.Purpose		= ""

SWEP.Instructions	= ""



SWEP.ViewModelFOV	= 80

SWEP.ViewModelFlip	= false

SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_cstm_famas.mdl"

SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_cstm_famas.mdl"



SWEP.WMPos = Vector(5.072, 0.924, -1.537)

SWEP.WMAng = Vector(-5, 0, 180)



SWEP.Spawnable			= true

SWEP.AdminSpawnable		= true



SWEP.Primary.ClipSize		= 25

SWEP.Primary.DefaultClip = 0 --	= 0

SWEP.Primary.Automatic		= true

SWEP.Primary.Ammo			= "SMG1"



SWEP.FireDelay = 0.0663

SWEP.FireSound = "CW_KK_INS2_CSTM_FAMAS_FIRE"

SWEP.FireSoundSuppressed = "CW_KK_INS2_MINI14_FIRE_SUPPRESSED"

SWEP.Recoil = 1.44



SWEP.HipSpread = 0.045

SWEP.AimSpread = 0.0025

SWEP.VelocitySensitivity = 1.8

SWEP.MaxSpreadInc = 0.033

SWEP.SpreadPerShot = 0.007

SWEP.SpreadCooldown = 0.16

SWEP.Shots = 1

SWEP.Damage = 27



SWEP.FirstDeployTime = 1.8

SWEP.DeployTime = 0.7

SWEP.HolsterTime = 0.5



SWEP.SnapToIdlePostReload = false



SWEP.ReloadTimes = {

	base_reload = {2.3, 3.1},

	base_reloadempty = {2.3, 4.6},



	foregrip_reload = {2.3, 3.1},

	foregrip_reloadempty = {2.3, 4.6}

}



SWEP.WeaponLength = 22



SWEP.MuzzleVelocity = 960



