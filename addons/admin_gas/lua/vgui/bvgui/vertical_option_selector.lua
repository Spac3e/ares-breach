--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/vertical_option_selector.lua

--]]

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self.Buttons = {}
	self.Color = bVGUI.BUTTON_COLOR_BLUE
	self.BorderColor = bVGUI.DarkenColor(self.Color, 0.4)

	self.SelectedButton = 1
end

function PANEL:SetColor(col)
	self.Color = col
	self.BorderColor = bVGUI.DarkenColor(self.Color, 0.4)
end

function PANEL:SelectButton(index)
	self.SelectedButton = index
end

function PANEL:AddButton(text, color)
	local label = vgui.Create("DLabel", self)
	label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	label:SetContentAlignment(5)
	label:SetTextColor(bVGUI.COLOR_WHITE)
	label:SetText(text)
	label.BtnColor = color
	label.BtnBorderColor = bVGUI.DarkenColor(color, 0.4)
	table.insert(self.Buttons, label)

	self:SizeButtons()
end

local grey_col = Color(150,150,150)
local dark_grey_col = bVGUI.DarkenColor(grey_col, 0.4)
function PANEL:Paint(w,h)
	draw.RoundedBox(4, 0, 0, w, h, dark_grey_col)
	draw.RoundedBoxEx(4, 0, 0, w, h - 4, grey_col, true, true)

	for i,v in ipairs(self.Buttons) do
		draw.RoundedBox(4, 0, (i * (h / #self.Buttons)) - 4, w, 4, dark_grey_col)
	end

	if (IsValid(self.Buttons[self.SelectedButton])) then
		local btn = self.Buttons[self.SelectedButton]

		if (self.LerpY == nil) then
			self.LerpY = (self.SelectedButton - 1) * (h / #self.Buttons)
		else
			self.LerpY = Lerp(0.05, self.LerpY, (self.SelectedButton - 1) * (h / #self.Buttons))
		end

		if (self.LerpBorderColor == nil) then
			self.LerpBorderColor = Color(btn.BtnBorderColor.r, btn.BtnBorderColor.g, btn.BtnBorderColor.b)
		else
			self.LerpBorderColor.r = Lerp(0.05, self.LerpBorderColor.r, btn.BtnBorderColor.r)
			self.LerpBorderColor.g = Lerp(0.05, self.LerpBorderColor.g, btn.BtnBorderColor.g)
			self.LerpBorderColor.b = Lerp(0.05, self.LerpBorderColor.b, btn.BtnBorderColor.b)
		end

		if (self.LerpColor == nil) then
			self.LerpColor = Color(btn.BtnColor.r, btn.BtnColor.g, btn.BtnColor.b)
		else
			self.LerpColor.r = Lerp(0.05, self.LerpColor.r, btn.BtnColor.r)
			self.LerpColor.g = Lerp(0.05, self.LerpColor.g, btn.BtnColor.g)
			self.LerpColor.b = Lerp(0.05, self.LerpColor.b, btn.BtnColor.b)
		end

		draw.RoundedBoxEx(4, 0, self.LerpY, w, h / #self.Buttons, self.LerpBorderColor, true, true, self.SelectedButton == #self.Buttons, self.SelectedButton == #self.Buttons)
		draw.RoundedBoxEx(4, 0, self.LerpY, w, (h / #self.Buttons) - 4, self.LerpColor, self.SelectedButton == 1, self.SelectedButton == 1)
	end
end

function PANEL:SizeButtons()
	local w = 0
	for _,v in ipairs(self.Buttons) do
		v:SizeToContents()
		if (v:GetWide() > w) then
			w = v:GetWide()
		end
	end
	self:SetWide(w + 20)
	for i,v in ipairs(self.Buttons) do
		v:SetWide(w)
	end
end

function PANEL:PerformLayout(w,h)
	for i,v in ipairs(self.Buttons) do
		v:SetSize(w,h / #self.Buttons)
		v:AlignTop((i - 1) * (h / #self.Buttons) - 2)
	end
end

function PANEL:OnMousePressed(m)
	self.MousePressed = m
end
function PANEL:OnMouseReleased(m)
	if (self.MousePressed == m) then
		if (m == MOUSE_LEFT) then
			local x,y = self:ScreenToLocal(gui.MousePos())
			self.SelectedButton = 1 + math.floor((y / self:GetTall()) * #self.Buttons)
			local btn = self.Buttons[self.SelectedButton]
			if (IsValid(btn)) then
				if (self.OptionChanged) then
					self:OptionChanged(btn:GetText())
				end
			end
		end
	end
end

derma.DefineControl("bVGUI.VerticalOptionSelector", nil, PANEL, "bVGUI.BlankPanel")