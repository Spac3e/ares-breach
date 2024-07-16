local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase)
	else
		return GAS:PhraseFormat(phrase, nil, ...)
	end
end

hook.Add("PopulateMenuBar", "gmodadminsuite.menubar", function(p)
	p.GASMenu = p:AddOrGetMenu("GmodAdminSuite")

	p.GASMenu:AddOption(L"open_gas", function()
		RunConsoleCommand("gmodadminsuite")
	end):SetIcon("icon16/shield.png")

	p.GASMenu:AddSpacer()

	for ident, tab in pairs(GAS.Modules.Info) do
		hook.Add("gmodadminsuite:LoadModule:"..ident, "gmodadminsuite.menubar", function()
			p.GASMenu:AddOption(tab.Name, function()
				GAS:PlaySound("popup")
				RunConsoleCommand("gmodadminsuite", ident)
			end):SetIcon(tab.Icon)
			hook.Remove("gmodadminsuite:LoadModule:"..ident, "gmodadminsuite.menubar")
		end)
	end
end)