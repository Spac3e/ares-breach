--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_browning/sh_soundscript.lua

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
		{time = 0, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 30/34.2, sound = "CW_KK_INS2_DOI_BROWNING_BOLTBACK"},
		{time = 42/34.2, sound = "CW_KK_INS2_DOI_BROWNING_BOLTRELEASE"},
		{time = 65/34.2, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_BROWNING_EMPTY"},
	},

	base_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/36.8, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 35/36.8, sound = "CW_KK_INS2_DOI_BROWNING_LIDOPEN"},
		{time = 75/36.8, sound = "CW_KK_INS2_DOI_BROWNING_LINKRATTLE"},
		{time = 81/36.8, sound = "CW_KK_INS2_DOI_BROWNING_FETCHMAG"},
		{time = 110/36.8, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 140/36.8, sound = "CW_KK_INS2_DOI_BROWNING_BELTJINGLE"},
		{time = 150/36.8, sound = "CW_KK_INS2_DOI_BROWNING_BELTALIGN"},
		{time = 197/36.8, sound = "CW_KK_INS2_DOI_BROWNING_LIDCLOSE"},
		{time = 230/36.8, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
		{time = 264/36.8, sound = "CW_KK_INS2_DOI_BROWNING_SHOULDER"},
	},

	base_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/36.8, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 35/36.8, sound = "CW_KK_INS2_DOI_BROWNING_LIDOPEN"},
		{time = 70/36.8, sound = "CW_KK_INS2_DOI_BROWNING_FETCHMAG"},
		{time = 100/36.8, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 110/36.8, sound = "CW_KK_INS2_DOI_BROWNING_BELTJINGLE"},
		{time = 120/36.8, sound = "CW_KK_INS2_DOI_BROWNING_BELTALIGN"},
		{time = 160/36.8, sound = "CW_KK_INS2_DOI_BROWNING_LIDCLOSE"},
		{time = 200/36.8, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
		{time = 210/36.8, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 234/36.8, sound = "CW_KK_INS2_DOI_BROWNING_BOLTBACK"},
		{time = 245/36.8, sound = "CW_KK_INS2_DOI_BROWNING_BOLTRELEASE"},
		{time = 272/36.8, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
		{time = 294/36.8, sound = "CW_KK_INS2_DOI_BROWNING_SHOULDER"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_BROWNING_EMPTY"},
	},

	deployed_in = {
		{time = 1/36, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 19/36, sound = "CW_KK_INS2_DOI_BROWNING_DEPLOYGROUNDHIT"},
		{time = 32/36, sound = "CW_KK_INS2_DOI_BROWNING_BELTJINGLE"},
		{time = 46/36, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
		{time = 65/36, sound = "CW_KK_INS2_DOI_BROWNING_SHOULDER"},
	},

	deployed_out = {
		{time = 1/36, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 15/36, sound = "CW_KK_INS2_DOI_BROWNING_BELTJINGLE"},
		{time = 22/36, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
		{time = 39/36, sound = "CW_KK_INS2_DOI_BROWNING_SHOULDER"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_BROWNING_EMPTY"},
	},

	deployed_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/36, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 35/36, sound = "CW_KK_INS2_DOI_BROWNING_LIDOPEN"},
		{time = 75/36, sound = "CW_KK_INS2_DOI_BROWNING_LINKRATTLE"},
		{time = 81/36, sound = "CW_KK_INS2_DOI_BROWNING_FETCHMAG"},
		{time = 110/36, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 140/36, sound = "CW_KK_INS2_DOI_BROWNING_BELTJINGLE"},
		{time = 150/36, sound = "CW_KK_INS2_DOI_BROWNING_BELTALIGN"},
		{time = 197/36, sound = "CW_KK_INS2_DOI_BROWNING_LIDCLOSE"},
		{time = 222/36, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
		{time = 249/36, sound = "CW_KK_INS2_DOI_BROWNING_SHOULDER"},
	},

	deployed_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 18/36, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 35/36, sound = "CW_KK_INS2_DOI_BROWNING_LIDOPEN"},
		{time = 70/36, sound = "CW_KK_INS2_DOI_BROWNING_FETCHMAG"},
		{time = 100/36, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 110/36, sound = "CW_KK_INS2_DOI_BROWNING_BELTJINGLE"},
		{time = 120/36, sound = "CW_KK_INS2_DOI_BROWNING_BELTALIGN"},
		{time = 160/36, sound = "CW_KK_INS2_DOI_BROWNING_LIDCLOSE"},
		{time = 194/36, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
		{time = 210/36, sound = "CW_KK_INS2_DOI_BROWNING_FOLEY"},
		{time = 234/36, sound = "CW_KK_INS2_DOI_BROWNING_BOLTBACK"},
		{time = 245/36, sound = "CW_KK_INS2_DOI_BROWNING_BOLTRELEASE"},
		{time = 283/36, sound = "CW_KK_INS2_DOI_BROWNING_RATTLE"},
		{time = 293/36, sound = "CW_KK_INS2_DOI_BROWNING_SHOULDER"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_BROWNING_EMPTY"},
	},

	base_melee_bash = {
		{time = 10/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
