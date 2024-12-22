--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_cobra/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_cobra/shared.lua
--]]
if not CustomizableWeaponry then return end



AddCSLuaFile()

AddCSLuaFile("sh_sounds.lua")

AddCSLuaFile("sh_soundscript.lua")

include("sh_sounds.lua")

include("sh_soundscript.lua")



if CLIENT then

	SWEP.DrawCrosshair = false

	SWEP.PrintName = "King Cobra"

	SWEP.CSMuzzleFlashes = true

	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/cobra.png" )



	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/kingcobra")



	SWEP.Shell = "KK_INS2_762x33"

	SWEP.NoShells = true

	SWEP.ShellScale = 2

	SWEP.Shell2 = "KK_INS2_REVOLVER"



	SWEP.AttachmentModelsVM = {

		-- ["kk_ins2_optic_rail"] = {model = "models/v_fas2_leupold_mounts.mdl", bone = "Weapon", pos = Vector(0, -1.895, 3.381), angle = Angle(0, -90, 0), size = Vector(1.8, 1.8, 1.8), bodygroups = {6},

			-- material = "models/weapons/view/pistols/ragingbull/ragingbullmount",

		-- },



		["kk_ins2_revolver_mag"] = {model = "models/weapons/upgrades/a_cobraloader_rev.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_counter"] = {model = "models/weapons/stattrack_cut.mdl", bone = "Weapon", pos = Vector(0.31, -0.57, 0.347), angle = Angle(0, -90, 0), size = Vector(0.4, 0.449, 0.449)},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_mak.mdl", bone = "Weapon", pos = Vector(0, 2.588, -0.066), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_mak.mdl", bone = "Weapon", pos = Vector(0, 2.588, -0.066), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},



		-- ["kk_holosight"] = {model = "models/weapons/attachments/c_cw_kk_holosight.mdl", bone = "Weapon", pos = Vector(0.028, -1.219, -1.505), angle = Angle(0, -90, 0), size = Vector(0.75, 0.75, 0.75)},

	}



	SWEP.AttachmentModelsWM = {

		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_mak.mdl", pos = Vector(10.3093, -1.804, 1.3029), angle = Angle(-2.9683, 6.6904, 0), size = Vector(1, 1, 1), bone = "R Hand"},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_mak.mdl", pos = Vector(10.3093, -1.804, 1.3029), angle = Angle(-2.9683, 6.6904, 0), size = Vector(1, 1, 1), bone = "R Hand"},

	}



	SWEP.IronsightPos = Vector(-1.8503, 0, -0.1013)

	SWEP.IronsightAng = Vector(0, 0.0104, 0)



	SWEP.KKFAS2HolosightPos = Vector(-1.8426, -2, -1.4575)

	SWEP.KKFAS2HolosightAng = Vector(0.2617, 0, 0)



	SWEP.CustomizationMenuScale = 0.01



	SWEP.SprintAnimSpeed = 1.1

	SWEP.ReloadViewBobEnabled = false

	SWEP.DisableSprintViewSimulation = true

	SWEP.HUD_MagText = "CYLINDER: "

end



SWEP.MuzzleEffect = "muzzleflash_m9_1p_core"

SWEP.MuzzleEffectWorld = "muzzleflash_m9_3rd"



if CustomizableWeaponry_KK.HOME == nil then

	SWEP.Attachments = {

		{header = "Lasers", offset = {-400, -400}, atts = {"kk_ins2_lam", "kk_ins2_flashlight"}},

		{header = "Reload Aid", offset = {500, -400}, atts = {"kk_ins2_revolver_mag"}},

		--["+reload"] = {header = "Ammo", offset = {500, 150}, atts = {"am_magnum", "am_matchgrade"}}

	}

else

	-- SWEP.Attachments = {

		-- {header = "Sigh", offset = {500, -400}, atts = {"kk_holosight"}},

		-- {header = "Lasers", offset = {-400, -400}, atts = {"kk_ins2_lam", "kk_ins2_flashlight"}},

		-- {header = "Reload Aid", offset = {-400, 150}, atts = {"kk_ins2_revolver_mag"}},

		-- {header = "CSGO", offset = {1000, 150}, atts = {"kk_counter"}},

		-- --["+reload"] = {header = "Ammo", offset = {500, 150}, atts = {"am_magnum", "am_matchgrade"}}

	-- }



	SWEP.Attachments = {

		{header = "Lasers", offset = {-400, -400}, atts = {"kk_ins2_lam", "kk_ins2_flashlight"}},

		{header = "Reload Aid", offset = {500, -400}, atts = {"kk_ins2_revolver_mag"}},

		{header = "CSGO", offset = {-400, 150}, atts = {"kk_counter"}},

		--["+reload"] = {header = "Ammo", offset = {500, 150}, atts = {"am_magnum", "am_matchgrade"}}

	}

end



SWEP.Animations = {

	base_reload_start = "base_reload_start",

	base_reload_start_empty = "base_reload_start",

	base_insert = "base_reload_insert",

	base_reload_end = "base_reload_end",

	base_reload_end_empty = "base_reload_end",



	base_pickup = "base_ready",

	base_draw = "base_draw",

	base_fire = {"base_fire","base_fire2"},

	base_fire_aim = "iron_fire",

	base_fire_empty = "base_dryfire",

	base_fire_empty_aim = "iron_dryfire",

	base_reload = "base_reload_speed",

	base_reload_empty = "base_reload_speed",

	base_idle = "base_idle",

	base_holster = "base_holster",

	base_sprint = "base_sprint",

	base_safe = "base_down",

	base_safe_aim = "iron_down",

	base_crawl = "base_crawl",

}



SWEP.SpeedDec = 10



SWEP.Slot = 1

SWEP.SlotPos = 1

SWEP.NormalHoldType = "revolver"

SWEP.RunHoldType = "normal"

SWEP.FireModes = {"semi"}

SWEP.Base = "cw_kk_ins2_base_main"

SWEP.Category = "CW 2.0 KK INS2 EXT"



SWEP.Author			= "Spy"

SWEP.Contact		= ""

SWEP.Purpose		= ""

SWEP.Instructions	= ""



SWEP.ViewModelFOV	= 80

SWEP.ViewModelFlip	= false

SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_cstm_cobra.mdl"

SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_cstm_cobra.mdl"



SWEP.WMPos = Vector(5.309, 1.623, -1.616)

SWEP.WMAng = Vector(-3, -5, 180)



SWEP.Spawnable			= true

SWEP.AdminSpawnable		= true



SWEP.Primary.ClipSize		= 6

SWEP.Primary.DefaultClip = 0 --	= 0

SWEP.Primary.Automatic		= false

SWEP.Primary.Ammo			= "Revolver"



SWEP.FireDelay = 0.6

SWEP.FireSound = "CW_KK_INS2_CSTM_COBRA_FIRE"

SWEP.FireSoundSuppressed = "CW_KK_INS2_REVOLVER_FIRE_SUPPRESSED"

SWEP.Recoil = 3.25



SWEP.HipSpread = 0.039

SWEP.AimSpread = 0.008

SWEP.VelocitySensitivity = 1.35

SWEP.MaxSpreadInc = 0.06

SWEP.SpreadPerShot = 0.02

SWEP.SpreadCooldown = 0.25

SWEP.Shots = 1

SWEP.Damage = 90



SWEP.FirstDeployTime = 2.5

SWEP.DeployTime = 0.4

SWEP.HolsterTime = 0.5



SWEP.CanRestOnObjects = false

SWEP.Chamberable = false

SWEP.WeaponLength = 16



SWEP.MuzzleVelocity = 470



SWEP.ReloadTimes = {

	base_reload_start = {1.6, 2.36, KK_INS2_REVOLVER_SLOW_UNLOAD},

	base_reload_insert = {0.4, 0.98},

	base_reload_end = {1.74, 1.74},

	base_reload_speed = {3.6, 4.2, KK_INS2_REVOLVER_SPEED_UNLOAD, 54/33.5},

}



function SWEP:IndividualInitialize()

	self.magType = "NONE"

	self.ShotgunReload = true



	if CLIENT then

		self:setBodygroup(1, self:Clip1())

		self:setBodygroup(2, self:Clip1())

	end

end



