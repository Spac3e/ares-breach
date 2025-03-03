--[[


addons/[weapons]_cw_20/lua/cw/shared/attachments/md_saker.lua

--]]

local att = {}
att.name = "md_saker"
att.displayName = "SAKER"
att.displayNameShort = "SAKER"
att.isSuppressor = true
att.SpeedDec = 2

att.statModifiers = {OverallMouseSensMult = -0.1,
RecoilMult = -0.15,
DamageMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/saker")
	att.description = {[1] = {t = "Decreases firing noise.", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self.dt.Suppressed = true
end

function att:detachFunc()
	self:resetSuppressorStatus()
end

CustomizableWeaponry:registerAttachment(att)