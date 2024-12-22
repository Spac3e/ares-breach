local CATEGORY_NAME = "User Management"

if !file.Exists( "ulx", "DATA" ) then
	file.CreateDir( "ulx" )
end

if !file.Exists( "ulx/tempuserdata", "DATA" ) then
	file.CreateDir( "ulx/tempuserdata" )
end

//--Code courtesy of Stickly Man.
ulx.tempuser_group_names = {}
local function updateNames()
	table.Empty( ulx.tempuser_group_names ) -- Don't reassign so we don't lose our refs

	for group_name, _ in pairs( ULib.ucl.groups ) do
		table.insert( ulx.tempuser_group_names, group_name )
	end
end
hook.Add( ULib.HOOK_UCLCHANGED, "ULXTempAddUesrGroupNamesUpdate", updateNames )
updateNames() -- Init

--[[
	 ulx.CheckExpiration( pl )
	pl : PlayerObject - Player who is being checked for an expiration time.
	
	This function checks to see if the called player has a temporary group configuration and will set their group to the new group if their time is expired or will
	set up a timer to change the player's group when their time expires.
]]
function ulx.CheckExpiration( pl )

	local SID = pl:SteamID64()	--We're going to use the 64bit SteamID because it's more string friendly.
	
	if file.Exists( "ulx/tempuserdata/" .. SID .. ".txt", "DATA" ) then	--If the authing user doesn't have a file for their SteamID then they clearly don't have a pending expiration.
		local todecode = file.Read( "ulx/tempuserdata/" .. SID .. ".txt", "DATA" )
		local tbl = string.Explode( "|", todecode)
		local exptime = tonumber(tbl[ 1 ])
		local rgroup = tbl[ 2 ]
		
		if os.time() >= exptime then	--If the users expiration time has already passed.
			ulx.ExpireGroupChange( pl, rgroup )
		else
			if os.time() + 3600 >= exptime then	--If the users group expires in the next 30 minutes.
				timer.Create( "ULXGroupExpire_" .. SID, ( exptime - os.time() ), 1, function() ulx.ExpireGroupChange( pl, rgroup ) end )
			end
		end
	end

end
hook.Add( "PlayerAuthed", "CheckExpiration", ulx.CheckExpiration )

--[[
	ulx.PeriodicExpirationCheck()
	This function checks every connected player to see if they have an expiration time on their current group.
	If they do it sets their group to expire automatically.
]]
function ulx.PeriodicExpirationCheck()

	if CLIENT then return end

	for _, pl in pairs (player.GetAll()) do
		if not IsValid(pl) then continue end
		if pl:IsConnected() then
			ulx.CheckExpiration( pl )
		end
	end
	
end
timer.Create( "ulx_periodicexpirationcheck", 3600, 0, ulx.PeriodicExpirationCheck )


--[[
	ulx.ExpireGroupChange( pl, group )
	pl : PlayerObject - Player who will be having their group changed.
	group : String - Group player will be set to. (setting this to 'user' will instead remove the player from the auth table)
	
	This function changes the players group and removes their temp group file from the data directory.
]]
function ulx.ExpireGroupChange( pl, group )

	if not IsValid(pl) then return end
	if not pl:IsConnected() then return end
	
	local SID = pl:SteamID64()
	
	if group == "user" then
		ULib.ucl.removeUser(pl:SteamID())
	else
		ULib.ucl.addUser( pl:SteamID(), _, _, group )
	end
	
	ulx.fancyLogAdmin( pl, "#A had his/her group auto set to #s by a timed group script.", group )
	
	timer.Remove("ULXGroupExpire_" .. SID)
	if file.Exists("ulx/tempuserdata/" .. SID .. ".txt", "DATA") then
		file.Delete("ulx/tempuserdata/"..SID..".txt")
	end

end

--[[
	ulx.CreateExpiration( pl, exp_time, return_group )
	pl : PlayerObject - Player to set up an expiration on.
	exp_time : Integer - time (in minutes) the player will remain in their new temp group.
	return_group: String - the group the player will be set to after their current group expires.
	
	This function sets up the data files so that the script will know when their group expires if they leave the server.
]]
function ulx.CreateExpiration( pl, exp_time, return_group )

	local SID = pl:SteamID64()
	local exp_time_global = ( exp_time * 60 ) + os.time()
	
	local tbl = {}
	tbl[ "exptime" ] = exp_time_global
	tbl[ "returngroup" ] = return_group
	
	local toencode = exp_time_global .. "|" .. return_group
	
	file.Write("ulx/tempuserdata/"..SID..".txt", toencode)

end

--[[
	ulx.CreateExpirationByID( id, exp_time, return_group )
	id : String - 64bit SteamID to set up an expiration on.
	exp_time : Integer - time (in minutes) the player will remain in their new temp group.
	return_group: String - the group the player will be set to after their current group expires.
	
	This function sets up the data files so that the script will know when their group expires if they leave the server.
]]
function ulx.CreateExpirationByID( id, exp_time, return_group )

	local SID = id
	local exp_time_global = ( exp_time * 60 ) + os.time()
	
	local tbl = {}
	tbl[ "exptime" ] = exp_time_global
	tbl[ "returngroup" ] = return_group
	
	local toencode = exp_time_global .. "|" .. return_group
	
	file.Write("ulx/tempuserdata/"..SID..".txt", toencode)

end

--[[
	ulx.tempadduser( calling_ply, target_ply, group_name, exp_time, return_group_name )
	calling_ply : PlayerObject - Player running the command (usually an admin)
	target_ply : PlayerObject - Player who will have their group temporarily set.
	group_name : String - Group to give the player temporarily
	exp_time : Integer - time (in minutes) the player will remain in their new temp group.
	return_group_name: String - the group the player will be set to after their current group expires.
	
	This is the actual command function. Calling this will set the player's group to a new temporary group and then after the set amount of time it will be set back to a new group.
]]
function ulx.tempadduser( calling_ply, target_ply, group_name, exp_time, return_group_name )
	group_name = group_name:lower()
	return_group_name = return_group_name:lower()

	local userInfo = ULib.ucl.authed[ target_ply:UniqueID() ]

	local id = ULib.ucl.getUserRegisteredID( target_ply )
	if not id then id = target_ply:SteamID() end
	
	ULib.ucl.addUser( id, userInfo.allow, userInfo.deny, group_name )

	ulx.fancyLogAdmin( calling_ply, "#A added #T to group #s for " .. exp_time .. " minutes.", target_ply, group_name )
	
	ulx.CreateExpiration( target_ply, exp_time, return_group_name )
	
	if exp_time <= 30 then
		timer.Create( "ULXGroupExpire_" .. target_ply:SteamID64(), exp_time * 60, 1, function() ulx.ExpireGroupChange( target_ply, return_group_name ) end )
	end
end
local tempadduser = ulx.command( CATEGORY_NAME, "ulx tempadduser", ulx.tempadduser )
tempadduser:addParam{ type=ULib.cmds.PlayerArg }
tempadduser:addParam{ type=ULib.cmds.StringArg, completes=ulx.tempuser_group_names, hint="Group to place user in temporarily", error="invalid group \"%s\" specified", ULib.cmds.restrictToCompletes }
tempadduser:addParam{ type=ULib.cmds.NumArg, hint="Time (Minutes)" }
tempadduser:addParam{ type=ULib.cmds.StringArg, completes=ulx.tempuser_group_names, hint="Group to place user in after time expires", error="invalid group \"%s\" specified", ULib.cmds.restrictToCompletes }
tempadduser:defaultAccess( ULib.ACCESS_SUPERADMIN )
tempadduser:help( "Add a user to specified group for a specified time." )

--[[
	ulx.tempadduserid( calling_ply, target_id, group_name, exp_time, return_group_name )
	calling_ply : PlayerObject - Player running the command (usually an admin)
	target_ply : String - Player who will have their group temporarily set.
	group_name : String - Group to give the player temporarily
	exp_time : Integer - time (in minutes) the player will remain in their new temp group.
	return_group_name: String - the group the player will be set to after their current group expires.
	
	This is the actual command function. Calling this will set the player's group to a new temporary group and then after the set amount of time it will be set back to a new group.
]]
function ulx.tempadduserid( calling_ply, target_id, group_name, exp_time, return_group_name )
	group_name = group_name:lower()
	return_group_name = return_group_name:lower()

	/* Check if the player is actually connected */
	new_id_64 = ulx.SteamIDTo64( target_id:upper() )
	
	if new_id_64 == nil then
		print( "Invalid SteamID" )
		return
	end
	
	local target_ply = nil
	for k, v in pairs( player.GetAll() ) do
		if v:SteamID() == target_id then
			target_ply = v
			break
		end
	end
	
	if target_ply then

		local userInfo = ULib.ucl.authed[ target_ply:UniqueID() ]

		local id = ULib.ucl.getUserRegisteredID( target_ply )
		if not id then id = target_ply:SteamID() end
		
		ULib.ucl.addUser( id, userInfo.allow, userInfo.deny, group_name )

		ulx.fancyLogAdmin( calling_ply, "#A added #T to group #s for " .. exp_time .. " minutes.", target_ply, group_name )
		
		ulx.CreateExpiration( target_ply, exp_time, return_group_name )
		
		if exp_time <= 30 then
			timer.Create( "ULXGroupExpire_" .. target_ply:SteamID64(), exp_time * 60, 1, function() ulx.ExpireGroupChange( target_ply, return_group_name ) end )
		end
		
	else
		ulx.fancyLogAdmin( calling_ply, "#A added " .. target_id .. " to group #s for " .. exp_time .. " minutes.", group_name )
		
		ulx.CreateExpirationByID( new_id_64, exp_time, return_group_name )
	end
end
local tempadduserid = ulx.command( CATEGORY_NAME, "ulx tempadduserid", ulx.tempadduserid )
tempadduserid:addParam{ type=ULib.cmds.StringArg }
tempadduserid:addParam{ type=ULib.cmds.StringArg, completes=ulx.tempuser_group_names, hint="Group to place user in temporarily", error="invalid group \"%s\" specified", ULib.cmds.restrictToCompletes }
tempadduserid:addParam{ type=ULib.cmds.NumArg, hint="Time (Minutes)" }
tempadduserid:addParam{ type=ULib.cmds.StringArg, completes=ulx.tempuser_group_names, hint="Group to place user in after time expires", error="invalid group \"%s\" specified", ULib.cmds.restrictToCompletes }
tempadduserid:defaultAccess( ULib.ACCESS_SUPERADMIN )
tempadduserid:help( "Add a user by SteamID to specified group for a specified time." )


--[[
	ulx.SteamIDto64( id )
	id : String - Regular SteamID
	
	This is a work around for one of the inadequecies in current GMod. Currently the util.SteamIDTo64 is broken.
]]
function ulx.SteamIDTo64( id )
	id = string.Trim( id )
	if string.sub( id, 1, 6 ) == 'STEAM_' then
		local parts = string.Explode( ':', string.sub(id,7) )
		local id_64 = (1197960265728 + tonumber(parts[2])) + (tonumber(parts[3]) * 2)
		local str = string.format('%f',id_64)
		return '7656'..string.sub( str, 1, string.find(str,'.',1,true)-1 )
	else
		return nil
	end
end