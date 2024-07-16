--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m60/sh_soundscript.lua

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
	base_melee_bash = {
		{time = 15/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_fire_1 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	base_fire_2 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	base_fire_3 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	iron_fire_1 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	iron_fire_2 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	iron_fire_3 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	iron_fire_4 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	deployed_fire_1 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	deployed_fire_2 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	deployed_iron_fire_1 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	deployed_iron_fire_2 = {
		{time = 0.02, sound = "", callback = link},
		{time = 0.05, sound = "", callback = shell},
	},

	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 33/30, sound = "CW_KK_INS2_M249_BOLTBACK"},
		{time = 41/30, sound = "CW_KK_INS2_M249_BOLTRELEASE"},
		{time = 61/30, sound = "CW_KK_INS2_M249_SHOULDER"},
	},

	base_draw = {
		{time = 0/33.5, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 9/33.5, sound = "CW_KK_INS2_M249_SHOULDER"},
		{time = 24/33.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 40/33.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
	},

	base_holster = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	-- base_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	-- base_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	-- base_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M249_EMPTY"},
	},

	base_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 48/30, sound = "CW_KK_INS2_M249_COVEROPEN"},
		{time = 100/30, sound = "CW_KK_INS2_M249_MAGOUTFULL"},
		{time = 135/30, sound = "CW_KK_INS2_M249_FETCHMAG"},
		{time = 145/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 175/30, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 186/30, sound = "CW_KK_INS2_M249_MAGIN"},
		{time = 203/30, sound = "CW_KK_INS2_M249_MAGHIT"},
		{time = 222/30, sound = "CW_KK_INS2_M249_BULLETJINGLE"},
		{time = 228/30, sound = "CW_KK_INS2_M249_BELTALIGN"},
		{time = 239/30, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
		{time = 258/30, sound = "CW_KK_INS2_M249_COVERCLOSE"},
		{time = 286/30, sound = "CW_KK_INS2_M249_SHOULDER"},
		// { event 46 269 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 134 ""},
	},

	base_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 32/30, sound = "CW_KK_INS2_M249_BOLTBACK"},
		{time = 42/30, sound = "CW_KK_INS2_M249_BOLTRELEASE"},
		{time = 71/30, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
		{time = 101/30, sound = "CW_KK_INS2_M249_COVEROPEN"},
		{time = 125/30, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 156/30, sound = "CW_KK_INS2_M249_MAGOUT"},
		{time = 186/30, sound = "CW_KK_INS2_M249_FETCHMAG"},
		{time = 196/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 210/30, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
		{time = 241/30, sound = "CW_KK_INS2_M249_MAGIN"},
		{time = 259/30, sound = "CW_KK_INS2_M249_MAGHIT"},
		{time = 273/30, sound = "CW_KK_INS2_M249_BULLETJINGLE"},
		{time = 283/30, sound = "CW_KK_INS2_M249_BELTALIGN"},
		{time = 292/30, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 313/30, sound = "CW_KK_INS2_M249_COVERCLOSE"},
		{time = 350/30, sound = "CW_KK_INS2_M249_SHOULDER"},
		// { event 46 311 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 194 ""},
	},

	base_reload_half = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 48/30, sound = "CW_KK_INS2_M249_COVEROPEN"},
		{time = 86/30, sound = "CW_KK_INS2_M249_THROWAWAYREMAINING"},
		{time = 130/30, sound = "CW_KK_INS2_M249_MAGOUT"},
		{time = 157/30, sound = "CW_KK_INS2_M249_FETCHMAG"},
		{time = 167/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 200/30, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 215/30, sound = "CW_KK_INS2_M249_MAGIN"},
		{time = 231/30, sound = "CW_KK_INS2_M249_MAGHIT"},
		{time = 248/30, sound = "CW_KK_INS2_M249_BULLETJINGLE"},
		{time = 257/30, sound = "CW_KK_INS2_M249_BELTALIGN"},
		{time = 268/30, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
		{time = 286/30, sound = "CW_KK_INS2_M249_COVERCLOSE"},
		{time = 317/30, sound = "CW_KK_INS2_M249_SHOULDER"},
		// { event 46 285 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 163 ""},
	},

	-- iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	-- iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	-- iron_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	-- iron_fire_4 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M249_EMPTY"},
	},

	deployed_in = {
		{time = 23/38, sound = "CW_KK_INS2_M249_BIPODDEPLOY"},
	},

	deployed_out = {
		{time = 21/38, sound = "CW_KK_INS2_M249_BIPODRETRACT"},
	},

	-- deployed_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	-- deployed_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	deployed_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M249_EMPTY"},
	},

	deployed_reload = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/32.5, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 48/32.5, sound = "CW_KK_INS2_M249_COVEROPEN"},
		{time = 100/32.5, sound = "CW_KK_INS2_M249_MAGOUTFULL"},
		{time = 135/32.5, sound = "CW_KK_INS2_M249_FETCHMAG"},
		{time = 145/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 175/32.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 186/32.5, sound = "CW_KK_INS2_M249_MAGIN"},
		{time = 203/32.5, sound = "CW_KK_INS2_M249_MAGHIT"},
		{time = 222/32.5, sound = "CW_KK_INS2_M249_BULLETJINGLE"},
		{time = 228/32.5, sound = "CW_KK_INS2_M249_BELTALIGN"},
		{time = 239/32.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
		{time = 258/32.5, sound = "CW_KK_INS2_M249_COVERCLOSE"},
		{time = 286/32.5, sound = "CW_KK_INS2_M249_SHOULDER"},
		// { event 46 269 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 134 ""},
	},

	deployed_reload_half = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/32.5, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 48/32.5, sound = "CW_KK_INS2_M249_COVEROPEN"},
		{time = 86/32.5, sound = "CW_KK_INS2_M249_THROWAWAYREMAINING"},
		{time = 130/32.5, sound = "CW_KK_INS2_M249_MAGOUT"},
		{time = 157/32.5, sound = "CW_KK_INS2_M249_FETCHMAG"},
		{time = 167/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 200/32.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 215/32.5, sound = "CW_KK_INS2_M249_MAGIN"},
		{time = 231/32.5, sound = "CW_KK_INS2_M249_MAGHIT"},
		{time = 248/32.5, sound = "CW_KK_INS2_M249_BULLETJINGLE"},
		{time = 257/32.5, sound = "CW_KK_INS2_M249_BELTALIGN"},
		{time = 268/32.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
		{time = 286/32.5, sound = "CW_KK_INS2_M249_COVERCLOSE"},
		{time = 317/32.5, sound = "CW_KK_INS2_M249_SHOULDER"},
		// { event 46 285 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 163 ""},
	},

	deployed_reload_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/32.5, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 32/32.5, sound = "CW_KK_INS2_M249_BOLTBACK"},
		{time = 42/32.5, sound = "CW_KK_INS2_M249_BOLTRELEASE"},
		{time = 71/32.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
		{time = 101/32.5, sound = "CW_KK_INS2_M249_COVEROPEN"},
		{time = 125/32.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 156/32.5, sound = "CW_KK_INS2_M249_MAGOUT"},
		{time = 186/32.5, sound = "CW_KK_INS2_M249_FETCHMAG"},
		{time = 196/32.5, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToReserve},
		{time = 210/32.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT2"},
		{time = 241/32.5, sound = "CW_KK_INS2_M249_MAGIN"},
		{time = 259/32.5, sound = "CW_KK_INS2_M249_MAGHIT"},
		{time = 273/32.5, sound = "CW_KK_INS2_M249_BULLETJINGLE"},
		{time = 283/32.5, sound = "CW_KK_INS2_M249_BELTALIGN"},
		{time = 292/32.5, sound = "CW_KK_INS2_M249_ARMMOVEMENT1"},
		{time = 313/32.5, sound = "CW_KK_INS2_M249_COVERCLOSE"},
		{time = 350/32.5, sound = "CW_KK_INS2_M249_SHOULDER"},
		// { event 46 311 ""},
		// { event AE_WPN_RELOAD_OFFSCREEN 194 ""},
	},

	-- deployed_iron_idle = {
		-- {time = 0/30, sound = "u_IronIdle"},
	-- },

	-- deployed_iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	-- deployed_iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 "M249 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "M249 EJECT"},
		-- // { event AE_EMIT_SHELL_LINK 0 ""},
	-- },

	deployed_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M249_EMPTY"},
	},
}
