--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/progressbar.lua

--]]

local PANEL = {}

function PANEL:Init()
	self.Min = 0
	self.Max = 0
	self.Progress = 0
	self.Fraction = 0
	self.Decimals = false

	self.Text = vgui.Create("DLabel", self)
	self.Text:SetText("")
	self.Text:SetTextColor(bVGUI.COLOR_WHITE)
	self.Text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "BOLD", 14))

	self.ProgressBar_X = -1
	self.ProgressBar_Col = -1
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(bVGUI.COLOR_SLATE)
	surface.DrawRect(0,0,w,h)

	--surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
	--surface.DrawTexturedRect(0,0,w,h)

	local w_frac = self.Fraction * w
	if (self.ProgressBar_X == -1) then
		self.ProgressBar_X = w_frac
	else
		self.ProgressBar_X = Lerp(0.05, self.ProgressBar_X, w_frac)
	end

	local frac_255 = self.Fraction * 255
	if (self.ProgressBar_Col == -1) then
		self.ProgressBar_Col = frac_255
	else
		self.ProgressBar_Col = Lerp(0.05, self.ProgressBar_Col, frac_255)
	end

	surface.SetDrawColor(255 - self.ProgressBar_Col, self.ProgressBar_Col, 0, 255)
	surface.DrawRect(0, 0, self.ProgressBar_X, h)

	--surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
	--surface.DrawTexturedRect(0, 0, self.ProgressBar_X, h)

	surface.SetDrawColor(bVGUI.COLOR_BLACK)
	surface.DrawOutlinedRect(0,0,w,h)
end

function PANEL:Think()
	self.Fraction = (self.Progress - self.Min) / (self.Max - self.Min)
	if (self.Decimals == false and tostring(self.Fraction * 100):find("%.")) then
		self.Decimals = true
	end

	if (self.Fraction > 0) then
		if (self.Decimals) then
			local percentage = math.Round(self.Fraction * 100, 1)
			if (percentage % 1 == 0 and self.Fraction ~= 1) then
				percentage = percentage .. ".0"
			end
			self.Text:SetText(percentage .. "%")
		else
			self.Text:SetText(math.Round(self.Fraction * 100, 1) .. "%")
		end
		self.Text:SizeToContents()
		self.Text:Center()
	elseif (self.Text:GetText() ~= "") then
		self.Text:SetText("")
	end
end

derma.DefineControl("bVGUI.ProgressBar", nil, PANEL, "DPanel")