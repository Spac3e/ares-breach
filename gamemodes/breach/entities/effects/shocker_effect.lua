
function EFFECT:Init( data )

  self.Shooter = data:GetEntity()
  self.Attachment = data:GetAttachment()
  self.WeaponEnt = self.Shooter:GetActiveWeapon()
  self.KillTime = 0
  self.ShouldRender = false

  if ( GetViewEntity() == self.Shooter ) then

    self.ViewModel = self.Shooter:GetViewModel()

  else

    self.ViewModel = self.WeaponEnt

  end

  if ( !self.ViewModel:IsValid() ) then return end

  local Muzzle = self.ViewModel:GetAttachment( self.Attachment )
  local hitpos = self.Shooter:GetEyeTrace().HitPos
  self:SetRenderBounds( Muzzle.Pos + Vector() * 1, hitpos - Vector() * 20 )

  self.KillTime = 2
  self.ShouldRender = true

end

function EFFECT:Think()

  if ( CurTime() > self.KillTime ) then return false end
  if ( self.WeaponEnt != self.Shooter:GetActiveWeapon() ) then return false end

  return true

end

function EFFECT:Render()

  if ( !self.ShouldRender ) then return end

  local Muzzle = self.ViewModel:GetAttachment( self.Attachment )
  if ( !Muzzle ) then return end

  local MuzzleAng = self.Shooter:GetAimVector()
  local RenderPos = Muzzle.Pos
  local hitpos = self.Shooter:GetEyeTrace().HitPos
  self:SetRenderBoundsWS( RenderPos + Vector() * 1, hitpos - Vector() * 20 )




end
