--[[


addons/[weapons]_phys_bullet/lua/effects/hab_physbullet_effects.lua

--]]


AddCSLuaFile( )

local MODULE = hab.Module.PhysBullet

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

local typelargepen = {

	[EFFECT_DEFAULT] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_FLESH] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_DIRT] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_GRASS] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_CONCRETE] = "HAB.PhysBullet.Impact.Big",
	[EFFECT_BRICK] = "HAB.PhysBullet.Impact.Big",
	[EFFECT_WOOD] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_PLASTER] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_METAL] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_SAND] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_SNOW] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_GRAVEL] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_WATER] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_GLASS] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_TILE] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_CARPET] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_ROCK] = "HAB.PhysBullet.Impact.Big",
	[EFFECT_ICE] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_PLASTIC] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_RUBBER] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_HAY] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_FOLIAGE] = "HAB.PhysBullet.Impact.Large",
	[EFFECT_CARDBOARD] = "HAB.PhysBullet.Impact.Large",

}

local typedebris = {

	[EFFECT_DEFAULT] = false,
	[EFFECT_FLESH] = false,
	[EFFECT_DIRT] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_GRASS] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_CONCRETE] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_BRICK] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_WOOD] = false,
	[EFFECT_PLASTER] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_METAL] = false,
	[EFFECT_SAND] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_SNOW] = false,
	[EFFECT_GRAVEL] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_WATER] = false,
	[EFFECT_GLASS] = false,
	[EFFECT_TILE] = false,
	[EFFECT_CARPET] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_ROCK] = "HAB.PhysBullet.Impact.Debris",
	[EFFECT_ICE] = false,
	[EFFECT_PLASTIC] = false,
	[EFFECT_RUBBER] = false,
	[EFFECT_HAY] = false,
	[EFFECT_FOLIAGE] = false,
	[EFFECT_CARDBOARD] = false,

}

local typeexplode = {

	[EFFECT_DEFAULT] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_FLESH] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_DIRT] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_GRASS] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_CONCRETE] = "HAB.PhysBullet.Explode.Large.Layer.Concrete",
	[EFFECT_BRICK] = "HAB.PhysBullet.Explode.Large.Layer.Concrete",
	[EFFECT_WOOD] = "HAB.PhysBullet.Explode.Large.Layer.Wood",
	[EFFECT_PLASTER] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_METAL] = "HAB.PhysBullet.Explode.Large.Layer.Metal",
	[EFFECT_SAND] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_SNOW] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_GRAVEL] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_WATER] = "HAB.PhysBullet.Explode.Large.Layer.Water",
	[EFFECT_GLASS] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_TILE] = "HAB.PhysBullet.Explode.Large.Layer.Concrete",
	[EFFECT_CARPET] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_ROCK] = "HAB.PhysBullet.Explode.Large.Layer.Concrete",
	[EFFECT_ICE] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_PLASTIC] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_RUBBER] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_HAY] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	[EFFECT_FOLIAGE] = "HAB.PhysBullet.Explode.Large.Layer.Wood",
	[EFFECT_CARDBOARD] = "HAB.PhysBullet.Explode.Large.Layer.Dirt",

}

local typesounds = {

	[HAB_BULLET_AP] = "AP",

	[HAB_BULLET_APHE] = "APHE",

	[HAB_BULLET_HE] = "HE",

	[HAB_BULLET_HEAT] = "HEAT",

}

local LocalPlayer = LocalPlayer
local math = math
local gravvec = Vector( 0, 0, -300 )
local renderGetSurfaceColor = render.GetSurfaceColor
local sound = sound
--type
HAB_BULLET_AP = 0 -- diectional damage
HAB_BULLET_APHE = 1 -- directional damage and explode
HAB_BULLET_HE = 2 -- explode
HAB_BULLET_HEAT = 3 -- directional explode

--mode
HAB_BULLET_IMPACT = 0
HAB_BULLET_RICOCHET = 1
HAB_BULLET_PENETRATE = 2
HAB_BULLET_AIRBURST = 3
HAB_BULLET_HITWATER = 4

HAB_BULLET_EF_NONE = 0
HAB_BULLET_EF_NOSOUND = 1
HAB_BULLET_EF_NOPARTICLES = 2
HAB_BULLET_EF_DISABLEEFFECT = 3

HAB_PB_LASTCOLOR = HAB_PB_LASTCOLOR or Color( 0, 0, 0, 0 )
local surfColFail = Color( 255, 255, 255, 255 )

function EFFECT:Init( data )

	local Mode = data:GetAttachment( )

	self.BulletType = data:GetDamageType( )
	self.HitEnt = data:GetEntity( ) or game.GetWorld( ) -- hit ent
	self.HitGroup = data:GetHitBox( ) -- hitgroup
	self.Caliber = data:GetMagnitude( )-- caliber
	self.Dir1 = data:GetNormal( ) -- direction 1
	self.Pos = data:GetOrigin( ) -- position
	self.Size = data:GetScale( )-- size
	self.Dir2 = data:GetStart( ) -- direction 2
	self.HitMat = data:GetSurfaceProp( ) -- hit material

	self.Flags = data:GetFlags( )

	self.HitColor = renderGetSurfaceColor( self.Pos + self.Dir1 * 10, self.Pos - self.Dir1 * 10 ):ToColor( )
	if self.HitColor == surfColFail then

		self.HitColor = HAB_PB_LASTCOLOR

	else

		HAB_PB_LASTCOLOR = self.HitColor

	end

	local lightCol = render.GetLightColor( self.Pos ):ToColor( )
	self.HitColor.r = math.min( self.HitColor.r / 2 + lightCol.r / 2, 250 )
	self.HitColor.g = math.min( self.HitColor.g / 2 + lightCol.g / 2, 250 )
	self.HitColor.b = math.min( self.HitColor.b / 2 + lightCol.b / 2, 250 )

--[[
	if self.HitColor.r < 32 or self.HitColor.g < 32 or self.HitColor.b < 32 then

		if self.HitColor.r < 8 and self.HitColor.g < 8 and self.HitColor.b < 8 then

			self.HitColor.r = self.HitColor.r + 128
			self.HitColor.g = self.HitColor.g + 128
			self.HitColor.b = self.HitColor.b + 128

		else

			self.HitColor.r = self.HitColor.r + 32
			self.HitColor.g = self.HitColor.g + 32
			self.HitColor.b = self.HitColor.b + 32

		end

	end
]]

	self.CaliberScaled = math.Clamp( math.pow( self.Caliber, 0.5 ), 1, 8 ) / 2

	local surf = MODULE.SurfaceProperties[self.HitMat]
	if !surf then return end

	self.FxTable = MODULE.MaterialEffects[surf.effect]

	local hiteffect = MODULE.SurfaceProperties[self.HitMat].effect

	local dist = self.Pos:Distance( LocalPlayer( ):GetPos( ) )
	if Mode == HAB_BULLET_HITWATER then -- water and airburst

		self:PlaySound( "HAB.PhysBullet.Impact.Water", self.Pos )

		self.Pos = self.Pos + self.Dir1
		self:CreateEffects( )

		return

	elseif Mode == HAB_BULLET_AIRBURST then

		if self.Caliber > 50 then 

			self:Flak( )

			if dist <= 3200 then

				self:PlaySound( "HAB.PhysBullet.Explode.Flak.Close", self.Pos )

				if dist <= 1600 then

					self:PlaySound( "HAB.PhysBullet.Explode.Flak.Layer.Debris", self.Pos )

				end

			else

				self:PlaySound( "HAB.PhysBullet.Explode.Flak.Far", self.Pos )		

			end

		else

			self:AirBurst( )

			self:PlaySound( "HAB.PhysBullet.Explode.Airburst", self.Pos )

		end

		return

	end

	if IsValid( self.HitEnt ) and !self.HitEnt:IsWorld( ) then -- entity

		if self.HitEnt:IsPlayer( )  then

			if self.HitGroup == HITGROUP_HEAD then

				if self.HitEnt != LocalPlayer( ) then -- headshot

					if self.HitEnt:GetNWFloat("HeadshotMultiplier", 1) < 1 or self.HitEnt:GetNWString("_UsingHelmet", "") != "" then

						self:PlaySound( "HAB.PhysBullet.Helmetshot.Player", self.Pos ) --self:PlaySound( "HAB.PhysBullet.Helmetshot.Player", self.Pos )
						self:HeadshotEffect()

					else

						self:PlaySound( "HAB.PhysBullet.Headshot.Player", self.Pos )
						self:HeadshotEffect()

					end

				else

					if self.HitEnt:GetNWFloat("HeadshotMultiplier", 1) < 1 or self.HitEnt:GetNWString("_UsingHelmet", "") != "" then

						self:PlaySound( "HAB.PhysBullet.Helmetshot.PlayerLocal", self.Pos ) --self:PlaySound( "HAB.PhysBullet.Helmetshot.PlayerLocal", self.Pos )
						self:HeadshotEffect()

					else

						self:PlaySound( "HAB.PhysBullet.Headshot.PlayerLocal", self.Pos )
						self:HeadshotEffect()

					end

				end

			else

				if self.HitEnt != LocalPlayer( ) then -- bodyshot

					self:PlaySound( "HAB.PhysBullet.Impact.Player", self.Pos )

				else

					self:PlaySound( "HAB.PhysBullet.Impact.PlayerLocal", self.Pos )

				end

			end

			self:CreateEffects( )

			return

		end

	end

	if self.BulletType > HAB_BULLET_AP and Mode == HAB_BULLET_IMPACT then -- everything else 

		self:Explode( )

		if self.Caliber >= 70 then 

			if dist > 5500 then

				self:PlaySound( "HAB.PhysBullet.Explode.Large.Far", self.Pos )

			else

				self:PlaySound( "HAB.PhysBullet.Explode.Large", self.Pos )

				self:PlaySound( typeexplode[hiteffect], self.Pos )

			end

--			self:PlaySound( "HAB.PhysBullet.Explode.Large.Bass", self.Pos )
			self:CreateDecal( "Scorch", self.Pos-self.Dir1, self.Pos + self.Dir1 )

		elseif self.Caliber > 35 then

			if dist > 4500 then

				self:PlaySound( "HAB.PhysBullet.Explode.Medium.Far", self.Pos )

			elseif dist > 2000 then

				self:PlaySound( "HAB.PhysBullet.Explode.Medium.Near", self.Pos )

			else

				self:PlaySound( "HAB.PhysBullet.Explode.Medium", self.Pos )

			end

		elseif self.Caliber >= 20 then

			self:PlaySound( "HAB.PhysBullet.Explode.Small", self.Pos )
			self:CreateDecal( "ExplosiveGunshot", self.Pos-self.Dir1, self.Pos + self.Dir1 )

		else

			self:PlaySound( self.FxTable.snd, self.Pos )
			self:CreateDecal( "ExplosiveGunshot", self.Pos-self.Dir1, self.Pos + self.Dir1 )

		end

	elseif Mode == HAB_BULLET_RICOCHET then

		if self.Caliber < 20 then

			self:PlaySound( "HAB.PhysBullet.Small.Ricochet", self.Pos )

		elseif hiteffect == EFFECT_METAL then

			if dist > 2000 then

				self:PlaySound( "HAB.PhysBullet.Far.Ricochet", self.Pos )

			else

				if self.Caliber < 50 then

					self:PlaySound( "HAB.PhysBullet.Small.Ricochet", self.Pos )

				elseif self.Caliber < 75 then

					self:PlaySound( "HAB.PhysBullet.Medium.Ricochet", self.Pos )

				else

					self:PlaySound( "HAB.PhysBullet.Large.Ricochet", self.Pos )

				end

			end

		else

			self:PlaySound( "HAB.PhysBullet.Impact.Large", self.Pos )

		end

		self:CreateDecal( self.FxTable.dec, self.Pos - self.Dir1, self.Pos + self.Dir1 )

		self:CreateEffects( )

	elseif Mode == HAB_BULLET_PENETRATE then

		if self.Caliber < 30 then

			self:PlaySound( self.FxTable.snd, self.Pos )

		else

			self:PlaySound( typelargepen[hiteffect], self.Pos )

		end

		self:CreateDecal( "ExplosiveGunshot", self.Pos - self.Dir1, self.Pos + self.Dir1 )

		self:CreateEffects( )
		self.Dir1 = -self.Dir1
		self.Dir2 = -self.Dir2
		self:CreateEffects( )

	else

		if self.Caliber > 30 then

			self:PlaySound( typelargepen[hiteffect], self.Pos )

		else

			self:PlaySound( self.FxTable.snd, self.Pos )

			if dist <= 2000 and typedebris[hiteffect] then

				self:PlaySound( typedebris[hiteffect], self.Pos )

			end

		end

		self:CreateDecal( self.FxTable.dec, self.Pos - self.Dir1, self.Pos + self.Dir1 )

		self:CreateEffects( )

	end

end

function EFFECT:PlaySound( snd, pos )

	if !bit.band( self.Flags, HAB_BULLET_EF_NOSOUND ) then return end

	sound.Play( snd, pos )

end

function EFFECT:CreateEffects( )

	if !bit.band( self.Flags, HAB_BULLET_EF_NOPARTICLES ) then return end

	self.Emitter = ParticleEmitter( self.Pos )
	self.Emitter:SetNearClip( 32, 64 )

	local effect = MODULE.SurfaceProperties[self.HitMat].effect

	if effect == EFFECT_DEFAULT then

		--self:Default( )
		self:Concrete( )

	elseif effect == EFFECT_FLESH then

		self:Flesh( )

	elseif effect == EFFECT_DIRT then

		self:Dirt( )

	elseif effect == EFFECT_GRASS then

		self:Grass( )

	elseif effect == EFFECT_CONCRETE then

		self:Concrete( )

	elseif effect == EFFECT_BRICK then

		self:Brick( )

	elseif effect == EFFECT_WOOD then

		self:Wood( )

	elseif effect == EFFECT_PLASTER then

		self:Plaster( )

	elseif effect == EFFECT_METAL then

		self:Metal( )

	elseif effect == EFFECT_SAND then

		self:Sand( )

	elseif effect == EFFECT_SNOW then

		self:Snow( )

	elseif effect == EFFECT_GRAVEL then

		self:Gravel( )

	elseif effect == EFFECT_WATER then

		self:Water( )

	elseif effect == EFFECT_GLASS then

		self:Glass( )

	elseif effect == EFFECT_TILE then

		self:Tile( )

	elseif effect == EFFECT_CARPET then

		self:Carpet( )

	elseif effect == EFFECT_ROCK then

		self:Rock( )

	elseif effect == EFFECT_ICE then

		self:Ice( )

	elseif effect == EFFECT_PLASTIC then

		self:Plastic( )

	elseif effect == EFFECT_RUBBER then

		self:Rubber( )

	elseif effect == EFFECT_HAY then

		self:Hay( )

	elseif effect == EFFECT_FOLIAGE then

		self:Foliage( )

	elseif effect == EFFECT_CARDBOARD then

		self:Cardboard( )

	else

		self:Default( )

	end

end

function EFFECT:CreateDecal( name, start, endPos, filter )

	if !bit.band( self.Flags, HAB_BULLET_EF_NODECAL ) then return end

	util.Decal( name, start, endPos, filter )

end

function EFFECT:Default( )

	for i = 0, ( self.CaliberScaled ) do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 150 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 18 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled + 4 ) do -- fleck wood

		local Splinters = self.Emitter:Add( "effects/fleck_wood"..math.random( 1, 2 ), self.Pos )
		if Splinters then

			Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
			Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Splinters:SetStartAlpha( 255 )
			Splinters:SetEndAlpha( 0 )
			Splinters:SetStartSize( math.Rand( 0.5, 1.5 ) * self.CaliberScaled )
			Splinters:SetRoll( math.Rand( 0, 360 ) )
			Splinters:SetRollDelta( math.Rand( -5, 5 ) )
			Splinters:SetAirResistance( 50 )
			Splinters:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Splinters:SetGravity( gravvec )
			Splinters:SetCollide( true )
			Splinters:SetBounce( 0.4 )

		end

	end

	for i = 0, ( self.CaliberScaled + 4 ) do -- fleck tile

		local Splinters = self.Emitter:Add( "effects/fleck_tile"..math.random( 1, 2 ), self.Pos )
		if Splinters then

			Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
			Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Splinters:SetStartAlpha( 255 )
			Splinters:SetEndAlpha( 0 )
			Splinters:SetStartSize( math.Rand( 0.5, 1.5 ) * self.CaliberScaled )
			Splinters:SetRoll( math.Rand( 0, 360 ) )
			Splinters:SetRollDelta( math.Rand( -5, 5 ) )
			Splinters:SetAirResistance( 50 )
			Splinters:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Splinters:SetGravity( gravvec )
			Splinters:SetCollide( true )
			Splinters:SetBounce( 0.4 )

		end

	end

	for i = 0, ( self.CaliberScaled + 4 ) do -- fleck glass

		local Splinters = self.Emitter:Add( "effects/fleck_glass"..math.random( 1, 3 ), self.Pos )
		if Splinters then

			Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
			Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Splinters:SetStartAlpha( 255 )
			Splinters:SetEndAlpha( 0 )
			Splinters:SetStartSize( math.Rand( 0.5, 1.5 ) * self.CaliberScaled )
			Splinters:SetRoll( math.Rand( 0, 360 ) )
			Splinters:SetRollDelta( math.Rand( -5, 5 ) )
			Splinters:SetAirResistance( 50 )
			Splinters:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Splinters:SetGravity( gravvec )
			Splinters:SetCollide( true )
			Splinters:SetBounce( 0.4 )

		end

	end

	for i = 0, ( self.CaliberScaled + 10 ) do -- fleck cement

		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
		if Debris then

			Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
			Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.Rand( 0.32, 1.28 ) * self.CaliberScaled )
			Debris:SetRoll( math.Rand( 0, 360 ) )
			Debris:SetRollDelta( math.Rand( -5, 5 ) )
			Debris:SetAirResistance( 50 )
			Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Debris:SetGravity( gravvec )
			Debris:SetCollide( true )
			Debris:SetBounce( 0.4 )

		end

	end

	for i = 0, ( self.CaliberScaled ) do -- blood spray

		local Blood = self.Emitter:Add( "effects/blood_puff", self.Pos )
		if Blood then

			Blood:SetVelocity( self.Dir2 * math.random( 32, 44 ) * i + self.Dir1 * VectorRand( ):GetNormalized( ) * self.CaliberScaled * math.Rand( 12, 20 ) )
			Blood:SetDieTime( math.Rand( 0.4 , 1 ) * self.CaliberScaled )
			Blood:SetStartAlpha( 128 )
			Blood:SetEndAlpha( 0 )
			Blood:SetStartSize( self.CaliberScaled )
			Blood:SetEndSize( math.Rand( 3 , 6 ) * self.CaliberScaled )
			Blood:SetRoll( math.Rand( 0, 360 ) )
			Blood:SetRollDelta( math.Rand( -1, 1 ) )
			Blood:SetAirResistance( 100 )
			Blood:SetColor( 90, 5, 20 )
			Blood:SetGravity( gravvec / 8 )
			Blood:SetCollide( false )

		end

	end

	for i = 0, self.CaliberScaled + 10 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled + 14 ) do -- sparks

		local Sparks = self.Emitter:Add( "effects/spark", self.Pos )
		if Sparks then

 			Sparks:SetVelocity( ( self.Dir2 + VectorRand( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
 			Sparks:SetDieTime( math.Rand( 0.5, 1.5 ) * self.CaliberScaled / 4 )
 			Sparks:SetStartAlpha( 255 )
 			Sparks:SetStartSize( math.Rand( 1, 2 ) * self.CaliberScaled / 2 ) 
 			Sparks:SetEndSize( 0 )
 			Sparks:SetRoll( math.Rand( 0, 360 ) )
 			Sparks:SetRollDelta( math.Rand( -5, 5 ) )
 			Sparks:SetAirResistance( 20 )
 			Sparks:SetGravity( Vector( 0, 0, -600 ) )
			Sparks:SetCollide( true )
			Sparks:SetBounce( 1 )

		end

	end

	local Flash = self.Emitter:Add( "effects/fire_embers"..math.random( 1, 3 ), self.Pos )
	if Flash then -- flash

		Flash:SetVelocity( self.Dir1 * 100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( 0 )
		Flash:SetEndSize( math.Rand( 1.75, 1.6 ) * self.Caliber )
		Flash:SetRoll( math.Rand( 0, 360 ) )
		Flash:SetRollDelta( math.Rand( -2, 2 ) )
		Flash:SetColor( 255, 255, 255 )

	end

end

function EFFECT:HeadshotEffect()
if self.Attacker == self.HitEnt then return end
	if !bit.band( self.Flags, HAB_BULLET_EF_NOPARTICLES ) then return end

	self.Emitter = ParticleEmitter( self.Pos )
	self.Emitter:SetNearClip( 32, 64 )

	if self.HitEnt:GetNWFloat("HeadshotMultiplier", 1) < 1  or self.HitEnt:GetNWString("_UsingHelmet", "") != "" then

		--self:PlaySound( "HAB.PhysBullet.Helmetshot.Player", self.Pos )
		self:Helmetshot()

	else

		--self.HitEnt:EmitSound("HAB.PhysBullet.Headshot.Player")
		self:Headshot()

	end
end

function EFFECT:Headshot( )
	for i = 0, ( self.CaliberScaled * 4 ) do -- blood spray

		local Blood = self.Emitter:Add( "effects/blood_puff", self.Pos )
		if Blood then

			Blood:SetVelocity( self.Dir2 * math.random( 80, 100 ) + self.Dir1 * VectorRand( ):GetNormalized( ) * self.CaliberScaled * math.Rand( 48, 64 ) )
			Blood:SetDieTime( math.Rand( 0.8 , 1.28 ) * self.CaliberScaled)
			Blood:SetStartAlpha( 255 )
			Blood:SetEndAlpha( 0 )
			Blood:SetStartSize( self.CaliberScaled * 10 )
			Blood:SetEndSize( math.Rand( 3 , 6 ) * self.CaliberScaled * 3)
			Blood:SetRoll( math.Rand( 0, 360 ) )
			Blood:SetRollDelta( math.Rand( -1, 1 ) )
			Blood:SetAirResistance( 1000 )
			Blood:SetColor( 80, 0, 0 )
			Blood:SetGravity( gravvec / 9 )
			Blood:SetCollide( false )

		end

	end
end

function EFFECT:Helmetshot()
	for i = 0, ( self.CaliberScaled * 4 ) do -- blood spray

		local Blood = self.Emitter:Add( "effects/blood_puff", self.Pos )
		if Blood then

			Blood:SetVelocity( self.Dir2 * math.random( 80, 100 ) + self.Dir1 * VectorRand( ):GetNormalized( ) * self.CaliberScaled * math.Rand( 48, 64 ) )
			Blood:SetDieTime( math.Rand( 0.8 , 1.28 ) * self.CaliberScaled)
			Blood:SetStartAlpha( 255 )
			Blood:SetEndAlpha( 0 )
			Blood:SetStartSize( self.CaliberScaled * 2)
			Blood:SetEndSize(0)
			Blood:SetRoll( math.Rand( 0, 360 ) )
			Blood:SetRollDelta( math.Rand( -1, 1 ) )
			Blood:SetAirResistance( 1000 )
			Blood:SetColor( 80, 0, 0 )
			Blood:SetGravity( gravvec / 9 )
			Blood:SetCollide( false )

		end

	end

	for i = 0, ( self.CaliberScaled * 2 + 16 ) do -- sparks
		local Sparks = self.Emitter:Add( "effects/spark", self.Pos )
		if Sparks then

 			Sparks:SetVelocity( ( self.Dir2 + VectorRand( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
 			Sparks:SetDieTime(1 * self.CaliberScaled / 4 )
 			Sparks:SetStartAlpha( 255 )
 			Sparks:SetStartSize( math.Rand( 4, 6 ) * self.CaliberScaled / 2 ) 
 			Sparks:SetEndSize( 0 )
 			Sparks:SetRoll( math.Rand( 0, 360 ) )
 			Sparks:SetRollDelta( math.Rand( -5, 5 ) )
 			Sparks:SetAirResistance( 20 )
 			Sparks:SetGravity( Vector( 0, 0, -600 ) )
			Sparks:SetCollide( true )
			Sparks:SetBounce( 1 )

		end
		local effect = EffectData()
		effect:SetEntity(self.HitEnt)
		effect:SetOrigin(self.Emitter:GetPos())
		util.Effect("MetalSpark", effect, true, true)

	end
end

function EFFECT:Flesh( )
	self:PlaySound("HAB.PhysBullet.Impact.Player", self:GetPos())

	for i = 0, ( self.CaliberScaled * 2 ) do -- blood spray

		local Blood = self.Emitter:Add( "effects/blood_puff", self.Pos )
		if Blood then

			Blood:SetVelocity( self.Dir2 * math.random( 80, 100 ) + self.Dir1 * VectorRand( ):GetNormalized( ) * self.CaliberScaled * math.Rand( 48, 64 ) )
			Blood:SetDieTime( math.Rand( 0.8 , 1.28 ) * self.CaliberScaled )
			Blood:SetStartAlpha( 255 )
			Blood:SetEndAlpha( 0 )
			Blood:SetStartSize( self.CaliberScaled * 5 )
			Blood:SetEndSize( math.Rand( 3 , 6 ) * i * self.CaliberScaled )
			Blood:SetRoll( math.Rand( 0, 360 ) )
			Blood:SetRollDelta( math.Rand( -1, 1 ) )
			Blood:SetAirResistance( 256 )
			Blood:SetColor( 60, 0, 00 )
			Blood:SetGravity( gravvec / 9 )
			Blood:SetCollide( false )

		end

	end

	--[[
	for i = 0, self.CaliberScaled do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.Rand( 1, 2 ) + VectorRand( ) ) * math.Rand( 24, 32 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 12 , 18 ) * self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 200 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 6 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end
	--]]

end

function EFFECT:Dirt( )

	for i = 0, self.CaliberScaled do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 160 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 16 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled * 1.5 + 4 ) do -- fleck cement

		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
		if Debris then

			Debris:SetVelocity( ( self.Dir1 * math.Rand( 1, 2 ) + self.Dir2 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 48 ) * self.CaliberScaled )
			Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.Rand( 0.32, 1.28 ) * self.CaliberScaled )
			Debris:SetRoll( math.Rand( 0, 360 ) )
			Debris:SetRollDelta( math.Rand( -5, 5 ) )
			Debris:SetAirResistance( 50 )
			Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Debris:SetGravity( gravvec )
			Debris:SetCollide( true )
			Debris:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 10 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 2, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 2 , 4 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 12 , 24 ) * self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Grass( )

	for i = 0, self.CaliberScaled do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 160 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 16 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled * 2 + 8 ) do -- fleck wood

		local Splinters = self.Emitter:Add( "effects/fleck_wood"..math.random( 1, 2 ), self.Pos )
		if Splinters then

			Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 48 ) * self.CaliberScaled )
			Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Splinters:SetStartAlpha( 255 )
			Splinters:SetEndAlpha( 0 )
			Splinters:SetStartSize( math.Rand( 2, 4 ) )
			Splinters:SetRoll( math.Rand( 0, 360 ) )
			Splinters:SetRollDelta( math.Rand( -32, 32 ) )
			Splinters:SetAirResistance( 64 )
			Splinters:SetColor( 16, 84, 32 )
			Splinters:SetGravity( gravvec )
			Splinters:SetCollide( true )
			Splinters:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 10 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 2, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 2 , 4 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 12 , 24 ) * self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Concrete( )

	for i = 0, ( self.CaliberScaled ) do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 160 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 18 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled + 10 ) do -- fleck cement

		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
		if Debris then

			Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 48 ) * self.CaliberScaled )
			Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.Rand( 1, 1.4 ) * self.CaliberScaled )
			Debris:SetRoll( math.Rand( 0, 360 ) )
			Debris:SetRollDelta( math.Rand( -20, 20 ) )
			Debris:SetAirResistance( 50 )
			Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Debris:SetGravity( gravvec )
			Debris:SetCollide( true )
			Debris:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 6 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled + 8 ) do -- sparks

		local Sparks = self.Emitter:Add( "effects/spark", self.Pos )
		if Sparks then

 			Sparks:SetVelocity( ( self.Dir2 + VectorRand( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
 			Sparks:SetDieTime( math.Rand( 0.5, 1.5 ) * self.CaliberScaled / 4 )
 			Sparks:SetStartAlpha( 255 )
 			Sparks:SetStartSize( math.Rand( 1, 2 ) * self.CaliberScaled / 2 ) 
 			Sparks:SetEndSize( 0 )
 			Sparks:SetRoll( math.Rand( 0, 360 ) )
 			Sparks:SetRollDelta( math.Rand( -5, 5 ) )
 			Sparks:SetAirResistance( 20 )
 			Sparks:SetGravity( Vector( 0, 0, -600 ) )
			Sparks:SetCollide( true )
			Sparks:SetBounce( 1 )

		end

	end

	local Flash = self.Emitter:Add( "effects/fire_embers"..math.random( 1, 3 ), self.Pos )
	if Flash then -- flash

		Flash:SetVelocity( self.Dir1 * 100 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( 0 )
		Flash:SetEndSize( math.Rand( 1.75, 2 ) * self.Caliber )
		Flash:SetRoll( math.Rand( 0, 360 ) )
		Flash:SetRollDelta( math.Rand( -2, 2 ) )
		Flash:SetColor( 255, 255, 255 )

	end

end

function EFFECT:Brick( )

	for i = 0, ( self.CaliberScaled ) do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 256, 640 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 160 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 18 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled ) do -- fleck cement

		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
		if Debris then

			Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 48 ) * self.CaliberScaled )
			Debris:SetDieTime( math.random( 1.5, 3 ) * self.CaliberScaled / 2 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.Rand( 1.92, 2.56 ) * self.CaliberScaled )
			Debris:SetRoll( math.Rand( 0, 360 ) )
			Debris:SetRollDelta( math.Rand( -20, 20 ) )
			Debris:SetAirResistance( 50 )
			Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Debris:SetGravity( gravvec )
			Debris:SetCollide( true )
			Debris:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 6 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled + 6 ) do -- sparks

		local Sparks = self.Emitter:Add( "effects/spark", self.Pos )
		if Sparks then

 			Sparks:SetVelocity( ( self.Dir2 + VectorRand( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
 			Sparks:SetDieTime( math.Rand( 0.5, 1.5 ) * self.CaliberScaled / 4 )
 			Sparks:SetStartAlpha( 255 )
 			Sparks:SetStartSize( math.Rand( 1, 2 ) * self.CaliberScaled / 2 ) 
 			Sparks:SetEndSize( 0 )
 			Sparks:SetRoll( math.Rand( 0, 360 ) )
 			Sparks:SetRollDelta( math.Rand( -5, 5 ) )
 			Sparks:SetAirResistance( 20 )
 			Sparks:SetGravity( Vector( 0, 0, -600 ) )
			Sparks:SetCollide( true )
			Sparks:SetBounce( 1 )

		end

	end

	local Flash = self.Emitter:Add( "effects/fire_embers"..math.random( 1, 3 ), self.Pos )
	if Flash then -- flash

		Flash:SetVelocity( self.Dir1 * 100 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( 0 )
		Flash:SetEndSize( math.Rand( 1.75, 2 ) * self.Caliber )
		Flash:SetRoll( math.Rand( 0, 360 ) )
		Flash:SetRollDelta( math.Rand( -2, 2 ) )
		Flash:SetColor( 255, 255, 255 )

	end

end

function EFFECT:Wood( )

	for i = 0, ( self.CaliberScaled + 8 ) do -- fleck wood

		local Splinters = self.Emitter:Add( "effects/fleck_wood"..math.random( 1, 2 ), self.Pos )
		if Splinters then

			Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 24, 32 ) * self.CaliberScaled )
			Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Splinters:SetStartAlpha( 255 )
			Splinters:SetEndAlpha( 0 )
			Splinters:SetStartSize( math.Rand( 0.64, 1.6 ) * self.CaliberScaled )
			Splinters:SetRoll( math.Rand( 0, 360 ) )
			Splinters:SetRollDelta( math.Rand( -24, 24 ) )
			Splinters:SetAirResistance( 50 )
			Splinters:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Splinters:SetGravity( gravvec )
			Splinters:SetCollide( true )
			Splinters:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 10 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 48 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 1.8 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Plaster( )

	for i = 0, ( self.CaliberScaled ) do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 150 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 18 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled + 10 ) do -- fleck cement

		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
		if Debris then

			Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 48 ) * self.CaliberScaled )
			Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.Rand( 1, 1.4 ) * self.CaliberScaled )
			Debris:SetRoll( math.Rand( 0, 360 ) )
			Debris:SetRollDelta( math.Rand( -20, 20 ) )
			Debris:SetAirResistance( 50 )
			Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Debris:SetGravity( gravvec )
			Debris:SetCollide( true )
			Debris:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 10 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Metal( )

	for i = 0, self.CaliberScaled do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 32 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.6 , 2.56 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 100, 128 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 4 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled * 2 + 8 ) do -- sparks

		local Sparks = self.Emitter:Add( "effects/spark", self.Pos )
		if Sparks then

 			Sparks:SetVelocity( ( self.Dir2 + VectorRand( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
 			Sparks:SetDieTime( math.Rand( 0.64, 1.92 ) * self.CaliberScaled / 4 )
 			Sparks:SetStartAlpha( 255 )
 			Sparks:SetStartSize( math.Rand( 1, 2 ) * self.CaliberScaled / 2 ) 
 			Sparks:SetEndSize( 0 )
 			Sparks:SetRoll( math.Rand( 0, 360 ) )
 			Sparks:SetRollDelta( math.Rand( -5, 5 ) )
 			Sparks:SetAirResistance( 20 )
 			Sparks:SetGravity( Vector( 0, 0, -600 ) )
			Sparks:SetCollide( true )
			Sparks:SetBounce( 1 )

		end

	end

	for i = 0, ( self.CaliberScaled ) do -- flash

		local Flash = self.Emitter:Add( "effects/fire_embers"..math.random( 1, 3 ), self.Pos + self.Dir2 * i * 2 )
		if Flash then

			Flash:SetVelocity( self.Dir1 * 100 )
			Flash:SetAirResistance( 200 )
			Flash:SetDieTime( 0.2 )
			Flash:SetStartAlpha( 255 )
			Flash:SetEndAlpha( 0 )
			Flash:SetStartSize( 0 )
			Flash:SetEndSize( math.Rand( 1.75, 1.6 ) * self.Caliber )
			Flash:SetRoll( math.Rand( 0, 360 ) )
			Flash:SetRollDelta( math.Rand( -2, 2 ) )
			Flash:SetColor( 255, 255, 255 )

		end

	end

end

function EFFECT:Sand( )

	for i = 0, self.CaliberScaled do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 256, 384 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.6 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 160 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 16 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1.5, 1.5 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 4 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, self.CaliberScaled + 8 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -24, 24 ), math.Rand( -24, 24 ), math.Rand( -24, 0 ) ) * self.CaliberScaled + ( gravvec / 4 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Snow( ) -- tmp

	for i = 0, self.CaliberScaled do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 160 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 16 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled * 1.5 + 4 ) do -- fleck cement

		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
		if Debris then

			Debris:SetVelocity( ( self.Dir1 * math.Rand( 1, 2 ) + self.Dir2 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 48 ) * self.CaliberScaled )
			Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.Rand( 0.32, 1.28 ) * self.CaliberScaled )
			Debris:SetRoll( math.Rand( 0, 360 ) )
			Debris:SetRollDelta( math.Rand( -5, 5 ) )
			Debris:SetAirResistance( 50 )
			Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Debris:SetGravity( gravvec )
			Debris:SetCollide( true )
			Debris:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 10 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 2, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 2 , 4 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 12 , 24 ) * self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Gravel( )

	for i = 0, self.CaliberScaled do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 160 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 16 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled * 2 + 4 ) do -- fleck cement

		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
		if Debris then

			Debris:SetVelocity( ( self.Dir1 * math.Rand( 1, 2 ) + self.Dir2 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 48 ) * self.CaliberScaled )
			Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.Rand( 0.32, 1 ) * self.CaliberScaled )
			Debris:SetRoll( math.Rand( 0, 360 ) )
			Debris:SetRollDelta( math.Rand( -5, 5 ) )
			Debris:SetAirResistance( 50 )
			Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Debris:SetGravity( gravvec )
			Debris:SetCollide( true )
			Debris:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 10 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 2, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 2 , 4 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 12 , 24 ) * self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Water( ) -- nil

end

function EFFECT:Glass( )

	for i = 0, ( self.CaliberScaled + 4 ) do -- fleck glass

		local Splinters = self.Emitter:Add( "effects/fleck_glass"..math.random( 1, 3 ), self.Pos )
		if Splinters then

			Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 16, 32 ) * self.CaliberScaled )
			Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Splinters:SetStartAlpha( 255 )
			Splinters:SetEndAlpha( 0 )
			Splinters:SetStartSize( math.Rand( 0.64, 1.28 ) * self.CaliberScaled )
			Splinters:SetRoll( math.Rand( 0, 360 ) )
			Splinters:SetRollDelta( math.Rand( -8, 8 ) )
			Splinters:SetAirResistance( 50 )
			Splinters:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Splinters:SetGravity( gravvec / 2 )
			Splinters:SetCollide( true )
			Splinters:SetBounce( 0.4 )

		end

	end

end

function EFFECT:Tile( ) -- concrete

	self:Concrete( )

end

function EFFECT:Carpet( )

	for i = 0, self.CaliberScaled do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 150 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 18 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, self.CaliberScaled do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Rock( ) -- concrete

	self:Concrete( )

end

function EFFECT:Ice( ) -- glass

	self:Glass( )

end

function EFFECT:Plastic( )

	for i = 0, self.CaliberScaled + 8 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end

function EFFECT:Rubber( ) -- plastic

	self:Plastic( )

end

function EFFECT:Hay( ) -- wood

	self:Wood( )

end

function EFFECT:Foliage( ) -- wood

	self:Wood( )

end

function EFFECT:Cardboard( )

	for i = 0, self.CaliberScaled do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

end


function EFFECT:Explode( )

	if !bit.band( self.Flags, HAB_BULLET_EF_NOPARTICLES ) then return end

	self.Emitter = ParticleEmitter( self.Pos )
	self.Emitter:SetNearClip( 32, 64 )

	for i = 0, ( self.CaliberScaled ) do -- composite

		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if Smoke then

			Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand( ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 0.64 , 1.2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( 150 )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 12 , 18 ) * self.CaliberScaled )
			Smoke:SetEndSize( self.CaliberScaled )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -2, 2 ) )
			Smoke:SetAirResistance( 400 )
			Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled + 10 ) do -- fleck cement

		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
		if Debris then

			Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand( ):GetNormalized( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
			Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.Rand( 0.32, 1.28 ) * self.CaliberScaled )
			Debris:SetRoll( math.Rand( 0, 360 ) )
			Debris:SetRollDelta( math.Rand( -5, 5 ) )
			Debris:SetAirResistance( 50 )
			Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
			Debris:SetGravity( gravvec )
			Debris:SetCollide( true )
			Debris:SetBounce( 0.4 )

		end

	end

	for i = 0, self.CaliberScaled + 10 do -- dust

		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1,9 ), self.Pos )
		if Smoke then

			Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand( ) ) * math.random( 24, 64 ) * self.CaliberScaled )
			Smoke:SetDieTime( math.Rand( 1.2 , 2 ) * self.CaliberScaled )
			Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( math.Rand( 4 , 8 ) * self.CaliberScaled )
			Smoke:SetEndSize( math.Rand( 16 , 32 ) * self.CaliberScaled + 16 )
			Smoke:SetRoll( math.Rand( 0, 360 ) )
			Smoke:SetRollDelta( math.Rand( -1, 1 ) )			
			Smoke:SetAirResistance( 400 ) 			 
			Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
			Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

		end

	end

	for i = 0, ( self.CaliberScaled + 14 ) do -- sparks

		local Sparks = self.Emitter:Add( "effects/spark", self.Pos )
		if Sparks then

 			Sparks:SetVelocity( ( self.Dir2 + VectorRand( ) ) * math.Rand( 32, 64 ) * self.CaliberScaled )
 			Sparks:SetDieTime( math.Rand( 0.5, 1.5 ) * self.CaliberScaled / 4 )
 			Sparks:SetStartAlpha( 255 )
 			Sparks:SetStartSize( math.Rand( 1, 2 ) * self.CaliberScaled / 2 ) 
 			Sparks:SetEndSize( 0 )
 			Sparks:SetRoll( math.Rand( 0, 360 ) )
 			Sparks:SetRollDelta( math.Rand( -5, 5 ) )
 			Sparks:SetAirResistance( 20 )
 			Sparks:SetGravity( Vector( 0, 0, -600 ) )
			Sparks:SetCollide( true )
			Sparks:SetBounce( 1 )

		end

	end

	local Flash = self.Emitter:Add( "effects/fire_embers"..math.random( 1, 3 ), self.Pos )
	if Flash then -- flash

		Flash:SetVelocity( self.Dir1 * 100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( 0 )
		Flash:SetEndSize( math.Rand( 1.75, 1.6 ) * self.Caliber )
		Flash:SetRoll( math.Rand( 0, 360 ) )
		Flash:SetRollDelta( math.Rand( -2, 2 ) )
		Flash:SetColor( 255, 255, 255 )

	end

end

function EFFECT:AirBurst( )

	if !bit.band( self.Flags, HAB_BULLET_EF_NOPARTICLES ) then return end

	self.Emitter = ParticleEmitter( self.Pos )
	self.Emitter:SetNearClip( 32, 64 )
	
	for i=0, 2*self.Size do -- main smoke
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.Dir1 * math.random( 20,500*self.Size) + VectorRand( ):GetNormalized( )*64*self.Size )
		Smoke:SetDieTime( math.Rand( 1.28 , 2.56 ) )
		Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 15*self.Size )
		Smoke:SetEndSize( 35*self.Size )
		Smoke:SetRoll( math.Rand(150, 360 ) )
		Smoke:SetRollDelta( math.Rand( -2, 2) )			
		Smoke:SetAirResistance( 300 ) 			 
		Smoke:SetGravity( Vector( math.Rand( -70, 70 ) * self.Size, math.Rand( -70, 70 ) * self.Size, math.Rand(0, -100 ) ) ) 			
		Smoke:SetColor( 130,125,115 )
		end
	end
	if self.Fancy then
		for i=0, 2*self.Size do -- remain smoke
			local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
			if (Smoke) then
			Smoke:SetVelocity( self.Dir1 * 64 * self.Size )
			Smoke:SetDieTime( math.Rand( 1.92 , 2.5 ) )
			Smoke:SetStartAlpha( math.Rand( 184, 255 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( 8*self.Size )
			Smoke:SetEndSize( 32*self.Size )
			Smoke:SetRoll( math.Rand(180,480 ) )
			Smoke:SetRollDelta( math.Rand( -1,1) )	
			Smoke:SetAirResistance( 1024 ) 			 
			Smoke:SetGravity( Vector( math.Rand( -70, 70 ) * self.Size, math.Rand( -70, 70 ) * self.Size, math.Rand(0, -100 ) ) ) 			
			Smoke:SetColor( 30,25,15 )
			end
		end	

		for i=0, 3*self.Size do -- particles
			local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
			if (Debris) then
			Debris:SetVelocity ( self.Dir1 * math.random(200,300*self.Size) + VectorRand( ):GetNormalized( ) * 192*self.Size )
			Debris:SetDieTime( math.random( .8, 1.92) )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.random(2,4) )
			Debris:SetRoll( math.Rand(0, 360 ) )
			Debris:SetRollDelta( math.Rand( -5, 5) )			
			Debris:SetAirResistance( 50 ) 			 			
			Debris:SetColor( 105,100,90 )
			Debris:SetGravity( Vector( 0, 0, -600 ) ) 
			Debris:SetCollide( true )
			Debris:SetBounce( 1 )			
			end
		end
	end

	for i=0, 2*self.Size do -- spark
		local particle = self.Emitter:Add( "effects/spark", self.Pos ) 
		if (particle) then 
			particle:SetVelocity( ((self.Dir1*0.75)+VectorRand( )) * math.Rand(48, 480 )*2 ) 
			particle:SetDieTime( math.Rand(1, 2) ) 				 
			particle:SetStartAlpha( 255 )  				 
			particle:SetStartSize( math.Rand(6, 8) ) 
			particle:SetEndSize( 0 ) 				 
			particle:SetRoll( math.Rand(0, 360 ) ) 
			particle:SetRollDelta( math.Rand( -5, 5) ) 				 
			particle:SetAirResistance( 20 ) 
			particle:SetGravity( Vector( 0, 0, -300 ) ) 
		end 		
	end 
	
	for i=0,1 do -- flash
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.Dir1*64 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.2 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( math.Rand( 64, 80 )*self.Size )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480 ) )
		Flash:SetRollDelta( math.Rand( -1,1) )
		Flash:SetColor(255,255,255)	
		end
	end
end

function EFFECT:Flak( )

	if !bit.band( self.Flags, HAB_BULLET_EF_NOPARTICLES ) then return end

	self.Emitter = ParticleEmitter( self.Pos )
	self.Emitter:SetNearClip( 32, 64 )

	for i=0, 3*self.Size do -- main smoke
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.Dir1 * math.random( 20,500*self.Size) + VectorRand( ):GetNormalized( )*64*self.Size )
		Smoke:SetDieTime( math.Rand( 1.28 , 2 ) )
		Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 15*self.Size )
		Smoke:SetEndSize( 35*self.Size )
		Smoke:SetRoll( math.Rand(150, 360 ) )
		Smoke:SetRollDelta( math.Rand( -2, 2) )			
		Smoke:SetAirResistance( 300 ) 			 
		Smoke:SetGravity( Vector( math.Rand( -70, 70 ) * self.Size, math.Rand( -70, 70 ) * self.Size, math.Rand(0, -100 ) ) ) 			
		Smoke:SetColor( 130,125,115 )
		end
	end
	if self.Fancy then
		for i=0, 2*self.Size do -- remain smoke
			local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
			if (Smoke) then
			Smoke:SetVelocity( self.Dir1 * 64 * self.Size )
			Smoke:SetDieTime( math.Rand( 1.92 , 2.5 ) )
			Smoke:SetStartAlpha( math.Rand( 184, 255 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( 8*self.Size )
			Smoke:SetEndSize( 32*self.Size )
			Smoke:SetRoll( math.Rand(180,480 ) )
			Smoke:SetRollDelta( math.Rand( -1,1) )	
			Smoke:SetAirResistance( 1024 ) 			 
			Smoke:SetGravity( Vector( math.Rand( -70, 70 ) * self.Size, math.Rand( -70, 70 ) * self.Size, math.Rand(0, -100 ) ) ) 			
			Smoke:SetColor( 30,25,15 )
			end
		end	

		for i=0, 6*self.Size do -- particles
			local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
			if (Debris) then
			Debris:SetVelocity ( self.Dir1 * math.random(200,300*self.Size) + VectorRand( ):GetNormalized( ) * 192*self.Size )
			Debris:SetDieTime( math.random( .8, 1.92) )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( math.random(2,4) )
			Debris:SetRoll( math.Rand(0, 360 ) )
			Debris:SetRollDelta( math.Rand( -5, 5) )			
			Debris:SetAirResistance( 50 ) 			 			
			Debris:SetColor( 105,100,90 )
			Debris:SetGravity( Vector( 0, 0, -600 ) ) 
			Debris:SetCollide( true )
			Debris:SetBounce( 1 )			
			end
		end

		for i=0, 8*self.Size do -- spark
			local particle = self.Emitter:Add( "effects/spark", self.Pos ) 
			if (particle) then 
				particle:SetVelocity( ((self.Dir1*0.75)+VectorRand( )) * math.Rand(48, 480 )*2 ) 
				particle:SetDieTime( math.Rand(1, 2) ) 				 
				particle:SetStartAlpha( 255 )  				 
				particle:SetStartSize( math.Rand(6, 8) ) 
				particle:SetEndSize( 0 ) 				 
				particle:SetRoll( math.Rand(0, 360 ) ) 
				particle:SetRollDelta( math.Rand( -5, 5) ) 				 
				particle:SetAirResistance( 20 ) 
				particle:SetGravity( Vector( 0, 0, -300 ) ) 
			end 		
		end 
	end
	
	for i=0,2 do -- flash
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.Dir1*64 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.2 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( math.Rand( 64, 80 )*self.Size )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480 ) )
		Flash:SetRollDelta( math.Rand( -1,1) )
		Flash:SetColor(255,255,255)	
		end
	end
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )
end

function EFFECT:OnRemove( )

	if IsValid( self.Emitter ) then

		self.Emitter:Finish( )

	end

end
