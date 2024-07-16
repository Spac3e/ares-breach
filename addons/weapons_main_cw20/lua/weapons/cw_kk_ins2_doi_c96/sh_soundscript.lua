--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_c96/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_draw = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_C96_EMPTY"},
	},

	base_reload_clip = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 33/31.8, sound = "CW_KK_INS2_DOI_M1911_BOLTBACK"},
		{time = 35/31.8, sound = "CW_KK_INS2_DOI_WEBLEY_DUMPROUNDS"},
		{time = 48/31.8, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 50/31.8, sound = "CW_KK_INS2_DOI_C96_FETCHMAG"},
		{time = 75/31.8, sound = "CW_KK_INS2_DOI_C96_MAGFIDDLE"},
		{time = 82/31.8, sound = "CW_KK_INS2_DOI_C96_STRIPPER_IN"},
		{time = 99/31.8, sound = "CW_KK_INS2_DOI_C96_STRIPPER_ROUNDSIN1"},
		{time = 104/31.8, sound = "CW_KK_INS2_DOI_C96_STRIPPER_ROUNDSIN2"},
		{time = 139/31.8, sound = "CW_KK_INS2_DOI_C96_STRIPPER_REMOVE"},
		{time = 141/31.8, sound = "CW_KK_INS2_DOI_C96_BOLTRELEASE"},
		{time = 166/31.8, sound = "CW_KK_INS2_DOI_C96_RATTLE"},
	},

	base_reload_empty_clip = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 10/31.8, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 12/31.8, sound = "CW_KK_INS2_DOI_C96_FETCHMAG"},
		{time = 37/31.8, sound = "CW_KK_INS2_DOI_C96_MAGFIDDLE"},
		{time = 44/31.8, sound = "CW_KK_INS2_DOI_C96_STRIPPER_IN"},
		{time = 59/31.8, sound = "CW_KK_INS2_DOI_C96_STRIPPER_ROUNDSIN1"},
		{time = 68/31.8, sound = "CW_KK_INS2_DOI_C96_STRIPPER_ROUNDSIN2"},
		// { event 46 72 ""},
		{time = 96/31.8, sound = "CW_KK_INS2_DOI_C96_STRIPPER_REMOVE"},
		{time = 98/31.8, sound = "CW_KK_INS2_DOI_C96_BOLTRELEASE"},
		{time = 128/31.8, sound = "CW_KK_INS2_DOI_C96_RATTLE"},
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
		{time = 0/30, sound = "CW_KK_INS2_DOI_C96_EMPTY"},
	},

	base_draw_empty = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_melee_bash = {
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash_empty = {
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
