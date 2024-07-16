--[[


addons/[admin]_gmodadminsuite/lua/vgui/gas_adminsits_sitplayers.lua

--]]

local function L(phrase)
	return GAS:Phrase(phrase, "adminsits")
end

local function UI_PlayerLine_Paint(self, w, h)
	if (self.InvitedSysTime) then
		local frac = math.max(math.min((self.InvitedSysTime - SysTime()) / (30 + 1), 1), 0)
		surface.SetDrawColor((1 - frac) * 255, frac * 255, 0, 50)
		surface.DrawRect(0, 0, frac * w, h)
		if (frac <= 0) then
			self:GetParent():RemovePlayer(self.Player)
		end
	end

	if (self:IsHovered()) then
		self.AlphaUHStart = nil
		self.AlphaHStart = self.AlphaHStart or SysTime()

		self.Alpha_uh = nil
		self.Alpha_h = self.Alpha_h or self.Alpha or 0

		self.Alpha = Lerp(math.TimeFraction(self.AlphaHStart, self.AlphaHStart + .15, SysTime()), self.Alpha_h, 25)
	else
		self.AlphaHStart = nil
		self.AlphaUHStart = self.AlphaUHStart or SysTime()

		self.Alpha_h = nil
		self.Alpha_uh = self.Alpha_h or self.Alpha or 0

		self.Alpha = Lerp(math.TimeFraction(self.AlphaUHStart, self.AlphaUHStart + .15, SysTime()), self.Alpha_uh, 0)
	end
	surface.SetDrawColor(255, 255, 255, self.Alpha)
	surface.DrawRect(1,1,w-2,h-2)

	if (not self.Lerp_TextColor) then
		self.Lerp_TextColor = Color(255,255,255)
	end

	if (self:IsHovered()) then
		self.Lerp_HoverTime = self.Lerp_HoverTime or SysTime()
		self.Lerp_UnhoverTime = nil

		self.TextLerp_uh_r = nil
		self.TextLerp_h_r = self.TextLerp_h_r or self.Lerp_TextColor.r

		self.TextLerp_uh_g = nil
		self.TextLerp_h_g = self.TextLerp_h_g or self.Lerp_TextColor.g

		self.TextLerp_uh_b = nil
		self.TextLerp_h_b = self.TextLerp_h_b or self.Lerp_TextColor.b
		
		local f = math.TimeFraction(self.Lerp_HoverTime, self.Lerp_HoverTime + .15, SysTime())
		self.Lerp_TextColor.r = Lerp(f, self.TextLerp_h_r, self.TeamColor.r)
		self.Lerp_TextColor.g = Lerp(f, self.TextLerp_h_g, self.TeamColor.g)
		self.Lerp_TextColor.b = Lerp(f, self.TextLerp_h_b, self.TeamColor.b)
	else
		self.Lerp_UnhoverTime = self.Lerp_UnhoverTime or SysTime()
		self.Lerp_HoverTime = nil

		self.TextLerp_h_r = nil
		self.TextLerp_uh_r = self.TextLerp_uh_r or self.Lerp_TextColor.r

		self.TextLerp_h_g = nil
		self.TextLerp_uh_g = self.TextLerp_uh_g or self.Lerp_TextColor.g

		self.TextLerp_h_b = nil
		self.TextLerp_uh_b = self.TextLerp_uh_b or self.Lerp_TextColor.b
		
		local f = math.TimeFraction(self.Lerp_UnhoverTime, self.Lerp_UnhoverTime + .15, SysTime())
		self.Lerp_TextColor.r = Lerp(f, self.TextLerp_uh_r, 255)
		self.Lerp_TextColor.g = Lerp(f, self.TextLerp_uh_g, 255)
		self.Lerp_TextColor.b = Lerp(f, self.TextLerp_uh_b, 255)
	end

	self.Name:SetTextColor(self.Lerp_TextColor)
end

local PANEL = {}

function PANEL:Init()
	self.PlayerLines = GAS:Registry()
end

function PANEL:AddPlayer(ply, invited, country, OS)
	local this = self
	if (IsValid(self.PlayerLines[ply])) then
		local PlayerLine = self.PlayerLines[ply]
		if (country) then PlayerLine:SetCountry(country) end
		if (OS) then PlayerLine:SetOS(OS) end
		PlayerLine.Invited = invited
		PlayerLine.InvitedSysTime = invited and SysTime() + (invited - os.time())
		self:SortPlayerLines()
		return
	end

	local plyPromptFilter = {[ply] = true}

	local PlayerLine = vgui.Create("DPanel", self)
	self.PlayerLines(ply, PlayerLine)
	PlayerLine.Player = ply
	PlayerLine.Invited = invited
	PlayerLine.InvitedSysTime = invited and SysTime() + (invited - os.time())

	PlayerLine:Dock(TOP)
	PlayerLine:SetTall(16 + 10)
	PlayerLine:DockPadding(5, 5, 5, 5)
	PlayerLine:SetCursor("hand")
	PlayerLine.Paint = UI_PlayerLine_Paint
	PlayerLine.PaintOver = UI_PlayerLine_PaintOver
	PlayerLine.TeamColor = team.GetColor(ply:Team())
	function PlayerLine:DoClick()
		local menu = DermaMenu()
	
		menu:AddOption(L"SteamProfile", function()
			GAS:OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64())
		end):SetIcon("gmodadminsuite/steam.png")
		menu:AddOption(L"CopySteamID", function()
			GAS:SetClipboardText(ply:SteamID())
		end):SetIcon("gmodadminsuite/steam.png")
		menu:AddOption(L"CopySteamID64", function()
			GAS:SetClipboardText(ply:SteamID64())
		end):SetIcon("gmodadminsuite/steam.png")

		if (this.EnableSitControls ~= false) then
			menu:AddSpacer()

			if (ply == LocalPlayer() or (not GAS.AdminSits:IsStaff(ply) or GAS.AdminSits:CanTargetStaff(LocalPlayer()))) then
				if (ply ~= LocalPlayer()) then
					menu:AddOption(L"RemoveFromSit", function()
						GAS:PlaySound("delete")
						GAS:netStart("AdminSits.RemoveFromSit")
							net.WriteEntity(ply)
						net.SendToServer()
					end):SetIcon("icon16/delete.png")
				end

				menu:AddOption(L"TeleportToSit", function()
					GAS:netStart("AdminSits.TeleportPlayerToSit")
						net.WriteEntity(ply)
					net.SendToServer()
				end):SetIcon("icon16/lightning.png")
			end
			
			if (GAS.AdminSits:IsStaff(LocalPlayer()) and not GAS.AdminSits:IsStaff(ply)) then

				if (not ply:IsBot()) then
					menu:AddSpacer()

					local MicToggleOption
					local function ToggleMic()
						MicToggleOption.MicMuted = not MicToggleOption.MicMuted
						if (ply:GetNWBool("GAS_AdminSits_MicMuted", false) ~= MicToggleOption.MicMuted) then
							GAS:netStart("AdminSits.MuteMicrophone")
								net.WriteEntity(ply)
								net.WriteBool(MicToggleOption.MicMuted)
							net.SendToServer()
						end
						if (not MicToggleOption.MicMuted) then
							GAS:PlaySound("btn_on")
							MicToggleOption:SetIcon("icon16/sound_mute.png")
							MicToggleOption:SetText(L"MuteMicrophone")
						else
							GAS:PlaySound("btn_off")
							MicToggleOption:SetIcon("icon16/sound.png")
							MicToggleOption:SetText(L"UnmuteMicrophone")
						end
					end
					if (ply:GetNWBool("GAS_AdminSits_MicMuted")) then
						MicToggleOption = menu:AddOption(L"UnmuteMicrophone")
						MicToggleOption:SetIcon("icon16/sound.png")
						MicToggleOption.MicMuted = true
					else
						MicToggleOption = menu:AddOption(L"MuteMicrophone")
						MicToggleOption:SetIcon("icon16/sound_mute.png")
						MicToggleOption.MicMuted = false
					end
					function MicToggleOption:OnMouseReleased(m)
						DButton.OnMouseReleased(self, m)
						if (self.m_MenuClicking and m == MOUSE_LEFT) then
							self.m_MenuClicking = false
							ToggleMic()
						end
					end

					local ChatToggleOption
					local function ToggleChat()
						ChatToggleOption.ChatMuted = not ChatToggleOption.ChatMuted
						if (ply:GetNWBool("GAS_AdminSits_ChatMuted", false) ~= ChatToggleOption.ChatMuted) then
							GAS:netStart("AdminSits.DisableTextChat")
								net.WriteEntity(ply)
								net.WriteBool(ChatToggleOption.ChatMuted)
							net.SendToServer()
						end
						if (not ChatToggleOption.ChatMuted) then
							GAS:PlaySound("btn_on")
							ChatToggleOption:SetIcon("icon16/comments_delete.png")
							ChatToggleOption:SetText(L"DisableTextChat")
						else
							GAS:PlaySound("btn_off")
							ChatToggleOption:SetIcon("icon16/comments.png")
							ChatToggleOption:SetText(L"EnableTextChat")
						end
					end
					if (ply:GetNWBool("GAS_AdminSits_ChatMuted")) then
						ChatToggleOption = menu:AddOption(L"EnableTextChat")
						ChatToggleOption:SetIcon("icon16/comments.png")
						ChatToggleOption.ChatMuted = true
					else
						ChatToggleOption = menu:AddOption(L"DisableTextChat")
						ChatToggleOption:SetIcon("icon16/comments_delete.png")
						ChatToggleOption.ChatMuted = false
					end
					function ChatToggleOption:OnMouseReleased(m)
						DButton.OnMouseReleased(self, m)
						if (self.m_MenuClicking and m == MOUSE_LEFT) then
							self.m_MenuClicking = false
							ToggleChat()
						end
					end

					menu:AddSpacer()

					local CheckSteamFriends, _ = menu:AddSubMenu(L"CheckSteamFriends") _:SetIcon("icon16/emoticon_grin.png")
					GAS.SelectionPrompts:PromptAccountID(function(account_id)
						if (IsValid(ply)) then
							if (ply:AccountID() == account_id) then
								GAS:PlaySound("error")
							else
								local ply2 = player.GetByAccountID(account_id)
								if (not IsValid(ply2)) then
									GAS:PlaySound("error")
									Derma_Message(L"PlayerOfflineError", L"CheckSteamFriends" .. " - " .. ply:Nick(), L"Dismiss")
								else
									GAS:netStart("AdminSits.CheckSteamFriends")
										net.WriteEntity(ply)
										net.WriteEntity(ply2)
									net.SendToServer()
								end
							end
						else
							GAS:PlaySound("error")
							Derma_Message(L"PlayerOfflineError", L"CheckSteamFriends" .. " - " .. ply:Nick(), L"Dismiss")
						end
					end, CheckSteamFriends, true, plyPromptFilter)

					local CheckSteamFamShare, _ = menu:AddSubMenu(L"CheckSteamFamShare") _:SetIcon("icon16/group_go.png")
					GAS.SelectionPrompts:PromptAccountID(function(account_id)
						local ply2 = player.GetByAccountID(account_id)
						if (IsValid(ply) and IsValid(ply2) and ply:AccountID() ~= account_id) then
							GAS:netStart("AdminSits.CheckSteamFamilySharing")
								net.WriteEntity(ply)
								net.WriteEntity(ply2)
							net.SendToServer()
						end
					end, CheckSteamFamShare, true, plyPromptFilter)

					menu:AddOption(L"CheckSteamGroups", function()
						GAS:OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64() .. "/groups")
					end):SetIcon("icon16/house.png")

					menu:AddOption(L"CheckSteamAge", function()
						GAS.AdminSits.Steam:GetProfile(ply, function(profile)
							if (profile.MemberSince) then
								GAS:PlaySound("flash")
								Derma_Message((L"MemberSince"):format(profile.MemberSince), L"CheckSteamAge" .. " - " .. ply:Nick(), L"Dismiss")
							else
								GAS:PlaySound("error")
								Derma_Message(L"SteamProfile_CheckSteamAge_Failed", L"CheckSteamAge" .. " - " .. ply:Nick(), L"Dismiss")
							end
						end)
					end):SetIcon("icon16/cake.png")

					menu:AddOption(L"CheckValveBans", function()
						GAS.AdminSits.Steam:GetProfile(ply, function(profile)
							local msg = (L"VACBans"):format(profile.VACBans or L"Error") .. "\n"
									.. (L"GameBans"):format(profile.GameBans or L"Error") .. "\n"
									.. (L"LastBan"):format((profile.LastBan == false and L"Never") or profile.LastBan or L"Error") .. "\n"
									.. (L"TradeBanned"):format((profile.TradeBanned == nil and L"Error") or ((profile.TradeBanned and L"Yes") or L"No"))
							
							GAS:PlaySound("flash")
							Derma_Message(msg, L"CheckValveBans" .. " - " .. ply:Nick(), L"Dismiss")
						end)
					end):SetIcon("icon16/exclamation.png")

					menu:AddOption(L"CheckGmodPlaytime", function()
						GAS.AdminSits.Steam:GetProfile(ply, function(profile)
							if (profile.GmodPlaytime) then
								GAS:PlaySound("flash")
								Derma_Message((L"Hours"):format(profile.GmodPlaytime), L"CheckGmodPlaytime" .. " - " .. ply:Nick(), L"Dismiss")
							else
								GAS:PlaySound("error")
								Derma_Message(L"SteamProfile_CheckGmodPlaytime_Failed", L"CheckGmodPlaytime" .. " - " .. ply:Nick(), L"Dismiss")
							end
						end)
					end):SetIcon("icon16/clock.png")
				end

				menu:AddSpacer()

				menu:AddOption(L"CheckWeapons", function()
					local weps = ""
					for _,wep in ipairs(ply:GetWeapons()) do
						if (wep:GetClass() ~= "gas_weapon_hands") then
							if (wep.PrintName) then
								weps = weps .. wep.PrintName .. " ("  .. wep:GetClass() .. ")\n"
							else
								weps = weps .. wep:GetClass() .. "\n"
							end
						end
					end
					if (#weps == 0) then weps = L"NoWeapons" .. "\n" end

					Derma_Message(weps:sub(1,-2), L"CheckWeapons" .. " - " .. ply:Nick(), L"Dismiss")

					surface.PlaySound("npc/combine_soldier/gear5.wav")
				end):SetIcon("icon16/bomb.png")

				if (DarkRP and RPExtraTeams) then
					menu:AddOption(L"CheckWallet", function()
						Derma_Message(DarkRP.formatMoney(ply:getDarkRPVar("money")), L"CheckWallet" .. " - " .. ply:Nick(), L"Dismiss")
						GAS:PlaySound("flash")
					end):SetIcon("icon16/money.png")

					if (ply:HasWeapon("pocket")) then
						menu:AddOption(L"CheckPocket", function()
							GAS:netStart("AdminSits.CheckPocket")
								net.WriteEntity(ply)
							net.SendToServer()
						end):SetIcon("icon16/folder_find.png")
					end
				end

				if (not ply:IsBot()) then
					menu:AddSpacer()

					menu:AddOption(L"TakeScreenshot", function()
						GAS:PlaySound("flash")
						GAS:netStart("AdminSits.TakeScreenshot")
							net.WriteEntity(ply)
						net.SendToServer()

						notification.AddLegacy(L"TakingScreenshot", NOTIFY_GENERIC, 5)
					end):SetIcon("icon16/camera.png")

					if (GAS.AdminSits.SitPlayersWindowFocus[ply] == false) then
						menu:AddOption(L"FlashWindow", function()
							GAS:netStart("AdminSits.FlashWindow")
								net.WriteEntity(ply)
							net.SendToServer()
							
							GAS:PlaySound("btn_on")
						end):SetIcon("icon16/application_lightning.png")
					end
				end
			end
		end

		menu:Open()
		GAS:PlaySound("popup")
	end
	function PlayerLine:OnMousePressed(m)
		self.mousePressed = m
	end
	function PlayerLine:OnMouseReleased(m)
		if (self.mousePressed == m and m == MOUSE_LEFT) then
			self:DoClick()
		end
		self.mousePressed = nil
	end

	PlayerLine.Speaking = vgui.Create("DPanel", PlayerLine)
	PlayerLine.Speaking:Dock(LEFT)
	PlayerLine.Speaking:SetWide(16)
	PlayerLine.Speaking:SetMouseInputEnabled(false)
	PlayerLine.Speaking:DockMargin(1, 0, 4, 0)
	PlayerLine.Speaking:SetVisible(false)
	PlayerLine.Speaking.Paint = nil

	PlayerLine.Speaking.Icon = vgui.Create("DImage", PlayerLine.Speaking)
	PlayerLine.Speaking.Icon:Dock(FILL)
	PlayerLine.Speaking.Icon:SetImage("icon16/sound.png")

	PlayerLine.Typing = vgui.Create("DPanel", PlayerLine)
	PlayerLine.Typing:Dock(LEFT)
	PlayerLine.Typing:SetWide(16)
	PlayerLine.Typing:SetMouseInputEnabled(false)
	PlayerLine.Typing:DockMargin(1, 0, 4, 0)
	PlayerLine.Typing:SetVisible(false)
	PlayerLine.Typing.Paint = nil

	PlayerLine.Typing.Icon = vgui.Create("DImage", PlayerLine.Typing)
	PlayerLine.Typing.Icon:Dock(FILL)
	PlayerLine.Typing.Icon:SetImage("icon16/comment.png")

	PlayerLine.Avatar = vgui.Create("AvatarImage", PlayerLine)
	PlayerLine.Avatar:Dock(LEFT)
	PlayerLine.Avatar:SetMouseInputEnabled(false)
	PlayerLine.Avatar:SetWide(16)
	if (not ply:IsBot()) then PlayerLine.Avatar:SetSteamID(ply:SteamID64(), 32) end
	PlayerLine.Avatar:DockMargin(1, 0, 4, 0)

	PlayerLine.Name = vgui.Create("DLabel", PlayerLine)
	PlayerLine.Name:Dock(FILL)
	PlayerLine.Name:SetText(ply:Nick())
	PlayerLine.Name:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	PlayerLine.Name:SetTextColor(bVGUI.COLOR_WHITE)
	PlayerLine.Name:SetContentAlignment(4)

	if (GAS.AdminSits:IsStaff(ply)) then
		PlayerLine.PlayerStaffContainer = vgui.Create("DPanel", PlayerLine)
		PlayerLine.PlayerStaffContainer:SetWide(16)
		PlayerLine.PlayerStaffContainer:Dock(RIGHT)
		PlayerLine.PlayerStaffContainer:DockMargin(5, 0, 0, 0)
		PlayerLine.PlayerStaffContainer.Paint = nil

		PlayerLine.PlayerStaff = vgui.Create("DImage", PlayerLine.PlayerStaffContainer)
		PlayerLine.PlayerStaff:SetSize(16,16)
		PlayerLine.PlayerStaff:SetImage("icon16/shield.png")

		bVGUI.AttachTooltip(PlayerLine.PlayerStaff, { Text = L"Staff" })
	end

	PlayerLine.PlayerStatusContainer = vgui.Create("DPanel", PlayerLine)
	PlayerLine.PlayerStatusContainer:SetWide(16)
	PlayerLine.PlayerStatusContainer:Dock(RIGHT)
	PlayerLine.PlayerStatusContainer:DockMargin(5, 0, 0, 0)
	PlayerLine.PlayerStatusContainer.Paint = nil

	PlayerLine.PlayerStatus = vgui.Create("DImage", PlayerLine.PlayerStatusContainer)
	PlayerLine.PlayerStatus:SetSize(16,16)
	PlayerLine.PlayerStatus:SetImage("gmodadminsuite/circle_green.png")
	
	PlayerLine.PlayerStatusContainer.PerformLayout = function(self, w, h)
		PlayerLine.PlayerStatus:Center()
	end

	PlayerLine.FlagContainer = vgui.Create("DPanel", PlayerLine)
	PlayerLine.FlagContainer:SetVisible(false)
	PlayerLine.FlagContainer:SetWide(16)
	PlayerLine.FlagContainer:Dock(RIGHT)
	PlayerLine.FlagContainer:DockMargin(5, 0, 0, 0)
	PlayerLine.FlagContainer.Paint = nil

	PlayerLine.Flag = vgui.Create("DImage", PlayerLine.FlagContainer)
	PlayerLine.Flag:SetSize(16,11)

	bVGUI.AttachTooltip(PlayerLine.Flag, {Text = GAS.CountryCodes[country] or L"Unknown"})

	PlayerLine.FlagContainer.PerformLayout = function(self, w, h)
		PlayerLine.Flag:Center()
	end

	function PlayerLine:SetCountry(country)
		PlayerLine.FlagContainer:SetVisible(country and country ~= "XX" and file.Exists("materials/flags16/" .. country .. ".png", "GAME"))
		if (PlayerLine.FlagContainer:IsVisible()) then
			PlayerLine.Flag:SetImage("flags16/" .. country .. ".png")
		end
	end

	PlayerLine.OSContainer = vgui.Create("DPanel", PlayerLine)
	PlayerLine.OSContainer:SetVisible(false)
	PlayerLine.OSContainer:SetWide(16)
	PlayerLine.OSContainer:Dock(RIGHT)
	PlayerLine.OSContainer:DockMargin(5, 0, 0, 0)
	PlayerLine.OSContainer.Paint = nil

	PlayerLine.OS = vgui.Create("DImage", PlayerLine.OSContainer)
	PlayerLine.OS:SetSize(16,16)

	PlayerLine.OSContainer.PerformLayout = function(self, w, h)
		PlayerLine.OS:Center()
	end

	function PlayerLine:SetOS(OS)
		if (OS) then
			PlayerLine.OSContainer:SetVisible(true)
			if (OS == 0) then
				PlayerLine.OS:SetImage("gmodadminsuite/windows.png")
				bVGUI.AttachTooltip(PlayerLine.OS, {Text = "Windows"})
			elseif (OS == 1) then
				PlayerLine.OS:SetImage("icon16/tux.png")
				bVGUI.AttachTooltip(PlayerLine.OS, {Text = "Linux"})
			elseif (OS == 2) then
				PlayerLine.OS:SetImage("gmodadminsuite/osx.png")
				bVGUI.AttachTooltip(PlayerLine.OS, {Text = "Mac OS X"})
			end
		else
			PlayerLine.OSContainer:SetVisible(false)
		end
	end

	PlayerLine:SetOS(OS)
	PlayerLine:SetCountry(country)

	self:LayoutSize(true)
	self:SortPlayerLines()
end

function PANEL:RemovePlayer(ply)
	if (self.PlayerLines[ply]) then
		self.PlayerLines[ply]:Remove()
		self.PlayerLines(ply, nil)
		self:LayoutSize(false)
		self:SortPlayerLines()
	end
end

do
	local function SortByStatus(PlayerLines)
		local status_green = {}
		local status_amber = {}
		local status_red   = {}

		for _,_PlayerLine in ipairs(PlayerLines) do
			local PlayerLine = ispanel(_PlayerLine) and _PlayerLine or _PlayerLine.PlayerLine
			if (PlayerLine.PlayerStatus:GetImage() == "gmodadminsuite/circle_green.png") then
				table.insert(status_green, { nick = PlayerLine.Player:Nick(), PlayerLine = PlayerLine })
			elseif (PlayerLine.PlayerStatus:GetImage() == "gmodadminsuite/circle_orange.png") then
				table.insert(status_amber, { nick = PlayerLine.Player:Nick(), PlayerLine = PlayerLine })
			else
				table.insert(status_red, { nick = PlayerLine.Player:Nick(), PlayerLine = PlayerLine })
			end
		end

		table.SortByMember(status_green, "nick")
		table.SortByMember(status_amber, "nick")
		table.SortByMember(status_red, "nick")
		
		return status_green, status_amber, status_red
	end
	function PANEL:SortPlayerLines()
		local staff = {}
		local normies = {}
		local invited = {}

		for _,ply in self.PlayerLines:ipairs() do
			local PlayerLine = self.PlayerLines[ply]
			if (PlayerLine.Invited) then
				table.insert(invited, { Expires = PlayerLine.Invited, PlayerLine = PlayerLine })
			elseif (GAS.AdminSits:IsStaff(ply)) then
				table.insert(staff, PlayerLine)
			else
				table.insert(normies, PlayerLine)
			end
		end

		table.SortByMember(invited, "Expires")

		local g,a,r = SortByStatus(invited)
		for _,PlayerLine in ipairs(r) do PlayerLine.PlayerLine:MoveToBack() end
		for _,PlayerLine in ipairs(a) do PlayerLine.PlayerLine:MoveToBack() end
		for _,PlayerLine in ipairs(g) do PlayerLine.PlayerLine:MoveToBack() end

		local g,a,r = SortByStatus(normies)
		for _,PlayerLine in ipairs(r) do PlayerLine.PlayerLine:MoveToBack() end
		for _,PlayerLine in ipairs(a) do PlayerLine.PlayerLine:MoveToBack() end
		for _,PlayerLine in ipairs(g) do PlayerLine.PlayerLine:MoveToBack() end

		local g,a,r = SortByStatus(staff)
		for _,PlayerLine in ipairs(r) do PlayerLine.PlayerLine:MoveToBack() end
		for _,PlayerLine in ipairs(a) do PlayerLine.PlayerLine:MoveToBack() end
		for _,PlayerLine in ipairs(g) do PlayerLine.PlayerLine:MoveToBack() end

		self:InvalidateLayout()
	end
end

function PANEL:Think()
	for _,ply in self.PlayerLines:ipairs() do
		if (IsValid(ply)) then
			local PlayerLine = self.PlayerLines[ply]

			local plyIsSpeaking = ply:IsSpeaking() and (ply == LocalPlayer() or ply:VoiceVolume() > 0)
			if (plyIsSpeaking ~= PlayerLine.Speaking:IsVisible()) then
				PlayerLine.Speaking:SetVisible(plyIsSpeaking)
				PlayerLine.Speaking:InvalidateParent(true)
			end
			
			local plyIsTyping = ply:IsTyping()
			if (plyIsTyping ~= PlayerLine.Typing:IsVisible()) then
				PlayerLine.Typing:SetVisible(plyIsTyping)
				PlayerLine.Typing:InvalidateParent(true)
			end

			if (GAS.AdminSits.SitPlayersTimingOut[ply]) then
				if (PlayerLine.PlayerStatus:GetImage() ~= "gmodadminsuite/circle_red.png") then
					PlayerLine.PlayerStatus:SetImage("gmodadminsuite/circle_red.png")
					bVGUI.AttachTooltip(PlayerLine.PlayerStatus, {Text = L"PlayerLine_Unreachable"})
					self:SortPlayerLines()
				end
			elseif (GAS.AdminSits.SitPlayersWindowFocus[ply] == false or GAS.AFK:IsAFK(ply)) then
				if (PlayerLine.PlayerStatus:GetImage() ~= "gmodadminsuite/circle_orange.png") then
					PlayerLine.PlayerStatus:SetImage("gmodadminsuite/circle_orange.png")
					bVGUI.AttachTooltip(PlayerLine.PlayerStatus, {Text = L"PlayerLine_Inactive"})
					self:SortPlayerLines()
				end
			elseif (PlayerLine.PlayerStatus:GetImage() ~= "gmodadminsuite/circle_green.png") then
				PlayerLine.PlayerStatus:SetImage("gmodadminsuite/circle_green.png")
				bVGUI.UnattachTooltip(PlayerLine.PlayerStatus)
				self:SortPlayerLines()
			end
		else
			self:RemovePlayer(ply)
		end
	end
end

derma.DefineControl("GAS.AdminSits.SitPlayers", nil, PANEL, "bVGUI.BlankPanel")