--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_mat49/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "smgMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "MAT-49"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_mat49")

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.15

	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 180}
	SWEP.ShellWorldAngleAlign = {Forward = 0, Right = 0, Up = 180}

	SWEP.AttachmentModelsVM = {}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.1187, -2, 0.4073)
	SWEP.IronsightAng = Vector(0, 0.0282, 0)

end

SWEP.MuzzleEffect = "muzzleflash_mp40_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_mp40_3rd"

SWEP.Attachments = {
	--["+reload"] = {header = "Ammo", offset = {0, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = "base_fire",
	base_fire_aim = {"iron_fire","iron_fire_a","iron_fire_b","iron_fire_c","iron_fire_d","iron_fire_e","iron_fire_f"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_idle_empty = "empty_idle",
	base_holster = "base_holster",
	base_holster_empty = "empty_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_safe_empty = "empty_down",
	base_safe_empty_aim = "iron_empty_down",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
}

SWEP.SpeedDec = 15

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "SMG"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_nam_mat49.mdl"
SWEP.WorldModel		= "models/weapons/w_mat49.mdl"

SWEP.WMPos = Vector(3.7, 0.889, -1)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.rgd5
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2keh
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 32
SWEP.Primary.DefaultClip = 0 --	= 32
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x19MM"

SWEP.FireDelay = 60/600
SWEP.FireSound = "CW_KK_INS2_NAM_MAT49_FIRE"
SWEP.Recoil = 0.77

SWEP.HipSpread = 0.035
SWEP.AimSpread = 0.009
SWEP.VelocitySensitivity = 1.5
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 25

SWEP.FirstDeployTime = 2.6
SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.6

SWEP.Chamberable = false

SWEP.WeaponLength = 16 // this things gotta b longer than MP5k

SWEP.KK_INS2_EmptyIdle = true

SWEP.ReloadTimes = {
	base_reload = {2.2, 2.95},
	base_reloadempty = {3.2, 4.55}
}

SWEP.MuzzleVelocity = 400

if CLIENT then
	local bone0 = 0
	local position0 = Vector(-2, -6, 0)
	local angle0 = Angle(0, 90, 0)

	local bone1 = 1
	local position1 = Vector(5, -7, 0)
	local angle1 = Angle(0, -90, 0)

	CustomizableWeaponry_KK.ins2.welementThink:add("cw_kk_ins2_nam_mat49", function(wep, welement)
		welement:ManipulateBonePosition(bone0, position0)
		welement:ManipulateBoneAngles(bone0, angle0)

		welement:ManipulateBonePosition(bone1, position1)
		welement:ManipulateBoneAngles(bone1, angle1)
	end)
end
