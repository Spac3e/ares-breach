/********************************
Player functions
********************************/

local meta = FindMetaTable("Player")

function SteamIDToSteamID32(steamid)
	local acc32 = tonumber(steamid:sub(11))
	if acc32 == nil then --bot fix
		return (tonumber(player.GetBySteamID(steamid):SteamID64()) - 90071996842377215) * -1
	end
	return tostring((acc32 * 2) + tonumber(steamid:sub(9,9)))
end

function meta:SteamID32()
	return SteamIDToSteamID32(self:SteamID())
end

--[[---------------------------------------------------------
	GetPData
	Saves persist data for this player
-----------------------------------------------------------]]
function meta:GetPData( name, default )

	name = Format( "%s[%s]", self:SteamID32(), name )
	local val = sql.QueryValue( "SELECT value FROM playerpdata WHERE infoid = " .. SQLStr( name ) .. " LIMIT 1" )
	if ( val == nil ) then return default end

	return val

end

--[[---------------------------------------------------------
	SetPData
	Set persistant data
-----------------------------------------------------------]]
function meta:SetPData( name, value )

	name = Format( "%s[%s]", self:SteamID32(), name )
	return sql.Query( "REPLACE INTO playerpdata ( infoid, value ) VALUES ( " .. SQLStr( name ) .. ", " .. SQLStr( value ) .. " )" ) ~= false

end

--[[---------------------------------------------------------
	RemovePData
	Remove persistant data
-----------------------------------------------------------]]
function meta:RemovePData( name )

	name = Format( "%s[%s]", self:SteamID32(), name )
	return sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( name ) ) ~= false

end

/********************************
Utility functions
********************************/

--[[---------------------------------------------------------
	Name: GetPData( steamid, name, default )
	Desc: Gets the persistant data from a player by steamid
-----------------------------------------------------------]]
function util.GetPData( steamid, name, default )

	name = Format( "%s[%s]", SteamIDToSteamID32( steamid ), name )
	local val = sql.QueryValue( "SELECT value FROM playerpdata WHERE infoid = " .. SQLStr( name ) .. " LIMIT 1" )
	if ( val == nil ) then return default end

	return val

end

--[[---------------------------------------------------------
	Name: SetPData( steamid, name, value )
	Desc: Sets the persistant data of a player by steamid
-----------------------------------------------------------]]
function util.SetPData( steamid, name, value )

	name = Format( "%s[%s]", SteamIDToSteamID32( steamid ), name )
	sql.Query( "REPLACE INTO playerpdata ( infoid, value ) VALUES ( " .. SQLStr( name ) .. ", " .. SQLStr( value ) .. " )" )

end

--[[---------------------------------------------------------
	Name: RemovePData( steamid, name )
	Desc: Removes the persistant data from a player by steamid
-----------------------------------------------------------]]
function util.RemovePData( steamid, name )

	name = Format( "%s[%s]", SteamIDToSteamID32( steamid ), name )
	sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( name ) )

end