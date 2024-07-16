if (GAS.PlayerDatabase and IsValid(GAS.PlayerDatabase.Menu)) then
	GAS.PlayerDatabase.Menu:Close()
end

GAS.PlayerDatabase = {}

if (CLIENT) then
	local function L(phrase, ...)
		if (#({...}) == 0) then
			return GAS:Phrase(phrase, "playerdatabase")
		else
			return GAS:PhraseFormat(phrase, "playerdatabase", ...)
		end
	end

	local search_tab_mat = Material("gmodadminsuite/search_tab.vtf")
	function GAS.PlayerDatabase:OpenMenu(ModuleFrame)
		if (IsValid(GAS.PlayerDatabase.Menu)) then
			GAS.PlayerDatabase.Menu:Close()
		end
		GAS.PlayerDatabase.Menu = ModuleFrame

		local see_ip_addresses = OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite/see_ip_addresses")

		local content = vgui.Create("bVGUI.BlankPanel", ModuleFrame)
		content:Dock(FILL)
		function content:PerformLayout()
			GAS.PlayerDatabase.Menu.SearchTab:AlignRight(10 + GAS.PlayerDatabase.Menu.SearchMenu:GetWide())
			GAS.PlayerDatabase.Menu.SearchTab:AlignBottom(30)
		end
		function content:PaintOver(w,h)
			if (GAS.PlayerDatabase.Menu.SearchMenu:GetWide() ~= 0) then
				surface.SetDrawColor(255,255,255,150)
				surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
				surface.DrawTexturedRect(w - GAS.PlayerDatabase.Menu.SearchMenu:GetWide(),0,10,h)
			end
		end

		GAS.PlayerDatabase.Menu.Table = vgui.Create("bVGUI.Table", content)
		GAS.PlayerDatabase.Menu.Table:Dock(FILL)
		GAS.PlayerDatabase.Menu.Table:AddColumn(L"last_seen", bVGUI.TABLE_COLUMN_SHRINK)
		GAS.PlayerDatabase.Menu.Table:AddColumn(L"steamid", bVGUI.TABLE_COLUMN_SHRINK)
		if (see_ip_addresses) then
			GAS.PlayerDatabase.Menu.Table:AddColumn(L"ip_address", bVGUI.TABLE_COLUMN_SHRINK)
		end
		GAS.PlayerDatabase.Menu.Table:AddColumn(L"usergroup", bVGUI.TABLE_COLUMN_SHRINK)
		GAS.PlayerDatabase.Menu.Table:AddColumn(L"country", bVGUI.TABLE_COLUMN_SHRINK)
		GAS.PlayerDatabase.Menu.Table:AddColumn(L"name", bVGUI.TABLE_COLUMN_GROW)
		GAS.PlayerDatabase.Menu.Table:SetLoading(true)
		GAS.PlayerDatabase.Menu.Table:SetRowCursor("hand")
		function GAS.PlayerDatabase.Menu.Table:OnColumnHovered(row, column_index)
			if (column_index == nil) then
				bVGUI.PlayerTooltip.Close()
			else
				bVGUI.PlayerTooltip.Create({
					account_id = tonumber(row.Data.account_id),
					creator = row,
					focustip = L"right_click_to_focus"
				})
			end
		end

		function GAS.PlayerDatabase.Menu.Table:OnRowClicked(row)
			local menu = DermaMenu()

			menu:AddOption(L"copy_steamid", function()
				GAS:SetClipboardText(GAS:AccountIDToSteamID(row.Data.account_id))
			end):SetIcon("gmodadminsuite/steam.png")

			menu:AddOption(L"copy_steamid64", function()
				GAS:SetClipboardText(GAS:AccountIDToSteamID64(row.Data.account_id))
			end):SetIcon("gmodadminsuite/steam.png")

			menu:AddOption(L"copy_steam_profile_link", function()
				GAS:SetClipboardText("https://steamcommunity.com/profiles/" .. GAS:AccountIDToSteamID64(row.Data.account_id))
			end):SetIcon("icon16/world_link.png")

			menu:AddSpacer()

			menu:AddOption(L"copy_name", function()
				GAS:SetClipboardText(row.Data.nick)
			end):SetIcon("icon16/tag_blue.png")

			menu:AddOption(L"copy_usergroup", function()
				GAS:SetClipboardText(row.Data.usergroup)
			end):SetIcon("icon16/group.png")

			if (row.Data.country_code ~= nil) then
				menu:AddOption(L"copy_country", function()
					GAS:SetClipboardText(GAS.CountryCodes[row.Data.country_code] or row.Data.country_code)
				end):SetIcon("icon16/world.png")
			end

			if (see_ip_addresses and row.Data.ip_address ~= nil) then
				menu:AddOption(L"copy_ip_address", function()
					GAS:SetClipboardText(row.Data.ip_address)
				end):SetIcon("icon16/connect.png")
			end

			menu:AddSpacer()

			menu:AddOption(L"search_name", function()
				GAS.PlayerDatabase.Menu.SearchMenu:Open(true)

				GAS.PlayerDatabase.Menu.SearchMenu.Content.NameField:SetValue(row.Data.nick)
				GAS.PlayerDatabase.Menu.SearchMenu.Content.SearchBtn:DoVerificationClick()
			end):SetIcon("icon16/magnifier.png")

			menu:AddOption(L"search_usergroup", function()
				GAS.PlayerDatabase.Menu.SearchMenu:Open(true)

				GAS.PlayerDatabase.Menu.SearchMenu.Content.UsergroupField:SetValue(row.Data.usergroup)
				GAS.PlayerDatabase.Menu.SearchMenu.Content.SearchBtn:DoVerificationClick()
			end):SetIcon("icon16/magnifier.png")

			if (row.Data.country_code ~= nil) then
				menu:AddOption(L"search_country", function()
					GAS.PlayerDatabase.Menu.SearchMenu:Open(true)

					for i,choice in pairs(GAS.PlayerDatabase.Menu.SearchMenu.Content.CountryField.Data) do
						if (choice == row.Data.country_code) then
							GAS.PlayerDatabase.Menu.SearchMenu.Content.CountryField:ChooseOptionID(i)
							break
						end
					end

					GAS.PlayerDatabase.Menu.SearchMenu.Content.SearchBtn:DoVerificationClick()
				end):SetIcon("icon16/magnifier.png")
			end

			if (see_ip_addresses and row.Data.ip_address ~= nil) then
				menu:AddOption(L"search_ip_address", function()
					GAS.PlayerDatabase.Menu.SearchMenu:Open(true)

					GAS.PlayerDatabase.Menu.SearchMenu.Content.IPAddressField:SetValue(row.Data.ip_address)
					GAS.PlayerDatabase.Menu.SearchMenu.Content.SearchBtn:DoVerificationClick()
				end):SetIcon("icon16/magnifier.png")
			end

			menu:Open()
		end
		function GAS.PlayerDatabase.Menu.Table:OnRowRightClicked(row)
			bVGUI.PlayerTooltip.Focus()
		end

		GAS.PlayerDatabase.Menu.SearchMenu = vgui.Create("bVGUI.BlankPanel", content)
		GAS.PlayerDatabase.Menu.SearchMenu:Dock(RIGHT)
		GAS.PlayerDatabase.Menu.SearchMenu:SetWide(0)
		GAS.PlayerDatabase.Menu.SearchMenu.IsOpen = false
		function GAS.PlayerDatabase.Menu.SearchMenu:Paint(w,h)
			surface.SetDrawColor(19,19,19,255)
			surface.DrawRect(0,0,w,h)
		end

		function GAS.PlayerDatabase.Menu.SearchMenu:Toggle()
			if (self.IsOpen) then
				self:Close()
			else
				self:Open()
			end
		end
		function GAS.PlayerDatabase.Menu.SearchMenu:Open(clear_content)
			GAS:PlaySound("popup")
			self.IsOpen = true
			self:Stop()
			self:SizeTo(160, self:GetTall(), 0.5)

			if (not clear_content and IsValid(self.Content)) then return end

			if (IsValid(self.Content)) then
				self.Content:Remove()
			end

			self.Content = vgui.Create("bVGUI.BlankPanel", self)
			local content = self.Content
			self.Content:Dock(FILL)
			self.Content:DockMargin(10,10,10,10)

			local form = vgui.Create("bVGUI.BlankPanel", self.Content)
			form:Dock(FILL)

			for _,v in ipairs({
				{
					Key = "NameField",
					Icon = "icon16/user.png",
					Label = L"name",
					TextEntry = true
				},

				{
					Key = "UsergroupField",
					Icon = "icon16/group.png",
					Label = L"usergroup",
					TextEntry = true
				},

				{
					Key = "CountryField",
					Icon = "icon16/world.png",
					Label = L"country",
					ComboBox = true
				},

				{
					Key = "IPAddressField",
					Icon = "icon16/connect.png",
					Label = L"ip_address",
					TextEntry = true
				},

				{
					Key = "SteamIDField",
					Icon = "gmodadminsuite/steam.png",
					Label = L"steamid",
					TextEntry = true
				},
			}) do

				local i = v.Key
				if (i == "IPAddressField" and not see_ip_addresses) then continue end

				local line = vgui.Create("bVGUI.BlankPanel", form)
				line:Dock(TOP)
				line:DockMargin(0,0,0,10)

				if (v.TextEntry) then
					local TextEntry = vgui.Create("bVGUI.TextEntry", line)
					self.Content[i] = TextEntry
					TextEntry:SetUpdateOnType(true)
					function TextEntry:OnValueChange()
						if (not IsValid(content.SearchBtn)) then return end
						content.SearchBtn:DoVerification()
					end
				elseif (v.ComboBox) then
					local ComboBox = vgui.Create("bVGUI.ComboBox", line)
					self.Content[i] = ComboBox
					function ComboBox:OnSelect(i,v,d)
						if (not IsValid(content.SearchBtn)) then return end
						GAS:PlaySound("btn_light")
						content.SearchBtn:DoVerification()
					end
				end

				self.Content[i]:Dock(BOTTOM)
				self.Content[i]:DockMargin(0,5,0,0)

				local top = vgui.Create("bVGUI.BlankPanel", line)
				top:Dock(TOP)
				top:SetTall(16)

				local icon = vgui.Create("DImage", top)
				icon:Dock(LEFT)
				icon:SetSize(16,16)
				icon:SetImage(v.Icon)
				icon:DockMargin(0,0,5,0)

				local label = vgui.Create("DLabel", top)
				label:Dock(FILL)
				label:SetContentAlignment(4)
				label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
				label:SetTextColor(bVGUI.COLOR_WHITE)
				label:SetText(v.Label)
				label:SizeToContents()

				line:SetTall(16 + 5 + self.Content[i]:GetTall())

			end

			self.Content.CountryField:SetSortItems(false)
			self.Content.CountryField:AddChoice(L"none", false, true, "icon16/cross.png")
			self.Content.CountryField:AddSpacer()
			for country_name, country_code in SortedPairs(GAS.CountryCodesReverse) do
				local icon
				if (file.Exists("materials/flags16/" .. country_code .. ".png", "GAME")) then
					icon = "flags16/" .. country_code .. ".png"
				end
				self.Content.CountryField:AddChoice(country_name, country_code, false, icon)
			end

			self.Content.SearchBtn = vgui.Create("bVGUI.Button", form)
			self.Content.SearchBtn:SetColor(bVGUI.BUTTON_COLOR_BLUE)
			self.Content.SearchBtn:SetText(L"search")
			self.Content.SearchBtn:SetDisabled(true)
			self.Content.SearchBtn:DockMargin(0,5,0,0)
			self.Content.SearchBtn:Dock(TOP)
			self.Content.SearchBtn:SetTall(25)
			function self.Content.SearchBtn:DoVerification()
				self:SetDisabled(not GAS.PlayerDatabase.Menu.Searching and (#content.SteamIDField:GetValue() == 0 or (not content.SteamIDField:GetValue():upper():find("^STEAM_%d:%d+:%d+$") and not content.SteamIDField:GetValue():find("^7656119%d+$"))) and (content.CountryField:GetSelectedID() == nil or content.CountryField:GetSelectedID() == 1) and #content.NameField:GetValue() == 0 and #content.UsergroupField:GetValue() == 0 and (not IsValid(content.IPAddressField) or not GAS:IsIPAddress(content.IPAddressField:GetValue(), true)))
			end
			function self.Content.SearchBtn:DoVerificationClick()
				self:DoVerification()
				if (not self:GetDisabled()) then
					self:DoClick()
				end
			end
			function self.Content.SearchBtn:DoClick()
				GAS.PlayerDatabase.Menu.Pagination:SetPage(1)
				GAS.PlayerDatabase.Menu.Pagination:SetPages(1)

				GAS.PlayerDatabase.Menu.Table:Clear()
				GAS.PlayerDatabase.Menu.Table:SetLoading(true)

				if (GAS.PlayerDatabase.Menu.Searching) then
					GAS:PlaySound("delete")

					GAS.PlayerDatabase.Menu.Searching = false
					self:SetColor(bVGUI.BUTTON_COLOR_BLUE)
					self:SetText(L"search")
				else
					GAS:PlaySound("success")

					GAS.PlayerDatabase.Menu.Searching = true
					self:SetColor(bVGUI.BUTTON_COLOR_RED)
					self:SetText(L"cancel")
				end

				GAS.PlayerDatabase.Menu.Pagination:OnPageSelected(1)
			end
		end
		function GAS.PlayerDatabase.Menu.SearchMenu:Close()
			if (GAS.PlayerDatabase.Menu.Searching) then
				GAS:PlaySound("error")
			else
				GAS:PlaySound("delete")
				self.IsOpen = false
				self:Stop()
				self:SizeTo(0, self:GetTall(), 0.5, 0)
			end
		end

		GAS.PlayerDatabase.Menu.SearchTab = vgui.Create("bVGUI.BlankPanel", content)
		GAS.PlayerDatabase.Menu.SearchTab:SetSize(50,25)
		GAS.PlayerDatabase.Menu.SearchTab:SetMouseInputEnabled(true)
		GAS.PlayerDatabase.Menu.SearchTab:SetCursor("hand")
		bVGUI.AttachTooltip(GAS.PlayerDatabase.Menu.SearchTab, {Text = L"search"})
		function GAS.PlayerDatabase.Menu.SearchTab:OnMouseReleased(m)
			if (m ~= MOUSE_LEFT) then return end
			GAS.PlayerDatabase.Menu.SearchMenu:Toggle()
		end
		function GAS.PlayerDatabase.Menu.SearchTab:Paint(w,h)
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(search_tab_mat)
			surface.DrawTexturedRect(0,0,64,64)
		end

		local pagination_container = vgui.Create("bVGUI.BlankPanel", content)
		pagination_container:Dock(BOTTOM)
		pagination_container:SetTall(30)
		function pagination_container:Paint(w,h)
			surface.SetDrawColor(19,19,19,255)
			surface.DrawRect(0,0,w,h)
		end

		GAS.PlayerDatabase.Menu.Pagination = vgui.Create("bVGUI.Pagination", pagination_container)
		GAS.PlayerDatabase.Menu.Pagination:Dock(FILL)
		GAS.PlayerDatabase.Menu.Pagination:SetPages(1)
		function GAS.PlayerDatabase.Menu.Pagination:OnPageSelected(page)
			GAS.PlayerDatabase.Menu.Table:Clear()
			GAS.PlayerDatabase.Menu.Table:SetLoading(true)

			GAS:StartNetworkTransaction("playerdatabase:GetPage", function()
				net.WriteUInt(page, 16)
				net.WriteBool(GAS.PlayerDatabase.Menu.Searching or false)
				if (GAS.PlayerDatabase.Menu.Searching) then
					local search_content = GAS.PlayerDatabase.Menu.SearchMenu.Content

					local search_name = #search_content.NameField:GetValue() > 0
					net.WriteBool(search_name)
					if (search_name) then
						net.WriteString(search_content.NameField:GetValue())
					end

					local search_usergroup = #search_content.UsergroupField:GetValue() > 0
					net.WriteBool(search_usergroup)
					if (search_usergroup) then
						net.WriteString(search_content.UsergroupField:GetValue())
					end

					local search_country = search_content.CountryField:GetSelectedID() ~= nil and search_content.CountryField:GetSelectedID() ~= 1
					net.WriteBool(search_country)
					if (search_country) then
						net.WriteString(search_content.CountryField:GetOptionData(search_content.CountryField:GetSelectedID()))
					end

					local search_ip_address = see_ip_addresses and #search_content.IPAddressField:GetValue() > 0
					net.WriteBool(search_ip_address)
					if (search_ip_address) then
						net.WriteString(search_content.IPAddressField:GetValue())
					end

					local search_steamid = #search_content.SteamIDField:GetValue() > 0
					net.WriteBool(search_steamid)
					if (search_steamid) then
						net.WriteString(search_content.SteamIDField:GetValue())
					end
				end
			end, function(has_data)
				if (not IsValid(GAS.PlayerDatabase.Menu) or not IsValid(GAS.PlayerDatabase.Menu.Table)) then return end
				GAS.PlayerDatabase.Menu.Table:SetLoading(false)
				if (has_data) then
					local pages = net.ReadUInt(16)
					local data_len = net.ReadUInt(16)
					local player_data = GAS:DeserializeTable(util.Decompress(net.ReadData(data_len)))
					for _,row in ipairs(player_data) do
						local ply = player.GetByAccountID(tonumber(row.account_id))
						local nick = row.nick
						if (IsValid(ply)) then
							nick = "<color=" .. GAS:Unvectorize(team.GetColor(ply:Team())) .. ">" .. GAS:EscapeMarkup(nick) .. "</color>"
						else
							nick = GAS:EscapeMarkup(nick)
						end
						local country
						if (row.country_code ~= nil) then
							country = GAS:EscapeMarkup(GAS.CountryCodes[row.country_code] or row.country_code)
						else
							country = ""
						end
						local row_pnl
						if (see_ip_addresses) then
							row_pnl = GAS.PlayerDatabase.Menu.Table:AddRow(GAS:SimplifyTimestamp(row.last_seen), GAS:AccountIDToSteamID(row.account_id), row.ip_address or "", GAS:EscapeMarkup(row.usergroup), country, nick)
						else
							row_pnl = GAS.PlayerDatabase.Menu.Table:AddRow(GAS:SimplifyTimestamp(row.last_seen), GAS:AccountIDToSteamID(row.account_id), GAS:EscapeMarkup(row.usergroup), country, nick)
						end
						row_pnl.Data = row
					end
				end
			end)
		end

		GAS.PlayerDatabase.Menu.Pagination:OnPageSelected(1)
	end

	GAS:hook("gmodadminsuite:ModuleSize:playerdatabase", "playerdatabase:framesize", function()
		return 900,600
	end)
	GAS:hook("gmodadminsuite:ModuleFrame:playerdatabase", "playerdatabase:menu", function(ModuleFrame)
		GAS.PlayerDatabase:OpenMenu(ModuleFrame)
	end)
else
	GAS:netInit("playerdatabase:GetPage")
	GAS:ReceiveNetworkTransaction("playerdatabase:GetPage", function(transaction_id, ply)
		if (not OpenPermissions:HasPermission(ply, "gmodadminsuite/playerdatabase")) then return end

		local page = net.ReadUInt(16)

		local searching = net.ReadBool()
		local searching_name, search_name, searching_usergroup, search_usergroup, searching_country, search_country, searching_ip_address, search_ip_address, searching_steamid, search_steamid

		if (searching) then
			searching_name = net.ReadBool()
			if (searching_name) then search_name = net.ReadString():lower() end

			searching_usergroup = net.ReadBool()
			if (searching_usergroup) then search_usergroup = net.ReadString():lower() end

			searching_country = net.ReadBool()
			if (searching_country) then search_country = net.ReadString():upper() end

			searching_ip_address = net.ReadBool()
			if (searching_ip_address) then search_ip_address = net.ReadString() end

			searching_steamid = net.ReadBool()
			if (searching_steamid) then search_steamid = net.ReadString():upper() end
		end

		local see_ip_addresses = OpenPermissions:HasPermission(ply, "gmodadminsuite/see_ip_addresses")

		if (searching and searching_ip_address and (not see_ip_addresses or not GAS:IsIPAddress(search_ip_address, true))) then return end

		local ip_address_column = ""
		if (see_ip_addresses) then
			ip_address_column = ", `ip_address`"
		end

		local pages
		local player_data
		local terminate
		local function data()
			if (terminate) then return end
			if (pages == 0 or player_data == false) then
				terminate = true
				GAS:TransactionNoData("playerdatabase:GetPage", transaction_id, ply)
				return
			end
			if (pages ~= nil and player_data ~= nil) then
				local c = util.Compress(GAS:SerializeTable(player_data))
				GAS:netStart("playerdatabase:GetPage")
					net.WriteUInt(transaction_id, 16)
					net.WriteUInt(pages, 16)
					net.WriteUInt(#c, 16)
					net.WriteData(c, #c)
				net.Send(ply)
			end
		end

		local get_pages_query, get_data_query

		if (not searching) then
			get_pages_query = "SELECT COUNT(*) AS 'count' FROM gas_offline_player_data WHERE `server_id`=" .. GAS.ServerID
			get_data_query = "SELECT `account_id`, `nick`, `usergroup`, `country_code`, UNIX_TIMESTAMP(`last_seen`) AS 'last_seen'" .. ip_address_column .. " FROM gas_offline_player_data WHERE `server_id`=" .. GAS.ServerID .. " ORDER BY `last_seen` DESC LIMIT " .. ((page - 1) * 60) .. ",60"
		else
			get_pages_query = "SELECT COUNT(*) as 'count' FROM gas_offline_player_data WHERE `server_id`=" .. GAS.ServerID .. " AND ("
			get_data_query = "SELECT `account_id`, `nick`, `usergroup`, `country_code`, UNIX_TIMESTAMP(`last_seen`) AS 'last_seen'" .. ip_address_column .. " FROM gas_offline_player_data WHERE `server_id`=" .. GAS.ServerID .. " AND ("

			local where_clause = ""
			if (searching_name) then
				where_clause = where_clause .. "LOWER(`nick`) LIKE '%" .. (GAS.Database:Escape(search_name, true):gsub("%%", "\\%%")) .. "%' AND "
			end
			if (searching_usergroup) then
				where_clause = where_clause .. "LOWER(`usergroup`) LIKE '%" .. (GAS.Database:Escape(search_usergroup, true):gsub("%%", "\\%%")) .. "%' AND "
			end
			if (searching_country) then
				where_clause = where_clause .. "`country_code`=" .. GAS.Database:Escape(search_country) .. " AND "
			end
			if (searching_ip_address) then
				where_clause = where_clause .. "`ip_address`=" .. GAS.Database:Escape(search_ip_address)
			end
			if (searching_steamid) then
				local account_id
				if (search_steamid:find("^STEAM_%d:%d+:%d+$")) then
					account_id = GAS:SteamIDToAccountID(search_steamid)
				elseif (search_steamid:find("^7656119%d+$")) then
					account_id = GAS:SteamID64ToAccountID(search_steamid)
				end
				if (account_id ~= nil) then where_clause = where_clause .. "`account_id`=" .. GAS.Database:Escape(account_id) end
			end
			where_clause = (where_clause:gsub("AND $",""))

			get_pages_query = get_pages_query .. where_clause .. ")"
			get_data_query = get_data_query .. where_clause .. ") ORDER BY `last_seen` DESC LIMIT " .. ((page - 1) * 60) .. ",60"
		end

		GAS.Database:Query(get_pages_query, function(rows)
			if (not rows or #rows == 0 or rows[1].count == nil or tonumber(rows[1].count) == nil) then
				pages = 0
				data()
			else
				pages = math.ceil(tonumber(rows[1].count) / 60)
				data()
			end
		end)
		GAS.Database:Query(get_data_query, function(rows)
			if (not rows or #rows == 0) then
				player_data = false
				data()
			else
				player_data = rows
				data()
			end
		end)
	end)
end