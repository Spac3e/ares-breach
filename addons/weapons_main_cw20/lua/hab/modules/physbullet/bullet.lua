--[[


addons/[weapons]_phys_bullet/lua/hab/modules/physbullet/bullet.lua

--]]


local MODULE = hab.Module.PhysBullet

MODULE.EntityCache = MODULE.EntityCache or {}

local math = math
local math_min = math.min
local math_modf = math.modf
local util = util
local CurTime = CurTime
local pairs = pairs
local table = table
local IsValid = IsValid
local net = net
local Vector = Vector
local EffectData = EffectData
local DamageInfo = DamageInfo
local player = player
local LocalPlayer = LocalPlayer
local soundPlay = sound.Play
local Entity = Entity
local CLIENT = CLIENT
local SERVER = SERVER
local cam = cam
local render = render
local tonumber = tonumber
local EyeAngles = EyeAngles
local EyePos = EyePos
local DynamicLight = DynamicLight
local TraceLine = util.TraceLine
local tobool = tobool
local hook = hook
local PointContents = util.PointContents
local vectorMeta = FindMetaTable("Vector")
local vectorLength = vectorMeta.Length
local utilDistanceToLine = util.DistanceToLine

BULLET_PENTEST_RESOLUTION = 4

local maxcspread = Vector( 0.032, 0.032, 0.032 )
local downVec = Vector( 0, 0, HAB_GRAVITY )

local fos = {}
local function FindOppoiteSide( startPos, dir, max, filter, mask, out )

	local i, add = 0, ( dir * BULLET_PENTEST_RESOLUTION )
	out =  out or {}

	fos.start 	= startPos + add
	fos.endpos 	= startPos
	fos.filter 	= filter
	fos.mask 	= mask
	fos.output	= out

	while i < max do

		TraceLine( fos )
--		local len = vectorLength( out.StartPos - out.HitPos )

		if ( out.Hit and out.Fraction != 0 and out.Fraction != 1 ) then

			i = i + ( BULLET_PENTEST_RESOLUTION * out.Fraction )

			break

		else

			fos.endpos = fos.start
			fos.start = fos.start + add
			i = i + BULLET_PENTEST_RESOLUTION

			continue

		end

	end

	out.StartPos = startPos
	out.Thickness = i

	return out

end

local ballistics = { -- ballistic behavior tables
--[[
	100% 	= {		25,		17,		19,		32,		31		},
	50% 	= {		30,		21,		27,		40,		39		},
	0%		= {		43,		28,		42,		55,		53		},

	[SHAPE] = {
		drag = DRAG, -- balistic drag
		quad = { r, A, B, C } --ricochetability quadratic inputs
	},
]]
	[HAB_BULLET_MODEL_G1] = {

		drag = 0.22,
		quad = {
			r = 1,
			A = -0.34188034188,
			B = 28.803418803,
			C = -506.41025641
		},

		c10 = 25,
		c05 = 30,
		c00 = 43,

	},

	[HAB_BULLET_MODEL_G2] = {

		drag = 0.2,
		quad = {
			r = 1,
			A = -0.487012987,
			B = 31.00649351,
			C = -386.3636364
		},

		c10 = 17,
		c05 = 21,
		c00 = 28,

	},

	[HAB_BULLET_MODEL_G7] = {

		drag = 0.18,
		quad = {
			r = 1,
			A = -0.126811594203,
			B = 12.0833333333,
			C = -183.804347826
		},

		c10 = 19,
		c05 = 27,
		c00 = 42,

	},

	[HAB_BULLET_MODEL_GS] = {

		drag = 0.6,
		quad = {
			r = 1,
			A = -0.1268115942,
			B = 15.380434783,
			C = -362.31884058
		},

		c10 = 32,
		c05 = 40,
		c00 = 55,

	},

	[HAB_BULLET_MODEL_GL] = {

		drag = 0.23,
		quad = {
			r = 1,
			A = -0.12175324675,
			B = 14.772727273,
			C = -340.94967532
		},

		c10 = 31,
		c05 = 39,
		c00 = 53,

	},
}

local function PhysBulletCalculateBullet( Ent, Index, Bullet ) -- process the bullet, return true for stop

	if !Ent or !Index or !Bullet then return false end

--	if Bullet.FiredTime + 0.25 < CurTime( ) then return false end

	Bullet.TickCount = Bullet.TickCount + 1

	Bullet.PointContents = PointContents( Bullet.Position )
	if bit.band( Bullet.PointContents, CONTENTS_SOLID ) == CONTENTS_SOLID or Bullet.Velocity < 8 then -- were too slow or inside something, remove

		Ent:PhysBulletRemove( Index )

		return true

	end

	Bullet.Underwater = Bullet.PointContents == bit.band( Bullet.PointContents, CONTENTS_WATER ) == CONTENTS_WATER

	Bullet.FlightVectorLength = vectorLength( Bullet.FlightVector )
	Bullet.FlightDirection = Bullet.FlightVector:GetNormalized( )
	Bullet.VelocityFraction = Bullet.FlightVectorLength / Bullet.VelocityInitial
	Bullet.InvVelocityFraction = math.max( 1 - Bullet.VelocityFraction, 0 )

	Bullet.TraceTable.start = Bullet.Position -- set next start to cur pos
	Bullet.TraceTable.endpos = Bullet.Position + Bullet.FlightVector -- set next end to pos + flv

	Bullet.PenetrationLeft = Bullet.Penetration * Bullet.VelocityFraction

	local override = hook.Call( "PhysBulletOnTick", MODULE, Ent, Index, Bullet )
	if override then return override end

	if Bullet.Fused and Bullet.TimeLeft < CurTime( ) then

		MODULE:PhysBulletAirBurst( Ent, Index, Bullet )

	end

	::prehitEx::

	if SERVER and ( Ent:IsPlayer( ) ) then -- start lag compensation

--		Ent:LagCompensation( true )

	end

	TraceLine( Bullet.TraceTable ) -- preform trace

	if SERVER and ( Ent:IsPlayer( ) ) then -- stop lag compensation

--		Ent:LagCompensation( false )

	end

	prehit = Bullet.tr.Hit
	if Ent == Bullet.tr.Entity then
		prehit = false
	end
	if prehit then

		local prex = hook.Call( "PhysBulletOnBulletTraceHit", MODULE, Ent, Inde, Bullet, Bullet.tr )
		if prex then

			prehit = false

			if IsValid( Bullet.tr.Entity ) then

				table.insert( Bullet.TraceTable.filter, Bullet.tr.Entity )

			end

			Bullet.TraceTable.start = Bullet.tr.HitPos

			goto prehitEx

		end

	end

	if prehit then -- we hit something

		if Bullet.tr.HitSky then -- hit sky, remove

			Ent:PhysBulletRemove( Index )

			return true

		end

		Bullet.TailPosition = Bullet.LastPosition
		Bullet.LastPosition = Bullet.Position -- update last position
		Bullet.Position = Bullet.tr.HitPos -- update position

		Bullet.Surf = Bullet.tr.SurfaceProps -- update hit surfaceproperty
		Bullet.Mat = Bullet.tr.MatType -- update hit material
		Bullet.MatTable = ( MODULE.SurfaceProperties[Bullet.tr.SurfaceProps] or MODULE.MaterialModifiers[Bullet.Mat] )

		if Bullet.Surf == SURF_WATER then

			MODULE:PhysBulletWaterPass( Ent, Index, Bullet )

			return false

		end

		Bullet.Dot = Bullet.FlightDirection:Dot( -Bullet.tr.HitNormal ) -- calc impact angle(RAD)
		Bullet.ImpactAngle = math.deg( math.acos( Bullet.Dot ) ) -- calc impact ang(DEG) with normalization
		Bullet.ImpactNormalizationDir = ( Bullet.FlightDirection - ( Bullet.tr.HitNormal * Bullet.Dot * Bullet.VelocityFraction / Bullet.MatTable.nrm[Bullet.BalisticsType] ) / 10 )


		local pp = Bullet.PenetrationLeft * Bullet.MatTable.pen[Bullet.BalisticsType] -- calc penetration power
		FindOppoiteSide( Bullet.Position, Bullet.ImpactNormalizationDir, pp, Bullet.Filter, Bullet.TraceTable.mask, Bullet.pr ) -- find the other side of the hit surface and output to Bullet.pr

		if Bullet.tr.Entity == Bullet.Attacker then

			MODULE:PhysBulletPenetrate( Ent, Index, Bullet )

			return false

		end

		--[[
		local thickness = 0
		if Bullet.pr.Hit and Bullet.pr.Fraction != 0 and Bullet.pr.Fraction != 1 then -- pentest passed

			thickness = vectorLength( Bullet.pr.StartPos - Bullet.pr.HitPos ) / Bullet.MatTable.pen[Bullet.BalisticsType] / HAB_MILIMETERS_TO_SOURCE / 2 -- calc thickness in source

		end

		if thickness != 0 and ( Bullet.Caliber * math.ceil( hab.CalculateQuadratic( 0.99867905684055, 0.000605128205128, -0.01388624708625, 1.1034545454545, Bullet.ImpactAngle ), 3 ) * Bullet.VelocityFraction ) > thickness then -- we overmatched, ignore normalization and penetrate

			MODULE:PhysBulletPenetrate( Ent, Index, Bullet )

			Bullet.FlightVector = ( Bullet.FlightVectorLength * ( 1 - thickness / pp ) * Bullet.VelocityFraction ) * Bullet.FlightDirection

			return false

		end
		--]]

		--local penetratethisshit = hook.Call("PhysBulletCustomPenetrate", Ent, Bullet, Bullet.tr)
		--if penetratethisshit then
			--MODULE:PhysBulletPenetrate( Ent, Index, Bullet )
			--return false
		--end

		local goc_ammo = 65

		--print(Ent)
  		if Ent then
    		if Ent.GetActiveWeapon then
    			if Ent:GetActiveWeapon().GetPrimaryAmmoType then
      				local ammo = Ent:GetActiveWeapon():GetPrimaryAmmoType()
      				if Bullet.tr.Entity:GetClass() == "ent_goc_shield" and ammo == goc_ammo then
      					MODULE:PhysBulletPenetrate( Ent, Index, Bullet )
        				return false
      				end
      			end
    		end
  		end

		local chance = 0 -- chance to ricochet
		Bullet.ImpactAngle = math.Clamp( ( 90 - Bullet.ImpactAngle - Bullet.MatTable.nrm[Bullet.BalisticsType] ) * Bullet.MatTable.ric, 0, 90 ) 

		if Bullet.ImpactAngle > ( ballistics[Bullet.BalisticsType].c10 ) then -- impact angle is greater than than c10

			if Bullet.ImpactAngle < ( ballistics[Bullet.BalisticsType].c00 ) then -- impact angle is less than c00, calculate chance from quadratic c00-c05-c10, else chance = 0 ( dont bounce )

				chance = 1 - hab.CalculateQuadratic( -- chance the round will ricochet (positive correlation)
					ballistics[Bullet.BalisticsType].quad.r,	-- r
					ballistics[Bullet.BalisticsType].quad.A,	-- A
					ballistics[Bullet.BalisticsType].quad.B,	-- B
					ballistics[Bullet.BalisticsType].quad.C,	-- C
					Bullet.ImpactAngle -- y
				) / 100 

			end

		else -- impact angle is within c10, 100% bounce

			chance = 1

		end

		--if ( chance > util.SharedRandom( "HAB_PhysBullet_SharedRandom", 0.0, 3.0, ( Bullet.RandomSeed + chance ) ) ) then -- chance to ricochet, calculate ricochet

			--MODULE:PhysBulletRicochet( Ent, Index, Bullet )
			--return false

		--end

		
		--[[
		local pen = Bullet.PenetrationLeft - thickness -- how much penetration power we might have left in mm

		if pen != Bullet.PenetrationLeft and pen > 0 then -- we have some penetration power

			MODULE:PhysBulletPenetrate( Ent, Index, Bullet )

			Bullet.FlightVector = ( Bullet.FlightVectorLength * math_min( pen / Bullet.Penetration, 1 ) ) * Bullet.ImpactNormalizationDir

			return false

		end
		--]]

		MODULE:PhysBulletImpact( Ent, Index, Bullet )

		return true

	end

	if Bullet.Mass != 0 then

		local drop = downVec / Bullet.Mass * TICKRATE
		Bullet.FlightMod = Bullet.FlightMod - drop

		local drift = hab.SharedRandomVector( "Bullet_Drift", -Bullet.ClampSpread, Bullet.ClampSpread, Bullet.RandomSeed + Bullet.TickCount ):GetNormalized( ) * math.max( 0.5 - Bullet.VelocityFraction / 2 - 0.128, 0.1 ) * ( Bullet.Ricochet + 0.5 ) * 10
		local drag = ( Bullet.Caliber / Bullet.Mass ) * ballistics[Bullet.BalisticsType].drag * math.min( Bullet.VelocityFraction + 0.128, 1 ) * ( Bullet.Underwater and 32 or 8 )
		Bullet.Velocity = Bullet.Velocity - drag

		Bullet.FlightVector = ( Bullet.FlightDirection * Bullet.Velocity ) + Bullet.FlightMod + drift -- calculate new flight vector

	else

		local drift = hab.SharedRandomVector( "Bullet_Drift", -Bullet.ClampSpread, Bullet.ClampSpread, Bullet.RandomSeed + Bullet.TickCount ) * Bullet.InvVelocityFraction * 50 * ( Bullet.Ricochet / 2 + 0.5 )

		Bullet.FlightVector = Bullet.FlightDirection * Bullet.Velocity + drift -- calculate new flight vector

	end

	Bullet.TailPosition = Bullet.LastPosition
	Bullet.LastPosition = Bullet.Position
	Bullet.Position = Bullet.Position + Bullet.FlightVector -- update position

	Bullet.LastUpdated = CurTime( )

	return false

end

hab.hook( "Tick", "HAB_PhysBullet_Tick", function( )

	for _, e in pairs( MODULE.EntityCache ) do
		if isnumber(e) then
			table.remove(MODULE.EntityCache, _)
			continue
		end

		if e.PhysBulletCache then -- see if the ent has bullets

			for k, v in pairs( e.PhysBulletCache ) do -- process bullets

				if !v.ShouldRemove then -- the bullet should have been removed, ignore it

					PhysBulletCalculateBullet( e, k, v )

				else

					e:PhysBulletRemove( k )

				end

			end

			if SERVER and e:IsPlayer( ) and e:IsLagCompensated( ) then

--				e:LagCompensation( false )

			end

		end

	end

end )


local ENTITY = FindMetaTable( "Entity" )

function ENTITY:FirePhysicalBullets( bulletInfo ) -- fire bullet using data from Entity:FireBullets( )
--if CLIENT then
--print(debug.traceback())
--end
	if CLIENT and !bulletInfo.SentFromServer and !IsFirstTimePredicted( ) then return end

	local entIndex = self:EntIndex( )
	MODULE.EntityCache[entIndex] = MODULE.EntityCache[entIndex] or self

	self.PhysBulletCache = self.PhysBulletCache or {} -- define self cache
	self.PhysBulletIndex = self.PhysBulletIndex or 0 -- define self index

-- fixup physbullet data
	bulletInfo.AmmoType = ( MODULE.AmmoTypes[bulletInfo.AmmoType] and bulletInfo.AmmoType or "Default" )
	local AmmoData = MODULE.AmmoTypes[bulletInfo.AmmoType]

	bulletInfo.Spread.z = bulletInfo.Spread.x -- set spread.z to spread.x

	bulletInfo.Num = math_min( bulletInfo.Num or AmmoData.Number, 64 )

	bulletInfo.Velocity = math_min( bulletInfo.Velocity or AmmoData.Velocity, 65536 )
	bulletInfo.Position = bulletInfo.Src

	bulletInfo.HullSize = 0 --( bulletInfo.HullSize or AmmoData.HullSize ) * HAB_METERS_TO_SOURCE -- nobody cares about hullsize
	bulletInfo.Penetration = math_min( math.Truncate( ( bulletInfo.Penetration or AmmoData.Penetration ), 1 ), 1638.4 ) -- clamp penetration to 1638.4 1 decimal place for netcode optimization

	bulletInfo.BulletType = ( bulletInfo.BulletType or AmmoData.BulletType )
	bulletInfo.BalisticsType = ( bulletInfo.BalisticsType or AmmoData.BalisticsType )

	bulletInfo.TimeToLive = ( bulletInfo.TimeToLive or AmmoData.TimeToLive )

	bulletInfo.Fused = ( bulletInfo.Fused or AmmoData.Fused )
	bulletInfo.Proximity = ( bulletInfo.Proximity or AmmoData.Proximity )
	bulletInfo.Radius = ( bulletInfo.Radius or AmmoData.Radius )

	bulletInfo.Caliber = ( bulletInfo.Caliber or AmmoData.Caliber )
	bulletInfo.Mass = ( bulletInfo.Mass or AmmoData.Mass )
	bulletInfo.Attacker = e

	if bulletInfo.Tracer != nil then

		bulletInfo.Tracer = tobool( bulletInfo.Tracer )

	else

		bulletInfo.Tracer = tobool( AmmoData.tracer )

	end

	bulletInfo.Color = ( bulletInfo.Color or AmmoData.Color )

	if !bulletInfo.Filter then

		bulletInfo.Filter = bulletInfo.Filter or {}

		if self.Children then

			table.Add( bulletInfo.Filter, self.Children )

		else

			local filter
			if IsValid( bulletInfo.IgnoreEntity ) then

				filter = bulletInfo.IgnoreEntity:GetChildren( )
				table.insert( filter, bulletInfo.IgnoreEntity )

			elseif istable( bulletInfo.IgnoreEntity ) then

				table.Add( filter, bulletInfo.IgnoreEntity )

			else

				filter = self:GetChildren( )
				table.insert( filter, self )

			end

			table.Add( bulletInfo.Filter, filter )

		end

	end

	if SERVER then

		local rec = RecipientFilter( ) -- create net.Send filter
		rec:AddAllPlayers( ) -- add everyone

		bulletInfo.NetToClients = ( bulletInfo.NetToClients or true )

		bulletInfo.FiredTime = math.Truncate( CurTime( ), 6 )
		bulletInfo.integral, bulletInfo.fractional = math_modf( bulletInfo.FiredTime )
		bulletInfo.fractional = math.Round( bulletInfo.fractional, 6 )

		if bulletInfo.NetToClients and IsValid( bulletInfo.Attacker ) and bulletInfo.Attacker == self and bulletInfo.Attacker:IsPlayer( ) then

			rec:RemovePlayer( bulletInfo.Attacker )

		end

		net.Start( "HAB_PhysBullet_NW_CreateBullet", true ) -- send client bullet data, ( sending separatley is more effecient than tables, 185~ bytes vs 51~ )

			net.WriteEntity( self ) -- write entity firing

			net.WriteUInt( bulletInfo.Num, 6 ) -- write Num

			net.WriteString( bulletInfo.AmmoType ) -- write AmmoType

			net.WriteUInt( bulletInfo.Velocity, 16 ) -- write Velocity
			net.WriteFloatVector( bulletInfo.Src ) -- write Position
			net.WriteFloatVector( bulletInfo.Dir ) -- write Dir

			net.WriteFloat( bulletInfo.Spread.x ) -- write Spread.x
			net.WriteFloat( bulletInfo.Spread.y ) -- write Spread.y
--			net.WriteFloatVector( bulletInfo.Spread ) -- write Spread

--			net.WriteFloat( bulletInfo.HullSize ) -- write HullSize
			net.WriteUInt( bulletInfo.Penetration * 10, 14 ) -- write Penetration

			net.WriteUInt( bulletInfo.BulletType, 2 ) -- write BulletType
			net.WriteUInt( bulletInfo.BalisticsType, 3 ) -- write BalisticsType

			net.WriteBool( bulletInfo.Fused ) -- write Fused
			net.WriteBool( bulletInfo.Proximity ) -- write Proximity
			if bulletInfo.Proximity then -- if bullet is prox write prox info

				net.WriteFloat( bulletInfo.Radius ) -- write Radius

			end

			net.WriteFloat( bulletInfo.Caliber ) -- write Caliber
			net.WriteFloat( bulletInfo.Mass ) -- write Mass

			net.WriteUInt( bulletInfo.integral, 28 ) -- write FiredTime
			net.WriteFloat( bulletInfo.fractional ) -- write FiredTime
			net.WriteFloat( bulletInfo.TimeToLive ) -- write TimeLeft

			net.WriteBool( bulletInfo.Tracer ) -- write Tracer
			if bulletInfo.Tracer then -- if the bullet is a tracer wirte tracer info

				net.WriteColor( bulletInfo.Color ) -- write Color

			end

			if bulletInfo.Filter then

				local _filter_tab = table.ClearKeys( bulletInfo.Filter )
				local count = #_filter_tab
				if count == 0 then

					net.WriteBool( false ) -- write Filter Type

				else

					net.WriteBool( true ) -- write Filter Type
					net.WriteUInt( count, 8 ) -- write filter length, 258 better be enough

					for i = 1, count do

						net.WriteEntity( _filter_tab[i] )

					end

				end

			else

				net.WriteBool( false ) -- write Filter Type

			end

		net.WriteEntity( bulletInfo.IgnoreEntity ) -- write IgnoreEntity

		net.Send( rec ) -- send to viewers

		bulletInfo.Damage = ( ( bulletInfo.Damage != 0 and bulletInfo.Damage ) or AmmoData.plydmg )

		bulletInfo.Force = ( bulletInfo.Force or AmmoData.force )
		bulletInfo.DamageType = ( bulletInfo.dmgtype or AmmoData.dmgtype )
		bulletInfo.BlastDamage = ( bulletInfo.BlastDamage or AmmoData.BlastDamage )
		bulletInfo.BlastDamageType = ( bulletInfo.BlastDamageType or AmmoData.BlastDamageType )
		bulletInfo.BlastDamageRadius = ( bulletInfo.BlastDamageRadius or AmmoData.BlastDamageRadius )

		bulletInfo.WeaponFiring = ( bulletInfo.WeaponFiring or self )

	elseif CLIENT then

		if bulletInfo.fractional then

			bulletInfo.FiredTime = bulletInfo.integral + bulletInfo.fractional

		else

			bulletInfo.FiredTime = math.Truncate( CurTime( ), 6 )
			bulletInfo.integral, bulletInfo.fractional = math_modf( bulletInfo.FiredTime )
			bulletInfo.fractional = math.Round( bulletInfo.fractional, 6 )

		end

		local viewer = LocalPlayer( ):GetViewEntity( )
		bulletInfo.Dist = viewer:GetPos( ):Distance( bulletInfo.Src )

	end

	bulletInfo.TimeLeft = bulletInfo.FiredTime + bulletInfo.TimeToLive

	bulletInfo.Velocity = bulletInfo.Velocity
	bulletInfo.Caliber = bulletInfo.Caliber

	bulletInfo = hook.Call( "PhysBulletOnCreated", MODULE, self, -1, bulletInfo, bulletInfo.SentFromServer ) or bulletInfo

	local pointcont = PointContents( bulletInfo.Src )
	local underwater = ( pointcont == CONTENTS_WATER )

	for i = 1, bulletInfo.Num do -- add bullets to cache for processing

		local Bullet = {}

		Bullet.AmmoType = bulletInfo.AmmoType

		Bullet.Velocity = bulletInfo.Velocity
		Bullet.VelocityInitial = bulletInfo.Velocity
		Bullet.FlightMod = Vector( )

		Bullet.Position = bulletInfo.Src
		Bullet.TailPosition = bulletInfo.Src
		Bullet.LastPosition = bulletInfo.Src

		Bullet.PositionInterpolated = bulletInfo.Src

		Bullet.Spread = bulletInfo.Spread
		Bullet.ClampSpread = maxcspread

		Bullet.HullSize = 0

		Bullet.BulletType = bulletInfo.BulletType
		Bullet.BalisticsType = bulletInfo.BalisticsType

		Bullet.Fused = bulletInfo.Fused
		Bullet.Proximity = bulletInfo.Proximity
		Bullet.Radius = bulletInfo.Radius

		Bullet.Damage = bulletInfo.Damage

		Bullet.Force = bulletInfo.Force
		Bullet.DamageType = bulletInfo.DamageType
		Bullet.BlastDamage = bulletInfo.BlastDamage
		Bullet.BlastDamageType = bulletInfo.BlastDamageType
		Bullet.BlastDamageRadius = bulletInfo.BlastDamageRadius

		Bullet.Attacker = bulletInfo.Attacker
		Bullet.WeaponFiring = bulletInfo.WeaponFiring

		Bullet.Caliber = bulletInfo.Caliber
		Bullet.InvCaliber = math.sqrt( bulletInfo.Caliber )
		Bullet.Mass = bulletInfo.Mass

		Bullet.FiredTime = bulletInfo.FiredTime
		Bullet.TimeToLive = bulletInfo.TimeToLive
		Bullet.TimeLeft = bulletInfo.TimeLeft

		Bullet.LastUpdated = bulletInfo.FiredTime
		Bullet.TickCount = 0

		Bullet.Penetration = bulletInfo.Penetration --/ HAB_MILIMETERS_TO_SOURCE
		Bullet.PenetrationLeft = bulletInfo.Penetration


		Bullet.Tracer = bulletInfo.Tracer
		Bullet.Color = bulletInfo.Color
		Bullet.TracerDelay = CurTime( )

		Bullet.Dist = bulletInfo.Dist

		Bullet.VelocityFraction = 0
		Bullet.InvVelocityFraction = 1

		Bullet.Ricochet = 0
		Bullet.Mat = 0

		Bullet.PointContents = pointcont
		Bullet.HitWater = underwater
		Bullet.Underwater = underwater

		Bullet.ShouldRemove = false
		Bullet.LostStability = false

		Bullet.MatTable = {}

		Bullet.tr = {}
		Bullet.pr = {}

		Bullet.GroupIndex = i -- set the bullets group index

		if self.PhysBulletIndex >= hab.cval.PhysBullet.MaxAlive then -- index is greater than the max, 

			local found = false
			for c = 1, hab.cval.PhysBullet.MaxAlive do -- find lowest open slot

				if !self.PhysBulletCache[c] then -- slot found, use

					found = true
					self.PhysBulletIndex = c

					break

				end

			end

			if !found then -- no open slots, replace 1

				self:PhysBulletRemove( 1 ) -- remove first bullet
				self.PhysBulletIndex = 1 -- set index to 1

--				hab.Dmsg( "Warning, Bullet Cache Exceeded " .. hab.cval.PhysBullet.MaxAlive .. "! Replacing Index:1" )

			end

		end

		self.PhysBulletIndex = self.PhysBulletIndex + 1 -- increment the index
		Bullet.BulletIndex = self.PhysBulletIndex -- set the bullets final indexing

		Bullet.RandomSeed = ( bulletInfo.fractional * 1000000 ) - (  Bullet.GroupIndex + Bullet.BulletIndex )-- set the bullets random generator value
		local initLen = util.SharedRandom( "Velocity_Var", -16, 16, Bullet.RandomSeed )

		local spread = hab.SharedRandomVector( "Bullet_Spread", -bulletInfo.Spread, bulletInfo.Spread, Bullet.RandomSeed ) * 100
		spread.z = spread.y
		spread.y = 0

		Bullet.FlightVector = bulletInfo.Dir * ( Bullet.Velocity + initLen ) + spread

		Bullet.TraceTable = {

			start 	= nil,
			endpos 	= nil,

			filter 	= bulletInfo.Filter,
			mask 	= MASK_SHOT + CONTENTS_WATER,
			output	= Bullet.tr

		}

		local precheck = PhysBulletCalculateBullet( self, Bullet.BulletIndex, Bullet )
		if Bullet and !precheck then

			table.insert( self.PhysBulletCache, Bullet ) -- set final bullet structure

		end

--		hab.Dmsg( tostring( self ) .. " Fired: " .. self.PhysBulletIndex )

	end

end

function ENTITY:PhysBulletRemove( Index ) -- remove bullet from cache

	if !self.PhysBulletCache[Index] then return end

	self.PhysBulletCache[Index].ShouldRemove = true

	self.PhysBulletIndex = Index
--	hab.Dmsg( tostring(self) .. " Removing: " .. Index .. " " .. self.PhysBulletCache[Index].BulletIndex )

--	table.remove( self.PhysBulletCache, Index ) -- remove bullet
	self.PhysBulletCache[Index] = nil

end

function MODULE:CreateEffects( Ent, Index, Bullet, Mode )

	local e = Bullet.tr.Entity
	if e == Ent then return end
	if e:GetClass() == "ent_goc_shield" then return end

	local flags = HAB_BULLET_EF_NONE
	local override = hook.Call( "PhysBulletOnBulletCreateEffects", MODULE, Ent, Index, Bullet, Mode )
	if override then
	
		if override == HAB_BULLET_EF_DISABLEEFFECT then

			return

		else

			flags = flags + override

		end

	end

	if Ent == LocalPlayer() then
	local effectdata = EffectData( )
		effectdata:SetDamageType( Bullet.BulletType )
		--print("bullettype "..Bullet.BulletType)
		effectdata:SetEntity( e ) -- hit ent
		--print("hitent "..e:EntIndex())
		effectdata:SetHitBox( Bullet.tr.HitGroup or -1 ) -- hitgroup
		--print("hitgroup "..Bullet.tr.HitGroup or -1)
		effectdata:SetMagnitude( Bullet.Caliber ) -- caliber
		--print("caliber "..Bullet.Caliber)
		effectdata:SetNormal( Bullet.tr.HitNormal or Bullet.FlightDirection ) -- direction 1
		--print("dir1 "..tostring(Bullet.tr.HitNormal or Bullet.FlightDirection))
		effectdata:SetOrigin( Bullet.Position ) -- position
		--print("pos "..tostring(Bullet.Position))
		effectdata:SetScale( Bullet.Caliber / 64 ) -- size --EffectSize
		--print("size "..Bullet.Caliber / 64)
		effectdata:SetStart( -( Bullet.tr.Normal or Bullet.FlightDirection ) ) -- direction 2
		--print("dir2 "..tostring(-( Bullet.tr.Normal or Bullet.FlightDirection )))
		effectdata:SetSurfaceProp( Bullet.Surf or 0 ) -- hit material
		--print("hitmat "..Bullet.Surf or 0)
		effectdata:SetAttachment( Mode )
		--print("mode "..Mode)
		effectdata:SetFlags( flags )
		--print("flags "..flags)
		util.Effect( "hab_physbullet_effects", effectdata )
	end

	if Ent:IsPlayer() then
		if Ent:IsBot() then
			local effectdata = EffectData( )
			effectdata:SetDamageType( Bullet.BulletType )
			--print("bullettype "..Bullet.BulletType)
			effectdata:SetEntity( e ) -- hit ent
			--print("hitent "..e:EntIndex())
			effectdata:SetHitBox( Bullet.tr.HitGroup or -1 ) -- hitgroup
			--print("hitgroup "..Bullet.tr.HitGroup or -1)
			effectdata:SetMagnitude( Bullet.Caliber ) -- caliber
			--print("caliber "..Bullet.Caliber)
			effectdata:SetNormal( Bullet.tr.HitNormal or Bullet.FlightDirection ) -- direction 1
			--print("dir1 "..tostring(Bullet.tr.HitNormal or Bullet.FlightDirection))
			effectdata:SetOrigin( Bullet.Position ) -- position
			--print("pos "..tostring(Bullet.Position))
			effectdata:SetScale( Bullet.Caliber / 64 ) -- size --EffectSize
			--print("size "..Bullet.Caliber / 64)
			effectdata:SetStart( -( Bullet.tr.Normal or Bullet.FlightDirection ) ) -- direction 2
			--print("dir2 "..tostring(-( Bullet.tr.Normal or Bullet.FlightDirection )))
			effectdata:SetSurfaceProp( Bullet.Surf or 0 ) -- hit material
			--print("hitmat "..Bullet.Surf or 0)
			effectdata:SetAttachment( Mode )
			--print("mode "..Mode)
			effectdata:SetFlags( flags )
			--print("flags "..flags)
			util.Effect( "hab_physbullet_effects", effectdata )
		end
	end

	if !Ent:IsPlayer() then
		if Ent:IsNPC() then
			local effectdata = EffectData( )
			effectdata:SetDamageType( Bullet.BulletType )
			--print("bullettype "..Bullet.BulletType)
			effectdata:SetEntity( e ) -- hit ent
			--print("hitent "..e:EntIndex())
			effectdata:SetHitBox( Bullet.tr.HitGroup or -1 ) -- hitgroup
			--print("hitgroup "..Bullet.tr.HitGroup or -1)
			effectdata:SetMagnitude( Bullet.Caliber ) -- caliber
			--print("caliber "..Bullet.Caliber)
			effectdata:SetNormal( Bullet.tr.HitNormal or Bullet.FlightDirection ) -- direction 1
			--print("dir1 "..tostring(Bullet.tr.HitNormal or Bullet.FlightDirection))
			effectdata:SetOrigin( Bullet.Position ) -- position
			--print("pos "..tostring(Bullet.Position))
			effectdata:SetScale( Bullet.Caliber / 64 ) -- size --EffectSize
			--print("size "..Bullet.Caliber / 64)
			effectdata:SetStart( -( Bullet.tr.Normal or Bullet.FlightDirection ) ) -- direction 2
			--print("dir2 "..tostring(-( Bullet.tr.Normal or Bullet.FlightDirection )))
			effectdata:SetSurfaceProp( Bullet.Surf or 0 ) -- hit material
			--print("hitmat "..Bullet.Surf or 0)
			effectdata:SetAttachment( Mode )
			--print("mode "..Mode)
			effectdata:SetFlags( flags )
			--print("flags "..flags)
			util.Effect( "hab_physbullet_effects", effectdata )
		end
	end

	--if LocalPlayer():SteamID() == "STEAM_0:0:18725400" then
		--print("effects created on ent "..Bullet.tr.Entity:GetClass()..", hitbox: "..Bullet.tr.HitGroup)
	--end

	if Ent == LocalPlayer() then
		--if LocalPlayer():SteamID() == "STEAM_0:0:18725400" then
			--print("ent == localplayer")
		--end
		Bullet.Dir = Bullet.FlightDirection
		Bullet.Src = Ent:EyePos()
		hook.Run("PhysBulletHit", Ent, Bullet, Mode)
	end

end

net.Receive("CreateEffectsFromHitreg", function()
	local Ent = net.ReadEntity()
	local Bullet = net.ReadTable()
	local Mode = tonumber(net.ReadString()) -- похуй
	local e = Bullet.tr.Entity
	if e == Ent then return end

	local effectdata = EffectData( )
		effectdata:SetDamageType( Bullet.BulletType )
		effectdata:SetEntity( e ) -- hit ent
		effectdata:SetHitBox( Bullet.tr.HitGroup or -1 ) -- hitgroup
		effectdata:SetMagnitude( Bullet.Caliber ) -- caliber
		effectdata:SetNormal( Bullet.tr.HitNormal or Bullet.FlightDirection ) -- direction 1
		effectdata:SetOrigin( Bullet.Position ) -- position
		effectdata:SetScale( Bullet.Caliber / 64 ) -- size --EffectSize
		effectdata:SetStart( -( Bullet.tr.Normal or Bullet.FlightDirection ) ) -- direction 2
		effectdata:SetSurfaceProp( Bullet.Surf or 0 ) -- hit material
		effectdata:SetAttachment( Mode )
		effectdata:SetFlags( flags )
	util.Effect( "hab_physbullet_effects", effectdata )
end)

function MODULE:BulletApplyDamage( Ent, Index, Bullet, Mode ) -- apply damage

	if CLIENT or !Ent or !Index or !Bullet then return end

	/*
	if IsValid(Ent) then
		if !Ent:IsNPC() then
			if Ent:IsPlayer() and !Ent:IsBot() then
				return
			end
		end
	end
    */
	local force = Bullet.Force * Bullet.VelocityFraction

	local dmg = DamageInfo( ) -- damage structure
	dmg:SetDamageCustom( Mode )
	dmg:SetAttacker( IsValid( Bullet.Attacker ) and Bullet.Attacker or IsValid( Bullet.WeaponFiring ) and Bullet.WeaponFiring or Ent )
	dmg:SetDamageForce( Bullet.FlightDirection * force )
	dmg:SetDamagePosition( Bullet.Position )
	dmg:SetInflictor( IsValid( Bullet.WeaponFiring ) and Bullet.WeaponFiring or IsValid( Bullet.Attacker ) and Bullet.Attacker or Ent )
	dmg:SetReportedPosition( Bullet.Position )

	local override = hook.Call( "PhysBulletOnBulletDealtDamage", MODULE, Ent, Index, Bullet, Bullet.tr.Entity, dmg, Mode, force )
	if override then return end

	if Bullet.BlastDamage and ( Mode == HAB_BULLET_IMPACT or Mode == HAB_BULLET_AIRBURST ) then -- deal explosive damge if the round terminates

		dmg:SetDamage( Bullet.BlastDamage )
		dmg:SetDamageType( Bullet.BlastDamageType )

		util.BlastDamageInfo( dmg, Bullet.Position, Bullet.BlastDamageRadius )

	elseif Bullet.tr.Entity != game.GetWorld( ) then -- deal physicaly based damage

		if IsValid( Bullet.tr.Entity ) then

			local e = Bullet.tr.Entity
			local phy = e:GetPhysicsObject( )

			if ( e:IsPlayer( ) or e:IsNPC( ) ) then -- paint blood

				util.Decal( "blood", Bullet.tr.HitPos + Bullet.tr.HitNormal * 4, Bullet.tr.HitPos - Bullet.tr.HitNormal * 4 )

			end

			dmg:SetDamage( Bullet.Damage * ( 0.5 + Bullet.VelocityFraction / 2 ) )
			dmg:SetDamageType( Bullet.DamageType )
			e:DispatchTraceAttack( dmg, Bullet.tr, Bullet.tr.HitNormal )

			if phy:IsValid( ) then -- apply physics force 

				phy:ApplyForceOffset( Bullet.FlightDirection * force, Bullet.tr.HitPos )

			end

		end

	end

	util.ScreenShake( Bullet.Position, force / 256, Bullet.Caliber, 1, Bullet.Radius / 3 )

end

function MODULE:PhysBulletWaterPass( Ent, Index, Bullet ) -- water effects

	if !Ent or !Index or !Bullet then return end

	Bullet.TailPosition = Bullet.LastPosition
	Bullet.LastPosition = Bullet.Position
	Bullet.Position = Bullet.tr.HitPos
	Bullet.PositionInterpolated = Bullet.tr.HitPos

	if CLIENT then

		MODULE:CreateEffects( Ent, Index, Bullet, HAB_BULLET_HITWATER )

	end

	Bullet.TraceTable.mask = MASK_SHOT

	Bullet.HitWater = true -- we hit water

--	hab.Dmsg( tostring( Ent ) .. ", Waterpass: " .. Index )

end

function MODULE:PhysBulletImpact( Ent, Index, Bullet ) -- impact efects

	if !Ent or !Index or !Bullet then return end

	Bullet.TailPosition = Bullet.LastPosition
	Bullet.LastPosition = Bullet.Position
	Bullet.Position = Bullet.tr.HitPos
	Bullet.PositionInterpolated = Bullet.tr.HitPos

	local override = hook.Call( "PhysBulletOnBulletImpact", MODULE, Ent, Index, Bullet, Bullet.tr )
	if override then return end

	Bullet.Impacted = true

	if CLIENT then

		MODULE:CreateEffects( Ent, Index, Bullet, HAB_BULLET_IMPACT )

	elseif SERVER then

		MODULE:BulletApplyDamage( Ent, Index, Bullet, HAB_BULLET_IMPACT )

	end

--	hab.Dmsg( tostring( Ent ) .. " Impacted: " .. Index .. " Hit: " .. tostring( Bullet.tr.Entity ) )

	Ent:PhysBulletRemove( Index )

end

function MODULE:PhysBulletPenetrate( Ent, Index, Bullet ) -- penetration effects

	if !Ent or !Index or !Bullet then return end

	Bullet.TailPosition = Bullet.LastPosition
	Bullet.LastPosition = Bullet.Position
	Bullet.Position = Bullet.pr.HitPos
	Bullet.PositionInterpolated = Bullet.pr.HitPos

	local override = hook.Call( "PhysBulletOnBulletPenetrate", MODULE, Ent, Index, Bullet, Bullet.tr, Bullet.pr )
	if override then return end

	if CLIENT then

		MODULE:CreateEffects( Ent, Index, Bullet, HAB_BULLET_PENETRATE )

	elseif SERVER then

		MODULE:BulletApplyDamage( Ent, Index, Bullet, HAB_BULLET_PENETRATE )

	end

--	hab.Dmsg( tostring( Ent ) .. " Penetrated: " .. Index )

end

function MODULE:PhysBulletRicochet( Ent, Index, Bullet ) -- ricochet effects

	if !Ent or !Index or !Bullet then return end

	local spread = hab.SharedRandomVector( "PhysBulletRicochet", -Bullet.ClampSpread, Bullet.ClampSpread, ( Bullet.RandomSeed + Bullet.TickCount + Bullet.Ricochet ) )
	spread.x = 0
	spread.z = 0

	local deflect = 2 * Bullet.tr.HitNormal * Bullet.Dot
	local dir = Bullet.tr.Normal + deflect + spread

	local fVec = Bullet.FlightVectorLength * ( 1 - Bullet.Dot ) * 0.85
	local newDir = fVec * dir

	local override = hook.Call( "PhysBulletOnBulletRiccochet", MODULE, Ent, Index, Bullet, Bullet.tr, newDir )
	if override then

		return

	end

	Bullet.Ricochet = Bullet.Ricochet + 1

	Bullet.TailPosition = Bullet.LastPosition
	Bullet.LastPosition = Bullet.Position
	Bullet.Position = Bullet.tr.HitPos

	Bullet.PositionInterpolated = Bullet.tr.HitPos

	Bullet.FlightVector = newDir

	if Bullet.Ricochet > 8 then -- we ricochet too many times, impact

		MODULE:PhysBulletImpact( Ent, Index, Bullet )

		return

	end

	if CLIENT then

		MODULE:CreateEffects( Ent, Index, Bullet, HAB_BULLET_RICOCHET )

	elseif SERVER then

		MODULE:BulletApplyDamage( Ent, Index, Bullet, HAB_BULLET_RICOCHET )

	end

--	hab.Dmsg( tostring( Ent ) .. " Ricochet: " .. Index )

end

function MODULE:PhysBulletAirBurst( Ent, Index, Bullet ) -- airburst effects

	if !Ent or !Index or !Bullet then return end

	local override = hook.Call( "PhysBulletOnBulletAirBurst", MODULE, Ent, Index, Bullet )
	if override then return end

	Bullet.TailPosition = Bullet.LastPosition
	Bullet.LastPosition = Bullet.Position

	Bullet.PositionInterpolated = Bullet.Position

	if CLIENT then

		MODULE:CreateEffects( Ent, Index, Bullet, HAB_BULLET_AIRBURST )

	elseif SERVER then

		MODULE:BulletApplyDamage( Ent, Index, Bullet, HAB_BULLET_AIRBURST )

	end

--	hab.Dmsg( tostring( Ent ) .. " Airburst: " .. Index )

	Ent:PhysBulletRemove( Index )

end

hook.Add("EntityFireBullets", "hab_remove_default_bullets", function(ent, data)
	if CLIENT then return end

	if ent:IsNPC() or ent:IsPlayer() then
		ent:FirePhysicalBullets(data)

		return false
	end
end)

local distantsoundtable = {}

hook.Add( "PhysBulletOnCreated", "hab_cw20_distant_sounds", function( Ent, Index, Bullet, fromServer )

	if SERVER then return end

	if Bullet.Dist > 2260 then
		local wep = Ent:GetActiveWeapon()
		local weptable = wep:GetTable()

		if IsValid(wep) then

			if weptable.dt then
				local wepclass = wep:GetClass()

				if !distantsoundtable[wepclass] then

				if !weptable.FireSound then
					return
				end
				if !sound.GetProperties(CustomizableWeaponry:findFireSound(weptable.FireSound)) then
					return
				end
				local str = sound.GetProperties(CustomizableWeaponry:findFireSound(weptable.FireSound)).sound
				local name = string.Split(str, "/")[2]
				--local distant = "weapons/"..name.."/"..name.."_dist.wav"
				local files, dirs = file.Find("sound/weapons/"..name.."/*_dist.wav", "GAME")
				local distant = "weapons/smg1/npc_smg1_fire1.wav"
				if files then
					if files[1] then
						distant = "weapons/"..name.."/"..files[1]
					end
				end

				--print(distant)

				--if !sound.GetProperties(distant) then
					local fireSoundTable = {}

					fireSoundTable.name = name.."_distant_fire_sound"
					fireSoundTable.sound = "^"..distant

					fireSoundTable.channel = 1
					fireSoundTable.volume = 0.3
					fireSoundTable.level = 140
					fireSoundTable.pitchstart = 95
					fireSoundTable.pitchend = 105

					sound.Add(fireSoundTable)
				--end

					distantsoundtable[wepclass] = name.."_distant_fire_sound"

				end

				if distantsoundtable[wepclass] then
					Ent:EmitSound(distantsoundtable[wepclass]) --Weapon_SMG1.NPC_Single
					--sound.Play(name.."_distant_fire_sound", Ent:GetPos(), 180)
				else
					Ent:EmitSound("Weapon_SMG1.NPC_Single") --Weapon_SMG1.NPC_Single
				end

			end
		end

	end

end )

if CLIENT then

local sprite = CreateMaterial( "HAB_PHYSBULLET_SPRITE", "Sprite", {

	["$basetexture"] = "sprites/Glow03",
	["$spriterendermode"] = "9",

})

local beam = CreateMaterial( "HAB_PHYSBULLET_BEAM", "Sprite", {

	["$basetexture"] = "trails/hvap_tracer",
	["$spriterendermode"] = "9",

})

local glow = CreateMaterial( "HAB_PHYSBULLET_GLOW", "Sprite", {

	["$basetexture"] = "sprites/Glow06",
	["$spriterendermode"] = "9",

})

net.Receive( "HAB_PhysBullet_NW_CreateBullet", function( len ) -- create bullet clientside

	local e = net.ReadEntity( ) -- read entity
	if !IsValid( e ) or e == Entity( 0 ) then return end

	local bulletInfo = {}

	bulletInfo.Num = net.ReadUInt( 6 ) -- read Num

	bulletInfo.AmmoType = net.ReadString( ) -- read AmmoType

	bulletInfo.Velocity = net.ReadUInt( 16 ) -- read Velocity
	bulletInfo.Src = net.ReadFloatVector( ) -- read Position
	bulletInfo.Dir = net.ReadFloatVector( ) -- read Dir
	local spread_x = net.ReadFloat( ) -- read Spread.x
	local spread_y = net.ReadFloat( ) -- read Spread.y
	bulletInfo.Spread = Vector( spread_x, spread_y, 0 )
--	bulletInfo.Spread = net.ReadFloatVector( ) -- read Spread

--	bulletInfo.HullSize = net.ReadFloat( ) -- read HullSize
	bulletInfo.Penetration = net.ReadUInt( 14 ) / 10 -- read Penetration

	bulletInfo.BulletType = net.ReadUInt( 2 ) -- read BulletType
	bulletInfo.BalisticsType = net.ReadUInt( 3 ) -- read BalisticsType

	bulletInfo.Fused = net.ReadBool( ) -- read Fused
	bulletInfo.Proximity = net.ReadBool( ) -- read Proximity
	if bulletInfo.Proximity then -- if bullet is prox read prox info

		bulletInfo.Radius = net.ReadFloat( ) -- read Radius

	end

	bulletInfo.Caliber = net.ReadFloat( ) -- read Caliber
	bulletInfo.Mass = net.ReadFloat( ) -- read Mass

	bulletInfo.integral = net.ReadUInt( 28 ) -- read FiredTime
	bulletInfo.fractional = math.Round( net.ReadFloat( ), 6 ) -- read FiredTime
	bulletInfo.TimeToLive = net.ReadFloat( ) -- read TimeToLive

	bulletInfo.Tracer = net.ReadBool( ) -- read Tracer

	if bulletInfo.Tracer then -- if the bullet is tracer read tracer info

		bulletInfo.Color = net.ReadColor( ) -- read Color

	end

	local filter_tab = net.ReadBool( ) -- read Filter Type
	if filter_tab then

		bulletInfo.Filter = {}
		local _count = net.ReadUInt( 8 ) -- read filter length
		for _i = 1, _count do

			bulletInfo.Filter[_i] = net.ReadEntity( )

		end

	end

	bulletInfo.IgnoreEntity = net.ReadEntity( )

	bulletInfo.SentFromServer = true

	if e:IsNPC() then
		e:FirePhysicalBullets( bulletInfo )
		return
	end

	if e:IsPlayer() and !e:IsNPC() then
		if e != LocalPlayer() then
			e:FirePhysicalBullets( bulletInfo )
		end
	end

--	hab.Dmsg( tostring( e ) .. " Fired: " .. Index )

end )

hab.hook( "PreDrawEffects", "HAB_PhysBullet_PreDrawEffects", function( ) -- sprites

	render.OverrideDepthEnable( true, false ) -- override depth buffer

	local enable_dlight = false --!tobool( hab.cval.PhysBullet.Disable_TracerLights )
	local enable_smoothing = false --!tobool( hab.cval.PhysBullet.Disable_TracerSmoothing )
	local enable_scaling = false --!tobool( hab.cval.PhysBullet.Disable_AdvancedTracerScaling )
	local enable_atcalc = false --!tobool( hab.cval.PhysBullet.Disable_AdvancedTracerCalc )
	local enable_glow = false --!tobool( hab.cval.PhysBullet.Disable_TracerGlow )

	local pos = LocalPlayer( ):GetPos( )
	local pve = LocalPlayer( ):GetViewEntity( )
	local eye = EyePos( )
	local eaf = EyeAngles( ):Forward( )

	for _, e in pairs( MODULE.EntityCache ) do
		if isnumber(e) then
			table.remove(MODULE.EntityCache, _)
			continue
		end

		if !e.PhysBulletCache then continue end

			for k, v in pairs( e.PhysBulletCache ) do

				local v = v

				if v.ShouldRemove then continue end

				local cansee = false

				if !v.Interps then
					v.Interps = 0
				end

				if enable_smoothing then
					v.Interps = v.Interps + 1
					if v.Interps > 2 then
						v.Interp = true
					end
					local pfr = math.Clamp( ( CurTime( ) - v.LastUpdated ) / TICKRATE, 0, 1 )
					v.PositionInterpolated = LerpVector( pfr, v.PositionInterpolated, v.Position )

				else
					v.Interps = v.Interps + 1
					if v.Interps > 2 then
						v.Interp = true
					end
					v.PositionInterpolated = v.Position

				end

				v.Dist = pos:Distance( v.PositionInterpolated )

				if e != pve and v.Dist > 64 and v.Dist < 4096 then
					local dist = utilDistanceToLine( v.TraceTable.start, v.TraceTable.endpos, eye )
					if dist < v.Caliber * 24 then

						if pos:DistToSqr( e:GetPos( ) ) > 102400 then

							hook.Call( "PhysBulletOnBulletNearmiss", MODULE, e, k, v, dist )

						end

					end

				end

				local size = ( math.Clamp( v.InvCaliber, 3, 6.4 ) + ( v.VelocityFraction * v.InvCaliber ) ) / 4

				if enable_scaling then

					size = size * math.Min( ( math.sqrt( v.Dist ) / 6.4 ), 64 )

				else

					size = size * 8

				end

				cansee = LocalPlayer():IsLineOfSightClear(v.Position)

				if !v.ShouldTracer and v.Interp then

					if cansee then
						render.SetMaterial( sprite ) -- ball
						render.DrawSprite( v.PositionInterpolated, size, size, HAB_COLOR_YELLOW )
					end

					if v.Tracer then -- tracer delays

						v.ShouldTracer = v.TracerDelay <= CurTime( ) -- update should tracer

					end

					continue

				elseif !v.Tracer and v.Interp and cansee then

					render.SetMaterial( sprite ) -- ball
					render.DrawSprite( v.PositionInterpolated, size, size, HAB_COLOR_YELLOW )

					continue

				end
--[[
				if enable_dlight then

					local light = DynamicLight( k )
					if light then

						local lsc = math.Clamp( v.Dist / 10240, 1, 6 ) * math.Clamp( v.InvCaliber, 3, 6 )
						light.Pos = v.PositionInterpolated
						light.r = v.Color.r
						light.g = v.Color.g
						light.b = v.Color.b
						light.minlight = 0
						light.Brightness = lsc / 2
						light.Size = lsc * 48
						light.Decay = 5000
						light.DieTime = CurTime( ) + 0.5

					end

				end
]]
				local offset = v.FlightDirection * size
				local col = v.Color

				if col == Color(255, 255, 255, 248) or col == Color(255, 255, 255, 255) then
					col = HAB_BULLET_COLOR
				end
				if enable_glow and v.Interp and cansee then

					render.SetMaterial( glow )

					col.a = 18
					render.DrawBeam( -- trail glow
						v.PositionInterpolated + offset * 16,
						v.TailPosition + offset * -32,
						size * 10, --width
						0, --tstart
						1, --tend
						col
					)

					col.a = 28
					render.DrawSprite( v.Position, size * 16, size * 16, col ) -- core glow

				end

				col.a = 248
				if enable_atcalc and v.TailPosition != v.LastPosition and v.Interp then

					local edot = math.pow( math.abs( v.FlightDirection:Dot( eaf ) ), 2 ) + 1
					size = size * edot --math.Clamp( edot, 0.5, 1 )

					if cansee then
					render.SetMaterial( beam ) -- trail
					render.StartBeam( 3 )

						render.AddBeam( v.Position, size * 0.95, 0.05, col )
						render.AddBeam( v.LastPosition, size * 0.64, 0.666, col )
						render.AddBeam( v.TailPosition, size* 0.32, 1.001, col )

					render.EndBeam( )
					end

				else

					if v.Interp and cansee then
					render.SetMaterial( beam ) -- trail
					render.DrawBeam( v.PositionInterpolated, v.TailPosition, size, 0.25, 1, col )
					end
				end

			end

	end

	render.OverrideDepthEnable( false, true ) -- revert depth buffer

end )

end
