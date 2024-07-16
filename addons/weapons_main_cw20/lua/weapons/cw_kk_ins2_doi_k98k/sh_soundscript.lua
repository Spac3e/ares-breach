--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_k98k/sh_soundscript.lua

--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

local function blankLoaded(wep)
	if SERVER then return end

	wep._blankWW2Loaded = true
end

local function removeBlank(wep)
	if SERVER then return end

	wep._blankWW2Loaded = false
end

local function dryFireInterruptedGL(wep)
	if SERVER then return end

	if wep._blankWW2Loaded then
		removeBlank(wep)
		wep:CreateMuzzle()
		wep:EmitSound(wep.FireSound)
	else
		wep:EmitSound("CW_KK_INS2_DOI_K98_EMPTY")
	end
end

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 22/33, sound = "CW_KK_INS2_DOI_K98_EMPTY"},
		{time = 47/33, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 54/33, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 68/33, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 75/33, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
		{time = 96/33, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fire_end = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 20 ""},
		{time = 13/35, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 14/35, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 20/35, sound = "", callback = shell},
		{time = 22/35, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		// { event AE_WPN_COCK 24 ""},
		{time = 26/35, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_K98_EMPTY"},
	},

	base_reload_clip = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 19/35, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		-- {time = 29/35, sound = "", callback = shell},
		{time = 37/35, sound = "CW_KK_INS2_DOI_K98_FETCHMAG"},
		{time = 40/35, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 64/35, sound = "CW_KK_INS2_DOI_K98_MAGIN"},
		{time = 80/35, sound = "CW_KK_INS2_DOI_K98_ROUNDSIN"},
		{time = 111/35, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARDSTRIPPERCLIP"},
		{time = 112/35, sound = "CW_KK_INS2_DOI_K98_STRIPPERCLIPEJECT"},
		{time = 119/35, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	base_reload_clip_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 19/35, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 29/35, sound = "", callback = shell},
		{time = 37/35, sound = "CW_KK_INS2_DOI_K98_FETCHMAG"},
		{time = 40/35, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 64/35, sound = "CW_KK_INS2_DOI_K98_MAGIN"},
		{time = 80/35, sound = "CW_KK_INS2_DOI_K98_ROUNDSIN"},
		{time = 111/35, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARDSTRIPPERCLIP"},
		{time = 112/35, sound = "CW_KK_INS2_DOI_K98_STRIPPERCLIPEJECT"},
		{time = 119/35, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	base_reload_start = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClipM1},
		{time = 19/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
	},

	base_reload_start_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		// { event AE_CL_CREATE_PARTICLE_BRASS 29 ""},
		{time = 19/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 29/35.5, sound = "", callback = shell},
	},

	base_reload_insert = {
		{time = 14/37.2, sound = "CW_KK_INS2_DOI_K98_BULLETIN"},
		{time = 21/37.2, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		// { event 46 22 ""},
	},

	base_reload_end = {
		{time = 14/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 21/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	iron_fire_end = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 18 ""},
		{time = 13/35, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 16/35, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 18/35, sound = "", callback = shell},
		{time = 24/35, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		// { event AE_WPN_COCK 26 ""},
		{time = 27/35, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_K98_EMPTY"},
	},

	gl_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 22/33, sound = "CW_KK_INS2_DOI_K98_EMPTY"},
		{time = 47/33, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 54/33, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 68/33, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 75/33, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
		{time = 96/33, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
	},

	gl_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	gl_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	gl_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	gl_fire_end = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 20 ""},
		{time = 13/35, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 14/35, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 20/35, sound = "", callback = shell},
		{time = 22/35, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		// { event AE_WPN_COCK 24 ""},
		{time = 26/35, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	gl_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_K98_EMPTY"},
	},

	gl_reload_clip = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		// { event AE_CL_CREATE_PARTICLE_BRASS 29 ""},
		{time = 19/35, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		-- {time = 29/35, sound = "", callback = shell},
		// { event 46 88 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 40 ""},
		{time = 37/35, sound = "CW_KK_INS2_DOI_K98_FETCHMAG"},
		{time = 40/35, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 64/35, sound = "CW_KK_INS2_DOI_K98_MAGIN"},
		{time = 80/35, sound = "CW_KK_INS2_DOI_K98_ROUNDSIN"},
		{time = 111/35, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARDSTRIPPERCLIP"},
		{time = 112/35, sound = "CW_KK_INS2_DOI_K98_STRIPPERCLIPEJECT"},
		{time = 119/35, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	gl_reload_clip_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		// { event AE_CL_CREATE_PARTICLE_BRASS 29 ""},
		{time = 19/35, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 29/35, sound = "", callback = shell},
		// { event 46 88 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 40 ""},
		{time = 37/35, sound = "CW_KK_INS2_DOI_K98_FETCHMAG"},
		{time = 40/35, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 64/35, sound = "CW_KK_INS2_DOI_K98_MAGIN"},
		{time = 80/35, sound = "CW_KK_INS2_DOI_K98_ROUNDSIN"},
		{time = 111/35, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARDSTRIPPERCLIP"},
		{time = 112/35, sound = "CW_KK_INS2_DOI_K98_STRIPPERCLIPEJECT"},
		{time = 119/35, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	gl_reload_start = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClipM1},
		{time = 19/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
	},

	gl_reload_start_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		// { event AE_CL_CREATE_PARTICLE_BRASS 29 ""},
		{time = 19/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 29/35.5, sound = "", callback = shell},
	},

	gl_reload_insert = {
		// { event AE_WPN_RELOAD_OFFSCREEN 21 ""},
		{time = 14/37.2, sound = "CW_KK_INS2_DOI_K98_BULLETIN"},
		{time = 21/37.2, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		// { event 46 22 ""},
	},

	gl_reload_end = {
		{time = 14/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 21/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	gl_iron_fire_end = {
		// { event AE_CL_CREATE_PARTICLE_BRASS 18 ""},
		{time = 13/35, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 16/35, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 18/35, sound = "", callback = shell},
		{time = 24/35, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		// { event AE_WPN_COCK 26 ""},
		{time = 27/35, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
	},

	gl_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_K98_EMPTY"},
	},

	glsetup_in = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClipM1},
		{time = 19/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 66/35.5, sound = "CW_KK_INS2_DOI_K98_BULLETIN", callback = blankLoaded},
		{time = 99/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 106/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
		{time = 134/35.5, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
		{time = 166/35.5, sound = "CW_KK_INS2_DOI_K98_GLLOAD1"},
		{time = 178/35.5, sound = "CW_KK_INS2_DOI_K98_GLLOAD2", callback = removeBlank},
		{time = 210/35.5, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
		{time = 212/35.5, sound = "CW_KK_INS2_DOI_K98_SHOULDER"},
	},

	glsetup_in_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 19/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		// { event AE_CL_CREATE_PARTICLE_BRASS 29 ""},
		{time = 29/35.5, sound = "", callback = shell},
		{time = 66/35.5, sound = "CW_KK_INS2_DOI_K98_BULLETIN", callback = blankLoaded},
		{time = 99/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 106/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
		{time = 134/35.5, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
		{time = 166/35.5, sound = "CW_KK_INS2_DOI_K98_GLLOAD1"},
		{time = 178/35.5, sound = "CW_KK_INS2_DOI_K98_GLLOAD2", callback = removeBlank},
		{time = 210/35.5, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
		{time = 212/35.5, sound = "CW_KK_INS2_DOI_K98_SHOULDER"},
	},

	glsetup_out = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 36/35.5, sound = "CW_KK_INS2_DOI_K98_GLREMOVE"},
		{time = 112/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 119/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 130/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 139/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
		{time = 155/35.5, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
	},

	glsetup_out_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 26/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 29/35.5, sound = "", callback = shell},
		{time = 38/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 45/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
		// { event AE_CL_CREATE_PARTICLE_BRASS 29 ""},
		{time = 63/35.5, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
	},

	glsetup_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	glsetup_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	glsetup_dryfire = {
		{time = 0/30, sound = "", callback = dryFireInterruptedGL},
	},

	glsetup_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 19/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTRELEASE"},
		{time = 27/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTBACK"},
		{time = 29/35.5, sound = "", callback = shell},
		{time = 66/35.5, sound = "CW_KK_INS2_DOI_K98_BULLETIN", callback = blankLoaded},
		{time = 99/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTFORWARD"},
		{time = 106/35.5, sound = "CW_KK_INS2_DOI_K98_BOLTLATCH"},
		{time = 134/35.5, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
		{time = 166/35.5, sound = "CW_KK_INS2_DOI_K98_GLLOAD1"},
		{time = 178/35.5, sound = "CW_KK_INS2_DOI_K98_GLLOAD2", callback = removeBlank},
		{time = 210/35.5, sound = "CW_KK_INS2_DOI_K98_RATTLE"},
		{time = 212/35.5, sound = "CW_KK_INS2_DOI_K98_SHOULDER"},
		// { event AE_CL_CREATE_PARTICLE_BRASS 29 ""},
		// { event 46 182 ""},
	},

	glsetup_iron_dryfire = {
		{time = 0, sound = "", callback = dryFireInterruptedGL},
	},

	base_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	gl_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	gl_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	gl_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	glsetup_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	glsetup_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash_empty = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_empty = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end_empty = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
