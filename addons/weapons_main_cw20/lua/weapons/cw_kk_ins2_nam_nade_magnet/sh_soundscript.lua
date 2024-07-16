--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_nade_magnet/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_plant = {
		{time = 6/30, sound = "CW_KK_INS2_C4_ARMMOVEMENT"},
		{time = 13/30, sound = "CW_KK_INS2_C4_PLANTPLACE"},
		{time = 22/30, sound = "CW_KK_INS2_M67_PINPULL"},
		// { event 3005 22 ""},
	},

	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 9/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 19/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_pullback = {
		{time = 6/30, sound = "CW_KK_INS2_M67_ARMDRAW"},
		// { event 3900 14 ""},
	},

	secondary_pullback = {
		{time = 6/30, sound = "CW_KK_INS2_M67_ARMDRAW"},
		// { event 3900 14 ""},
	},

	low_pullback = {
		{time = 6/30, sound = "CW_KK_INS2_M67_ARMDRAW"},
		// { event 3900 14 ""},
	},

	base_throw = {
		{time = 5/33, sound = "CW_KK_INS2_M67_PINPULL"},
		{time = 33/33, sound = "CW_KK_INS2_C4_THROW"},
		// { event 3005 35 ""},
	},

	secondary_throw = {
		{time = 5/33, sound = "CW_KK_INS2_M67_PINPULL"},
		{time = 6/33, sound = "CW_KK_INS2_C4_THROW"},
		// { event 3005 8 ""},
	},

	low_throw = {
		{time = 5/30, sound = "CW_KK_INS2_M67_PINPULL"},
		{time = 33/30, sound = "CW_KK_INS2_C4_THROW"},
		// { event 3005 35 ""},
	},
}
