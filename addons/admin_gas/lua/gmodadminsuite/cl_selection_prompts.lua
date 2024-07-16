local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase)
	else
		return GAS:PhraseFormat(phrase, nil, ...)
	end
end

GAS.SelectionPrompts = {}

function GAS.SelectionPrompts:PromptTeam(callback, _menu, muted)
	if (not muted) then GAS:PlaySound("btn_light") end

	local menu = _menu or DermaMenu()

	if (DarkRP) then
		local categories = {}
		for i,c in ipairs(DarkRP.getCategories().jobs) do
			if (GAS:table_IsEmpty(c.members)) then continue end
			table.insert(categories, {members = c.members, name = c.name, color = c.color})
		end
		table.SortByMember(categories, "name", true)
		for i,v in ipairs(categories) do
			local submenu, _submenu = menu:AddSubMenu(v.name)
			bVGUI_DermaMenuOption_ColorIcon(_submenu, v.color)

			local teams = {}
			for i,t in ipairs(v.members) do
				table.insert(teams, {index = t.team, name = t.name})
			end
			table.SortByMember(teams, "name", true)
			for i,v in ipairs(teams) do
				bVGUI_DermaMenuOption_ColorIcon(submenu:AddOption(v.name, function()
					callback(v.index)
					if (not muted) then GAS:PlaySound("btn_heavy") end
				end), team.GetColor(v.index))
			end
		end
	else
		local teams = {}
		for i,t in ipairs(team.GetAllTeams()) do
			table.insert(teams, {index = i, name = t.Name})
		end
		table.SortByMember(teams, "name", true)
		for i,v in ipairs(teams) do
			bVGUI_DermaMenuOption_ColorIcon(menu:AddOption(v.name, function()
				callback(v.index)
				if (not muted) then GAS:PlaySound("btn_heavy") end
			end), team.GetColor(v.index))
		end
	end

	if (not _menu) then	menu:Open() end
end

function GAS.SelectionPrompts:PromptLuaFunction(callback, _menu, muted)
	if (not muted) then GAS:PlaySound("btn_light") end

	local menu = _menu or DermaMenu()
	local lua_function_names = table.GetKeys(GAS.LuaFunctions)
	table.sort(lua_function_names)
	for i,lua_function_name in ipairs(lua_function_names) do
		bVGUI_DermaMenuOption_GreenToRed(i, #lua_function_names, menu:AddOption(lua_function_name, function()
			callback(lua_function_name, GAS.LuaFunctions[lua_function_name])
			if (not muted) then GAS:PlaySound("btn_heavy") end
		end))
	end
	if (not _menu) then	menu:Open() end
end

function GAS.SelectionPrompts:PromptUsergroup(callback, _menu, muted)
	if (not muted) then GAS:PlaySound("btn_light") end

	local menu = _menu or DermaMenu()
	menu:AddOption(L"custom_ellipsis", function()
		bVGUI.StringQuery(L"add_usergroup", nil, L"usergroup_ellipsis", function(usergroup)
			callback(usergroup)
		end)
	end):SetIcon("icon16/pencil.png")
	menu:AddSpacer()
	local usergroups = {}
	for _,ply in ipairs(player.GetHumans()) do
		for v in pairs(OpenPermissions:GetUserGroups(ply)) do
			usergroups[v] = true
		end
	end
	usergroups = table.GetKeys(usergroups)
	table.sort(usergroups)
	for i,v in ipairs(usergroups) do
		bVGUI_DermaMenuOption_GreenToRed(i, #usergroups, menu:AddOption(v, function()
			callback(v)
			if (not muted) then GAS:PlaySound("btn_heavy") end
		end))
	end
	if (not _menu) then	menu:Open() end
end

function GAS.SelectionPrompts:PromptSteamID64(callback, _menu, muted)
	print("PromptSteamID64 is deprecated")
	GAS.SelectionPrompts:PromptAccountID(function(account_id, ...)
		callback(GAS:AccountIDToSteamID64(account_id, ...))
	end, _menu, play_sound)
end

function GAS.SelectionPrompts:PromptAccountID(callback, _menu, muted, filter)
	if (not muted) then GAS:PlaySound("btn_light") end

	local menu = _menu or DermaMenu()
	menu:AddOption(L"steamid_ellipsis", function()
		bVGUI.StringQuery(L"add_steamid", L("add_steamid_help", LocalPlayer():SteamID(), LocalPlayer():SteamID64()), L"enter_steamid_ellipsis", function(text)
			if (text:find("^STEAM_%d:%d:%d+$")) then
				local ply = player.GetBySteamID(text)
				if (IsValid(ply)) then
					callback(GAS:SteamIDToAccountID(text), ply)
				else
					callback(GAS:SteamIDToAccountID(text))
				end
			elseif (text:find("^7656119%d+$")) then
				local ply = player.GetBySteamID64(text)
				if (IsValid(ply)) then
					callback(GAS:SteamID64ToAccountID(text), ply)
				else
					callback(GAS:SteamID64ToAccountID(text))
				end
			end
		end, function(text)
			if (text:find("^STEAM_%d:%d:%d+$") or text:find("^7656119%d+$")) then
				return true
			end
		end)
	end):SetIcon("materials/gmodadminsuite/steam.png")
	menu:AddSpacer()

	local distance_submenu, pnl = menu:AddSubMenu(L"by_distance") pnl:SetIcon("icon16/world.png")
	local usergroups_submenu, pnl = menu:AddSubMenu(L"by_usergroup") pnl:SetIcon("icon16/group.png")
	local jobs_submenu, pnl = menu:AddSubMenu(L"by_team") pnl:SetIcon("icon16/user_suit.png")
	local players_submenu, pnl = menu:AddSubMenu(L"by_name") pnl:SetIcon("icon16/emoticon_grin.png")

	local stuff_to_add = {
		usergroups = {},
		jobs = {},
		players = {},
		distances = {}
	}
	for _,ply in ipairs(player.GetHumans()) do
		if (filter and filter[ply]) then continue end
		
		table.insert(stuff_to_add.players, {account_id = ply:AccountID(), nick = ply:Nick(), ply = ply})
		table.insert(stuff_to_add.distances, {distance = ply:GetPos():DistToSqr(LocalPlayer():GetPos()), account_id = ply:AccountID(), nick = ply:Nick(), ply = ply})

		local team_name = gteams.GetName(ply:GTeam())
		stuff_to_add.jobs[team_name] = stuff_to_add.jobs[team_name] or {}
		table.insert(stuff_to_add.jobs[team_name], {account_id = ply:AccountID(), nick = ply:Nick(), ply = ply})

		for v in pairs(OpenPermissions:GetUserGroups(ply)) do
			stuff_to_add.usergroups[v] = stuff_to_add.usergroups[v] or {}
			table.insert(stuff_to_add.usergroups[v], {account_id = ply:AccountID(), nick = ply:Nick(), ply = ply})
		end
	end

	local usergroups = table.GetKeys(stuff_to_add.usergroups)
	table.sort(usergroups)
	local jobs = table.GetKeys(stuff_to_add.jobs)
	table.sort(jobs)
	local players = stuff_to_add.players
	table.SortByMember(players, "nick")
	local distances = stuff_to_add.distances
	table.SortByMember(distances, "distance")

	local function PlayerInfoOverlay(option, ply)
		function option:OnCursorEntered()
			if (not IsValid(ply)) then return end
			bVGUI.PlayerTooltip.Create({
				canfocus = false,
				player = ply,
				copiedphrase = L"copied",
				focustip = L"right_click_to_focus",
				creator = self
			})
		end
		function option:OnCursorExited()
			bVGUI.PlayerTooltip.Close()
		end
		option.OnMouseReleased_Old = option.OnMouseReleased
		function option:OnMouseReleased(mouse)
			if (mouse == MOUSE_RIGHT) then
				bVGUI.PlayerTooltip.Focus()
			end
			option:OnMouseReleased_Old(mouse)
		end
	end
	for _,ply in ipairs(distances) do
		local option = distance_submenu:AddOption(ply.nick, function()
			if (not muted) then GAS:PlaySound("btn_heavy") end
			callback(ply.account_id, ply.ply)
		end)
		bVGUI_DermaMenuOption_ColorIcon(option, gteams.GetColor(ply.ply:GTeam()))
		PlayerInfoOverlay(option, ply.ply)
	end
	for _,ply in ipairs(players) do
		local option = players_submenu:AddOption(ply.nick, function()
			if (not muted) then GAS:PlaySound("btn_heavy") end
			callback(ply.account_id, ply.ply)
		end)
		bVGUI_DermaMenuOption_ColorIcon(option, gteams.GetColor(ply.ply:GTeam()))
		PlayerInfoOverlay(option, ply.ply)
	end
	for i,usergroup in ipairs(usergroups) do
		local submenu, _ = usergroups_submenu:AddSubMenu(usergroup)
		bVGUI_DermaMenuOption_GreenToRed(i, #usergroups, _)
		table.SortByMember(stuff_to_add.usergroups[usergroup], "nick")
		for _,ply in ipairs(stuff_to_add.usergroups[usergroup]) do
			local option = submenu:AddOption(ply.nick, function()
				if (not muted) then GAS:PlaySound("btn_heavy") end
				callback(ply.account_id, ply.ply)
			end)
			bVGUI_DermaMenuOption_ColorIcon(option, gteams.GetColor(ply.ply:GTeam()))
			PlayerInfoOverlay(option, ply.ply)
		end
	end
	for _,job in ipairs(jobs) do
		local submenu, submenu_option = jobs_submenu:AddSubMenu(job)
		bVGUI_DermaMenuOption_ColorIcon(submenu_option, gteams.GetColor(GAS:TeamFromName(job)))
		table.SortByMember(stuff_to_add.jobs[job], "nick")
		for _,ply in ipairs(stuff_to_add.jobs[job]) do
			local option = submenu:AddOption(ply.nick, function()
				if (not muted) then GAS:PlaySound("btn_heavy") end
				callback(ply.account_id, ply.ply)
			end)
			bVGUI_DermaMenuOption_ColorIcon(option, gteams.GetColor(ply.ply:GTeam()))
			PlayerInfoOverlay(option, ply.ply)
		end
	end

	if (not _menu) then	menu:Open() end
end