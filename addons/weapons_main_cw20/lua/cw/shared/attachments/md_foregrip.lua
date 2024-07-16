--[[


addons/[weapons]_cw_20/lua/cw/shared/attachments/md_foregrip.lua

--]]

local att = {}
att.name = "md_foregrip"
att.displayName = "Foregrip"
att.displayNameShort = "Grip"

att.statModifiers = {VelocitySensitivityMult = -0.15,
DrawSpeedMult = -0.1,
SpreadPerShotMult = -0.1,
RecoilMult = -0.125}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/foregrip")
end

CustomizableWeaponry:registerAttachment(att)