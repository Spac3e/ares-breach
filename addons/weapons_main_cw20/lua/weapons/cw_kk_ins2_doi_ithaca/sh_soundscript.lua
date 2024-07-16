--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_ithaca/sh_soundscript.lua

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
		{time = 22/30, sound = "CW_KK_INS2_DOI_ITHC_PUMPBACK"},
		{time = 36/30, sound = "CW_KK_INS2_DOI_ITHC_PUMPFORWARD"},
	},

	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_fire_cock_1 = {
		{time = 5/35, sound = "CW_KK_INS2_DOI_ITHC_PUMPBACK"},
		{time = 7/35, sound = "", callback = shell},
		{time = 11/35, sound = "CW_KK_INS2_DOI_ITHC_PUMPFORWARD"},
	},

	base_fire_cock_2 = {
		{time = 5/35, sound = "CW_KK_INS2_DOI_ITHC_PUMPBACK"},
		{time = 7/35, sound = "", callback = shell},
		{time = 11/35, sound = "CW_KK_INS2_DOI_ITHC_PUMPFORWARD"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_ITHC_EMPTY"},
	},

	base_reload_start = {
		{time = 5/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reload_start_empty = {
		{time = 5/36, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 22/36, sound = "CW_KK_INS2_DOI_ITHC_SHELLINSERTSINGLE"},
		{time = 49/36, sound = "CW_KK_INS2_DOI_ITHC_RATTLE"},
		{time = 56/36, sound = "CW_KK_INS2_DOI_ITHC_PUMPBACK"},
		{time = 58/36, sound = "", callback = shell},
		{time = 64/36, sound = "CW_KK_INS2_DOI_ITHC_PUMPFORWARD"},
	},

	base_reload_insert = {
		{time = 9/42, sound = "CW_KK_INS2_DOI_ITHC_SHELLINSERT"},
	},

	base_reload_end = {
		{time = 5/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 11/32, sound = "CW_KK_INS2_DOI_ITHC_RATTLE"},
	},

	base_reload_end_empty = {
		{time = 5/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 11/32, sound = "CW_KK_INS2_DOI_ITHC_RATTLE"},
	},

	iron_fire_cock_1 = {
		{time = 5/35, sound = "CW_KK_INS2_DOI_ITHC_PUMPBACK"},
		{time = 7/35, sound = "", callback = shell},
		{time = 11/35, sound = "CW_KK_INS2_DOI_ITHC_PUMPFORWARD"},
	},

	iron_fire_cock_2 = {
		{time = 5/35, sound = "CW_KK_INS2_DOI_ITHC_PUMPBACK"},
		{time = 7/35, sound = "", callback = shell},
		{time = 11/35, sound = "CW_KK_INS2_DOI_ITHC_PUMPFORWARD"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_ITHC_EMPTY"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end = {
		{time = 1/35, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
