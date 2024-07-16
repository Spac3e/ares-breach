include( "shared.lua" )

local vec_offset = Vector( 0, 0, 30 )

function ENT:Think()

  if ( !self.StartPatricle ) then

    self.StartPatricle = true
    ParticleEffect( "portal1_green", self:GetPos() + vec_offset, angle_zero, self )

  end

end

function ENT:OnRemove()

  self:StopAndDestroyParticles()

end

function ENT:Draw()
end
