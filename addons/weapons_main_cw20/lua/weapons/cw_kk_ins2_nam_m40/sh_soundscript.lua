--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m40/sh_soundscript.lua

--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

-- {time = 21/30, sound = "", callback = shell},

SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 18/30, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 30/30, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		{time = 37/30, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
		{time = 55/30, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
	},

	base_draw = {
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fire_end = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 9/29, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 13/29, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 14/29, sound = "", callback = shell},
		{time = 17/29, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		// { event AE_WPN_COCK 19 ""},
		{time = 22/29, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
		// { event AE_WPN_READY 37 ""},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_SPRING_EMPTY"},
	},

	base_reload_start = {
		{time = 17/30.56, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 22/30.56, sound = "", callback = shell},
		{time = 24/30.56, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		// { event AE_CL_CREATE_PARTICLE_BRASS 22 ""},
	},

	base_reload_insert = {
		{time = 15/32.3, sound = "CW_KK_INS2_DOI_SPRING_BULLETIN"},
		// { event 46 20 ""},
	},

	base_reload_end = {
		{time = 10/30, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		{time = 15/30, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
		// { event AE_WPN_READY 27 ""},
	},

	base_melee_bash = {
		{time = 15/31, sound = "CW_KK_INS2_DOI_MELEE"},
		// { event 1338 18 ""},
		// { event AE_WPN_READY 43 ""},
	},

	iron_fire_end = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 14 ""},
		{time = 9/29, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 13/29, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 14/29, sound = "", callback = shell},
		{time = 18/29, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		// { event AE_WPN_COCK 18 ""},
		{time = 21/29, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
		// { event AE_WPN_READY 36 ""},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_SPRING_EMPTY"},
	},
}
