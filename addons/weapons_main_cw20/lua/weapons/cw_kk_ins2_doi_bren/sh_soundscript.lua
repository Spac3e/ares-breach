--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_bren/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 32/30, sound = "CW_KK_INS2_DOI_BREN_BOLTBACK"},
		{time = 43/30, sound = "CW_KK_INS2_DOI_BREN_BOLTRELEASE"},
		{time = 62/30, sound = "CW_KK_INS2_DOI_BREN_RATTLE"},
		{time = 80/30, sound = "CW_KK_INS2_DOI_BREN_SHOULDERWEAPON"},
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

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_BREN_EMPTY"},
	},

	base_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 30/33.5, sound = "CW_KK_INS2_DOI_BREN_MAGRELEASE"},
		{time = 41/33.5, sound = "CW_KK_INS2_DOI_BREN_MAGOUT"},
		{time = 50/33.5, sound = "CW_KK_INS2_DOI_BREN_FETCHMAG"},
		{time = 60/33.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		-- { event 46 132 ""},
		{time = 117/33.5, sound = "CW_KK_INS2_DOI_BREN_MAGIN"},
		{time = 132/33.5, sound = "CW_KK_INS2_DOI_BREN_MAGHIT"},
		{time = 160/33.5, sound = "CW_KK_INS2_DOI_BREN_RATTLE"},
		{time = 180/33.5, sound = "CW_KK_INS2_DOI_BREN_SHOULDERWEAPON"},
	},

	base_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 33/33.5, sound = "CW_KK_INS2_DOI_BREN_BOLTBACK"},
		{time = 44/33.5, sound = "CW_KK_INS2_DOI_BREN_BOLTRELEASE"},
		{time = 63/33.5, sound = "CW_KK_INS2_DOI_BREN_RATTLE"},
		{time = 93/33.5, sound = "CW_KK_INS2_DOI_BREN_MAGRELEASE"},
		{time = 106/33.5, sound = "CW_KK_INS2_DOI_BREN_MAGOUT"},
		{time = 110/33.5, sound = "CW_KK_INS2_DOI_BREN_FETCHMAG"},
		{time = 120/33.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		-- { event 46 197 ""},
		{time = 179/33.5, sound = "CW_KK_INS2_DOI_BREN_MAGIN"},
		{time = 193/33.5, sound = "CW_KK_INS2_DOI_BREN_MAGHIT"},
		{time = 223/33.5, sound = "CW_KK_INS2_DOI_BREN_RATTLE"},
		{time = 243/33.5, sound = "CW_KK_INS2_DOI_BREN_SHOULDERWEAPON"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_BREN_EMPTY"},
	},

	deployed_in = {
		{time = 19/32.5, sound = "CW_KK_INS2_DOI_BREN_DEPLOYGROUNDHIT"},
		{time = 40/32.5, sound = "CW_KK_INS2_DOI_BREN_RATTLE"},
		{time = 50/32.5, sound = "CW_KK_INS2_DOI_BREN_SHOULDERWEAPON"},
	},

	deployed_out = {
		{time = 20/33, sound = "CW_KK_INS2_DOI_BREN_RATTLE"},
		{time = 39/33, sound = "CW_KK_INS2_DOI_BREN_SHOULDERWEAPON"},
	},

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_BREN_EMPTY"},
	},

	deployed_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 30/34, sound = "CW_KK_INS2_DOI_BREN_MAGRELEASE"},
		{time = 41/34, sound = "CW_KK_INS2_DOI_BREN_MAGOUT"},
		{time = 50/34, sound = "CW_KK_INS2_DOI_BREN_FETCHMAG"},
		{time = 60/34, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		-- { event 46 132 ""},
		{time = 117/34, sound = "CW_KK_INS2_DOI_BREN_MAGIN"},
		{time = 132/34, sound = "CW_KK_INS2_DOI_BREN_MAGHIT"},
		{time = 160/34, sound = "CW_KK_INS2_DOI_BREN_RATTLE"},
		{time = 180/34, sound = "CW_KK_INS2_DOI_BREN_SHOULDERWEAPON"},
	},

	deployed_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 33/34, sound = "CW_KK_INS2_DOI_BREN_BOLTBACK"},
		{time = 44/34, sound = "CW_KK_INS2_DOI_BREN_BOLTRELEASE"},
		{time = 93/34, sound = "CW_KK_INS2_DOI_BREN_MAGRELEASE"},
		{time = 106/34, sound = "CW_KK_INS2_DOI_BREN_MAGOUT"},
		{time = 110/34, sound = "CW_KK_INS2_DOI_BREN_FETCHMAG"},
		{time = 120/34, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		-- { event 46 197 ""},
		{time = 179/34, sound = "CW_KK_INS2_DOI_BREN_MAGIN"},
		{time = 193/34, sound = "CW_KK_INS2_DOI_BREN_MAGHIT"},
		{time = 223/34, sound = "CW_KK_INS2_DOI_BREN_RATTLE"},
		{time = 243/34, sound = "CW_KK_INS2_DOI_BREN_SHOULDERWEAPON"},
	},

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_BREN_EMPTY"},
	},

	base_melee_bash = {
		{time = 13/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
