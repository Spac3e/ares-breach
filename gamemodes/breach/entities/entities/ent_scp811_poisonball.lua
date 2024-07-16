AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model( "models/hunter/misc/sphere025x025.mdl" )

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Exploded" )

  self:SetExploded( false )

end

function ENT:Initialize()

  self:SetModel( self.Model )
  self:SetMoveType( MOVETYPE_FLYGRAVITY )
  self:SetSolid( SOLID_VPHYSICS )
  self:PhysWake()

  if ( SERVER ) then

    self:SetTrigger( true )

    self.travel_snd = CreateSound( self, "nextoren/scp/811/poison_ball/travel_lp.wav"  )
    self.travel_snd:Play()

    timer.Simple( .1, function()

      if ( self && self:IsValid() && !self:GetExploded() ) then

        if ( self.Distant ) then

          net.Start( "CreateClientParticleSystem" )

            net.WriteEntity( self )
            net.WriteString( "Poison_Ball" )
            net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )
            net.WriteUInt( 1, 7 )
            net.WriteVector( vector_origin )
            net.WriteBool( true )

          net.Broadcast()

        else

          net.Start( "CreateClientParticleSystem" )

            net.WriteEntity( self )
            net.WriteString( "Priestess_Ball" )
            net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )
            net.WriteUInt( 1, 7 )
            net.WriteVector( vector_origin )
            net.WriteBool( true )

          net.Broadcast()

        end

      end

    end )

  end

end

if ( CLIENT ) then

  function ENT:Draw()

    if ( !self:GetExploded() ) then

      local dynamic_light = DynamicLight( self:EntIndex() )

  		if ( dynamic_light ) then

  			dynamic_light.Pos = self:GetPos()
  			dynamic_light.r = 0
  			dynamic_light.g = 180
  			dynamic_light.b = 0
  			dynamic_light.Brightness = 4
  			dynamic_light.Size = 280
  			dynamic_light.Decay = 2500
  			dynamic_light.DieTime = CurTime() + .1

  		end

    end

  end

end

if ( SERVER ) then

  function ENT:Touch( ent )

    if ( ent != self:GetOwner() && ent:GetClass() != "ent_scp811_poisonball" && !self.CantExplode ) then

      if ( !self:GetExploded() ) then

        self:SetExploded( true )
        self:Explode()

      end

    end

  end

  function ENT:Explode()

    local explode_dmginfo = DamageInfo()
    explode_dmginfo:SetDamage( math.random( 40, 90 ) )
    explode_dmginfo:SetDamageType( DMG_BUCKSHOT )
    explode_dmginfo:SetAttacker( self:GetOwner() || NULL )
    explode_dmginfo:SetInflictor( self )

    util.BlastDamageInfo( explode_dmginfo, self:GetPos(), 220 )

    self:SetMoveType( MOVETYPE_NONE )
    self:SetTrigger( false )

    self.travel_snd:Stop()

    sound.Play( "nextoren/scp/811/poison_ball/hit.wav", self:GetPos(), 75, math.random( 80, 100 ), 1 )

    if ( self.Distant ) then

      net.Start( "CreateClientParticleSystem" )

        net.WriteEntity( self )
        net.WriteString( "scp_811_blast" )
        net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )
        net.WriteUInt( 1, 7 )
        net.WriteVector( -vector_up )

      net.Broadcast()

    else

      net.Start( "CreateClientParticleSystem" )

        net.WriteEntity( self )
        net.WriteString( "priestess_explosion" )
        net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )
        net.WriteUInt( 1, 7 )
        net.WriteVector( -vector_up )

      net.Broadcast()

    end

    self.DieTime = CurTime() + 1.25

  end

  function ENT:Think()

    self:NextThink( CurTime() + .25 )

    if ( self.DieTime && self.DieTime < CurTime() ) then

      self:Remove()

    end

  end

end
