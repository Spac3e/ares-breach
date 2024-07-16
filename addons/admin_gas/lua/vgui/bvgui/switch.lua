--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/switch.lua

--]]

local PANEL = {}

local on_color  = Color(76,218,100)
local off_color = Color(216,75,75)
local switch_width = 40
local switch_height = 20
local label_margin = 7

local function Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function PANEL:Init()
	self.Active = false
	self.ColorInterpolation = bVGUI.LerpColor(off_color, off_color, 1)
	self.SwitchInterpolation = bVGUI.Lerp(switch_height / 2, switch_height / 2, 1)

	self.Label = vgui.Create("DLabel", self)
	self.Label:SetContentAlignment(4)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self:SetText("Switch")

	self.ClickableArea = vgui.Create("bVGUI.BlankPanel", self)
	self.ClickableArea:SetMouseInputEnabled(true)
	self.ClickableArea:SetCursor("hand")
	function self.ClickableArea:OnMouseReleased(m)
		if (m ~= MOUSE_LEFT) then return end
		local checked = not self:GetParent().Active
		self:GetParent():SetChecked(checked, true)
		if (GAS) then
			if (checked) then
				GAS:PlaySound("btn_on")
			else
				GAS:PlaySound("btn_off")
			end
		end
		if (self:GetParent().OnChange) then
			self:GetParent():OnChange()
		end
	end
end

function PANEL:PerformLayout()
	self.ClickableArea:SetSize(switch_width + label_margin + self.Label:GetWide() + label_margin, switch_height)
end

function PANEL:SetText(text)
	self.Text = text

	self.Label:SetText(text)
	self.Label:SizeToContents()
	self.Label:AlignLeft(switch_width + label_margin)
	self.Label:SizeToContents()

	self:SetSize(switch_width + label_margin + self.Label:GetWide(), switch_height)

	self.Label:CenterVertical()
end
function PANEL:GetText(text)
	return self.Text
end

function PANEL:Paint(w)
	self.ColorInterpolation:DoLerp()
	self.SwitchInterpolation:DoLerp()

	surface.SetDrawColor(self.ColorInterpolation:GetColor())
	draw.NoTexture()
	Circle(switch_height / 2, switch_height / 2, switch_height / 2,20)
	Circle(switch_width - switch_height / 2, switch_height / 2, switch_height / 2,20)
	surface.DrawRect(switch_height / 2, 0, switch_width - switch_height, switch_height)

	surface.SetDrawColor(255, 255, 255)
	Circle(self.SwitchInterpolation:GetValue(), switch_height / 2, switch_height / 2 - 2,20)
end

function PANEL:SetChecked(active, animate)
	if (self.Disabled) then return end
	self.Active = active
	local from
	local to
	if (active) then
		from = switch_height / 2
		to = switch_width - (switch_height / 2)
	else
		from = switch_width - (switch_height / 2)
		to = switch_height / 2
	end
	if (animate) then
		self.SwitchInterpolation = bVGUI.Lerp(from, to, 0.5)
		if (active) then
			self.ColorInterpolation = bVGUI.LerpColor(off_color, on_color, 0.5)
		else
			self.ColorInterpolation = bVGUI.LerpColor(on_color, off_color, 0.5)
		end
	else
		self.SwitchInterpolation = bVGUI.Lerp(to, to, 0.5)
		if (active) then
			self.ColorInterpolation = bVGUI.LerpColor(on_color, on_color, 0.5)
		else
			self.ColorInterpolation = bVGUI.LerpColor(off_color, off_color, 0.5)
		end
	end
end
function PANEL:GetChecked()
	return self.Active
end

function PANEL:SetHelpText(text)
	self.HelpLabel = vgui.Create("DLabel", self)
	self.HelpLabel:SetTextColor(Color(200,200,200))
	self.HelpLabel:SetAutoStretchVertical(true)
	self.HelpLabel:SetWrap(true)
	self.HelpLabel:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	self.HelpLabel:AlignTop(switch_height + 10)
	self.HelpLabel:SetText(text)
	function self.HelpLabel:PerformLayout()
		local w = math.min(500, self:GetParent():GetWide())
		if (self:GetWide() ~= w) then
			self:SetWide(w)
		end
		self:GetParent():SetSize(switch_width + label_margin + self:GetParent().Label:GetWide(), switch_height + 10 + self:GetTall())
	end
end

function PANEL:SetDisabled(disabled)
	self.Disabled = disabled
	if (self.Disabled) then
		self.ColorInterpolation:SetColor(Color(165,165,165))
		self.Label:SetTextColor(Color(180,180,180))
		self.ClickableArea:SetCursor("no")
	else
		self.ClickableArea:SetCursor("hand")
		self.Label:SetTextColor(bVGUI.COLOR_WHITE)
		if (self:GetChecked()) then
			self.ColorInterpolation:SetColor(on_color)
		else
			self.ColorInterpolation:SetColor(off_color)
		end
	end
end
function PANEL:GetDisabled()
	return self.Disabled
end

derma.DefineControl("bVGUI.Switch", nil, PANEL, "bVGUI.BlankPanel")