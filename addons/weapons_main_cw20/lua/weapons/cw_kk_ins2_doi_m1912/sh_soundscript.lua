--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1912/sh_soundscript.lua

--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

SWEP.Sounds = {
	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 26/30, sound = "CW_KK_INS2_DOI_M1912_PUMPBACK"},
		{time = 36/30, sound = "CW_KK_INS2_DOI_M1912_PUMPFORWARD"},
	},

	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_fire_cock_1 = {
		{time = 1/24, sound = "CW_KK_INS2_DOI_M1912_PUMPBACK"},
		{time = 2/24, sound = "", callback = shell},
		{time = 5/24, sound = "CW_KK_INS2_DOI_M1912_PUMPFORWARD"},
		// pumpedrdy @ 6 ""},
	},

	base_fire_cock_2 = {
		{time = 1/24, sound = "CW_KK_INS2_DOI_M1912_PUMPBACK"},
		{time = 2/24, sound = "", callback = shell},
		{time = 5/24, sound = "CW_KK_INS2_DOI_M1912_PUMPFORWARD"},
		// pumpedrdy @ 6 ""},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1912_EMPTY"},
	},

	base_reload_start = {
		{time = 5/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reload_start_empty = {
		{time = 5/35, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1912_PUMPBACK"},
		{time = 20/35, sound = "", callback = shell},
		{time = 51/35, sound = "CW_KK_INS2_DOI_M1912_SHELLINSERTSINGLE"},
		{time = 76/35, sound = "CW_KK_INS2_DOI_M1912_PUMPFORWARD"},
		// reloaded @ 78 ""},
	},

	base_reload_insert = {
		{time = 5/36, sound = "CW_KK_INS2_DOI_M1912_SHELLINSERT"},
		// reloaded @ 15 ""},
	},

	base_reload_end = {
		{time = 5/35, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reload_end_empty = {
		{time = 5/35, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	iron_fire_cock_1 = {
		{time = 3/35, sound = "CW_KK_INS2_DOI_M1912_PUMPBACK"},
		{time = 4/35, sound = "", callback = shell},
		{time = 11/35, sound = "CW_KK_INS2_DOI_M1912_PUMPFORWARD"},
		// pumpedrdy @ 12 ""},
	},

	iron_fire_cock_2 = {
		{time = 3/35, sound = "CW_KK_INS2_DOI_M1912_PUMPBACK"},
		{time = 4/35, sound = "", callback = shell},
		{time = 11/35, sound = "CW_KK_INS2_DOI_M1912_PUMPFORWARD"},
		// pumpedrdy @ 12 ""},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1912_EMPTY"},
	},
}
