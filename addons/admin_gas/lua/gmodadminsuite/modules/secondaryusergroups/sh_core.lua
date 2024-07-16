local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "secondaryusergroups")
	else
		return GAS:PhraseFormat(phrase, "secondaryusergroups", ...)
	end
end

GAS.SecondaryUsergroups = {}
GAS.SecondaryUsergroups.CachedUsergroups = {}
GAS.SecondaryUsergroups.CachedUsergroupsCount = 0

GAS:hook("OpenPermissions:GetUserGroups", "secondaryusergroups:OpenPermissions:GetUserGroups", function(ply, usergroups_tbl)
	if (GAS.SecondaryUsergroups.CachedUsergroups[ply:AccountID()]) then
		for usergroup in pairs(GAS.SecondaryUsergroups.CachedUsergroups[ply:AccountID()]) do
			usergroups_tbl[usergroup] = true
		end
	end
end)

GAS:hook("OpenPermissions:IsUserGroup", "secondaryusergroups:OpenPermissions:IsUserGroup", function(ply, usergroup)
	if (GAS.SecondaryUsergroups.CachedUsergroups[ply:AccountID()]) then
		if (GAS.SecondaryUsergroups.CachedUsergroups[ply:AccountID()][usergroup] == true) then
			return true
		end
	end
end)

if (CLIENT) then
	GAS:netReceive("secondaryusergroups:SyncUsergroups", function()
		local account_id = net.ReadUInt(31)
		GAS.SecondaryUsergroups.CachedUsergroups[account_id] = {}
		local usergroups_len = net.ReadUInt(8)
		for i=1,usergroups_len do
			GAS.SecondaryUsergroups.CachedUsergroups[account_id][net.ReadString()] = true
		end
	end)

	GAS:netReceive("secondaryusergroups:SyncAllUsergroups", function()
		local ply_len = net.ReadUInt(8)
		for i=1,ply_len do
			local account_id = net.ReadUInt(31)
			GAS.SecondaryUsergroups.CachedUsergroups[account_id] = {}
			local usergroups_len = net.ReadUInt(8)
			for i=1,usergroups_len do
				GAS.SecondaryUsergroups.CachedUsergroups[account_id][net.ReadString()] = true
			end
		end
	end)

	GAS:netReceive("secondaryusergroups:UsergroupGiven", function()
		local account_id = net.ReadUInt(31)
		GAS.SecondaryUsergroups.CachedUsergroups[account_id] = GAS.SecondaryUsergroups.CachedUsergroups[account_id] or {}
		GAS.SecondaryUsergroups.CachedUsergroups[account_id][net.ReadString()] = true
	end)

	GAS:netReceive("secondaryusergroups:UsergroupRevoked", function()
		local account_id = net.ReadUInt(31)
		local usergroup = net.ReadString()
		if (GAS.SecondaryUsergroups.CachedUsergroups[account_id] ~= nil) then
			GAS.SecondaryUsergroups.CachedUsergroups[account_id][usergroup] = nil
			if (GAS:table_IsEmpty(GAS.SecondaryUsergroups.CachedUsergroups[account_id])) then
				GAS.SecondaryUsergroups.CachedUsergroups[account_id] = nil
			end
		end
	end)

	GAS:InitPostEntity(function()
		GAS:netStart("secondaryusergroups:SyncAllUsergroups")
		net.SendToServer()
	end)

	GAS:ContextProperty("gas_secondaryusergroups", {
		MenuLabel = L"module_name",
		MenuIcon = "icon16/user_edit.png",
		MenuOpen = function(self, option, ply, tr, option_pnl)
			GAS.SecondaryUsergroups:OpenContextMenu(option, ply, true, option_pnl)
		end,
		Filter = function(self, ent, ply)
			return ent:IsPlayer() and not ent:IsBot() and OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite/secondaryusergroups")
		end
	})
end