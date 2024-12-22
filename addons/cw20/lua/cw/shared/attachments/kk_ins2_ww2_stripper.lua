--[[


addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_ww2_stripper.lua

--]]

local att = {}
att.name = "kk_ins2_ww2_stripper"
att.displayNameShort = "Strippers"
att.displayName = "Stripper clip"

att.statModifiers = {}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Significantly decreases empty reload time.", c = CustomizableWeaponry.textColors.VPOSITIVE},
	}
end

CustomizableWeaponry:registerAttachment(att)
