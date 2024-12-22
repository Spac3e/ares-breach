--[[


addons/[weapons]_cw_20/lua/cw/shared/ammotypes/am_reducedpowderload.lua

--]]

local att = {}
att.name = "am_reducedpowderload"
att.displayName = "Reduced powder load"
att.displayNameShort = "RPL"

att.statModifiers = {DamageMult = -0.25,
	RecoilMult = -0.3,
	SpreadPerShotMult = -0.3}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/magnumrounds")
	att.description = {{t = "Reduced powder load, which reduces muzzle velocity and recoil alike.", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self:unloadWeapon()
end

function att:detachFunc()
	self:unloadWeapon()
end

CustomizableWeaponry:registerAttachment(att)