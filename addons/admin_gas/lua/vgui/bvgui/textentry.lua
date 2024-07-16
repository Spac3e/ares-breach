--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/textentry.lua

--]]

local PANEL = {}

function PANEL:Init()
	self:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self:ApplySchemeSettings()
	self:SetTextColor(bVGUI.COLOR_BLACK)
end

local focused_col = Color(0,120,255,255)
function PANEL:Paint(w,h)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawRect(0,0,w,h)
	
	if (self._Valid) then
		surface.SetDrawColor(0,255,0,100)
		surface.DrawRect(0,0,w,h)
	elseif (self._Invalid) then
		surface.SetDrawColor(255,0,0,100)
		surface.DrawRect(0,0,w,h)
	end

	if (self:HasFocus()) then
		surface.SetDrawColor(0,120,255,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	if (self:GetPlaceholderText() and #string.Trim(self:GetText()) == 0) then
		local oldtext = self:GetText()
		self:SetText(self:GetPlaceholderText())
		self:DrawTextEntryText(self:GetPlaceholderColor(), self:GetHighlightColor(), self:GetCursorColor())
		self:SetText(oldtext)
	else
		self:DrawTextEntryText(self:GetTextColor(), self:GetHighlightColor(), self:GetCursorColor())
	end
end

function PANEL:OnGetFocus()
	self.StoredValue = self:GetValue()
end

function PANEL:OnLoseFocus()
	if (self.OnValueChange and self:GetValue() ~= self.StoredValue) then
		self:OnValueChange(self:GetValue())
	end
end

function PANEL:SetInvalid(invalid)
	self._Invalid = invalid
	self._Valid = nil
end

function PANEL:SetValid(valid)
	self._Valid = valid
	self._Invalid = nil
end

function PANEL:ResetValidity()
	self._Valid, self._Invalid = nil
end

derma.DefineControl("bVGUI.TextEntry", nil, PANEL, "DTextEntry")

local PANEL = {}

function PANEL:Init()
	self.TextEntry = vgui.Create("bVGUI.TextEntry", self)
	self.TextEntry:SetWide(350)
end

function PANEL:SetLabel(text)
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetContentAlignment(4)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText(text)
	self.Label:SizeToContents()

	self:PerformSizing()
end

function PANEL:SetHelpText(text)
	self.HelpLabel = vgui.Create("DLabel", self)
	self.HelpLabel:SetContentAlignment(4)
	self.HelpLabel:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	self.HelpLabel:SetTextColor(bVGUI.COLOR_WHITE)
	self.HelpLabel:SetText(text)
	self.HelpLabel:SetWide(500)
	self.HelpLabel:SetWrap(true)
	self.HelpLabel:SetAutoStretchVertical(true)
	self.HelpLabel:SetTextColor(Color(200,200,200))
	function self.HelpLabel:PerformLayout()
		self:GetParent():PerformSizing()
		self:InvalidateParent(true)
	end
end

function PANEL:PerformSizing()
	local y = self.TextEntry:GetTall()
	if (IsValid(self.Label)) then
		y = y + self.Label:GetTall() + 10
	end
	if (IsValid(self.HelpLabel)) then
		y = y + self.HelpLabel:GetTall() + 10
	end
	self:SetTall(y)
end

function PANEL:PerformLayout()
	self.Label:AlignTop(0)
	self.HelpLabel:AlignBottom(0)
	self.TextEntry:AlignTop(self.Label:GetTall() + 10)
end

derma.DefineControl("bVGUI.TextEntryContainer", nil, PANEL, "bVGUI.BlankPanel")