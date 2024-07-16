--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/sh_offline_player_data.lua

--]]

AddCSLuaFile()

GAS.OfflinePlayerData = {callbacks = {}, data = {}}

if (CLIENT) then
	local function L(phrase, ...)
		if (#({...}) == 0) then
			return GAS:Phrase(phrase)
		else
			return GAS:PhraseFormat(phrase, ...)
		end
	end

	GAS:netReceive("offline_player_data", function()
		local account_id = net.ReadUInt(31)
		local nick = net.ReadString()
		local usergroup = net.ReadString()
		GAS.OfflinePlayerData.data[account_id] = {nick = nick, usergroup = usergroup}
		
		if (GAS.OfflinePlayerData.callbacks[account_id]) then
			for i,v in ipairs(GAS.OfflinePlayerData.callbacks[account_id]) do
				table.remove(GAS.OfflinePlayerData.callbacks[account_id], i)
				v(true, GAS.OfflinePlayerData.data[account_id])
			end
		end
	end)

	GAS:netReceive("offline_player_data_failed", function()
		local account_id = net.ReadUInt(31)
		GAS.OfflinePlayerData.data[account_id] = false

		if (GAS.OfflinePlayerData.callbacks[account_id]) then
			for i,v in ipairs(GAS.OfflinePlayerData.callbacks[account_id]) do
				table.remove(GAS.OfflinePlayerData.callbacks[account_id], i)
				v(false)
			end
		end
	end)

	GAS:InitPostEntity(function()
		if (system.GetCountry() and #system.GetCountry() > 0) then
			GAS:netStart("offline_player_data_country_code")
				net.WriteString(system.GetCountry())
			net.SendToServer()
		end
	end)
else
	GAS:untimer("offline_player_data_update")

	local cached_offline_data = {}

	GAS_OfflinePlayerData_CountryCodes = GAS_OfflinePlayerData_CountryCodes or {}
	function GAS.OfflinePlayerData:Update(ply)
		GAS.Database:Prepare("REPLACE INTO gas_offline_player_data (`server_id`, `account_id`, `nick`, `usergroup`, `ip_address`, `country_code`, `last_seen`) VALUES(?,?,?,?,?,?,CURRENT_TIMESTAMP())", {GAS.ServerID, ply:AccountID(), utf8.force(ply:Nick()), ply:GetUserGroup(), (ply:IPAddress():gsub(":%d+$","")), GAS_OfflinePlayerData_CountryCodes[ply] or NULL})
	end

	local function sql_init()
		GAS.Database:ServerID(function()
			local function update_data()
				GAS.Database:BeginTransaction()
				for _,ply in ipairs(player.GetHumans()) do
					local data_hash = util.CRC(ply:Nick() .. ply:GetUserGroup() .. ply:IPAddress() .. (GAS_OfflinePlayerData_CountryCodes[ply] or ""))
					if (data_hash ~= cached_offline_data[ply]) then
						cached_offline_data[ply] = data_hash
						GAS.OfflinePlayerData:Update(ply)
					end
				end
				GAS.Database:CommitTransaction()
			end
			update_data()
			GAS:timer("offline_player_data_update", 60, 0, update_data)
		end)
	end
	if (GAS.Database.MySQLDatabase) then
		GAS.Database:Query([[

			CREATE TABLE IF NOT EXISTS `gas_offline_player_data` (
				`server_id` int(11) NOT NULL,
				`account_id` int(11) UNSIGNED NOT NULL,
				`nick` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
				`usergroup` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
				`ip_address` varchar(15) CHARACTER SET ascii NOT NULL,
				`country_code` char(3) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
				`last_seen` timestamp NOT NULL,
				PRIMARY KEY (`server_id`, `account_id`)
			);

		]], function()

			GAS.Database:Query("SHOW COLUMNS FROM `gas_offline_player_data` WHERE `Field`='country_code'", function(rows)
				if (not rows or #rows == 0) then
					GAS.Database:Query("ALTER TABLE `gas_offline_player_data` ADD `country_code` CHAR(3) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL AFTER `ip_address`, ADD INDEX (`country_code`), ADD INDEX (`usergroup`), ADD INDEX (`ip_address`)", sql_init)
				else
					sql_init()
				end
			end)

		end)
	else
		GAS.Database:Query([[

			CREATE TABLE IF NOT EXISTS "gas_offline_player_data" (
				"server_id" INTEGER NOT NULL,
				"account_id" INTEGER NOT NULL,
				"nick" TEXT NOT NULL,
				"usergroup" TEXT NOT NULL,
				"ip_address" TEXT NOT NULL,
				"country_code" TEXT DEFAULT NULL,
				"last_seen" INTEGER NOT NULL,
				PRIMARY KEY ("server_id", "account_id")
			);

			CREATE INDEX IF NOT EXISTS gas_opd_usergroup_index ON gas_offline_player_data ("usergroup");
			CREATE INDEX IF NOT EXISTS gas_opd_country_code_index ON gas_offline_player_data ("country_code");
			CREATE INDEX IF NOT EXISTS gas_opd_ip_address_index ON gas_offline_player_data ("ip_address");

		]], function()

			GAS.Database:Query("PRAGMA table_info(`gas_offline_player_data`)", function(rows)
				local found = false
				for _,row in ipairs(rows) do
					if (row.name == "country_code") then
						found = true
						break
					end
				end
				if (not found) then
					GAS.Database:Query("ALTER TABLE `gas_offline_player_data` ADD COLUMN `country_code` TEXT DEFAULT NULL", sql_init)
				else
					sql_init()
				end
			end)

		end)
	end

	GAS:netInit("offline_player_data")
	GAS:netInit("offline_player_data_failed")

	GAS:netReceive("offline_player_data", function(ply)
		local account_id = net.ReadUInt(31)
		local target_ply = player.GetByAccountID(account_id)
		if (IsValid(target_ply)) then
			GAS:netStart("offline_player_data")
				net.WriteUInt(account_id, 31)
				net.WriteString(target_ply:Nick())
				net.WriteString(target_ply:GetUserGroup())
			net.Send(ply)
		else
			GAS.Database:Prepare("SELECT `nick`, `usergroup` FROM gas_offline_player_data WHERE `server_id`=? AND `account_id`=?", {GAS.ServerID, account_id}, function(rows)
				if (not rows or #rows == 0) then
					GAS:netStart("offline_player_data_failed")
						net.WriteUInt(account_id, 31)
					net.Send(ply)
				else
					GAS:netStart("offline_player_data")
						net.WriteUInt(account_id, 31)
						net.WriteString(rows[1].nick)
						net.WriteString(rows[1].usergroup)
					net.Send(ply)
				end
			end)
		end
	end)

	GAS:netInit("offline_player_data_country_code")
	GAS:netReceive("offline_player_data_country_code", function(ply)
		local country_code = net.ReadString()
		if (GAS_OfflinePlayerData_CountryCodes[ply]) then return end
		if (#country_code > 0 and #country_code <= 3) then
			GAS_OfflinePlayerData_CountryCodes[ply] = country_code
			GAS.Database:Prepare("UPDATE gas_offline_player_data SET `country_code`=? WHERE `account_id`=?", {country_code:upper(), ply:AccountID()})
		end
	end)

	GAS:hook("onPlayerChangedName", "offline_player_data:ChangeName", function(ply, _, name)
		GAS.Database:Prepare("UPDATE gas_offline_player_data SET `nick`=? WHERE `account_id`=?", {name, ply:AccountID()})
	end)
end

function GAS.OfflinePlayerData:SteamID64(steamid64, callback)
	print("deprecated", steamid64)
	debug.Trace()
	return GAS.OfflinePlayerData:AccountID(GAS:SteamID64ToAccountID(steamid64), callback)
end

function GAS.OfflinePlayerData:AccountID(account_id, callback)
	local ply = player.GetByAccountID(account_id)
	if (IsValid(ply)) then
		GAS.OfflinePlayerData.data[account_id] = {nick = ply:Nick(), usergroup = ply:GetUserGroup()}
		callback(true, GAS.OfflinePlayerData.data[account_id])
	else
		if (CLIENT) then
			if (GAS.OfflinePlayerData.data[account_id] ~= nil) then
				if (GAS.OfflinePlayerData.data[account_id] == false) then
					callback(false)
				else
					callback(true, GAS.OfflinePlayerData.data[account_id])
				end
			else
				GAS.OfflinePlayerData.callbacks[account_id] = GAS.OfflinePlayerData.callbacks[account_id] or {}
				table.insert(GAS.OfflinePlayerData.callbacks[account_id], callback)
				GAS:netStart("offline_player_data")
					net.WriteUInt(account_id, 31)
				net.SendToServer()
			end
		else
			GAS.Database:Prepare("SELECT `nick`, `usergroup` FROM gas_offline_player_data WHERE `server_id`=? AND `account_id`=?", {GAS.ServerID, account_id}, function(rows)
				if (#rows == 0) then
					callback(false)
				else
					callback(true, {nick = rows[1].nick, usergroup = rows[1].usergroup})
				end
			end)
		end
	end
end