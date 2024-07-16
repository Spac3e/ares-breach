--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/button.lua

--]]

--/// Button Color Enumerations ///--

bVGUI.BUTTON_COLOR_BLUE   = bVGUI.COLOR_GMOD_BLUE
bVGUI.BUTTON_COLOR_GREEN  = Color(57, 202, 116)
bVGUI.BUTTON_COLOR_RED    = Color(229, 77, 66)
bVGUI.BUTTON_COLOR_ORANGE = Color(230, 126, 34)
bVGUI.BUTTON_COLOR_PURPLE = Color(154, 91, 180)
bVGUI.BUTTON_COLOR_YELLOW = Color(240, 195, 48)
bVGUI.BUTTON_COLOR_GREY   = Color(62, 62, 62)

--/// bVGUI.Button ///--

local PANEL = {}

function PANEL:Init()
	self:SetCursor("hand")
	self:SetTall(30)
	self:SetMouseInputEnabled(true)
	self:DockPadding(0,0,0,4)

	self.OriginalBarColor = bVGUI.INFOBAR_COLOR_GREY
	self.TargetBarColor = self.OriginalBarColor
	self.BorderColor = bVGUI.DarkenColor(self.OriginalBarColor, 0.4)

	self.Label = vgui.Create("DLabel", self)
	self.Label:Dock(FILL)
	self.Label:SetContentAlignment(5)
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
end

function PANEL:SetFont(font)
	self.Label:SetFont(font)
end

function PANEL:SetText(text)
	self.Text = text
	self.Label:SetText(text)
end
function PANEL:GetText()
	return self.Text
end

function PANEL:SetColor(col_enum)
	self.Label:SetTextColor(bVGUI.TextColorContrast(col_enum))
	self.OriginalBarColor = col_enum
	self.TargetBarColor = self.OriginalBarColor
	self.BorderColor = bVGUI.DarkenColor(self.OriginalBarColor, 0.4)
	if (self.ColorInterpolation) then
		self.ColorInterpolation = bVGUI.LerpColor(self.OriginalBarColor, self.OriginalBarColor, 0.5)
	end
end
function PANEL:GetColor()
	return self.OriginalBarColor
end

function PANEL:OnCursorEntered()
	if (self.Tooltip) then
		bVGUI.CreateTooltip(self.Tooltip)
	end
	if (self.Disabled) then return end

	self.TargetBarColor = bVGUI.LightenColor(self.OriginalBarColor, 0.2)
	self.ColorInterpolation = bVGUI.LerpColor(self.OriginalBarColor, self.TargetBarColor, 0.5)
end
function PANEL:OnCursorExited()
	if (self.Tooltip) then
		bVGUI.DestroyTooltip()
	end
	if (self.Disabled) then return end

	self.ColorInterpolation = bVGUI.LerpColor(self.TargetBarColor, self.OriginalBarColor, 0.5)
	self.TargetBarColor = self.OriginalBarColor
end
function PANEL:OnMousePressed()
	if (self.Disabled) then return end

	self.ColorInterpolation = nil
	self.TargetBarColor = self.BorderColor
	if (self.DrawBorder ~= false) then
		self:DockPadding(0,0,0,0)
		self:InvalidateLayout(true)
	end
end
function PANEL:OnMouseReleased()
	if (self.Disabled) then return end

	if (self:IsHovered()) then
		self.TargetBarColor = bVGUI.LightenColor(self.OriginalBarColor, 0.2)
	else
		self.TargetBarColor = self.OriginalBarColor
	end
	if (self.DrawBorder ~= false) then
		self:DockPadding(0,0,0,4)
		self:InvalidateLayout(true)
	end

	if (self.ButtonSound and GAS) then
		GAS:PlaySound(self.ButtonSound)
	end
	if (self.DoClick) then
		self:DoClick()
	end
end

function PANEL:Paint(w,h)
	if (self.ColorInterpolation) then
		self.ColorInterpolation:DoLerp()
		surface.SetDrawColor(self.ColorInterpolation:GetColor())
	else
		surface.SetDrawColor(self.TargetBarColor)
	end
	if (self.DrawBorder ~= false) then
		local col
		if (self.ColorInterpolation) then
			col = self.ColorInterpolation:GetColor()
		else
			col = self.TargetBarColor
		end
		draw.RoundedBox(4, 0, 0, w, h, self.BorderColor)
		draw.RoundedBoxEx(4, 0, 0, w, h - 4, col, true, true)
	else
		surface.DrawRect(0,0,w,h)
	end
end

function PANEL:SetDisabled(disabled)
	self.Disabled = disabled
	if (disabled) then
		self:SetCursor("no")
		if (self.ColorInterpolation) then
			self.ColorInterpolation = bVGUI.LerpColor(self.TargetBarColor, bVGUI.BUTTON_COLOR_GREY, 0.5)
		end
		self.TargetBarColor = bVGUI.BUTTON_COLOR_GREY
	else
		self:SetCursor("hand")
		if (self.ColorInterpolation) then
			self.ColorInterpolation = bVGUI.LerpColor(self.TargetBarColor, self.OriginalBarColor, 0.5)
		end
		self.TargetBarColor = self.OriginalBarColor
	end
	self.BorderColor = bVGUI.DarkenColor(self.TargetBarColor, 0.4)
end
function PANEL:GetDisabled()
	return self.Disabled
end

function PANEL:SetDrawBorder(draw_border)
	self.DrawBorder = draw_border
	if (draw_border == false) then
		self:DockPadding(0,0,0,0)
	else
		self:DockPadding(0,0,0,5)
	end
end
function PANEL:GetDrawBorder()
	return self.DrawBorder
end

function PANEL:SetTooltip(tooltip)
	self.Tooltip = tooltip
	self.Tooltip.VGUI_Element = self
end
function PANEL:RemoveTooltip()
	if (IsValid(self.Tooltip)) then
		bVGUI.DestroyTooltip()
	end
	self.Tooltip = nil
end

function PANEL:SetSound(sound_name)
	self.ButtonSound = sound_name
end

derma.DefineControl("bVGUI.Button", nil, PANEL, "DPanel")

local PANEL = {}

function PANEL:Init()
	self:SetTall(30)
	self.Button = vgui.Create("bVGUI.Button", self)
end

function PANEL:PerformLayout()
	self.Button:Center()
end

derma.DefineControl("bVGUI.ButtonContainer", nil, PANEL, "bVGUI.BlankPanel")