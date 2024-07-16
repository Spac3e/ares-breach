--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_g19/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_g19/shared.lua
--]]
if not CustomizableWeaponry then return end



AddCSLuaFile()

AddCSLuaFile("sh_sounds.lua")

AddCSLuaFile("sh_soundscript.lua")

include("sh_sounds.lua")

include("sh_soundscript.lua")



SWEP.magType = "pistolMag"



if CLIENT then

	SWEP.DrawCrosshair = false

	SWEP.PrintName = "Glock 19"

	SWEP.CSMuzzleFlashes = true



	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/g19")
	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/g19.png", "noclamp smooth" )



	SWEP.Shell = "KK_INS2_9x19"

	SWEP.ShellDelay = 0.06

	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}



	SWEP.AttachmentModelsVM = {

		["kk_ins2_suppressor_pistol"] = {model = "models/weapons/upgrades/a_suppressor_pistol.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_mag_g19_15"] = {model = "models/weapons/upgrades/a_magazikk_makag19_8.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_mag_g19_22"] = {model = "models/weapons/upgrades/a_magazikk_makag19_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_rail.mdl", pos = Vector(0, 3.3, -0.3336), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), bone = "Weapon"},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_rail.mdl", pos = Vector(0, 3.3, -0.3336), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), bone = "Weapon"},

		["kk_ins2_m6x"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_m6x.mdl", pos = Vector(-0.1169, 1.5466, -1.0772), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), bone = "Weapon"},



		["kk_ins2_g19_skin"] = {model = "models/weapons/v_cw_kk_ins2_cstm_g19.mdl", pos = Vector(), angle = Angle(), size = Vector(1), merge = true, hideVM = true, material = "models/weapons/glock/blacker/glock"},

		["kk_ins2_g19_skin2"] = {model = "models/weapons/v_cw_kk_ins2_cstm_g19.mdl", pos = Vector(), angle = Angle(), size = Vector(1), merge = true, hideVM = true, material = "models/weapons/glock/tt/glock"},

		["kk_ins2_g19_skin3"] = {model = "models/weapons/v_cw_kk_ins2_cstm_g19.mdl", pos = Vector(), angle = Angle(), size = Vector(1), merge = true, hideVM = true, material = "models/weapons/glock/ss/glock"},



		["kk_ins2_cstm_leupold_dpp"] = {model = "models/weapons/attachments/kk_leupold_dpp.mdl", pos = Vector(-0.0936, -2.5031, 0.0545), angle = Angle(), size = Vector(1, 1, 1), bone = "Slide"},

	}



	SWEP.AttachmentModelsWM = {

		["kk_ins2_suppressor_pistol"] = {model = "models/weapons/upgrades/w_sil_pistol.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_mag_g19_15"] = {model = "models/weapons/upgrades/w_magazikk_makag19_8.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_mag_g19_22"] = {model = "models/weapons/upgrades/w_magazikk_makag19_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(0, 180, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_m6x"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_g19_skin"] = {model = "models/weapons/w_cw_kk_ins2_cstm_g19.mdl", pos = Vector(), angle = Angle(), size = Vector(1), merge = true, hideVM = true, material = "models/weapons/glock/blacker/glock"},

		["kk_ins2_g19_skin2"] = {model = "models/weapons/w_cw_kk_ins2_cstm_g19.mdl", pos = Vector(), angle = Angle(), size = Vector(1), merge = true, hideVM = true, material = "models/weapons/glock/tt/glock"},

		["kk_ins2_g19_skin3"] = {model = "models/weapons/w_cw_kk_ins2_cstm_g19.mdl", pos = Vector(), angle = Angle(), size = Vector(1), merge = true, hideVM = true, material = "models/weapons/glock/ss/glock"},

	}



	SWEP.IronsightPos = Vector(-1.9772, 0, 0.3214)

	SWEP.IronsightAng = Vector(0.4361, 0.0414, 0)



	SWEP.KKINS2CSTMLDPPPos = Vector(-1.9882, 0, -0.0882)

	SWEP.KKINS2CSTMLDPPAng = Vector(0.0025, 0.0072, 0)



	SWEP.CustomizationMenuScale = 0.01

	SWEP.ReloadViewBobEnabled = false

	SWEP.DisableSprintViewSimulation = true

end



SWEP.MuzzleEffect = "muzzleflash_m9_1p_core"

SWEP.MuzzleEffectWorld = "muzzleflash_m9_3rd"



if CustomizableWeaponry_KK.HOME then

	SWEP.Attachments = {

		{header = "Sight", offset = {800, -400}, atts = {"kk_ins2_cstm_leupold_dpp"}},

		{header = "Barrel", offset = {100, -400}, atts = {"kk_ins2_suppressor_pistol"}},

		{header = "Lasers", offset = {-800, -400}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_m6x"}},

		{header = "Magazine", offset = {-700, 150}, atts = {"kk_ins2_mag_g19_22"}},

		{header = "Texture", offset = {100, 150}, atts = {"kk_ins2_g19_skin", "kk_ins2_g19_skin2", "kk_ins2_g19_skin3"}},

		--["+reload"] = {header = "Ammo", offset = {800, 150}, atts = {"am_magnum", "am_matchgrade"}}

	}

else

	SWEP.Attachments = {

		{header = "Texture", offset = {500, -400}, atts = {"kk_ins2_g19_skin", "kk_ins2_g19_skin2", "kk_ins2_g19_skin3"}},

		{header = "Barrel", offset = {-500, -400}, atts = {"kk_ins2_suppressor_pistol"}},

		{header = "Lasers", offset = {-500, 150}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_m6x"}},

		{header = "Magazine", offset = {500, 150}, atts = {"kk_ins2_mag_g19_22"}},

		--["+reload"] = {header = "Ammo", offset = {500, 500}, atts = {"am_magnum", "am_matchgrade"}}

	}

end



SWEP.Animations = {

	base_pickup = "base_ready",

	base_draw = "base_draw",

	base_draw_empty = "empty_draw",

	base_fire = {"base_fire","base_fire2","base_fire3"},

	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3"},

	base_fire_last = "base_firelast",

	base_fire_last_aim = "iron_fire_last",

	base_fire_empty = "iron_dryfire",

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

	base_safe_empty = "empty_down",

	base_safe_aim = "iron_down",

	base_safe_empty_aim = "empty_iron_down",

	base_crawl = "base_crawl",

	base_crawl_empty = "empty_crawl",

}



SWEP.SpeedDec = 10



SWEP.Slot = 1

SWEP.SlotPos = 0

SWEP.NormalHoldType = "revolver"

SWEP.RunHoldType = "normal"

SWEP.FireModes = {"semi"}

SWEP.Base = "cw_kk_ins2_base"

SWEP.Category = "CW 2.0 KK INS2 EXT"



SWEP.Author			= "Spy"

SWEP.Contact		= ""

SWEP.Purpose		= ""

SWEP.Instructions	= ""



SWEP.ViewModelFOV	= 80

SWEP.ViewModelFlip	= false

SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_cstm_g19.mdl"

SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_cstm_g19.mdl"



SWEP.WMPos = Vector(5.309, 1.623, -1.821)

SWEP.WMAng = Vector(-3, -5, 180)



SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)



SWEP.Primary.ClipSize		= 15 // 22 ext

SWEP.Primary.DefaultClip = 0 --	= 0

SWEP.Primary.Automatic		= false

SWEP.Primary.Ammo			= "Pistol"



SWEP.KK_INS2_EmptyIdle = true

SWEP.CanRestOnObjects = false

SWEP.WeaponLength = 16



SWEP.FireSound = "CW_KK_INS2_CSTM_G19_FIRE"

SWEP.FireSoundSuppressed = "CW_KK_INS2_CSTM_G19_FIRE_SUPPRESSED"



SWEP.FireDelay = 60/285

SWEP.Recoil = 1.1

SWEP.HipSpread = 0.034

SWEP.AimSpread = 0.012

SWEP.VelocitySensitivity = 1.2

SWEP.MaxSpreadInc = 0.04

SWEP.SpreadPerShot = 0.01

SWEP.SpreadCooldown = 0.22

SWEP.Shots = 1

SWEP.Damage = 45



SWEP.FirstDeployTime = 1.3

SWEP.DeployTime = 0.4

SWEP.HolsterTime = 0.4



SWEP.MuzzleVelocity = 381



SWEP.ReloadTimes = {

	base_reload = {2, 2.65},

	base_reloadempty = {2, 2.65},

	base_reload_extmag = {2, 2.65},

	base_reloadempty_extmag = {2, 2.65},

}



if CLIENT then

	function SWEP:updateStandardParts()

		self:setElementActive("kk_ins2_mag_g19_15", !self.ActiveAttachments.kk_ins2_mag_g19_22)

	end

end



