hab.player = function( p )

	p.hab = p.hab or {}

	p.hab.cvars = p.hab.cvars or {}
	p.hab.cval = p.hab.cval or {}

end

local PLAYER = FindMetaTable( "Player" )
local WEAPON = FindMetaTable( "Weapon" )
local VEHICLE = FindMetaTable( "Vehicle" )
local ENTITY = FindMetaTable( "Entity" )
local VECTOR = FindMetaTable( "Vector" )
local ANGLE = FindMetaTable( "Angle" )
local CMOVEDATA = FindMetaTable( "CMoveData" )

function ENTITY:GetVehicleType( )

	return self.VehicleType or HVAP_VEHICLE_GENERIC

end

function VECTOR:CalculateVectorDot( vec )

	local x = self:DotProduct( vec )
	local y = self:DotProduct( vec )
	local z = self:DotProduct( vec )

	return Vector( x, y, z )

end

function ANGLE:CalculateVectorDot( vec )

	local x = self:Forward( ):DotProduct( vec )
	local y = self:Right( ):DotProduct( vec )
	local z = self:Up( ):DotProduct( vec )

	return Vector( x, y, z )

end

function CMOVEDATA:RemoveKeys( keys )

	local newbuttons = bit.band( self:GetButtons( ), bit.bnot( keys ) )

	self:SetButtons( newbuttons )

end

function PLAYER:GetNWSteamID( )

	return self:GetNWString( "hab_steam_id", self:GetNW2String( "hab_steam_id", 0 ) )

end

function PLAYER:GetNW2SteamID( )

	return self:GetNW2String( "hab_steam_id", self:GetNWString( "hab_steam_id", 0 ) )

end

function PLAYER:IsMoving( )

	if !IsValid( self ) or !self:Alive( ) then return false end

	local keydown = self:KeyDown( IN_FORWARD ) or self:KeyDown( IN_BACK ) or self:KeyDown( IN_MOVELEFT ) or self:KeyDown( IN_MOVERIGHT )

	return keydown and self:OnGround( )

end

function PLAYER:IsRunning( )

	if !IsValid( self ) or !self:Alive( ) then return false end

	return self:IsMoving( ) and self:KeyDown( IN_SPEED )

end

function PLAYER:HasHelmet( )

	return self.HasHelmet or false

end

function PLAYER:SetPlayerDSP( number, b )

	if IsValid( self ) and self:Alive( ) then

		local force = ( CLIENT and b ) or false

		self:SetDSP( number, force )

	end

end

if SERVER then

function PlayerInitialSpawnDelayed( ply ) end

elseif CLIENT then

function cPlayerInitialSpawnDelayed( ply ) end

function cPlayerSpawn( ply ) end

end

function WEAPON:GetOwner( )

	return self.Owner

end