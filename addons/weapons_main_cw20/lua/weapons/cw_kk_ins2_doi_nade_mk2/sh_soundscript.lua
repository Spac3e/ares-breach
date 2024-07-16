--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_nade_mk2/sh_soundscript.lua

--]]


SWEP.Sounds = {
	// CW_KK_INS2_DOI_NADE_MK2_SPOONEJECT

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
		{time = 19/30, sound = "CW_KK_INS2_DOI_NADE_MK2_PINPULL"},
		{time = 20/30, sound = "CW_KK_INS2_DOI_NADE_MK2_ARMDRAW"},
		// { event 3900 32 ""},
	},

	pullbackhighbake = {
		{time = 19/30, sound = "CW_KK_INS2_DOI_NADE_MK2_PINPULL"},
		// { event AE_WPN_PULL_SPOON 23 ""},
		{time = 23/30, sound = "CW_KK_INS2_DOI_NADE_MK2_SPOONEJECT"},
		{time = 34/30, sound = "CW_KK_INS2_DOI_NADE_MK2_ARMDRAW"},
		// { event 3900 41 ""},
	},

	pullbacklow = {
		{time = 19/30, sound = "CW_KK_INS2_DOI_NADE_MK2_PINPULL"},
		{time = 20/30, sound = "CW_KK_INS2_DOI_NADE_MK2_ARMDRAW"},
		// { event 3900 32 ""},
	},

	throw = {
		{time = 3/31.5, sound = "CW_KK_INS2_DOI_NADE_MK2_THROW"},
		// { event AE_WPN_PULL_SPOON 3 ""},
		{time = 4/31.5, sound = "CW_KK_INS2_DOI_NADE_MK2_SPOONEJECT"},
		// { event 3005 3 ""},
	},

	throwback = {
		{time = 14/30, sound = "CW_KK_INS2_DOI_NADE_MK2_ARMDRAW"},
		// { event 3900 25 ""},
	},

	bakethrow = {
		{time = 3/31.5, sound = "CW_KK_INS2_DOI_NADE_MK2_THROW"},
		// { event 3013 3 ""},
	},

	lowthrow = {
		{time = 6/31.5, sound = "CW_KK_INS2_DOI_NADE_MK2_THROW"},
		{time = 7/31.5, sound = "CW_KK_INS2_DOI_NADE_MK2_SPOONEJECT"},
		// { event 3016 6 ""},
	},
}
