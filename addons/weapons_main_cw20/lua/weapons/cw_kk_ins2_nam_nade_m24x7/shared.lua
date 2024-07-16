--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_nade_m24x7/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M24x7 HE IED"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_geballteladung")

	SWEP.IconLetter = "O"

	SWEP.AttachmentModelsVM = {
		-- ["nam_buddy"] = {model = "models/weapons/v_nam_geballteladung.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true, hideVM = true},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.MoveType = 2
	SWEP.ViewModelMovementScale = 0.8
	SWEP.DisableSprintViewSimulation = true

	SWEP.HUD_3D2DOffset = Vector(-1, 3, 0)
	SWEP.HUD_3D2DOffsetMenu = Vector(-8, 6, 0)
	SWEP.CustomizationMenuScale = 0.006

	SWEP.HUD_3D2DBone = 54
end

SWEP.Attachments = CustomizableWeaponry_KK.ins2.slowGrenadeMenu

SWEP.CanRestOnObjects = false
SWEP.projectileClass = "cw_kk_ins2_projectile_ww2_c4_de"

SWEP.Animations = {
	pullpin = "pullbackhigh",
	throw = "throw",

	pull_cook = "pullbackhighbake",
	throw_cook = "bakethrow",

	pull_short = "pullbacklow",
	throw_short = "lowthrow",

	base_pickup = "draw",
	base_draw = "draw",
	base_idle = "idle",
	base_holster = "holster",
	base_sprint = "sprint",
	base_safe = "down",
	base_crawl = "crawl",
}

SWEP.SpeedDec = 5

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "grenade"
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
SWEP.ViewModel		= "models/weapons/v_nam_geballteladung.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_geballteladung.mdl"

SWEP.WMPos = Vector(3.891, 2.295, -1.765)
SWEP.WMAng = Angle(-28.962, 155.365, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.m26
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2kus
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.Ammo			= "Frag Grenades"

SWEP.HolsterTime = 0.6

SWEP.fuseTime = 5

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
