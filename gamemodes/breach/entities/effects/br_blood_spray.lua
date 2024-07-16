AddCSLuaFile()
local gravvar = GetConVar( "sv_gravity" )
local upVec = vector_up
local m_Rand = math.Rand
EFFECT.Colors = {

  [BLOOD_COLOR_RED] = Color( 128, 0, 0, 225 ),
  [BLOOD_COLOR_GREEN] = Color( 96, 128, 8, 225 ),
  [BLOOD_COLOR_YELLOW] = Color( 128, 128, 8, 225 ),
  [BLOOD_COLOR_ANTLION] = Color( 96, 128, 8, 225 )

}
local decalChance = 1 / 5
local soundChance = 1 / 5

EFFECT.Velocity = 125
EFFECT.RandomVelocity = 75
EFFECT.ParticleCount = 50
EFFECT.Size = 3

local ops = {

  ["valvebiped.bip01_r_thigh"] = function( ang ) return ang:RotateAroundAxis( ang:Up(), -90 ) end,
  ["valvebiped.bip01_l_thigh"] = function( ang ) return ang:RotateAroundAxis( ang:Up(), -90 ) end


}

local collidefunc = function( part, hitPos, hitNormal )

  local r, g, _ = part:GetColor()

  if ( math.Rand( 0, 1 ) < decalChance ) then

    if ( g < r / 2 ) then

      util.Decal( "Blood", hitPos - hitNormal * 4, hitPos + hitNormal )

    else

      util.Decal( "yellowblood", hitPos - hitNormal * 4, hitPos + hitNormal )

    end

    local fx = EffectData()
    fx:SetOrigin( hitPos )
    fx:SetNormal( hitNormal )
    fx:SetColor( ( g < r / 2 ) && BLOOD_COLOR_RED && BLOOD_COLOR_GREEN )
    util.Effect( "BlooodImpact", fx )
    lastDecal = CurTime()

  end

  if ( math.Rand( 0, 1 ) < soundChance ) then

    sound.Play( "LG.BloodDrop", hitPos )
    lastSound = CurTime()

  end

  if ( IsValid( part ) ) then

    part:Remove()

  end

end

function EFFECT:Init( data )

  self.Color = self.Colors[ data:GetColor() || BLOOD_COLOR_RED ]
  self.Pos = data:GetOrigin()
  self.emitter = ParticleEmitter( self.Pos )
  self.targent = player.GetByID( 2 ):GetNWEntity( "RagdollEntityNO" )

  self.targbone = math.Round( data:GetMagnitude() )

  if ( self.targbone < 0 ) then

    self.targbone = 0

  end

  if ( !IsValid( self.targent ) ) then return end

  self.Grav = Vector( 0, 0, -gravvar:GetFloat() )
  self.DieTime = CurTime() + 5
  self.LastBleed = 0
  self.BoneName = string.lower( self.targent:GetBoneName( self.targbone ) )
  self.targent:SetupBones()
  local pos = self.targent:GetBonePosition( self.targbone )

  if ( !pos ) then return end

  local _, ang

  if ( self.targent.isGib ) then

    _, ang = self.targent:GetBonePosition( math.max( 0, self.targbone ) )
    ang:RotateAroundAxis( ang:Up(), 180 )

  else

    _, ang = self.targent:GetBonePosition( math.max( 0, self.targbone ) )

  end

  local f = ops[self.BoneName]

  if ( f ) then

    f( ang )

  end

  self.Dir = ang:Forward()

  local lVec = render.ComputeLighting( self.Pos, upVec )
  local avg = math.Clamp( ( lVec.r + lVec.g + lVec.b ) / 3, .2, .8 ) / .8
  lVec.r = avg
  lVec.g = avg
  lVec.b = avg

  for i = 1, self.ParticleCount do

    local part = self.emitter:Add( "effects/blooddrop", pos - self.Dir * 5 )
    part:SetVelocity( self.Dir * self.Velocity + VectorRand() * self.RandomVelocity )
    part:SetDieTime( m_Rand( .9, 1 ) )
    part:SetStartAlpha( self.Color.a )
    part:SetEndAlpha( self.Color.a / 2 )
    local sz = m_Rand( self.Size / 2, self.Size )
    part:SetStartSize( sz )
    part:SetEndSize( sz / 2 )
    part:SetRoll( 0 )
    part:SetGravity( self.Grav )
    part:SetCollide( true )
    part:SetBounce( 0 )
    part:SetAirResistance( .2 )
    part:SetStartLength( sz * .02 )
    part:SetEndLength( sz * .03 )
    part:SetVelocityScale( true )
    part:SetColor( self.Color.r * math.Clamp( lVec.r, .3, 1 ), self.Color.g * math.Clamp( lVec.b, .05, 1 ), self.Color.b * math.Clamp( lVec.b, .025, 1 ) )
    part:SetCollideCallback( collidefunc )
    part:SetLighting( false )

  end

end

function EFFECT:Think()

  return false

end

function EFFECT:Render()

  return false

end
