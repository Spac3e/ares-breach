--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_spas12/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_spas12/sh_soundscript.lua
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
		{time = 26/30, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 36/30, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_fire = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 13/30, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 18/30, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	base_fire_2 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 13/30, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 18/30, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_TOZ_EMPTY"},
	},

	base_reload_start = {
		{time = 5/30, sound = "CW_KK_INS2_UNIVERSAL_LeanIn"},
	},

	base_reload_start_empty = {
		{time = 5/30, sound = "CW_KK_INS2_UNIVERSAL_LeanIn"},
	},

	base_reload_insert = {
		{time = 5/36, sound = "CW_KK_INS2_TOZ_SHELLINSERT"},
	},

	base_reload_end = {
		{time = 5/35, sound = "CW_KK_INS2_UNIVERSAL_LeanIn"},
	},

	base_reload_end_empty = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 15 ""},
		{time = 14/35, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 24/35, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	-- iron_fire_1 = {
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 23 ""},
		-- {time = 22/40, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		-- {time = 30/40, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	-- },

	-- iron_fire_2 = {
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 23 ""},
		-- {time = 22/40, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		-- {time = 30/40, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	-- },

	iron_fire_1 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 23 ""},
		{time = 22/50, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 30/50, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	iron_fire_2 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 23 ""},
		{time = 22/50, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 30/50, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_TOZ_EMPTY"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 26/30, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 36/30, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	foregrip_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_fire_1 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 13/30, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 18/30, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	foregrip_fire_2 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 13/30, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 18/30, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_TOZ_EMPTY"},
	},

	foregrip_reload_start = {
		{time = 5/30, sound = "CW_KK_INS2_UNIVERSAL_LeanIn"},
	},

	foregrip_reload_start_empty = {
		{time = 5/30, sound = "CW_KK_INS2_UNIVERSAL_LeanIn"},
	},

	foregrip_reload_insert = {
		{time = 5/36, sound = "CW_KK_INS2_TOZ_SHELLINSERT"},
	},

	foregrip_reload_end = {
		{time = 5/35, sound = "CW_KK_INS2_UNIVERSAL_LeanIn"},
	},

	foregrip_reload_end_empty = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 15 ""},
		{time = 14/35, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 24/35, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	-- foregrip_iron_fire_1 = {
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 23 ""},
		-- {time = 22/40, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		-- {time = 30/40, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	-- },

	-- foregrip_iron_fire_2 = {
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 23 ""},
		-- {time = 22/40, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		-- {time = 30/40, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	-- },

	foregrip_iron_fire_1 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 23 ""},
		{time = 22/50, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 30/50, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	foregrip_iron_fire_2 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 23 ""},
		{time = 22/50, sound = "CW_KK_INS2_TOZ_PUMPBACK"},
		{time = 30/50, sound = "CW_KK_INS2_TOZ_PUMPFORWARD"},
	},

	foregrip_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_TOZ_EMPTY"},
	},
}


