if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/215.png" )

end

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.PrintName = "SCP-215"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.WorldModel = "models/cultist/scp_items/215/w_215.mdl"
SWEP.ViewModel = "models/cultist/scp_items/215/v_215.mdl"
SWEP.HoldType = "slam"
SWEP.UseHands = true
SWEP.IsDrinking = nil

SWEP.Pos = Vector( 2, 4, 2 )
SWEP.Ang = Angle( -90, 90, 90 )

function SWEP:SetupDataTables()

  self:NetworkVar( "Bool", 0, "IsActive" )

end

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

function SWEP:DrawWorldModel()

	local pl = self:GetOwner()

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if ( !bone ) then return end

		local wm = self:CreateWorldModel()
		local pos, ang = self.Owner:GetBonePosition( bone )

		if ( wm && wm:IsValid() ) then

			ang:RotateAroundAxis( ang:Right(), self.Ang.p )
			ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
			ang:RotateAroundAxis( ang:Up(), self.Ang.r )

			wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
			wm:SetRenderAngles( ang )
			wm:DrawModel()

		end

	else

		self:SetRenderOrigin( nil )
		self:SetRenderAngles( nil )
		self:DrawModel()

	end

end

SWEP.Deployed = false

function SWEP:Deploy()

  self.IdleDelay = CurTime() + .5
  self.HolsterDelay = nil
  self:SetIsActive( false )
  self:PlaySequence( "draw" )
  self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying && !self:GetIsActive() ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle", true )

	end

end

SWEP.Friendly_Teams =  {

  [ TEAM_CB ] = {

    [ TEAM_GUARD ] = true,
    [ TEAM_SCI ] = true,
    [ TEAM_SPECIAL ] = true,
    [ TEAM_NTF ] = true,
    [ TEAM_OBR ] = true,
    [ TEAM_CB ] = true,

  },
  [ TEAM_GUARD ] = {

    [ TEAM_SCI ] = true,
    [ TEAM_SPECIAL ] = true,
    [ TEAM_CB ] = true,
    [ TEAM_NTF ] = true,
    [ TEAM_OBR ] = true,
    [ TEAM_GUARD ] = true

  },
  [ TEAM_CLASSD ] = {

    [ TEAM_CHAOS ] = true

  },
  [ TEAM_SCI ] = {

    [ TEAM_GUARD ] = true,
    [ TEAM_CB ] = true,
    [ TEAM_SCI ] = true,
    [ TEAM_NTF ] = true,
    [ TEAM_OBR ] = true,
    [ TEAM_SPECIAL ] = true

  },

  [ TEAM_SPECIAL ] = {

    [ TEAM_GUARD ] = true,
    [ TEAM_CB ] = true,
    [ TEAM_SCI ] = true,
    [ TEAM_NTF ] = true,
    [ TEAM_OBR ] = true,
    [ TEAM_SPECIAL ] = true


  },
  [ TEAM_CHAOS ] = {

    [ TEAM_CLASSD ] = true

  }

}

SWEP.Outline_Color = Color( 180, 0, 0, 180 )

function SWEP:PrimaryAttack()

  self:SetNextPrimaryFire( CurTime() + 2 )

  self.IdleDelay = CurTime() + 2

  if ( !self:GetIsActive() ) then

    self:PlaySequence( "puton" )
    self:SetIsActive( true )

    if ( CLIENT ) then

      self.Owner:ScreenFade( SCREENFADE.OUT, color_black, .5, 1 )

      timer.Simple( 1.5, function()

        hook.Add( "PreDrawOutlines", "DrawEnemys", function()

          local client = LocalPlayer()

          if ( !client:HasWeapon( "item_scp_215" ) || client:GetActiveWeapon() != NULL && client:GetActiveWeapon():GetClass() != "item_scp_215" ) then

            if ( client:Health() > 0 ) then

              client:ScreenFade( SCREENFADE.IN, color_black, .5, 1 )

            end

            hook.Remove( "PreDrawOutlines", "DrawEnemys" )

            return
          end

          local entity_find_pos = ents.FindInSphere( client:GetPos(), 300 )

          local tbl_enemys = {}

          for i = 1, #entity_find_pos do

            local ent = entity_find_pos[ i ]

            if ( !ent:IsPlayer() || ent == client ) then continue end

            if ( ent:GTeam() == TEAM_SPEC || self.Friendly_Teams[ client:GTeam() ][ ent:GTeam() ] ) then continue end
            local bnmrgtable = ents.FindByClassAndParent("breach_bonemerge", ent)
            tbl_enemys[ #tbl_enemys + 1 ] = ent
            if istable(bnmrgtable) then
              for _, bnmrg in pairs(bnmrgtable) do
                if IsValid(bnmrg) then tbl_enemys[ #tbl_enemys + 1 ] = bnmrg end
              end
            end

          end

          if ( #tbl_enemys > 0 ) then

            outline.Add( tbl_enemys, self.Outline_Color, OUTLINE_MODE_BOTH )

          end

        end )

      end )

    end

  else

    if ( CLIENT ) then

      hook.Remove( "PreDrawOutlines", "DrawEnemys" )
      self.Owner:ScreenFade( SCREENFADE.IN, color_black, .5, 1 )

    end

    local seq_id = self:LookupSequence( "putoff" )

    self:PlaySequence( seq_id )
    self:SetIsActive( false )

    timer.Simple( self:SequenceDuration( seq_id ) - 1, function()

      if ( self && self:IsValid() ) then

        self:PlaySequence( "idle", true )

      end

    end )

  end

end

SWEP.Sanity = 0

function SWEP:Think()

  if ( self:GetIsActive() && ( self.NextSanityUp || 0 ) < CurTime() ) then

    self.NextSanityUp = CurTime() + .25

    if ( self.Sanity < 100 ) then

      self.Sanity = self.Sanity + 1

    end

    if ( self.Sanity >= 60 && self.droppable == nil ) then

      if ( SERVER ) then

        self.Owner:Tip( 3, "[Ares Breach]", self.Outline_Color, "Ваша привязанность к SCP-215 стала настолько высока, что Вы уже не в состоянии с ним расстаться.", color_white )

      end

      self.droppable = false
      self.UndroppableItem = true

    end

  end

  if ( SERVER ) then

    if ( self.Sanity >= 100 ) then

      if ( self.Owner:Health() > 0 ) then

        self.Owner:Kill()
        self.Sanity = 0

      end

    end

  else

    if ( self.Sanity >= 80 ) then

      colour = .7 * math.abs( math.sin( CurTime() ) * 8 )

    end

  end

end

function SWEP:Holster()

  if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + 1
    self.IdleDelay = CurTime() + 3
  	self:PlaySequence( "holster" )
    self:SetIsActive( false )
    self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then

    self.Deployed = nil

		return true
	end

end

function SWEP:CanSecondaryAttack()

  return false

end
