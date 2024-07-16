--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/categories.lua

--]]

--/// bVGUI.Categories ///--

local PANEL = {}

function PANEL:Init()
	self.Categories = {}
	self.Items = {}

	self:Dock(LEFT)

	self.CategoriesContainer = vgui.Create("bVGUI.ScrollPanel", self)
	self.CategoriesContainer:Dock(FILL)

	self.DrawBackground = true
end

function PANEL:SetDrawBackground(draw_background)
	self.DrawBackground = draw_background
end

function PANEL:Paint(w,h)
	if (self.DrawBackground) then
		surface.SetDrawColor(bVGUI.COLOR_SLATE)
		surface.DrawRect(0,0,w,h)
	end

	self:LoadingPaint(w,h)
end

function PANEL:AddCategory(category_name, category_col)
	local this = self

	local category = vgui.Create("bVGUI.CategoriesCategory", self.CategoriesContainer)
	self.Categories[category_name] = category
	category:SetColor(category_col)
	category:SetText(category_name)
	category.ExistingItems = {}

	function category:AddItem(item_name, func, col, icon)
		if (category.ExistingItems[item_name]) then return end
		category.ExistingItems[item_name] = true
		local item = vgui.Create("bVGUI.CategoriesItem", self.ItemsContainer)
		table.insert(this.Items, item)
		item.ItemFunction = func
		item.Category = category
		item:SetText(item_name)
		if (col) then
			item:SetColor(col)
		else
			item:SetColor(category_col)
		end
		if (icon) then
			item:SetIcon(icon)
		end
		self.ItemsContainer:SizeToChildren(false, true)
		self.ItemsContainer:InvalidateParent(true)

		return item
	end

	function category:AddPlayer(ply, func, col, icon)
		local item = category:AddItem(ply:SteamID(), func, col, icon)
		if (not item) then return end
		item:SetAccountID(ply:AccountID())
	end

	function category:AddSteamID(steamid, func, col, icon)
		local item = category:AddItem(steamid, func, col, icon)
		if (not item) then return end
		print("deprecated AddSteamID", steamid)
		debug.Trace()
		item:SetAccountID(GAS:SteamIDToAccountID(steamid))
	end

	function category:AddAccountID(account_id, func, col, icon)
		local item = category:AddItem(GAS:AccountIDToSteamID(account_id), func, col, icon)
		if (not item) then return end
		item:SetAccountID(account_id)
	end

	function category:Clear()
		self.ExistingItems = {}
		local new_items = {}
		for i,v in pairs(this.Items) do
			if (v.Category == self) then
				v:Remove()
			else
				table.insert(new_items, v)
			end
		end
		this.Items = new_items
	end

	return category
end

function PANEL:RemoveItem(item)
	local item_category = item.Category

	item_category.ExistingItems[item.ItemName] = nil
	for i,v in ipairs(self.Items) do
		if (v == item) then
			table.remove(self.Items, i)
			break
		end
	end
	item:Remove()

	timer.Simple(0, function()
		if (item_category.Collapsed) then
			item_category.ItemsContainer:Stop()
			local y = 0
			for _,v in ipairs(item_category.ItemsContainer:GetChildren()) do
				y = y + v:GetTall()
			end
			item_category.ItemsContainer:SizeTo(item_category.ItemsContainer:GetWide(), y, 0.5)
		end
	end)
end

function PANEL:Clear()
	for _,v in ipairs(self.Items) do
		v:Remove()
	end
	for _,v in pairs(self.Categories) do
		v:Remove()
	end
	self.Categories = {}
	self.Items = {}
	self.CategoriesContainer:SetTall(0)
	self:InvalidateLayout(true)
	self.CategoriesContainer:InvalidateLayout(true)
end

function PANEL:EnableSearchBar(search_phrase)
	self.SearchBarContainer = vgui.Create("bVGUI.BlankPanel", self)
	self.SearchBarContainer:Dock(BOTTOM)
	self.SearchBarContainer:DockPadding(5,5,5,5)
	self.SearchBarContainer:SetTall(32)
	function self.SearchBarContainer:Paint(w,h)
		surface.SetDrawColor(bVGUI.COLOR_SLATE)
		surface.DrawRect(0,0,w,h)
	end

	self.SearchBarContainer.SearchBar = vgui.Create("bVGUI.TextEntry", self.SearchBarContainer)
	self.SearchBarContainer.SearchBar:Dock(FILL)
	self.SearchBarContainer.SearchBar:SetPlaceholderText(search_phrase or "Search...")
	function self.SearchBarContainer.SearchBar:OnChange()
		local search_text = self:GetText():lower()
		if (#search_text == 0) then
			for _,v in ipairs(self:GetParent():GetParent().Items) do
				v:SetVisible(true)
			end
		else
			for _,v in ipairs(self:GetParent():GetParent().Items) do
				if (v:GetText():lower():find(search_text,1,true)) then
					v:SetVisible(true)
				else
					v:SetVisible(false)
				end
			end
		end
		for _,v in pairs(self:GetParent():GetParent().Categories) do
			v.ItemsContainer:InvalidateLayout(true)
			v.ItemsContainer:SizeToChildren(false, true)
			v.ItemsContainer:InvalidateParent(true)
		end
	end
end

function PANEL:AddItem(item_name, func, col, icon)
	local item = vgui.Create("bVGUI.CategoriesItem", self)
	table.insert(self.Items, item)
	item.ItemFunction = func
	item.Category = category
	item:SetText(item_name)
	if (col) then
		item:SetColor(col)
	else
		item:SetColor(category_col)
	end
	if (icon) then
		item:SetIcon(icon)
	end

	return item
end

function PANEL:ClearActive()
	for _,v in ipairs(self.Items) do
		v:SetActive(false)
	end
end

derma.DefineControl("bVGUI.Categories", nil, PANEL, "bVGUI.LoadingPanel")

--/// bVGUI.CategoriesCategory ///--

local PANEL = {}

function PANEL:Init()
	self:SetTall(35)
	self:Dock(TOP)

	self.Collapsed = true
	self:SetCursor("up")

	self.CategoryColor = Color(0,0,0)
	self.CategoryName = ""

	self.CategoryNameLabel = vgui.Create("DLabel", self)
	self.CategoryNameLabel:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.CategoryNameLabel:SetText("")

	self.ItemsContainer = vgui.Create("DPanel", self:GetParent())
	self.ItemsContainer:SetTall(0)
	self.ItemsContainer:Dock(TOP)
	self.ItemsContainer.Category = self
	function self.ItemsContainer:Paint(w,h)
		surface.SetDrawColor(255,255,255,200)
		surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT_LARGE)
		surface.DrawTexturedRect(0,0,w,h)
	end
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(self.CategoryColor)
	surface.DrawRect(0,0,w,h)

	surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
	surface.DrawTexturedRect(0,0,w,h)
end

function PANEL:SetColor(col)
	self.CategoryColor = col
	
	if (bVGUI.ColorShouldUseBlackText(col)) then
		self.CategoryNameLabel:SetTextColor(bVGUI.COLOR_BLACK)
	else
		self.CategoryNameLabel:SetTextColor(bVGUI.COLOR_WHITE)
	end
end
function PANEL:SetText(text)
	self.CategoryName = text
	self.CategoryNameLabel:SetText(self.CategoryName)
	self.CategoryNameLabel:SizeToContentsY()
	self.CategoryNameLabel:SetWide(self:GetParent():GetWide() - 5 - 10 - 10)
	self.CategoryNameLabel:CenterVertical()
	self.CategoryNameLabel:AlignLeft(5 + 10)
end
function PANEL:GetText()
	return self.CategoryName
end

function PANEL:OnMouseReleased(m)
	if (m ~= MOUSE_LEFT) then return end
	if (self.Collapsed) then
		self.Collapsed = not self.Collapsed
		self:SetCursor("hand")
		self.ItemsContainer:Stop()
		self.ItemsContainer:SizeTo(self.ItemsContainer:GetWide(), 0, 0.5)
	else
		self.Collapsed = not self.Collapsed
		self:SetCursor("up")
		self.ItemsContainer:Stop()
		local y = 0
		for _,v in ipairs(self.ItemsContainer:GetChildren()) do
			y = y + v:GetTall()
		end
		self.ItemsContainer:SizeTo(self.ItemsContainer:GetWide(), y, 0.5)
	end
end

function PANEL:PerformLayout()
	self.CategoryNameLabel:SizeToContentsY()
	self.CategoryNameLabel:SetWide(self:GetParent():GetWide() - 5 - 10 - 10)
	self.CategoryNameLabel:CenterVertical()
	self.CategoryNameLabel:AlignLeft(5 + 10)
end

derma.DefineControl("bVGUI.CategoriesCategory", nil, PANEL, "DPanel")

--/// bVGUI.CategoriesItem ///--

local PANEL = {}

function PANEL:Init()
	self:SetCursor("hand")
	self:SetTall(35)
	self:Dock(TOP)
	self:InvalidateParent(true)

	self.ItemName = ""
	self.ItemColor = bVGUI.COLOR_BLACK
	self.ItemColorDark = bVGUI.COLOR_BLACK

	self.ItemNameLabel = vgui.Create("DLabel", self)
	self.ItemNameLabel:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.ItemNameLabel:SetText("")
	self.ItemNameLabel:SetTextColor(bVGUI.COLOR_WHITE)

	self.CurrentBarX = 0
	self.Ceil = false
	self.AnimTime = CurTime()
end

function PANEL:SetIcon(path)
	self.Icon = vgui.Create("DImage", self)
	self.Icon:SetImage(path)
	self.Icon:SetSize(16, 16)
	self.Icon:AlignLeft(5 + 10)
	self.Icon:CenterVertical()

	self.ItemNameLabel:AlignLeft(5 + 10 + 16 + 5)
end

function PANEL:Paint(w,h)
	if (self:IsActive()) then
		self.CurrentBarX = Lerp(math.TimeFraction(0, 3, CurTime() - self.AnimTime), self.CurrentBarX, w)
	else
		self.CurrentBarX = Lerp(math.TimeFraction(0, 3, CurTime() - self.AnimTime), self.CurrentBarX, 5)
	end

	surface.SetDrawColor(self.ItemColor)
	surface.DrawRect(0, 0, 5, h)
	if (self.Ceil) then
		surface.SetDrawColor(self.ItemColorDark)
		surface.DrawRect(5, 0, math.ceil(self.CurrentBarX) - 5, h)
	else
		surface.SetDrawColor(self.ItemColorDark)
		surface.DrawRect(5, 0, math.floor(self.CurrentBarX) - 5, h)
	end
end

function PANEL:SetColor(col)
	self.ItemColor = col
	self.ItemColorDark = bVGUI.DarkenColor(self.ItemColor, 0.35)
end
function PANEL:SetText(text)
	self.ItemName = text
	self.ItemNameLabel:SetText(self.ItemName)
	self.ItemNameLabel:SizeToContentsY()
	self.ItemNameLabel:SetWide(self:GetParent():GetWide() - 5 - 10 - 10)
	self.ItemNameLabel:CenterVertical()
	self.ItemNameLabel:AlignLeft(5 + 10)
end
function PANEL:GetText()
	return self.ItemName
end

function PANEL:GetCategories()
	if (self:GetParent().Items) then
		return self:GetParent()
	elseif (self:GetParent():GetParent():GetParent():GetParent().Items) then
		return self:GetParent():GetParent():GetParent():GetParent()
	end
end

function PANEL:UpdateActiveState(active, forced_active)
	for _,v in pairs(self:GetCategories().Items) do
		v.Active = false
		v.AnimTime = CurTime()
		v.Ceil = false
	end
	self.AnimTime = CurTime()
	self.Active = active or false
	self.ForcedActive = forced_active or false
	self.Ceil = active or forced_active or false
end

function PANEL:IsActive()
	return self.Active or self.ForcedActive or false
end

function PANEL:SetForcedActive(forced_active)
	self:UpdateActiveState(self.Active, forced_active)
end

function PANEL:SetActive(active)
	self:UpdateActiveState(active, self.ForcedActive)
end

function PANEL:OnMouseReleased(m)
	if (m == MOUSE_LEFT) then
		self:SetActive(true)
		if (self.ItemFunction) then
			if (self.AccountID) then
				self.ItemFunction(self.AccountID)
			else
				self.ItemFunction()
			end
		end
	elseif (m == MOUSE_RIGHT and self.AccountID) then
		bVGUI.PlayerTooltip.Focus()
	end
end

function PANEL:PerformLayout()
	self.ItemNameLabel:SizeToContentsY()
	self.ItemNameLabel:CenterVertical()

	local item_name_label_left = 5 + 10
	local item_name_label_wide = self:GetParent():GetWide() - 5 - 10 - 10
	if (IsValid(self.AvatarImage)) then
		self.AvatarImage:AlignLeft(5)
		self.AvatarImage:CenterVertical()
		item_name_label_left = item_name_label_left + 35
		item_name_label_wide = item_name_label_wide - 35
	end
	if (IsValid(self.Icon)) then
		item_name_label_left = item_name_label_left + 16 + 10
		item_name_label_wide = item_name_label_wide - (16 + 10)
	end
	self.ItemNameLabel:AlignLeft(item_name_label_left)
	self.ItemNameLabel:SetWide(item_name_label_wide)
end

function PANEL:SetAccountID(account_id)
	self.AccountID = account_id
	self.AvatarImage = vgui.Create("AvatarImage", self)
	self.AvatarImage:SetSize(35,35)
	self.AvatarImage:SetSteamID(GAS:AccountIDToSteamID64(account_id), 32)
	self.AvatarImage:SetMouseInputEnabled(false)
	local this = self
	GAS.OfflinePlayerData:AccountID(account_id, function(success, data)
		if (not success) then
			this:SetText(GAS:AccountIDToSteamID(account_id))
		else
			this:SetText(data.nick)
		end
	end)
end

function PANEL:SetSteamID64(steamid64)
	print("SetSteamID64 deprecated", steamid64)
	return self:SetAccountID(GAS:SteamID64ToAccountID(steamid64))
end

function PANEL:OnCursorEntered()
	if (self.AccountID) then
		bVGUI.PlayerTooltip.Create({
			account_id = self.AccountID,
			focustip = bVGUI.L("right_click_to_focus"),
			copiedphrase = bVGUI.L("copied"),
			creator = self
		})
	end
end
function PANEL:OnCursorExited()
	if (self.AccountID) then
		bVGUI.PlayerTooltip.Close()
	end
end

derma.DefineControl("bVGUI.CategoriesItem", nil, PANEL, "DPanel")