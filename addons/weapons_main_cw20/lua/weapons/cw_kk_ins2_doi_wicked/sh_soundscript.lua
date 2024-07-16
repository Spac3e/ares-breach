--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_wicked/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/27, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 22/27, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	-- base_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_dryfire = {
		-- {time = 0/30, sound = "CW_KK_INS2_DOI_VICKERS_EMPTY"},
	-- },

	base_reload = {
		// { event 46 115 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 40 ""},
		{time = 40/38.2, sound = "CW_KK_INS2_DOI_VICKERS_FETCHMAG"},
		{time = 50/38.2, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 90/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BELTALIGN"},
		{time = 107/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BELTJINGLE"},
		{time = 127/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BELTDROP"},
		{time = 148/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BELTPULL"},
		{time = 190/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BOLTBACK"},
		{time = 202/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BOLTRELEASE"},
		{time = 218/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BOLTBACK"},
		{time = 227/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BOLTRELEASE"},
		{time = 279/38.2, sound = "CW_KK_INS2_DOI_VICKERS_SHOULDER"},
	},

	base_reloadempty = {
		// { event 46 115 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 40 ""},
		{time = 40/38.2, sound = "CW_KK_INS2_DOI_VICKERS_FETCHMAG"},
		{time = 50/38.2, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 90/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BELTALIGN"},
		{time = 107/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BELTJINGLE"},
		{time = 127/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BELTDROP"},
		{time = 148/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BELTPULL"},
		{time = 190/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BOLTBACK"},
		{time = 202/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BOLTRELEASE"},
		{time = 218/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BOLTBACK"},
		{time = 227/38.2, sound = "CW_KK_INS2_DOI_VICKERS_BOLTRELEASE"},
		{time = 279/38.2, sound = "CW_KK_INS2_DOI_VICKERS_SHOULDER"},
	},

	base_melee_bash = {
		{time = 10/31, sound = "CW_KK_INS2_DOI_MELEE"},
		// { event AE_WPN_READY 55 ""},
	},

	-- iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_VICKERS_EMPTY"},
	},

	deployed_in = {
		{time = 28/36, sound = "CW_KK_INS2_DOI_VICKERS_DEPLOYGROUNDHIT"},
		-- // { event AE_WPN_READY 53 ""},
		-- // fps 36
	},

	-- deployed_out = {
		-- // { event AE_WPN_READY 45 ""},
		-- // fps 36
	-- },

	-- deployed_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- deployed_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	deployed_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_VICKERS_EMPTY"},
	},

	deployed_reload = {
		// { event 46 115 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 40 ""},
		// { event AE_WPN_READY 227 ""},
		{time = 40/30, sound = "CW_KK_INS2_DOI_VICKERS_FETCHMAG"},
		{time = 50/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 65/30, sound = "CW_KK_INS2_DOI_VICKERS_BELTALIGN"},
		{time = 81/30, sound = "CW_KK_INS2_DOI_VICKERS_BELTJINGLE"},
		{time = 96/30, sound = "CW_KK_INS2_DOI_VICKERS_BELTDROP"},
		{time = 140/30, sound = "CW_KK_INS2_DOI_VICKERS_BOLTBACK"},
		{time = 151/30, sound = "CW_KK_INS2_DOI_VICKERS_BOLTRELEASE"},
		{time = 166/30, sound = "CW_KK_INS2_DOI_VICKERS_BOLTBACK"},
		{time = 176/30, sound = "CW_KK_INS2_DOI_VICKERS_BOLTRELEASE"},
		{time = 226/30, sound = "CW_KK_INS2_DOI_VICKERS_SHOULDER"},
	},

	deployed_reload_empty = {
		// { event 46 115 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 40 ""},
		// { event AE_WPN_READY 227 ""},
		{time = 40/33, sound = "CW_KK_INS2_DOI_VICKERS_FETCHMAG"},
		{time = 50/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 65/33, sound = "CW_KK_INS2_DOI_VICKERS_BELTALIGN"},
		{time = 81/33, sound = "CW_KK_INS2_DOI_VICKERS_BELTJINGLE"},
		{time = 96/33, sound = "CW_KK_INS2_DOI_VICKERS_BELTDROP"},
		{time = 140/33, sound = "CW_KK_INS2_DOI_VICKERS_BOLTBACK"},
		{time = 151/33, sound = "CW_KK_INS2_DOI_VICKERS_BOLTRELEASE"},
		{time = 166/33, sound = "CW_KK_INS2_DOI_VICKERS_BOLTBACK"},
		{time = 176/33, sound = "CW_KK_INS2_DOI_VICKERS_BOLTRELEASE"},
		{time = 226/33, sound = "CW_KK_INS2_DOI_VICKERS_SHOULDER"},
	},

	-- deployed_iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- deployed_iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- deployed_iron_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	deployed_iron_dryfire = {
		{time = 0/32, sound = "CW_KK_INS2_DOI_VICKERS_EMPTY"},
	},
}
