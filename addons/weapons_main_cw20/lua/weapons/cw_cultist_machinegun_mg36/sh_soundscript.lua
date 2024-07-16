--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_machinegun_mg36/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 14/28, sound = "CW_KK_INS2_MG36_FIRESELECT"},
		{time = 29/28, sound = "CW_KK_INS2_MG36_BOLTBACK"},
		{time = 41/28, sound = "CW_KK_INS2_MG36_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RightCrawl"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LeftCrawl"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MG36_EMPTY"},
	},

	base_fireselect = {
		{time = 17/30, sound = "CW_KK_INS2_MG36_FIRESELECT"},
	},

	base_reload = {
		{time = 20/30, sound = "CW_KK_INS2_MG36_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_MG36_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_MG36_MAGOUTRATTLE"},
		{time = 50/30, sound = "CW_KK_INS2_MG36_FETCHMAG"},
		{time = 97/30, sound = "CW_KK_INS2_MG36_MAGIN"},
		{time = 122/30, sound = "CW_KK_INS2_MG36_RATTLE"},
	},

	base_reloadempty = {
		{time = 20/30, sound = "CW_KK_INS2_MG36_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_MG36_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_MG36_MAGOUTRATTLE"},
		{time = 50/30, sound = "CW_KK_INS2_MG36_FETCHMAG"},
		{time = 97/30, sound = "CW_KK_INS2_MG36_MAGIN"},
		{time = 122/30, sound = "CW_KK_INS2_MG36_RATTLE"},
		{time = 146/30, sound = "CW_KK_INS2_MG36_BOLTBACK"},
		{time = 153/30, sound = "CW_KK_INS2_MG36_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MG36_EMPTY"},
	},

	iron_fireselect = {
		{time = 17/30, sound = "CW_KK_INS2_MG36_FIRESELECT"},
	},

	deployed_in = {
		{time = 16/30, sound = "CW_KK_INS2_MG36_BIPODDEPLOY"},
	},

	deployed_out = {
		{time = 13/30, sound = "CW_KK_INS2_MG36_MAGOUTRATTLE"},
		{time = 20/30, sound = "CW_KK_INS2_MG36_BIPODRETRACT"},
	},

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MG36_EMPTY"},
	},

	deployed_fireselect = {
		{time = 17/30, sound = "CW_KK_INS2_MG36_FIRESELECT"},
	},

	deployed_reload = {
		{time = 16/30, sound = "CW_KK_INS2_MG36_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_MG36_MAGOUT"},
		{time = 44/30, sound = "CW_KK_INS2_MG36_MAGOUTRATTLE"},
		{time = 80/30, sound = "CW_KK_INS2_MG36_FETCHMAG"},
		{time = 111/30, sound = "CW_KK_INS2_MG36_MAGIN"},
		{time = 130/30, sound = "CW_KK_INS2_MG36_ENDDEPLOYEDRELOAD"},
	},

	deployed_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_MG36_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_MG36_MAGOUT"},
		{time = 44/30, sound = "CW_KK_INS2_MG36_MAGOUTRATTLE"},
		{time = 80/30, sound = "CW_KK_INS2_MG36_FETCHMAG"},
		{time = 111/30, sound = "CW_KK_INS2_MG36_MAGIN"},
		{time = 150/30, sound = "CW_KK_INS2_MG36_BOLTBACK"},
		{time = 157/30, sound = "CW_KK_INS2_MG36_BOLTRELEASE"},
		{time = 168/30, sound = "CW_KK_INS2_MG36_ENDDEPLOYEDRELOAD"},
	},

	deployed_iron_idle = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_IronIdle"},
	},

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MG36_EMPTY"},
	},

	deployed_iron_fireselect = {
		{time = 17/30, sound = "CW_KK_INS2_MG36_FIRESELECT"},
	},
}
