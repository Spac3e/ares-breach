--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_flame_gb/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if not CustomizableWeaponry_KK.HOME then return end

SWEP.magType = "NONE"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Flame GB"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_flamethrower_british")

	SWEP.NoShells = true

	SWEP.AttachmentModelsVM = {}
	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-2.2377, -2, 1.0456)
	SWEP.IronsightAng = Vector(0.1611, 0.0052, 0)
end

SWEP.WeaponLength = 16

SWEP.Attachments = {
	-- ----["+reload"] = {header = "Ammo", offset = {900, 500}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Chamberable = false
SWEP.KK_INS2_EmptyIdle = false

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = "base_fire",
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "base_dryfire",
	base_reload = "base_ready",
	base_reload_empty = "base_ready",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "base_down",
	base_crawl = "base_crawl",
	base_melee = "base_melee",
}

SWEP.SpeedDec = 15

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base_flame"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_flame_lifebuoy.mdl"
SWEP.WorldModel		= "models/weapons/w_lufboy.mdl"

SWEP.WMPos = Vector(11, 0.395, -2.5)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 400
SWEP.Primary.DefaultClip = 0 --	= 400
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".45 ACP"

SWEP.FireDelay = 60/700
SWEP.FireSound = "CW_KK_INS2_DOI_FLAME_GB_FIRE_START"
SWEP.Recoil = 0.7

SWEP.FirstDeployTime = 0.9
SWEP.DeployTime = 0.9
SWEP.HolsterTime = 0.8

SWEP.ReloadTimes = {
	base_ready = {1.9, 1.9},
	base_melee = {0.3, 1.3},
}
