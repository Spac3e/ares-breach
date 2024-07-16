--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_galil_ace/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_soundscript.lua")
include("sh_soundscript.lua")

SWEP.magType = "arMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Galil ACE"
	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelMovementScale = 1.15

	-- SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_galil_sar")
	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/galil2.png" )
	SWEP.IconLetter = "b"

	SWEP.Shell = "KK_INS2_556x45"
	SWEP.ShellDelay = 0.06

	local counterExists = file.Exists("models/weapons/stattrack.mdl", "GAME")

	SWEP.AttachmentModelsVM = {
		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/a_suppressor_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_mag_galil_35"] = {model = "models/weapons/upgrades/a_magazine_galil_35.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_galil_75"] = {model = "models/weapons/upgrades/a_magazine_galil_75.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_bipod"] = {model = "models/weapons/upgrades/a_bipod_galil.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/a_foregrip_sec2.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), attachment = "Foregrip"},

		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_magnifier"] = {model = "models/weapons/upgrades/a_optic_aimp2x.mdl", rLight = true, bone = "Weapon", pos = Vector(0.059, -3.7, 2.759), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},

		["kk_ins2_aimpoint"] = {model = "models/weapons/upgrades/a_optic_aimpoint.mdl", bone = "Weapon", pos = Vector(0.059, -4, 2.759), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},

		["kk_ins2_cstm_cmore"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_cmore.mdl", bone = "Weapon", pos = Vector(0.059, -4, 2.759), angle = Angle(), size = Vector(1, 1, 1)},
		["kk_ins2_cstm_barska"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_barska.mdl", bone = "Weapon", pos = Vector(0.059, -2.931, 2.743), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},

	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_mag_galil_35"] = {model = "models/weapons/upgrades/w_magazine_galil_35.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_mag_galil_75"] = {model = "models/weapons/upgrades/w_magazine_galil_75.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/w_sil_sec1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_bipod"] = {model = "models/weapons/upgrades/w_bipod_galil.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/w_ins_foregrip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

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

	SWEP.ForeGripOffsetCycle_Reload_Empty = 0
	SWEP.ForeGripOffsetCycle_Reload = 0
	SWEP.ForeGripOffsetCycle_Draw = 0

	SWEP.ForegripOverridePos = {
		["tweak"] = {
			["Magazine"] = {pos = Vector(0, -0.25, 0), angle = Angle()}
		},
	}

	SWEP.ForegripParent = "tweak"
	SWEP.ForegripOverride = true

	SWEP.IronsightPos = Vector(-2.2208, -2, 0.8355)
	SWEP.IronsightAng = Vector(-0.373, 0.039, 0)

	SWEP.KKINS2CSTMBarskaPos = Vector(-2.2232, -2, -0.0282)
	SWEP.KKINS2CSTMBarskaAng = Vector()

	SWEP.KKINS2AimpointPos = Vector(-2.2321, -1, -0.0275)
	SWEP.KKINS2AimpointAng = Vector()

	SWEP.KKINS2CSTMCMorePos = Vector(-2.2321, -1, -0.0275)
	SWEP.KKINS2CSTMCMoreAng = Vector()

	SWEP.KKINS2MagnifierPos = Vector(-2.2207, -1, -0.0405)
	SWEP.KKINS2MagnifierAng = Vector()

	SWEP.CustomizationMenuScale = 0.016
end

SWEP.MuzzleEffect = "muzzleflash_smg_npc"
SWEP.MuzzleEffectWorld = "muzzleflash_smg_npc"

SWEP.Attachments = {
	{header = "Sight", offset = {300, -600}, atts = {"kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", /*"kk_ins2_cstm_eotechxps", "kk_ins2_eotech", */"kk_ins2_aimpoint", /*"kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"*/}},
	{header = "Barrel", offset = {-200, -600}, atts = {"kk_ins2_suppressor_sec"}},
	{header = "Under", offset = {-500, -150}, atts = {"kk_ins2_bipod", "kk_ins2_vertgrip"}},
	{header = "Lasers", offset = {150, -150}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},
	--{header = "Magazine", offset = {-200, 350}, atts = {"kk_ins2_mag_galil_75"}},
	{header = "More Sight", offset = {1100, -150}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
	--["+reload"] = {header = "Ammo", offset = {1000, 350}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = {"iron_fire_a","iron_fire_b","iron_fire_c"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_mm = "base_reload_drum",
	base_reload_empty = "base_reloadempty",
	base_reload_empty_mm = "base_reloadempty_drum",
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
	foregrip_fire_aim = {"foregrip_iron_fire_a","foregrip_iron_fire_b","foregrip_iron_fire_c"},
	foregrip_fire_empty = "foregrip_dryfire",
	foregrip_fire_empty_aim = "foregrip_iron_dryfire",
	foregrip_reload = "foregrip_reload",
	foregrip_reload_mm = "foregrip_reload_drum",
	foregrip_reload_empty = "foregrip_reloadempty",
	foregrip_reload_empty_mm = "foregrip_reloadempty_drum",
	foregrip_idle = "foregrip_holster",
	foregrip_holster = "foregrip_holster",
	foregrip_firemode = "foregrip_fireselect",
	foregrip_firemode_aim = "foregrip_iron_fireselect",
	foregrip_sprint = "foregrip_sprint",
	foregrip_safe = "foregrip_down",
	foregrip_safe_aim = "foregrip_iron_down",
	foregrip_crawl = "foregrip_crawl",

	bipod_in = "deployed_in",
	bipod_fire = "deployed_fire",
	bipod_fire_aim = {"deployed_iron_fire_a","deployed_iron_fire_b","deployed_iron_fire_c"},
	bipod_fire_empty = "deployed_dryfire",
	bipod_fire_empty_aim = "deployed_iron_dryfire",
	bipod_reload = "deployed_reload",
	bipod_reload_mm = "deployed_reload_drum",
	bipod_reload_empty = "deployed_reload_empty",
	bipod_reload_empty_mm = "deployed_reload_empty_drum",
	bipod_firemode = "deployed_fireselect",
	bipod_firemode_aim = "deployed_iron_fireselect",
	bipod_out = "deployed_out",
}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_galil_ace.mdl"
SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_galil_ace.mdl"

SWEP.WMPos = Vector(5.919, 0.964, -2.055)
SWEP.WMAng = Angle(-10, 0, 180)

SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.gurkha

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.AdminOnly			= true

SWEP.Primary.ClipSize		= 35
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"

SWEP.FireDelay = 60/700
SWEP.FireSound = "CW_KK_INS2_GALIL_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_GALIL_FIRE_SUPPRESSED"
SWEP.Recoil = 1.2

SWEP.HipSpread = 0.043
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 38

SWEP.FirstDeployTime = 2.6
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.WeaponLength = 26

SWEP.MuzzleVelocity = 915

SWEP.ReloadTimes = {					//qc
	base_reload = {70/32.2, 3.5},
	base_reloadempty = {70/32.2, 5},
	base_reload_drum = {116/31.8, 5.5},
	base_reloadempty_drum = {116/31.8, 7.55},

	foregrip_reload = {70/32.2, 3.5},
	foregrip_reloadempty = {70/32.2, 5},
	foregrip_reload_drum = {116/31.8, 5.5},
	foregrip_reloadempty_drum = {116/31.8, 7.55},

	deployed_reload = {70/30, 3.8},
	deployed_reload_empty = {70/30, 5.4},
	deployed_reload_drum = {116/31.8, 5.5},
	deployed_reload_empty_drum = {116/31.8, 7.55},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("kk_ins2_mag_galil_35", !self.ActiveAttachments.kk_ins2_mag_galil_75)
	end
end
