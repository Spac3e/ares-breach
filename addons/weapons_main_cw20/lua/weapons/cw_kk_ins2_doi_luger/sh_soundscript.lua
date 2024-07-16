--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_luger/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 25/30, sound = "CW_KK_INS2_DOI_P08_BOLTBACK"},
		{time = 35/30, sound = "CW_KK_INS2_DOI_P08_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0/33, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_P08_EMPTY"},
	},

	base_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 15/30, sound = "CW_KK_INS2_DOI_P08_MAGRELEASE"},
		{time = 20/30, sound = "CW_KK_INS2_DOI_P08_MAGOUT"},
		{time = 40/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 57/30, sound = "CW_KK_INS2_DOI_P08_MAGIN"},
		{time = 63/30, sound = "CW_KK_INS2_DOI_P08_MAGHIT"},
		// { event 46 66 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 40 ""},
	},

	base_reloadempty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 15/30, sound = "CW_KK_INS2_DOI_P08_MAGRELEASE"},
		{time = 20/30, sound = "CW_KK_INS2_DOI_P08_MAGOUT"},
		{time = 40/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 57/30, sound = "CW_KK_INS2_DOI_P08_MAGIN"},
		{time = 63/30, sound = "CW_KK_INS2_DOI_P08_MAGHIT"},
		// { event 46 66 ""},
		{time = 92/30, sound = "CW_KK_INS2_DOI_P08_BOLTRELEASE"},
		// { event AE_WPN_RELOAD_OFFSCREEN 40 ""},
	},

	empty_draw = {
		{time = 0/33, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	empty_holster = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_P08_EMPTY"},
	},

	base_melee_bash = {
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	empty_melee_bash = {
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
