AddCSLuaFile()

local gravvar = GetConVar( "sv_gravity" )
local upVec = vector_up
local m_Rand = math.Rand
EFFECT.Colors = {

  [BLOOD_COLOR_RED] = Color( 128, 0, 0, 180 ),
  [BLOOD_COLOR_GREEN] = Color( 96, 128, 8, 225 ),
  [BLOOD_COLOR_YELLOW] = Color( 128, 128, 8, 225 ),
  [BLOOD_COLOR_ANTLION] = Color( 96, 128, 8, 225 )

}
local particlesPerSecond = 30
local decalsPerSecond = 10
local soundsPerSecond = 20
local lastDecal = 0
local dropDistanceThreshold = 2.5
local lastSound = 0
EFFECT.FPS = particlesPerSecond

EFFECT.PoolCounter = 0
EFFECT.PoolCounterMax = 3
EFFECT.LastPos = Vector()
EFFECT.LastImpact = Vector()

EFFECT.Velocity = 100
EFFECT.SpurtPeriod = .7
EFFECT.SpurtFactor = .25

EFFECT.PoolMovementThreshold = 3

EFFECT.PoolParticles = {}

local dropFade = 2

local function dropDecay( p )

  local mult = math.Clamp( p:GetDieTime() - p:GetLifeTime(), 0, dropFade ) / dropFade

  p:SetStartAlpha( 255 * mult )
  p:SetEndAlpha( 255 * mult )

  if ( mult < 1 ) then

    p:SetNextThink( CurTime() )

  end

end

function EFFECT:Init( data )


end

function EFFECT:Think()

  if ( !self.DieTime ) then return false end
  if ( !IsValid( self.targent ) ) then return end
  if ( CurTime() > self.DieTime ) then return false end

  local bmat = self.targent:GetBoneMatrix( self.targbone )
  if ( !bmat ) then self:Die() return end

  local bpos = bmat:GetTranslation()
  self.Pos = LerpVector( FrameTime() * 10, self.Pos, bpos )

  if ( !self.LastPos ) then

    self.LastPos = self.Pos

  else

    if ( self.Pos:Distance( self.LastPos ) > self.PoolMovementThreshold ) then

      self.LastPos = self.Pos

      for _, part in pairs( self.PoolParticles ) do

        local mult = part:GetLifeTime() / part:GetDieTime()
        part:SetStartSize( mult * ( part:GetEndSize() - part:GetStartSize() ) + part:GetStartSize() )
        part:SetEndSize( part:GetStartSize() )

      end

      table.Empty( self.PoolParticles )

    end

  end


  local lVec = render.ComputeLighting( self.Pos, upVec )
  local avg = math.Clamp( ( lVec.r + lVec.g + lVec.b ) / 3, .2, .8 ) / .8
  lVec.r = avg
  lVec.g = avg
  lVec.b = avg

  if ( CurTime() > self.LastBleed + 1 / self.FPS ) then

    self.lastblood = CurTime()
    local pos = self.Pos
    local _, ang

    _, ang = self.targent:GetBonePosition( math.max( 0, self.targent:GetBoneParent( self.targbone ) ) )

    local f = ops[ self.BoneName ]

    if ( f ) then

      f( ang )

    end

    self.emitter:SetPos( pos )
    self.Dir = ang:Forward()
    local part = self.emitter:Add( "effects/blood_core", pos - self.Dir * 5 )
    part:SetVelocity( self.Dir * self.Velocity * ( 1 + math.sin( CurTime() * math.pi * 2 / self.SpurtPeriod ) * self.SpurtFactor ) )
    part:SetDieTime( m_Rand( .9, 1 ) )
    part:SetStartAlpha( self.Color.a )
    part:SetEndAlpha( self.Color.a / 2 )
    local sz = m_Rand( 5, 6 )
    part:SetStartSize( sz )
    part:SetEndSize( sz )
    part:SetRoll( 0 )
    part:SetGravity( self.Grav )
    part:SetCollide( true )
    part:SetBounce( 0 )
    part:SetAirResistance( .25 )
    part:SetStartLength( .15 )
    part:SetEndLength( .3 )
    part:SetVelocityScale( true )
    part:SetColor( self.Color.r * math.Clamp( lVec.r, .3, 1 ), self.Color.g * math.Clamp( lVec.b, .05, 1 ), self.Color.b * math.Clamp( lVec.b, .025, 1 ) )
    part:SetCollideCallback( function( pt, hitPos, hitNormal )

      if ( IsValid( self ) ) then

        local lVec2 = render.ComputeLighting( self.Pos, upVec )
        local avg = math.Clamp( ( lVec2.r + lVec2.g + lVec2.b ) / 3, .2, .8 ) / .8
        lVec2.r = avg
        lVec2.g = avg
        lVec2.b = avg
        local drop = self.emitter3D:Add( "particle/smokesprites_000" .. math.random( 1, 9 ), hitPos + hitNormal )
        drop:SetAngles( hitNormal:Angle() )
        drop:SetStartSize( pt:GetStartSize() * .5 )
        drop:SetEndSize( pt:GetStartSize() * 3 )
        drop:SetDieTime( 15 )
        drop:SetColor( self.Color.r * math.Clamp( lVec2.r, .3, 1 ), self.Color.g * math.Clamp( lVec2.b, .05, 1 ), self.Color.b * math.Clamp( lVec2.b, .025, 1 ) )
        drop:SetLighting( false )
        drop:SetStartAlpha( 255 )
        drop:SetEndAlpha( 255 )
        drop:SetThinkFunction( dropDecay )
        drop:SetNextThink( CurTime() + drop:GetDieTime() - dropFade )
        self.PoolParticles[ #self.PoolParticles + 1 ] = drop

      end

      if ( IsValid( pt ) ) then

        pt:Remove()

      end

    end )

    part:SetLighting( false )

  end

  return true
end

function EFFECT:Render()

  return false

end

function EFFECT:Die()

  if ( IsValid( self.emitter ) ) then

    self.emitter:Finish()

  end

  local em = self.emitter3D

  timer.Simple( 15, function()

    if ( IsValid( em ) ) then

      em:Finish()

    end

  end )

end
