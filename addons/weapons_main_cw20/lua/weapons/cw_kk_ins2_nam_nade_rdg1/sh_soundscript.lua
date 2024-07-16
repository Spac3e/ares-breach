--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_nade_rdg1/sh_soundscript.lua

--]]


CustomizableWeaponry:addReloadSound("CW_KK_INS2_NAM_RDG1_PULL", "weapons/nam/rdg1/m67_pinpull.wav")

SWEP.Sounds = {
	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_GRENADE_DRAW"},
	},

	base_holster = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_GRENADE_HOLSTER"},
	},

	base_crawl = {
		{time = 10/29, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 20/29, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	pullbackhigh = {
		{time = 14/30, sound = "CW_KK_INS2_NAM_RDG1_PULL"},
		{time = 35/30, sound = "CW_KK_INS2_M67_ARMDRAW"},
		// { event 3900 45 ""},
	},

	pullbacklow = {
		{time = 14/30, sound = "CW_KK_INS2_NAM_RDG1_PULL"},
		{time = 36/30, sound = "CW_KK_INS2_M67_ARMDRAW"},
		// { event 3900 45 ""},
	},

	throw = {
		{time = 5/30.3, sound = "CW_KK_INS2_M67_THROW"},
		// { event 3005 5 ""},
	},

	lowthrow = {
		{time = 5/31.5, sound = "CW_KK_INS2_M67_THROW"},
		// { event 3016 7 ""},
	},
}
