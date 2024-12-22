--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_usa/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1903A3 Springfield"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_springfield")

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.ShellDelay = 0
	SWEP.NoShells = true

	SWEP.BackupSights = {}

	SWEP.AttachmentModelsVM = {
		-- ["kek"] = {model = "models/weapons/v_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true, hideVM = true},

		["sleeve"] = {model = "models/weapons/upgrades/a_clothwrap_springfield.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_optic_iron"] = {model = "models/weapons/upgrades/a_iron_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["bolt_scope"] = {model = "models/weapons/upgrades/a_bolt_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["bolt_iron"] = {model = "models/weapons/upgrades/a_bolt_springfield_ext.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_ww2_stripper"] = {model = "models/weapons/upgrades/a_springfield_stripper_clip.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/a_springfield_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_gl_m7"] = {model = "models/weapons/upgrades/a_springfield_gl.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_m73"] = {model = "models/weapons/upgrades/a_optic_springfield.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_scope_u8x"] = {model = "models/weapons/upgrades/a_optic_springfield_7x.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["sleeve"] = {model = "models/weapons/upgrades/w_clothwrap_springfield.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_optic_iron"] = {model = "models/weapons/upgrades/w_iron_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/w_garand_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_gl_m7"] = {model = "models/weapons/upgrades/w_springfield_gl.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_m73"] = {model = "models/weapons/upgrades/w_optic_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_scope_u8x"] = {model = "models/weapons/upgrades/w_optic_springfield.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.ForegripOverridePos = {
		none = {
			["a_underbarrel"] = {pos = Vector(), angle = Angle()},
			["gl_base"] = {pos = Vector(), angle = Angle()},
		},

		gl = {
			["A_Underbarrel"] = {pos = Vector(1.6, 0.5, 0), angle = Angle(-90, -90, 0)},
			["gl_base"] = {pos = Vector(-7.5, 4.55, 0.3), angle = Angle()},
		}
	}

	SWEP.ForegripParent = "none"
	SWEP.ForegripOverride = true

	SWEP.IronsightPos = Vector(-2.5643, -3, 1.3156)
	SWEP.IronsightAng = Vector(-0.03, 0.03, 0)

	SWEP.KKINS2ScopeM73Pos = Vector(-2.5631, -3, 1.2384)
	SWEP.KKINS2ScopeM73Ang = Vector()

	SWEP.KKINS2ScopeU8XPos = Vector(-2.57, -4, 1.1622)
	SWEP.KKINS2ScopeU8XAng = Vector(0, 0, 0)

	SWEP.M203Pos = Vector(-2.6856, 0, 5.5299)
	SWEP.M203Ang = Vector(-8.6177, 0.0383, 0)

	SWEP.CustomizationMenuScale = 0.017
end

SWEP.MuzzleEffect = "muzzleflash_sniper_npc"
SWEP.MuzzleEffectWorld = "muzzleflash_sniper_npc"

SWEP.Attachments = {
	{header = "Sight", offset = {600, -500}, atts = {
		"kk_ins2_scope_m73",
		"kk_ins2_scope_u8x",
	}, exclusions = {[
		"kk_ins2_ww2_stripper"] = true
	}},

	{header = "Barrel", offset = {-200, -500}, atts = {"kk_ins2_ww2_knife", "kk_ins2_gl_m7"}},
	{header = "Stock", offset = {1000, 0}, atts = {"kk_ins2_ww2_sling"}},

	{header = "Clip", offset = {300, 0}, atts = {"kk_ins2_ww2_stripper"}, exclusions = {
		["kk_ins2_scope_m73"] = true,
		["kk_ins2_scope_u8x"] = true
	}},

	{header = "Inside", offset = {-400, 0}, atts = {"kk_ins2_ww2_bolt"}},

	{header = "Flavor", offset = {0, 500}, atts = {"kk_ins2_bs"}},
	-- {header = "More Sight", offset = {1200, 0}, atts = {"kk_ins2_magnifier"}, dependencies = CustomizableWeaponry_KK.ins2.magnifierDependencies},
	----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
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
	-- base_reload_start_empty = "base_reload_start",
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
	base_sprint_knife_empty	= "base_sprint_bayonet_empty",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "base_down_empty",
	base_safe_empty_aim = "iron_down_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash_empty",
	-- base_melee = "base_melee",
	base_stab = "base_melee_end",
	-- base_melee_empty = "base_melee_empty",
	base_stab_empty = "base_melee_end_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",

	gl_off_pickup = "base_ready",
	gl_off_draw = "base_draw",
	gl_off_draw_empty = "base_draw_empty",
	gl_off_fire = "base_fire_start",
	gl_off_fire_aim = "iron_fire_start",
	gl_off_fire_last = "base_fire_last",
	gl_off_fire_last_aim = "iron_fire_last",
	gl_off_fire_empty = "base_dryfire",
	gl_off_fire_empty_aim = "iron_dryfire",
	gl_off_bolt = "base_fire_end",
	gl_off_bolt_aim = "iron_fire_end",
	gl_off_reload_stripper_1 = "base_reload_clip",
	gl_off_reload_stripper_1_empty = "base_reload_clip_empty",
	gl_off_reload_start = "base_reload_start",
	gl_off_reload_start_empty = "base_reload_start_empty",
	gl_off_insert = "base_reload_insert",
	gl_off_reload_end = "base_reload_end",
	gl_off_reload_end_empty = "base_reload_end",
	gl_off_idle = "base_idle",
	gl_off_idle_empty = "empty_idle",
	gl_off_holster = "base_holster",
	gl_off_holster_empty = "base_holster_empty",
	gl_off_sprint = "base_sprint",
	gl_off_sprint_empty = "base_sprint_empty",
	gl_off_safe = "base_down",
	gl_off_safe_aim = "iron_down",
	gl_off_safe_empty = "base_down_empty",
	gl_off_safe_empty_aim = "iron_down_empty",
	gl_off_melee = "base_melee_bash",
	gl_off_melee_empty = "base_melee_bash_empty",
	gl_off_crawl = "base_crawl",
	gl_off_crawl_empty = "base_crawl_empty",

	gl_on_draw = "glsetup_draw",
	gl_on_draw_empty = "glsetup_draw_empty",
	gl_on_fire = "glsetup_fire",
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
	gl_on_safe_aim = "glsetup_iron_down",
	gl_on_safe_empty = "glsetup_down_empty",
	gl_on_safe_empty_aim = "glsetup_iron_down_empty",
	gl_on_crawl = "glsetup_crawl",
	gl_on_crawl_empty = "glsetup_crawl_empty",

	gl_turn_on_full = "glsetup_in",
	gl_turn_on = "glsetup_in",
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
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_springfield.mdl"
SWEP.WorldModel		= "models/weapons/w_springfield.mdl"

SWEP.WMPos = Vector(14, 0, -2)
SWEP.WMAng = Vector(-10, 2, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_springfield.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip = 0 --	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "AR2"

SWEP.FireDelay = 0.3
SWEP.FireSound = "CW_KK_INS2_DOI_SPRING_FIRE"
SWEP.Recoil = 2.5

SWEP.HipSpread = 0.075
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 2.5
SWEP.MaxSpreadInc = 0.2
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 1.7
SWEP.Shots = 1
SWEP.Damage = 61

SWEP.FirstDeployTime = 3.7
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.SnapToIdlePostReload = false

SWEP.Chamberable = false
SWEP.SnapToIdlePostReload = false
SWEP.ShotgunReload = true
SWEP.ReticleInactivityPostFire = SWEP.FireDelay + 0.2
SWEP.GlobalDelayOnShoot = SWEP.FireDelay

SWEP.KK_INS2_EmptyIdle = true
SWEP.KK_INS2_EmptyIdleGL = true
SWEP.WeaponLength = 38

SWEP.MuzzleVelocity = 854

SWEP.ReloadTimes = {
	base_fire_end = {20/35, 1.49},
	iron_fire_end = {18/35, 1.49},

	base_reload_clip = {2.6, 4.7, KK_INS2_STRIPPERCLIP_UNLOAD_ONE, 27/33.4},
	base_reload_clip_empty = {2.6, 4.7},
	base_reload_start = {29/34.5, 1.25, KK_INS2_SHOTGUN_UNLOAD_ONE},
	base_reload_start_empty = {1.25, 1.25},
	base_reload_insert = {20/37.2, 0.99},
	base_reload_end = {1.45, 1.45},

	glsetup_reload = {2.1, 5.46},

	glsetup_in = {2.1, 3.6},
	glsetup_out = {1.6, 3.7},
	glsetup_out_empty = {1.7, 1.7},

	base_melee_bash = {0.3, 0.9},
	base_melee_bash_empty = {0.3, 0.9},
}

if CLIENT then
	function SWEP:updateStandardParts()
		local scope = self:getActiveAttachmentInCategory(1) != nil
		self:setElementActive("bolt_iron", !scope)
		self:setElementActive("bolt_scope", scope)

		-- self:setElementActive("sleeve", self.ActiveAttachments.kk_ins2_scope_m73)

		self.AttachmentModelsVM.sleeve.nodraw =
			self.ActiveAttachments.kk_ins2_scope_u8x
	end
end

if CLIENT then
	function SWEP:canAimGL()
		return !(self.ActiveAttachments.kk_ins2_scope_m73 or self.ActiveAttachments.kk_ins2_scope_u8x)
	end
end
