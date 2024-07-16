local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "secondaryusergroups")
	else
		return GAS:PhraseFormat(phrase, "secondaryusergroups", ...)
	end
end

local function SortedUsergroups(all_data)
	local all_usergroups = {}
	for account_id, usergroups in pairs(GAS.SecondaryUsergroups.AllData) do
		for usergroup in pairs(usergroups) do
			all_usergroups[usergroup] = true
		end
	end
	local sorted = table.GetKeys(all_usergroups)
	table.sort(sorted)
	return sorted
end

function GAS.SecondaryUsergroups:OpenContextMenu(submenu, ply, open_menu_btn, submenu_pnl)
	if (open_menu_btn) then
		submenu:AddOption(L"open_menu", function()
			RunConsoleCommand("gmodadminsuite", "secondaryusergroups")
		end):SetIcon("icon16/application_form_magnify.png")

		submenu:AddSpacer()
	end

	submenu:AddOption(L"custom_ellipsis", function()
		bVGUI.StringQuery(L"give_usergroup", nil, L"usergroup_ellipsis", function(usergroup)
			GAS:netStart("secondaryusergroups:GiveUsergroup")
				net.WriteUInt(ply:AccountID(), 31)
				net.WriteString(usergroup)
			net.SendToServer()
		end)
	end):SetIcon("icon16/pencil.png")

	local option = submenu:AddOption(ply:GetUserGroup())
	option:SetIcon("icon16/wrench_orange.png")
	function option:OnMouseReleased(m)
		DButton.OnMouseReleased(self, m)
		if (m ~= MOUSE_LEFT or not self.m_MenuClicking) then return end
		self.m_MenuClicking = false
	end
	
	local function Populate()
		local all_usergroups = SortedUsergroups()
		local my_usergroups = OpenPermissions:GetUserGroups(ply)

		for _,usergroup in ipairs(all_usergroups) do
			local option = submenu:AddOption(usergroup)
			option.HasUsergroup = my_usergroups[usergroup] or false
			if (option.HasUsergroup) then
				option:SetIcon("icon16/tick.png")
			else
				option:SetIcon("icon16/cross.png")
			end
			function option:OnMouseReleased(m)
				DButton.OnMouseReleased(self, m)
				if (m ~= MOUSE_LEFT or not self.m_MenuClicking) then return end
				self.m_MenuClicking = false

				self.HasUsergroup = not self.HasUsergroup
				if (self.HasUsergroup) then
					option:SetIcon("icon16/tick.png")
					GAS:netStart("secondaryusergroups:GiveUsergroup")
				else
					option:SetIcon("icon16/cross.png")
					GAS:netStart("secondaryusergroups:RevokeUsergroup")
				end
				
				net.WriteUInt(ply:AccountID(), 31)
				net.WriteString(usergroup)

				net.SendToServer()
			end
		end
	end	

	local loading_option
	local has_loaded
	submenu_pnl.GAS_OLD_ENTER = submenu_pnl.OnCursorEntered
	function submenu_pnl:OnCursorEntered(...)
		self:GAS_OLD_ENTER(...)

		if (not has_loaded) then
			loading_option = bVGUI_DermaMenuOption_Loading(submenu)

			GAS:netStart("secondaryusergroups:GetAllData")
			net.SendToServer()

			GAS:netReceive("secondaryusergroups:GetAllData", function(l)
				GAS.SecondaryUsergroups.AllData = GAS:DeserializeTable(util.Decompress(net.ReadData(l)))
				if (not IsValid(loading_option)) then return end
				loading_option:Remove()

				has_loaded = true

				Populate()
			end)
		end
	end
end

GAS:hook("gmodadminsuite:ModuleSize:secondaryusergroups", "secondaryusergroups:framesize", function()
	return 700,500
end)

local logo_mat = Material("gmodadminsuite/secondaryusergroups.vtf")
GAS:hook("gmodadminsuite:ModuleFrame:secondaryusergroups", "secondaryusergroups:menu", function(ModuleFrame)
	local main_content = vgui.Create("bVGUI.BlankPanel", ModuleFrame)
	main_content:Dock(FILL)

	local left_content = vgui.Create("bVGUI.BlankPanel", main_content)
	left_content:Dock(LEFT)
	left_content:SetWide(175)

	local categories = vgui.Create("bVGUI.Categories", left_content)
	categories:Dock(FILL)
	categories:EnableSearchBar()
	categories:SetLoading(true)
	local category = categories:AddCategory(L"players", Color(216,75,75))

	local offline_container = vgui.Create("DPanel", left_content)
	offline_container:Dock(BOTTOM)
	offline_container:DockPadding(5,5,5,5)
	offline_container:SetTall(35)
	function offline_container:Paint(w,h)
		surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
		surface.DrawRect(0,0,w,h)
	end

		local offline_btn = vgui.Create("bVGUI.Button", offline_container)
		offline_btn:SetColor(bVGUI.BUTTON_COLOR_BLUE)
		offline_btn:SetText(L"offline_btn")
		offline_btn:Dock(FILL)

	local logo_content = vgui.Create("bVGUI.BlankPanel", main_content)
	logo_content:Dock(FILL)

	local logo_btn = vgui.Create("bVGUI.Button", logo_content)
	logo_btn:SetColor(bVGUI.BUTTON_COLOR_GREEN)
	logo_btn:SetSize(150,30)
	logo_btn:SetText(L"help")
	logo_btn:SetEnabled(false)
	function logo_btn:DoClick()
		GAS:OpenURL("https://gmodsto.re/gmodadminsuite-secondaryusergroups-help")
	end

	function logo_content:Paint(w,h)
		surface.SetMaterial(logo_mat)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(w / 2 - 256 / 2, (h / 2 - 256 / 2) - 15 - 30, 256, 256)
	end

	function logo_content:PerformLayout(w,h)
		logo_btn:SetPos(w / 2 - 150 / 2, (h / 2 - 256 / 2) + 185 + 15)
	end

	local function ShowUsergroups(account_id)
		if (IsValid(logo_content)) then
			logo_content:Remove()
		end

		if (IsValid(main_content.Content)) then
			main_content.Content:Remove()
		end
		main_content.Content = vgui.Create("bVGUI.ScrollPanel", main_content)
		main_content.Content:Dock(FILL)

		local btn = vgui.Create("bVGUI.ButtonContainer", main_content.Content)
		btn:Dock(TOP)
		btn:DockMargin(10,10,10,0)
		btn.Button:SetColor(bVGUI.COLOR_GMOD_BLUE)
		btn.Button:SetText(L"give_usergroup")
		btn.Button:SetWide(150)
		function btn.Button:DoClick()
			bVGUI.StringQuery(L"give_usergroup", nil, L"usergroup_ellipsis", function(usergroup)
				local switch = vgui.Create("bVGUI.Switch", main_content.Content)
				switch:DockMargin(10,10,10,0)
				switch:Dock(TOP)
				switch:SetText(usergroup)
				switch:SetChecked(true)
				function switch:OnChange()
					if (self:GetChecked()) then
						GAS:netStart("secondaryusergroups:GiveUsergroup")
					else
						GAS:netStart("secondaryusergroups:RevokeUsergroup")
					end

					net.WriteUInt(account_id, 31)
					net.WriteString(usergroup)

					net.SendToServer()
				end
				switch:OnChange()
			end)
		end

		local switch = vgui.Create("bVGUI.Switch", main_content.Content)
		switch:DockMargin(10,10,10,0)
		switch:Dock(TOP)
		switch:SetText(L"loading_ellipsis")
		switch:SetChecked(true)
		switch:SetDisabled(true)
		switch:SetHelpText(L"usergroup_is_main")

		local all_usergroups = SortedUsergroups()

		for _,usergroup in ipairs(all_usergroups) do
			local switch = vgui.Create("bVGUI.Switch", main_content.Content)
			switch:DockMargin(10,10,10,0)
			switch:Dock(TOP)
			switch:SetText(usergroup)
			switch:SetChecked(GAS.SecondaryUsergroups.AllData[account_id] ~= nil and GAS.SecondaryUsergroups.AllData[account_id][usergroup] == true)
			function switch:OnChange()
				if (self:GetChecked()) then
					GAS:netStart("secondaryusergroups:GiveUsergroup")
				else
					GAS:netStart("secondaryusergroups:RevokeUsergroup")
				end
				
				net.WriteUInt(account_id, 31)
				net.WriteString(usergroup)

				net.SendToServer()
			end
		end

		local main_usergroup
		local target_ply = player.GetByAccountID(account_id)
		if (IsValid(target_ply)) then
			switch:SetText(target_ply:GetUserGroup())
		else
			GAS.OfflinePlayerData:AccountID(account_id, function(success, data)
				if (success) then
					switch:SetText(data.usergroup)
				else
					switch:SetText(L"unknown")
				end
			end)
		end
	end

	function offline_btn:DoClick()
		GAS.SelectionPrompts:PromptAccountID(function(account_id, ply)
			category:AddAccountID(account_id, ShowUsergroups)
		end)
	end

	function main_content:PaintOver(w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
		surface.DrawTexturedRect(categories:GetWide(),0,10,h)
	end

	GAS:netStart("secondaryusergroups:GetAllData")
	net.SendToServer()

	GAS:netReceive("secondaryusergroups:GetAllData", function(l)
		GAS.SecondaryUsergroups.AllData = GAS:DeserializeTable(util.Decompress(net.ReadData(l)))
		categories:SetLoading(false)
		for account_id, usergroups in pairs(GAS.SecondaryUsergroups.AllData) do
			category:AddAccountID(account_id, ShowUsergroups)
		end
	end)
end)