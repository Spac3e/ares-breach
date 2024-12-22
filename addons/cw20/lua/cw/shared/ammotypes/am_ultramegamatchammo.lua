--[[


addons/[weapons]_cw_20/lua/cw/shared/ammotypes/am_ultramegamatchammo.lua

--]]

local att = {}
att.name = "am_ultramegamatchammo"
att.displayName = "Ultra Mega Match grade rounds"
att.displayNameShort = "UMGMatch"

att.statModifiers = {AimSpreadMult = -0.99}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/matchgradeammo")
	att.description = {
		{t = "ur gay lol", c = CustomizableWeaponry.textColors.VNEGATIVE},
		{t = "i kiss you on the lips", c = CustomizableWeaponry.textColors.VPOSITIVE},
		{t = "i love you", c = CustomizableWeaponry.textColors.VPOSITIVE},
		{t = "oh god im gonna cum", c = CustomizableWeaponry.textColors.VPOSITIVE},
		{t = "hello buy Intravenous :)", c = CustomizableWeaponry.textColors.VPOSITIVE},
	}
end

function att:attachFunc()
	self:unloadWeapon()
end

function att:detachFunc()
	self:unloadWeapon()
end

CustomizableWeaponry:registerAttachment(att)