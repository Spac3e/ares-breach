--[[


addons/[weapons]_cw_20/lua/cw/shared/attachments/md_tundra9mm.lua

--]]

local att = {}
att.name = "md_tundra9mm"
att.displayName = "Tundra 9MM"
att.displayNameShort = "Tundra"
att.isSuppressor = true
att.SpeedDec = 1

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