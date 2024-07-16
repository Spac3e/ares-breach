local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "commands")
	else
		return GAS:PhraseFormat(phrase, "commands", ...)
	end
end

GAS:netReceive("commands:no_permission", function()
	chat.AddText(Color(255,0,0), L"no_permission")
end)

GAS:netReceive("commands:ACTION_GAS_MODULE", function()
	RunConsoleCommand("gmodadminsuite", net.ReadString())
end)

GAS:netReceive("commands:ACTION_WEBSITE", function()
	GAS:OpenURL(net.ReadString())
end)

GAS:netReceive("commands:ACTION_LUA_FUNCTION", function()
	GAS:RunLuaFunction(net.ReadString(), LocalPlayer(), net.ReadString())
end)

function GAS.Commands:OpenMenu(show_settings, ModuleFrame)
	if (IsValid(GAS.Commands.Menu)) then
		GAS.Commands.Menu:Close()
	end

	if (IsValid(ModuleFrame)) then
		GAS.Commands.Menu = ModuleFrame
	else
		GAS.Commands.Menu = vgui.Create("bVGUI.Frame")
		GAS.Commands.Menu:SetSize(650,450)
		GAS.Commands.Menu:Center()
		GAS.Commands.Menu:SetTitle(L"commands")
		GAS.Commands.Menu:MakePopup()
	end

	local main_content, main_tab, new_command_content, new_command_tab
	if (show_settings) then
		GAS.Commands.Menu.Tabs = vgui.Create("bVGUI.Tabs", GAS.Commands.Menu)
		GAS.Commands.Menu.Tabs:Dock(TOP)
		GAS.Commands.Menu.Tabs:SetTall(0)

		main_content, main_tab = GAS.Commands.Menu.Tabs:AddTab("", Color(0,0,0))
		new_command_content, new_command_tab = GAS.Commands.Menu.Tabs:AddTab("", Color(0,0,0))

		new_command_tab:SetFunction(function()
			if (IsValid(new_command_content.Content)) then new_command_content.Content:Remove() end
			if (IsValid(new_command_content.BtnContainer)) then new_command_content.BtnContainer:Remove() end

			new_command_content.BtnContainer = vgui.Create("DPanel", new_command_content)
			new_command_content.BtnContainer:Dock(BOTTOM)
			new_command_content.BtnContainer:SetTall(45)
			function new_command_content.BtnContainer:Paint(w,h)
				surface.SetDrawColor(bVGUI.COLOR_DARKER_GREY)
				surface.DrawRect(0,0,w,h)
			end
			function new_command_content.BtnContainer:PerformLayout()
				local w = (self:GetWide() - self.Cancel:GetWide() - 10 - self.Finished:GetWide() - 10 - self.Wiki:GetWide()) / 2

				self.Cancel:AlignLeft(w)
				w = w + self.Cancel:GetWide() + 10 self.Finished:AlignLeft(w)
				w = w + self.Finished:GetWide() + 10 self.Wiki:AlignLeft(w)

				self.Cancel:CenterVertical()
				self.Finished:CenterVertical()
				self.Wiki:CenterVertical()
			end

			new_command_content.BtnContainer.Finished = vgui.Create("bVGUI.Button", new_command_content.BtnContainer)
			new_command_content.BtnContainer.Finished:SetColor(bVGUI.BUTTON_COLOR_GREEN)
			new_command_content.BtnContainer.Finished:SetText(L"finished")
			new_command_content.BtnContainer.Finished:SetSize(125,25)
			new_command_content.BtnContainer.Finished:SetDisabled(true)
			function new_command_content.BtnContainer.Finished:DoVerification()
				local problem
				local command_name = new_command_content.Content.CommandName:GetValue():lower()
				if (GAS.Commands.Config.Commands[command_name] and not new_command_content.Content.Editing) then
					problem = L"error_command_exists"
				elseif (#command_name == 0) then
					problem = L"error_no_command"
				elseif (not new_command_content.Content.Action:GetSelected()) then
					problem = L"error_no_action"
				else
					local action_i = new_command_content.Content.Action:GetSelectedID() - 1
					local val_elem = new_command_content.Content.ActionValue
					if (IsValid(val_elem)) then
						if (action_i == GAS.Commands.ACTION_TELEPORT and (val_elem.TelePos == nil or val_elem.TeleAng == nil)) then
							problem = L"error_no_position_set"
						elseif ((action_i == GAS.Commands.ACTION_LUA_FUNCTION_SV or action_i == GAS.Commands.ACTION_LUA_FUNCTION_CL) and not val_elem:GetSelected()) then
							problem = L"error_no_lua_function"
						elseif (action_i == GAS.Commands.ACTION_GAS_MODULE and not val_elem:GetSelected()) then
							problem = L"error_no_gas_module"
						elseif (action_i == GAS.Commands.ACTION_WEBSITE and (#val_elem:GetValue() == 0 or not val_elem:GetValue():lower():find("^https?://.+%..+"))) then
							problem = L"error_invalid_website"
						elseif (action_i == GAS.Commands.ACTION_CHAT and #val_elem:GetValue() == 0) then
							problem = L"error_no_chat_msg"
						elseif (action_i == GAS.Commands.ACTION_COMMAND and #val_elem:GetValue() == 0) then
							problem = L"error_no_command_execute"
						end
					end
				end
				if (not problem) then
					new_command_content.BtnContainer.Finished:SetDisabled(false)
					bVGUI.UnattachTooltip(new_command_content.BtnContainer.Finished)
				else
					new_command_content.BtnContainer.Finished:SetDisabled(true)
					bVGUI.AttachTooltip(new_command_content.BtnContainer.Finished, {Text = problem})
				end
			end
			function new_command_content.BtnContainer.Finished:DoClick()
				GAS:PlaySound("success")
				GAS:netReceive("commands:NewCommand", function()
					if (not IsValid(main_tab)) then return end
					main_tab:OnMouseReleased(MOUSE_LEFT)
					net.Receivers["gmodadminsuite:commands:NewCommand"] = nil
				end)
				GAS:netStart("commands:NewCommand")
					net.WriteString(new_command_content.Content.CommandName:GetValue())
					net.WriteString(new_command_content.Content.Help:GetValue())
					net.WriteBool(new_command_content.Content.HideInChat:GetChecked())
					net.WriteUInt(new_command_content.Content.Action:GetSelectedID(), 4)
					if (IsValid(new_command_content.Content.ActionValue)) then
						if (new_command_content.Content.Action:GetSelectedID() - 1 == GAS.Commands.ACTION_TELEPORT) then
							net.WriteVector(new_command_content.Content.ActionValue.TelePos)
							net.WriteAngle(new_command_content.Content.ActionValue.TeleAng)
						else
							if (new_command_content.Content.ActionValue.GetSelectedID ~= nil) then
								net.WriteString(new_command_content.Content.ActionValue:GetOptionData(new_command_content.Content.ActionValue:GetSelectedID()) or new_command_content.Content.ActionValue:GetValue())
							else
								net.WriteString(new_command_content.Content.ActionValue:GetValue())
							end
						end
					end
					if (new_command_content.Content.CommandName.OldCommandName ~= nil) then
						net.WriteBool(true)
						net.WriteString(new_command_content.Content.CommandName.OldCommandName)
					else
						net.WriteBool(false)
					end
				net.SendToServer()
				bVGUI.MouseInfoTooltip.Create(L"saved_exclamation")
			end

			new_command_content.BtnContainer.Cancel = vgui.Create("bVGUI.Button", new_command_content.BtnContainer)
			new_command_content.BtnContainer.Cancel:SetColor(bVGUI.BUTTON_COLOR_RED)
			new_command_content.BtnContainer.Cancel:SetText(L"cancel")
			new_command_content.BtnContainer.Cancel:SetSize(125,25)
			function new_command_content.BtnContainer.Cancel:DoClick()
				GAS:PlaySound("error")
				main_tab:OnMouseReleased(MOUSE_LEFT)
			end

			new_command_content.BtnContainer.Wiki = vgui.Create("bVGUI.Button", new_command_content.BtnContainer)
			new_command_content.BtnContainer.Wiki:SetColor(bVGUI.BUTTON_COLOR_BLUE)
			new_command_content.BtnContainer.Wiki:SetText(L"wiki")
			new_command_content.BtnContainer.Wiki:SetDisabled(true)
			new_command_content.BtnContainer.Wiki:SetSize(125,25)
			function new_command_content.BtnContainer.Wiki:DoClick()
				GAS:OpenURL("https://gmodsto.re/gmodadminsuite-commands-wiki")
			end

			new_command_content.Content = vgui.Create("bVGUI.ColumnLayout", new_command_content)
			new_command_content.Content:Dock(FILL)
			new_command_content.Content:DockMargin(10,10,10,10)
			new_command_content.Content:SetPaddings(10,10)
			new_command_content.Content:SetColumns(bVGUI.COLUMN_LAYOUT_COLUMN_GROW, bVGUI.COLUMN_LAYOUT_COLUMN_SHRINK)

			local label
			local font = bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16)

			label = vgui.Create("DLabel", new_command_content.Content)
			label:SetContentAlignment(7)
			label:SetFont(font)
			label:SetTextColor(bVGUI.COLOR_WHITE)
			label:SetText(L"command")
			label:SizeToContents()

			new_command_content.Content.CommandName = vgui.Create("bVGUI.TextEntry", new_command_content.Content)
			new_command_content.Content.CommandName:SetSize(300,25)
			new_command_content.Content.CommandName:SetPlaceholderText("!command")
			new_command_content.Content.CommandName:DockPadding(0,0,0,10)
			new_command_content.Content.CommandName:SetUpdateOnType(true)
			new_command_content.Content.CommandName.OnValueChange = new_command_content.BtnContainer.Finished.DoVerification
			bVGUI.AttachTooltip(new_command_content.Content.CommandName, {Text = L"commands_case_insensitive"})

			new_command_content.Content:AddRow(label, new_command_content.Content.CommandName)

			--=======================================================================--

			label = vgui.Create("DLabel", new_command_content.Content)
			label:SetContentAlignment(7)
			label:SetFont(font)
			label:SetTextColor(bVGUI.COLOR_WHITE)
			label:SetText(L"help")
			label:SizeToContents()

			new_command_content.Content.Help = vgui.Create("bVGUI.TextEntry", new_command_content.Content)
			new_command_content.Content.Help:SetMultiline(true)
			new_command_content.Content.Help:SetContentAlignment(7)
			new_command_content.Content.Help:SetSize(300,90)
			new_command_content.Content.Help:SetPlaceholderText(L"form_help")
			new_command_content.Content.Help:DockPadding(0,0,0,10)
			bVGUI.AttachTooltip(new_command_content.Content.Help, {Text = L"form_help_tip"})

			new_command_content.Content:AddRow(label, new_command_content.Content.Help)

			--=======================================================================--

			label = vgui.Create("DLabel", new_command_content.Content)
			label:SetContentAlignment(7)
			label:SetFont(font)
			label:SetTextColor(bVGUI.COLOR_WHITE)
			label:SetText(L"hide_in_chat")
			label:SizeToContents()

			new_command_content.Content.HideInChat = vgui.Create("bVGUI.Checkbox", new_command_content.Content)
			new_command_content.Content.HideInChat:SetChecked(true)
			bVGUI.AttachTooltip(new_command_content.Content.HideInChat, {Text = L"hide_in_chat_tip"})

			new_command_content.Content:AddRow(label, new_command_content.Content.HideInChat)

			--=======================================================================--

			label = vgui.Create("DLabel", new_command_content.Content)
			label:SetContentAlignment(7)
			label:SetFont(font)
			label:SetTextColor(bVGUI.COLOR_WHITE)
			label:SetText(L"action")
			label:SizeToContents()

			new_command_content.Content.Action = vgui.Create("DComboBox", new_command_content.Content)
			new_command_content.Content.Action:SetValue(L"select_action")
			new_command_content.Content.Action:SetTall(25)
			new_command_content.Content.Action:SetSortItems(false)
			new_command_content.Content.Action:AddChoice(L"action_open_commands_menu")
			new_command_content.Content.Action:AddChoice(L"action_command")
			new_command_content.Content.Action:AddChoice(L"action_chat")
			new_command_content.Content.Action:AddChoice(L"action_website")
			new_command_content.Content.Action:AddChoice(L"action_teleport")
			new_command_content.Content.Action:AddChoice(L"action_lua_function_sv")
			new_command_content.Content.Action:AddChoice(L"action_lua_function_cl")
			new_command_content.Content.Action:AddChoice(L"action_gas_module")

			function new_command_content.Content.Action:OnSelect(_i, v)
				if (self.ActionValueIndex) then
					new_command_content.Content:RemoveRow(self.ActionValueIndex)
					self.ActionValueIndex = nil
				end

				local i = _i - 1
				if (i == GAS.Commands.ACTION_COMMANDS_MENU) then
					new_command_content.BtnContainer.Finished:DoVerification()
					return
				end

				local label = vgui.Create("DLabel", new_command_content.Content)
				label:SetContentAlignment(7)
				label:SetFont(font)
				label:SetTextColor(bVGUI.COLOR_WHITE)

				local val_elem

				if (i == GAS.Commands.ACTION_COMMAND) then

					label:SetText(L"form_action_command")
					label:SizeToContents()

					val_elem = vgui.Create("bVGUI.TextEntry", new_command_content.Content)
					val_elem:SetSize(300,25)

				elseif (i == GAS.Commands.ACTION_CHAT) then

					label:SetText(L"form_action_chat")
					label:SizeToContents()

					val_elem = vgui.Create("bVGUI.TextEntry", new_command_content.Content)
					val_elem:SetSize(300,25)

				elseif (i == GAS.Commands.ACTION_WEBSITE) then

					label:SetText(L"form_action_website")
					label:SizeToContents()

					val_elem = vgui.Create("bVGUI.TextEntry", new_command_content.Content)
					val_elem:SetSize(300,25)

				elseif (i == GAS.Commands.ACTION_TELEPORT) then

					label:SetText(L"form_action_teleport")
					label:SizeToContents()

					val_elem = vgui.Create("bVGUI.Button", new_command_content.Content)
					val_elem:SetColor(bVGUI.BUTTON_COLOR_BLUE)
					val_elem:SetText(L"set_position")
					val_elem:SetSize(150,25)
					function val_elem:DoClick()
						GAS.Commands.Menu.bVGUI_PinButton:DoClick()
						notification.AddLegacy(L"set_position_instruction", NOTIFY_HINT, 7)
						notification.AddLegacy(L"set_position_instruction_2", NOTIFY_HINT, 7)
						function GAS.Commands.Menu:OnUnpinned()
							val_elem:SetColor(bVGUI.BUTTON_COLOR_GREEN)
							val_elem:SetText(L"position_set")
							val_elem.TelePos = LocalPlayer():GetPos()
							val_elem.TeleAng = LocalPlayer():GetAngles()
							new_command_content.BtnContainer.Finished:DoVerification()
						end
					end

				elseif (i == GAS.Commands.ACTION_GAS_MODULE) then

					label:SetText(L"form_action_gas_module")
					label:SizeToContents()

					val_elem = vgui.Create("bVGUI.ComboBox", new_command_content.Content)
					val_elem:SetSize(300,25)

				elseif (i == GAS.Commands.ACTION_LUA_FUNCTION_SV) then

					label:SetText(L"form_action_lua_function_sv")
					label:SizeToContents()

					val_elem = vgui.Create("DComboBox", new_command_content.Content)
					val_elem:SetSize(300,25)

				elseif (i == GAS.Commands.ACTION_LUA_FUNCTION_CL) then

					label:SetText(L"form_action_lua_function_cl")
					label:SizeToContents()

					val_elem = vgui.Create("DComboBox", new_command_content.Content)
					val_elem:SetSize(300,25)

				end

				if (i == GAS.Commands.ACTION_LUA_FUNCTION_SV or i == GAS.Commands.ACTION_LUA_FUNCTION_CL) then
					for lua_function_name in pairs(GAS.LuaFunctions) do
						val_elem:AddChoice(lua_function_name)
					end
					val_elem.OnSelect = new_command_content.BtnContainer.Finished.DoVerification
				elseif (i == GAS.Commands.ACTION_GAS_MODULE) then
					for module_name, info in pairs(GAS.Modules.Info) do
						val_elem:AddChoice(info.Name, module_name, false, info.Icon)
					end
					val_elem.OnSelect = new_command_content.BtnContainer.Finished.DoVerification
				elseif (i ~= GAS.Commands.ACTION_TELEPORT) then
					val_elem:SetUpdateOnType(true)
					val_elem.OnValueChange = new_command_content.BtnContainer.Finished.DoVerification
				end

				new_command_content.Content.ActionValue = val_elem
				self.ActionValueIndex = new_command_content.Content:AddRow(label, val_elem)

				new_command_content.BtnContainer.Finished:DoVerification()
			end

			new_command_content.Content:AddRow(label, new_command_content.Content.Action)
			
			new_command_content.BtnContainer.Finished:DoVerification()

			if (new_command_content.OnContentLoaded) then
				new_command_content:OnContentLoaded()
			end
		end)
	else
		main_content = GAS.Commands.Menu
	end

	GAS.Commands.Menu.Table = vgui.Create("bVGUI.Table", main_content)
	GAS.Commands.Menu.Table:Dock(FILL)
	GAS.Commands.Menu.Table:SetLoading(true)
	GAS.Commands.Menu.Table:AddColumn(L"command", bVGUI.TABLE_COLUMN_SHRINK)
	GAS.Commands.Menu.Table:AddColumn(L"action", bVGUI.TABLE_COLUMN_SHRINK)
	GAS.Commands.Menu.Table:AddColumn(L"help", bVGUI.TABLE_COLUMN_GROW)
	GAS.Commands.Menu.Table:SetRowCursor("hand")

	function GAS.Commands.Menu.Table:OnRowClicked(row)
		GAS:PlaySound("btn_heavy")
		local menu = DermaMenu()

		menu:AddOption(L"run_command", function()
			GAS:PlaySound("delete")
			RunConsoleCommand("say", row.Command)
		end):SetIcon("icon16/font_go.png")

		menu:AddOption(L"copy_command", function()
			GAS:SetClipboardText(row.Command)
		end):SetIcon("icon16/page_copy.png")

		if (show_settings) then
			menu:AddOption(L"edit_command", function()

				GAS:PlaySound("flash")

				function new_command_content:OnContentLoaded()
					self.OnContentLoaded = nil
					self.Content.Editing = true
					self.Content.CommandName:SetValue(row.Command)
					self.Content.CommandName.OldCommandName = row.Command
					local options = GAS.Commands.Config.Commands[row.Command]
					self.Content.Help:SetText(options.help or "")
					self.Content.Action:ChooseOptionID(options.action.type + 1)
					self.Content.HideInChat:SetChecked(options.hide_command)
					if (IsValid(self.Content.ActionValue)) then
						if (options.action.type == GAS.Commands.ACTION_LUA_FUNCTION_SV or options.action.type == GAS.Commands.ACTION_LUA_FUNCTION_CL) then
							if (GAS.LuaFunctions[options.action.lua_func_name]) then
								self.Content.ActionValue:ChooseOption(options.action.lua_func_name)
							end
						elseif (options.action.type == GAS.Commands.ACTION_GAS_MODULE) then
							for id, data in ipairs(self.Content.ActionValue.Data) do
								if (data == options.action.module_name) then
									self.Content.ActionValue:ChooseOptionID(id)
									break
								end
							end
						elseif (options.action.type == GAS.Commands.ACTION_COMMAND) then
							self.Content.ActionValue:SetValue(options.action.command)
						elseif (options.action.type == GAS.Commands.ACTION_CHAT) then
							self.Content.ActionValue:SetValue(options.action.chat)
						elseif (options.action.type == GAS.Commands.ACTION_WEBSITE) then
							self.Content.ActionValue:SetValue(options.action.website)
						elseif (options.action.type == GAS.Commands.ACTION_TELEPORT) then
							self.Content.ActionValue.TelePos = Vector(options.action.TelePosX, options.action.TelePosY, options.action.TelePosZ)
							self.Content.ActionValue.TeleAng = Angle(options.action.TeleAngP, options.action.TeleAngY, options.action.TeleAngR)
						end
					end
					self.BtnContainer.Finished:DoVerification()
				end
				new_command_tab:OnMouseReleased(MOUSE_LEFT)

			end):SetIcon("icon16/pencil.png")

			menu:AddOption(L"delete_command", function()
				GAS:PlaySound("delete")
				GAS:netStart("commands:DeleteCommand")
					net.WriteString(row.Command)
				net.SendToServer()
				GAS.Commands.Menu.Table:RemoveRow(row.RowIndex)
			end):SetIcon("icon16/delete.png")
		end
		menu:Open()
	end

	local function PopulateCommandsTable()
		GAS.Commands.Menu.Table:Clear()
		GAS.Commands.Menu.Table:SetLoading(true)
		GAS:GetConfig("commands", function(config)
			GAS.Commands.Config = config

			GAS.Commands.Menu.Table:SetLoading(false)
			for command, options in pairs(GAS.Commands.Config.Commands) do
				if (not OpenPermissions:HasPermission(LocalPlayer(), command)) then continue end
				local action_str = "Unknown"
				if (options.action.type == GAS.Commands.ACTION_COMMANDS_MENU) then
					action_str = L"action_open_commands_menu"
				elseif (options.action.type == GAS.Commands.ACTION_COMMAND) then
					action_str = L"action_command"
				elseif (options.action.type == GAS.Commands.ACTION_GAS_MODULE) then
					action_str = L"action_gas_module"
				elseif (options.action.type == GAS.Commands.ACTION_CHAT) then
					action_str = L"action_chat"
				elseif (options.action.type == GAS.Commands.ACTION_WEBSITE) then
					action_str = L"action_website"
				elseif (options.action.type == GAS.Commands.ACTION_TELEPORT) then
					action_str = L"action_teleport"
				elseif (options.action.type == GAS.Commands.ACTION_LUA_FUNCTION_SV) then
					action_str = L"action_lua_function_cl"
				elseif (options.action.type == GAS.Commands.ACTION_LUA_FUNCTION_CL) then
					action_str = L"action_lua_function_sv"
				end
				GAS.Commands.Menu.Table:AddRow(command, action_str, options.help or "").Command = command
			end
		end)
	end

	if (show_settings) then
		GAS.Commands.Menu.BtnContainer = vgui.Create("DPanel", main_content)
		GAS.Commands.Menu.BtnContainer:Dock(BOTTOM)
		GAS.Commands.Menu.BtnContainer:SetTall(45)
		function GAS.Commands.Menu.BtnContainer:Paint(w,h)
			surface.SetDrawColor(bVGUI.COLOR_DARKER_GREY)
			surface.DrawRect(0,0,w,h)
		end
		function GAS.Commands.Menu.BtnContainer:PerformLayout(_w, _h)
			local w,h = (_w - 125 - 10 - 125) / 2, (_h - 25) / 2
			self.Add:SetPos(w, h)
			self.Permissions:SetPos(w + 125 + 10, h)
		end

		GAS.Commands.Menu.BtnContainer.Add = vgui.Create("bVGUI.Button", GAS.Commands.Menu.BtnContainer)
		GAS.Commands.Menu.BtnContainer.Add:SetColor(bVGUI.BUTTON_COLOR_BLUE)
		GAS.Commands.Menu.BtnContainer.Add:SetText(L"new_command")
		GAS.Commands.Menu.BtnContainer.Add:SetSize(125,25)
		function GAS.Commands.Menu.BtnContainer.Add:DoClick()
			GAS:PlaySound("flash")
			new_command_tab:OnMouseReleased(MOUSE_LEFT)
		end

		GAS.Commands.Menu.BtnContainer.Permissions = vgui.Create("bVGUI.Button", GAS.Commands.Menu.BtnContainer)
		GAS.Commands.Menu.BtnContainer.Permissions:SetColor(bVGUI.BUTTON_COLOR_ORANGE)
		GAS.Commands.Menu.BtnContainer.Permissions:SetText(L"permissions")
		GAS.Commands.Menu.BtnContainer.Permissions:SetSize(125,25)
		function GAS.Commands.Menu.BtnContainer.Permissions:DoClick()
			GAS:PlaySound("popup")
			RunConsoleCommand("openpermissions", "gmodadminsuite_commands")
		end
		
		main_tab:SetFunction(PopulateCommandsTable)
		main_tab:OnMouseReleased(MOUSE_LEFT)
	else
		PopulateCommandsTable()
	end
end

GAS:netReceive("commands:ACTION_COMMANDS_MENU", function()
	GAS.Commands:OpenMenu(false)
end)

GAS:hook("gmodadminsuite:ModuleSize:commands", "commands:framesize", function()
	return 650,450
end)
GAS:hook("gmodadminsuite:ModuleFrame:commands", "commands:menu", function(ModuleFrame)
	GAS.Commands:OpenMenu(true, ModuleFrame)
end)