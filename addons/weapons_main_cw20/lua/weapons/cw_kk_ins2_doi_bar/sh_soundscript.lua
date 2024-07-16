--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_bar/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 28/30, sound = "CW_KK_INS2_DOI_BAR_BOLTBACK"},
		{time = 38/30, sound = "CW_KK_INS2_DOI_BAR_BOLTRELEASE"},
		{time = 59/30, sound = "CW_KK_INS2_DOI_BAR_RATTLE"},
	},

	base_draw = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/33, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
	-- },

	-- base_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
	-- },

	-- base_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_BAR_EMPTY"},
	},

	base_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_DOI_BAR_FIRESELECT"},
	},

	base_reloadfull = {
		{time = 17/33, sound = "CW_KK_INS2_DOI_BAR_MAGRELEASE"},
		{time = 30/33, sound = "CW_KK_INS2_DOI_BAR_MAGOUT"},
		{time = 35/33, sound = "CW_KK_INS2_DOI_BAR_FETCHMAG"},
		// { event 46 117 ""},
		{time = 91/33, sound = "CW_KK_INS2_DOI_BAR_MAGIN"},
		{time = 116/33, sound = "CW_KK_INS2_DOI_BAR_MAGHIT"},
		{time = 134/33, sound = "CW_KK_INS2_DOI_BAR_RATTLE"},
	},

	base_reloadempty = {
		{time = 28/33, sound = "CW_KK_INS2_DOI_BAR_BOLTBACK"},
		{time = 39/33, sound = "CW_KK_INS2_DOI_BAR_BOLTRELEASE"},
		{time = 62/33, sound = "CW_KK_INS2_DOI_BAR_MAGRELEASE"},
		{time = 74/33, sound = "CW_KK_INS2_DOI_BAR_MAGOUT"},
		{time = 79/33, sound = "CW_KK_INS2_DOI_BAR_FETCHMAG"},
		// { event 46 162 ""},
		{time = 133/33, sound = "CW_KK_INS2_DOI_BAR_MAGIN"},
		{time = 161/33, sound = "CW_KK_INS2_DOI_BAR_MAGHIT"},
		{time = 179/33, sound = "CW_KK_INS2_DOI_BAR_RATTLE"},
	},

	-- iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
	-- },

	-- iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_BAR_EMPTY"},
	},

	iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_DOI_BAR_FIRESELECT"},
	},

	deployed_in = {
		{time = 23/32, sound = "CW_KK_INS2_DOI_BAR_DEPLOYGROUNDHIT"},
	},

	deployed_out = {
		{time = 13/32, sound = "CW_KK_INS2_DOI_BAR_RATTLE"},
	},

	-- deployed_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- deployed_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	deployed_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_BAR_EMPTY"},
	},

	deployed_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_DOI_BAR_FIRESELECT"},
	},

	deployed_reload = {
		{time = 17/33, sound = "CW_KK_INS2_DOI_BAR_MAGRELEASE"},
		{time = 30/33, sound = "CW_KK_INS2_DOI_BAR_MAGOUT"},
		{time = 35/33, sound = "CW_KK_INS2_DOI_BAR_FETCHMAG"},
		// { event 46 117 ""},
		{time = 91/33, sound = "CW_KK_INS2_DOI_BAR_MAGIN"},
		{time = 116/33, sound = "CW_KK_INS2_DOI_BAR_MAGHIT"},
	},

	deployed_reload_empty = {
		{time = 28/33, sound = "CW_KK_INS2_DOI_BAR_BOLTBACK"},
		{time = 39/33, sound = "CW_KK_INS2_DOI_BAR_BOLTRELEASE"},
		{time = 62/33, sound = "CW_KK_INS2_DOI_BAR_MAGRELEASE"},
		{time = 74/33, sound = "CW_KK_INS2_DOI_BAR_MAGOUT"},
		{time = 79/33, sound = "CW_KK_INS2_DOI_BAR_FETCHMAG"},
		// { event 46 162 ""},
		{time = 133/33, sound = "CW_KK_INS2_DOI_BAR_MAGIN"},
		{time = 161/33, sound = "CW_KK_INS2_DOI_BAR_MAGHIT"},
	},

	-- deployed_iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- deployed_iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- deployed_iron_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	deployed_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_BAR_EMPTY"},
	},

	deployed_iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_DOI_BAR_FIRESELECT"},
	},

	base_draw_empty = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	deployed_in_empty = {
		{time = 11/32, sound = "CW_KK_INS2_DOI_BAR_DEPLOYGROUNDHIT"},
	},

	deployed_out_empty = {
		{time = 13/32, sound = "CW_KK_INS2_DOI_BAR_RATTLE"},
	},

	deployed_fireselect_empty = {
		{time = 13/30, sound = "CW_KK_INS2_DOI_BAR_FIRESELECT"},
	},

	base_melee_bash = {
		{time = 13/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
