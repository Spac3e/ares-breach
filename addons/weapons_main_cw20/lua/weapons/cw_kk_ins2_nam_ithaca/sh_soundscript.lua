--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_ithaca/sh_soundscript.lua

--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

SWEP.Sounds = {
	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_holster = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 21/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 28/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
	},

	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	-- base_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
	-- },

	-- base_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
	-- },

	base_fire_cock_1 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 3 ""},
		{time = 2/28, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 3/28, sound = "", callback = shell},
		{time = 6/28, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
		// { event AE_WPN_COCK 5 ""},
	},

	base_fire_cock_2 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 3 ""},
		{time = 2/28, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 3/28, sound = "", callback = shell},
		{time = 6/28, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
		// { event AE_WPN_COCK 5 ""},
	},

	-- base_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M590_EMPTY"},
	},

	base_reload_start = {
		{time = 5/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reload_start_empty = {
		{time = 2/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 5/30, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 7/30, sound = "", callback = shell},
		// { event AE_CL_CREATE_PARTICLE_BRASS 7 ""},
		{time = 33/30, sound = "CW_KK_INS2_M590_SHELLINSERTSINGLE"},
		{time = 53/30, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
		// { event 46 54 ""},
	},

	base_reload_insert = {
		{time = 5/30, sound = "CW_KK_INS2_M590_SHELLINSERT"},
		// { event 46 14 ""},
	},

	base_reload_insert2 = {
		{time = 5/30, sound = "CW_KK_INS2_M590_SHELLINSERT"},
		// { event 46 14 ""},
	},

	base_reload_end = {
		{time = 5/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reload_end_empty = {
		{time = 5/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	-- iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
	-- },

	-- iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
	-- },

	iron_fire_cock_1 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 6 ""},
		{time = 4/29, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 6/29, sound = "", callback = shell},
		{time = 8/29, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
		// { event AE_WPN_COCK 11 ""},
	},

	iron_fire_cock_2 = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 6 ""},
		{time = 4/29, sound = "CW_KK_INS2_M590_PUMPBACK"},
		{time = 6/29, sound = "", callback = shell},
		{time = 8/29, sound = "CW_KK_INS2_M590_PUMPFORWARD"},
		// { event AE_WPN_COCK 11 ""},
	},

	-- iron_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M590_EMPTY"},
	},
}
