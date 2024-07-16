--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/loadingpanel.lua

--]]

local PANEL = {}

function PANEL:Init()
	self.LoadingPaint = self.Paint
end

function PANEL:Paint(w,h)
	if (not self.EndTime or SysTime() >= self.EndTime) then
		self.EndTime = SysTime() + 2
	end
	self.Rotation = ((self.EndTime - SysTime()) / 2) * 360

	if (self.Loading == true) then
		local size = 24
		surface.SetDrawColor(bVGUI.COLOR_WHITE)
		surface.SetMaterial(bVGUI.MATERIAL_LOADING_ICON)
		surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, math.Round(self.Rotation))
	end
end

function PANEL:SetLoading(is_loading)
	self.Loading = is_loading
end
function PANEL:GetLoading()
	return self.Loading
end

derma.DefineControl("bVGUI.LoadingPanel", nil, PANEL, "DPanel")
derma.DefineControl("bVGUI.LoadingScrollPanel", nil, table.Copy(PANEL), "bVGUI.ScrollPanel")