--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/pagination.lua

--]]

local PANEL = {}

local page_btn_font = bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14)
local page_btn_width = 23
local page_btn_padding = 15
local inactive_page_textcolor = Color(175,175,175)

local next_btn_mat = Material("vgui/bvgui/right-arrow.png", "smooth")
local prev_btn_mat = Material("vgui/bvgui/left-arrow.png", "smooth")

function PANEL:LoadingDebounce()
	if (IsValid(self.LoadingPanel)) then
		if (self.LoadingPanel:GetLoading() == true) then
			return true
		end
	end
	return false
end
function PANEL:SetLoadingPanel(loading_panel)
	self.LoadingPanel = loading_panel
end

function PANEL:Init()
	local pagination = self

	self.CurrentPage = 1
	self.Pages = 0

	self.Previous = vgui.Create("bVGUI.BlankPanel", self)
	self.Previous:SetMouseInputEnabled(true)
	self.Previous:SetCursor("hand")
	self.Previous:Dock(LEFT)
	self.Previous.Old_OnMouseReleased = self.Previous.OnMouseReleased
	function self.Previous:OnMouseReleased(m)
		if (self:GetParent().LoadingPanel and self:GetParent():LoadingDebounce() == true) then return end
		if (pagination:GetPage() ~= 1) then
			pagination:SetPage(pagination:GetPage() - 1)
			if (pagination.OnPageSelected) then
				pagination:OnPageSelected(pagination:GetPage())
			end
		end
		if (self.Old_OnMouseReleased) then
			self:Old_OnMouseReleased(m)
		end
	end
	self.Previous.Btn = vgui.Create("DImage", self.Previous)
	self.Previous.Btn:SetSize(16,16)
	self.Previous.Btn:SetMaterial(prev_btn_mat)
	function self.Previous:PerformLayout()
		self.Btn:Center()
	end

	self.PagesContainer = vgui.Create("bVGUI.BlankPanel", self)
	self.PagesContainer:SetMouseInputEnabled(true)
	self.PagesContainer:SetCursor("hand")
	function self.PagesContainer:OnMouseReleased()
		if (self:GetParent().LoadingPanel and self:GetParent():LoadingDebounce() == true) then return end
		if (self.HoveredButton and self.HoveredButton > 0 and (self:GetParent().Infinite == true or self.HoveredButton <= math.min(9, self:GetParent():GetPages()))) then
			if (pagination.DrawPages[self.HoveredButton] == "∞") then
				return
			elseif (pagination.DrawPages[self.HoveredButton] == "..") then
				if (self.HoveredButton == #pagination.DrawPages - 1) then
					if (self:GetParent().Infinite) then
						self:GetParent().Next:OnMouseReleased(MOUSE_LEFT)
						return
					else
						pagination:SetPage(pagination.DrawPages[self.HoveredButton - 1] + 1)
					end
				elseif (self.HoveredButton == 2) then
					if (self:GetParent().Infinite) then
						self:GetParent().Previous:OnMouseReleased(MOUSE_LEFT)
						return
					else
						pagination:SetPage(pagination.DrawPages[self.HoveredButton + 1] - 1)
					end
				end
			else
				pagination:SetPage(pagination.DrawPages[self.HoveredButton])
			end
			if (pagination.OnPageSelected) then
				pagination:OnPageSelected(pagination:GetPage())
			end
		end
	end

	self.Next = vgui.Create("bVGUI.BlankPanel", self)
	self.Next:SetMouseInputEnabled(true)
	self.Next:SetCursor("hand")
	self.Next:Dock(RIGHT)
	self.Next.Old_OnMouseReleased = self.Next.OnMouseReleased
	function self.Next:OnMouseReleased(m)
		if (self:GetParent().LoadingPanel and self:GetParent():LoadingDebounce() == true) then return end
		if (self:GetParent().Infinite or pagination:GetPage() < pagination:GetPages()) then
			pagination:SetPage(pagination:GetPage() + 1)
			if (pagination.OnPageSelected) then
				pagination:OnPageSelected(pagination:GetPage())
			end
		end
		if (self.Old_OnMouseReleased) then
			self:Old_OnMouseReleased(m)
		end
	end
	self.Next.Btn = vgui.Create("DImage", self.Next)
	self.Next.Btn:SetSize(16,16)
	self.Next.Btn:SetMaterial(next_btn_mat)
	function self.Next:PerformLayout()
		self.Btn:Center()
	end

	local page_poly = {
		{x = 0, y = 0},
		{x = 0, y = 0},
		{x = 0, y = 0},
		{x = 0, y = 0}
	}
	local hover_poly = {
		{x = 0, y = 0},
		{x = 0, y = 0},
		{x = 0, y = 0},
		{x = 0, y = 0}
	}
	function self.PagesContainer:Paint(w,h)
		local pages = pagination.Pages
		local current_page = pagination.CurrentPage
		if (pages == 0) then return end

		local infinite_controlled_pages = pages
		if (self:GetParent().Infinite) then infinite_controlled_pages = current_page + 2 end

		for i=0,math.min(infinite_controlled_pages, 9) do
			surface.SetDrawColor(40, 40, 40)
			surface.DrawLine((i * page_btn_width) + (i * page_btn_padding), h, ((i + 1) * page_btn_width) + (i * page_btn_padding), 0)
		end

		self.RhombusLerp:DoLerp()

		draw.NoTexture()

		local position = self.RhombusLerp:GetValue()

		page_poly[1].x = position + page_btn_width
		--page_poly[1].y = 0

		page_poly[2].x = position + page_btn_width + page_btn_padding + page_btn_width + 1
		--page_poly[2].y = 0

		page_poly[3].x = position + page_btn_width + page_btn_padding + 1
		page_poly[3].y = h

		page_poly[4].x = position
		page_poly[4].y = h

		surface.SetDrawColor(27, 127, 249)
		surface.DrawPoly(page_poly)

		if (self:IsHovered()) then
			-- please, a moment of silence for the amount of hours this took
			local x,y = self:ScreenToLocal(gui.MousePos())
			local rel_x = (x / (page_btn_width + page_btn_padding) % 1) * (page_btn_width + page_btn_padding)
			local rhombus_midpoint = h * (1 - (rel_x / page_btn_width))
			local hovered_position = x / (page_btn_width + page_btn_padding)
			if (rel_x < page_btn_width) then
				if (rhombus_midpoint < y) then
					hovered_position = math.floor(hovered_position + 1)
				else
					hovered_position = math.floor(hovered_position)
				end
			else
				hovered_position = math.ceil(hovered_position)
			end
			self.HoveredButton = hovered_position
			if (hovered_position > 0 and hovered_position <= math.min(9, infinite_controlled_pages)) then
				hovered_position = (hovered_position - 1) * (page_btn_width + page_btn_padding)

				hover_poly[1].x = hovered_position + page_btn_width
				--hover_poly[1].y = 0

				hover_poly[2].x = hovered_position + page_btn_width + page_btn_padding + page_btn_width + 1
				--hover_poly[2].y = 0

				hover_poly[3].x = hovered_position + page_btn_width + page_btn_padding + 1
				hover_poly[3].y = h

				hover_poly[4].x = hovered_position
				hover_poly[4].y = h

				surface.SetDrawColor(27, 127, 249, 100)
				surface.DrawPoly(hover_poly)
			end
		end

		for i,v in ipairs(self:GetParent().DrawPages) do
			if (v == current_page or (i == self.HoveredButton and self:IsHovered())) then
				draw.SimpleText(v, page_btn_font, ((page_btn_width + page_btn_padding) * i) - (page_btn_padding / 2), h / 2, bVGUI.COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(v, page_btn_font, ((page_btn_width + page_btn_padding) * i) - (page_btn_padding / 2), h / 2, inactive_page_textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end

function PANEL:UpdatePageButtons()
	self.DrawPages = {}

	local all_pages = self:GetPages()
	if (self.Infinite) then all_pages = "∞" end
	local current_page = self:GetPage()

	if (current_page < 8) then
		local _all_pages = all_pages
		if (self.Infinite) then _all_pages = current_page end
		for i=1,math.min(_all_pages, 7) do
			table.insert(self.DrawPages, i)
		end
		table.insert(self.DrawPages, "..")
		table.insert(self.DrawPages, all_pages)
	elseif (self.Infinite ~= true and current_page >= (all_pages - 6)) then
		table.insert(self.DrawPages, 1)
		table.insert(self.DrawPages, "..")
		for i=all_pages - 6, all_pages do
			table.insert(self.DrawPages, i)
		end
	elseif (self.Infinite) then
		table.insert(self.DrawPages, 1)
		table.insert(self.DrawPages, "..")
		for i=current_page - 4, current_page do
			table.insert(self.DrawPages, i)
		end
		table.insert(self.DrawPages, "..")
		table.insert(self.DrawPages, all_pages)
	elseif (current_page <= 12) then
		table.insert(self.DrawPages, 1)
		table.insert(self.DrawPages, "..")
		for i=8,12 do
			table.insert(self.DrawPages, i)
		end
		table.insert(self.DrawPages, "..")
		table.insert(self.DrawPages, all_pages)
	else
		table.insert(self.DrawPages, 1)
		table.insert(self.DrawPages, "..")
		table.insert(self.DrawPages, current_page - 2)
		table.insert(self.DrawPages, current_page - 1)
		table.insert(self.DrawPages, current_page)
		table.insert(self.DrawPages, current_page + 1)
		table.insert(self.DrawPages, current_page + 2)
		table.insert(self.DrawPages, "..")
		table.insert(self.DrawPages, all_pages)
	end
	for i,v in ipairs(self.DrawPages) do
		if (v == current_page) then
			local rhombus_pos = (i - 1) * (page_btn_width + page_btn_padding)
			if (not self.PagesContainer.RhombusLerp) then
				self.PagesContainer.RhombusLerp = bVGUI.Lerp(rhombus_pos, rhombus_pos, .5)
			else
				self.PagesContainer.RhombusLerp:SetTo(rhombus_pos)
			end
			break
		end
	end
	if (self.Infinite) then all_pages = current_page + 2 end
	self.PagesContainer:SetWide(((math.min(all_pages, 9) + 1) * page_btn_width) + (math.min(all_pages, 9) * page_btn_padding))
end

function PANEL:SetPage(page)
	if (page == "∞") then return end
	self.CurrentPage = page
	self:UpdatePageButtons()
end
function PANEL:GetPage()
	return self.CurrentPage
end

function PANEL:SetPages(pages)
	self.Pages = pages
	self.CurrentPage = math.min(self.CurrentPage, pages)
	self:UpdatePageButtons()
end
function PANEL:GetPages()
	return self.Pages
end

function PANEL:SetInfinite(infinite)
	self.Infinite = infinite
	self:UpdatePageButtons()
end

function PANEL:PerformLayout()
	self.PagesContainer:SetTall(self:GetTall())
	self.PagesContainer:CenterHorizontal()
	self.Previous:SetSize(self:GetTall(), self:GetTall())
	self.Next:SetSize(self:GetTall(), self:GetTall())
end

derma.DefineControl("bVGUI.Pagination", nil, PANEL, "bVGUI.BlankPanel")