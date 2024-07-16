local function L(phrase, ...)
	if (#({...}) > 0) then
		return GAS:Phrase(phrase, "fpsbooster")
	else
		return GAS:PhraseFormat(phrase, "fpsbooster", ...)
	end
end

if (GAS.FPSBooster and IsValid(GAS.FPSBooster.Menu)) then
	GAS.FPSBooster.Menu:Close()
end

GAS.FPSBooster = {}

GAS.FPSBooster.Optimizations = {
	{
		name = "show_fps",
		commands = {
			cl_showfps = 1
		}
	},

	{
		name = "multicore_rendering",
		help_text = "multicore_rendering_help",
		commands = {
			gmod_mcore_test = 1,
			mat_queue_mode = -1,
			cl_threaded_bone_setup = 1,
			cl_threaded_client_leaf_system = 1,
			r_queued_ropes = 1,
			r_threaded_renderables = 1,
			r_threaded_particles = 1,
			r_threaded_client_shadow_manager = 1,
			studio_queue_mode = 1
		}
	},

	{
		name = "hardware_acceleration",
		commands = {
			r_fastzreject = -1
		}
	},

	{
		name = "disable_skybox",
		commands = {
			r_3dsky = 0,
		}
	},

	{
		name = "sprays",
		commands = {
			cl_playerspraydisable = 1,
			r_spray_lifetime = 0,
		}
	},

	{
		name = "gibs",
		help_text = "gibs_help",
		commands = {
			cl_phys_props_enable = 0,
			cl_phys_props_max = 0,
			props_break_max_pieces = 0,
			r_propsmaxdist = 1,
			violence_agibs = 0,
			violence_hgibs = 0,
		}
	},
}

function GAS.FPSBooster:OpenMenu(show_dont_show_again)
	if (IsValid(GAS.FPSBooster.Menu)) then
		GAS.FPSBooster.Menu:Close()
	end

	GAS.FPSBooster.Menu = vgui.Create("bVGUI.Frame")
	GAS.FPSBooster.Menu:SetTitle(L"fps_booster")
	GAS.FPSBooster.Menu:SetSize(500,280)
	GAS.FPSBooster.Menu:Center()
	GAS.FPSBooster.Menu:MakePopup()

	local scroll = vgui.Create("bVGUI.ScrollPanel", GAS.FPSBooster.Menu)
	scroll:Dock(FILL)

	for _,optimization in ipairs(GAS.FPSBooster.Optimizations) do
		local switch = vgui.Create("bVGUI.Switch", scroll)
		switch:Dock(TOP)
		switch:SetText(L(optimization.name))
		if (optimization.help_text) then
			switch:SetHelpText(L(optimization.help_text))
		end
		switch:DockMargin(10,10,10,0)
		local setting_on = cookie.GetNumber("gmodadminsuite:FPSBooster:" .. optimization.name, 0) == 1
		switch:SetChecked(setting_on)
		if (setting_on) then
			for command, value in pairs(optimization.commands) do
				local convar = GetConVar(command)
				if (convar) then
					RunConsoleCommand(command, value)
					GAS:print("[FPS Booster] " .. command .. " " .. value, GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)
				else
					GAS:print("[FPS Booster] Convar " .. command .. " does not exist", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
				end
			end
		end
		function switch:OnChange()
			if (self:GetChecked() == true) then
				cookie.Set("gmodadminsuite:FPSBooster:" .. optimization.name, 1)
				for command, value in pairs(optimization.commands) do
					local convar = GetConVar(command)
					if (convar) then
						RunConsoleCommand(command, value)
						GAS:print("[FPS Booster] " .. command .. " " .. value, GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)
					else
						GAS:print("[FPS Booster] Convar " .. command .. " does not exist", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
					end
				end
			else
				cookie.Set("gmodadminsuite:FPSBooster:" .. optimization.name, 0)
				for command, value in pairs(optimization.commands) do
					local convar = GetConVar(command)
					if (convar) then
						local default = tonumber(convar:GetDefault())
						if (default) then
							RunConsoleCommand(command, default)
							GAS:print("[FPS Booster] " .. command .. " " .. default, GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)
						end
					else
						GAS:print("[FPS Booster] Convar " .. command .. " does not exist", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
					end
				end
			end
		end
	end

	if (show_dont_show_again) then
		local dont_show_again = vgui.Create("bVGUI.ButtonContainer", scroll)
		dont_show_again:Dock(TOP)
		dont_show_again:DockMargin(0,20,0,0)
		dont_show_again.Button:SetSize(180,30)
		dont_show_again.Button:SetText(L"never_show_again")
		dont_show_again.Button:SetColor(bVGUI.BUTTON_COLOR_RED)
		dont_show_again.Button:SetTooltip({Text = L"never_show_again_tip"})
		dont_show_again.Button:SetSound("delete")
		function dont_show_again.Button:DoClick()
			cookie.Set("gmodadminsuite:FPSBooster:disable", "1")
		end

		local padding = vgui.Create("bVGUI.BlankPanel", scroll)
		padding:Dock(TOP)
		padding:SetTall(20)
	end
end

GAS:hook("gmodadminsuite:ModuleMenu:fpsbooster", "FPSBooster:menu", function()
	GAS.FPSBooster:OpenMenu()
	return true
end)

if (not GAS_FPS_BOOSTER_INITPOSTENTITY) then
	if (cookie.GetNumber("gmodadminsuite:FPSBooster:disable", 0) ~= 1) then
		GAS:InitPostEntity(function()
			GAS_FPS_BOOSTER_INITPOSTENTITY = true
			GAS.FPSBooster:OpenMenu(true)
		end)
	end
end