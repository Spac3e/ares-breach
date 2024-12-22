--[[


addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_sights_base.lua

--]]

local att = {}
att.name = "kk_ins2_sights_base"
att.displayName = "INS2 Devs"
att.displayNameShort = "NWI"

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {}
end

CustomizableWeaponry:registerAttachment(att)
