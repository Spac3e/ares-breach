--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1917/sh_soundscript.lua

--]]


local function spawnShells(self)
	if SERVER then return end

	local vm = self.CW_VM
	local b = vm:GetBodygroup(self._beltBGID)
	local s = vm:GetBodygroup(self._shellsBGID)

	for _ = 1, (s - b) do
		self:shellEventRev()
	end
end

local db = {}

local function reloadStarted(self)
	db[self] = true
end

local function reloadFinished(self)
	db[self] = false
end

local lastValidResetTime

local function meleeShellCorection(self)
	if db[self] then
		CustomizableWeaponry_KK.ins2.bulletBgs.bothToClip(self)
	end

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
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_crawl_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fire = {
		{time = 22/35, sound = "CW_KK_INS2_DOI_M1917_COCKHAMMER"},
		// { event AE_MUZZLEFLASH 0 ""},
	},

	base_fire2 = {
		{time = 22/35, sound = "CW_KK_INS2_DOI_M1917_COCKHAMMER"},
		// { event AE_MUZZLEFLASH 0 ""},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1917_COCKHAMMER"},
		{time = 4/30, sound = "CW_KK_INS2_DOI_M1917_EMPTY"},
	},

	base_reload_start = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/34, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 22/34, sound = "CW_KK_INS2_DOI_M1917_OPENCHAMBER"},
		{time = 46/34, sound = "CW_KK_INS2_DOI_M1917_DUMPROUNDS"},
		{time = 47/34, sound = "", callback = spawnShells},
		{time = 60/34, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
	},

	base_reload_start_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/34, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 12/34, sound = "CW_KK_INS2_DOI_M1917_COCKHAMMER"},
		{time = 46/34, sound = "CW_KK_INS2_DOI_M1917_OPENCHAMBER"},
		{time = 70/34, sound = "CW_KK_INS2_DOI_M1917_DUMPROUNDS"},
		{time = 71/34, sound = "", callback = spawnShells},
		{time = 84/34, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
	},

	base_reload_insert = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bothToClipP1},
		{time = 13/40, sound = "CW_KK_INS2_DOI_M1917_INSERTSINGLE"},
		// { event 46 0 ""},
		{time = 26/40, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reload_end = {
		{time = 7/34.5, sound = "CW_KK_INS2_UNIVERSAL_LEANOUT"},
		{time = 29/34.5, sound = "CW_KK_INS2_DOI_M1917_CLOSECHAMBER"},
	},

	base_reload_clip = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 24/32, sound = "CW_KK_INS2_DOI_M1917_OPENCHAMBER"},
		{time = 48/32, sound = "CW_KK_INS2_DOI_M1917_DUMPROUNDS", callback = reloadStarted},
		{time = 50/32, sound = "", callback = spawnShells},
		{time = 55/32, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bothToReserve},
		{time = 93/32, sound = "CW_KK_INS2_DOI_M1917_MOONCLIP"},
		{time = 121/32, sound = "CW_KK_INS2_DOI_M1917_MOONCLIP"},
		{time = 145/32, sound = "CW_KK_INS2_DOI_M1917_CLOSECHAMBER", callback = reloadFinished},
	},

	base_reload_clip_empty = {
		{time = 0, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 24/32, sound = "CW_KK_INS2_DOI_M1917_OPENCHAMBER"},
		{time = 48/32, sound = "CW_KK_INS2_DOI_M1917_DUMPROUNDS", callback = reloadStarted},
		{time = 50/32, sound = "", callback = spawnShells},
		{time = 55/32, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bothToReserve},
		{time = 93/32, sound = "CW_KK_INS2_DOI_M1917_MOONCLIP"},
		{time = 121/32, sound = "CW_KK_INS2_DOI_M1917_MOONCLIP"},
		{time = 145/32, sound = "CW_KK_INS2_DOI_M1917_CLOSECHAMBER", callback = reloadFinished},
		{time = 163/32, sound = "CW_KK_INS2_DOI_M1917_COCKHAMMER"},
	},

	iron_fire_1 = {
		{time = 22/35, sound = "CW_KK_INS2_DOI_M1917_COCKHAMMER"},
		// { event AE_MUZZLEFLASH 0 ""},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1917_COCKHAMMER"},
		{time = 4/30, sound = "CW_KK_INS2_DOI_M1917_EMPTY"},
	},

	base_melee_bash = {
		{time = 0, sound = "", callback = meleeShellCorection},
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash_empty = {
		{time = 0, sound = "", callback = meleeShellCorection},
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
