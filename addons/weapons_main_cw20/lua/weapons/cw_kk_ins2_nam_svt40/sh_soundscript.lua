--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_svt40/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 17/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 25/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	base_reload = {
		{time = 23/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 28/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 78/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
	},

	base_reloadempty = {
		{time = 23/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 27/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 83/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
		{time = 107/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 114/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 17/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 25/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	foregrip_reloadempty = {
		{time = 23/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 27/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 83/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
		{time = 106/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 114/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	foregrip_reload = {
		{time = 23/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 28/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 78/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	foregrip_empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	deployed_in = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 19/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_out = {
		{time = 20/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	deployed_reload = {
		{time = 24/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 29/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 77/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
	},

	deployed_reloadempty = {
		{time = 24/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 29/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 82/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
		{time = 106/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 114/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	deployed_empty_in = {
		{time = 12/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 17/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_empty_out = {
		{time = 20/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_empty_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},
}
