

AddCSLuaFile()

local LocalPlayer = LocalPlayer
local math = math
local gravvec = Vector( 0, 0, -300 )
local sound = sound

function EFFECT:Init( data )

  self.Pos = data:GetOrigin()

  self.Emitter = ParticleEmitter( self.Pos )
  self:Gas()

end

local vel_vec = Vector( -200, -200, -200 )
local gas_clr = Color( 77, 77, 77 )

function EFFECT:Gas()

  local GasParticle = self.Emitter:Add( "particle/vistasmokev1_fog_add", self.Pos )

  if ( GasParticle ) then

    GasParticle:SetDieTime( 80 )
    GasParticle:SetStartAlpha( 255 )
    GasParticle:SetEndAlpha( 0 )
    GasParticle:SetStartSize( 250 )
    GasParticle:SetAirResistance( 100 )
    GasParticle:SetColor( gas_clr )
    GasParticle:SetCollide( true )
    GasParticle:SetBounce( .4 )
    GasParticle:SetVelocity( vel_vec )

  end

end
