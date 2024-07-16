local function L(phrase, ...)
	if (#({...}) > 0) then
		return GAS:Phrase(phrase)
	else
		return GAS:PhraseFormat(phrase, nil, ...)
	end
end

GAS.ContextProperties = {}
function GAS:ContextProperty(name, propertydata)
	GAS.ContextProperties[name] = propertydata
end

properties.Add("GmodAdminSuite", {
	MenuLabel = "GmodAdminSuite",
	MenuIcon = "icon16/shield.png",
	Filter = function(self, ent, ply)
		if (not IsValid(ent)) then return false end
		if (table.Count(GAS.ContextProperties) == 0) then return false end
		return true
	end,
	MenuOpen = function(self, option, ent, tr)
		local option_submenu = option:AddSubMenu()
		option_submenu:AddOption(L"open_menu", self.Action):SetIcon("icon16/application_form_magnify.png")
		local spacer = false
		for i,v in pairs(GAS.ContextProperties) do
			if (v.Filter and v.Filter(self, ent, LocalPlayer()) == false) then continue end
			if (not spacer) then spacer = true option_submenu:AddSpacer() end
			local submenu, submenu_pnl = option_submenu:AddSubMenu(v.MenuLabel, v.Action)
			if (v.MenuIcon) then
				submenu_pnl:SetIcon(v.MenuIcon)
			end
			if (v.MenuOpen) then
				v.MenuOpen(self, submenu, ent, tr, submenu_pnl)
			end
		end
	end,
	Action = function()
		RunConsoleCommand("gmodadminsuite")
	end
})