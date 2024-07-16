--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_mel_kabar5/shared.lua

--]]

if not CustomizableWeaponry then return end

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "New Gun"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_hatchet")

	SWEP.AttachmentModelsVM = {
		-- ["ani_body"] = {model = "models/weapons/v_cw_kk_doi_hatchet_redux.mdl", pos = Vector(0, 0, 1), angle = Angle(0, -70, 0), size = Vector(1, 1, 1), bone = "Weapon", hideVM = true, active = true},
	}

	SWEP.HUD_3D2DBone = 39
end

SWEP.Animations = {
	base_pickup = "base_draw",
	base_draw = "base_draw",
	base_fire = {"base_swing_1", "base_swing_2"},
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_crawl = "base_crawl",
}

SWEP.NormalHoldType = "melee2"
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
-- SWEP.ViewModel		= "models/weapons/kk_doi/v_etool_brit.mdl"
SWEP.ViewModel		= "models/weapons/cw_kk_doi_c054/v_hatchet.mdl"
SWEP.WorldModel		= "models/weapons/w_hatchet.mdl"

SWEP.WMPos = Vector(5, 1.544, -9.83)
SWEP.WMAng = Vector(99.385, -22.739, 8.048)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2us

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.FirstDeployTime = 0.8
SWEP.DeployTime = 0.8
SWEP.HolsterTime = 0.5

SWEP.DamageBase = 35

SWEP.FireDelay = 1
SWEP.ReticleInactivityPostFire = 1
SWEP.DamageOutputDelay = 0.3

SWEP.AttackSound = "CW_KK_INS2_DOI_HATCHET"
SWEP.HitFleshSound = "CW_KK_INS2_DOI_HATCHET_HITPLY"
SWEP.HitWorldSound = "CW_KK_INS2_DOI_HATCHET_HITWORLD"

SWEP.Sounds = {
	-- base_attack_1 = {
		-- // { event 1338 8 ""},
	-- },

	-- base_attack_2 = {
		-- // { event 1338 13 ""},
	-- },

	-- base_attack_3 = {
		-- // { event 1338 14 ""},
	-- },

	-- base_attack_kill = {
		-- {time = 7/30, sound = "CW_KK_INS2_DOI_MELEE"},
		-- {time = 38/30, sound = "CW_KK_INS2_DOI_MELEE"},
	-- },

	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/33, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/33, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/33, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
