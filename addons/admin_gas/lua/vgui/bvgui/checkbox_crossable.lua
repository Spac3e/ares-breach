--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/checkbox_crossable.lua

--]]

local PANEL = {}

local checked_mat = Material("vgui/bvgui/checked.png", "smooth")
local crossed_mat = Material("vgui/bvgui/cross.png", "smooth")

function PANEL:Init()
	self.Checked = 0

	self.CheckedOpacity = bVGUI.Lerp(0,0,.5)
	self.CrossedOpacity = bVGUI.Lerp(0,0,.5)
end

function PANEL:OnMouseReleased()
	self.Checked = self.Checked + 1
	if (self.Checked > 2) then self.Checked = 0 end
	if (self.OnChange) then
		self:OnChange()
	end
	self:UpdateOpacities()
	if (GAS) then
		if (self.Checked == 1) then
			GAS:PlaySound("btn_on")
		elseif (self.Checked == 2) then
			GAS:PlaySound("delete")
		else
			GAS:PlaySound("btn_off")
		end
	end
end

function PANEL:SetChecked(checked)
	self.Checked = math.Clamp(checked, 0, 2)
	self:UpdateOpacities()
end

function PANEL:UpdateOpacities()
	if (self.Checked == 1) then
		self.CheckedOpacity:SetTo(255)
	elseif (self.CheckedOpacity.to ~= 0) then
		self.CheckedOpacity:SetTo(0)
	end
	if (self.Checked == 2) then
		self.CrossedOpacity:SetTo(255)
	elseif (self.CrossedOpacity.to ~= 0) then
		self.CrossedOpacity:SetTo(0)
	end
end

local checkbox_bg = Color(47,53,66)
local check_size = 12
function PANEL:Paint(w,h)
	draw.RoundedBox(4, 0, 0, w, h, checkbox_bg)

	self.CheckedOpacity:DoLerp()
	self.CrossedOpacity:DoLerp()

	surface.SetMaterial(checked_mat)
	surface.SetDrawColor(255,255,255,self.CheckedOpacity:GetValue())
	surface.DrawTexturedRect(w / 2 - check_size / 2, h / 2 - check_size / 2, check_size, check_size)

	surface.SetMaterial(crossed_mat)
	surface.SetDrawColor(255,255,255,self.CrossedOpacity:GetValue())
	surface.DrawTexturedRect(w / 2 - check_size / 2, h / 2 - check_size / 2, check_size, check_size)
end

derma.DefineControl("bVGUI.Checkbox_Crossable", nil, PANEL, "bVGUI.Checkbox")