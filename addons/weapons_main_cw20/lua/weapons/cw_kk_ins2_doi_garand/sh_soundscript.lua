--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_garand/sh_soundscript.lua

--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

local function clip(wep)
	if SERVER then return end

	wep:shellEvent2()
end

SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 24/30, sound = "CW_KK_INS2_DOI_GARAND_BOLTRELEASE"},
		{time = 41/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
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

	base_fire_1 = {
		// { event AE_MUZZLEFLASH 0 ""},
		// { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
		{time = 0.09, sound = "", callback = shell},
	},

	base_fire_2 = {
		// { event AE_MUZZLEFLASH 0 ""},
		// { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
		{time = 0.09, sound = "", callback = shell},
	},

	base_fire_last = {
		// { event AE_MUZZLEFLASH 0 ""},
		// { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
		// { event AE_EMIT_SHELL_CLIP 1 ""},
		// { event AE_VM_GLOBALSOUND 0/30, sound = "garaj_Ping"},
		{time = 0, sound = "CW_KK_INS2_DOI_GARAND_PING"},
		{time = 0.06, sound = "", callback = shell},
		{time = 0.45, sound = "", callback = clip},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_GARAND_EMPTY"},
	},

	base_reloadfull = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/30, sound = "CW_KK_INS2_DOI_GARAND_MAGRELEASE"},
		{time = 32/31.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTBACK"},
		{time = 35/31.5, sound = "CW_KK_INS2_DOI_GARAND_MAGOUT"},
		{time = 50/31.5, sound = "CW_KK_INS2_DOI_GARAND_FETCHMAG"},
		{time = 55/31.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		// { event 46 113 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 80 ""},
		{time = 93/31.5, sound = "CW_KK_INS2_DOI_GARAND_MAGIN"},
		{time = 110/31.5, sound = "CW_KK_INS2_DOI_GARAND_MAGHIT"},
		{time = 120/31.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTRELEASE"},
		{time = 137/31.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
	},

	base_reloadempty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/31.5, sound = "CW_KK_INS2_DOI_GARAND_FETCHMAG"},
		// { event 46 60 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 28 ""},
		{time = 28/31.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 47/31.5, sound = "CW_KK_INS2_DOI_GARAND_MAGIN"},
		{time = 65/31.5, sound = "CW_KK_INS2_DOI_GARAND_MAGHIT"},
		{time = 75/31.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTRELEASE"},
		{time = 92/31.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
	},

	base_reloadempty_null = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/30, sound = "CW_KK_INS2_DOI_GARAND_FETCHMAG"},
		{time = 28/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 47/30, sound = "CW_KK_INS2_DOI_GARAND_MAGIN"},
		{time = 65/30, sound = "CW_KK_INS2_DOI_GARAND_MAGHIT"},
		{time = 75/30, sound = "CW_KK_INS2_DOI_GARAND_BOLTRELEASE"},
		{time = 78/30, sound = "CW_KK_INS2_DOI_PLAYER_DAMAGEMAJOR"},
		{time = 85/30, sound = "CW_KK_INS2_DOI_UNIVERSAL_ADSIN"},
		{time = 102/30, sound = "CW_KK_INS2_DOI_PLAYER_DAMAGEMINOR"},
		{time = 104/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 137/30, sound = "CW_KK_INS2_DOI_UNIVERSAL_LOWER"},
		{time = 165/30, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
	},

	iron_fire_1 = {
		// { event AE_MUZZLEFLASH 0 ""},
		// { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
		{time = 0.09, sound = "", callback = shell},
	},

	iron_fire_2 = {
		// { event AE_MUZZLEFLASH 0 ""},
		// { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
		{time = 0.09, sound = "", callback = shell},
	},

	iron_fire_3 = {
		// { event AE_MUZZLEFLASH 0 ""},
		// { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
		{time = 0.09, sound = "", callback = shell},
	},

	iron_fire_last = {
		// { event AE_MUZZLEFLASH 0 ""},
		// { event AE_CL_CREATE_PARTICLE_BRASS 1 ""},
		// { event AE_EMIT_SHELL_CLIP 1 ""},
		// { event AE_VM_GLOBALSOUND 0/30, sound = "garaj_Ping"},
		{time = 0, sound = "CW_KK_INS2_DOI_GARAND_PING"},
		{time = 0.06, sound = "", callback = shell},
		{time = 0.45, sound = "", callback = clip},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_GARAND_EMPTY"},
	},

	base_draw_empty = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty = {
		{time = 0/33, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	glsetup_in = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGRELEASE"},
		{time = 32/33.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTBACK"},
		{time = 35/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGOUT"},
		{time = 50/33.5, sound = "CW_KK_INS2_DOI_GARAND_FETCHMAG"},
		{time = 94/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGIN"},
		{time = 110/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGHIT"},
		{time = 121/33.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTRELEASE"},
		{time = 153/33.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
		{time = 194/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_LOAD1"},
		{time = 204/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_LOAD2"},
		{time = 245/33.5, sound = "CW_KK_INS2_DOI_GARAND_SHOULDER"},
	},

	glsetup_in_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGRELEASE"},
		{time = 32/33.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTBACK"},
		{time = 35/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGOUT"},
		{time = 50/33.5, sound = "CW_KK_INS2_DOI_GARAND_FETCHMAG"},
		{time = 94/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGIN"},
		{time = 110/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGHIT"},
		{time = 121/33.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTRELEASE"},
		{time = 153/33.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
		{time = 194/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_LOAD1"},
		{time = 204/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_LOAD2"},
		{time = 245/33.5, sound = "CW_KK_INS2_DOI_GARAND_SHOULDER"},
	},

	glsetup_out = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 12/33.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
		{time = 43/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_REMOVE"},
		{time = 96/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGRELEASE"},
		{time = 110/33.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTBACK"},
		{time = 112/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGOUT"},
		{time = 135/33.5, sound = "CW_KK_INS2_DOI_GARAND_FETCHMAG"},
		{time = 171/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGIN"},
		{time = 188/33.5, sound = "CW_KK_INS2_DOI_GARAND_MAGHIT"},
		{time = 199/33.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTRELEASE"},
		{time = 218/33.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
	},

	glsetup_out_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/30.5, sound = "CW_KK_INS2_DOI_GARAND_MAGRELEASE"},
		{time = 32/30.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTBACK"},
		{time = 35/30.5, sound = "CW_KK_INS2_DOI_GARAND_MAGOUT"},
		{time = 50/30.5, sound = "CW_KK_INS2_DOI_GARAND_FETCHMAG"},
		{time = 55/30.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
		{time = 94/30.5, sound = "CW_KK_INS2_DOI_GARAND_MAGIN"},
		{time = 110/30.5, sound = "CW_KK_INS2_DOI_GARAND_MAGHIT"},
		{time = 121/30.5, sound = "CW_KK_INS2_DOI_GARAND_BOLTRELEASE"},
		{time = 138/30.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
	},

	glsetup_draw = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_draw_empty = {
		{time = 0/33.5, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 43/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_LOAD1"},
		{time = 52/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_LOAD2"},
		{time = 90/33.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
		{time = 100/33.5, sound = "CW_KK_INS2_DOI_GARAND_SHOULDER"},
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
	-- },

	glsetup_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_GARAND_EMPTY"},
	},

	glsetup_reload = {
		{time = 16/33.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
		{time = 53/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_LOAD1"},
		{time = 65/33.5, sound = "CW_KK_INS2_DOI_GARAND_GL_LOAD2"},
		// { event 46 58 ""},
		{time = 106/33.5, sound = "CW_KK_INS2_DOI_GARAND_RATTLE"},
		{time = 113/33.5, sound = "CW_KK_INS2_DOI_GARAND_SHOULDER"},
	},

	-- glsetup_iron_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
	-- },

	glsetup_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_GARAND_EMPTY"},
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
