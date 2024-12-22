--[[


addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_suppressor_pistol.lua

--]]

local att = {}
att.name = "kk_ins2_suppressor_pistol"
att.displayName = "Pistol suppressor"
att.displayNameShort = "Silencer"
att.isSuppressor = true
att.WeaponLength = 8

att.statModifiers = {
	// OverallMouseSensMult = -0.1,
	RecoilMult = -0.15,
	-- WeaponLength = 8,
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Decreases firing noise.", c = CustomizableWeaponry.textColors.POSITIVE},
		-- [2] = {t = "Increases weapon length.", c = CustomizableWeaponry.textColors.NEGATIVE}
	}
end

function att:attachFunc()
	self.dt.Suppressed = true
end

function att:detachFunc()
	self:resetSuppressorStatus()
end

CustomizableWeaponry:registerAttachment(att)