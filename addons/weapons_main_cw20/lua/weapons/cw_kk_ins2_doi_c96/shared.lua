--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_c96/shared.lua

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
	SWEP.PrintName = "Mauser C96"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_c96")

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.06
	SWEP.ShellWorldAngleAlign = {Forward = 90, Right = 0, Up = 0}

	SWEP.AttachmentModelsVM = {
		["kk_ins2_c96_barrel_std"] = {model = "models/weapons/upgrades/a_barrel_c96_short.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true, active = true},
		["kk_ins2_c96_barrel_lng"] = {model = "models/weapons/upgrades/a_barrel_c96_long.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},

		["bg_ar15sturdystock"] = {model = "models/weapons/upgrades/a_stock_c96.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		-- ["ani_body"] = {model = "models/weapons/v_c96.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
	}

	SWEP.AttachmentModelsWM = {}

	-- // long B
	-- SWEP.LongBarrelPos = Vector(-2.6343, -2, 0.8154)
	-- SWEP.LongBarrelAng = Vector(0.2535, 0.0412, 0)

	SWEP.IronsightPos = Vector(-2.6353, -2, 0.681)
	SWEP.IronsightAng = Vector(0.9804, 0.0329, 0)

	SWEP.CustomizationMenuScale = 0.010
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true

end

SWEP.MuzzleEffect = "muzzleflash_luger_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_mp40_3p"

SWEP.StockBGs = {main = 0, regular = 0, heavy = 0, sturdy = 0}

SWEP.Attachments = {
	{header = "Stock", offset = {800, 0}, atts = {"bg_ar15sturdystock"}},
	-- {header = "Lasers", offset = {500, -400}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_m6x"}},
	-- {header = "Barrel", offset = {-500, -400}, atts = {"kk_ins2_c96_barrel_lng"}},
	--["+reload"] = {header = "Ammo", offset = {-400, 0}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw_empty",
	base_fire = {"base_fire_1", "base_fire_2", "base_fire_3"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload_clip",
	base_reload_empty = "base_reload_empty_clip",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "base_holster_empty",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint_empty",
	base_safe = "base_down",
	base_safe_empty = "base_down_empty",
	base_safe_aim = "iron_down",
	base_safe_empty_aim = "iron_down_empty",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl_empty",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash_empty",
}

SWEP.SpeedDec = 10

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "revolver"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_c96.mdl"
SWEP.WorldModel		= "models/weapons/w_c96.mdl"

SWEP.WMPos = Vector(4.5, 1, -3.5)
SWEP.WMAng = Vector(-8, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2de
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2de

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip = 0 --	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9x19MM"

SWEP.FireDelay = 60/700
SWEP.FireSound = "CW_KK_INS2_DOI_C96_FIRE"
SWEP.Recoil = 0.77

SWEP.HipSpread = 0.034
SWEP.AimSpread = 0.011
SWEP.VelocitySensitivity = 1.2
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.17
SWEP.Shots = 1
SWEP.Damage = 24

SWEP.FirstDeployTime = 0.5
SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.4

SWEP.Chamberable = false
SWEP.CanRestOnObjects = false
SWEP.WeaponLength = 16

SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 425

SWEP.ReloadTimes = {
	base_reload_clip = {3.4, 6.23, KK_INS2_REVOLVER_SPEED_UNLOAD, 1.1},
	base_reload_empty_clip = {2.4, 4.37},

	base_melee_bash = {0.3, 0.8},
	base_melee_bash_empty = {0.3, 0.8},
}

if CLIENT then
	function SWEP:updateStandardParts()
		self:setElementActive("kk_ins2_c96_barrel_std", !self.ActiveAttachments.kk_ins2_c96_barrel_lng)
	end
end

-- function SWEP:IndividualReloadCheck()
	-- return self:Clip1() == 0
-- end
