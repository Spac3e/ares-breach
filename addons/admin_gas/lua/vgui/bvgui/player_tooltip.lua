--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/player_tooltip.lua

--]]

if (bVGUI.PlayerTooltip) then
	if (IsValid(bVGUI.PlayerTooltip.Panel)) then
		bVGUI.PlayerTooltip.Panel:Remove()
	end
end

bVGUI.PlayerTooltip = {}
bVGUI.PlayerTooltip.Close = function()
	if (IsValid(bVGUI.PlayerTooltip.Panel)) then
		if (bVGUI.PlayerTooltip.Panel.Focused ~= true) then
			bVGUI.PlayerTooltip.Panel:Remove()
		end
	end
end
bVGUI.PlayerTooltip.Create = function(options)
	if (IsValid(bVGUI.PlayerTooltip.Panel)) then
		if (bVGUI.PlayerTooltip.Panel.Focused ~= true) then
			bVGUI.PlayerTooltip.Panel:Remove()
		end
	end

	if (not IsValid(options.player) and options.account_id) then
		local ply = player.GetByAccountID(options.account_id)
		if (IsValid(ply)) then
			options.player = ply
		end
	elseif (not IsValid(options.player) and options.steamid64) then
		local ply = player.GetBySteamID64(options.steamid64)
		if (IsValid(ply)) then
			options.player = ply
		end
	end

	local data = {}
	data.nick = "Loading..."
	data.usergroup = "Loading..."
	data.team_name = "(offline)"
	data.team_color = bVGUI.BUTTON_COLOR_RED
	if (IsValid(options.player)) then
		data.account_id = options.player:AccountID()
		data.steamid = options.player:SteamID()
		data.steamid64 = options.player:SteamID64()
		data.team_name = gteams.GetName(options.player:GTeam())
		data.team_color = gteams.GetColor(options.player:GTeam())
		data.nick = options.player:Nick()
		data.usergroup = options.player:GetUserGroup()
	elseif (options.steamid64) then
		data.account_id = GAS:SteamID64ToAccountID(options.steamid64)
		data.steamid = util.SteamIDFrom64(options.steamid64)
		data.steamid64 = options.steamid64
	elseif (options.account_id) then
		data.account_id = options.account_id
		data.steamid = GAS:AccountIDToSteamID(options.account_id)
		data.steamid64 = util.SteamIDTo64(data.steamid)
	end

	bVGUI.PlayerTooltip.Panel = vgui.Create("bVGUI.Frame")
	local pnl = bVGUI.PlayerTooltip.Panel
	pnl.Options = options
	pnl.CreatorPanel = options.creator
	pnl:ShowFullscreenButton(false)
	pnl:SetSize(316, 234)
	pnl:SetPos(gui.MouseX() + 15, gui.MouseY() + 15)
	pnl:DockPadding(10,24 + 10,10,10)
	pnl:MakePopup()
	pnl:SetMouseInputEnabled(false)
	pnl:SetKeyBoardInputEnabled(false)
	pnl:SetDrawOnTop(true)
	if (options.focustip) then
		pnl:SetTitle(data.nick .. " · " .. options.focustip)
	else
		pnl:SetTitle(data.nick)
	end
	pnl.OriginalTitle = data.nick

	pnl.OldPaint = pnl.Paint
	function pnl:Paint(w,h)
		if (not self.Focused) then
			surface.SetAlphaMultiplier(0.5)
		end
		self:OldPaint(w,h)

		if (self.Focused ~= true) then
			self:SetPos(gui.MouseX() + 15, gui.MouseY() + 15)
		end

		if (not self.Focused) then
			if (not system.HasFocus()) then
				self:Remove()
			elseif (self.CreatorPanel) then
				if (not IsValid(self.CreatorPanel)) then
					self:Remove()
				elseif (vgui.GetHoveredPanel() ~= self.CreatorPanel) then
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
	end

	local avatar_container = vgui.Create("bVGUI.BlankPanel", pnl)
	avatar_container:SetMouseInputEnabled(true)
	avatar_container:Dock(LEFT)
	avatar_container:DockMargin(0,0,10,0)
	avatar_container:SetWide(110)

	local avatar = vgui.Create("AvatarImage", avatar_container)
	avatar:Dock(TOP)
	avatar:SetSize(avatar_container:GetWide(), avatar_container:GetWide())
	if (IsValid(options.player)) then
		avatar:SetPlayer(options.player, 128)
	else
		avatar:SetSteamID(data.steamid64, 128)
	end

	local usergroup = vgui.Create("bVGUI.InfoBar", avatar_container)
	usergroup:Dock(TOP)
	usergroup:DockMargin(0,10,0,10)
	usergroup:SetText(data.usergroup)
	usergroup:AllowCopy(options.copiedphrase)
	usergroup:SetColor(bVGUI.INFOBAR_COLOR_PURPLE)
	bVGUI.AttachTooltip(usergroup, {Text = "Usergroup"})

	local job = vgui.Create("bVGUI.InfoBar", avatar_container)
	job:Dock(TOP)
	job:DockMargin(0,0,0,10)
	job:SetText(data.team_name)
	job:AllowCopy(options.copiedphrase)
	job:SetColor(data.team_color)
	if (DarkRP) then
		bVGUI.AttachTooltip(job, {Text = "Job"})
	else
		bVGUI.AttachTooltip(job, {Text = "Team"})
	end

	local info_container = vgui.Create("bVGUI.BlankPanel", pnl)
	info_container:Dock(FILL)
	info_container:SetMouseInputEnabled(true)
	info_container.SIG = true

	local nick = vgui.Create("bVGUI.InfoBar", info_container)
	nick:Dock(TOP)
	nick:DockMargin(0,0,0,10)
	nick:SetText(data.nick)
	nick:AllowCopy(options.copiedphrase)
	nick:SetColor(bVGUI.INFOBAR_COLOR_PURPLE)

	local steamid = vgui.Create("bVGUI.InfoBar", info_container)
	steamid:Dock(TOP)
	steamid:DockMargin(0,0,0,10)
	steamid:SetText(data.steamid)
	steamid:AllowCopy(options.copiedphrase)

	local steamid64 = vgui.Create("bVGUI.InfoBar", info_container)
	steamid64:Dock(TOP)
	steamid64:DockMargin(0,0,0,10)
	steamid64:SetText(data.steamid64)
	steamid64:AllowCopy(options.copiedphrase)

	local steam_profile = vgui.Create("bVGUI.Button", info_container)
	steam_profile:Dock(TOP)
	steam_profile:DockMargin(0,0,0,10)
	steam_profile:SetText(bVGUI.L("open_steam_profile"))
	steam_profile:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	function steam_profile:DoClick()
		if (GAS) then
			GAS:OpenURL("https://steamcommunity.com/profiles/" .. steamid64:GetText())
		else
			gui.OpenURL("https://steamcommunity.com/profiles/" .. steamid64:GetText())
		end
	end

	local context_menu = vgui.Create("bVGUI.Button", info_container)
	context_menu:Dock(TOP)
	context_menu:DockMargin(0,0,0,10)
	context_menu:SetText(bVGUI.L("open_context_menu"))
	context_menu:SetColor(bVGUI.BUTTON_COLOR_RED)
	context_menu:SetDisabled(not IsValid(options.player))
	function context_menu:DoClick()
		if (IsValid(options.player)) then
			if (GAS) then GAS:PlaySound("popup") end
			properties.OpenEntityMenu(options.player, LocalPlayer():GetEyeTrace())
		else
			if (GAS) then GAS:PlaySound("error") end
			self:SetDisabled(true)
		end
	end
	
	if (not IsValid(options.player)) then
		pnl.GetPlayerData = function()
			GAS:untimer("PlayerTooltip:Load:" .. data.account_id)
			GAS.OfflinePlayerData:AccountID(tonumber(data.account_id), function(success, offline_data)
				if (not IsValid(pnl)) then return end
				if (success) then
					pnl.OriginalTitle = offline_data.nick
					nick:SetText(offline_data.nick)
					usergroup:SetText(offline_data.usergroup)
					if (options.focustip) then
						pnl:SetTitle(offline_data.nick .. " · " .. options.focustip)
					else
						pnl:SetTitle(offline_data.nick)
					end
				else
					pnl.OriginalTitle = bVGUI.L("unknown")
					nick:SetText(bVGUI.L("unknown"))
					usergroup:SetText(bVGUI.L("unknown"))
					if (options.focustip) then
						pnl:SetTitle(bVGUI.L("unknown") .. " · " .. options.focustip)
					else
						pnl:SetTitle(bVGUI.L("unknown"))
					end
				end
			end)
			pnl.GetPlayerData = nil
		end
		if (GAS.OfflinePlayerData.data[data.account_id] ~= nil) then
			pnl.GetPlayerData()
		else
			GAS:timer("PlayerTooltip:Load:" .. data.account_id, .5, 1, function()
				if (not IsValid(pnl)) then return end
				pnl.GetPlayerData()
			end)
		end
	end

	return pnl
end
bVGUI.PlayerTooltip.Focus = function()
	if (IsValid(bVGUI.PlayerTooltip.Panel)) then
		if (GAS) then GAS:PlaySound("flash") end
		bVGUI.PlayerTooltip.Panel.Focused = true
		bVGUI.PlayerTooltip.Panel:MakePopup()
		bVGUI.PlayerTooltip.Panel:MoveToFront()
		bVGUI.PlayerTooltip.Panel:SetTitle(bVGUI.PlayerTooltip.Panel.OriginalTitle)
		bVGUI.PlayerTooltip.Panel:SetDrawOnTop(false)
		if (bVGUI.PlayerTooltip.Panel.GetPlayerData) then
			bVGUI.PlayerTooltip.Panel.GetPlayerData()
		end
	end
end

bVGUI.PlayerTooltip.Attach = function(pnl, options)
	options.creator = pnl
	if (pnl.bVGUI_PlayerTooltipOptions) then
		pnl.bVGUI_PlayerTooltipOptions = options
		return
	else
		pnl.bVGUI_PlayerTooltipOptions = options
	end

	pnl.bVGUI_PLAYER_TOOLTIP_OLD_CURSOR_ENTER = pnl.OnCursorEntered
	pnl.bVGUI_PLAYER_TOOLTIP_OLD_CURSOR_EXIT = pnl.OnCursorExited
	function pnl:OnCursorEntered(...)
		bVGUI.PlayerTooltip.Create(self.bVGUI_PlayerTooltipOptions)
		if (self.bVGUI_PLAYER_TOOLTIP_OLD_CURSOR_ENTER) then self.bVGUI_PLAYER_TOOLTIP_OLD_CURSOR_ENTER(self, ...) end
	end
	function pnl:OnCursorExited(...)
		bVGUI.PlayerTooltip.Close()
		if (self.bVGUI_PLAYER_TOOLTIP_OLD_CURSOR_EXIT) then self.bVGUI_PLAYER_TOOLTIP_OLD_CURSOR_EXIT(self, ...) end
	end
end

bVGUI.PlayerTooltip.Unattach = function(pnl)
	pnl.bVGUI_PlayerTooltipOptions = nil
	pnl.OnCursorEntered = pnl.bVGUI_PLAYER_TOOLTIP_OLD_CURSOR_ENTER
	pnl.OnCursorExited = pnl.bVGUI_PLAYER_TOOLTIP_OLD_CURSOR_EXIT
end