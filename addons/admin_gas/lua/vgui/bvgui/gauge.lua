--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/gauge.lua

--]]

local PANEL = {}

function PANEL:Init()
	self.Color = Color(192,57,43)
	self.Progress = 0
	self.ProgressAngle = 0

	self.ProgressCircle = GAS_NewCircle(CIRCLE_OUTLINED)
	self.ProgressCircle:SetAngles(180,360)
	self.ProgressCircle:SetThickness(20)
	self.ProgressCircle:SetVertices(64)

	self.ProgressBackgroundCircle = GAS_NewCircle(CIRCLE_OUTLINED)
	self.ProgressBackgroundCircle:SetAngles(180,360)
	self.ProgressBackgroundCircle:SetThickness(20)
	self.ProgressBackgroundCircle:SetVertices(64)

	self.BackgroundCircle = GAS_NewCircle(CIRCLE_FILLED)
	self.BackgroundCircle:SetAngles(180,360)
	self.BackgroundCircle:SetVertices(64)

	self.Text = vgui.Create("DLabel", self)
	self.Text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 18))
	self.Text:SetTextColor(COLOR_WHITE)
	self.Text:SetText("")

	self.SubText = vgui.Create("DLabel", self)
	self.SubText:SetVisible(false)
	self.SubText:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
	self.SubText:SetTextColor(COLOR_WHITE)
	self.SubText:SetText("")
end

function PANEL:SetColor(col_from, col_to)
	if (IsColor(col_from) and col_to == nil) then
		self.Color = col_from
		self.ColorFrom = nil
		self.ColorTo = nil
	elseif (IsColor(col_from) and IsColor(col_to)) then
		self.Color = table.Copy(col_from)
		self.ColorFrom = col_from
		self.ColorTo = col_to
	end
end

function PANEL:SetProgress(progress)
	self.Progress = math.Clamp(progress, 0, 100)
end

function PANEL:SetText(txt)
	self.Text:SetText(txt)
end

function PANEL:SetSubText(txt)
	if (txt == nil or #txt == 0) then
		self.SubText:SetVisible(false)
	else
		self.SubText:SetVisible(true)
		self.SubText:SetText(txt)
	end
end

function PANEL:PerformLayout(w, h)
	self.Text:SizeToContents()

	if (self.SubText:IsVisible()) then
		self.SubText:SizeToContents()

		self.Text:SetPos((w - self.Text:GetWide()) / 2, ((w - self.Text:GetTall()) / 2) - 20 - (self.SubText:GetTall() / 2))
		self.SubText:SetPos((w - self.SubText:GetWide()) / 2, ((w - self.Text:GetTall()) / 2) - 20 + (self.Text:GetTall() / 2))
	else
		self.Text:SetPos((w - self.Text:GetWide()) / 2, ((w - self.Text:GetTall()) / 2) - 20)
	end
end

function PANEL:Paint(w,h)
	draw.NoTexture()

	local r = w / 2

	surface.SetDrawColor(45,45,45,255)
	self.ProgressBackgroundCircle:SetPos(w / 2, w / 2)
	self.ProgressBackgroundCircle:SetRadius(r)
	self.ProgressBackgroundCircle()

	local progress_frac = (self.Progress / 100)
	if (self.ColorFrom and self.ColorTo) then
		self.Color.r = Lerp(0.05, self.Color.r, self.ColorFrom.r + ((self.ColorTo.r - self.ColorFrom.r) * progress_frac))
		self.Color.g = Lerp(0.05, self.Color.g, self.ColorFrom.g + ((self.ColorTo.g - self.ColorFrom.g) * progress_frac))
		self.Color.b = Lerp(0.05, self.Color.b, self.ColorFrom.b + ((self.ColorTo.b - self.ColorFrom.b) * progress_frac))
	end
	self.ProgressAngle = Lerp(0.05, self.ProgressAngle, progress_frac * 180)

	surface.SetDrawColor(self.Color)
	self.ProgressCircle:SetAngles(180, 180 + self.ProgressAngle)
	self.ProgressCircle:SetPos(w / 2, w / 2)
	self.ProgressCircle:SetRadius(r)
	self.ProgressCircle()

	surface.SetDrawColor(60,60,60,255)
	self.BackgroundCircle:SetPos(w / 2, w / 2)
	self.BackgroundCircle:SetRadius(r - 20)
	self.BackgroundCircle()
end

derma.DefineControl("bVGUI.Gauge", nil, PANEL, "DPanel")