--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_nade_c4_de/sh_soundscript.lua

--]]


local function pcf(wep)
	if SERVER then return end

	if wep.Owner:ShouldDrawLocalPlayer() then return end

	local vm = wep.AttachmentModelsVM.fx_rag.ent

	ParticleEffectAttach("weapon_compB_fuse", PATTACH_POINT_FOLLOW, vm, 1)

	wep._pcfStop = wep.Sequence

	wep._soundStop = vm:StartLoopingSound("CW_KK_INS2_DOI_C4_DE_FUSELOOP")
end

local function soundLoop(wep)
	if SERVER then return end

	if wep.soundLoop then wep.soundLoop:Stop() end

	-- sound.PlayFile("CW_KK_INS2_DOI_C4_DE_FUSELOOP", "3d", function(sound, ...)
	sound.PlayFile("sound/weapons/compositonb/handling/compositonb_fuse_loop.wav", "", function(sound)
		if IsValid(sound) then
			wep.soundLoop = sound
			sound:EnableLooping(true)
			sound:Play()
		end
	end)
end

SWEP.Sounds = {
	base_plant = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_C4_DE_PLANTARMMOVEMENT"},
		{time = 12/30, sound = "CW_KK_INS2_DOI_C4_DE_PLANTPLACE"},
		{time = 31/30, sound = "CW_KK_INS2_DOI_C4_DE_PRIME", callback = pcf},
		{time = 35/30, sound = "", callback = soundLoop},
		// 35/30
	},

	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 10/29, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 20/29, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_pullback = {
		{time = 19/33, sound = "CW_KK_INS2_DOI_C4_DE_PRIME", callback = pcf},
		{time = 29/33, sound = "", callback = soundLoop},
		// { event 3900 29 ""},
	},

	secondary_pullback = {
		{time = 19/33, sound = "CW_KK_INS2_DOI_C4_DE_PRIME", callback = pcf},
		{time = 29/33, sound = "", callback = soundLoop},
		// { event 3900 29 ""},
	},

	low_pullback = {
		{time = 19/33, sound = "CW_KK_INS2_DOI_C4_DE_PRIME", callback = pcf},
		{time = 32/33, sound = "", callback = soundLoop},
		// { event 3900 32 ""},
	},

	base_throw = {
		{time = 6/33, sound = "CW_KK_INS2_DOI_C4_DE_THROW"},
		// { event 3005 7 ""},
	},

	secondary_throw = {
		{time = 6/33, sound = "CW_KK_INS2_DOI_C4_DE_THROW"},
		// { event 3005 7 ""},
	},

	low_throw = {
		{time = 6/30, sound = "CW_KK_INS2_DOI_C4_DE_THROW"},
		// { event 3005 7 ""},
	},
}
