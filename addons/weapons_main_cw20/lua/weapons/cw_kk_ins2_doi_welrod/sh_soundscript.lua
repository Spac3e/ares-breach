--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_welrod/sh_soundscript.lua

--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 17/32, sound = "CW_KK_INS2_DOI_WELROD_TWISTOPEN"},
		{time = 25/32, sound = "CW_KK_INS2_DOI_WELROD_BOLTBACK"},
		{time = 34/32, sound = "CW_KK_INS2_DOI_WELROD_BOLTRELEASE"},
		{time = 39/32, sound = "CW_KK_INS2_DOI_WELROD_TWISTCLOSE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fire_end = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 25 ""},
		-- { event AE_WPN_COCK 34 ""},
		{time = 15/30, sound = "CW_KK_INS2_DOI_WELROD_TWISTOPEN"},
		{time = 23/30, sound = "CW_KK_INS2_DOI_WELROD_BOLTBACK"},
		{time = 25/30, sound = "", callback = shell},
		{time = 32/30, sound = "CW_KK_INS2_DOI_WELROD_BOLTRELEASE"},
		{time = 37/30, sound = "CW_KK_INS2_DOI_WELROD_TWISTCLOSE"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_WELROD_EMPTY"},
	},

	base_reload = {
		{time = 21/30, sound = "CW_KK_INS2_DOI_WELROD_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_DOI_WELROD_MAGIN"},
		-- { event 46 67 ""},
	},

	base_reloadempty = {
		{time = 21/30, sound = "CW_KK_INS2_DOI_WELROD_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_DOI_WELROD_MAGIN"},
		{time = 87/30, sound = "CW_KK_INS2_DOI_WELROD_TWISTOPEN"},
		{time = 95/30, sound = "CW_KK_INS2_DOI_WELROD_BOLTBACK"},
		{time = 97/30, sound = "", callback = shell}, // nomz
		{time = 104/30, sound = "CW_KK_INS2_DOI_WELROD_BOLTRELEASE"},
		{time = 109/30, sound = "CW_KK_INS2_DOI_WELROD_TWISTCLOSE"},
		-- { event 46 112 ""},
	},

	iron_fire_end = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 25 ""},
		-- { event AE_WPN_COCK 34 ""},
		{time = 15/30, sound = "CW_KK_INS2_DOI_WELROD_TWISTOPEN"},
		{time = 23/30, sound = "CW_KK_INS2_DOI_WELROD_BOLTBACK"},
		{time = 25/30, sound = "", callback = shell},
		{time = 32/30, sound = "CW_KK_INS2_DOI_WELROD_BOLTRELEASE"},
		{time = 37/30, sound = "CW_KK_INS2_DOI_WELROD_TWISTCLOSE"},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_WELROD_EMPTY"},
	},

	base_melee_bash = {
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
