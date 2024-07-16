--[[


addons/[admin]_gmodadminsuite/lua/vgui/gas_workshop_item.lua

--]]

local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "workshop")
	else
		return GAS:PhraseFormat(phrase, "workshop", ...)
	end
end

file.CreateDir("gmodadminsuite/workshop")

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
	self:Dock(TOP)
	self:SetTall(105)
	self:SetLoading(true)

	self.ItemImage = vgui.Create("bVGUI.LoadingPanel", self)
	self.ItemImage:Dock(LEFT)
	self.ItemImage:SetMouseInputEnabled(false)
	self.ItemImage:DockPadding(10,10,10,10)
	self.ItemImage:SetLoading(false)
	self.ItemImage:SetWide(105)

		self.ItemImage.ImagePnl = vgui.Create("DImage", self.ItemImage)
		self.ItemImage.ImagePnl:Dock(FILL)

	self.Content = vgui.Create("bVGUI.BlankPanel", self)
	self.Content:Dock(FILL)
	self.Content:SetMouseInputEnabled(false)
	self.Content:DockPadding(0,10,10,10)

		self.Content.ItemName = vgui.Create("DLabel", self.Content)
		self.Content.ItemName:Dock(TOP)
		self.Content.ItemName:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "BOLD", 16))
		self.Content.ItemName:SetTextColor(bVGUI.COLOR_WHITE)
		self.Content.ItemName:SetContentAlignment(4)
		self.Content.ItemName:SetText("")

		self.Content.Description = vgui.Create("DLabel", self.Content)
		self.Content.Description:Dock(FILL)
		self.Content.Description:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
		self.Content.Description:SetTextColor(bVGUI.COLOR_WHITE)
		self.Content.Description:SetContentAlignment(7)
		self.Content.Description:SetText("")
		self.Content.Description:SetWrap(true)
end

function PANEL:OnMouseReleased(m)
	if (m ~= MOUSE_LEFT) then return end
	local menu = DermaMenu()

	menu:AddOption(L"copy_item_id", function()
		GAS:SetClipboardText(self.ItemInfo.publishedfileid)
	end):SetIcon("icon16/page_copy.png")

	local open_workshop_page, _ = menu:AddSubMenu(L"open_workshop_page") _:SetIcon("materials/gmodadminsuite/steam.png")

		open_workshop_page:AddOption(L"steam_browser", function()
			GAS:OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. self.ItemInfo.publishedfileid)
		end):SetIcon("materials/gmodadminsuite/steam.png")

		open_workshop_page:AddOption(L"copy_link", function()
			GAS:SetClipboardText("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. self.ItemInfo.publishedfileid)
		end):SetIcon("icon16/page_copy.png")

	menu:AddOption(L"open_creator_profile", function()
		GAS:OpenURL("https://steamcommunity.com/profiles/" .. self.ItemInfo.creator)
	end):SetIcon("icon16/user_gray.png")

	menu:Open()
end

function PANEL:SetItemInfo(item_info)
	self.ItemInfo = item_info
	self.ItemID = tonumber(item_info.publishedfileid)

	self.Content.ItemName:SetText(item_info.title or L"error")
	self.Content.ItemName:SizeToContentsY()

	self.Content.Description:SetText(item_info.description or L"error")

	if (file.Read("gmodadminsuite/workshop/" .. item_info.publishedfileid .. ".png", "DATA")) then
		self.ItemImage:SetLoading(false)
		self.ItemImage.ImagePnl:SetImage("data/gmodadminsuite/workshop/" .. item_info.publishedfileid .. ".png")
	else
		self.ItemImage:SetLoading(true)
		http.Fetch(item_info.preview_url, function(body, len, headers, code)
			self.ItemImage:SetLoading(false)
			if (len > 0 and code == 200) then
				file.Write("gmodadminsuite/workshop/" .. item_info.publishedfileid .. ".png", body)
				self.ItemImage.ImagePnl:SetImage("data/gmodadminsuite/workshop/" .. item_info.publishedfileid .. ".png")
			else
				self.ItemImage.ImagePnl:SetImage("missing")
			end
		end)
	end
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(40,64,87)
	surface.DrawRect(0,0,w,h)

	surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
	surface.DrawTexturedRect(0,0,w,h)
end

derma.DefineControl("GAS.Workshop.Item", nil, PANEL, "bVGUI.LoadingPanel")