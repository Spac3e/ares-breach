hab.Module.PhysBullet = hab.Module.PhysBullet or {}
local MODULE = hab.Module.PhysBullet

MODULE.info = {

	name = "Physical Bullets", --module name
	iname = "PhysBullet", --internal name

	version = "0.3a",
	author = "The_HAVOK",
	contact = "STEAM_0:1:40989742",
	contrib = {},

}

-- ENUMERATORS
HAB_BULLET_MODEL_G1 = 1 -- Common standard projectile shape
HAB_BULLET_MODEL_G2 = 2 -- Larger caliber usage, capped flat tip
HAB_BULLET_MODEL_G7 = 3 -- All around common
HAB_BULLET_MODEL_GS = 4 -- Sphere
HAB_BULLET_MODEL_GL = 5 -- blunt nosed

HAB_BULLET_COLOR = Color( 255, 128, 84, 255 )

--bullet impact types
HAB_BULLET_AP = 0 -- diectional damage
HAB_BULLET_APHE = 1 -- directional damage and explode
HAB_BULLET_HE = 2 -- explode
HAB_BULLET_HEAT = 3 -- directional explode

-- effect states
HAB_BULLET_IMPACT = 0
HAB_BULLET_RICOCHET = 1
HAB_BULLET_PENETRATE = 2
HAB_BULLET_AIRBURST = 3
HAB_BULLET_HITWATER = 4

-- bullet effect flags
HAB_BULLET_EF_NONE = 0
HAB_BULLET_EF_NOSOUND = 1
HAB_BULLET_EF_NOPARTICLES = 2
HAB_BULLET_EF_NODECAL = 4
HAB_BULLET_EF_DISABLEEFFECT = HAB_BULLET_EF_NOSOUND + HAB_BULLET_EF_NOPARTICLES + HAB_BULLET_EF_NODECAL

-- effects
EFFECT_DEFAULT = 0
EFFECT_FLESH = 1
EFFECT_DIRT = 2
EFFECT_GRASS = 3
EFFECT_CONCRETE = 4
EFFECT_BRICK = 5
EFFECT_WOOD = 6
EFFECT_PLASTER = 7
EFFECT_METAL = 8
EFFECT_SAND = 9
EFFECT_SNOW = 10
EFFECT_GRAVEL = 11
EFFECT_WATER = 12
EFFECT_GLASS = 13
EFFECT_TILE = 14
EFFECT_CARPET = 15
EFFECT_ROCK = 16
EFFECT_ICE = 17
EFFECT_PLASTIC = 18
EFFECT_RUBBER = 19
EFFECT_HAY = 20
EFFECT_FOLIAGE = 21
EFFECT_CARDBOARD = 22

if SERVER then

util.AddNetworkString( "HAB_PhysBullet_NW_CreateBullet" )

end

local cvar_sv = { -- define cvars

	[ "Enable_Hitscan" ] = {
		value = 1,
		helptext = "Enable/Disable hitscan replacement. (Default: 1)",
	},

	[ "MaxAlive" ] = {
		value = 256,
		helptext = "Maximum number of bullets alive at once per entity. (Default: 256)",
	},

	[ "DefaultSpeed" ] = {
		value = 700,
		helptext = "Default bullet velocity in m/s. (Default: 700)",
	},

	[ "DefaultEffectSize" ] = {
		value = 1,
		helptext = "Default bullet effect size multiplier. (Default: 1)",
	},

	[ "DefaultPenetrationMult" ] = {
		value = 0,
		helptext = "Default bullet penetration multiplier. (Default: 5)",
	},

	[ "DefaultCaliber" ] = {
		value = 8,
		helptext = "Default bullet caliber in mm. (Default: 8)",
	},

	[ "Seed" ] = {
		value = os.time(),
		helptext = "Bullet randomizer seed",
	},

}

for k, v in pairs( cvar_sv ) do -- add cvars

	hab.AddCvar( MODULE.info.iname, k, v.value, CVAL_NUMBER, HAB_FCVAR_SERVER, v.helptext, v.value, false )

end

if CLIENT then

local cvar_cl = { -- define cvars

	[ "Disable_TracerLights" ] = {
		value = 0,
		helptext = "Disable/Enable dynamic light emitted by tracers, Resource intensive. (Default: 0)",
		optiontext = "Disable Dynamic Tracer Light",
	},

	[ "Disable_TracerSmoothing" ] = {
		value = 0,
		helptext = "Disable/Enable tracer position smoothing, Resource intensive. (Default: 0)",
		optiontext = "Disable Tracer Position Smoothing",
	},

	[ "Disable_TracerGlow" ] = {
		value = 0,
		helptext = "Disable/Enable tracer glow effect, Minimal effect. (Default: 0)",
		optiontext = "Disable Tracer Glow Sprites",
	},

	[ "Disable_AdvancedTracerCalc" ] = {
		value = 0,
		helptext = "Disable/Enable advanced tracer calculations, Small effect. (Default: 0)",
		optiontext = "Disable Adv. Tracer Length Math",
	},

	[ "Disable_AdvancedTracerScaling" ] = {
		value = 0,
		helptext = "Disable/Enable tracer distance scaling calculations, Small effect. (Default: 0)",
		optiontext = "Disable Tracer Distance Scaling",
	},

}

for k, v in pairs( cvar_cl ) do -- add cvars

	hab.AddCvarCL( MODULE.info.iname, k, v.value, CVAL_BOOL, HAB_FCVAR_CLIENT_ONLY, v.helptext, v.value, false)

end

hab.Menu.AddMenuPanel( MODULE.info.name, "Client Options", function( Panel )

	for k, v in pairs( cvar_cl ) do

		local opt = Panel:CheckBox( v.optiontext, "hab_PhysBullet_" .. k )
		opt:SetTooltip( v.helptext )

	end

end )

hab.Menu.AddMenuPanel( MODULE.info.name, "Server Options", function( Panel )

	local Enable_Hitscan = Panel:CheckBox( "Enable HitScan Replacement", "hab_PhysBullet_Enable_Hitscan_cl" )
	Enable_Hitscan:SetTooltip( cvar_sv.Enable_Hitscan.helptext )

end )

end

hab.AddConCommand( MODULE.info.iname, "print_cache", function( ) for k, v in pairs( MODULE.Cache ) do MsgN( k, v ) end end, nil, "Prints the current bullet cache to console." )

hab.RegisterModule( MODULE )

hab.LoadFile( MODULE.info.iname, "definitions" )
hab.LoadFile( MODULE.info.iname, "sounds" )
hab.LoadFile( MODULE.info.iname, "ammotypes" )
hab.LoadFile( MODULE.info.iname, "bullet" )

hab.hook( "Initialize", "HAB_Initialize_PhysBullet", function( )

	hook.Call( "PhysBulletOnAddAmmoTypes", MODULE )

end )

-- called shared once per bullet per tick passing ( ent who fired, bulletindex, bulletstruc ) return true to stop default calculation
function MODULE:PhysBulletOnTick( Ent, Index, Bullet ) end

-- called shared once when a bullet is initially craeted passing ( ent who fired, bulletindex, bulletstruc, weather the bullet is from server or not 'CLIENT ONLY' ) -- return bulletscruc to modify or false
function MODULE:PhysBulletOnCreated( Ent, Index, Bullet, fromServer ) end


-- called clientside once per bullet per frame on the client whenever a bullet passes nearby ( ent who fired, bulletindex, bulletstruc, distance to bullet ) -- returns do nothing
function MODULE:PhysBulletOnBulletNearmiss( Ent, Index, Bullet, Dist ) end

-- called clientside whenever particleeffects are created only passing ( ent who fired, bulletindex, HAB_BULLET_ effect states ) -- return HAB_BULLET_EF_ flag
function MODULE:PhysBulletOnBulletCreateEffects( Ent, Index, Bullet, Mode ) end

-- called serverside on bullet damage infliction passing ( ent who fired, bulletindex, bulletstruc, hit entity, cTakeDamageInfo, HAB_BULLET_ effect states )
function MODULE:PhysBulletOnBulletDealtDamage( Ent, Index, Bullet, hitEnt, cTakeDamageInfo, Mode, force ) end

-- called shared whenever a bullet hits something passing( ent who fired, bulletindex, traceresult ) return true to bypass default trace hit actions
function MODULE:PhysBulletOnBulletTraceHit( Ent, Index, Bullet, tr ) end

function MODULE:PhysBulletOnBulletImpact( Ent, Index, Bullet, tr ) end
function MODULE:PhysBulletOnBulletPenetrate( Ent, Index, Bullet, tr, pr ) end
function MODULE:PhysBulletOnBulletRiccochet( Ent, Index, Bullet, tr, newDir ) end
function MODULE:PhysBulletOnBulletAirBurst( Ent, Index, Bullet ) end

--called shared when ammotypes should be added
function MODULE:PhysBulletOnAddAmmoTypes( ) end


for k, v in ipairs( MODULE.MaterialEffects ) do

	PrecacheParticleSystem( v.pcf )

end

local ENT = FindMetaTable( "Entity" ) 

hab.hook( "EntityRemoved", "HAB_PhysBullet_EntityRemoved", function( ent ) -- clear the bullet cache on entity removal

	if ent.PhysBulletCache then

		local ein = ent:EntIndex( )
		table.remove( MODULE.EntityCache, ein )
		MODULE.EntityCache[ein] = nil

		table.Empty( ent.PhysBulletCache ) -- clear the cache

	end

end )

hab.hook( "PreCleanupMap", "HAB_PhysBullet_PreCleanupMap", function( ) -- clear the bullet cache from entities on map cleanup

	for k, v in pairs( MODULE.EntityCache ) do
		if isnumber(v) then
			table.remove(MODULE.EntityCache, k)
			continue
		end

		if v.PhysBulletCache then

			table.Empty( v.PhysBulletCache ) -- clear the cache

			v.PhysBulletIndex = 1 -- reset index

		end

	end

	table.Empty( MODULE.EntityCache )

end )

local badAT = {

	["generic_hitscan"] = true,

}
hab.hook( "EntityFireBullets", "HAB_PhysBullet_EntityFireBullets", function( ent, data ) -- override default bullet firing

	if !data.TraceBack and ( hab.cval.PhysBullet.Enable_Hitscan > 0 and !data.DisableOverride and !badAT[data.AmmoType] ) then

		ent:FirePhysicalBullets( data )

		return false

	else

		return true

	end

end )


hab.hook( "PhysBulletOnCreated", "HAB_Crack_PhysBulletOnCreated", function( Ent, Index, Bullet, fromServer )

	if SERVER then return end

	local viewer = LocalPlayer( ):GetViewEntity( )
	if viewer != self and Bullet.Dist > 2560 then

		--sound.Play( "HAB.Sounds.PhysBullet.FarCrack", Bullet.Position, 90 )

	end

end )

hab.hook( "PhysBulletOnBulletCreateEffects", "HAB_GaussEnergy_PhysBulletOnBulletCreateEffects", function( Ent, Index, Bullet, Mode )

	return ( Bullet.AmmoType == "GaussEnergy" and HAB_BULLET_EF_DISABLEEFFECT or HAB_BULLET_EF_NONE )

end )

hab.hook( "PhysBulletOnBulletNearmiss", "HAB_Whiz_PhysBulletOnBulletNearmiss", function( Ent, Index, Bullet, Dist )

	if !Bullet.Whized then

		local viewer = LocalPlayer( ):GetViewEntity( )
		if viewer:GetPos( ):DistToSqr( Ent:GetPos( ) ) > 160000 then

			sound.Play( "HAB.Sounds.PhysBullet.NearCrack", Bullet.PositionInterpolated, 90 )

			Bullet.Whized = true

		end

	end

end )

local nopenents = {

	["npc_combinedropship"] = true,
	["npc_combinegunship"] = true,
	["npc_hunter"] = true,
	["npc_helicopter"] = true,
	["npc_rollermine"] = true,
	["npc_strider"] = true,
	["npc_antlion"] = true,
	["npc_antlionguard"] = true,
	["npc_antlionguardian"] = true,
	["npc_zombine"] = true,
	["npc_dog"] = true,

}
hab.hook( "PhysBulletOnBulletPenetrate", "HAB_NPC_PhysBulletOnBulletPenetrate", function( Ent, Index, Bullet, tr, pr )

	local hitEnt = tr.Entity
	if !IsValid( hitEnt ) or !hitEnt:IsNPC( ) then return false end

	local class = hitEnt:GetClass( )
	if nopenents[class] then

		MODULE:PhysBulletImpact( Ent, Index, Bullet )

		return true

	end

end )

local heliignorebox = {
	[1] = true,
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[7] = true,
}
hab.hook( "PhysBulletOnBulletImpact", "HAB_NPC_PhysBulletOnBulletImpact", function( Ent, Index, Bullet, tr )

	local hitEnt = tr.Entity
	if !IsValid( hitEnt ) or !hitEnt:IsNPC( ) then return false end

	local class = hitEnt:GetClass( )
	if class == "npc_helicopter" then

		if heliignorebox[tr.HitBox] then

			table.insert( Bullet.TraceTable.filter, hitEnt )

			return true

		end

	end

end )

hab.hook( "PhysBulletOnBulletRiccochet", "HAB_GaussEnergy_PhysBulletOnBulletRiccochet", function( Ent, Index, Bullet, tr, newDir )

	if Bullet.AmmoType == "GaussEnergy" then

		MODULE:PhysBulletImpact( Ent, Index, Bullet )

		return true

	end

	local hitEnt = tr.Entity
	if !IsValid( hitEnt ) or !hitEnt:IsNPC( ) then return false end

	local class = hitEnt:GetClass( )
	if class == "npc_helicopter" then

		if heliignorebox[tr.HitBox] then

			table.insert( Bullet.TraceTable.filter, hitEnt )

			return true

		end

	end

end )

local gunshiphitboxes = {
	[0] = 0.5,
	[2] = 1,
	[9] = 1,
	[12] = 0.5,
}
hab.hook( "PhysBulletOnBulletDealtDamage", "HAB_NPC_PhysBulletOnBulletDealtDamage", function( Ent, Index, Bullet, hitEnt, dmg, Mode, force )

	if !IsValid( hitEnt ) or !hitEnt:IsNPC( ) then return false end

	hitEnt:AddEntityRelationship( dmg:GetAttacker( ), D_HT, 99 )

	local class = hitEnt:GetClass( )
	if class == "npc_strider" then

		if Mode != HAB_BULLET_IMPACT then return true end

		if math.floor( Bullet.PenetrationLeft ) > 12 then

			util.Decal( "YellowBlood", Bullet.tr.HitPos + Bullet.tr.HitNormal * 4, Bullet.tr.HitPos - Bullet.tr.HitNormal * 4 )

			dmg:SetDamageType( DMG_GENERIC )

			if Bullet.tr.HitGroup == 1 then

				dmg:SetDamage( math.max( Bullet.Damage * Bullet.VelocityFraction * 0.2, 1 ) )
				hitEnt:TakeDamageInfo( dmg )

			elseif Bullet.tr.HitGroup == 2 then

				dmg:SetDamage( math.max( Bullet.Damage * Bullet.VelocityFraction * 0.32, 1 ) )
				hitEnt:TakeDamageInfo( dmg )

			end

		end

		return true

	elseif class == "npc_combinegunship" then

		if Mode != HAB_BULLET_IMPACT then return true end

		local sHBox = gunshiphitboxes[Bullet.tr.HitBox]
		if math.floor( Bullet.PenetrationLeft ) > 12 and sHBox then

			util.Decal( "YellowBlood", Bullet.tr.HitPos + Bullet.tr.HitNormal * 4, Bullet.tr.HitPos - Bullet.tr.HitNormal * 4 )

			dmg:SetDamageType( DMG_GENERIC )
			dmg:SetDamage( math.max( Bullet.Damage * Bullet.VelocityFraction * sHBox, 1 ) )
			hitEnt:TakeDamageInfo( dmg )

		end

		return true

	elseif class == "npc_helicopter" then

		if Mode != HAB_BULLET_IMPACT then return true end

		local sHBox = gunshiphitboxes[Bullet.tr.HitBox]
		if math.floor( Bullet.PenetrationLeft ) > 10 and sHBox then

			dmg:SetDamageType( DMG_AIRBOAT )
			dmg:SetDamage( math.max( Bullet.Damage * Bullet.VelocityFraction * sHBox / 3, 1 ) )
			hitEnt:TakeDamageInfo( dmg )

		end

		return true

	end

	if Bullet.BlastDamage and ( Mode == HAB_BULLET_IMPACT or Mode == HAB_BULLET_AIRBURST ) then -- deal explosive damge if the round terminates

		dmg:SetDamage( Bullet.BlastDamage )
		dmg:SetDamageType( Bullet.BlastDamageType )

		util.BlastDamageInfo( dmg, Bullet.Position, Bullet.BlastDamageRadius )

	else -- deal physicaly based damage

		util.Decal( "blood", Bullet.tr.HitPos + Bullet.tr.HitNormal * 4, Bullet.tr.HitPos - Bullet.tr.HitNormal * 4 )

		dmg:SetDamage( Bullet.Damage * ( 0.5 + Bullet.VelocityFraction / 2 ) )
		dmg:SetDamageType( Bullet.DamageType )
		hitEnt:DispatchTraceAttack( dmg, Bullet.tr, Bullet.tr.HitNormal )

		local phy = hitEnt:GetPhysicsObject( )
		if phy:IsValid( ) then -- apply physics force 

			phy:ApplyForceOffset( Bullet.FlightDirection * force, Bullet.tr.HitPos )

		end

	end

	util.ScreenShake( Bullet.Position, force / 256, Bullet.Caliber, 1, Bullet.Radius / 3 )

	return true 

end )
