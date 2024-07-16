GAS.Database = {}

function GAS.Database:ServerTable(tbl_name, no_quotes)
	if (no_quotes) then
		return GAS.Database.ServerTablePrefix .. tbl_name
	else
		return "`" .. GAS.Database.ServerTablePrefix .. tbl_name .. "`"
	end
end

function GAS.Database:Escape(str, no_quotes)
	if (GAS.Database.MySQLDatabase) then
		if (no_quotes) then
			return GAS.Database.MySQLDatabase:escape(tostring(str))
		else
			return "'" .. GAS.Database.MySQLDatabase:escape(tostring(str)) .. "'"
		end
	else
		return sql.SQLStr(tostring(str), no_quotes)
	end
end
function GAS.Database:UglifyQuery(query)
	local new_query = (string.Trim(query):gsub("\n%s+", "\n"))
	if (not GAS.Database.MySQLDatabase) then
		new_query = (new_query:gsub("INSERT IGNORE", "INSERT OR IGNORE"):gsub("LAST_INSERT_ID%(%)", "last_insert_rowid()"):gsub("CURRENT_TIMESTAMP%(%)", "CURRENT_TIMESTAMP"):gsub("UNIX_TIMESTAMP%(%)", "strftime('%%s', 'now')"):gsub("UNIX_TIMESTAMP%((.-)%)", "strftime('%%s', %1)"))
	end
	return new_query
end

local function transaction_onSuccess(self)
	local queries = self:getQueries()
	if (not queries) then return end
	for i,v in pairs(queries) do
		if (v.onSuccess) then
			v.onSuccess(v, v:getData())
		end
	end
end

local function transaction_onError(self)
	local queries = self:getQueries()
	if (not queries) then return end
	for i,v in pairs(queries) do
		if (v.onSuccess) then
			v:onSuccess(v:getData())
		end
	end
	for i,v in ipairs(self:getQueries()) do
		if (#v:error() > 0) then
			if (v.onError) then
				v:onError(v:error())
			end
		end
	end
end

function GAS.Database:BeginTransaction()
	if (GAS.Database.MySQLDatabase) then
		GAS.Database.CurrentTransaction = GAS.Database.MySQLDatabase:createTransaction()
		GAS.Database.CurrentTransaction.onSuccess = transaction_onSuccess
		GAS.Database.CurrentTransaction.onError = transaction_onError
	else
		sql.Begin()
	end
end
function GAS.Database:CommitTransaction(onSuccess)
	if (GAS.Database.MySQLDatabase) then
		if (onSuccess) then
			GAS.Database.CurrentTransaction.onSuccess = onSuccess
		end
		GAS.Database.CurrentTransaction:start()
		GAS.Database.CurrentTransaction = nil
	else
		sql.Commit()
		if (onSuccess) then
			onSuccess()
		end
	end
end

function GAS.Database:Prepare(query, args, callback)
	query = GAS.Database:UglifyQuery(query)
	if (GAS.Database.MySQLDatabase) then
		local prepared = GAS.Database.MySQLDatabase:prepare(query)
		for i,v in ipairs(args) do
			if (type(v) == "string") then
				prepared:setString(i, v)
			elseif (type(v) == "number") then
				prepared:setNumber(i, v)
			elseif (v == NULL) then
				prepared:setNull(i)
			elseif (type(v) == "boolean") then
				prepared:setBoolean(i, v)
			end
		end
		if (callback) then
			prepared.onSuccess = function(_, data)
				callback(data, prepared:lastInsert())
			end
		end
		prepared.onError = function(_, err)
			GAS:print("A MySQL prepared statement error has occured!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS:print("Error: " .. err, GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS:print("Query:", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			MsgC(GAS_COLOR_WHITE, query .. "\n")
			PrintTable(args)
			debug.Trace()
		end
		if (GAS.Database.CurrentTransaction) then
			GAS.Database.CurrentTransaction:addQuery(prepared)
		else
			prepared:start()
		end
	else
		local new_query = ""
		local arg_num = 1
		local active_special_char
		for i = 1, #query do
			if (not active_special_char) then
				if (query[i] == "`" or query[i] == "'" or query[i] == "\"") then
					active_special_char = query[i]
				elseif (query[i] == "?") then
					if (args[arg_num] == NULL or args[arg_num] == nil) then
						new_query = new_query .. "NULL"
					else
						new_query = new_query .. sql.SQLStr(args[arg_num])
					end
					arg_num = arg_num + 1
					continue
				end
			else
				if (query[i] == active_special_char) then
					active_special_char = nil
				end
			end
			new_query = new_query .. query[i]
		end
		if (active_special_char ~= nil) then
			error("Unfinished " .. active_special_char .. " in SQL query:")
			print(query)
		end
		local data = sql.Query(new_query)
		if (data == false) then
			GAS:print("An SQLite prepared statement error has occured!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS:print("Error: " .. sql.LastError(), GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS:print("Query:", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			MsgC(GAS_COLOR_WHITE, new_query .. "\n")
			debug.Trace()
			return
		elseif (data == nil) then
			data = {}
		end
		for row_i, row in ipairs(data) do
			for column, value in pairs(row) do
				if (value == "NULL") then
					data[row_i][column] = nil
				end
			end
		end
		local last_insert_query = sql.Query("SELECT last_insert_rowid() AS 'last_insert'")
		local last_insert = nil
		if (last_insert_query) then
			if (last_insert_query[1]) then
				if (last_insert_query[1].last_insert) then
					last_insert = last_insert_query[1].last_insert
				end
			end
		end
		if (callback) then
			callback(data, tonumber(last_insert))
		end
	end
end
function GAS.Database:Query(query_sql, callback, get_last_insert)
	query_sql = GAS.Database:UglifyQuery(query_sql)
	if (GAS.Database.MySQLDatabase) then
		local query = GAS.Database.MySQLDatabase:query(query_sql)
		if (callback) then
			query.onSuccess = function(_, data)
				if (get_last_insert) then
					callback(data, query:lastInsert())
				else
					callback(data)
				end
			end
		end
		query.onError = function(_, err)
			GAS:print("A MySQL query error has occured!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS:print("Error: " .. err, GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS:print("Query:", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			MsgC(GAS_COLOR_WHITE, query_sql .. "\n")
			debug.Trace()
		end
		if (GAS.Database.CurrentTransaction) then
			GAS.Database.CurrentTransaction:addQuery(query)
		else
			query:start()
		end
	else
		local data = sql.Query(query_sql)
		if (data == false) then
			GAS:print("An SQLite query error has occured!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS:print("Error: " .. sql.LastError(), GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS:print("Query:", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			MsgC(GAS_COLOR_WHITE, query_sql .. "\n")
			debug.Trace()
			return
		elseif (data == nil) then
			data = {}
		end
		for row_i, row in ipairs(data) do
			for column, value in pairs(row) do
				if (value == "NULL") then
					data[row_i][column] = nil
				end
			end
		end
		if (get_last_insert) then
			local last_insert_query = sql.Query("SELECT last_insert_rowid() AS 'last_insert'")
			local last_insert = nil
			if (last_insert_query) then
				if (last_insert_query[1]) then
					if (last_insert_query[1].last_insert) then
						last_insert = last_insert_query[1].last_insert
					end
				end
			end
			if (callback) then
				callback(data, tonumber(last_insert))
			end
		elseif (callback) then
			callback(data)
		end
	end
end

local ServerID_Queue = {}
function GAS.Database:ServerID(callback)
	if (GAS.ServerID ~= nil) then
		callback()
	else
		table.insert(ServerID_Queue, callback)
	end
end

local function InitServerID()
	local function sql_init()
		local server_nick = GAS.Config.MySQL.ServerNickname or "Default"
		GAS.Database:Prepare("SELECT `id` FROM gas_servers WHERE `nickname`=?", {server_nick}, function(rows)
			local function got_id()
				for _,f in ipairs(ServerID_Queue) do f() end
				ServerID_Queue = {}

				GAS:InitPostEntity(function()
					GAS.Database:Prepare("UPDATE gas_servers SET `ip_address`=? WHERE `nickname`=?", {game.GetIPAddress(), server_nick})
				end)
				
				if (GAS.Database.MySQLDatabase) then
					GAS.Database:Prepare("REPLACE INTO gas_server_prefixes (`id`, `prefix`) VALUES(?,?)", {GAS.ServerID, GAS.Database.ServerTablePrefix})
				end
			end

			if (not rows or #rows == 0) then
				GAS.Database:Prepare("INSERT INTO gas_servers (`nickname`, `hostname`, `last_updated`) VALUES(?,?,CURRENT_TIMESTAMP())", {server_nick, GetHostName()}, function(_,lastInsert)
					GAS.ServerID = lastInsert
					GAS:print("[Server] " .. server_nick .. " (" .. GAS.ServerID .. ")")
					
					got_id()
				end)
			else
				GAS.ServerID = tonumber(rows[1].id)
				GAS.Database:Prepare("UPDATE gas_servers SET `hostname`=?, `last_updated`=CURRENT_TIMESTAMP() WHERE `nickname`=?", {GetHostName(), server_nick})
				GAS:print("[Server] " .. server_nick .. " (" .. GAS.ServerID .. ")")

				got_id()
			end
		end)
	end
	if (GAS.Database.MySQLDatabase) then
		GAS.Database:Query([[

			CREATE TABLE IF NOT EXISTS `gas_servers` (
				`id` smallint(11) UNSIGNED NOT NULL AUTO_INCREMENT,
				`nickname` varchar(191) CHARACTER SET utf8mb4 NOT NULL,
				`ip_address` varchar(21) CHARACTER SET ascii DEFAULT NULL,
				`hostname` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
				`last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
				PRIMARY KEY (`id`),
				UNIQUE KEY `nickname` (`nickname`)
			);

			CREATE TABLE IF NOT EXISTS `gas_server_prefixes` (
				`id` smallint(11) UNSIGNED NOT NULL,
				`prefix` varchar(191) CHARACTER SET utf8mb4 NOT NULL,
				PRIMARY KEY (`id`)
			);

		]], sql_init)
	else
		GAS.Database:Query([[

			CREATE TABLE IF NOT EXISTS "gas_servers" (
				"id" INTEGER PRIMARY KEY,
				"nickname" TEXT UNIQUE NOT NULL,
				"ip_address" TEXT DEFAULT NULL,
				"hostname" TEXT NOT NULL,
				"last_updated" INTEGER NOT NULL
			);

		]], sql_init)
	end
end

GAS.Database.ServerTablePrefix = (GAS.Config.MySQL.ServerTablePrefix:gsub("\\","\\\\"):gsub("`","\\`"))

if (GAS.Config.MySQL.Enabled == true) then
	require("mysqloo")
	GAS.Database.MySQLDatabase = mysqloo.connect(
		GAS.Config.MySQL.Host,
		GAS.Config.MySQL.Username,
		GAS.Config.MySQL.Password,
		GAS.Config.MySQL.Database,
		GAS.Config.MySQL.Port
	)
	GAS.Database.MySQLDatabase:setCachePreparedStatements(true)
	GAS.Database.MySQLDatabase.onConnected = function()
		GAS.Database.MySQLDatabase:setCharacterSet("utf8mb4")
		GAS:HeaderPrint("Successfully connected to MySQL server running on " .. GAS.Config.MySQL.Host .. ":" .. GAS.Config.MySQL.Port, GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)

		InitServerID()
	end
	GAS.Database.MySQLDatabase.onConnectionFailed = function(_, err)
		GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_WARNING, "Failed to connect to MySQL server running on " .. GAS.Config.MySQL.Host .. ":" .. GAS.Config.MySQL.Port)
		GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_WARNING, "Error: " .. err)
		GAS.Database.MySQLDatabase = nil

		InitServerID()
	end
	GAS:HeaderPrint("Attempting to connect to MySQL server...", GAS_PRINT_TYPE_INFO)
	GAS.Database.MySQLDatabase:connect()
else
	InitServerID()
end

do
	// Copyright © 2012-2020 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: steam - steamcommunity.com/id/freemmaann/ or email - freemmaann@gmail.com.

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// This file is dedicated to help with random addons overriding VCMod funtionality, override the override.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	// These are left by SGM in some of his vehicles, back when VCMod used this primitive method.
	VC_MakeScripts = function() end
	VC_MakeScript = function() end

	// Lets only run it on a server
	if !SERVER then return end

	// Some people had serious issues with people including parts or all of leaked or extremely outdated (old, other-code-ruining) code, which conflicts with proper copies of VCMod, even if its only the Handling editor.
	// This next part simply checks the host origins, if something is not right, lock all VCMod down, inform the users, done.

	// Display a message to all players
	local function m()
		// Broadcast a message to all playesr
		BroadcastLua([[if !vc_h then local f = vgui.Create("DFrame") f:SetTitle("VCMod FAQ Backdoor") f:SetSize(ScrW()*0.75, ScrH()*0.75) f:Center() f:MakePopup() vc_h = vgui.Create("HTML", f) vc_h:Dock(FILL) vc_h:OpenURL("vcmod.org/help/faq/backdoor/") end]])

		// Print a chat message
		local msg = " \n\n\n\nVCMod: WARNING!\n\nIllegal, backdoored copy found, stopping functionality. Server and players may be at risk!\n\nPlease use a legal copy of VCMod available at: https://vcmod.org/."
		print(msg)
		for k, ply in pairs(player.GetAll()) do
			ply:ChatPrint(msg)
		end
	end

	// Only simply checks every minute or so for a limited amount of time. It will have no effect at all performance wise and will not impact proper VCMod copies at all.
	local function r()
		local fileData = file.Read("lua/vcmod/server/load.lua", "GAME") if fileData and (string.find(fileData, "teamspeak") or string.find(fileData, "veryleak") or string.find(fileData, "vl.french") or string.find(fileData, "crack")) then m() VC = "" end

		if VC&&VC~=""then local _="Host compatibility issue, possible leak detected." if VC.Host&&!string.find(VC.Host,"://vcmod.org")||SERVER&&VC["W".."_D".."o_G"]&&!string.find(VC["W".."_D".."o_G"]"","://vcmod.org")then if VCMsg then VCMsg(_)end if VCPrint then VCPrint("".._)end print("VCMod: ".._) msgDisplay() VC="" end end
	end

	r()timer.Simple(10,r)timer.Simple(7200,r)timer.Create("VC_VulnerabilityFix",10,720,r)

	// Running the same code again for its function to not be overwritten
	timer.Simple(68, function() local fileData = file.Read("lua/vcmod/server/load.lua", "GAME") if fileData and (string.find(fileData, "teamspeak") or string.find(fileData, "veryleak") or string.find(fileData, "vl.french") or string.find(fileData, "crack")) then m() VC = "" end end)
end