--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_wicked/shared.lua

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
	SWEP.PrintName = "Vickers gun"
	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_vickers")

	SWEP.MuzzleAttachmentName = "muzzle"

	SWEP.NoShells = false

	SWEP.Shell = "KK_INS2_762x54"
	SWEP.ShellEjectVelocity = 50
	SWEP.ShellViewAngleAlign = {Forward = 90, Right = 0, Up = 0}
	-- SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = -90}

	SWEP.AttachmentModelsVM = {
		-- ["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_sterling.mdl", pos = Vector(2.4741, -3.8255, 2.5795), angle = Angle(0, -90, 0), size = Vector(1.25, 1.25, 1.25), bone = "Weapon"},
		-- ["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_sterling.mdl", pos = Vector(2.4741, -3.8255, 2.5795), angle = Angle(0, -90, 0), size = Vector(1.25, 1.25, 1.25), bone = "Weapon"},
		-- ["kk_ins2_anpeq15"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_anpeq_ring.mdl", pos = Vector(2.4741, -3.8255, 2.5795), angle = Angle(0, -90, 0), size = Vector(1.25, 1.25, 1.25), bone = "Weapon"},
	}

	-- SWEP.LaserAngAdjustBase = Angle(6,-4,0)
	-- SWEP.LaserAngAdjustBipod = Angle(0,0,0)

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-0.0034, 0, -0.0059)
	SWEP.IronsightAng = Vector(0, 0.0431, 0)

	SWEP.AlternativePos = Vector(0, 0, 0)
	SWEP.AlternativeAng = Vector(-4.7469, -2.8829, 0)

	SWEP.CustomizationMenuScale = 0.018
end

SWEP.MuzzleEffect = "muzzleflash_m1919_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_bar_3p"

SWEP.Attachments = {
	-- {header = "Lasers", offset = {-500, -100}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_anpeq15"}},
	--["+reload"] = {header = "Ammo", offset = {900, 300}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "base_draw",
	base_fire = {"base_fire_1", "base_fire_2"},
	base_fire_aim = {"iron_fire_1", "iron_fire_2"},
	base_fire_last = "base_fire_last",
	base_fire_last_aim = "base_fire_last",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_idle_empty = "base_idle_empty",
	base_holster = "base_holster",
	base_holster_empty = "base_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "base_down",
	base_safe_empty = "base_down",
	base_safe_empty_aim = "base_down",
	base_crawl = "base_crawl",
	base_crawl_empty = "base_crawl",
	base_melee = "base_melee_bash",
	base_melee_empty = "base_melee_bash",

	bipod_in = "deployed_in",
	bipod_in_empty = "deployed_in",
	bipod_fire = {"deployed_fire_1","deployed_fire_2"},
	bipod_fire_aim = {"deployed_iron_fire_1", "deployed_iron_fire_2"},
	bipod_fire_last = "deployed_fire_last",
	bipod_fire_last_aim = "deployed_iron_fire_last",
	bipod_fire_empty = "deployed_dryfire",
	bipod_fire_empty_aim = "deployed_iron_dryfire",
	bipod_reload = "deployed_reload",
	bipod_reload_empty = "deployed_reload_empty",
	bipod_idle = "deployed_idle",
	bipod_idle_aim = "deployed_iron_idle",
	bipod_idle_empty = "deployed_idle_empty",
	bipod_idle_empty_aim = "deployed_iron_idle_empty",
	bipod_out = "deployed_out",
	bipod_out_empty = "deployed_out",
}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_vickers.mdl"
SWEP.WorldModel		= "models/weapons/w_vickers.mdl"

SWEP.WMPos = Vector(13, 0.921, -4.5)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 250
SWEP.Primary.DefaultClip = 0 --	= 250
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".303 British"

SWEP.FireDelay = 60/500
SWEP.FireSound = "CW_KK_INS2_DOI_VICKERS_FIRE"
SWEP.Recoil = 1.1

SWEP.HipSpread = 0.065
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 2.4
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 60

SWEP.FirstDeployTime = 1.5
SWEP.DeployTime = 0.9
SWEP.HolsterTime = 0.6

SWEP.BipodDeployTime = 2.18
SWEP.BipodUndeployTime = 1.73

SWEP.Chamberable = false
SWEP.BipodInstalled = true
SWEP.KK_INS2_EmptyIdle = false
SWEP.WeaponLength = 24

SWEP.MuzzleVelocity = 850

SWEP.ReloadTimes = {
	base_reload = {7.3, 10},
	base_reloadempty = {7.3, 10},

	deployed_reload = {5.8, 8.1},
	deployed_reload_empty = {5.8, 8.1},

	base_melee_bash = {0.6, 2},
}

if CLIENT then
	-- function SWEP:IndividualThink_INS2()
		-- self.LaserAngAdjust = self.dt.BipodDeployed and self.LaserAngAdjustBipod or self.LaserAngAdjustBase
	-- end

	local pos = Vector(0,0,-2)
	local ang = Vector(1,0,0)

	CustomizableWeaponry.callbacks:addNew("adjustViewmodelPosition", "KK_DOI_VICKERS", function(wep, TargetPos, TargetAng)
		if wep:GetClass() != "cw_kk_ins2_doi_wicked" then return end
		if wep.dt.BipodDeployed then
			if wep:isAiming() then return end

			return pos, ang
		else
			if !wep:isAiming() then return end

			return wep.AlternativePos, wep.AlternativeAng
		end
	end)
end
