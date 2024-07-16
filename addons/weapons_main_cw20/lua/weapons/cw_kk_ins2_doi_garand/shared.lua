--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_garand/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "m1Clip"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1 Garand"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_m1garand")

	SWEP.NoShells = true

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.ShellEjectVelocity = 150

	SWEP.Shell2 = "KK_INS2_GARAND"
	SWEP.Shell2EjectVelocity = 150
	SWEP.Shell2ViewAngleAlign = {Forward = 0, Right = 30, Up = -90}
	SWEP.Shell2WorldAngleAlign = {Forward = 0, Right = 0, Up = 90}

	SWEP.BackupSights = {
		["kk_ins2_scope_m82"] = {
			Vector(-2.4643, -2, 1.1174),
			Vector(-0.4782, 0.006, 0)
		},
	}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_optic_iron"] = {model = "models/weapons/upgrades/a_iron_garand_l.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},
		["bg_foldsight"] = {model = "models/weapons/upgrades/a_iron_garand_s.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["sleeve"] = {model = "models/weapons/upgrades/a_clothwrap_garand.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/a_garand_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		-- ["kk_ins2_gl_m7"] = {model = "models/weapons/upgrades/a_springfield_gl.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_gl_m7"] = {model = "models/weapons/upgrades/a_garand_gl.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_m82"] = {model = "models/weapons/upgrades/a_optic_garand.mdl", rLight = true, pos = Vector(), angle = Angle(), size = Vector(0.075, 0.075, 0.075), merge = true},
		["kk_ins2_scope_m82_rail"] = {model = "models/weapons/upgrades/a_iron_garand_l.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["kk_was_here_lol"] = {model = "models/weapons/upgrades/a_modkit_m1a1.mdl", pos = Vector(2.3473, -14.2344, 3.829), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), bone = "Weapon", active = true},

		-- ["modbody"] = {model = "models/weapons/v_cw_kk_doi_garand.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true},
		-- ["wood"] = {model = "models/weapons/upgrades/a_standard_garand.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true, rel = "modbody"},
		-- ["raul"] = {model = "models/weapons/upgrades/a_modkit_m1a1.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true, rel = "modbody"},
		-- ["kk_ins2_eotech"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_barska_xl.mdl", pos = Vector(0, 0, 7.95), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), attachment = "optic"},

		-- ["ani_body"] = {model = "models/weapons/v_garand.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kki_body"] = {model = "models/weapons/v_garand.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_garand.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["sleeve"] = {model = "models/weapons/upgrades/w_clothwrap_garand.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_ww2_knife"] = {model = "models/weapons/upgrades/w_garand_bayonet.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["kk_ins2_gl_m7"] = {model = "models/weapons/upgrades/w_springfield_gl.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_scope_m82"] = {model = "models/weapons/upgrades/w_scope_garand.mdl", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-2.4643, -2, 1.1174)
	SWEP.IronsightAng = Vector(-0.4782, 0.006, 0)

	SWEP.FoldSightPos = Vector(-2.4643, -2, 1.1174)
	SWEP.FoldSightAng = Vector(-0.4782, 0.006, 0)

	SWEP.KKINS2ScopeM82Pos = Vector(-1.3779, -3.5, 0.7695)
	SWEP.KKINS2ScopeM82Ang = Vector()

	SWEP.KKINS2EoTechPos = Vector(-2.444, -2, -0.1278)
	SWEP.KKINS2EoTechAng = Vector(0.0096, 0.0097, 0)

	SWEP.M203Pos = Vector(-2.7463, 0, 5.4451)
	SWEP.M203Ang = Vector(-9.1139, 0.0581, 0)

	-- SWEP.M203Pos = Vector(-2.7362, -3, 3.7136)
	-- SWEP.M203Ang = Vector(-8.5227, 0.0134, 0)

	SWEP.CustomizationMenuScale = 0.019
end

SWEP.MuzzleEffect = "muzzleflash_garand_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_garand_3p"

SWEP.SightBGs = {main = 0, foldsight = 0}

SWEP.Attachments = {
	{header = "Sight", offset = {900, -200}, atts = {"bg_foldsight",/* "kk_ins2_eotech",*/ "kk_ins2_scope_m82"}},
	{header = "Barrel", offset = {-300, -200}, atts = {"kk_ins2_ww2_knife", "kk_ins2_gl_m7"}},
	{header = "Stock", offset = {-300, 300}, atts = {"kk_ins2_ww2_sling"}},
	{header = "Flavor", offset = {900, 300}, atts = {"kk_ins2_bs"}},
	--["+reload"] = {header = "Ammo", offset = {350, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = {"base_fire_1","base_fire_2"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	base_fire_last = "base_fire_last",
	base_fire_last_aim = "iron_fire_last",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reloadfull",
	base_reload_empty = "base_reloadempty",
	base_reload_empty_lulz = "base_reloadempty_null",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "base_holster_empty",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint_empty",
	base_sprint_knife = "base_sprint_bayonet",
	base_sprint_knife_empty = "base_sprint_bayonet_empty",
	base_safe = "base_down",
	base_safe_empty = "base_down_empty",
	base_safe_aim = "iron_down",
	base_safe_empty_aim = "iron_down_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash_empty",
	base_stab = "base_melee_end",
	base_stab_empty = "base_melee_end_empty",

	gl_off_pickup = "base_ready",
	gl_off_draw = "base_draw",
	gl_off_draw_empty = "base_draw_empty",
	gl_off_fire = {"base_fire_1","base_fire_2"},
	gl_off_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	gl_off_fire_last = "base_fire_last",
	gl_off_fire_last_aim = "iron_fire_last",
	gl_off_fire_empty = "base_dryfire",
	gl_off_fire_empty_aim = "iron_dryfire",
	gl_off_reload = "base_reloadfull",
	gl_off_reload_empty = "base_reloadempty",
	gl_off_reload_empty_lulz = "base_reloadempty_null",
	gl_off_idle = "base_idle",
	gl_off_idle_empty = "empty_idle",
	gl_off_holster = "base_holster",
	gl_off_holster_empty = "base_holster_empty",
	gl_off_sprint = "base_sprint",
	gl_off_sprint_empty = "base_sprint_empty",
	gl_off_safe = "base_down",
	gl_off_safe_empty = "base_down_empty",
	gl_off_safe_aim = "iron_down",
	gl_off_safe_empty_aim = "iron_down_empty",
	gl_off_crawl = "base_crawl",
	gl_off_crawl_empty = "base_crawl_empty",
	gl_off_melee = "base_melee_bash",
	gl_off_melee_empty = "base_melee_bash_empty",

	gl_on_pickup = "base_ready",
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
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_garand.mdl"
SWEP.WorldModel		= "models/weapons/w_garand.mdl"

SWEP.WMPos = Vector(14.986, 0.921, -3.038)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_springfield.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip = 0 --	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".30-06"

SWEP.FireDelay = 60/450
SWEP.FireSound = "CW_KK_INS2_DOI_GARAND_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_M14_FIRE_SUPPRESSED"
SWEP.Recoil = 1.6

SWEP.HipSpread = 0.055
SWEP.AimSpread = 0.002
SWEP.VelocitySensitivity = 2.1
SWEP.MaxSpreadInc = 0.07
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.12
SWEP.Shots = 1
SWEP.Damage = 59

SWEP.FirstDeployTime = 2
SWEP.DeployTime = 1.2
SWEP.HolsterTime = 0.85

SWEP.Chamberable = false
SWEP.KK_INS2_EmptyIdle = true
SWEP.KK_INS2_EmptyIdleGL = true

SWEP.WeaponLength = 22

SWEP.MuzzleVelocity = 853

SWEP.ReloadTimes = {
	base_reloadfull = {3.6, 5, KK_INS2_REVOLVER_SPEED_UNLOAD, 1.1},
	base_reloadempty = {2.2, 3.6},
	base_reloadempty_null = {3.5, 6.4},

	glsetup_reload = {2, 3.1},

	glsetup_in = {6.2, 7.6},
	glsetup_in_empty = {6.2, 7.6},
	glsetup_out = {1.6, 7},
	glsetup_out_empty = {2.75, 5.2},

	base_melee_bash = {0.3, 0.9},
	base_melee_bash_empty = {0.3, 0.9},
}

if CLIENT then
	local bone = 66
	local dir = Vector(0,0,-1)
	local angleVel = Vector()

	local vm, att, pos, ang, velocity, align, shellEnt

	function SWEP:shellEvent2()
		if self.Owner:ShouldDrawLocalPlayer() then
			vm = self:getMuzzleModel()

			att = vm:GetAttachment(self.ShellWorldAttachmentID)

			pos = att.Pos
			ang = att.Ang
			velocity = self.Owner:GetVelocity() + ang:Forward() * (50)

			align = self.Shell2WorldAngleAlign
			ang:RotateAroundAxis(ang:Right(), align.Right)
			ang:RotateAroundAxis(ang:Forward(), align.Forward)
			ang:RotateAroundAxis(ang:Up(), align.Up)

			CustomizableWeaponry_KK.ins2.shells:make(
				pos,
				ang,
				velocity,
				angleVel,
				self._shellTable2,
				self.Shell2Scale
			)
		else
			vm = self.CW_VM

			att = vm:GetBoneMatrix(bone)

			pos = att:GetTranslation()
			ang = att:GetAngles()
			velocity = self.Owner:GetVelocity() + dir * (self.Shell2EjectVelocity or 200)

			align = self.Shell2ViewAngleAlign
			ang:RotateAroundAxis(ang:Right(), align.Right)
			ang:RotateAroundAxis(ang:Forward(), align.Forward)
			ang:RotateAroundAxis(ang:Up(), align.Up)

			CustomizableWeaponry_KK.ins2.shells:make(
				pos,
				ang,
				velocity,
				angleVel,
				self._shellTable2,
				self.Shell2Scale
			)
		end
	end
end

SWEP.reloadProgressAnimsRaw = {
	base_reload_empty_lulz = true
}

SWEP.reticleInactivityCallbacksRaw = {
	["base_reload_empty_lulz"] = 0.1
}

function SWEP:overrideReloadAnim(prefix, suffix)
	if self.dt.INS2GLActive or self:Clip1() > 0 then
		return prefix .. "reload"
	end

	if math.random(100) == 82 then
		return "base_reload_empty_lulz"
	end

	return prefix .. "reload_empty"
end
