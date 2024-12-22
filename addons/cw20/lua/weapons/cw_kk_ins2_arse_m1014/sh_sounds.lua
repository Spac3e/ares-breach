--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_arse_m1014/sh_sounds.lua

--]]

--[[
lua/weapons/cw_kk_ins2_arse_m1014/sh_sounds.lua
--]]
CustomizableWeaponry:addFireSound("CW_KK_INS2_M590_FIRE", "weapons/m590/m590_fp.wav", 1, 105, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_M590_FIRE_SUPPRESSED", "weapons/m590/m590_suppressed_fp.wav", 1, 75, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_M590_EMPTY", "weapons/m590/handling/m590_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M590_PUMPBACK", "weapons/m590/handling/m590_pumpback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M590_PUMPFORWARD", "weapons/m590/handling/m590_pumpforward.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M590_SHELLINSERT", {
	"weapons/m590/handling/m590_shell_insert_1.wav",
	"weapons/m590/handling/m590_shell_insert_2.wav",
	"weapons/m590/handling/m590_shell_insert_3.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M590_SHELLINSERTSINGLE", {
	"weapons/m590/handling/m590_single_shell_insert_1.wav",
	"weapons/m590/handling/m590_single_shell_insert_2.wav",
	"weapons/m590/handling/m590_single_shell_insert_3.wav"
})


