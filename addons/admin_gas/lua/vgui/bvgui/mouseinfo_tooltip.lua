--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/mouseinfo_tooltip.lua

--]]

if (IsValid(bVGUI.MouseInfoTooltip)) then
	if (IsValid(bVGUI.MouseInfoTooltip.Label)) then
		bVGUI.PlayerTooltip.Label:Remove()
	end
end

bVGUI.MouseInfoTooltip = {}
bVGUI.MouseInfoTooltip.Create = function(text)
	if (IsValid(bVGUI.MouseInfoTooltip.Label)) then
		bVGUI.MouseInfoTooltip.Label:Remove()
	end
	bVGUI.MouseInfoTooltip.Label = vgui.Create("DLabel")
	bVGUI.MouseInfoTooltip.Label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "BOLD", 12))
	bVGUI.MouseInfoTooltip.Label:SetText(text)
	bVGUI.MouseInfoTooltip.Label:SizeToContents()
	bVGUI.MouseInfoTooltip.Label:SetContentAlignment(5)

	bVGUI.MouseInfoTooltip.Label.CurrentTextColor = Color(255, 255, 255, 255)
	bVGUI.MouseInfoTooltip.Label.CurrentY = 15

	bVGUI.MouseInfoTooltip.Label:SetTextColor(bVGUI.MouseInfoTooltip.Label.CurrentTextColor)
	bVGUI.MouseInfoTooltip.Label:SetPos(gui.MouseX(), bVGUI.MouseInfoTooltip.Label.CurrentY)

	bVGUI.MouseInfoTooltip.Label:SetZPos(32767)
	bVGUI.MouseInfoTooltip.Label:SetMouseInputEnabled(false)
	bVGUI.MouseInfoTooltip.Label:SetKeyBoardInputEnabled(false)
	bVGUI.MouseInfoTooltip.Label:MakePopup()
	bVGUI.MouseInfoTooltip.Label:MoveToFront()

	bVGUI.MouseInfoTooltip.Label.SysTime = SysTime()
	bVGUI.MouseInfoTooltip.Label.SysTimeEnd = SysTime() + 5
	function bVGUI.MouseInfoTooltip.Label:Think()
		local time_frac = math.TimeFraction(self.SysTime, self.SysTimeEnd, SysTime())
		self.CurrentTextColor.a = Lerp(time_frac, self.CurrentTextColor.a, 0)
		self.CurrentY = Lerp(time_frac, self.CurrentY, 20)

		self:SetTextColor(self.CurrentTextColor)
		self:SetPos(gui.MouseX() - (self:GetWide() / 2) + 5, gui.MouseY() + self:GetTall() + self.CurrentY)

		if (self.CurrentTextColor.a <= 1) then
			self:Remove()
		end
	end
end