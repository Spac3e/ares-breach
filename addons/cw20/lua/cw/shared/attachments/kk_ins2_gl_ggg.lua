--[[


addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_gl_ggg.lua

--]]

local att = {}
att.name = "kk_ins2_gl_ggg"
att.displayNameShort = "GL"
att.displayName = "Gewehrgranatgerät"
att.isGrenadeLauncher = true
att.ww2GrenadeLauncher = true
att.KK_INS2_playIdle = true

att.statModifiers = {
	DrawSpeedMult = -0.2,
	HolsterSpeedMult = -0.2,
	// OverallMouseSensMult = -0.2,
	RecoilMult = -0.1
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Allows the user to fire 40MM rounds.", c = CustomizableWeaponry.textColors.POSITIVE},
	}
end

local function resetGL(self)
	if self.M203Chamber then
		if SERVER then
			self.Owner:GiveAmmo(1, "40MM", true)
		end
		self.M203Chamber = false
	end

	self.dt.INS2GLActive = false
end

function att:attachFunc()
	resetGL(self)
end

function att:detachFunc()
	resetGL(self)
end

CustomizableWeaponry:registerAttachment(att)
