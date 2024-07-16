--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/option_selector.lua

--]]

local PANEL = {}

function PANEL:Init()
	self.Color = bVGUI.BUTTON_COLOR_BLUE
	self.DarkColor = bVGUI.DarkenColor(self.Color, 0.5)

	self.SelectedX = bVGUI.Lerp(0,0,.5)
	self.SelectedWidth = bVGUI.Lerp(0,0,.5)

	self.ButtonLabels = {}
	self.TotalWidth = 0
	self.ButtonCount = 0
	self.Selected = 1

	self.ClickableArea = vgui.Create("bVGUI.BlankPanel", self)
	self.ClickableArea:SetMouseInputEnabled(true)
	self.ClickableArea:SetCursor("hand")
	function self.ClickableArea:OnMouseReleased(m)
		self:GetParent():OnMouseReleased(m)
	end
end

function PANEL:SetColor(col)
	self.Color = col
	self.DarkColor = bVGUI.DarkenColor(self.Color, 0.5)
end

local grey_col = Color(150,150,150)
local dark_grey_col = bVGUI.DarkenColor(grey_col, 0.5)
function PANEL:Paint(w,h)
	if (IsValid(self.HelpLabel)) then
		h = 26
	end

	self.SelectedX:DoLerp()
	self.SelectedWidth:DoLerp()

	draw.RoundedBoxEx(4,0,0,self.TotalWidth,h - 4,grey_col,true,true)
	draw.RoundedBoxEx(4,0,h - 4,self.TotalWidth,4,grey_col,false,false,true,true)

	if (self.LerpedColor == nil) then
		self.LerpedColor = Color(self.Color.r, self.Color.g, self.Color.b)
	else
		self.LerpedColor.r = Lerp(0.05, self.LerpedColor.r, self.Color.r)
		self.LerpedColor.g = Lerp(0.05, self.LerpedColor.g, self.Color.g)
		self.LerpedColor.b = Lerp(0.05, self.LerpedColor.b, self.Color.b)
	end

	if (self.LerpDarkColor == nil) then
		self.LerpDarkColor = Color(self.DarkColor.r, self.DarkColor.g, self.DarkColor.b)
	else
		self.LerpDarkColor.r = Lerp(0.05, self.LerpDarkColor.r, self.DarkColor.r)
		self.LerpDarkColor.g = Lerp(0.05, self.LerpDarkColor.g, self.DarkColor.g)
		self.LerpDarkColor.b = Lerp(0.05, self.LerpDarkColor.b, self.DarkColor.b)
	end

	draw.RoundedBoxEx(4, self.SelectedX:GetValue(), 0, self.SelectedWidth:GetValue(), h, self.LerpedColor, self.Selected == 1, self.Selected == self.ButtonCount, false, false)

	surface.SetDrawColor(dark_grey_col)
	surface.DrawRect(0,h - 4,self.TotalWidth,4)

	surface.SetDrawColor(self.LerpDarkColor)
	surface.DrawRect(self.SelectedX:GetValue(), h - 4, self.SelectedWidth:GetValue(), 4)
end

function PANEL:AddButton(text, col)
	self.ButtonCount = self.ButtonCount + 1
	local btn = vgui.Create("DLabel", self)
	btn.BtnIndex = table.insert(self.ButtonLabels, btn)
	btn.BtnColor = col
	btn:SetTextColor(bVGUI.COLOR_WHITE)
	btn:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
	btn:SetContentAlignment(5)
	btn:SetText(text)
	self:InvalidateLayout(true)
end

function PANEL:PerformLayout(w,h)
	local x = 5
	for i,v in ipairs(self.ButtonLabels) do
		if (i == self.Selected) then
			self.SelectedX:SetTo((v:GetPos()) - 5)
			self.SelectedWidth:SetTo(v:GetWide() + 10)
		end
		v:SizeToContentsX()
		if (IsValid(self.HelpLabel)) then
			v:SetTall(26 - 4)
		else
			v:SetTall(h - 4)
		end
		v:AlignLeft(x)
		x = x + v:GetWide() + 10
	end
	self.TotalWidth = x - 5
	if (IsValid(self.Label)) then
		self.Label:AlignLeft(self.TotalWidth + 10)
	end
	if (IsValid(self.HelpLabel)) then
		local h = self.HelpLabel:GetTall() + 30
		if (self:GetTall() ~= h) then
			self:SetTall(h)
		end
	end
	self.ClickableArea:SetSize(self.TotalWidth, 26)
end

function PANEL:SetSelectedButton(index)
	self.Selected = index
	self:InvalidateLayout(true)
end
function PANEL:GetSelectedButton()
	return self.ButtonLabels[self.Selected]:GetText(), self.ButtonLabels[self.Selected]
end

function PANEL:OnMouseReleased(m)
	if (m == MOUSE_LEFT) then
		local x,y = self:ScreenToLocal(gui.MousePos())
		for i,v in ipairs(self.ButtonLabels) do
			local btn_x, btn_y, btn_w = v:GetBounds()
			if (y <= 25 and x >= btn_x - 5 and x <= btn_x + btn_w + 5) then
				self:SetSelectedButton(i)
				if (v.BtnColor ~= nil) then
					self:SetColor(v.BtnColor)
				end
				if (self.OnChange) then
					self:OnChange()
				end
				break
			end
		end
	end
end

function PANEL:SetText(text)
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetContentAlignment(4)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText(text)
	self.Label:SizeToContentsX()
	self.Label:SetTall(21)
end

function PANEL:SetHelpText(text)
	self.HelpLabel = vgui.Create("DLabel", self)
	self.HelpLabel:SetContentAlignment(4)
	self.HelpLabel:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.HelpLabel:SetTextColor(bVGUI.COLOR_WHITE)
	self.HelpLabel:SetText(text)
	self.HelpLabel:SetWide(500)
	self.HelpLabel:SetWrap(true)
	self.HelpLabel:SetAutoStretchVertical(true)
	self.HelpLabel:AlignTop(30)
	self.HelpLabel:SetTextColor(Color(200,200,200))
	function self.HelpLabel:PerformLayout()
		self:InvalidateParent(true)
	end
end

function PANEL:GetValue()
	return self.ButtonLabels[self.Selected]:GetText()
end
function PANEL:SetValue(val)
	for i,v in ipairs(self.ButtonLabels) do
		if (v:GetText() == val) then
			self:SetSelectedButton(i)
			self.SelectedX:SetValue(self.SelectedX.to)
			self.SelectedWidth:SetValue(self.SelectedWidth.to)
			break
		end
	end
end

function PANEL:SizeToButtons()
	local w = 0
	for i,v in ipairs(self.ButtonLabels) do
		w = w + v:GetWide() + 10
	end
	self:SetWide(w)
end

derma.DefineControl("bVGUI.OptionSelector", nil, PANEL, "bVGUI.BlankPanel")