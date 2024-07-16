--## CACHING ##--

function GAS.SecondaryUsergroups:CacheUsergroups(ply)
	if (GAS.SecondaryUsergroups.CachedUsergroups[ply:AccountID()] == nil) then
		GAS.SecondaryUsergroups.CachedUsergroupsCount = GAS.SecondaryUsergroups.CachedUsergroupsCount + 1
	end
	GAS.SecondaryUsergroups.CachedUsergroups[ply:AccountID()] = {}
	GAS.Database:Query("SELECT `usergroup` FROM " .. GAS.Database:ServerTable("gas_secondaryusergroups") .. " WHERE `account_id`=" .. ply:AccountID(), function(rows)
		if (not rows) then return end
		GAS:netStart("secondaryusergroups:SyncUsergroups")
			net.WriteUInt(ply:AccountID(), 31)
			net.WriteUInt(#rows, 8)
			for _,row in ipairs(rows) do
				net.WriteString(row.usergroup)
				GAS.SecondaryUsergroups.CachedUsergroups[ply:AccountID()][row.usergroup] = true
			end
		net.SendOmit(ply)
	end)
end
GAS:hook("PlayerInitialSpawn", "secondaryusergroups:CacheUsergroups", function(ply)	
	GAS.SecondaryUsergroups:CacheUsergroups(ply)
end)
GAS:hook("PlayerDisconnect", "secondaryusergroups:UndoCacheUsergroups", function(ply)
	GAS.SecondaryUsergroups.CachedUsergroupsCount = GAS.SecondaryUsergroups.CachedUsergroupsCount - 1
	GAS.SecondaryUsergroups.CachedUsergroups[ply:AccountID()] = nil
end)

--## DATABASE ##--

local function sql_init()
	for _,ply in ipairs(player.GetHumans()) do
		GAS.SecondaryUsergroups:CacheUsergroups(ply)
	end
end
if (GAS.Database.MySQLDatabase) then
	GAS.Database:Query([[

		CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_secondaryusergroups") .. [[ (
			`account_id` int(11) UNSIGNED NOT NULL,
			`usergroup` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
			PRIMARY KEY (`account_id`, `usergroup`)
		)

	]], sql_init)
else
	GAS.Database:Query([[

		CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_secondaryusergroups") .. [[ (
			"account_id" INTEGER NOT NULL,
			"usergroup" TEXT NOT NULL,
			PRIMARY KEY ("account_id", "usergroup")
		)

	]], sql_init)
end

--## CONTROL ##--

function GAS.SecondaryUsergroups:GiveUsergroup(account_id, usergroup)
	usergroup = utf8.force(usergroup)

	GAS.Database:Prepare("REPLACE INTO " .. GAS.Database:ServerTable("gas_secondaryusergroups") .. " (`account_id`, `usergroup`) VALUES(?,?)", {account_id, usergroup})
	GAS.SecondaryUsergroups.CachedUsergroups[account_id] = GAS.SecondaryUsergroups.CachedUsergroups[account_id] or {}
	GAS.SecondaryUsergroups.CachedUsergroups[account_id][usergroup] = true

	GAS:netStart("secondaryusergroups:UsergroupGiven")
		net.WriteUInt(account_id, 31)
		net.WriteString(usergroup)
	net.Broadcast()
end
function GAS.SecondaryUsergroups:RevokeUsergroup(account_id, usergroup)
	usergroup = utf8.force(usergroup)
	
	GAS.Database:Prepare("DELETE FROM " .. GAS.Database:ServerTable("gas_secondaryusergroups") .. " WHERE `account_id`=? AND `usergroup`=?", {account_id, usergroup})
	if (GAS.SecondaryUsergroups.CachedUsergroups[account_id]) then
		GAS.SecondaryUsergroups.CachedUsergroups[account_id][usergroup] = nil
		if (GAS:table_IsEmpty(GAS.SecondaryUsergroups.CachedUsergroups[account_id])) then
			GAS.SecondaryUsergroups.CachedUsergroups[account_id] = nil
		end
	end

	GAS:netStart("secondaryusergroups:UsergroupRevoked")
		net.WriteUInt(account_id, 31)
		net.WriteString(usergroup)
	net.Broadcast()
end

concommand.Add("gas_secondaryusergroups", function(ply, cmd, args)
	if (IsValid(ply)) then return end
	if (#args ~= 3) then
		GAS:print("[SecondaryUsergroups] Invalid number of arguments", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
		GAS:print("[SecondaryUsergroups] gas_secondaryusergroups give/revoke steamid32/64 usergroup", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
	else
		local account_id
		if (args[2]:find("^STEAM_%d:%d:%d+$")) then
			account_id = GAS:SteamIDToAccountID(args[2])
		elseif (args[2]:find("^7656119%d+$")) then
			account_id = GAS:SteamID64ToAccountID(args[2])
		end
		if (account_id) then
			if (args[1] == "give") then
				GAS.SecondaryUsergroups:GiveUsergroup(account_id, args[3])
				GAS:print("[SecondaryUsergroups] Given usergroup \"" .. args[3] .. "\"")
			elseif (args[1] == "revoke") then
				GAS.SecondaryUsergroups:RevokeUsergroup(account_id, args[3])
				GAS:print("[SecondaryUsergroups] Revoked usergroup \"" .. args[3] .. "\"")
			else
				GAS:print("[SecondaryUsergroups] First argument should be give/revoke", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			end
		else
			GAS:print("[SecondaryUsergroups] You did not provide a SteamID32/64", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
		end
	end
end)

--## NETWORKING ##--

GAS:netInit("secondaryusergroups:GiveUsergroup")
GAS:netInit("secondaryusergroups:RevokeUsergroup")
GAS:netInit("secondaryusergroups:UsergroupGiven")
GAS:netInit("secondaryusergroups:UsergroupRevoked")
GAS:netInit("secondaryusergroups:SyncUsergroups")
GAS:netInit("secondaryusergroups:SyncAllUsergroups")
GAS:netInit("secondaryusergroups:GetAllData")

GAS:netReceive("secondaryusergroups:SyncAllUsergroups", function(ply)
	GAS:netStart("secondaryusergroups:SyncAllUsergroups")
		net.WriteUInt(GAS.SecondaryUsergroups.CachedUsergroupsCount, 8)
		for account_id, usergroups in pairs(GAS.SecondaryUsergroups.CachedUsergroups) do
			net.WriteUInt(account_id, 31)
			net.WriteUInt(table.Count(usergroups), 8)
			for usergroup in pairs(usergroups) do
				net.WriteString(usergroup)
			end
		end
	net.Send(ply)
end)

GAS:netReceive("secondaryusergroups:GiveUsergroup", function(ply)
	local account_id = net.ReadUInt(31)
	local usergroup = net.ReadString()
	if (not OpenPermissions:IsOperator(ply) or usergroup == "superadmin" or usergroup == "admin" or usergroup == "user") then return end
	GAS.SecondaryUsergroups:GiveUsergroup(account_id, usergroup)
end)

GAS:netReceive("secondaryusergroups:RevokeUsergroup", function(ply)
	local account_id = net.ReadUInt(31)
	local usergroup = net.ReadString()
	if (not OpenPermissions:IsOperator(ply) or usergroup == "superadmin" or usergroup == "admin" or usergroup == "user") then return end
	GAS.SecondaryUsergroups:RevokeUsergroup(account_id, usergroup)
end)

GAS:netReceive("secondaryusergroups:GetAllData", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	local data = {}
	GAS.Database:Query("SELECT * FROM " .. GAS.Database:ServerTable("gas_secondaryusergroups"), function(rows)
		if (rows and #rows > 0) then
			for _,row in ipairs(rows) do
				local id = tonumber(row.account_id)
				data[id] = data[id] or {}
				data[id][row.usergroup] = true
			end
		end
		data = util.Compress(GAS:SerializeTable(data))
		GAS:netStart("secondaryusergroups:GetAllData")
			net.WriteData(data, #data)
		net.Send(ply)
	end)
end)