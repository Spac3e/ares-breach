--[[


addons/[weapons]_cw_20/lua/cw/shared/attachments/md_cmag_556_official.lua

--]]

local att = {}
att.name = "md_cmag_556_official"
att.displayName = "Beta C-Mag 5.56x45MM"
att.displayNameShort = "C-Mag"
att.SpeedDec = 4

att.statModifiers = {ReloadSpeedMult = -0.25,
DrawSpeedMult = -0.1,
OverallMouseSensMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/cmag_official")
	att.description = {[1] = {t = "Increases mag size to 100 rounds.", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self:unloadWeapon()
	self.canOffsetMagBone = true
	
	self.ForegripOverride = true
	self.ForegripParent = "md_cmag_556_official"
	
	self.Primary.ClipSize = 100
	self.Primary.ClipSize_Orig = 100
end

function att:detachFunc()
	self:unloadWeapon()
	self.canOffsetMagBone = false
	
	if CLIENT then
		self:offsetMagBone(true)
	end
	
	self.ForegripOverride = false
	self.ForegripParent = nil
	
	self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
end

CustomizableWeaponry:registerAttachment(att)