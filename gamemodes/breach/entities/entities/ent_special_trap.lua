AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"
ENT.Category    = "Breach"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model       = Model( "models/special_sci_props/mine.mdl"  )

function ENT:Initialize()

  self:SetModel( self.Model )
  self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );

  local phys_obj = self:GetPhysicsObject()

  if ( phys_obj && phys_obj:IsValid() ) then

    phys_obj:Wake()
    phys_obj:EnableMotion( false )

  end

  self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
  self:SetHealth( 100 )

  self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

  self.dmginfo = DamageInfo()
  self.dmginfo:SetDamage( 40 )
  self.dmginfo:SetDamageType( DMG_POISON )
  if self:GetOwner() == NULL then self:SetOwner(self) end
  self.dmginfo:SetAttacker( self:GetOwner() || self )
  self.dmginfo:SetInflictor( self )

end

function ENT:Explode( attacker )

  local ents_smokepoison = ents.Create( "base_gmodentity" )
  ents_smokepoison:SetPos( self:GetPos() )
  ents_smokepoison:SetAngles( self:GetAngles() )
  ents_smokepoison:SetNoDraw( true )
  ents_smokepoison.dmginfo = DamageInfo()
  ents_smokepoison.dmginfo:SetDamage( 5 )
  ents_smokepoison.dmginfo:SetDamageType( DMG_POISON )
  ents_smokepoison.dmginfo:SetAttacker( attacker )
  ents_smokepoison.dmginfo:SetInflictor( self )
  ents_smokepoison:Spawn()
  timer.Simple( math.random( 30, 40 ), function()

    if ( ents_smokepoison && ents_smokepoison:IsValid() ) then

      ents_smokepoison:Remove()

    end

  end )

  ParticleEffectAttach( "smoker_smokecloud", PATTACH_POINT_FOLLOW, ents_smokepoison, 0 )

  ents_smokepoison.Think = function( self )

    self:NextThink( CurTime() + .7 )

    for _, v in ipairs( ents.FindInSphere( self:GetPos(), 200 ) ) do

      if ( v:IsPlayer() && !v:HasHazmat() && v:GetRoleName() != "MTF_Chem" ) then

        v:TakeDamageInfo( self.dmginfo )

      end

    end

    return true

  end

end

function ENT:OnTakeDamage( dmginfo )

  self:SetHealth( self:Health() - dmginfo:GetDamage() )

  if ( self:Health() <= 0 ) then

    self.Triggered = true
    self:Explode( dmginfo:GetAttacker() )
    self:Remove()

  end

end

function ENT:Touch( collider )

  if ( collider:IsPlayer() && collider:IsSolid() && collider:GTeam() == TEAM_SCP ) then

    self.Triggered = true

    collider.dmginfomine = self.dmginfo
    collider.SpeedMultiplier = .5

    timer.Simple( 5, function()

      if ( collider && collider:IsValid() ) then

        collider.SpeedMultiplier = nil

      end

    end )

    timer.Create( "ColliderDamage" .. collider:SteamID64(), 1, 5, function()

      if ( collider && collider:IsValid() && collider:Health() > 0 && collider:GTeam() == TEAM_SCP ) then

        collider:TakeDamageInfo( collider.dmginfomine )

      end

    end )

    self:Remove()

  end

end

function ENT:OnRemove()

  if ( self.Triggered ) then

    self:EmitSound( "nextoren/vo/special_sci/mine_trigger.mp3" )

  end

end

function ENT:Use( caller )

  if ( caller == self:GetOwner() ) then

    caller:SetSpecialMax( caller:GetSpecialMax() + 1 )

    self:Remove()

  end

end

function ENT:Draw()

  self:DrawModel()

end
