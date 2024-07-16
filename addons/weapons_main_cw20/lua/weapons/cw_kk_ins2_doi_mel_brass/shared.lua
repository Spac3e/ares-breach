--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_mel_brass/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Brass knuckles"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_brassknuckles")

	SWEP.AttachmentModelsVM = {}

	SWEP.HUD_3D2DBone = 57
end

SWEP.Animations = {
	base_pickup = "ready_1",
	base_draw = "draw_2",
	base_fire = {/*"swing1", */"swing2", "swing3"},
	base_idle = "idle",
	base_holster = "holster",
	base_sprint = "sprint",
	base_crawl = "crawl",
}

SWEP.NormalHoldType = "fist"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base_melee"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/kk_doi/v_brassknuckles.mdl"
-- SWEP.ViewModel		= "models/weapons/cw_kk_doi_c054/v_brassknuckles.mdl"
SWEP.WorldModel		= "models/weapons/w_brassknuckles.mdl"

SWEP.WMPos = Vector(3.7, 0.5, 0)
SWEP.WMAng = Vector(10, -5, -3)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.FirstDeployTime = 1.6
SWEP.DeployTime = 0.8
SWEP.HolsterTime = 0.6

SWEP.ReticleInactivityPostFire = 1

SWEP.AttackSound = "CW_KK_INS2_DOI_BRASS_ATTACK"
SWEP.HitFleshSound = "CW_KK_INS2_DOI_BRASS_HITPLY"
SWEP.HitWorldSound = "CW_KK_INS2_DOI_BRASS_HITWORLD"

SWEP.DamageOutputDelay = 4/32

SWEP.Sounds = {
	ready_1 = {
		{time = 0/32, sound = "CW_KK_INS2_DOI_BRASS_READY1"},
		{time = 7/32, sound = "CW_KK_INS2_DOI_BRASS_READY2"},
	},

	ready_2 = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	draw_1 = {
		{time = 0/32, sound = "CW_KK_INS2_DOI_BRASS_READY1"},
		{time = 7/32, sound = "CW_KK_INS2_DOI_BRASS_READY2"},
	},

	draw_2 = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	crawl = {
		{time = 0/28, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 15/28, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 26/28, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 41/28, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
