if (GAS.Database.MySQLDatabase) then
	GAS.Database:Query([[

		CREATE TABLE IF NOT EXISTS `gas_steam_avatars` (
			`account_id` int(11) NOT NULL,
			`avatar` varchar(255) CHARACTER SET ascii NOT NULL,
			`last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (`account_id`)
		)

	]])
else
	GAS.Database:Query([[

		CREATE TABLE IF NOT EXISTS "gas_steam_avatars" (
			"account_id" INTEGER NOT NULL,
			"avatar" TEXT NOT NULL,
			"last_updated" INTEGER NOT NULL,
			PRIMARY KEY ("account_id")
		)

	]])
end

local cache = {}

local function GetAvatarFromAPI(account_id, callback)
	local steamid64 = GAS:AccountIDToSteamID64(account_id)
	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. GAS.SteamAPI.Config.APIKey .. "&steamids=" .. steamid64, function(body, size, headers, code)
		if (code == 403) then
			GAS:print("Your Steam API key is invalid!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS.SteamAPI.Config.APIKey = nil
		end
		if (size == 0 or #body == 0 or code ~= 200) then
			GAS:print("Couldn't fetch Steam avatar for user " .. steamid64 .. ": Invalid response", GAS.PRINT_WARNING)
			callback(false)
		else
			local parsed_json = util.JSONToTable(body)
			if (not parsed_json) then
				GAS:print("Couldn't fetch Steam avatar for user " .. steamid64 .. ": Invalid JSON", GAS.PRINT_WARNING)
				callback(false)
			else
				if (not parsed_json["response"] or not parsed_json["response"]["players"] or not parsed_json["response"]["players"][1] or not parsed_json["response"]["players"][1]["avatarfull"]) then
					GAS:print("Couldn't fetch Steam avatar for user " .. steamid64 .. ": Invalid data in JSON", GAS.PRINT_WARNING)
					callback(false)
				else
					local avatar = parsed_json["response"]["players"][1]["avatarfull"]
					cache[account_id] = {last_updated = os.time(), avatar = avatar}
					callback(true, avatar)

					GAS.Database:Prepare("REPLACE INTO gas_steam_avatars (`account_id`, `avatar`, `last_updated`) VALUES(?,?,CURRENT_TIMESTAMP())", {account_id, avatar})
				end
			end
		end
	end, function(err)
		GAS:print("Couldn't fetch Steam avatar for user " .. steamid64 .. ": " .. err, GAS.PRINT_WARNING)
		callback(false)
	end)
end

function GAS.SteamAPI:GetAvatar(account_id, callback)
	if (not GAS.SteamAPI.Config.APIKey or #GAS.SteamAPI.Config.APIKey == 0) then
		callback(false)
	elseif (cache[account_id]) then
		if (os.time() - cache[account_id].last_updated > GAS.SteamAPI.Config.Cache) then
			GetAvatarFromAPI(account_id, callback)
		else
			callback(true, cache[account_id].avatar)
		end
	else
		GAS.Database:Prepare("SELECT `avatar`, UNIX_TIMESTAMP(`last_updated`) AS 'last_updated' FROM gas_steam_avatars WHERE `account_id`=?", {account_id}, function(rows)
			if (#rows == 0 or os.time() - tonumber(rows[1].last_updated) > GAS.SteamAPI.Config.Cache) then
				GetAvatarFromAPI(account_id, callback)
			else
				callback(true, rows[1].avatar)
			end
		end)
	end
end