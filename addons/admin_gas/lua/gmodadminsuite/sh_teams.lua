--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/sh_teams.lua

--]]

GAS.Teams = {}
GAS.Teams.Identifiers = {}
GAS.Teams.IdentifiersIndexed = {}

local ReadyCallbacks = {}
function GAS.Teams:Ready(callback)
	if (GAS.Teams.CachedIdentifiers) then
		callback()
	else
		table.insert(ReadyCallbacks, callback)
	end
end

if (SERVER) then

	GAS:netInit("teams:GetIdentifiers")
	local function NetworkIdentifiers(ply)
		GAS:netStart("teams:GetIdentifiers")
			net.WriteUInt(table.Count(GAS.Teams.Identifiers), 16)
			for team_index, identifier in pairs(GAS.Teams.Identifiers) do
				net.WriteUInt(team_index, 16)
				net.WriteUInt(identifier, 16)
			end
		net.Send(ply)
	end

	local GetIdentifiersQueue = {}
	GAS:netReceive("teams:GetIdentifiers", function(ply)
		if (GAS.Teams.CachedIdentifiers) then
			NetworkIdentifiers(ply)
		else
			table.insert(GetIdentifiersQueue, ply)
		end
	end)

	GAS.Teams:Ready(function()
		for _,ply in ipairs(GetIdentifiersQueue) do
			NetworkIdentifiers(ply)
		end
		GetIdentifiersQueue = {}
	end)

	local function teams_init()
		GAS.Teams.Identifiers = {}
		GAS.Teams.IdentifiersIndexed = {}
		
		GAS:print("Populating team identification...", GAS_PRINT_TYPE_INFO)

		GAS.Database:Query("SELECT `id`, `name`, `command`, `OPENPERMISSIONS_IDENTIFIER` FROM `gas_teams` WHERE `server_id`=" .. GAS.ServerID, function(rows)
			GAS.Database:BeginTransaction()

			if (DarkRP and RPExtraTeams) then
				for _,job in ipairs(RPExtraTeams) do
					local OPENPERMISSIONS_IDENTIFIER = NULL
					if (job.OPENPERMISSIONS_IDENTIFIER ~= nil) then
						OPENPERMISSIONS_IDENTIFIER = utf8.force(job.OPENPERMISSIONS_IDENTIFIER)
					end
					local found = false
					for _,row in ipairs(rows) do
						if (
							(row.OPENPERMISSIONS_IDENTIFIER ~= nil and job.OPENPERMISSIONS_IDENTIFIER ~= nil and utf8.force(job.OPENPERMISSIONS_IDENTIFIER) == row.OPENPERMISSIONS_IDENTIFIER) or
							(row.command ~= nil and utf8.force(job.command) == row.command)
						) then
							found = true
							GAS.Database:Prepare("UPDATE `gas_teams` SET `name`=?, `command`=?, `OPENPERMISSIONS_IDENTIFIER`=? WHERE `server_id`=? AND `id`=?", {utf8.force(job.name), utf8.force(job.command), OPENPERMISSIONS_IDENTIFIER, GAS.ServerID, tonumber(row.id)})
							break
						end
					end
					if (not found) then
						GAS.Database:Prepare("INSERT INTO `gas_teams` (`server_id`, `name`, `command`, `OPENPERMISSIONS_IDENTIFIER`) VALUES(?,?,?,?)", {GAS.ServerID, utf8.force(job.name), utf8.force(job.command), OPENPERMISSIONS_IDENTIFIER})
					end
				end
			else
				for i,t in ipairs(team.GetAllTeams()) do
					local found = false
					for _,row in ipairs(rows) do
						if (row.name ~= nil and utf8.force(t.Name) == row.name) then
							found = true
							GAS.Database:Prepare("UPDATE `gas_teams` SET `name`=?, `command`=?, `OPENPERMISSIONS_IDENTIFIER`=? WHERE `server_id`=? AND `id`=?", {utf8.force(t.Name), NULL, NULL, GAS.ServerID, tonumber(row.id)})
							break
						end
					end
					if (not found) then
						GAS.Database:Prepare("INSERT INTO `gas_teams` (`server_id`, `name`, `command`, `OPENPERMISSIONS_IDENTIFIER`) VALUES(?,?,?,?)", {GAS.ServerID, utf8.force(t.Name), NULL, NULL})
					end
				end
			end

			GAS.Database:CommitTransaction(function()

				GAS.Database:Query("SELECT `id`, `name`, `command`, `OPENPERMISSIONS_IDENTIFIER` FROM `gas_teams` WHERE `server_id`=" .. GAS.ServerID, function(rows)
					for _,row in ipairs(rows) do
						if (DarkRP and RPExtraTeams) then
							for _,job in ipairs(RPExtraTeams) do
								if (GAS.Teams.Identifiers[job.team] ~= nil) then continue end
								if (
									(row.OPENPERMISSIONS_IDENTIFIER ~= nil and job.OPENPERMISSIONS_IDENTIFIER == row.OPENPERMISSIONS_IDENTIFIER) or
									(row.command ~= nil and job.command == row.command) or
									(row.name ~= nil and job.name == row.name)
								) then
									GAS.Teams.Identifiers[job.team] = tonumber(row.id)
									GAS.Teams.IdentifiersIndexed[tonumber(row.id)] = job.team
									break
								end
							end
						else
							for i,t in ipairs(team.GetAllTeams()) do
								if (GAS.Teams.Identifiers[i] ~= nil) then continue end
								if (row.name ~= nil and t.Name == row.name) then
									GAS.Teams.Identifiers[i] = tonumber(row.id)
									GAS.Teams.IdentifiersIndexed[tonumber(row.id)] = i
									break
								end
							end
						end
					end

					GAS.Teams.CachedIdentifiers = true

					for _,callback in ipairs(ReadyCallbacks) do
						callback()
					end
					ReadyCallbacks = {}

					hook.Run("GAS:TeamIdentifiersReady")

					GAS:print("Initialized team identification", GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)
				end)

			end)
		end)
	end

	local function sql_init()
		GAS:GMInitialize(function()
			GAS:InitPostEntity(function()
				GAS.Database:ServerID(teams_init)
			end)
		end)
		hook.Add("DConfigOnUpdateJob", "DConfig:UpdateJobCache", teams_init)
	end

	if (GAS.Database.MySQLDatabase) then
		GAS.Database:Query([[

			CREATE TABLE IF NOT EXISTS `gas_teams` (
				`id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
				`server_id` smallint(5) unsigned NOT NULL,
				`OPENPERMISSIONS_IDENTIFIER` varchar(189) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
				`command` varchar(189) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
				`name` varchar(189) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
				PRIMARY KEY (`id`),
				UNIQUE KEY `command` (`server_id`,`command`),
				UNIQUE KEY `OPENPERMISSIONS_IDENTIFIER` (`server_id`,`OPENPERMISSIONS_IDENTIFIER`)
			)

		]], function()
			GAS.Database:Query("SHOW INDEX FROM gas_teams WHERE KEY_NAME='name'", function(rows)
				if (rows and #rows > 0) then
					GAS.Database:Query("DROP INDEX name ON gas_teams", sql_init)
				else
					sql_init()
				end
			end)
		end)
	else
		GAS.Database:Query([[

			CREATE TABLE IF NOT EXISTS "gas_teams" (
				"id" INTEGER PRIMARY KEY,
				"server_id" INTEGER NOT NULL,
				"OPENPERMISSIONS_IDENTIFIER" TEXT DEFAULT NULL,
				"command" TEXT DEFAULT NULL,
				"name" TEXT NOT NULL,
				UNIQUE ("server_id","command"),
				UNIQUE ("server_id","OPENPERMISSIONS_IDENTIFIER")
			)

		]], sql_init)
	end

else

	GAS:netReceive("teams:GetIdentifiers", function(len)
		for i=1,net.ReadUInt(16) do
			local team_index, identifier = net.ReadUInt(16), net.ReadUInt(16)
			GAS.Teams.Identifiers[team_index] = identifier
			GAS.Teams.IdentifiersIndexed[identifier] = team_index
		end

		GAS.Teams.CachedIdentifiers = true

		for _,callback in ipairs(ReadyCallbacks) do
			callback()
		end
		ReadyCallbacks = {}

		hook.Run("GAS:TeamIdentifiersReady")
	end)

	GAS:InitPostEntity(function()
		GAS:netStart("teams:GetIdentifiers")
		net.SendToServer()
	end)

end

function GAS.Teams:GetIdentifier(team_index)
	return GAS.Teams.Identifiers[team_index]
end
function GAS.Teams:GetFromIdentifier(identifier)
	return GAS.Teams.IdentifiersIndexed[tonumber(identifier)]
end

GAS:hook("OpenPermissions:GetTeamIdentifier", "teams:OpenPermissions:GetTeamIdentifier", function(team_index)
	return GAS.Teams:GetIdentifier(team_index)
end)
GAS:hook("OpenPermissions:GetTeamFromIdentifier", "teams:OpenPermissions:GetTeamFromIdentifier", function(team_identifier)
	return GAS.Teams:GetFromIdentifier(team_identifier)
end)