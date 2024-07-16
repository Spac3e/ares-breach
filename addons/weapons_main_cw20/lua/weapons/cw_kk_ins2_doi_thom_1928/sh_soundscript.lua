--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_thom_1928/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 21/31, sound = "CW_KK_INS2_DOI_THOM_1928_BOLTRELEASE"},
		{time = 47/31, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire_last_drum = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_1928_EMPTY"},
	},

	base_dryfire_drum = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_1928_EMPTY"},
	},

	base_fireselect = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_1928_FIRESELECT"},
	},

	base_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_reload = {
		{time = 13/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGRELEASE"},
		{time = 20/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGOUT"},
		{time = 27/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGOUTRATTLE"},
		{time = 65/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGIN"},
		{time = 76/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGHIT"},
		// { event 46 77 ""},
		{time = 93/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	base_reloadempty = {
		{time = 13/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGRELEASE"},
		{time = 20/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGOUT"},
		{time = 27/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGOUTRATTLE"},
		{time = 83/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGTAP"},
		{time = 104/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGHIT"},
		{time = 118/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGIN"},
		// { event 46 119 ""},
		{time = 141/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	base_reload_drum = {
		{time = 19/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGRELEASE"},
		{time = 35/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGOUT"},
		{time = 40/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGOUTRATTLE"},
		{time = 42/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGFETCH"},
		{time = 112/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGIN"},
		{time = 140/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGHIT"},
		// { event 46 141 ""},
		{time = 159/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	base_reloadempty_drum = {
		{time = 28/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_BOLTRELEASE"},
		{time = 69/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGRELEASE"},
		{time = 83/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGOUT"},
		{time = 90/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGOUTRATTLE"},
		{time = 92/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGFETCH"},
		{time = 167/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGIN"},
		{time = 188/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGHIT"},
		// { event 46 189 ""},
		{time = 212/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	base_reload_null = {
		{time = 5/30, sound = "CW_KK_INS2_DOI_UNIVERSAL_A1"},
		{time = 31/30, sound = "CW_KK_INS2_DOI_UNIVERSAL_A2"},
		{time = 55/30, sound = "CW_KK_INS2_DOI_UNIVERSAL_A3"},
		{time = 69/30, sound = "CW_KK_INS2_DOI_UNIVERSAL_A4"},
		{time = 92/30, sound = "CW_KK_INS2_DOI_UNIVERSAL_A5"},
		{time = 116/30, sound = "CW_KK_INS2_DOI_UNIVERSAL_A6"},
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

	-- iron_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_last_drum = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_1928_EMPTY"},
	},

	iron_dryfire_drum = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_1928_EMPTY"},
	},

	iron_fireselect = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_1928_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 21/31, sound = "CW_KK_INS2_DOI_THOM_1928_BOLTRELEASE"},
		{time = 47/31, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	foregrip_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- foregrip_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- foregrip_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- foregrip_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- foregrip_fire_last_drum = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	foregrip_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_1928_EMPTY"},
	},

	foregrip_dryfire_drum = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_1928_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_1928_FIRESELECT"},
	},

	foregrip_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	foregrip_reload = {
		{time = 13/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGRELEASE"},
		{time = 20/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGOUT"},
		{time = 27/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGOUTRATTLE"},
		{time = 65/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGIN"},
		{time = 76/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGHIT"},
		// { event 46 77 ""},
		{time = 93/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	foregrip_reloadempty = {
		{time = 13/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGRELEASE"},
		{time = 20/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGOUT"},
		{time = 27/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGOUTRATTLE"},
		{time = 83/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGTAP"},
		{time = 104/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGHIT"},
		{time = 118/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGIN"},
		// { event 46 119 ""},
		{time = 141/31.5, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	foregrip_reload_drum = {
		{time = 19/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGRELEASE"},
		{time = 35/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGOUT"},
		{time = 40/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGOUTRATTLE"},
		{time = 42/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGFETCH"},
		{time = 112/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGIN"},
		{time = 140/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGHIT"},
		// { event 46 141 ""},
		{time = 159/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	foregrip_reloadempty_drum = {
		{time = 28/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_BOLTRELEASE"},
		{time = 69/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_MAGRELEASE"},
		{time = 83/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGOUT"},
		{time = 90/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGOUTRATTLE"},
		{time = 92/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGFETCH"},
		{time = 167/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGIN"},
		{time = 188/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_DRUMMAGHIT"},
		// { event 46 189 ""},
		{time = 212/32.5, sound = "CW_KK_INS2_DOI_THOM_1928_RATTLE"},
	},

	-- foregrip_iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- foregrip_iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- foregrip_iron_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- foregrip_iron_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- foregrip_iron_fire_last_drum = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	foregrip_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_1928_EMPTY"},
	},

	foregrip_iron_dryfire_drum = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_1928_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_1928_FIRESELECT"},
	},

	foregrip_draw_empty_drum = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster_empty_drum = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl_empty_drum = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_fireselect_empty_drum = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_1928_FIRESELECT"},
	},

	foregrip_melee_empty_drum = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	foregrip_iron_fireselect_empty_drum = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_1928_FIRESELECT"},
	},

	base_draw_empty_drum = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty_drum = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty_drum = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fireselect_empty_drum = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_1928_FIRESELECT"},
	},

	base_melee_empty_drum = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	iron_fireselect_empty_drum = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_1928_FIRESELECT"},
	},
}
