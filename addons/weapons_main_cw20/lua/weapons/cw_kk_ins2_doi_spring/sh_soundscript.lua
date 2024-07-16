--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_spring/sh_soundscript.lua

--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 24/33, sound = "CW_KK_INS2_DOI_SPRING_EMPTY"},
		{time = 47/33, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 54/33, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 68/33, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		{time = 75/33, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
		{time = 96/33, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
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

	base_fire_end = {
		{time = 13/35, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 19/35, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 21/35, sound = "", callback = shell},
		{time = 26/35, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		{time = 33/35, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_SPRING_EMPTY"},
	},

	base_reload_clip = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClipM1},
		{time = 19/33.4, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 27/33.4, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		-- {time = 29/33.4, sound = "", callback = shell},
		{time = 37/33.4, sound = "CW_KK_INS2_DOI_SPRING_FETCHMAG"},
		{time = 50/33.4, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 64/33.4, sound = "CW_KK_INS2_DOI_SPRING_MAGIN"},
		{time = 80/33.4, sound = "CW_KK_INS2_DOI_SPRING_ROUNDSIN"},
		{time = 111/33.4, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARDSTRIPPERCLIP"},
		{time = 112/33.4, sound = "CW_KK_INS2_DOI_SPRING_STRIPPERCLIPEJECT"},
		{time = 119/33.4, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
	},

	base_reload_clip_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 19/33.4, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 27/33.4, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 29/33.4, sound = "", callback = shell},
		{time = 37/33.4, sound = "CW_KK_INS2_DOI_SPRING_FETCHMAG"},
		{time = 40/33.4, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 64/33.4, sound = "CW_KK_INS2_DOI_SPRING_MAGIN"},
		{time = 80/33.4, sound = "CW_KK_INS2_DOI_SPRING_ROUNDSIN"},
		{time = 111/33.4, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARDSTRIPPERCLIP"},
		{time = 112/33.4, sound = "CW_KK_INS2_DOI_SPRING_STRIPPERCLIPEJECT"},
		{time = 119/33.4, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
	},

	base_reload_start = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClipM1},
		{time = 19/34.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 27/34.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
	},

	base_reload_start_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 29 ""},
		{time = 19/34.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 27/34.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 29/34.5, sound = "", callback = shell},
	},

	base_reload_insert = {
		{time = 14/37.2, sound = "CW_KK_INS2_DOI_SPRING_BULLETIN"},
		-- { event 46 22 ""},
		{time = 22/37.2, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
	},

	base_reload_end = {
		{time = 14/34.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		{time = 21/34.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
	},

	iron_fire_end = {
		-- { event AE_CL_CREATE_PARTICLE_BRASS 18 ""},
		{time = 13/35, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 19/35, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 21/35, sound = "", callback = shell},
		{time = 26/35, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		-- { event AE_WPN_COCK 26 ""},
		{time = 33/35, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_SPRING_EMPTY"},
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

	glsetup_in = {
		{time = 17/33.5, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
		{time = 54/33.5, sound = "CW_KK_INS2_DOI_SPRING_GL_LOAD1"},
		{time = 63/33.5, sound = "CW_KK_INS2_DOI_SPRING_GL_LOAD2"},
		{time = 97/33.5, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
		{time = 110/33.5, sound = "CW_KK_INS2_DOI_SPRING_SHOULDER"},
	},

	glsetup_out = {
		{time = 12/33.5, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
		{time = 36/33.5, sound = "CW_KK_INS2_DOI_SPRING_GL_REMOVE"},
		{time = 81/33.5, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
		{time = 108/33.5, sound = "CW_KK_INS2_DOI_SPRING_SHOULDER"},
	},

	glsetup_out_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		// { event AE_CL_CREATE_PARTICLE_BRASS 21 ""},
		{time = 13/30.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 19/30.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 26/30.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		{time = 33/30.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
	},

	glsetup_draw = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_draw_empty = {
		{time = 0/33.5, sound = "CW_KK_INS2_UNIVERSAL_DRAW", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 36/33.5, sound = "CW_KK_INS2_DOI_SPRING_GL_LOAD1"},
		{time = 49/33.5, sound = "CW_KK_INS2_DOI_SPRING_GL_LOAD2"},
		{time = 102/33.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 110/33.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 120/33.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		{time = 129/33.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
		// { event AE_CL_CREATE_PARTICLE_BRASS 112 ""},
		// { event 46 52 ""},
		{time = 145/33.5, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
		{time = 156/33.5, sound = "CW_KK_INS2_DOI_SPRING_SHOULDER"},
	},

	glsetup_holster = {
		{time = 0/31.5, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	glsetup_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- glsetup_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // fps 32
	-- },

	glsetup_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_SPRING_EMPTY"},
	},

	glsetup_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 17/33.5, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
		{time = 54/33.5, sound = "CW_KK_INS2_DOI_SPRING_GL_LOAD1"},
		{time = 63/33.5, sound = "CW_KK_INS2_DOI_SPRING_GL_LOAD2"},
		{time = 119/33.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTRELEASE"},
		{time = 124/33.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTBACK"},
		{time = 135/33.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTFORWARD"},
		{time = 143/33.5, sound = "CW_KK_INS2_DOI_SPRING_BOLTLATCH"},
		// { event AE_CL_CREATE_PARTICLE_BRASS 125 ""},
		// { event 46 139 ""},
		{time = 164/33.5, sound = "CW_KK_INS2_DOI_SPRING_RATTLE"},
		{time = 168/33.5, sound = "CW_KK_INS2_DOI_SPRING_SHOULDER"},
	},

	glsetup_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_SPRING_EMPTY"},
	},

	glsetup_holster_empty = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	glsetup_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_empty = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash_empty = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end_empty = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
