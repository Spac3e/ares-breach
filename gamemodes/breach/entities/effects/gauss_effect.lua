local BLAST_SHOOT = Material( "effects/tracer/tracer_02" )

function EFFECT:Init( data )

  self.Position = data:GetStart()
  self.EndPos = data:GetOrigin()
  self.WeaponEnt = data:GetEntity()
  self.Attachment = data:GetAttachment()
  self.StartPos = self:GetTracerShootPos( self.Posiiton, self.WeaponEnt, self.Attachment )

  if ( self.StartPos && self.EndPos ) then

    self:SetRenderBoundsWS( self.StartPos, self.EndPos )

  end

  if ( !( isvector( self.StartPos ) && isvector( self.EndPos ) ) ) then return end

  self.Dir = ( self.EndPos - self.StartPos ):GetNormalized()
  self.Dist = self.StartPos:Distance( self.EndPos )

  self.LifeTime = .02 - ( .02 / self.Dist )
  self.DieTime = CurTime() + self.LifeTime

end

function EFFECT:Think()

  if ( CurTime() > ( self.DieTime || 0 ) ) then return false end

  return true

end

function EFFECT:Render()

  local v1 = ( CurTime() - self.DieTime ) / self.LifeTime
  local v2 = ( self.DieTime - CurTime() ) / self.LifeTime
  local a = self.EndPos - self.Dir * math.min( 1 - ( v1 * self.Dist ), self.Dist )

  render.SetMaterial( BLAST_SHOOT )
  render.DrawBeam( a, self.EndPos, v2 * 6, 0, self.Dist / 10, ColorAlpha( color_white, v2 * 255 ) )

end
