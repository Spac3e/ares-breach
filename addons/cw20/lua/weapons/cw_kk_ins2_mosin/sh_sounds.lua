--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_mosin/sh_sounds.lua

--]]

--[[
lua/weapons/cw_kk_ins2_mosin/sh_sounds.lua
--]]
CustomizableWeaponry:addFireSound("CW_KK_INS2_MOSIN_FIRE", "weapons/mosin/mosin_fp.wav", 1, 105, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_MOSIN_FIRE_SUPPRESSED", "weapons/mosin/mosin_suppressed_fp.wav", 1, 75, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BOLTBACK", "weapons/mosin/handling/mosin_boltback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BOLTFORWARD", "weapons/mosin/handling/mosin_boltforward.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BOLTLATCH", "weapons/mosin/handling/mosin_boltlatch.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BOLTRELEASE", "weapons/mosin/handling/mosin_boltrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BULLETIN", {
	"weapons/mosin/handling/mosin_bulletin_1.wav",
	"weapons/mosin/handling/mosin_bulletin_2.wav",
	"weapons/mosin/handling/mosin_bulletin_3.wav",
	"weapons/mosin/handling/mosin_bulletin_4.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_EMPTY", "weapons/mosin/handling/mosin_empty.wav")


