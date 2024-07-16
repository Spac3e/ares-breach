--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m79/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M79"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_m79")

	SWEP.NoShells = true
	SWEP.Shell = "KK_INS2_40mm"

	SWEP.AttachmentModelsVM = {
		["kk_ins2_ww2_sling"] = {model = "models/weapons/upgrades/a_m79_sling.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},
		["muzzle"] = {model = "models/maxofs2d/cube_tool.mdl", pos = Vector(21.3825, 0.0088, -0.496), angle = Angle(0, 0, 0), size = Vector(0.01, 0.01, 0.01), attachment = "muzzle", bodygroups = {[1] = 1,}, active = true, nodraw = true},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.2518, -2, -1.4316)
	SWEP.IronsightAng = Vector(7.531, 0.0067, 0)

	SWEP.ReloadViewBobEnabled = false
	SWEP.HUD_MagText = "BREECH: "
	SWEP.CustomizationMenuScale = 0.015
end

SWEP.MuzzleEffect = "ins_weapon_m203"
SWEP.MuzzleEffectWorld = "ins_weapon_m203"

SWEP.Attachments = {
	{header = "Stock", offset = {600, 0}, atts = {"kk_ins2_ww2_sling"}},
	-- {header = "Ammo", offset = {-100, 0}, atts = {"kk_ins2_gp25_ammo"}},
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = "iron_fire",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = {"base_reload", "base_reload2", "base_reload3"},
	base_reload_empty = {"base_reload", "base_reload2", "base_reload3"},
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 15

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"break"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_nam_m79.mdl"
SWEP.WorldModel		= "models/weapons/w_m79.mdl"

-- SWEP.WMPos = Vector(3.243, 1, 0)
-- SWEP.WMAng = Vector(15, 179, 180)

SWEP.WMPos = Vector(4, 0.2, -1.5)
SWEP.WMAng = Vector(-15, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.m26
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2kus
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip = 0 --	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "40MM"

SWEP.FireDelay = 0.4
SWEP.FireSound = "CW_KK_INS2_NAM_M79_FIRE"
SWEP.Recoil = 3

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.9
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.8
SWEP.Shots = 1
SWEP.Damage = 10

SWEP.FirstDeployTime = 1.6
SWEP.DeployTime = 1
SWEP.HolsterTime = 1

SWEP.Chamberable = false
SWEP.SnapToIdlePostReload = false
SWEP.ShotgunReload = false
SWEP.ReticleInactivityPostFire = 0.8

SWEP.WeaponLength = 24

SWEP.MuzzleVelocity = 76
SWEP.projectileClass = "cw_40mm_explosive"
SWEP.hipBulletDelay = 0

SWEP.ReloadTimes = {
	base_reload = {3.2, 4.6},
	base_reload2 = {3.2, 4.6},
	base_reload3 = {3.2, 4.6},
}

if CLIENT then
	local att
	local muz = {}

	function SWEP:getMuzzlePosition()
		if self.Owner:ShouldDrawLocalPlayer() then
			muz.Pos = self.WMEnt:GetAttachment(1).Pos
			muz.Ang = EyeAngles()
			return muz
		end

		muz.Pos = self.AttachmentModelsVM.muzzle.ent:GetPos()
		muz.Ang = self.AttachmentModelsVM.muzzle.ent:GetAngles()
		return muz
	end
end
