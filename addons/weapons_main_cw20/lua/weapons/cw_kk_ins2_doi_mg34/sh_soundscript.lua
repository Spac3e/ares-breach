--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_mg34/sh_soundscript.lua

--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

local function link(wep)
	if SERVER then return end

	wep:shellEvent2()
end

SWEP.Sounds = {
	base_ready = {
		{time = 29/34.2, sound = "CW_KK_INS2_DOI_MG34_BOLTBACK"},
		{time = 38/34.2, sound = "CW_KK_INS2_DOI_MG34_BOLTRELEASE"},
		{time = 61/34.2, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 78/34.2, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 15, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fire_1 = {
		{time = 0, sound = "", callback = link},
		{time = 0.02, sound = "", callback = shell},
	},

	base_fire_2 = {
		{time = 0, sound = "", callback = link},
		{time = 0.02, sound = "", callback = shell},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_MG34_EMPTY"},
	},

	base_fireselect = {
		{time = 0, sound = "CW_KK_INS2_DOI_MG34_FIRESELECT"},
	},

	base_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 30/32.5, sound = "CW_KK_INS2_DOI_MG34_COVEROPEN"},
		{time = 78/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUT"},
		{time = 83/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUTRATTLE"},
		{time = 115/32.5, sound = "CW_KK_INS2_DOI_MG34_FETCHMAG"},
		{time = 130/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 158/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGIN"},
		{time = 168/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGHIT"},
		{time = 198/32.5, sound = "CW_KK_INS2_DOI_MG34_BELTALIGN"},
		{time = 234/32.5, sound = "CW_KK_INS2_DOI_MG34_COVERCLOSE"},
		{time = 267/32.5, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 285/32.5, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
		-- { event AE_WPN_RELOAD_OFFSCREEN 130 ""},
		-- { event 46 170 ""},
	},

	base_reload_half = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 30/32.5, sound = "CW_KK_INS2_DOI_MG34_COVEROPEN"},
		{time = 78/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUT"},
		{time = 83/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUTRATTLE"},
		{time = 115/32.5, sound = "CW_KK_INS2_DOI_MG34_FETCHMAG"},
		{time = 130/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 158/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGIN"},
		{time = 168/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGHIT"},
		{time = 198/32.5, sound = "CW_KK_INS2_DOI_MG34_BELTALIGN"},
		{time = 234/32.5, sound = "CW_KK_INS2_DOI_MG34_COVERCLOSE"},
		{time = 267/32.5, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 285/32.5, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
		-- { event AE_WPN_RELOAD_OFFSCREEN 130 ""},
		-- { event 46 170 ""},
	},

	base_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 30/32.5, sound = "CW_KK_INS2_DOI_MG34_COVEROPEN"},
		{time = 68/32.5, sound = "CW_KK_INS2_DOI_MG34_BOLTBACK"},
		{time = 76/32.5, sound = "CW_KK_INS2_DOI_MG34_BOLTRELEASE"},
		{time = 98/32.5, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 132/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUT"},
		{time = 136/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUTRATTLE"},
		{time = 150/32.5, sound = "CW_KK_INS2_DOI_MG34_FETCHMAG"},
		{time = 160/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 213/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGIN"},
		{time = 222/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGHIT"},
		{time = 252/32.5, sound = "CW_KK_INS2_DOI_MG34_BELTALIGN"},
		{time = 288/32.5, sound = "CW_KK_INS2_DOI_MG34_COVERCLOSE"},
		{time = 323/32.5, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 338/32.5, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
		-- { event AE_WPN_RELOAD_OFFSCREEN 150 ""},
		-- { event 46 224 ""},
	},

	iron_fire_1 = {
		{time = 0, sound = "", callback = link},
		{time = 0.02, sound = "", callback = shell},
	},

	iron_fire_2 = {
		{time = 0, sound = "", callback = link},
		{time = 0.02, sound = "", callback = shell},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_MG34_EMPTY"},
	},

	iron_fireselect = {
		{time = 0, sound = "CW_KK_INS2_DOI_MG34_FIRESELECT"},
	},

	deployed_in = {
		{time = 19/36, sound = "CW_KK_INS2_DOI_MG34_DEPLOYGROUNDHIT"},
		{time = 46/36, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 65/36, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
	},

	deployed_out = {
		{time = 25/36, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 39/36, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
	},

	deployed_fire_1 = {
		{time = 0, sound = "", callback = link},
		{time = 0.02, sound = "", callback = shell},
	},

	deployed_fire_2 = {
		{time = 0, sound = "", callback = link},
		{time = 0.02, sound = "", callback = shell},
	},

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_MG34_EMPTY"},
	},

	deployed_fireselect = {
		{time = 0, sound = "CW_KK_INS2_DOI_MG34_FIRESELECT"},
	},

	deployed_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 30/32.5, sound = "CW_KK_INS2_DOI_MG34_COVEROPEN"},
		{time = 78/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUT"},
		{time = 83/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUTRATTLE"},
		{time = 115/32.5, sound = "CW_KK_INS2_DOI_MG34_FETCHMAG"},
		{time = 130/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 158/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGIN"},
		{time = 168/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGHIT"},
		{time = 198/32.5, sound = "CW_KK_INS2_DOI_MG34_BELTALIGN"},
		{time = 234/32.5, sound = "CW_KK_INS2_DOI_MG34_COVERCLOSE"},
		{time = 260/32.5, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 276/32.5, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
		-- { event AE_WPN_RELOAD_OFFSCREEN 130 ""},
		-- { event 46 170 ""},
	},

	deployed_reload_half = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 30/32.5, sound = "CW_KK_INS2_DOI_MG34_COVEROPEN"},
		{time = 78/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUT"},
		{time = 83/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUTRATTLE"},
		{time = 115/32.5, sound = "CW_KK_INS2_DOI_MG34_FETCHMAG"},
		{time = 130/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 158/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGIN"},
		{time = 168/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGHIT"},
		{time = 198/32.5, sound = "CW_KK_INS2_DOI_MG34_BELTALIGN"},
		{time = 234/32.5, sound = "CW_KK_INS2_DOI_MG34_COVERCLOSE"},
		{time = 260/32.5, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 276/32.5, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
		-- { event AE_WPN_RELOAD_OFFSCREEN 130 ""},
		-- { event 46 170 ""},
	},

	deployed_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 30/32.5, sound = "CW_KK_INS2_DOI_MG34_COVEROPEN"},
		{time = 68/32.5, sound = "CW_KK_INS2_DOI_MG34_BOLTBACK"},
		{time = 76/32.5, sound = "CW_KK_INS2_DOI_MG34_BOLTRELEASE"},
		{time = 98/32.5, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 132/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUT"},
		{time = 136/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGOUTRATTLE"},
		{time = 150/32.5, sound = "CW_KK_INS2_DOI_MG34_FETCHMAG"},
		{time = 160/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 213/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGIN"},
		{time = 222/32.5, sound = "CW_KK_INS2_DOI_MG34_MAGHIT"},
		{time = 252/32.5, sound = "CW_KK_INS2_DOI_MG34_BELTALIGN"},
		{time = 288/32.5, sound = "CW_KK_INS2_DOI_MG34_COVERCLOSE"},
		{time = 316/32.5, sound = "CW_KK_INS2_DOI_MG34_RATTLE"},
		{time = 330/32.5, sound = "CW_KK_INS2_DOI_MG34_SHOULDERWEAPON"},
		-- { event AE_WPN_RELOAD_OFFSCREEN 150 ""},
		-- { event 46 224 ""},
	},

	deployed_iron_fire_1 = {
		{time = 0, sound = "", callback = link},
		{time = 0.02, sound = "", callback = shell},
	},

	deployed_iron_fire_2 = {
		{time = 0, sound = "", callback = link},
		{time = 0.02, sound = "", callback = shell},
	},

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_MG34_EMPTY"},
	},

	deployed_iron_fireselect = {
		{time = 0, sound = "CW_KK_INS2_DOI_MG34_FIRESELECT"},
	},

	base_melee_bash = {
		{time = 10/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
