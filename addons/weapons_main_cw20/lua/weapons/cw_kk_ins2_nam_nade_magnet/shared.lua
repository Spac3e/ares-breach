--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_nade_magnet/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "BZE39-fused AT 'nade"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_hafthohlladung")

	SWEP.IconLetter = "O"

	SWEP.AttachmentModelsVM = {}
	SWEP.AttachmentModelsWM = {}

	SWEP.MoveType = 2
	SWEP.ViewModelMovementScale = 0.8
	SWEP.DisableSprintViewSimulation = true

	SWEP.HUD_3D2DOffset = Vector(3, -5, 0)
	SWEP.HUD_3D2DOffsetMenu = Vector(-1, -3, 0)
	SWEP.CustomizationMenuScale = 0.006

	SWEP.HUD_3D2DBone = 53
end

SWEP.Attachments = CustomizableWeaponry_KK.ins2.slowGrenadeMenu

SWEP.CanRestOnObjects = false
SWEP.projectileClass = "cw_kk_ins2_projectile_ww2_c4_de"

SWEP.Animations = {
	plant = "base_plant",

	pullpin = "base_pullback",
	throw = "base_throw",

	pull_cook = "secondary_pullback",
	throw_cook = "secondary_throw",

	pull_short = "low_pullback",
	throw_short = "low_throw",

	base_pickup = "base_draw",
	base_draw = "base_draw",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 5

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "slam"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base_nade"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_nam_hafthohlladung.mdl"
SWEP.WorldModel		= "models/weapons/w_hafthohlladung.mdl"

SWEP.WMPos = Vector(3.891, 4.5, 7)
SWEP.WMAng = Angle(-70, 90, 0)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.rgd5
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2keh
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.Ammo			= "Frag Grenades"

SWEP.HolsterTime = 0.6

SWEP.fuseTime = 7.5

SWEP.timeToThrow = 1.2
SWEP.spawnTime = 0.95
SWEP.swapTime = 1.4
SWEP.maxVelDelay = 1.5

SWEP.spoonTime = 44/35.2
SWEP.timeToThrowCook = 1.5
SWEP.maxVelDelayCook = 1.8

SWEP.timeToThrowShort = 1.2
SWEP.spawnTimeShort = 0.65
SWEP.swapTimeShort = 1.3
SWEP.maxVelDelayShort = 1.5

SWEP.canCook = false
SWEP.canPlant = true

SWEP.spoonTimePlant = 0.75
SWEP.spawnTimePlant = 0.8
SWEP.swapTimePlant = 1.35
