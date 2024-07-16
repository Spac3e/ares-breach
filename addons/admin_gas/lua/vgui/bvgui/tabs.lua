--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/tabs.lua

--]]

--/// bVGUI.Tabs ///--

local PANEL = {}

function PANEL:Init()
	self.Tabs = {}
	self.TabPages = {}

	self.EnabledTabs = {}
	self.EnabledTabPages = {}

	self.SelectedTab = 0

	self.BarX = bVGUI.Lerp(0,0,4)
	self.BarColor = bVGUI.LerpColor(bVGUI.COLOR_BLACK,bVGUI.COLOR_BLACK,4)
end

function PANEL:OnRemove()
	for _,v in pairs(self.TabPages) do
		v:Remove()
	end
end

function PANEL:CalculateEnabledTabs()
	self.EnabledTabs = {}
	self.EnabledTabPages = {}
	for i,v in pairs(self.Tabs) do
		if (v:GetEnabled()) then
			v.EnabledTabIndex = table.insert(self.EnabledTabs, v)
			self.TabPages[i].EnabledTabIndex = table.insert(self.EnabledTabPages, self.TabPages[i])
		end
	end
end

function PANEL:AddTab(tab_name, tab_color, enabled)
	local tab_index = #self.Tabs + 1
	local tab = vgui.Create("bVGUI.Tab", self)
	self.Tabs[tab_index] = tab
	tab.TabIndex = tab_index
	tab:SetColor(tab_color)
	tab:SetText(tab_name)

	local tab_page = vgui.Create("bVGUI.TabPage", self:GetParent())
	self.TabPages[tab_index] = tab_page
	tab_page:SetTab(tab)
	tab_page:SetTabs(self)

	tab:SetTabPage(tab_page)
	tab:SetEnabled(enabled ~= false)
	if (self.SelectedTab == 0 and enabled ~= false) then
		self.SelectedTab = tab_index
		self.BarColor:SetColor(tab:GetColor())
	end

	return tab_page, tab
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(bVGUI.COLOR_SLATE)
	surface.DrawRect(0,0,w,h)
end

function PANEL:PaintOver(w,h)
	if (self.SelectedTab > 0) then
		self.BarX:DoLerp()
		self.BarColor:DoLerp()

		surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
		surface.DrawRect(0, h - 3, w, 3)

		surface.SetDrawColor(self.BarColor:GetColor())
		surface.DrawRect(self.BarX:GetValue(), h - 3, self:GetWide() / #self.EnabledTabs, 3)
	end
end

function PANEL:PerformLayout()
	self:CalculateEnabledTabs()

	local tab_width = self:GetWide() / #self.EnabledTabs
	for i,v in ipairs(self.EnabledTabs) do
		v:SetSize(tab_width, self:GetTall())
		local _,y = v:GetPos()
		v:SetPos((i - 1) * tab_width, y)
	end

	if (self.SelectedTab > 0) then
		for i,v in ipairs(self.EnabledTabPages) do
			local _,y = self:GetPos()
			v:SetSize(self:GetWide(), v:GetParent():GetTall() - self:GetTall() - y)
			if (not v.m_AnimList or #v.m_AnimList == 0) then
				v:SetPos((i - self.Tabs[self.SelectedTab].EnabledTabIndex) * self:GetWide() + (self:GetPos()), y + self:GetTall())
			end
		end

		local bar_x = (self.Tabs[self.SelectedTab]:GetPos())
		if (not self.EnabledTabs_Check or self.EnabledTabs_Check ~= #self.EnabledTabs) then
			self.EnabledTabs_Check = #self.EnabledTabs
			self.BarX:SetValue(bar_x)
		end
		if (self.BarX.to ~= bar_x) then
			self.BarX:SetValue(bar_x)
		end
	end
end

function PANEL:SelectTab(tab_index, suppress_click_func)
	local tab = self.Tabs[tab_index]

	local prev_tab = self.SelectedTab
	self.SelectedTab = tab.TabIndex

	self.BarX:SetTo((tab:GetPos()))
	self.BarColor:SetTo(tab:GetColor())

	for i,v in pairs(self.EnabledTabPages) do
		local _,y = v:GetPos()
		v:Stop()
		v:MoveTo((i - self.Tabs[self.SelectedTab].EnabledTabIndex) * v:GetWide() + (self:GetPos()), y, 0.5, 0, -1, function()
			self:InvalidateLayout(true)
			v:InvalidateChildren(true)
		end)
	end

	if (not suppress_click_func and tab.ClickFunction) then
		tab:GetTabPage().ExecClickFunction = tab.ClickFunction
		timer.Simple(0, function()
			if (self.OnTabSelected and prev_tab ~= nil) then
				self:OnTabSelected(self.Tabs[prev_tab], tab)
			end
		end)
	else
		if (self.OnTabSelected and prev_tab ~= nil) then
			self:OnTabSelected(self.Tabs[prev_tab], tab)
		end
	end
end

derma.DefineControl("bVGUI.Tabs", nil, PANEL, "DPanel")

--/// bVGUI.Tab ///--

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self.Label = vgui.Create("DLabel", self)
	self.Label:Dock(FILL)
	self.Label:SetContentAlignment(5)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText("Tab")
end

function PANEL:OnMouseReleased()
	self:GetParent():SelectTab(self.TabIndex)
end

function PANEL:SetEnabled(enabled)
	self:SetVisible(enabled)
	self:GetTabPage():SetVisible(enabled)
	if (enabled ~= self.Enabled) then
		self.Enabled = enabled
		self:GetParent():InvalidateLayout(true)
	else
		self.Enabled = enabled
	end
end
function PANEL:GetEnabled()
	return self.Enabled
end

function PANEL:SetColor(color)
	self.Color = color
end
function PANEL:GetColor()
	return self.Color
end

function PANEL:SetText(name)
	self.Name = name
	self.Label:SetText(self.Name)
end
function PANEL:GetText()
	return self.Name
end

function PANEL:SetTabPage(tabpage)
	self.TabPage = tabpage
end
function PANEL:GetTabPage()
	return self.TabPage
end

function PANEL:SetFunction(func)
	self.ClickFunction = func
end
function PANEL:GetFunction()
	return self.ClickFunction
end

function PANEL:Paint(w,h)
	if (self:GetParent().SelectedTab == self.TabIndex) then
		surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
		surface.DrawTexturedRect(0,0,w,h)
	end
end

derma.DefineControl("bVGUI.Tab", nil, PANEL, "DPanel")

--/// bVGUI.TabPage ///--

local PANEL = {}

function PANEL:SetTab(tab)
	self.MyTab = tab
end
function PANEL:GetTab()
	return self.MyTab
end

function PANEL:SetTabs(tabs)
	self.MyTabs = tabs
end
function PANEL:GetTabs()
	return self.MyTabs
end

function PANEL:Think()
	if (self.ExecClickFunction) then
		self.ExecClickFunction(self:GetTab())
		self.ExecClickFunction = nil
	end
end

derma.DefineControl("bVGUI.TabPage", nil, PANEL, "bVGUI.BlankPanel")