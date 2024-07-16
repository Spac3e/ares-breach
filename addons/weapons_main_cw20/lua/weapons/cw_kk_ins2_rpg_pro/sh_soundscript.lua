--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_rpg_pro/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_rpg_pro/sh_soundscript.lua
--]]

SWEP.particleLighter = "molotov_lighter"
SWEP.particleRag = "weapon_compB_fuse"

PrecacheParticleSystem(SWEP.particleLighter)
PrecacheParticleSystem(SWEP.particleRag)

if CLIENT then
	function SWEP:updateOtherParts()
		if self.Sequence != self._ragStop then
			self.AttachmentModelsVM.fx_rag.ent:StopParticles()
			self._ragStop = nil
		end

		if self.Sequence != self._lighterStop or self.CW_VM:GetCycle() >= 1 then
			self.AttachmentModelsVM.fx_light.ent:StopParticles()
			self._lighterStop = nil
		end
	end
end

local function lighter(wep)
	if SERVER then return end

	if wep.Owner:ShouldDrawLocalPlayer() then return end

	local vm = wep.AttachmentModelsVM.fx_light.ent

	ParticleEffectAttach(wep.particleLighter, PATTACH_POINT_FOLLOW, vm, 1)

	wep._lighterStop = wep.Sequence
end

local function lighterFin(wep)
	if SERVER then return end

	wep._lighterStop = nil
end

local function rag(wep)
	if SERVER then return end

	if wep.Owner:ShouldDrawLocalPlayer() then return end

	local vm = wep.AttachmentModelsVM.fx_rag.ent

	ParticleEffectAttach(wep.particleRag, PATTACH_POINT_FOLLOW, vm, 0)

	wep._ragStop = wep.Sequence
end

SWEP.Sounds = {
	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_GRENADE_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_GRENADE_HOLSTER"},
	},

	base_crawl = {
		{time = 10/25, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 20/25, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	pullback_high = {
		{time = 1/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTEROPEN"},
		{time = 5/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTERSTRIKE", callback = lighter},
		{time = 8/20, sound = "CW_KK_INS2_MOLOTOV_IGNITE", callback = rag},
		{time = 17/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTERCLOSE", callback = lighterFin},
	},

	pullback_highbake = {
		{time = 1/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTEROPEN"},
		{time = 5/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTERSTRIKE", callback = lighter},
		{time = 8/20, sound = "CW_KK_INS2_MOLOTOV_IGNITE", callback = rag},
		{time = 17/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTERCLOSE", callback = lighterFin},
	},

	pullback_low = {
		{time = 1/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTEROPEN"},
		{time = 5/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTERSTRIKE", callback = lighter},
		{time = 8/20, sound = "CW_KK_INS2_MOLOTOV_IGNITE", callback = rag},
		{time = 17/20, sound = "CW_KK_INS2_MOLOTOV_LIGHTERCLOSE", callback = lighterFin},
	},

	throw = {
		{time = 0, sound = "CW_KK_INS2_MOLOTOV_THROW"},
		{time = 0.3, sound = "CW_KK_INS2_RPG_FIRE"},
	},

	throw_bake = {
		{time = 0, sound = "CW_KK_INS2_MOLOTOV_THROW"},
		{time = 0.3, sound = "CW_KK_INS2_RPG_FIRE"},
	},

	throw_low = {
		{time = 0, sound = "CW_KK_INS2_MOLOTOV_THROW"},
		{time = 0.3, sound = "CW_KK_INS2_RPG_FIRE"},
	}
}


