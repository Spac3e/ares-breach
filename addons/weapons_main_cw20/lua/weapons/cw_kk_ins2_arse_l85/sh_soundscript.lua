--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_arse_l85/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_arse_l85/sh_soundscript.lua
--]]

local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 24/32, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 36/32, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 53/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
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

	base_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M4A1_EMPTY"},
	},

	base_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_M4A1_FIRESELECT"},
	},

	base_reload = {
		{time = 17/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 35/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bulletsToReserve},
		{time = 68/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_M4A1_HIT"},
		-- { event 46 85 ""},
		-- { event AE_WPN_RELOAD_OFFSCREEN 35 ""},
		{time = 101/30, sound = "CW_KK_INS2_AK74_RATTLE"},
	},

	base_reloadempty = {
		{time = 17/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 35/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bulletsToReserve},
		{time = 73/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		-- { event 46 77 ""},
		-- { event AE_WPN_RELOAD_OFFSCREEN 35 ""},
		{time = 105/30, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 109/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 125/30, sound = "CW_KK_INS2_AK74_RATTLE"},
	},

	iron_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	iron_fire_a = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	iron_fire_b = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	iron_fire_c = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	iron_fire_d = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	iron_fire_e = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	iron_fire_f = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M4A1_EMPTY"},
	},

	iron_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_M4A1_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 24/32, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 36/32, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 53/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M4A1_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_M4A1_FIRESELECT"},
	},

	foregrip_iron_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_iron_fire_a = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_iron_fire_b = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_iron_fire_c = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_iron_fire_d = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_iron_fire_e = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_iron_fire_f = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M4A1_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_M4A1_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 17/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 35/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bulletsToReserve},
		{time = 68/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_M4A1_HIT"},
		-- { event 46 85 ""},
		-- { event AE_WPN_RELOAD_OFFSCREEN 35 ""},
		{time = 101/30, sound = "CW_KK_INS2_AK74_RATTLE"},
	},

	foregrip_reloadempty = {
		{time = 17/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 35/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bulletsToReserve},
		{time = 73/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		-- { event 46 77 ""},
		-- { event AE_WPN_RELOAD_OFFSCREEN 35 ""},
		{time = 104/30, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 113/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 126/30, sound = "CW_KK_INS2_AK74_RATTLE"},
	},

	gl_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 24/32, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 36/32, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 53/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	gl_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	gl_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	gl_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	gl_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M4A1_EMPTY"},
	},

	gl_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_M4A1_FIRESELECT"},
	},

	gl_reload = {
		{time = 17/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 35/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bulletsToReserve},
		{time = 68/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_M4A1_HIT"},
		-- { event 46 85 ""},
		-- { event AE_WPN_RELOAD_OFFSCREEN 35 ""},
		{time = 101/30, sound = "CW_KK_INS2_AK74_RATTLE"},
	},

	gl_reloadempty = {
		{time = 17/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 35/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bulletsToReserve},
		{time = 73/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		-- { event 46 77 ""},
		-- { event AE_WPN_RELOAD_OFFSCREEN 35 ""},
		{time = 105/30, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 109/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 125/30, sound = "CW_KK_INS2_AK74_RATTLE"},
	},

	gl_iron_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_iron_fire_a = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_iron_fire_b = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_iron_fire_c = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_iron_fire_d = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_iron_fire_e = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_iron_fire_f = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M4A1_EMPTY"},
	},

	gl_iron_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_M4A1_FIRESELECT"},
	},

	glsetup_in = {
		{time = 0, sound = "CW_KK_INS2_M203_SELECT"},
	},

	glsetup_out = {
		{time = 0, sound = "CW_KK_INS2_M203_DESELECT"},
	},

	glsetup_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	glsetup_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- glsetup_fire = {
		-- { event AE_GL_MUZZLEFLASH 0 ""},
	-- },

	glsetup_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M203_EMPTY"},
	},

	glsetup_reload = {
		{time = 0/30, sound = "CW_KK_INS2_GL_BEGINRELOAD"},
		{time = 21/30, sound = "CW_KK_INS2_M203_OPENBARREL"},
		{time = 56/30, sound = "CW_KK_INS2_M203_INSERTGRENADE"},
		-- { event AE_EMIT_SHELL_M203 30 ""},
		-- {time = 35/30, sound = "m203_GrenadeDrop"},
		{time = 83/30, sound = "CW_KK_INS2_M203_CLOSEBARREL"},
		-- { event 46 85 ""},
	},

	-- glsetup_iron_fire = {
		-- { event AE_GL_MUZZLEFLASH 0 ""},
	-- },

	glsetup_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M203_EMPTY"},
	},

	base_fire_2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	foregrip_fire_2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},

	gl_fire_2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		{time = 0.06, sound = "", callback = shell},
	},
}


