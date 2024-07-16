--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m16a1/sh_soundscript.lua

--]]


local function m203(wep)
	if SERVER then return end

	wep:shellEvent203()
end

SWEP.Sounds = {
	base_melee_bash = {
		{time = 11/30, sound = "CW_KK_INS2_DOI_MELEE"},
		// { event 1338 13 ""},
		// { event AE_WPN_READY 29 ""},
	},

	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 21/30, sound = "CW_KK_INS2_M16A4_BOLTBACK"},
		{time = 29/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		{time = 51/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 52/30, sound = "CW_KK_INS2_M16A4_HIT"},
		{time = 63/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		// { event AE_WPN_READY 80 ""},
	},

	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		// { event AE_WPN_READY 15 ""},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M16A4_EMPTY"},
	},

	base_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M16A4_FIRESELECT"},
		// { event AE_WPN_READY 16 ""},
	},

	base_reload = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 101 ""},
		// { event AE_WPN_READY 124 ""},
	},

	base_reloadempty = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 120 ""},
		{time = 123/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		// { event AE_WPN_READY 142 ""},
	},

	base_reload_extended = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 101 ""},
		// { event AE_WPN_READY 124 ""},
	},

	base_reloadempty_extended1 = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 120 ""},
		{time = 123/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		// { event AE_WPN_READY 142 ""},
	},

	base_reloadempty_extended2 = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 120 ""},
		{time = 123/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		// { event AE_WPN_READY 142 ""},
	},

	base_reloadempty2 = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 120 ""},
		{time = 123/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		// { event AE_WPN_READY 143 ""},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M16A4_EMPTY"},
	},

	iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M16A4_FIRESELECT"},
		// { event AE_WPN_READY 17 ""},
	},

	gl_ready = {
		{time = 0/29, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 21/29, sound = "CW_KK_INS2_M16A4_BOLTBACK"},
		{time = 29/29, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		{time = 51/29, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 52/29, sound = "CW_KK_INS2_M16A4_HIT"},
		{time = 63/29, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		// { event AE_WPN_READY 80 ""},
	},

	gl_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		// { event AE_WPN_READY 15 ""},
	},

	gl_holster = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	gl_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	gl_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M16A4_EMPTY"},
	},

	gl_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M16A4_FIRESELECT"},
		// { event AE_WPN_READY 16 ""},
	},

	gl_reload = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 101 ""},
		// { event AE_WPN_READY 124 ""},
	},

	gl_reloadempty1 = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 120 ""},
		{time = 123/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		// { event AE_WPN_READY 143 ""},
	},

	gl_reloadempty2 = {
		{time = 29/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 88/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 103/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 120 ""},
		{time = 123/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		// { event AE_WPN_READY 143 ""},
	},

	gl_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M16A4_EMPTY"},
	},

	gl_iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M16A4_FIRESELECT"},
		// { event AE_WPN_READY 16 ""},
	},

	glsetup_in = {
		{time = 0/30, sound = "CW_KK_INS2_M203_SELECT"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
		// { event AE_WPN_READY 41 ""},
	},

	glsetup_out = {
		{time = 0/30, sound = "CW_KK_INS2_M203_DESELECT"},
		{time = 18/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
		// { event AE_WPN_READY 41 ""},
	},

	glsetup_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_holster = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	glsetup_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	glsetup_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M203_EMPTY"},
	},

	glsetup_reload = {
		{time = 0/30, sound = "CW_KK_INS2_GL_BEGINRELOAD"},
		{time = 20/30, sound = "CW_KK_INS2_M203_OPENBARREL"},
		{time = 25/30, sound = "", callback = m203},
		{time = 78/30, sound = "CW_KK_INS2_M203_INSERTGRENADE"},
		// { event AE_EMIT_SHELL_M203 33 ""},
		-- {time = 42/30, sound = "ins2_m203_GrenadeDrop"},
		{time = 109/30, sound = "CW_KK_INS2_M203_CLOSEBARREL"},
		// { event 46 104 ""},
		// { event AE_WPN_READY 129 ""},
	},

	glsetup_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M203_EMPTY"},
	},

	deployed_in = {
		{time = 7/30, sound = "CW_KK_INS2_M16A4_HIT"},
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		// { event AE_WPN_READY 16 ""},
	},

	deployed_out = {
		{time = 2/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		// { event AE_WPN_READY 15 ""},
	},

	deployed_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M16A4_EMPTY"},
	},

	deployed_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M16A4_FIRESELECT"},
		// { event AE_WPN_READY 16 ""},
	},

	deployed_reload_half = {
		{time = 15/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 19/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 87/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 86 ""},
		// { event AE_WPN_READY 104 ""},
	},

	deployed_reload_empty = {
		{time = 15/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 19/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 87/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 109 ""},
		{time = 107/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		// { event AE_WPN_READY 124 ""},
	},

	deployed_reload_half_ext = {
		{time = 15/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 19/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 87/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 86 ""},
		// { event AE_WPN_READY 104 ""},
	},

	deployed_reload_empty_ext = {
		{time = 15/30, sound = "CW_KK_INS2_M16A4_MAGRELEASE"},
		{time = 19/30, sound = "CW_KK_INS2_M16A4_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_M16A4_MAGIN"},
		{time = 87/30, sound = "CW_KK_INS2_M16A4_HIT"},
		// { event 46 109 ""},
		{time = 107/30, sound = "CW_KK_INS2_M16A4_BOLTRELEASE"},
		// { event AE_WPN_READY 124 ""},
	},

	deployed_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M16A4_EMPTY"},
	},

	deployed_iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M16A4_FIRESELECT"},
		// { event AE_WPN_READY 16 ""},
	},
}
