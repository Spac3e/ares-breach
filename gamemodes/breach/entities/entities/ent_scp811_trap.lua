AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model( "models/cultist/scp/811/811_puke_mine.mdl" )

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "CanTrigger" )

end

sound.Add( {

  name = "scp_811_trap.place",
  volume = 1,
  soundlevel = 80,
  pitch = { 90, 100 },
  sound = "nextoren/scp/811/mine/place.wav"

} )

sound.Add( {

  name = "scp_811_trap.trigger",
  volume = 1,
  soundlevel = 90,
  pitch = { 100, 105 },
  sound = "nextoren/scp/811/mine/hit.wav"

} )

function ENT:Initialize()

  self:SetModel( self.Model )
  self:SetMoveType( MOVETYPE_NONE )

  self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
  self:SetSolid( SOLID_VPHYSICS )

  self:PhysWake()

  self.fl_Health = 100

  if ( SERVER ) then

    self:SetTrigger( true )

    timer.Simple( .15, function()

      if ( self && self:IsValid() ) then

        local current_pos = self:GetPos()

        self:SetPos( Vector( current_pos.x, current_pos.y, GroundPos( current_pos ).z ) )

        timer.Simple( .1, function()

          if ( self && self:IsValid() ) then

            self:SetCanTrigger( true )
            self:EmitSound( "scp_811_trap.place" )

          end

        end )

      end

    end )

  end

end

if ( CLIENT ) then

  function ENT:Draw()

    if ( self:GetCanTrigger() ) then

      self:DrawModel()

    end

  end

end

if ( SERVER ) then

  function ENT:Use( caller )

    if ( self:GetCanTrigger() && caller:GetRoleName() == "SCP811" ) then

      caller:SetSpecialMax( caller:GetSpecialMax() + 1 )

      self:Remove()

    end

  end

  function ENT:Touch( ent )

    if ( !self:GetCanTrigger() || !ent:IsPlayer() || ent:GTeam() == TEAM_SCP ) then return end

    if ( self.Triggered ) then return end

    self.Triggered = true

    self:Explode()

  end

  function ENT:OnTakeDamage( dmginfo )

    if ( dmginfo:GetDamageType() == DMG_BUCKSHOT ) then return end

    self.fl_Health = math.max( self.fl_Health - dmginfo:GetDamage(), 0 )

    if ( self.fl_Health == 0 && !self.Triggered ) then

      self.Triggered = true
      self:Explode()

    end

  end

  function ENT:Explode()

    local owner = self:GetOwner()

    if ( owner && owner:IsValid() && owner:GetRoleName() == "SCP811" ) then

      owner:SetSpecialMax( owner:GetSpecialMax() + 1 )

    end

    self:EmitSound( "nextoren/scp/811/mine/hit.wav" )

    local counter = 0

    for i = 1, 10 do

      timer.Simple( .05 * i, function()

        local poison_ball = ents.Create( "ent_scp811_poisonball" )
        poison_ball:SetOwner( owner )
        poison_ball:SetPos( self:GetPos() + ( vector_up * 4 ) )
        poison_ball:SetAngles( Angle( 0, 0, math.random( 86, 90 ) ) )
        poison_ball:SetVelocity( ( vector_up * 400 ) + ( VectorRand() * 128 ) )
        poison_ball.CantExplode = true
        poison_ball:Spawn()
        poison_ball:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
        poison_ball:SetGravity( .75 )

        timer.Simple( .25, function()

          if ( poison_ball && poison_ball:IsValid() ) then

            poison_ball.CantExplode = nil

          end

        end )

        counter = counter + 1

        if ( counter > 9 ) then

          self:Remove()

        end

      end )

    end

  end

end
