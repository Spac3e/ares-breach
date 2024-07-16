
AddCSLuaFile()

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
  [EFFECT_CARDBOARD] = "HAB.PhysBullet.Impact.Large"

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
  [EFFECT_CARDBOARD] = false

}

local LocalPlayer = LocalPlayer
local math = math
local gravvec = Vector( 0, 0, -300 )
local renderGetSurfaceColor = render.GetSurfaceColor
local sound = sound

--type
BREACH_BULLET_AP = 0 -- diectional damage
BREACH_BULLET_APHE = 1 -- directional damage and explode
BREACH_BULLET_HE = 2 -- explode
BREACH_BULLET_HEAT = 3 -- directional explode

--mode
BREACH_BULLET_IMPACT = 0
BREACH_BULLET_RICOCHET = 1
BREACH_BULLET_PENETRATE = 2
BREACH_BULLET_AIRBURST = 3
BREACH_BULLET_HITWATER = 4

BREACH_LASTCOLOR = BREACH_LASTCOLOR || ColorAlpha( color_black, 0 )

local approved_number = {

  [ 30 ] = true,
  [ 3 ] = true,
  [ 39 ] = true

}

local gravvec_2 = 52.459

function EFFECT:Init( data )

  local Mode = data:GetFlags()

  self.BulletType = data:GetDamageType()
  self.HitEnt = data:GetEntity() || game.GetWorld()
  self.HitGroup = data:GetHitBox()
  self.Caliber = data:GetMagnitude() / gravvec_2
  self.Dir1 = data:GetNormal()
  self.Pos = data:GetOrigin()
  self.Size = data:GetScale()
  self.Dir2 = data:GetStart()
  self.HitMat = data:GetSurfaceProp()

  if ( !self.HitEnt:IsPlayer() ) then

    self.HitColor = renderGetSurfaceColor( self.Pos + self.Dir1 * 10, self.Pos - self.Dir1 * 10 ):ToColor()

    if ( self.HitColor == surfColFail ) then

      self.HitColor = BREACH_LASTCOLOR

    else

      BREACH_LASTCOLOR = self.HitColor

    end

  else

    self.HitColor = BREACH_LASTCOLOR

  end

  local lightCol = render.GetLightColor( self.Pos ):ToColor()

  self.HitColor.r = math.min( self.HitColor.r / 2 + lightCol.r / 2, 250 )
  self.HitColor.g = math.min( self.HitColor.g / 2 + lightCol.g / 2, 250 )
  self.HitColor.b = math.min( self.HitColor.b / 2 + lightCol.b / 2, 250 )

  self.CaliberScaled = math.Clamp( math.pow( self.Caliber, 0.5 ), 1, 8 ) / 2

  if ( !self.HitMat || !approved_number[ self.HitMat ] ) then

    self.HitMat = 30

  end

  self.FxTable = BrPhysDef.MaterialEffects[ BrPhysDef.SurfaceProperties[ self.HitMat ].effect ]

  local hiteffect = BrPhysDef.SurfaceProperties[ self.HitMat ].effect
  local dist = self.Pos:DistToSqr( LocalPlayer():GetPos() )

  if ( Mode == BREACH_BULLET_HITWATER ) then

    sound.Play( "HAB.PhysBullet.Impact.Water", self.Pos )

    self.Pos = self.Pos + self.Dir1
    self:CreateEffects( self.HitMat )

    return

  elseif ( Mode == BREACH_BULLET_AIRBURST ) then

    if ( self.Caliber > 50 ) then

      self:Flak()

      if ( dist <= 10240000 ) then

        sound.Play( "HAB.PhysBullet.Explode.Flak.Close", self.Pos )

        if ( dist <= 2560000 ) then

          sound.Play( "HAB.PhysBullet.Explode.Flask.Layer.Debris", self.Pos )

        end

      else

        sound.Play( "HAB.PhysBullet.Explode.Flak.Far", self.Pos )

      end

    else

      self:AirBurst()

      sound.Play( "HAB.PhysBullet.Explode.Airburst", self.Pos )

    end

    return

  end


  if ( self.HitEnt && self.HitEnt:IsValid() && !self.HitEnt:IsWorld() ) then

    local isply = self.HitEnt:IsPlayer()

    if ( isply ) then

      if ( self.HitGroup == HITGROUP_HEAD ) then

        if ( self.HitEnt != LocalPlayer() ) then

          if ( isply && self.HitEnt.HasHelmet ) then

            sound.Play( "HAB.PhysBullet.Helmetshot.Player", self.Pos )

          else

            sound.Play( "HAB.PhysBullet.HeadShot.Player", self.Pos )
            local effect_data = EffectData()
            effect_data:SetOrigin( self.HitEnt:GetBonePosition( self.HitEnt:LookupBone( "ValveBiped.Bip01_Head1" ) ) )
            effect_data:SetScale( .8 )

            util.Effect( "br_blood_puff", effect_data )

          end

        else

          if ( isply && self.HitEnt.HasHelmet ) then

            sound.Play( "HAB.PhysBullet.Helmetshot.PlayerLocal", self.Pos )

          else

            sound.Play( "HAB.PhysBullet.Headshot.PlayerLocal", self.Pos )

          end

        end

      else

        if ( self.HitEnt != LocalPlayer() ) then

          if ( !self.HitEnt:IsNPC() ) then

            sound.Play( "HAB.PhysBullet.Impact.Player", self.Pos )

          end

        else

          sound.Play( "HAB.PhysBullet.Impact.PlayerLocal", self.Pos )

        end

      end

      self:CreateEffects()

      return

    end

  end

  if ( self.BulletType > 6000 && Mode == BREACH_BULLET_IMPACT ) then

    self:Explode()

    if ( self.Caliber >= 70 ) then

      if ( dist > 30250000 ) then

        sound.Play( "HAB.PhysBullet.Explode.Large.Far", self.Pos )

      else

        sound.Play( "HAB.PhysBullet.Explode.Large", self.Pos )

      end

    elseif ( self.Caliber > 35 ) then

      if ( dist > 20250000 ) then

        sound.Play( "HAB.PhysBullet.Explode.Medium.Far", self.Pos )

      elseif ( dist > 4000000 ) then

        sound.Play( "HAB.PhysBullet.Explode.Medium.Near", self.Pos )

      else

        sound.Play( "HAB.PhysBullet.Explode.Medium", self.Pos )

      end

    elseif ( self.Caliber >= 20 ) then


      sound.Play( "HAB.PhysBullet.Explode.Small", self.Pos )

      util.Decal( "ExplosiveGunshot", self.Pos - self.Dir1, self.Pos + self.Dir1 )

    else

      sound.Play( self.FxTable.snd, self.Pos )
      util.Decal( "ExplosiveGunshot", self.Pos - self.Dir1, self.Pos + self.Dir1 )

    end

  elseif ( Mode == BREACH_BULLET_RICOCHET ) then

    if ( self.Caliber < 20 ) then

      sound.Play( "HAB.PhysBullet.Small.Ricochet", self.Pos )

    elseif ( hiteffect == EFFECT_METAL ) then

      if ( dist > 4000000 ) then

        sound.Play( "HAB.PhysBullet.Far.Ricochet", self.Pos )

      else

        if ( self.Caliber < 50 ) then

          sound.Play( "HAB.PhysBullet.Small.Ricochet", self.Pos )

        elseif ( self.Caliber <  75 ) then

          sound.Play( "HAB.PhysBullet.Medium.Ricochet", self.Pos )

        else

          sound.Play( "HAB.PhysBullet.Large.Ricochet", self.Pos )

        end

      end

    else

      sound.Play( "HAB.PhysBullet.Impact.Large", self.Pos )

    end


    util.Decal( "decals/metal/metal_0"..math.random( 1, 5 ), self.Pos - self.Dir1, self.Pos + self.Dir1 )

    self:CreateEffects()

  elseif ( Mode == BREACH_BULLET_PENETRATE ) then

    if ( self.HitEnt && self.HitEnt:IsValid() && self.HitEnt:GetClass() == "prop_ragdoll" ) then

      sound.Play( "HAB.PhysBullet.Impact.Player", self.Pos )

    elseif ( self.Caliber < 30 ) then

      if ( self.HitEnt && self.HitEnt:IsValid() && self.HitEnt:GetClass():find( "goc" ) ) then

        sound.Play( "goc_shield.block", self.Pos )
        self:CreateEffects()

        return
      else

        sound.Play( self.FxTable.snd, self.Pos )

      end

    else

      sound.Play( typelargepen[ hiteffect ], self.Pos )

    end

    util.Decal( "Decal.PhysBullet.ConcreteNew", self.Pos - self.Dir1, self.Pos + self.Dir1 )

    self:CreateEffects()
    self.Dir1 = -self.Dir1
    self.Dir2 = -self.Dir2
    self:CreateEffects()

  else

    if ( self.Caliber > 30 ) then

      sound.Play( typelargepen[hiteffect], self.Pos )

    else

      sound.Play( self.FxTable.snd, self.Pos )

      if ( dist <= 4000000 && typedebris[hiteffect] )then

        sound.Play( typedebris[hiteffect], self.Pos )

      end

    end

    util.Decal( "decals/metal/metal_0"..math.random( 1, 5 ), self.Pos - self.Dir1, self.Pos + self.Dir1 )

    self:CreateEffects()

  end

end

function EFFECT:Explode()

  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 150 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 18 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled + 10 ) do

    local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )

    if ( Debris ) then

      Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
      Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
      Debris:SetStartAlpha( 255 )
      Debris:SetEndAlpha( 0 )
      Debris:SetStartSize( math.Rand( .32, 1.28 ) * self.CaliberScaled )
      Debris:SetRoll( math.Rand( 0, 360 ) )
      Debris:SetRollDelta( math.Rand( -5, 5 ) )
      Debris:SetAirResistance( 50 )
      Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
      Debris:SetGravity( gravvec )
      Debris:SetCollide( true )
      Debris:SetBounce( .4 )

    end

  end

  for i = 0, ( self.CaliberScaled + 10 ) do -- dust

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled + 16 ) do

    local Sparks = self.Emitter:Add( "effects/spark", self.Pos )

    if ( Sparks ) then

      Sparks:SetVelocity( ( self.Dir2 + VectorRand() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
      Sparks:SetDieTime( math.Rand( .5, 1.5 ) * self.CaliberScaled / 4 )
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

  if ( Flash ) then

    Flash:SetVelocity( self.Dir1 * 100 )
    Flash:SetAirResistance( 200 )
    Flash:SetDieTime( .15 )
    Flash:SetStartAlpha( 255 )
    Flash:SetEndAlpha( 0 )
    Flash:SetStartSize( 0 )
    Flash:SetEndSize( math.Rand( 1.75, 1.6 ) * self.CaliberScaled )
    Flash:SetRoll( math.Rand( 0, 360 ) )
    Flash:SetRollDelta( math.Rand( -2, 2 ) )
    Flash:SetColor( 255, 255, 255 )

  end

end

function EFFECT:AirBurst()

  for i = 0, 2 * self.Size do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 20, 500 * self.Size ) + VectorRand():GetNormalized() * 64 * self.Size )
      Smoke:SetDieTime( math.Rand( 1.28, 2.56 ) )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( 15 * self.Size )
      Smoke:SetEndSize( 35 * self.Size )
      Smoke:SetRoll( math.Rand( 150, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 300 )
      Smoke:SetGravity( Vector( math.Rand( -70, 70 ) * self.Size, math.Rand( -70, 70 ) * self.Size, math.Rand( 0, -100 ) ) )
      Smoke:SetColor( 130, 125, 115 )

    end

  end

  for i = 0, 2 * self.Size do

    local particle = self.Emitter:Add( "effects/spark", self.Pos )

    if ( particle ) then

      particle:SetVelocity( ( ( self.Dir1 * .75 ) + VectorRand() ) * math.Rand( 48, 480 ) * 2 )
      particle:SetDieTime( math.Rand( 1, 2 ) )
      particle:SetStartAlpha( 255 )
      particle:SetStartSize( math.Rand( 6, 8 ) )
      particle:SetEndSize( 0 )
      particle:SetRoll( math.Rand( 0, 360 ) )
      particle:SetRollDelta( math.Rand( -5, 5 ) )
      particle:SetAirResistance( 20 )
      particle:SetGravity( Vector( 0, 0, -300 ) )

    end

  end

  for i = 0, 1 do

    local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random( 1, 4), self.Pos )

    if ( Flash ) then

      Flash:SetVelocity( self.Dir1 * 64 )
      Flash:SetAirResistance( 200 )
      Flash:SetDieTime( .2 )
      Flash:SetStartAlpha( 255 )
      Flash:SetEndAlpha( 0 )
      Flash:SetStartSize( math.Rand( 64, 80 ) * self.Size )
      Flash:SetRoll( math.Rand( 180, 480 ) )
      Flash:SetRollDelta( math.Rand( -1, 1 ) )
      Flash:SetColor( 255, 255, 255 )

    end

  end


end

function EFFECT:Flak()

  ----print( "flak" )
  for i = 0, 3 * self.Size do -- main smoke

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )
    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 20, 500 * self.Size ) + VectorRand():GetNormalized() * 64 * self.Size )
      Smoke:SetDieTime( math.Rand( 1.28, 2 ) )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( 15 * self.Size )
      Smoke:SetEndSize( 35 * self.Size )
      Smoke:SetRoll( math.Rand( 150, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 300 )
      Smoke:SetGravity( Vector( math.Rand( -70, 70 ) * self.Size, math.Rand( -70, 70 ) * self.Size, math.Rand( 0, -100 ) ) )

    end

  end

  if ( self.Fancy ) then

    for i = 0, 2 * self.Size do

      local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

      if ( Smoke ) then

        Smoke:SetVelocity( self.Dir1 * 64 * self.Size )
        Smoke:SetDieTime( math.Rand( 1.92, 2.5 ) )
        Smoke:SetStartAlpha( math.Rand( 184, 255 ) )
        Smoke:SetEndAlpha( 0 )
        Smoke:SetStartSize( 8 * self.Size )
        Smoke:SetEndSize( 32 * self.Size )
        Smoke:SetRoll( math.Rand( 180, 480 ) )
        Smoke:SetRollDelta( math.Rand( -1, 1 ) )
        Smoke:SetAirResistance( 1024 )
        Smoke:SetGravity( Vector( math.Rand( -70, 70 ) * self.Size, math.Rand( -70, 70 ) * self.Size, math.Rand( 0, -100 ) ) )
        Smoke:SetColor( 30, 25, 15 )

      end

    end

    for i = 0, 6 * self.Size do

      local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )
      if ( Debris ) then

        Debris:SetVelocity( self.Dir1 * math.random( 200, 300 * self.Size ) + VectorRand():GetNormalized() * 192 * self.Size )
        Debris:SetDieTime( math.Rand( .8, 1.92 ) )
        Debris:SetStartAlpha( 255 )
        Debris:SetEndAlpha( 0 )
        Debris:SetStartSize( math.random( 2, 4 ) )
        Debris:SetRoll( math.Rand( 0, 360 ) )
        Debris:SetRollDelta( math.Rand( -5, 5 ) )
        Debris:SetAirResistance( 50 )
        Debris:SetColor( 105, 100, 90 )
        Debris:SetGravity( Vector( 0, 0, -600 ) )
        Debris:SetCollide( true )
        Debris:SetBounce( 1 )

      end

    end

    for i = 0, 8 * self.Size do

      local particle = self.Emitter:Add( "effects/spark", self.Pos )

      if ( particle ) then

        particle:SetVelocity( ( ( self.Dir1 * .75 ) + VectorRand() ) * math.Rand( 48, 480 ) * 2 )
        particle:SetDieTime( math.Rand( 1, 2 ) )
        particle:SetStartAlpha( 255 )
        particle:SetStartSize( math.Rand( -6, 6 ) )
        particle:SetEndSize( 0 )
        particle:SetRoll( math.Rand( 0, 360 ) )
        particle:SetRollDelta( math.Rand( -5, 5 ) )
        particle:SetAirResistance( 20 )
        particle:SetGravity( Vector( 0, 0, -300 ) )

      end

    end

  end

  for i = 0, 2 do

    local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Pos )

    if ( Flash ) then

      Flash:SetVelocity( self.Dir1 * 64 )
      Flash:SetAirResistance( 20 )
      Flash:SetDieTime( .2 )
      Flash:SetStartAlpha( 255 )
      Flash:SetEndSize( 0 )
      Flash:SetRoll( math.Rand( 180, 480 ) )
      Flash:SetRollDelta( math.Rand( -1, 1 ) )
      Flash:SetColor( 255, 255, 255 )

    end

  end


end

function EFFECT:CreateEffects()

  local is_valid = self.HitEnt && self.HitEnt:IsValid()

  if ( is_valid && self.HitEnt:GetClass() == "prop_ragdoll" || self.HitEnt:IsPlayer() ) then

    self.Emitter = ParticleEmitter( self.Pos )
    self.Emitter:SetNearClip( 32, 64 )

    self:Flesh()

    return
  end

  local effect = BrPhysDef.SurfaceProperties[ self.HitMat ].effect

  self.Emitter = ParticleEmitter( self.Pos )
  self.Emitter:SetNearClip( 32, 64 )

  effect = 8

  if ( is_valid && self.HitEnt:GetModel() == "models/cultist/scp/173.mdl" ) then

    self:Rock()
    return
  end

  if ( is_valid && self.HitEnt:GetClass():find( "goc" ) ) then

    self:Electric()
    return
  end

  if ( effect == 0 ) then

    self:Default()
    return
  end

  if ( effect == EFFECT_DEFAULT ) then

    self:Default()

  elseif ( effect == EFFECT_FLESH ) then

    self:Flesh()

  elseif ( effect == EFFECT_DIRT ) then

    self:Dirt()

  elseif ( effect == EFFECT_GRASS ) then

    self:Grass()

  elseif ( effect == EFFECT_CONCRETE ) then

    self:Concrete()

  elseif ( effect == EFFECT_BRICK ) then

    self:Brick()

  elseif ( effect == EFFECT_WOOD ) then

    self:Wood()

  elseif ( effect == EFFECT_PLASTER ) then

    self:Plaster()

  elseif ( effect == EFFECT_METAL ) then

    self:Metal()

  elseif ( effect == EFFECT_SAND ) then

    self:Sand()

  elseif ( effect == EFFECT_SNOW ) then

    self:Snow()

  elseif ( effect == EFFECT_GRAVEL ) then

    self:Gravel()

  elseif ( effect == EFFECT_WATER ) then

    self:Water()

  elseif ( effect == EFFECT_GLASS ) then

    self:Glass()

  elseif ( effect == EFFECT_TILE ) then

    self:Tile()

  elseif ( effect == EFFECT_CARPET ) then

    self:Carpet()

  elseif ( effect == EFFECT_ROCK ) then

    self:Rock()

  elseif ( effect == EFFECT_ICE ) then

    self:Ice()

  elseif ( effect == EFFECT_PLASTIC ) then

    self:Plastic()

  elseif ( effect == EFFECT_RUBBER ) then

    self:Rubber()

  elseif ( effect == EFFECT_HAY ) then

    self:Hay()

  elseif ( effect == EFFECT_FOLIAGE ) then

    self:Foliage()

  elseif ( effect == EFFECT_CARDBOARD ) then

    self:Cardboard()

  else

    self:Default()

  end

end


function EFFECT:Default()

  for i = 0, ( self.CaliberScaled ) do

    local smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( smoke ) then

      smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand() * self.CaliberScaled )
      smoke:SetDieTime( math.Rand( 0.64, 1.2 ) * self.CaliberScaled )
      smoke:SetStartAlpha( 150 )
      smoke:SetEndAlpha( 0 )
      smoke:SetStartSize( math.Rand( 12, 18 ) * self.CaliberScaled )
      smoke:SetEndSize( self.CaliberScaled )
      smoke:SetRoll( math.Rand( 0, 360 ) )
      smoke:SetRollDelta( math.Rand( -2, 2 ) )
      smoke:SetAirResistance( 400 )
      smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end


  for i = 0, ( self.CaliberScaled ) do

    local Splinters = self.Emitter:Add( "effects/fleck_wood"..math.random( 1, 2 ), self.Pos )

    if ( Splinters ) then

      Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
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
  for i = 0, ( self.CaliberScaled + 4 ) do

    local Splinters = self.Emitter:Add( "effects/fleck_tile"..math.random( 1, 2 ), self.Pos )

    if ( Splinters ) then

      Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
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

  for i = 0, ( self.CaliberScaled + 4 ) do

    local Splinters = self.Emitter:Add( "effects/fleck_glass"..math.random( 1, 3 ), self.Pos )

    if ( Splinters ) then

      Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
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


  for i = 0, ( self.CaliberScaled + 10 ) do

    local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos)

    if ( Debris ) then

      Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
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

  for i= 0, ( self.CaliberScaled ) do

    local Blood = self.Emitter:Add( "effects/blood_puff", self.Pos )

    if ( Blood ) then

      Blood:SetVelocity( self.Dir2 * math.random( 32, 44 ) * i + self.Dir1 * VectorRand():GetNormalized() * self.CaliberScaled * math.random( 12, 20 ) )
      Blood:SetDieTime( math.Rand( 0.4, 1 ) * self.CaliberScaled )
      Blood:SetStartAlpha( 120 )
      Blood:SetEndAlpha( 0 )
      Blood:SetStartSize( self.CaliberScaled )
      Blood:SetEndSize( math.Rand( 3, 6 ) * self.CaliberScaled )
      Blood:SetRoll( math.Rand( 0, 360 ) )
      Blood:SetRollDelta( math.Rand( -1, 1 ) )
      Blood:SetAirResistance( 100 )
      Blood:SetColor( 90, 5, 20 )
      Blood:SetGravity( gravvec / 8 )
      Blood:SetCollide( false )

    end

  end

  for i = 0, ( self.CaliberScaled * 10 ) do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 80 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled + 14 ) do

    local Sparks = self.Emitter:Add( "effects/spark", self.Pos )

    if ( Sparks ) then

      Sparks:SetVelocity( ( self.Dir2 + VectorRand() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
      Sparks:SetDieTime( math.Rand( 0.5, 1.5) * self.CaliberScaled / 4 )
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

  if ( Flash ) then


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

function EFFECT:Flesh()

  self.CaliberScaled = self.CaliberScaled * 2
  for i = 0, ( self.CaliberScaled ) do

    local Blood = self.Emitter:Add( "effects/blood_puff", self.Pos )

    if ( Blood ) then

      Blood:SetVelocity( self.Dir2 * math.random( 80, 100 ) * i + self.Dir1 * VectorRand():GetNormalized() * self.CaliberScaled * math.Rand( 48, 64 ) )
      Blood:SetDieTime( math.Rand( .8, 1.28 ) * self.CaliberScaled )
      Blood:SetStartAlpha( 128 )
      Blood:SetEndAlpha( 0 )
      Blood:SetStartSize( self.CaliberScaled )
      Blood:SetEndSize( math.Rand( 3, 6 ) * i * self.CaliberScaled )
      Blood:SetRoll( math.Rand( 0, 360 ) )
      Blood:SetRollDelta( math.Rand( -1, 1 ) )
      Blood:SetAirResistance( 256 )
      Blood:SetColor( 90, 5, 20 )
      Blood:SetGravity( gravvec / 9 )
      Blood:SetCollide( false )

    end

  end

  for i = 0, self.CaliberScaled do -- dust

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.Rand( 1, 2 ) + VectorRand() ) * math.Rand( 24, 32 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 12, 18 ) * self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 200 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 6 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end

function EFFECT:Dirt()

  for i = 0, self.CaliberScaled do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 160 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 16 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled * 1.5 + 4 ) do

    local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )

    if ( Debris ) then

      Debris:SetVelocity( ( self.Dir1 * math.Rand( 1, 2 ) + self.Dir2 + VectorRand():GetNormalized() ) * math.Rand( 32, 48 ) * self.CaliberScaled )
      Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
      Debris:SetStartAlpha( 255 )
      Debris:SetEndAlpha( 0 )
      Debris:SetStartSize( math.Rand( .32, 1.28 ) * self.CaliberScaled )
      Debris:SetRoll( math.Rand( 0, 360 ) )
      Debris:SetRollDelta( math.Rand( -5, 5 ) )
      Debris:SetAirResistance( 50 )
      Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
      Debris:SetGravity( gravvec )
      Debris:SetCollide( true )
      Debris:SetBounce( .4  )

    end

  end

  for i = 0, self.CaliberScaled + 10 do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 2, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 2, 4 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 12, 24 ) * self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end

function EFFECT:Grass()

  for i = 0, self.CaliberScaled do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 160 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 16 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end


  for i = 0, ( self.CaliberScaled * 2 + 8 ) do

    local Splinters = self.Emitter:Add( "effects/fleck_wood"..math.random( 1, 2 ), self.Pos )

    if ( Splinters ) then

      Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 48 ) * self.CaliberScaled )
      Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 3 )
      Splinters:SetStartAlpha( 255 )
      Splinters:SetEndAlpha( 0 )
      Splinters:SetStartSize( math.Rand( 2, 4 ) )
      Splinters:SetRoll( math.Rand( 0, 360 ) )
      Splinters:SetRollDelta( math.Rand( -32, 32 ) )
      Splinters:SetAirResistance( 64 )
      Splinters:SetColor( 16, 84, 32 )
      Splinters:SetGravity( gravvec )
      Splinters:SetCollide( true )
      Splinters:SetBounce( .4 )

    end

  end

  for i = 0, self.CaliberScaled + 10 do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 2, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 2, 4 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 12, 24 ) * self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b  )

    end

  end

end


function EFFECT:Concrete()

  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * ( self.CaliberScaled / 4 ) )
      Smoke:SetStartAlpha( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 18 ) * self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled + 10 ) do

    local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )

    if ( Debris ) then

      Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 48 ) * self.CaliberScaled )
      Debris:SetDieTime( math.random( 1, 3 ) * ( self.CaliberScaled / 4 ) )
      Debris:SetStartAlpha( 255 )
      Debris:SetEndAlpha( 0 )
      Debris:SetStartSize( math.Rand( 1, 1.4 ) * self.CaliberScaled )
      Debris:SetRoll( math.Rand( 0, 360 ) )
      Debris:SetRollDelta( math.Rand( -20, 20 ) )
      Debris:SetAirResistance( 50 )
      Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
      Debris:SetGravity( gravvec )
      Debris:SetCollide( true )
      Debris:SetBounce( .4 )

    end

  end

  for i = 0, self.CaliberScaled + 6 do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * ( self.CaliberScaled / 4 ) )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled + 8 ) do

    local Sparks = self.Emitter:Add( "effects/spark", self.Pos )

    if ( Sparks ) then

      Sparks:SetVelocity( ( self.Dir2 + VectorRand() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
      Sparks:SetDieTime( math.Rand( .5, 1.5 ) * ( self.CaliberScaled / 4 ) )
      Sparks:SetStartAlpha( 255 )
      Sparks:SetEndAlpha( 0 )
      Sparks:SetStartSize( math.Rand( 1,2 ) * self.CaliberScaled / 2 )
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

  if ( Flash ) then

    Flash:SetVelocity( self.Dir1 * 100 )
    Flash:SetDieTime( .15 )
    Flash:SetStartAlpha( 255 )
    Flash:SetEndAlpha( 0 )
    Flash:SetStartSize( 0 )
    Flash:SetEndSize( math.Rand( 1.75, 2 ) * self.CaliberScaled  )
    Flash:SetRoll( math.Rand( 0, 360 ) )
    Flash:SetRollDelta( math.Rand( -2, 2 ) )
    Flash:SetColor( 255, 255, 255 )

  end

end

function EFFECT:Brick()

  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 256, 640 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 160 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 18 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled ) do

    local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )

    if ( Debris ) then

      Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 48 ) * self.CaliberScaled )
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
      Debris:SetBounce( .4 )

    end

  end

  for i = 0, ( self.CaliberScaled + 6 ) do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled + 6 ) do

    local Sparks = self.Emitter:Add( "effects/spark", self.Pos )

    if ( Sparks ) then

      Sparks:SetVelocity( ( self.Dir2 + VectorRand() ) * math.Rand( 32, 64 ) * self.CaliberScaled )
      Sparks:SetDieTime( math.Rand( .5, 1.5 ) * self.CaliberScaled / 4 )
      Sparks:SetStartAlpha( 255 )
      Sparks:SetEndAlpha( math.Rand( 1, 2 ) * self.CaliberScaled / 2 )
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

  if ( Flash ) then

    Flash:SetVelocity( self.Dir1 * 100 )
    Flash:SetDieTime( .15 )
    Flash:SetStartAlpha( 255 )
    Flash:SetEndAlpha( 0 )
    Flash:SetEndSize( math.Rand( 1.75, 2 ) * self.CaliberScaled )
    Flash:SetRoll( math.Rand( 0, 360 ) )
    Flash:SetRollDelta( math.Rand( -2, 2 ) )
    Flash:SetColor( 255, 255, 255 )

  end


end

function EFFECT:Wood()

  for i = 0, ( self.CaliberScaled + 8 ) do

    local Splinters = self.Emitter:Add( "effects/fleck_wood"..math.random( 1, 2 ), self.Pos )

    if ( Splinters ) then

      Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 24, 32 ) * self.CaliberScaled )
      Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
      Splinters:SetStartAlpha( 255 )
      Splinters:SetEndAlpha( 0 )
      Splinters:SetStartSize( math.Rand( .64, 1.6 ) * self.CaliberScaled )
      Splinters:SetRoll( math.Rand( 0, 360 ) )
      Splinters:SetRollDelta( math.Rand( -24, 24 ) )
      Splinters:SetAirResistance( 50 )
      Splinters:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
      Splinters:SetGravity( gravvec )
      Splinters:SetCollide( true )
      Splinters:SetBounce( .4 )

    end

  end

  for i = 0, self.CaliberScaled + 10 do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 48 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 1.8 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 + Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end

function EFFECT:Plaster()

  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 150 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 18 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled + 10 ) do

    local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )

    if ( Debris ) then

      Debris:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 32, 48 ) * self.CaliberScaled )
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
      Debris:SetBounce( .4 )

    end

  end

  for i = 0, ( self.CaliberScaled + 10 ) do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( 0, 10 ) )  * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end

function EFFECT:Metal()

  self.CaliberScaled = self.CaliberScaled * 2

  for i = 0, self.CaliberScaled do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 32 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.6, 2.56 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 100, 128 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 4 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled * 2 + 8 ) do

    local Sparks = self.Emitter:Add( "effects/spark", self.Pos )

    if ( Sparks ) then

      Sparks:SetVelocity( ( self.Dir2 + VectorRand() ) * math.random( 32, 64 ) * self.CaliberScaled )
      Sparks:SetDieTime( math.Rand( .64, 1.92 ) * self.CaliberScaled / 4 )
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

  for i = 0, ( self.CaliberScaled ) do

    local Flash = self.Emitter:Add( "effects/fire_embers"..math.random( 1, 3 ), self.Pos + self.Dir2 * i * 2 )

    if ( Flash ) then

      Flash:SetVelocity( self.Dir1 * 100 )
      Flash:SetAirResistance( 200 )
      Flash:SetDieTime( .2 )
      Flash:SetStartAlpha( 255 )
      Flash:SetEndAlpha( 0 )
      Flash:SetStartSize( 0 )
      Flash:SetEndSize( math.Rand( 1.75, 1.6 ) * self.Caliber )
      Flash:SetRoll( math.Rand( 0, 360 ) )
      Flash:SetRollDelta( math.Rand( -2, 2 ) )
      Flash:SetRollDelta( math.Rand( -2, 2 ) )
      Flash:SetColor( 255, 255, 255 )

    end

  end

end

function EFFECT:Sand()


  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 256, 384 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.6 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 160 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 16 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1.5, 1.5 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled ) + ( gravvec / 4 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled + 8 ) do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -24, 24 ), math.Rand( -24, 24 ), math.Rand( -24, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end

function EFFECT:Gravel()

  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 255 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, self.CaliberScaled + 8 do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -24, 24 ), math.Rand( -24, 24 ), math.Rand( -24, 0 ) ) * self.CaliberScaled + ( gravvec / 4 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end


function EFFECT:Snow()
  --print( "snow" )
  for i = 0, self.CaliberScaled do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 160 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 16 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled * 1.5 + 4 ) do

    local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )

    if ( Debris ) then

      Debris:SetVelocity( ( self.Dir1 * math.Rand( 1, 2 ) + self.Dir2 + VectorRand():GetNormalized() ) * math.Rand( 32, 48 ) * self.CaliberScaled )
      Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
      Debris:SetStartAlpha( 255 )
      Debris:SetEndAlpha( 0 )
      Debris:SetStartSize( math.Rand( .32, 1.28 ) * self.CaliberScaled )
      Debris:SetRoll( math.Rand( 0, 360 ) )
      Debris:SetRollDelta( math.Rand( -5, 5 ) )
      Debris:SetAirResistance( 50 )
      Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
      Debris:SetGravity( gravvec )
      Debris:SetCollide( true )
      Debris:SetBounce( .4 )

    end

  end

  for i = 0, ( self.CaliberScaled + 10 ) do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 2, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 2, 4 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 12, 24 ) * self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  sound.Play( "HAB.PhysBullet.Impact.Snow", self.Pos )
end

function EFFECT:Gravel()

  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 256 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 160 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 16 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, ( self.CaliberScaled * 2 + 4 ) do

    local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random( 1, 2 ), self.Pos )

    if ( Debris ) then

      Debris:SetVelocity( ( self.Dir1 * math.Rand( 1, 2 ) + self.Dir2 + VectorRand():GetNormalized() ) * math.Rand( 32, 48 ) * self.CaliberScaled )
      Debris:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
      Debris:SetStartAlpha( 255 )
      Debris:SetEndAlpha( 0 )
      Debris:SetStartSize( math.Rand( .32, 1 ) * self.CaliberScaled )
      Debris:SetRoll( math.Rand( 0, 360 ) )
      Debris:SetRollDelta( math.Rand( -5, 5 ) )
      Debris:SetAirResistance( 50 )
      Debris:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
      Debris:SetGravity( gravvec )
      Debris:SetCollide( true )
      Debris:SetBounce( .4 )

    end

  end

  for i = 0, ( self.CaliberScaled + 10 ) do

    local Smoke = self.Emitter:Add( "partucle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 2, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 2, 4 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 12, 24 ) * self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end

function EFFECT:Water()


end

function EFFECT:Electric( )

  self.CaliberScaled = self.CaliberScaled * 2

	--[[for i = 0, self.CaliberScaled do -- dust

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

	end]]

	for i = 0, ( self.CaliberScaled * 8 + 8 ) do -- sparks

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

function EFFECT:Glass()

  for i = 0, ( self.CaliberScaled + 4 ) do

    local Splinters = self.Emitter:Add( "effects/fleck_glass"..math.random( 1, 3 ), self.Pos )

    if ( Splinters ) then

      Splinters:SetVelocity( ( self.Dir2 + self.Dir1 + VectorRand():GetNormalized() ) * math.Rand( 16, 32 ) * self.CaliberScaled )
      Splinters:SetDieTime( math.random( 1, 3 ) * self.CaliberScaled / 2 )
      Splinters:SetStartAlpha( 255 )
      Splinters:SetEndAlpha( 0 )
      Splinters:SetStartSize( math.Rand( .64, 1.28 ) * self.CaliberScaled )
      Splinters:SetRoll( math.Rand( 0, 360 ) )
      Splinters:SetRollDelta( math.Rand( -8, 8 ) )
      Splinters:SetAirResistance( 50 )
      Splinters:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )
      Splinters:SetGravity( gravvec / 2 )
      Splinters:SetCollide( true )
      Splinters:SetBounce( .4 )

    end

  end

end

function EFFECT:Tile()

  self:Concrete()

end

function EFFECT:Carpet()

  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( self.Dir1 * math.random( 192, 512 ) + VectorRand() * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( .64, 1.2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( 150 )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 12, 18 ) * self.CaliberScaled )
      Smoke:SetEndSize( self.CaliberScaled )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -2, 2 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir2 * Vector( math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) * self.CaliberScaled, math.Rand( -84, 84 ) ) + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

  for i = 0, self.CaliberScaled do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end

function EFFECT:Rock()

  self:Concrete()

end

function EFFECT:Ice()

  self:Glass()

end


function EFFECT:Plastic()

  for i = 0, ( self.CaliberScaled + 8 ) do -- dust

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled  + ( gravvec / 3 ) )
      Smoke:SetColor( self.HitColor.r, self.HitColor.g, self.HitColor.b )

    end

  end

end

function EFFECT:Rubber() -- plastic

  self:Plastic()

end

function EFFECT:Hay()

  self:Wood()

end

function EFFECT:Foliage()

  self:Wood()

end

function EFFECT:Cardboard()

  for i = 0, ( self.CaliberScaled ) do

    local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self.Pos )

    if ( Smoke ) then

      Smoke:SetVelocity( ( self.Dir1 * math.random( 1, 3 ) + VectorRand() ) * math.random( 24, 64 ) * self.CaliberScaled )
      Smoke:SetDieTime( math.Rand( 1.2, 2 ) * self.CaliberScaled )
      Smoke:SetStartAlpha( math.Rand( 80, 100 ) )
      Smoke:SetEndAlpha( 0 )
      Smoke:SetStartSize( math.Rand( 4, 8 ) * self.CaliberScaled )
      Smoke:SetEndSize( math.Rand( 16, 32 ) * self.CaliberScaled + 16 )
      Smoke:SetRoll( math.Rand( 0, 360 ) )
      Smoke:SetRollDelta( math.Rand( -1, 1 ) )
      Smoke:SetAirResistance( 400 )
      Smoke:SetGravity( self.Dir1 * Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 0 ) ) * self.CaliberScaled + ( gravvec / 3 ) )

    end

  end

end

function EFFECT:Think()

  return false

end

function EFFECT:Render() end

function EFFECT:OnRemove()

  if ( IsValid( self.Emitter ) ) then

    self.Emitter:Finish()

  end

end
