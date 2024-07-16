--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/tooltip.lua

--]]

local bg_color = Color(43,48,58,255)

local PANEL = {}

function PANEL:Init()
	self:SetDrawOnTop(true)

	self.Label = vgui.Create("DLabel", self)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.Label:SetText("Tooltip")
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetContentAlignment(5)
	self.Label:SetWrap(true)

	self.Arrow = {
		{x = 0, y = 0},
		{x = 0, y = 0},
		{x = 0, y = 0}
	}
end

function PANEL:Paint(w,h)
	draw.RoundedBox(4, 0, 0, w, h, self.BackgroundColor or bg_color)
	surface.DisableClipping(true)

	surface.SetDrawColor(self.BackgroundColor or bg_color)
	draw.NoTexture()

	self.Arrow[1].x = w / 2 - 7
	self.Arrow[1].y = h

	self.Arrow[2].x = w / 2 + 7
	self.Arrow[2].y = h

	self.Arrow[3].x = w / 2
	self.Arrow[3].y = h + 7

	surface.DrawPoly(self.Arrow)

	surface.DisableClipping(false)
end

function PANEL:Think()
	local x,y = self.Label:GetSize()
	self:SetSize(x + 15, y + 7)
	self.Label:Center()
	local x,y = gui.MousePos()
	self:SetPos(x - self:GetWide() / 2, y - self:GetTall() - 14 - 5)

	if (not system.HasFocus()) then
		self:Remove()
	elseif (self.VGUI_Element) then
		if (not IsValid(self.VGUI_Element)) then
			self:Remove()
		elseif (vgui.GetHoveredPanel() ~= self.VGUI_Element) then
			if (self.HoverFrameNumber) then
				if (FrameNumber() > self.HoverFrameNumber) then
					self:Remove()
				end
			else
				self.HoverFrameNumber = FrameNumber() + 1
			end
		end
	end
end

function PANEL:SetText(text)
	self.Label:SetText(text)
	self.Label:SetWrap(false)
	self.Label:SizeToContentsX()
	if (self.Label:GetWide() >= 200) then
		self.Label:SetWide(200)
		self.Label:SetWrap(true)
		self.Label:SetAutoStretchVertical(true)
	end
end
function PANEL:GetText()
	return self.Label:GetText()
end

function PANEL:SetTextColor(col)
	self.Label:SetTextColor(col)
end
function PANEL:GetTextColor()
	return self.Label:GetTextColor()
end

function PANEL:SetBackgroundColor(col)
	self.BackgroundColor = col
end
function PANEL:GetBackgroundColor()
	return self.BackgroundColor
end

function PANEL:SetVGUIElement(elem)
	self.VGUI_Element = elem
end
function PANEL:GetVGUIElement()
	return self.VGUI_Element
end

derma.DefineControl("bVGUI.Tooltip", nil, PANEL, "DPanel")

bVGUI.CreateTooltip = function(options)
	if (IsValid(bVGUI.Tooltip)) then
		if (bVGUI.Tooltip.Closing ~= true) then
			bVGUI.Tooltip:Remove()
		end
	end

	bVGUI.Tooltip = vgui.Create("bVGUI.Tooltip")
	bVGUI.Tooltip:SetVGUIElement(options.VGUI_Element)
	bVGUI.Tooltip:SetText(options.Text)
	bVGUI.Tooltip:SetTextColor(options.TextColor or bVGUI.COLOR_WHITE)
	bVGUI.Tooltip:SetBackgroundColor(options.BackgroundColor or bg_color)
end
bVGUI.DestroyTooltip = function()
	if (IsValid(bVGUI.Tooltip)) then
		if (bVGUI.Tooltip.Closing ~= true) then
			bVGUI.Tooltip:Remove()
		end
	end
end

bVGUI.AttachTooltip = function(pnl, options)
	pnl:SetMouseInputEnabled(true)
	options.VGUI_Element = pnl
	if (pnl.bVGUI_TooltipOptions) then
		pnl.bVGUI_TooltipOptions = options
		return
	else
		pnl.bVGUI_TooltipOptions = options
	end

	pnl.bVGUI_TOOLTIP_OLD_CURSOR_ENTER = pnl.bVGUI_TOOLTIP_OLD_CURSOR_ENTER or pnl.OnCursorEntered
	pnl.bVGUI_TOOLTIP_OLD_CURSOR_EXIT = pnl.bVGUI_TOOLTIP_OLD_CURSOR_EXIT or pnl.OnCursorExited
	function pnl:OnCursorEntered(...)
		bVGUI.CreateTooltip(self.bVGUI_TooltipOptions)
		if (self.bVGUI_TOOLTIP_OLD_CURSOR_ENTER) then self.bVGUI_TOOLTIP_OLD_CURSOR_ENTER(self, ...) end
	end
	function pnl:OnCursorExited(...)
		bVGUI.DestroyTooltip()
		if (self.bVGUI_TOOLTIP_OLD_CURSOR_EXIT) then self.bVGUI_TOOLTIP_OLD_CURSOR_EXIT(self, ...) end
	end
end

bVGUI.UnattachTooltip = function(pnl)
	pnl.bVGUI_TooltipOptions = nil
	pnl.OnCursorEntered = pnl.bVGUI_TOOLTIP_OLD_CURSOR_ENTER
	pnl.OnCursorExited = pnl.bVGUI_TOOLTIP_OLD_CURSOR_EXIT
end