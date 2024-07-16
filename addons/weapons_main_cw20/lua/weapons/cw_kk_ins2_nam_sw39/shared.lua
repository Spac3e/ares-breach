--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_sw39/shared.lua

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
	SWEP.PrintName = "SW M39"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_nam_sw39")

	SWEP.Shell = "KK_INS2_9x19"
	SWEP.ShellDelay = 0.06
	SWEP.ShellWorldAngleAlign = {Forward = 90, Right = 0, Up = 0}

	SWEP.AttachmentModelsVM = {}
	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-1.8478, 0, 0.4957)
	SWEP.IronsightAng = Vector(0.1302, 0.0213, 7)

	SWEP.CustomizationMenuScale = 0.01
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true
end

SWEP.MuzzleEffect = "muzzleflash_1911_1p"
SWEP.MuzzleEffectWorld = "muzzleflash_sten_3p"

SWEP.SightBGs = {main = 0, foldsight = 0}
SWEP.StockBGs = {main = 0, regular = 0, heavy = 0, sturdy = 0}

SWEP.Attachments = {
	-- {header = "Sight", offset = {500, -400}, atts = {"bg_foldsight"}},
	-- {header = "Barrel", offset = {-500, -400}, atts = {"kk_ins2_hoovy"}},
	-- {header = "Stock", offset = {-500, 150}, atts = {"bg_ar15sturdystock"}},
	--["+reload"] = {header = "Ammo", offset = {500, 50}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_draw_empty = "empty_draw",
	base_fire = {"base_fire","base_fire2","base_fire3"},
	base_fire_aim = {"iron_fire","iron_fire2","iron_fire3"},
	base_fire_last = "base_firelast",
	base_fire_last_aim = "iron_firelast",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "iron_idle",
	base_idle_empty = "iron_empty",
	base_holster = "base_holster",
	base_holster_empty = "empty_holster",
	base_sprint = "base_sprint",
	base_sprint_empty = "empty_sprint",
	base_safe = "base_down",
	base_safe_empty = "empty_down",
	base_safe_aim = "iron_down",
	base_safe_empty_aim = "empty_iron_down",
	base_crawl = "base_crawl",
	base_crawl_empty = "empty_crawl",
}

SWEP.SpeedDec = 10

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "pistol"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_nam_sw39.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_sw39.mdl"

SWEP.WMPos = Vector(5.5, 1, -2)
SWEP.WMAng = Vector(-8, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.m26
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2kus
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip = 0 --	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9x19MM"

SWEP.FireDelay = 0.1
SWEP.FireSound = "CW_KK_INS2_NAM_SW39_FIRE"
SWEP.FireSoundSuppressed = "CW_KK_INS2_NAM_SW39_FIRE_SUPPRESSED"
SWEP.Recoil = 0.77

SWEP.HipSpread = 0.034
SWEP.AimSpread = 0.011
SWEP.VelocitySensitivity = 1.2
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.17
SWEP.Shots = 1
SWEP.Damage = 24

SWEP.FirstDeployTime = 2.5
SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.4

SWEP.CanRestOnObjects = false
SWEP.WeaponLength = 16

SWEP.SuppressedOnEquip = true
SWEP.KK_INS2_EmptyIdle = true

SWEP.MuzzleVelocity = 335

SWEP.ReloadTimes = {
	base_reload = {60/31.5, 2.6},
	base_reloadempty = {60/31.5, 3.2},

	base_melee_bash = {0.3, 0.8},
	empty_melee_bash = {0.3, 0.8},
}

if CLIENT then
	local v0 = Vector()
	local v1 = Vector(1,1,1)
	local bone = 63

	function SWEP:updateOtherParts()
		local vm = self.CW_VM
		local cycle = vm:GetCycle()
		local activity = self.Sequence

		if self:Clip1() == 0 and (self.Sequence != self.Animations.base_reload_empty or cycle < 0.3) then
			vm:ManipulateBoneScale(bone, v0)
		else
			vm:ManipulateBoneScale(bone, v1)
		end
	end
end
