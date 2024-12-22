--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nazi/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Kar-98k"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.NoShells = true

	SWEP.BackupSights = {
		["kk_ins2_scope_k98"] = {
			Vector(-2.5615, -4, 1.588),
			Vector(0.2652, 0.0073, 0)
		},
		["kk_ins2_scope_zf4"] = {
			Vector(-2.5615, -4, 1.588),
			Vector(0.2652, 0.0073, 0)
		},
		["kk_ins2_scope_zf41"] = {
			Vector(-2.5615, -4, 1.588),
			Vector(0.2652, 0.0073, 0)
		},
	}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/a_kar98k_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["sleeve"] = {model = "models/weapons/upgrades/a_clothwrap_kar98k.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_ww2_stripper"] = {model = "models/weapons/upgrades/a_kar98k_stripper_clip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_gl_ggg"] = {model = "models/weapons/upgrades/a_kar98k_gl.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_k98"] = {model = "models/weapons/upgrades/a_optic_kar98k.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_kar98k.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_k98.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_k98.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_zf4"] = {model = "models/weapons/upgrades/a_optic_kar98k_4x.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_scope_zf41"] = {model = "models/weapons/upgrades/a_optic_kk_zf41.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/w_kar98k_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["sleeve"] = {model = "models/weapons/upgrades/w_clothwrap_kar98k.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true},

		-- ["kk_ins2_gl_ggg"] = {model = "models/weapons/upgrades/w_enfield_gl.mdl", pos = Vector(41.9803, -0.1208, 4.8887), angle = Angle(1.7669, -1.2005, 0), size = Vector(1, 1, 1), bone = "R Hand"},
		["kk_ins2_gl_ggg"] = {model = "models/weapons/upgrades/w_grenade_kar98k.mdl", pos = Vector(0, 0, 0), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), attachment = "muzzle"},

		["kk_ins2_scope_k98"] = {model = "models/weapons/upgrades/w_optic_kar98k.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_zf4"] = {model = "models/weapons/upgrades/w_optic_kar98k.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_zf41"] = {model = "models/weapons/upgrades/w_optic_kar98k.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-2.5615, -4, 1.588)
	SWEP.IronsightAng = Vector(0.2652, 0.0073, 0)

	SWEP.KKINS2ScopeK98Pos = Vector(-2.564, -1.5, 0.3398)
	SWEP.KKINS2ScopeK98Ang = Vector(0.0148, 0.0176, 0)

	SWEP.KKINS2ScopeZF4Pos = Vector(-2.1298, -4, 0.6019)
	SWEP.KKINS2ScopeZF4Ang = Vector(0.0091, 0.0194, 0)

	SWEP.KKINS2ScopeZF41Pos = Vector(-2.5014, -4, 1.0187)
	SWEP.KKINS2ScopeZF41Ang = Vector(0, 0, 0)

	SWEP.M203Pos = Vector(-0.9306, 0, 3.634)
	SWEP.M203Ang = Vector(1.9036, 0, 0)

	SWEP.CustomizationMenuScale = 0.018
end

SWEP.MuzzleEffect = "muzzleflash_sniper_npc"
SWEP.MuzzleEffectWorld = "muzzleflash_sniper_npc"

SWEP.Attachments = {
	{header = "Sight", offset = {600, -500}, atts = {"kk_ins2_scope_zf41", "kk_ins2_scope_zf4", "kk_ins2_scope_k98"}},
	{header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_ww2_knife", "kk_ins2_gl_ggg"}},
	{header = "Stock", offset = {1000, 0}, atts = {"kk_ins2_ww2_sling"}},
	{header = "Clip", offset = {300, 0}, atts = {"kk_ins2_ww2_stripper"}, exclusions = {["kk_ins2_scope_k98"] = true, ["kk_ins2_scope_zf4"] = true}},
	{header = "Inside", offset = {-400, 0}, atts = {"kk_ins2_ww2_bolt"}},
	{header = "Flavor", offset = {0, 500}, atts = {"kk_ins2_bs"}},
	["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.AttachmentExclusions = {
	["kk_ins2_scope_k98"] = {"kk_ins2_ww2_stripper"},
	["kk_ins2_scope_zf4"] = {"kk_ins2_ww2_stripper"}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = "base_fire_start",
	base_fire_aim = "iron_fire_start",
	base_fire_last = "base_fire_last",
	base_fire_last_aim = "iron_fire_last",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_bolt = "base_fire_end",
	base_bolt_aim = "iron_fire_end",
	base_reload_stripper_1 = "base_reload_clip",
	base_reload_stripper_1_empty = "base_reload_clip_empty",
	base_reload_start = "base_reload_start",
	base_reload_start_empty = "base_reload_start_empty",
	base_insert = "base_reload_insert",
	base_reload_end = "base_reload_end",
	base_reload_end_empty = "base_reload_end",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "base_holster_empty",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint_empty",
	base_sprint_knife = "base_sprint_bayonet",
	base_sprint_knife_empty = "base_sprint_bayonet_empty",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "base_down_empty",
	base_safe_empty_aim = "iron_down_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash_empty",
	base_stab = "base_melee_end",
	base_stab_empty = "base_melee_end_empty",

	gl_off_pickup = "gl_ready",
	gl_off_draw = "gl_draw",
	gl_off_draw_empty = "gl_draw_empty",
	gl_off_fire = "gl_fire_start",
	gl_off_fire_aim = "gl_iron_fire_start",
	gl_off_fire_last = "gl_fire_last",
	gl_off_fire_last_aim = "gl_iron_fire_last",
	gl_off_fire_empty = "gl_dryfire",
	gl_off_fire_empty_aim = "gl_iron_dryfire",
	gl_off_bolt = "gl_fire_end",
	gl_off_bolt_aim = "gl_iron_fire_end",
	gl_off_reload_stripper_1 = "gl_reload_clip",
	gl_off_reload_stripper_1_empty = "gl_reload_clip_empty",
	gl_off_reload_start = "gl_reload_start",
	gl_off_reload_start_empty = "gl_reload_start_empty",
	gl_off_insert = "gl_reload_insert",
	gl_off_reload_end = "gl_reload_end",
	gl_off_reload_end_empty = "gl_reload_end",
	gl_off_idle = "gl_holster",
	gl_off_idle_empty = "gl_iron_idle_empty",
	gl_off_holster = "gl_holster",
	gl_off_holster_empty = "gl_holster_empty",
	gl_off_sprint = "gl_sprint",
	gl_off_sprint_empty = "gl_sprint_empty",
	gl_off_safe = "gl_down",
	gl_off_safe_aim = "gl_iron_down",
	gl_off_safe_empty = "gl_down_empty",
	gl_off_safe_empty_aim = "gl_iron_down_empty",
	gl_off_crawl = "gl_crawl",
	gl_off_crawl_empty = "gl_crawl_empty",

	gl_on_draw = "glsetup_draw",
	gl_on_draw_empty = "glsetup_draw_empty",
	gl_on_fire = "glsetup_firelast",
	gl_on_fire_aim = "glsetup_iron_fire",
	gl_on_fire_empty = "glsetup_dryfire",
	gl_on_fire_empty_aim = "glsetup_iron_dryfire",
	gl_on_reload = "glsetup_reload",
	gl_on_idle = "glsetup",
	gl_on_idle_empty = "glsetup_idle_empty",
	gl_on_holster = "glsetup_holster",
	gl_on_holster_empty = "glsetup_holster_empty",
	gl_on_sprint = "glsetup_sprint",
	gl_on_sprint_empty = "glsetup_sprint_empty",
	gl_on_safe = "glsetup_down",
	gl_on_safe_empty = "glsetup_down_empty",
	gl_on_safe_aim = "glsetup_iron_down",
	gl_on_safe_empty_aim = "glsetup_iron_down_empty",
	gl_on_crawl = "glsetup_crawl",
	gl_on_crawl_empty = "glsetup_crawl_empty",

	gl_turn_on_full = "glsetup_in",
	gl_turn_on = "glsetup_in_empty",
	gl_turn_off = "glsetup_out",
	gl_turn_off_empty = "glsetup_out_empty",
}

SWEP.SpeedDec = 40

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ww2tdm"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"bolt"}
SWEP.Base = "cw_kk_ins2_base_main"
SWEP.Category = "(GERMAN) WW2"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_kar98k_oldgl.mdl"
SWEP.WorldModel		= "models/weapons/w_kar98k.mdl"

SWEP.WMPos = Vector(14, 0, -2)
SWEP.WMAng = Vector(-10, 2, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2de
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2de
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip    = 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Sniper"

SWEP.FireDelay = 0.3
SWEP.FireSound = "CW_KK_INS2_DOI_K98_FIRE"
SWEP.Recoil = 9

SWEP.HipSpread = 0.075
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 2.5
SWEP.MaxSpreadInc = 0.2
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 1.6
SWEP.Shots = 1
SWEP.Damage = 80

SWEP.FirstDeployTime = 3.7
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.BipodDeployTime = 1.15
SWEP.BipodUndeployTime = 1.15

SWEP.Chamberable = false
SWEP.SnapToIdlePostReload = false
SWEP.ShotgunReload = true
SWEP.ReticleInactivityPostFire = SWEP.FireDelay + 0.2
SWEP.GlobalDelayOnShoot = SWEP.FireDelay

SWEP.KK_INS2_EmptyIdle = true
SWEP.KK_INS2_EmptyIdleGL = true
SWEP.WeaponLength = 38

SWEP.MuzzleVelocity = 760

SWEP.ReloadTimes = {
	base_fire_end = {20/35, 1.2},
	iron_fire_end = {18/35, 1.4},
	base_reload_clip = {88/35, 4.29, KK_INS2_STRIPPERCLIP_UNLOAD_ONE, 29/35},
	base_reload_clip_empty = {88/35, 4.29},
	base_reload_start = {29/35.5, 1.21, KK_INS2_SHOTGUN_UNLOAD_ONE},
	base_reload_start_empty = {1.21, 1.21},
	base_reload_insert = {19/37.2, 0.99},
	base_reload_end = {1.41, 1.41},

	gl_fire_end = {20/35, 1.2},
	gl_iron_fire_end = {18/35, 1.4},
	gl_reload_clip = {88/35, 4.29, KK_INS2_STRIPPERCLIP_UNLOAD_ONE, 29/35},
	gl_reload_clip_empty = {88/35, 4.29},
	gl_reload_start = {29/35.5, 1.21, KK_INS2_SHOTGUN_UNLOAD_ONE},
	gl_reload_start_empty = {1.21, 1.21},
	gl_reload_insert = {19/37.2, 0.99},
	gl_reload_end = {1.41, 1.41},

	glsetup_reload = {5.4, 6.6},

	glsetup_in = {5.4, 6.6, KK_INS2_RIFLEGL_UNLOAD_ONE, 29/35.5},
	glsetup_in_empty = {5.4, 6.6},
	glsetup_out = {2, 5},
	glsetup_out_empty = {2.2, 2.2},

	base_melee_bash = {0.3, 0.9},
	base_melee_bash_empty = {0.3, 0.9},
}


if CLIENT then
	function SWEP:updateStandardParts()
		--self:setElementActive("sleeve", self.ActiveAttachments.kk_ins2_scope_k98)
		self.AttachmentModelsVM.sleeve.nodraw =
			self.ActiveAttachments.kk_ins2_gl_ggg or
			self.ActiveAttachments.kk_ins2_scope_zf41
	end
end
