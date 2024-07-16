--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/lang/english.lua

--]]

return {
	Name = "English",
	Flag = "flags16/gb.png",
	Phrases = function() return {

		open_menu                 = "Open Menu",
		menu_nopermission         = "Sorry, but you do not have permission to access the GmodAdminSuite menu.",
		menu_unknown_module       = "Sorry, but a module with that name is not installed or does not exist.",
		menu_disabled_module      = "Sorry, but that module is disabled.",
		menu_module_nopermission  = "Sorry, you don't have permission to access this module.",
		open_gas                  = "Open GmodAdminSuite",
		module_shortcut           = "Module Shortcut",
		module_shortcut           = "Module Shortcut",
		module_shortcut_info      = [[You can quickly access this GmodAdminSuite module through console and chat commands.

		To access the module through your console, type: %s
		To access the module through chat, type: %s

		Additionally, you can bind a key on your keyboard to a specific module.
		To do this, in your console, type: %s

		Make sure to replace KEY with a key on your keyboard of your choice.
		%s]],
		close                     = "Close",
		wiki                      = "Wiki",
		licensee                  = "Licensee",
		support                   = "Support",
		module_shop               = "Module Shop",
		welcome                   = "Welcome",
		operator                  = "Operator",
		script_page               = "Script Page",
		wiki                      = "Wiki",
		no_modules_available      = "No modules available!",
		no_modules_available_info = [[Sorry, but there aren't any GmodAdminSuite modules available for you to use.
		You may have insufficient permissions to use any, or none are enabled.]],
		custom_ellipsis           = "Custom...",
		usergroup_ellipsis        = "Usergroup...",
		steamid_ellipsis          = "SteamID...",
		enter_steamid_ellipsis    = "Enter SteamID...",
		by_distance               = "By Distance",
		by_usergroup              = "By Usergroup",
		by_team                   = "By Team",
		by_name                   = "By Name",
		right_click_to_focus      = "Right click to focus",
		unknown                   = "Unknown",
		utilities                 = "Utilities",
		player_management         = "Player Management",
		administration            = "Administration",
		s_second                  = "1 second",
		s_seconds                 = "%d seconds",
		s_minute                  = "1 minute",
		s_minutes                 = "%d minutes",
		s_hour                    = "1 hour",
		s_hours                   = "%d hours",
		second_ago                = "1 second ago",
		seconds_ago               = "%d seconds ago",
		minute_ago                = "1 minute ago",
		minutes_ago               = "%d minutes ago",
		hour_ago                  = "1 hour ago",
		hours_ago                 = "%d hours ago",
		just_now                  = "Just now",
		click_to_focus            = "Click to focus",
		right_click_to_focus      = "Right click to focus",
		add_steamid               = "Custom SteamID",
		copied                    = "Copied!",
		settings                  = "Settings",
		add_steamid_help          = [[Enter a SteamID or SteamID64. Examples:
		SteamID: %s
		SteamID64: %s]],

		setting_default_module = "Default Module",
		setting_default_module_tip = "What module should be opened when the GmodAdminSuite main menu is opened?",
		none = "None",
		general = "General",
		localization = "Localization",
		setting_menu_voicechat = "Allow speaking (voice chat)\nwhen GAS menus are open",
		setting_menu_voicechat_tip = "GmodAdminSuite's menus do not block your voice chat key. If this option is on, just press your voice chat key to talk whilst in a menu.",
		use_gas_language = "Use GmodAdminSuite language",
		default_format = "Default Format",
		short_date_format = "Short Date Format",
		long_date_format = "Long Date Format",
		short_date_format_tip = "Date format used for shorter date formats\n\nThe default format automatically matches the date format of your region (North America, Europe, etc.)",
		long_date_format_tip = "Date format used for longer date formats",
		permissions = "Permissions",
		module_enable_switch_tip = "Changes to this will only apply after a server restart/map change",
		enabled = "Enabled",
		modules = "Modules",
		permissions_help = [[GmodAdminSuite utilizes an open-source permissions library called OpenPermissions, which was developed by Billy for GAS. It provides optimized permissions handling for advanced systems running on any sized server.
		
		OpenPermissions is where you will control what groups can access what modules, and what they can do with those modules.
		It can be opened at any time by typing "!openpermissions" in chat or "openpermissions" in console.

		For help & info, click the "Help" tab in the OpenPermissions menu.]],
		website = "Website",
		fun = "Fun",

		bvgui_copied               = "Copied!",
		bvgui_open_context_menu    = "Open Context Menu",
		bvgui_open_steam_profile   = "Open Steam Profile",
		bvgui_right_click_to_focus = "Right click to focus",
		bvgui_click_to_focus       = "Click to focus",
		bvgui_unknown              = "Unknown",
		bvgui_no_data              = "No data",
		bvgui_no_results_found     = "No results found",
		bvgui_done                 = "Done",
		bvgui_enter_text_ellipsis  = "Enter text...",
		bvgui_loading_ellipsis     = "Loading...",
		bvgui_pin_tip              = "Press ESC to click the menu again",
		bvgui_click_to_render      = "Click to render",
		bvgui_teleport             = "Teleport",
		bvgui_inspecting           = "Inspecting",
		bvgui_inspect              = "Inspect",
		bvgui_screenshot           = "Screenshot",
		bvgui_ok                   = "OK",
		bvgui_screenshot_saved     = "Screenshot Saved",
		bvgui_screenshot_saved_to  = "The screenshot has been saved to %s on your computer",
		bvgui_reset                = "Reset",
		bvgui_right_click_to_stop_rendering = "Right click to stop rendering",

} end }