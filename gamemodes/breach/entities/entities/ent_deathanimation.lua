AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Death Animation ( Fake Ragdoll )"

if ( CLIENT ) then

  ENT.Animations = {

    4813,
    4812,
    4811,
    5204,
    5188

  }

  function ENT:Initialize()

    self:SetMoveType( MOVETYPE_NONE )

    timer.Simple( .3, function()

      if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) ) then return end

      self:SetModel( self.Owner:GetModel() )
      self:SetSkin( self.Owner:GetSkin() )

      if ( #self.Bodygroups > 0 ) then

        for i = 1, #self.Bodygroups do

          local bodygroup = self.Bodygroups[ i ]

          self:SetBodygroup( bodygroup.id, bodygroup.value )

        end

      end

      self:SetAutomaticFrameAdvance( true )
      self:SetPlaybackRate( 1.0 )
      self:SetCycle( 0 )

      self.SetupComplete = true

    end )

  end

  function ENT:Think()

    self:NextThink( CurTime() )

    if ( self:GetSequence() == 0 ) then

      self:SetSequence( self.Animations[ math.random( 1, #self.Animations ) ] )

    elseif ( self:GetCycle() < 1 ) then

      self:SetCycle( math.Approach( self:GetCycle(), 1, RealFrameTime() * .35 ) )

    end

    if ( self.Owner:Health() > 0 ) then

      self:Remove()

    elseif ( self.Owner:GetNWEntity( "NTF1Entity" ) != self ) then

      self.Owner:SetNWEntity( "NTF1Entity", self )

    end

  end

  function ENT:Draw()

    if ( !self.SetupComplete ) then return end

    self:DrawModel()

  end

end
