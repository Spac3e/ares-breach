BREACH.Msg("Comparing languages\n", CLR_MSG_PINK)

function BREACH.CompareLanguage(lang)
	local no_translations = {}
	for k, v in pairs(russian) do
		local found = false
		for _, ass in pairs(lang) do
			if _ == k then
				found = true
			end
		end
		if !found then
			no_translations[k] = v
		end
	end

	return no_translations
end

local function AutoComplete(cmd, stringargs)
	local tbl = {}
    for k, v in pairs(ALLLANGUAGES) do
    	table.insert(tbl, "breach_compare_language "..tostring(k))
    end
    return tbl
end

concommand.Add("breach_compare_language",
	function(ply, cmd, args, argstr)
		if !ALLLANGUAGES[args[1]] then
			BREACH.Msg("language not found: "..args[1]..'\n', CLR_MSG_RED)
			return
		end
		local tbl = BREACH.CompareLanguage(ALLLANGUAGES[args[1]])
		if #table.GetKeys(tbl) > 0 then
			PrintTable(tbl)
			BREACH.Msg("found "..#table.GetKeys(tbl)..'missing phrases\n', CLR_MSG_YELLOW)
		else
			BREACH.Msg("language is up to date", CLR_MSG_GREEN)
		end
	end,
AutoComplete)

local obsolete_found = false
for k, v in pairs(ALLLANGUAGES) do
	local tbl = BREACH.CompareLanguage(v)

	if #table.GetKeys(tbl) > 0 then
		BREACH.Msg("Language "..tostring(k).." is obsolete. Found "..#table.GetKeys(tbl).." missing phrases\n", CLR_MSG_RED)
		obsolete_found = true
	else
		BREACH.Msg("Language "..tostring(k).." is up to date\n", CLR_MSG_GREEN)
	end
end

if obsolete_found then
	BREACH.Msg("Use command breach_compare_language (language) to get missing phrases\n", CLR_MSG_YELLOW)
else
	BREACH.Msg("All languages are up to date\n", CLR_MSG_GREEN)
end
