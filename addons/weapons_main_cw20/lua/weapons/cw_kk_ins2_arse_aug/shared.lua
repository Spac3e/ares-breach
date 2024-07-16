--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_arse_aug/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_arse_aug/shared.lua
--]]
if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_soundscript.lua")
include("sh_soundscript.lua")

SWEP.magType = "arMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "STG-77"
	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/aug")

	SWEP.Shell = "KK_INS2_556x45"

	SWEP.AttachmentModelsVM = {
		["kk_ins2_optic_iron"] = {model = "models/weapons/aug/a_aug_standard.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_optic_rail"] = {model = "models/weapons/aug/a_aug_rail.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["std_barrel"] = {model = "models/weapons/aug/a_aug_standardbarrel.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_hoovy"] = {model = "models/weapons/aug/a_aug_heavybarrel.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/a_suppressor_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_lam"] = {model = "models/weapons/upgrades/insguns_a_auglaser.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/insguns_a_augflash.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["std_mag"] = {model = "models/weapons/aug/a_augmag.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["ext_mag"] = {model = "models/weapons/aug/a_augextmag.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

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
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_optic_iron"] = {model = "models/weapons/aug/w_augscope.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_optic_rail"] = {model = "models/weapons/aug/w_augrail.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["handguardStandard"] = {model = "models/weapons/upgrades/w_standard_aks74u.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/w_sil_ins1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_vertgrip"] = {model = "models/weapons/upgrades/w_foregrip_aks74u.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_gl_gp25"] = {model = "models/weapons/upgrades/w_gp25.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

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

	SWEP.IronsightPos = Vector(-2.7721, -3, 0.7476)
	SWEP.IronsightAng = Vector(0, 0, 0)

	SWEP.KKINS2KobraPos = Vector(-2.0164, -2, -0.6267)
	SWEP.KKINS2KobraAng = Vector()

	SWEP.KKINS2EoTechPos = Vector(-2.0297, -2, -0.5256)
	SWEP.KKINS2EoTechAng = Vector()

	SWEP.KKINS2AimpointPos = Vector(-2.029, -2, -0.5172)
	SWEP.KKINS2AimpointAng = Vector()

	SWEP.KKINS2ElcanPos = Vector(-2.0241, -2, -0.6341)
	SWEP.KKINS2ElcanAng = Vector()

	SWEP.KKINS2PO4Pos = Vector(-1.9663, -2, -0.429)
	SWEP.KKINS2PO4Ang = Vector()

	SWEP.KKINS2MagnifierPos = Vector(-2.0197, -2, -0.5329)
	SWEP.KKINS2MagnifierAng = Vector()

	SWEP.CustomizationMenuScale = 0.0145
end

SWEP.MuzzleEffect = "muzzleflash_m16_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_m16_3rd"

SWEP.Attachments = {
	{header = "Sight", offset = {400, -500}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},
	{header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_suppressor_sec", "kk_ins2_hoovy"}},
	-- {header = "Under", offset = {-500, -100}, atts = {"kk_ins2_vertgrip"}},
	{header = "Lasers", offset = {0, 300}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},
	{header = "More Sight", offset = {1000, -50}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
	["+use"] = {header = "Sight Contract", offset = {400, -50}, atts = {"kk_ins2_sights_cstm"}},
	--["+reload"] = {header = "Ammo", offset = {700, 400}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire", "base_fire_2"},
	base_fire_aim = {"iron_fire_a","iron_fire_b"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",

	-- foregrip_pickup = "foregrip_ready",
	-- foregrip_draw = "foregrip_draw",
	-- foregrip_fire = "foregrip_fire",
	-- foregrip_fire_aim = {"foregrip_iron_fire", "foregrip_iron_fire_2"},
	-- foregrip_fire_empty = "foregrip_dryfire",
	-- foregrip_fire_empty_aim = "foregrip_iron_dryfire_b",
	-- foregrip_reload = "foregrip_reload",
	-- foregrip_reload_empty = "foregrip_reloadempty",
	-- foregrip_idle = "foregrip_holster",
	-- foregrip_holster = "foregrip_holster",
	-- foregrip_firemode = "foregrip_fireselect",
	-- foregrip_firemode_aim = "foregrip_iron_fireselect",
	-- foregrip_sprint = "foregrip_sprint",
	-- foregrip_safe = "foregrip_down",
	-- foregrip_safe_aim = "foregrip_iron_down",
	-- foregrip_crawl = "foregrip_crawl",
}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 AR"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/aug/v_aug.mdl"
SWEP.WorldModel		= "models/weapons/aug/w_aug.mdl"

SWEP.WMPos =Vector(5.524, 0.66, -1.188)
SWEP.WMAng = Angle(-10, 0, 180)

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip = 0 --	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.FireDelay = 60/675
SWEP.FireSound = "CW_KK_INS2_M4A1_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_M4A1_FIRE_SUPPRESSED"

SWEP.Recoil = 1.2
SWEP.HipSpread = 0.043
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 19

SWEP.FirstDeployTime = 1.5
SWEP.DeployTime = 0.5
SWEP.HolsterTime = 0.4

SWEP.WeaponLength = 20

SWEP.ReloadTimes = {
	base_reload = {2.6, 3.5},
	base_reloadempty = {2.2, 3.9},
	foregrip_reload = {2.6, 3.5},
	foregrip_reloadempty = {2.2, 3.9}
}

SWEP.MuzzleVelocity = 970

if CLIENT then
	function SWEP:updateOtherParts()
		self:setElementActive("std_barrel", !self.ActiveAttachments.kk_ins2_hoovy)
	end
end


