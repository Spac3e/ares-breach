--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_machinegun_m60/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "lmgBox"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M60"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15
	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/m60.png" )

	SWEP.NoShells = true

	SWEP.Shell = "KK_INS2_556x45"
	SWEP.ShellEjectVelocity = 50

	SWEP.Shell2 = "KK_INS2_556x45_link"
	SWEP.Shell2Scale = 0.7
	SWEP.Shell2EjectVelocity = 50
	SWEP.Shell2ViewAttachmentID = 4
	SWEP.Shell2ViewAngleAlign = {Forward = 0, Right = 0, Up = -90}
	SWEP.Shell2WorldAngleAlign = {Forward = 0, Right = 0, Up = -90}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/a_suppressor_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_counter"] = {model = "models/weapons/stattrack.mdl", bone = "Weapon", pos = Vector(0.026, -7.77, 4.057), angle = Angle(0, 0, 50), size = Vector(0.699, 0.699, 0.699)},
		["kk_textbox"] = {model = "models/weapons/uid.mdl", bone = "LidCont", pos = Vector(0.441, -5.015, -0.156), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},

		["kk_counter_mag"] = {model = "models/weapons/stattrack.mdl", bone = "Magazine", rel = "", pos = Vector(1.149, -0.976, 1.919), angle = Angle(), size = Vector(0.4, 0.4, 0.4)},

		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_band.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_magnifier"] = {model = "models/weapons/upgrades/a_optic_aimp2x.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_aimpoint"] = {model = "models/weapons/upgrades/a_optic_aimpoint.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_elcan"] = {model = "models/weapons/upgrades/a_optic_elcan_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},
		["kk_ins2_eotech"] = {model = "models/weapons/upgrades/a_optic_eotech.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_kobra"] = {model = "models/weapons/upgrades/a_optic_kobra.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_po4"] = {model = "models/weapons/upgrades/a_optic_po4x24_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},

		["kk_ins2_cstm_cmore"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_cmore.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_compm4s"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_compm4s.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_microt1"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_microt1.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_acog"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_acog_m.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, retSizeMult = 0.85},
		["kk_ins2_cstm_barska"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_barska.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_cstm_eotechxps"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_eotechxps.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["fas2"] = {model = "models/gmod4phun/60rndmag.mdl", bone = "Weapon", pos = Vector(1.47, 1.057, 2.095), angle = Angle(45, 0, 0), size = Vector(0.779, 0.779, 0.779)},
		-- ["fas2"] = {model = "models/gmod4phun/60rndmag.mdl", bone = "Magazine", pos = Vector(1.294, 1.832, 2.471), angle = Angle(45, 0, 0), size = Vector(0.779, 0.779, 0.779)},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_suppressor_sec"] = {model = "models/weapons/upgrades/w_sil_pistol.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

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

	SWEP.CustomizePos = Vector(4.488, -1.627, -0.821)
	SWEP.CustomizeAng = Vector(17.009, 29.971, 16.669)

	SWEP.IronsightPos = Vector( -2.0484, 0, 0 )
	SWEP.IronsightAng = Vector(0, 0.03, 0)

	SWEP.KKINS2KobraPos = Vector( -2.0484, -2, -0.55 )
	SWEP.KKINS2KobraAng = Vector()

	SWEP.KKINS2EoTechPos = Vector( -2.0484, -2, -0.63 )
	SWEP.KKINS2EoTechAng = Vector()

	SWEP.KKINS2AimpointPos = Vector( -2.0484, -2, -0.63 )
	SWEP.KKINS2AimpointAng = Vector()

	SWEP.KKINS2ElcanPos = Vector( -2.0484, -2, -0.63 )
	SWEP.KKINS2ElcanAng = Vector()

	SWEP.KKINS2PO4Pos = Vector( -2, -2, -0.4 )
	SWEP.KKINS2PO4Ang = Vector()

	SWEP.KKINS2MagnifierPos = Vector(-2.0063, -1, 0.0037)
	SWEP.KKINS2MagnifierAng = Vector()

	SWEP.KKINS2CSTMCMorePos = Vector(-2.0484, 0, -0.63)
	SWEP.KKINS2CSTMCMoreAng = Vector()

	SWEP.KKINS2CSTMBarskaPos = Vector(-2.0484, 0, -0.63)
	SWEP.KKINS2CSTMBarskaAng = Vector()

	SWEP.KKINS2CSTMMicroT1Pos = Vector(-2.0484, 0, -0.63)
	SWEP.KKINS2CSTMMicroT1Ang = Vector()

	SWEP.KKINS2CSTMEoTechXPSPos =  Vector(-2.0484, 0, -0.63)
	SWEP.KKINS2CSTMEoTechXPSAng = Vector()

	SWEP.KKINS2CSTMCompM4SPos =  Vector(-2.0484, 0, -0.63)
	SWEP.KKINS2CSTMCompM4SAng = Vector()

	SWEP.KKINS2CSTMACOGPos =  Vector(-2.0484, 0, -0.63)
	SWEP.KKINS2CSTMACOGAng = Vector()

	SWEP.CustomizationMenuScale = 0.02
end

SWEP.MuzzleEffect = "weapon_muzzle_flash_smg"
SWEP.MuzzleEffectWorld = "weapon_muzzle_flash_smg"

SWEP.Attachments = {
	{header = "Sight", offset = {400, -500}, atts = {"kk_ins2_kobra", "kk_ins2_eotech", "kk_ins2_aimpoint", "kk_ins2_elcan", "kk_ins2_po4", "kk_ins2_cstm_cmore", "kk_ins2_cstm_barska", "kk_ins2_cstm_microt1", "kk_ins2_cstm_eotechxps", "kk_ins2_cstm_compm4s", "kk_ins2_cstm_acog"}},
	{header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_suppressor_sec"}},
	{header = "Lasers", offset = {-400, 0}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},
	{header = "More Sight", offset = {1000, 0}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
	["+use"] = {header = "Sight Contract", offset = {400, 0}, atts = {"kk_ins2_sights_cstm"}},
	--["+reload"] = {header = "Ammo", offset = {200, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

if CustomizableWeaponry_KK.HOME then
	table.insert(SWEP.Attachments, {header = "Skill1", offset = {2100, -600}, atts = {"kk_aimbot"}})
	table.insert(SWEP.Attachments, {header = "Skill2", offset = {2100, -200}, atts = {"kk_wallhaq"}})
	table.insert(SWEP.Attachments, {header = "CSGO", offset = {2100, 200}, atts = {"kk_counter"}})
	table.insert(SWEP.Attachments, {header = "CSGO", offset = {2100, 600}, atts = {"kk_textbox"}})
end

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = {"base_fire_1","base_fire_2","base_fire_3"},
	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3","iron_fire_4"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_close = "base_reload_half",
	base_reload_empty = "base_reload_empty",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",

	bipod_in = "deployed_in",
	bipod_fire = {"deployed_fire_1","deployed_fire_2"},
	bipod_fire_aim = {"deployed_iron_fire_1","deployed_iron_fire_2"},
	bipod_fire_empty = "deployed_dryfire",
	bipod_fire_empty_aim = "deployed_iron_dryfire",
	bipod_reload = "deployed_reload",
	bipod_reload_close = "deployed_reload_half",
	bipod_reload_empty = "deployed_reload_empty",
	bipod_out = "deployed_out",
}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "smg"
SWEP.RunHoldType = "smg"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW BREACH"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_cultist/m60/v_m60.mdl"
SWEP.WorldModel		= "models/weapons/cw_cultist/m60/w_m60.mdl"

SWEP.WMPos = Vector(5.184, 0.935, -1.03)
SWEP.WMAng = Vector(-10, -1, 180)

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 200
SWEP.Primary.DefaultClip = 0 --	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"

SWEP.FireDelay = 0.09
SWEP.FireSound = "CW_KK_INS2_M60_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_M60_FIRE_SUPPRESSED"
SWEP.Recoil = 1.1975

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.0027
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 50

SWEP.FirstDeployTime = 2.6
SWEP.DeployTime = 0.9
SWEP.HolsterTime = 0.6

SWEP.Chamberable = false
SWEP.BipodInstalled = true
SWEP.WeaponLength = 28

SWEP.MuzzleVelocity = 915

SWEP.ReloadTimes = {
	base_reload = {7.3, 9.5},
	base_reload_half = {8, 9.84},
	base_reload_empty = {9.35, 11},

	deployed_reload = {7.1, 8.77},
	deployed_reload_half = {7.9, 9.5},
	deployed_reload_empty = {8.85, 10.52},
}

SWEP.reloadProgressAnimsRaw = {
	base_reload_close = true,
	bipod_reload_close = true
}

SWEP.reticleInactivityCallbacksRaw = {
	["base_reload_close"] = 0.1,
	["bipod_reload_close"] = 0.1,
}

function SWEP:overrideReloadAnim(prefix, suffix)
	local clip = self:Clip1()

	if clip > 15 then
		return prefix .. "reload" .. suffix
	elseif clip > 0 then
		return prefix .. "reload_close" .. suffix
	end

	return prefix .. "reload_empty" .. suffix
end

if CLIENT then
	CustomizableWeaponry_KK.ins2.welementThink:add("cw_kk_ins2_m249", "bipod")
end

if CLIENT then
	local counterExists = file.Exists("models/weapons/stattrack.mdl", "GAME")

	function SWEP:updateOtherParts()
		self.AttachmentModelsVM.kk_counter_mag.ent._KKCSGONUM = 160904
		self.AttachmentModelsVM.kk_counter_mag.active = counterExists and CustomizableWeaponry_KK.HOME

		-- self.AttachmentModelsVM.kk_counter_mag.active = false
		-- self.AttachmentModelsVM.fas2.active = true
		-- self:setBodygroup(1,0)
		-- self.CW_VM:ManipulateBoneScale(self.CW_VM:LookupBone("Magazine"), Vector(0.01,0.01,0.01))
	end
end
