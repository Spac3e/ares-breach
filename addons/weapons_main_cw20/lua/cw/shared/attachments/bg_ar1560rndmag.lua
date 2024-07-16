--[[


addons/[weapons]_cw_20/lua/cw/shared/attachments/bg_ar1560rndmag.lua

--]]

local att = {}
att.name = "bg_ar1560rndmag"
att.displayName = "Quad-stack mag"
att.displayNameShort = "Quad"
att.isBG = true
att.SpeedDec = 2

att.statModifiers = {ReloadSpeedMult = -0.15,
OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/ar1560rndmag")
	att.description = {[1] = {t = "Increases mag size to 60 rounds.", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.round60)
	self:unloadWeapon()
	self.Primary.ClipSize = 60
	self.Primary.ClipSize_Orig = 60
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
	self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
end

CustomizableWeaponry:registerAttachment(att)