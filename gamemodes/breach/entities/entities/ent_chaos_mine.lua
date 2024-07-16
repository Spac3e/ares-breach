AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "CI Mine"
ENT.Model = "models/cultist/humans/chaos/items/claymore_mine.mdl"

function ENT:Initialize()

  self:SetModel( self.Model )

  self:SetMoveType( MOVETYPE_NONE )
  self:SetSolid( SOLID_VPHYSICS )

  self:EmitSound( "nextoren/weapons/claymore/fire.wav" )
  self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

  if ( CLIENT ) then return end


  timer.Simple( .75, function()

    if ( self && self:IsValid() ) then

      self:SetActive( true )
      self:EmitSound( "nextoren/weapons/claymore/motion_sensor_activate.wav" )

    end

  end )

end

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Active" )
  self:NetworkVar( "Bool", 1, "Triggered" )

  self:SetActive( false )
  self:SetTriggered( false )

end

if ( CLIENT ) then

  local clr_red = Color( 180, 0, 0, 210 )

  local laser_mat = Material( "cable/redlaser" )

  function ENT:Draw()

    self:DrawModel()

    if ( !self:GetActive() && !self:GetTriggered() ) then return end

    if ( !self.OriginVector ) then

      self.OriginVector = self:GetPos() + self:GetForward() * 2.7 + self:GetUp() * 11.8 + self:GetRight() * -2.2
      self.EndVector = self:GetPos() + self:GetRight() * -12 + self:GetForward() * 8 + self:GetUp() * 11.8

      self.OriginVector_2 = self:GetPos() - self:GetForward() * 2.7 + self:GetUp() * 11.8 + self:GetRight() * -2.2
      self.EndVector_2 = self:GetPos() + self:GetRight() * -12 - self:GetForward() * 8 + self:GetUp() * 11.8

    end

    render.SetMaterial( laser_mat )

    local is_triggered = self:GetTriggered()

    if ( is_triggered ) then

      if ( !self.SinSum ) then

        self.SinSum = 24

      end

      self.SinSum = math.Approach( self.SinSum, 30, RealFrameTime() * 4 )

    end

    if ( self:GetActive() || is_triggered && math.sin( RealTime() * self.SinSum ) > .7 ) then

      render.DrawBeam( self.OriginVector, self.EndVector, 2, 1, 1, color_white )
      render.DrawBeam( self.OriginVector_2, self.EndVector_2, 2, 1, 1, color_white )

    end

  end

end

if ( SERVER ) then

  ENT.Explode_Effects = {

    "gas_explosion_fireball",
    "gas_explosion_firesmoke"

  }

  function ENT:OnTakeDamage()

    if ( self:GetTriggered() ) then return end

    self:SetTriggered( true )

    self:Explode( self:GetPos() )
    self:Remove()

  end

  function ENT:Explode( pos )

    self:EmitSound( "misc.explosion" )

    for i = 1, #self.Explode_Effects do

      local s_explosion_effect = self.Explode_Effects[ i ]

      net.Start( "CreateParticleAtPos" )

        net.WriteString( s_explosion_effect )
        net.WriteVector( pos )

      net.Broadcast()

    end

    local explosion_damage = DamageInfo()
    explosion_damage:SetDamageType( DMG_BLAST )
    explosion_damage:SetDamage( 500 )
    explosion_damage:SetInflictor( self )
    if self:GetOwner() == NULL then
      self:SetOwner(game.GetWorld())
    end
    explosion_damage:SetAttacker( self:GetOwner() )

    util.BlastDamageInfo( explosion_damage, pos, 500 )

  end

  local default_angle_offset = Angle( 0, 90, 0 )

  function ENT:Think()

    if ( !self:GetActive() ) then return end

    local forward_angles = ( self:GetAngles() + default_angle_offset ):Forward()
    local sensor_ents = ents.FindInCone( self:GetPos() - forward_angles * 6, forward_angles, 100, .70710678118655 ) -- 45 degrees

    for i = 1, #sensor_ents do

      local ent = sensor_ents[ i ]

      if ( ent:IsPlayer() && ent:GTeam() != TEAM_CHAOS && ent:IsLineOfSightClear( self ) && ent:IsSolid() ) then

        self:SetActive( false )
        self:SetTriggered( true )
        self:EmitSound( "nextoren/weapons/claymore/motion_sensor_detect.wav" )

        timer.Simple( .3, function()

          if ( self && self:IsValid() ) then

            self:EmitSound( "nextoren/weapons/claymore/motion_sensor_predetonate.wav" )

            timer.Simple( 1, function()

              if ( self && self:IsValid() ) then

                self:Explode( self:GetPos() )
                self:Remove()

              end

            end )

          end

        end )

      end

    end

  end

  function ENT:Use( activator )

    if ( activator != self:GetOwner() ) then return end

    activator:SetSpecialMax( activator:GetSpecialMax() + 1 )

    self:Remove()

  end

end
