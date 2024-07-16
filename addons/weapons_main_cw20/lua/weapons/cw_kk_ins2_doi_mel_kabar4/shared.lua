--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_mel_kabar4/shared.lua

--]]

if not CustomizableWeaponry then return end

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Fairbairn Knife"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_fairbairn")

	SWEP.AttachmentModelsVM = {
		["ani_body"] = {model = "models/weapons/v_fairbairn.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
	}

	SWEP.HUD_3D2DBone = 57
end

SWEP.Animations = {
	base_pickup = "draw",
	base_draw = "draw",
	base_fire = {"hitcenter1", "hitcenter2"},
	base_idle = "idle",
	base_holster = "holster",
	base_sprint = "sprint",
	base_crawl = "crawl",
}

SWEP.NormalHoldType = "knife"
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
-- SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_marinebayonet.mdl"
SWEP.ViewModel		= "models/weapons/cw_kk_doi_c054/v_fairbairn.mdl"
SWEP.WorldModel		= "models/weapons/w_fairbairn.mdl"

SWEP.WMPos = Vector(3.812, 1.544, -2.83)
SWEP.WMAng = Vector(99.385, -22.739, 18.048)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.FirstDeployTime = 0.8
SWEP.DeployTime = 0.8
SWEP.HolsterTime = 0.6

SWEP.AttackSound = "CW_KK_INS2_DOI_KNIFE"
SWEP.HitFleshSound = "CW_KK_INS2_DOI_KNIFE_HITPLY"
SWEP.HitWorldSound = "CW_KK_INS2_DOI_KNIFE_HITWORLD"

SWEP.Sounds = {
	-- hitcenter1 = {
		-- // { event 1338 7 ""},
	-- },

	-- hitcenter2 = {
		-- // { event 1338 7 ""},
	-- },

	draw = {
		{time = 0/34, sound = "CW_KK_INS2_DOI_BAYONET_DRAW"},
	},

	holster = {
		{time = 10/32, sound = "CW_KK_INS2_DOI_BAYONET_HOLSTER"},
	},

	crawl = {
		{time = 10/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 20/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},
}
