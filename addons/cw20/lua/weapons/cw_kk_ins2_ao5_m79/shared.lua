--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_ao5_m79/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_ao5_m79/shared.lua
--]]
if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_soundscript.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M79"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/m79")

	SWEP.NoShells = true
	SWEP.Shell = "KK_INS2_40mm"

	SWEP.AttachmentModelsVM = {}

	SWEP.IronsightPos = Vector(-2.3908, -2, 0.3153)
	SWEP.IronsightAng = Vector(0.9848, 0, 0)

	SWEP.ReloadViewBobEnabled = false
	SWEP.HUD_MagText = "BREECH: "
	SWEP.CustomizationMenuScale = 0.015
end

SWEP.MuzzleEffect = "ins_weapon_m203"
SWEP.MuzzleEffectWorld = "ins_weapon_m203"

SWEP.Attachments = {
	{header = "", offset = {500, 0}, atts = {"kk_ins2_gp25_ammo"}},
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire_last = "base_fire",
	base_fire_last_aim = "iron_fire",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload_empty = "base_reload",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "empty_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "empty_down",
	base_safe_empty_aim = "empty_iron_down",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
}

SWEP.SpeedDec = 15

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"break"}
SWEP.Base = "cw_kk_ins2_base_main"
SWEP.Category = "CW 2.0 KK INS2 AO5"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/aof/v_m79.mdl"
SWEP.WorldModel		= "models/weapons/aof/w_m79.mdl"

SWEP.WMPos = Vector(5.243, 1.562, -1.657)
SWEP.WMAng = Vector(-15, 1, 180)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip 	= 0 --	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "RPG_Rocket"

SWEP.FireDelay = 0.8
SWEP.FireSound = "CW_KK_INS2_M203_FIRE"
SWEP.Recoil = 3

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.9
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.8
SWEP.Shots = 1
SWEP.Damage = 8

SWEP.FirstDeployTime = 1.5
SWEP.DeployTime = 0.5
SWEP.HolsterTime = 0.5

SWEP.Chamberable = false
SWEP.SnapToIdlePostReload = false
SWEP.ShotgunReload = false
SWEP.ReticleInactivityPostFire = 0.8

SWEP.KK_INS2_EmptyIdle = true

SWEP.WeaponLength = 24

SWEP.ReloadTimes = {
	base_reload = {4.6, 5.17},
}

function SWEP:FireBullet(Damage, CurCone, ClumpSpread, Shots)
	if Shots == 1 then
		local target = CustomizableWeaponry.grenadeTypes.registered[self.Grenade40MM]

		if not target then
			CustomizableWeaponry.grenadeTypes.defaultFireFunc(self)
		else
			target.fireFunc(self)
		end

		CustomizableWeaponry.grenadeTypes.selectFireSound(self, target)
	else
		weapons.GetStored("cw_base").FireBullet(self, Damage, CurCone, ClumpSpread, Shots)
	end
end


