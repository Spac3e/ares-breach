--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/infobar.lua

--]]

bVGUI.INFOBAR_COLOR_GREY = Color(62, 62, 62)
bVGUI.INFOBAR_COLOR_PURPLE = Color(104, 0, 160)

local PANEL = {}

function PANEL:Init()
	self:SetTall(30)
	self:SetMouseInputEnabled(true)
	self:DockPadding(5,0,5,4)

	self.OriginalBarColor = bVGUI.INFOBAR_COLOR_GREY
	self.TargetBarColor = self.OriginalBarColor
	self.BorderColor = bVGUI.DarkenColor(self.OriginalBarColor, 0.2)

	self.Label = vgui.Create("DLabel", self)
	self.Label:Dock(FILL)
	self.Label:SetContentAlignment(5)
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
end

function PANEL:SetText(text)
	self.Text = text
	self.Label:SetText(text)
end
function PANEL:GetText()
	return self.Text
end

function PANEL:SetColor(col_enum)
	self.OriginalBarColor = col_enum
	self.TargetBarColor = self.OriginalBarColor
	self.BorderColor = bVGUI.DarkenColor(self.OriginalBarColor, 0.2)
	self.Label:SetTextColor(bVGUI.TextColorContrast(col_enum))
end

function PANEL:OnCursorEntered()
	if (self.AllowCopy) then
		self.TargetBarColor = bVGUI.LightenColor(self.OriginalBarColor, 0.2)
		self.ColorInterpolation = bVGUI.LerpColor(self.OriginalBarColor, self.TargetBarColor, 0.5)
	end
end
function PANEL:OnCursorExited()
	if (self.AllowCopy) then
		self.ColorInterpolation = bVGUI.LerpColor(self.TargetBarColor, self.OriginalBarColor, 0.5)
		self.TargetBarColor = self.OriginalBarColor
	end
end
function PANEL:OnMousePressed()
	if (self.AllowCopy) then
		self.ColorInterpolation = nil
		self.TargetBarColor = self.BorderColor
		self:DockPadding(5,0,5,0)
		self:InvalidateLayout(true)
	end
end
function PANEL:OnMouseReleased()
	if (self.AllowCopy) then
		if (GAS) then
			GAS:SetClipboardText(self:GetText())
		else
			SetClipboardText(self:GetText())
			bVGUI.MouseInfoTooltip.Create(bVGUI.L("copied"))
		end

		if (self:IsHovered()) then
			self.TargetBarColor = bVGUI.LightenColor(self.OriginalBarColor, 0.2)
		else
			self.TargetBarColor = self.OriginalBarColor
		end
		self:DockPadding(5,0,5,4)
		self:InvalidateLayout(true)
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

function PANEL:SetDrawBorder(draw_border)
	self.DrawBorder = draw_border
	if (draw_border == false) then
		self:DockPadding(0,0,0,0)
	else
		self:DockPadding(0,0,0,4)
	end
end
function PANEL:GetDrawBorder()
	return self.DrawBorder
end

function PANEL:AllowCopy()
	self.AllowCopy = true
	self:SetCursor("hand")
end

derma.DefineControl("bVGUI.InfoBar", nil, PANEL, "DPanel")