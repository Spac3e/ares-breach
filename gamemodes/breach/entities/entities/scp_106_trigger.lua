AddCSLuaFile()

ENT.Type = "anim"
ENT.Name = "SCP-106 Trigger"
ENT.Category = "NextOren"
ENT.Uses = 0

ENT.Pos = Vector( 3654.719238, -14806.517578, -2975.182617 )
ENT.Angle = Angle( 0, -90, 0 )

function ENT:Initialize()

  self:SetModel("models/props_lab/keypad.mdl") --Important note: Change model!!!

  self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_FLY )
	self:SetSolid( SOLID_VPHYSICS )
  self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

  self:SetNoDraw( true )
  self:DrawShadow( false )

  self:SetPos( self.Pos )
  self:SetAngles( self.Angle )

  self:SetColor( color_white )

end

ENT.Victims106 = {}
ENT.AlreadyVictim = {}

ENT.NextTriggerHurt = 0
ENT.Radius_Check = 300 * 300

if ( SERVER ) then

  function ENT:Think()

    if ( ( self.NextTriggerHurt || 0 ) >= CurTime() ) then return end
    self.NextTriggerHurt = CurTime() + 1.5

    for _, victim in ipairs( ents.FindInSphere( self:GetPos(), 280 ) ) do

      if ( victim:IsPlayer() && victim:IsSolid() && victim:Health() > 0 && !self.AlreadyVictim[ victim ] ) then

        self.AlreadyVictim[ victim ] = true
        self.Victims106[ #self.Victims106 + 1 ] = victim

      end

    end

    for i = 1, #self.Victims106 do

      local victim = self.Victims106[ i ]

      if ( !( victim && victim:IsValid() ) ) then

        self.Victims106 = {}
        self.AlreadyVictim = {}

        continue
      end

      if ( victim:Health() > 0 && victim:GetPos():DistToSqr( self:GetPos() ) < self.Radius_Check ) then

        victim:SetHealth( victim:Health() - math.random( 1, 4 ) )
        victim:SetDSP( 28 )

      else

        if ( victim:Health() <= 0 ) then

          victim:Kill()

        end

        victim:SetDSP( 1 )
        table.remove( self.Victims106, i )
        self.AlreadyVictim[ victim ] = nil

      end

    end

  end

end
