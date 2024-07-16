--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/numberwang.lua

--]]

local PANEL = {}

function PANEL:Init()
	self.NumberWang = vgui.Create("DNumberWang", self)
	self.NumberWang:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
end

function PANEL:CorrectSizing()
	local y = 0
	y = y + self.NumberWang:GetTall()
	if (IsValid(self.Label)) then
		y = y + 10 + self.Label:GetTall()
		self.NumberWang:AlignTop(10 + self.Label:GetTall())
	end
	if (IsValid(self.HelpLabel)) then
		y = y + 10 + self.HelpLabel:GetTall()
		self.HelpLabel:AlignTop(10 + self.Label:GetTall() + self.NumberWang:GetTall() + 10)
	end
	self:SetTall(y)
end

function PANEL:SetText(text)
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetContentAlignment(4)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText(text)
	self.Label:SizeToContents()

	self:CorrectSizing()
end

function PANEL:SetHelpText(text)
	self.HelpLabel = vgui.Create("DLabel", self)
	self.HelpLabel:SetTextColor(Color(200,200,200))
	self.HelpLabel:SetAutoStretchVertical(true)
	self.HelpLabel:SetWrap(true)
	self.HelpLabel:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	self.HelpLabel:SetText(text)
	local this = self
	function self.HelpLabel:PerformLayout()
		this:CorrectSizing()
	end
	self:CorrectSizing()
end

function PANEL:PerformLayout()
	if (IsValid(self.HelpLabel)) then
		self.HelpLabel:SetWide(self:GetWide() - 10)
	end
end

derma.DefineControl("bVGUI.NumberWang", nil, PANEL, "bVGUI.BlankPanel")