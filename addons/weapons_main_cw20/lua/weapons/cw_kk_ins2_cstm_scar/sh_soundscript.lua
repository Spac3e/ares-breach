--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_scar/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_scar/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 22/38, sound = "CW_KK_INS2_M14_BOLTBACK"},
		{time = 36/38, sound = "CW_KK_INS2_M14_BOLTRELEASE"},
		{time = 52/38, sound = "CW_KK_INS2_M14_RATTLE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	base_fireselect = {
		{time = 12/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_fireselect_empty = {
		{time = 12/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_reload = {
		{time = 14/30, sound = "CW_KK_INS2_M14_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_M14_MAGOUT"},
		{time = 75/30, sound = "CW_KK_INS2_M14_MAGIN"},
		-- { event 46 90 ""},
		{time = 93/30, sound = "CW_KK_INS2_M14_RATTLE"},
		{time = 95/30, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	base_reloadempty = {
		{time = 13/30, sound = "CW_KK_INS2_M14_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 21/30, sound = "CW_KK_INS2_M14_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_M14_MAGIN"},
		-- { event 46 90 ""},
		{time = 97/30, sound = "CW_KK_INS2_M9_BOLTBACK"},
		{time = 106/30, sound = "CW_KK_INS2_M14_BOLTRELEASE"},
		{time = 128/30, sound = "CW_KK_INS2_M14_RATTLE"},
		{time = 130/30, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	iron_fireselect = {
		{time = 12/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	iron_fireselect_empty = {
		{time = 12/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 22/38, sound = "CW_KK_INS2_M14_BOLTBACK"},
		{time = 36/38, sound = "CW_KK_INS2_M14_BOLTRELEASE"},
		{time = 52/38, sound = "CW_KK_INS2_M14_RATTLE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 12/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	foregrip_fireselect_empty = {
		{time = 12/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 14/30, sound = "CW_KK_INS2_M14_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_M14_MAGOUT"},
		{time = 75/30, sound = "CW_KK_INS2_M14_MAGIN"},
		-- { event 46 90 ""},
		{time = 93/30, sound = "CW_KK_INS2_M14_RATTLE"},
		{time = 95/30, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	foregrip_reloadempty = {
		{time = 13/30, sound = "CW_KK_INS2_M14_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 21/30, sound = "CW_KK_INS2_M14_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_M14_MAGIN"},
		-- { event 46 90 ""},
		{time = 97/30, sound = "CW_KK_INS2_M9_BOLTBACK"},
		{time = 106/30, sound = "CW_KK_INS2_M14_BOLTRELEASE"},
		{time = 128/30, sound = "CW_KK_INS2_M14_RATTLE"},
		{time = 130/30, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 12/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	foregrip_iron_fireselect_empty = {
		{time = 12/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	deployed_out = {
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_LEANOUT"},
		{time = 18/31, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
		{time = 30/31, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	deployed_out_empty = {
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_LEANOUT"},
		{time = 18/31, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
		{time = 30/31, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	deployed_in = {
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_LEANOUT"},
		{time = 24/31, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
		{time = 39/31, sound = "CW_KK_INS2_M14_RATTLE"},
		{time = 41/31, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	deployed_in_empty = {
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_LEANOUT"},
		{time = 24/31, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
		{time = 39/31, sound = "CW_KK_INS2_M14_RATTLE"},
		{time = 41/31, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	deployed_fireselect = {
		{time = 10/24, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	deployed_fireselect_empty = {
		{time = 10/24, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	deployed_reload_half = {
		{time = 14/30, sound = "CW_KK_INS2_M14_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_M14_MAGOUT"},
		{time = 75/30, sound = "CW_KK_INS2_M14_MAGIN"},
		-- { event 46 90 ""},
		{time = 95/30, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	deployed_reload_empty = {
		{time = 13/32, sound = "CW_KK_INS2_M14_MAGRELEASE"},
		{time = 18/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 21/32, sound = "CW_KK_INS2_M14_MAGOUT"},
		{time = 66/32, sound = "CW_KK_INS2_M14_MAGIN"},
		-- { event 46 90 ""},
		{time = 97/32, sound = "CW_KK_INS2_M9_BOLTBACK"},
		{time = 106/32, sound = "CW_KK_INS2_M14_BOLTRELEASE"},
		{time = 130/32, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	deployed_iron_fireselect = {
		{time = 10/24, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	deployed_iron_fireselect_empty = {
		{time = 10/24, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}


