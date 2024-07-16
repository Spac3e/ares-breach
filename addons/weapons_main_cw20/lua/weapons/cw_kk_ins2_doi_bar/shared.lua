--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_bar/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "brMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M1918A2 BAR"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_bar")

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.ShellDelay = 0.12

	SWEP.AttachmentModelsVM = {
		["kk_ins2_bipod"] = {model = "models/weapons/upgrades/a_bipod_bar.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_bar.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
		-- ["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_bar.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, rel = "ani_body"},
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_sling_bar.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_bipod"] = {model = "models/weapons/upgrades/w_bipod_bar.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
	}

	SWEP.IronsightPos = Vector(-2.1192, -2, 1.4437)
	SWEP.IronsightAng = Vector(-0.3029, 0, 0)
end

SWEP.MuzzleEffect = "muzzleflash_bar_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_bar_3p"

SWEP.Attachments = {
	{header = "Barrel", offset = {-300, -200}, atts = {"kk_ins2_bipod"}},
	{header = "Stock", offset = {700, -200}, atts = {"kk_ins2_ww2_sling"}},
	--["+reload"] = {header = "Ammo", offset = {1100, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = {"base_fire_1", "base_fire_2", "base_fire_3"},
	base_fire_aim = {"iron_fire_1","iron_fire_2"},
	base_fire_last = {"base_fire_1", "base_fire_2", "base_fire_3"},
	base_fire_last_aim = {"iron_fire_1","iron_fire_2"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reloadfull",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "base_holster_empty",
	base_firemode = "base_fireselect",
	base_firemode_empty = "base_fireselect",
	base_firemode_aim = "iron_fireselect",
	base_firemode_empty_aim = "iron_fireselect",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint_empty",
	base_safe = "base_down",
	base_safe_empty = "base_down_empty",
	base_safe_aim = "iron_down",
	base_safe_empty_aim = "iron_down_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash",

	bipod_in = "deployed_in",
	bipod_in_empty = "deployed_in_empty",
	bipod_fire = {"deployed_fire_1", "deployed_fire_2"},
	bipod_fire_aim = {"deployed_iron_fire_1","deployed_iron_fire_2","deployed_iron_fire_3"},
	bipod_fire_last = {"deployed_fire_1", "deployed_fire_2"},
	bipod_fire_last_aim = {"deployed_iron_fire_1","deployed_iron_fire_2","deployed_iron_fire_3"},
	bipod_fire_empty = "deployed_dryfire",
	bipod_fire_empty_aim = "deployed_iron_dryfire",
	bipod_reload = "deployed_reload",
	bipod_reload_empty = "deployed_reload_empty",
	bipod_firemode = "deployed_fireselect",
	bipod_firemode_empty = "deployed_fireselect_empty",
	bipod_firemode_aim = "deployed_iron_fireselect",
	bipod_firemode_empty_aim = "deployed_fireselect_empty",
	bipod_out = "deployed_out",
	bipod_out_empty = "deployed_out_empty",
}

SWEP.SpeedDec = 40

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"barslow", "barfast"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_bar.mdl"
SWEP.WorldModel		= "models/weapons/w_bar.mdl"

SWEP.WMPos = Vector(18.197, 0, -3)
SWEP.WMAng = Vector(-15, 2.743, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip = 0 --	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".30-06"

SWEP.FireDelayFast = 60/650
SWEP.FireDelaySlow = 60/450
SWEP.FireDelay = SWEP.FireDelaySlow
SWEP.FireSound = "CW_KK_INS2_DOI_BAR_FIRE"
SWEP.Recoil = 1.5

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.002
SWEP.VelocitySensitivity = 2
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.17
SWEP.Shots = 1
SWEP.Damage = 59

SWEP.BipodDeployTime = 0.91
SWEP.BipodUndeployTime = 1.16

SWEP.FirstDeployTime = 2.6
SWEP.DeployTime = 0.9
SWEP.HolsterTime = 0.7

SWEP.WeaponLength = 28

SWEP.Chamberable = false
SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 860

SWEP.ReloadTimes = {
	base_reloadfull = {3.54, 4.42},
	base_reloadempty = {4.9, 5.79},

	deployed_reload = {3.54, 4.42},
	deployed_reload_empty = {4.9, 5.79},

	base_melee_bash = {0.5, 1.6},
}

function SWEP:IndividualThink_INS2()
	self.FireDelay = (self.FireMode == "barslow") and self.FireDelaySlow or self.FireDelayFast
end

-- if CLIENT then
	-- function SWEP:updateStandardParts()
		-- self.AttachmentModelsVM.slingpin.ent:SetBodygroup(1,self.ActiveAttachments.kk_ins2_ww2_sling and 1 or 0)
	-- end
-- end
