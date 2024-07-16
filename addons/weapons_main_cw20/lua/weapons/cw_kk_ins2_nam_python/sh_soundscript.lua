--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_python/sh_soundscript.lua

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

		-- {time = 0/30, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.dostuff},

SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 29/30, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 46/30, sound = "CW_KK_INS2_REVOLVER_CLOSECHAMBER"},
	},

	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fire = {
		{time = 0/30, sound = "CW_KK_INS2_REVOLVER_COCKHAMMER"},
		// { event AE_MUZZLEFLASH 0 ""},
	},

	base_fire2 = {
		{time = 0/30, sound = "CW_KK_INS2_REVOLVER_COCKHAMMER"},
		// { event AE_MUZZLEFLASH 0 ""},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_REVOLVER_COCKHAMMER"},
		{time = 4/30, sound = "CW_KK_INS2_REVOLVER_EMPTY"},
	},

	base_reload_start = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 16/31, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 39/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 45/31, sound = "", callback = spawnShells},
		{time = 51/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 55/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
		// { event AE_EMIT_SHELL_38 49 ""},
	},

	base_reload_start2 = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 16/31, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 39/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 45/31, sound = "", callback = spawnShells},
		{time = 51/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 55/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
		// { event AE_EMIT_SHELL_38 49 ""},
	},

	base_reload_start3 = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 16/31, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 39/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 45/31, sound = "", callback = spawnShells},
		{time = 51/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 55/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
		// { event AE_EMIT_SHELL_38 49 ""},
	},

	base_reload_start4 = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 1/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 16/31, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 39/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 45/31, sound = "", callback = spawnShells},
		{time = 51/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 55/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
		// { event AE_EMIT_SHELL_38 49 ""},
	},

	base_reload_insert = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bothToClipP1},
		{time = 8/32, sound = "CW_KK_INS2_REVOLVER_INSERTSINGLE"},
		// { event 46 0 ""},
		{time = 28/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reload_end = {
		{time = 7/31, sound = "CW_KK_INS2_UNIVERSAL_LEANOUT"},
		{time = 22/31, sound = "CW_KK_INS2_REVOLVER_CLOSECHAMBER"},
	},

	base_reload_speed = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 16/31, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 39/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 45/31, sound = "", callback = spawnShells},
		{time = 51/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 55/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
		// { event AE_EMIT_SHELL_49 57 ""},
		{time = 88/31, sound = "CW_KK_INS2_REVOLVER_SPEEDLOADERINSERT"},
		{time = 90/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bothToReserve},
		// { event 46 105 ""},
		{time = 118/31, sound = "CW_KK_INS2_REVOLVER_CLOSECHAMBER"},
	},

	base_reload_speed2 = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 16/31, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 39/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 45/31, sound = "", callback = spawnShells},
		{time = 51/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 55/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
		// { event AE_EMIT_SHELL_49 57 ""},
		{time = 88/31, sound = "CW_KK_INS2_REVOLVER_SPEEDLOADERINSERT"},
		{time = 90/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bothToReserve},
		// { event 46 105 ""},
		{time = 118/31, sound = "CW_KK_INS2_REVOLVER_CLOSECHAMBER"},
	},

	base_reload_speed3 = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 16/31, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 39/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 45/31, sound = "", callback = spawnShells},
		{time = 51/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 55/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
		// { event AE_EMIT_SHELL_49 57 ""},
		{time = 88/31, sound = "CW_KK_INS2_REVOLVER_SPEEDLOADERINSERT"},
		{time = 90/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bothToReserve},
		// { event 46 105 ""},
		{time = 118/31, sound = "CW_KK_INS2_REVOLVER_CLOSECHAMBER"},
	},

	base_reload_speed4 = {
		{time = 0/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.beltToClip},
		{time = 2/31, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 16/31, sound = "CW_KK_INS2_REVOLVER_OPENCHAMBER"},
		{time = 39/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 45/31, sound = "", callback = spawnShells},
		{time = 51/31, sound = "CW_KK_INS2_REVOLVER_DUMPROUNDS"},
		{time = 55/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.shellsToClip},
		// { event AE_EMIT_SHELL_49 57 ""},
		{time = 88/31, sound = "CW_KK_INS2_REVOLVER_SPEEDLOADERINSERT"},
		{time = 90/31, sound = "", callback = CustomizableWeaponry_KK.ins2.bulletBgs.bothToReserve},
		// { event 46 105 ""},
		{time = 118/31, sound = "CW_KK_INS2_REVOLVER_CLOSECHAMBER"},
	},

	iron_fire = {
		{time = 0/30, sound = "CW_KK_INS2_REVOLVER_COCKHAMMER"},
		// { event AE_MUZZLEFLASH 0 ""},
	},

	iron_fire2 = {
		{time = 0/30, sound = "CW_KK_INS2_REVOLVER_COCKHAMMER"},
		// { event AE_MUZZLEFLASH 0 ""},
	},

	iron_fire3 = {
		{time = 0/30, sound = "CW_KK_INS2_REVOLVER_COCKHAMMER"},
		// { event AE_MUZZLEFLASH 0 ""},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_REVOLVER_COCKHAMMER"},
		{time = 4/30, sound = "CW_KK_INS2_REVOLVER_EMPTY"},
	},
}
