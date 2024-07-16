--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1911/sh_soundscript.lua

--]]


local lastValidResetTime

local function meleeShellCorection(self)
	self.reticleInactivity = UnPredictedCurTime() + 0.8

	lastValidResetTime = CurTime()
	local localValidResetTime = lastValidResetTime

	CustomizableWeaponry.actionSequence.new(self, 0.7, nil, function()
		if lastValidResetTime == localValidResetTime then
			self:idleAnimFunc()
		end
	end)
end

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 17/30, sound = "CW_KK_INS2_DOI_M1911_SAFETY"},
		{time = 40/30, sound = "CW_KK_INS2_DOI_M1911_BOLTBACK"},
		{time = 45/30, sound = "CW_KK_INS2_DOI_M1911_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire3 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_firelast = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1911_EMPTY"},
	},

	base_reload = {
		{time = 12/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGRELEASE"},
		{time = 15/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGOUT"},
		{time = 48/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGIN"},
		{time = 55/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGHIT"},
		-- { event 46 56 ""},
	},

	base_reloadempty = {
		{time = 12/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGRELEASE"},
		{time = 15/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGOUT"},
		{time = 48/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGIN"},
		{time = 55/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGHIT"},
		-- { event 46 56 ""},
		{time = 77/31.5, sound = "CW_KK_INS2_DOI_M1911_BOLTRELEASE"},
	},

	base_reloadempty_null = {
		{time = 10/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGRELEASE"},
		{time = 14/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGOUT"},
		{time = 43/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGIN"},
		{time = 55/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGHIT"},
		-- { event 46 56 ""},
		{time = 79/31.5, sound = "CW_KK_INS2_DOI_M1911_BOLTRELEASE"},
	},

	base_reload_extmag = {
		{time = 12/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGRELEASE"},
		{time = 15/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGOUT"},
		{time = 48/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGIN"},
		{time = 55/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGHIT"},
		-- { event 46 56 ""},
	},

	base_reloadempty_extmag = {
		{time = 12/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGRELEASE"},
		{time = 15/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGOUT"},
		{time = 48/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGIN"},
		{time = 55/31.5, sound = "CW_KK_INS2_DOI_M1911_MAGHIT"},
		-- { event 46 56 ""},
		{time = 77/31.5, sound = "CW_KK_INS2_DOI_M1911_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- iron_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire3 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_firelast = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1911_EMPTY"},
	},

	iron_dryfire_preblend = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1911_EMPTY"},
	},

	base_melee_bash = {
		{time = 0, sound = "", callback = meleeShellCorection},
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	empty_melee_bash = {
		{time = 0, sound = "", callback = meleeShellCorection},
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
