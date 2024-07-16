--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_ksg/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_ksg/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 20/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 28/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 30/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fire = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 14/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	base_fire2 = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 14/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M590_EMPTY"},
	},

	base_reload_insert = {
		{time = 5/36, sound = "CW_KK_INS2_M590_SHELLINSERT"},
	},

	base_reload_end_empty = {
		{time = 18/35, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 27/35, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	iron_fire_1 = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 14/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	iron_fire_2 = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 14/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M590_EMPTY"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 20/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 28/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	foregrip_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 30/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_fire_1 = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 14/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	foregrip_fire_2 = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 14/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M590_EMPTY"},
	},

	foregrip_reload_insert = {
		{time = 5/36, sound = "CW_KK_INS2_M590_SHELLINSERT"},
	},

	foregrip_reload_end_empty = {
		{time = 18/35, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 27/35, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	foregrip_iron_fire_1 = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 14/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	foregrip_iron_fire_2 = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 14/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_M590_EMPTY"},
	},
}


