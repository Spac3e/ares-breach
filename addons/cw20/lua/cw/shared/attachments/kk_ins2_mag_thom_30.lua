--[[


addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_mag_thom_30.lua

--]]

local att = {}
att.name = "kk_ins2_mag_thom_30"
att.displayName = "30 round magazine"
att.displayNameShort = "30 RND"

att.statModifiers = {
	// OverallMouseSensMult = -0.05
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Increases mag size to 30 rounds.", c = CustomizableWeaponry.textColors.POSITIVE}
	}
end

function att:attachFunc()
	self._KK_INS2_customReloadSuffix = ""
	self:unloadWeapon()
	self.Primary.ClipSize = 30
	self.Primary.ClipSize_Orig = 30
end

function att:detachFunc()
	self._KK_INS2_customReloadSuffix = ""
	self:unloadWeapon()
	self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
end

CustomizableWeaponry:registerAttachment(att)
