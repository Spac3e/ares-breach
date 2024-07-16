--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_mg42/sh_soundscript.lua

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
		{time = 0, sound = "CW_KK_INS2_DOI_MG42_FOLEY"},
		{time = 30/34.2, sound = "CW_KK_INS2_DOI_MG42_BOLTBACK"},
		{time = 42/34.2, sound = "CW_KK_INS2_DOI_MG42_BOLTRELEASE"},
		{time = 65/34.2, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_MG42_EMPTY"},
	},

	base_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/33.5, sound = "CW_KK_INS2_DOI_MG42_FOLEY"},
		{time = 35/33.5, sound = "CW_KK_INS2_DOI_MG42_LIDOPEN"},
		{time = 75/33.5, sound = "CW_KK_INS2_DOI_MG42_LINKRATTLE"},
		{time = 81/33.5, sound = "CW_KK_INS2_DOI_MG42_FETCHMAG"},
		{time = 110/33.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		// reload time = 110 ""},
		{time = 140/33.5, sound = "CW_KK_INS2_DOI_MG42_BELTJINGLE"},
		{time = 150/33.5, sound = "CW_KK_INS2_DOI_MG42_BELTALIGN"},
		{time = 203/33.5, sound = "CW_KK_INS2_DOI_MG42_LIDCLOSE"},
		{time = 238/33.5, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
		{time = 264/33.5, sound = "CW_KK_INS2_DOI_MG42_SHOULDER"},
	},

	base_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/33.5, sound = "CW_KK_INS2_DOI_MG42_FOLEY"},
		{time = 33/33.5, sound = "CW_KK_INS2_DOI_MG42_BOLTBACK"},
		{time = 43/33.5, sound = "CW_KK_INS2_DOI_MG42_BOLTRELEASE"},
		{time = 67/33.5, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
		{time = 95/33.5, sound = "CW_KK_INS2_DOI_MG42_LIDOPEN"},
		{time = 100/33.5, sound = "CW_KK_INS2_DOI_MG42_FETCHMAG"},
		{time = 150/33.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 164/33.5, sound = "CW_KK_INS2_DOI_MG42_BELTJINGLE"},
		{time = 176/33.5, sound = "CW_KK_INS2_DOI_MG42_BELTALIGN"},
		// reload time = 150 ""},
		{time = 229/33.5, sound = "CW_KK_INS2_DOI_MG42_LIDCLOSE"},
		{time = 264/33.5, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
		{time = 284/33.5, sound = "CW_KK_INS2_DOI_MG42_SHOULDER"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_MG42_EMPTY"},
	},

	deployed_in = {
		{time = 1/32.5, sound = "CW_KK_INS2_DOI_MG42_FOLEY"},
		{time = 19/32.5, sound = "CW_KK_INS2_DOI_MG42_DEPLOYGROUNDHIT"},
		{time = 46/32.5, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
		{time = 65/32.5, sound = "CW_KK_INS2_DOI_MG42_SHOULDER"},
	},

	deployed_out = {
		{time = 1/33, sound = "CW_KK_INS2_DOI_MG42_FOLEY"},
		{time = 25/33, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
		{time = 39/33, sound = "CW_KK_INS2_DOI_MG42_SHOULDER"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_MG42_EMPTY"},
	},

	deployed_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 13/34.5, sound = "CW_KK_INS2_DOI_MG42_FOLEY"},
		{time = 35/34.5, sound = "CW_KK_INS2_DOI_MG42_LIDOPEN"},
		{time = 75/34.5, sound = "CW_KK_INS2_DOI_MG42_LINKRATTLE"},
		{time = 81/34.5, sound = "CW_KK_INS2_DOI_MG42_FETCHMAG"},
		{time = 110/33.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		// reload time = 110 ""},
		{time = 140/34.5, sound = "CW_KK_INS2_DOI_MG42_BELTJINGLE"},
		{time = 150/34.5, sound = "CW_KK_INS2_DOI_MG42_BELTALIGN"},
		{time = 203/34.5, sound = "CW_KK_INS2_DOI_MG42_LIDCLOSE"},
		{time = 230/34.5, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
		{time = 255/34.5, sound = "CW_KK_INS2_DOI_MG42_SHOULDER"},
	},

	deployed_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 13/33.5, sound = "CW_KK_INS2_DOI_MG42_FOLEY"},
		{time = 33/33.5, sound = "CW_KK_INS2_DOI_MG42_BOLTBACK"},
		{time = 43/33.5, sound = "CW_KK_INS2_DOI_MG42_BOLTRELEASE"},
		{time = 67/33.5, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
		{time = 95/33.5, sound = "CW_KK_INS2_DOI_MG42_LIDOPEN"},
		{time = 100/33.5, sound = "CW_KK_INS2_DOI_MG42_FETCHMAG"},
		{time = 150/33.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 164/33.5, sound = "CW_KK_INS2_DOI_MG42_BELTJINGLE"},
		{time = 176/33.5, sound = "CW_KK_INS2_DOI_MG42_BELTALIGN"},
		// reload time = 150 ""},
		{time = 229/33.5, sound = "CW_KK_INS2_DOI_MG42_LIDCLOSE"},
		{time = 251/33.5, sound = "CW_KK_INS2_DOI_MG42_RATTLE"},
		{time = 284/33.5, sound = "CW_KK_INS2_DOI_MG42_SHOULDER"},
	},

	deployed_iron_idle = {
		{time = 0, sound = "Universal_IronIdle"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_MG42_EMPTY"},
	},

	base_melee_bash = {
		{time = 10/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
