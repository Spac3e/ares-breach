local vecNeg = Vector( -1, -1, -1 )
local vecPos = Vector( 1, 1, 1 )

--------------------------------------------------------------------------------------------------
hab.WireMounted = function ( )

	if WireLib then

		return true

	else

		return false

	end

end
--------------------------------------------------------------------------------------------------
hab.RegisterModule = function( MODULE ) -- Should be called before subload but after any envirionment variables such as enumerators

--	module( MODULE.info.iname, package.seeall )

	if MODULE.info.requirements then

		for k, v in pairs( MODULE.info.requirements ) do

			if v then

				include( "hab/modules/" .. string.lower( k ) .. ".lua" )

			end

		end

	end

end
--------------------------------------------------------------------------------------------------
hab.SubLoad = function( name )

	local folderList = file.Find("hab/modules/" .. name .. "/*.lua", "LUA")

	for _, f in pairs( folderList ) do

		local sv = string.find( f:lower( ), "sv_" )
		local cl = string.find( f:lower( ), "cl_" )
		local sh = string.find( f:lower( ), "sh_" )

		if ( !sv and !cl ) or sh then -- file is shared

			AddCSLuaFile( "hab/modules/" .. name .. "/" .. f )
			include( "hab/modules/" .. name .. "/" .. f )

		elseif SERVER and sv then

			include( "hab/modules/" .. name .. "/" .. f )

		elseif cl then

			if SERVER then

				AddCSLuaFile( "hab/modules/" .. name .. "/" .. f )

			elseif CLIENT then

				include( "hab/modules/" .. name .. "/" .. f )

			end

		end

		local typ = ( ( !sv and !sh ) and "CL" ) or ( sh and "SH" ) or ( sv and "SV" )

	end

end
--------------------------------------------------------------------------------------------------
hab.LoadFile = function( name, Fname )

	local folderList = file.Find("hab/modules/" .. name .. "/*" .. Fname .. ".lua", "LUA")

	for _, f in pairs( folderList ) do

		local sv = string.find( f:lower( ), "sv_" )
		local cl = string.find( f:lower( ), "cl_" )
		local sh = string.find( f:lower( ), "sh_" )

		if !sv or sh then -- file is shared

			AddCSLuaFile( "hab/modules/" .. name .. "/" .. f )
			include( "hab/modules/" .. name .. "/" .. f )

		elseif SERVER and sv then

			include( "hab/modules/" .. name .. "/" .. f )

		elseif cl then

			if SERVER then

				AddCSLuaFile( "hab/modules/" .. name .. "/" .. f )

			elseif CLIENT then

				include( "hab/modules/" .. name .. "/" .. f )

			end

		end

		local typ = ( ( !sv and !sh ) and "CL" ) or ( sh and "SH" ) or ( sv and "SV" )

	end

end
--------------------------------------------------------------------------------------------------
hab.hook = function( gmhook, name, func, unload )

	hab.hooks[name] = { f = func, u = unload, g = gmhook }

	hook.Add( gmhook, name, func )

end
--------------------------------------------------------------------------------------------------
if SERVER then

util.AddNetworkString( "HAB_Update_Admin_CVar" )

net.Receive( "HAB_Update_Admin_CVar", function( len, ply )

	if ply:IsAdmin( ) or ply:IsSuperAdmin( ) then

		local name = net.ReadString( )
		local value = net.ReadCVarValue( )

		if GetConVar( name ) then

			RunConsoleCommand( name, value )

		end

	end

end )

end

hab.NameToPlayer = function( text )

	if text then

		text = text:lower( )

	else

		return false

	end

	local plyMatch

	for _, ply in ipairs( player.GetAll( ) ) do

		local nameMatch
		local nick = ply:Nick( ):lower( )

		if text == nick then

			if !plyMatch then

				return player

			else

				return false

			end

		end

		if nick:find( text, 1, true ) then

			nameMatch = ply

		end

		if nameMatch then

			if plyMatch then

				return false

			else

				plyMatch = nameMatch

			end

		end

	end

	if !plyMatch then

		return false

	else

		return plyMatch

	end

end

hab.GetCVarVal = function( name, type, b )

	if !GetConVar( name ) then

		MsgN( "Invalid Cvar: ", name )

		return nil

	else

		if type == CVAL_STRING then

			return cvars.String( name, b or nil )

		elseif type == CVAL_BOOL then

			return cvars.Bool( name, b or false )

		elseif type == CVAL_NUMBER then

			return tonumber( cvars.Number( name, b or 0 ) )

		else

			MsgN( "Invalid CVal Type: ", type )

			return nil

		end

	end

end

hab.AddCvar = function( cat, name, value, type, flags, helptext, fallback, b, callback ) -- ( category, cvar name, value, value type, flags, helper text, disable notify on change )

	local stringname = cat and ( "hab_" .. cat .. "_" .. name ) or ( "hab_" .. name )

	cat = cat or "Base"

	hab.CVars[cat] = hab.CVars[cat] or {}
	hab.cval[cat] = hab.cval[cat] or {}

	local cvar = CreateConVar( stringname, value, flags, helptext )
	local cvar_val = hab.GetCVarVal( stringname, type, fallback )

	if CLIENT then

		CreateClientConVar( stringname .. "_cl", value, false, false, helptext .. ", Client to Server CVar" )

		cvars.AddChangeCallback( stringname .. "_cl", function( cname, old, new )

			local ply = LocalPlayer( )
			if ply:IsAdmin( ) or ply:IsSuperAdmin( ) then

				local str = string.gsub( cname, "_cl", "" )

				net.Start( "HAB_Update_Admin_CVar" )

					net.WriteString( str ) -- write name

					net.WriteCVarValue( type, new ) -- write value

				net.SendToServer( )

			end

		end, stringname .. "_callback_cl" )

	end

	cvars.AddChangeCallback( stringname, function( cname, old, new )

		if !b then

			MsgN( "Cvar: " .. cname .. " Changed from " .. old .. " to " .. new )

		end

		hab.cval[cat][name] = hab.GetCVarVal( cname, type, fallback )

		return isfunction( callback ) and callback( cname, old, new ) or nil

	end, stringname .. "_callback" )

	hab.CVars[cat][name] = cvar
	hab.cval[cat][name] = cvar_val

	return cvar

end

hab.AddCvarCL = function( cat, name, value, shouldsave, userdata, helptext, callback ) -- ( category, cvar name, value, save value, send to server, helper text, callback function )

	local stringname = cat and ( "hab_" .. cat .. "_" .. name ) or ( "hab_" .. name )

	cat = cat or "Base"

	hab.CVars[cat] = hab.CVars[cat] or {}
	hab.cval[cat] = hab.cval[cat] or {}

	local cvar = CreateClientConVar( stringname, value, shouldsave, userdata, helptext )
	local cvar_val = hab.GetCVarVal( stringname, CVAL_STRING, value )

	cvars.AddChangeCallback( stringname, function( cname, old, new )

		if !b then

			MsgN( "Cvar: " .. cname .. " Changed from " .. old .. " to " .. new )

		end

		hab.cval[cat][name] = hab.GetCVarVal( cname, CVAL_STRING, callback )

		return isfunction( callback ) and callback( cname, old, new ) or nil

	end, stringname .. "_callback" )

	hab.CVars[cat][name] = cvar
	hab.cval[cat][name] = cvar_val

	return cvar

end

hab.AddConCommand = function( cat, name, callback, autoComplete, helpText, flags )

	local stringname = cat and ( "hab_" .. cat .. "_" .. name ) or ( "hab_" .. name )

	concommand.Add( stringname, callback, autoComplete, helpText, flags )

end

hab.AddChatCommand = function( name, callback )

	hab.ChatCom[name] = callback

end

hab.hook( "PlayerSay", "HAB_Util_PlayerSay", function( ply, text, public )

	if !string.StartWith( text, "/" ) then return end

	text = string.TrimLeft( text:lower( ), "/" )

	local exp = string.Explode( " ", text )

	if hab.ChatCom[ exp[1] ] then

		return hab.ChatCom[ exp[1] ]( ply, exp )

	end

end )
--------------------------------------------------------------------------------------------------
hab.setVar = function( ent, name, var, bool )

	if bool then

		if ent:GetNW2Bool( name ) != var then

			ent:SetNW2Bool( name, var )

		end

	else

		if ent:GetNW2Int( name ) != var then

			ent:SetNW2Int( name, math.Round( var, 0 ) )

		end

	end

end
--------------------------------------------------------------------------------------------------
hab.addControls = function( category, cont )

	local c

	for i, t in pairs( hab.controls ) do

		if t.name == category then

			c = t

		end

	end

	if !c then

		c = { name = category, list = {} }

		table.insert(hab.controls, c)

	end

	for name, control in pairs( cont ) do

		control[2] = control[2] or KEY_NONE

		c.list[name] = control

	end

end
--------------------------------------------------------------------------------------------------
hab.Dmsg = function( ... )

	if hab.cval.Base.Developer > 0 then

		MsgN( ... )

	end

end
--------------------------------------------------------------------------------------------------
hab.smoothApproach = function( x, y, s, c )

	if !x then error( "first argument nil", 2 ) end
	if !y then error( "second argument nil", 2 ) end
	local FrT = math.Clamp( FrameTime( ), 0.001, 0.035 ) * 0.3
	c = ( c and c * FrT ) or 99999
	return x-math.Clamp( ( x - y ) * s * FrT, - c, c )

end
--------------------------------------------------------------------------------------------------
hab.smoothApproachAngle = function(x,y,s,c)

	local FrT = math.Clamp( FrameTime( ), 0.001, 0.035 ) * 0.3
	c = ( c and c * FrT ) or 99999
	return x - math.Clamp( math.AngleDifference( x, y ) * s * FrT, - c, c )

end
--------------------------------------------------------------------------------------------------
hab.smoothApproachAngles = function(a1,a2,s,c)

	if !a1 or !a2 then error( "one argument is nil", 2 ) end
	a1.p = hab.smoothApproachAngle( a1.p, a2.p, s, c )
	a1.y = hab.smoothApproachAngle( a1.y, a2.y, s, c )
	a1.r = hab.smoothApproachAngle( a1.r, a2.r, s, c )
	return a1

end
--------------------------------------------------------------------------------------------------
hab.smoothApproachVector = function(begin, target, s, c)

	if !begin then error( "first argument is nil", 2 ) end
	if !target then error( "second argument is nil", 2 ) end
	if !s then error( "third argument is nil", 2 ) end
	local dir = (begin-target):GetNormal( )
	local dist = begin:Distance(target)
	local var = hab.smoothApproach( 0, dist, s, c )
	local v = begin - dir * var
	begin.x = v.x
	begin.y = v.y
	begin.z = v.z
	return begin

end
--------------------------------------------------------------------------------------------------
VectorRandom = function( min, max ) -- returns randomized vector

	min = min or vecNeg
	max = max or vecPos

	return Vector( math.Rand( min.x, max.x ), math.Rand( min.y, max.y ), math.Rand( min.z, max.z ) )

end
--------------------------------------------------------------------------------------------------
net.WriteCVarValue = function( type, value )

	net.WriteType( type, 8 )

	if type == CVAL_STRING then

		net.WriteString( value )

	elseif type == CVAL_BOOL then

		net.WriteBool( value )

	elseif type == CVAL_NUMBER then

		net.WriteFloat( value )

	end

end

net.ReadCVarValue = function( )

	local type = net.ReadType( )
	local value = 0

	if type == CVAL_STRING then

		value = net.ReadString( )

	elseif type == CVAL_BOOL then

		value = net.ReadBool( )

	elseif type == CVAL_NUMBER then

		value = net.ReadFloat( )

	end

	return value

end

net.WriteFloatVector = function( vec ) -- send net message for high precision vector

	net.WriteFloat( vec.x )

	net.WriteFloat( vec.y )

	net.WriteFloat( vec.z )

end

net.WriteCompressedFloatVector = function( vec, r ) -- net message for rounded high precision vector

	r = r or 3

	net.WriteFloat( math.Round( vec.x, r ) )

	net.WriteFloat( math.Round( vec.y, r ) )

	net.WriteFloat( math.Round( vec.z, r ) )

end

net.ReadFloatVector = function( ) -- recieve net message for high precision vector

	local x = net.ReadFloat( )

	local y = net.ReadFloat( )

	local z = net.ReadFloat( )

	return Vector( x, y, z )

end

net.WriteFloatAngles = function( ang ) -- send net message for high precision angles

	net.WriteFloat( ang.x )

	net.WriteFloat( ang.y )

	net.WriteFloat( ang.z )

end

net.ReadFloatAngles = function( ) -- recieve net message for high precision angles

	local p = net.ReadFloat( )

	local y = net.ReadFloat( )

	local r = net.ReadFloat( )

	return Angle( p, y, r )

end
--------------------------------------------------------------------------------------------------
hab.CalculateQuadratic = function( r, A, B, C, x )

	return A * math.pow( x, 2 ) + B * x + C

end

hab.CalculateInverseQuadratic = function( r, A, B, C, y )

	local Q = math.pow( math.pow( B, 2 ) - 4 * A * ( C - y ), 0.5 ) / ( 2 * A )

	return - B + Q, -B - Q

end
--------------------------------------------------------------------------------------------------
hab.SharedRandomVector = function( name, minVec, maxVec, seed )

	minVec = minVec or vecNeg
	maxVec = maxVec or vecPos
	seed = seed or util.SharedRandom( name, -1000, 1000 )

	return Vector( util.SharedRandom( ( name .. "_X" ), minVec.x, maxVec.x, seed ), util.SharedRandom( ( name .. "_Y" ), minVec.y, maxVec.y, seed ), util.SharedRandom( ( name .. "_Z" ), minVec.z, maxVec.z, seed ) )

end

hab.RandomVector = function( minVec, maxVec )

	minVec = minVec or vecNeg
	maxVec = maxVec or vecPos

	return Vector( math.Rand( minVec.x, maxVec.x ), math.Rand( minVec.y, maxVec.y ), math.Rand( minVec.z, maxVec.z ) )

end

if CLIENT then

hab.Menu.ClientSettings = "Client Settings"
hab.Menu.ServerSettings = "Server Settings"

hab.Menu.AddMenuPanel = function( title, section, func )

	hab.menus[title] = hab.menus[title] or {}

	hab.menus[title][section] = hab.menus[title][section] or func

end

hab.PopulateMenus = function( )

	for name, title in SortedPairs( hab.menus ) do

		for section, func in SortedPairs( title ) do

			spawnmenu.AddToolMenuOption( "HAB", name, name .."_".. section, section, "", "", func )

		end

	end

end

hab.hook( "PopulateToolMenu", "HAB_PopulateToolMenu", function( )

	hab.PopulateMenus( )

end )

end
