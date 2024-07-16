--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_lewis/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 33/31, sound = "CW_KK_INS2_DOI_LEWIS_BOLTBACK"},
		{time = 62/31, sound = "CW_KK_INS2_DOI_LEWIS_RATTLE"},
		{time = 88/31, sound = "CW_KK_INS2_DOI_LEWIS_SHOULDERWEAPON"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire_1 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	-- base_fire_2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	-- base_fire_last = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_LEWIS_EMPTY"},
	},

	base_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 26/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGRELEASE"},
		{time = 40/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGOUTFULL"},
		{time = 53/34.5, sound = "CW_KK_INS2_DOI_LEWIS_FETCHMAG"},
		{time = 83/34.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 134/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGFIDDLE"},
		{time = 140/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGIN"},
		{time = 169/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGHIT"},
		{time = 198/34.5, sound = "CW_KK_INS2_DOI_LEWIS_RATTLE"},
		{time = 208/34.5, sound = "CW_KK_INS2_DOI_LEWIS_SHOULDERWEAPON"},
		-- { event 46 170 ""},
	},

	base_reloadempty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 26/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGRELEASE"},
		{time = 40/34.5, sound = "lewis_Magout"},
		{time = 53/34.5, sound = "CW_KK_INS2_DOI_LEWIS_FETCHMAG"},
		{time = 83/34.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 119/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGFIDDLE"},
		{time = 127/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGIN"},
		{time = 157/34.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGHIT"},
		-- { event 46 158 ""},
		{time = 197/34.5, sound = "CW_KK_INS2_DOI_LEWIS_BOLTBACK"},
		{time = 225/34.5, sound = "CW_KK_INS2_DOI_LEWIS_RATTLE"},
		{time = 239/34.5, sound = "CW_KK_INS2_DOI_LEWIS_SHOULDERWEAPON"},
	},

	-- iron_fire_1 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	-- iron_fire_2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	-- iron_fire_last = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_LEWIS_EMPTY"},
	},

	base_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	deployed_in = {
		{time = 19/36, sound = "CW_KK_INS2_DOI_LEWIS_DEPLOYGROUNDHIT"},
		{time = 40/36, sound = "CW_KK_INS2_DOI_LEWIS_RATTLE"},
		{time = 50/36, sound = "CW_KK_INS2_DOI_LEWIS_SHOULDERWEAPON"},
	},

	deployed_out = {
		{time = 20/36, sound = "CW_KK_INS2_DOI_LEWIS_RATTLE"},
		{time = 39/36, sound = "CW_KK_INS2_DOI_LEWIS_SHOULDERWEAPON"},
	},

	-- deployed_fire_1 = {
		-- { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	-- deployed_fire_2 = {
		-- { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	-- deployed_fire_last = {
		-- { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_LEWIS_EMPTY"},
	},

	deployed_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 26/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGRELEASE"},
		{time = 40/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGOUTFULL"},
		{time = 53/35.5, sound = "CW_KK_INS2_DOI_LEWIS_FETCHMAG"},
		{time = 83/35.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 134/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGFIDDLE"},
		{time = 140/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGIN"},
		{time = 169/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGHIT"},
		{time = 198/35.5, sound = "CW_KK_INS2_DOI_LEWIS_RATTLE"},
		{time = 208/35.5, sound = "CW_KK_INS2_DOI_LEWIS_SHOULDERWEAPON"},
		-- { event 46 170 ""},
	},

	deployed_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 26/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGRELEASE"},
		{time = 40/35.5, sound = "lewis_Magout"},
		{time = 53/35.5, sound = "CW_KK_INS2_DOI_LEWIS_FETCHMAG"},
		{time = 83/35.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 119/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGFIDDLE"},
		{time = 127/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGIN"},
		{time = 157/35.5, sound = "CW_KK_INS2_DOI_LEWIS_MAGHIT"},
		-- { event 46 158 ""},
		{time = 197/35.5, sound = "CW_KK_INS2_DOI_LEWIS_BOLTBACK"},
		{time = 225/35.5, sound = "CW_KK_INS2_DOI_LEWIS_RATTLE"},
		{time = 239/35.5, sound = "CW_KK_INS2_DOI_LEWIS_SHOULDERWEAPON"},
	},

	-- deployed_iron_fire_1 = {
		-- { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	-- deployed_iron_fire_2 = {
		-- { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	-- deployed_iron_fire_last = {
		-- { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
		-- fps 35
	-- },

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_LEWIS_EMPTY"},
	},

	base_melee_bash = {
		{time = 10/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
