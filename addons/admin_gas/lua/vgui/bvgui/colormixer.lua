--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/colormixer.lua

--]]

local PANEL = {}

function PANEL:Init()
	self.ColorMixer = vgui.Create("DColorMixer", self)
	self.ColorMixer:SetPalette(false)
end

function PANEL:SetColor(col)
	self.ColorMixer:SetColor(col)
end
function PANEL:GetColor()
	return self.ColorMixer:GetColor()
end

function PANEL:SetLabel(text)
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetContentAlignment(4)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText(text)
	self.Label:SizeToContentsX()
	self.Label:SetTall(21)
end

function PANEL:PerformLayout()
	self.ColorMixer:AlignBottom(0)
	if (IsValid(self.Label)) then
		self.ColorMixer:SetSize(self:GetTall() * 1.6, self:GetTall() - self.Label:GetTall())
	else
		self.ColorMixer:SetSize(self:GetTall() * 1.6, self:GetTall())
	end
end

derma.DefineControl("bVGUI.ColorMixer", nil, PANEL, "bVGUI.BlankPanel")