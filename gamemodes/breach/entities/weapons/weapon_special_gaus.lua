AddCSLuaFile()

SWEP.HoldType = "gauss"

if ( CLIENT ) then

  SWEP.Category = "[NextOren] Guns"
  SWEP.PrintName = "Пушка Гаусса"
  SWEP.Slot = 1
  SWEP.ViewModelFOV = 50
  SWEP.DrawSecondaryAmmo = false
  SWEP.DrawAmmo = false
  SWEP.InvIcon = Material( "nextoren/gui/icons/gaus.png" )

end

SWEP.ViewModel = "models/weapons/gaus/c_gauss.mdl"
SWEP.WorldModel = "models/weapons/gaus/w_gauss_fixed_2.mdl"

SWEP.PrimaryDamage = 180

SWEP.UseHands = true

SWEP.Pos = Vector( -5, 8, 0 )
SWEP.Ang = Angle( 0, 205, 0 )

SWEP.Shooting = false
SWEP.Damage = 20

SWEP.Idle = ACT_VM_IDLE

function SWEP:Deploy()

  self:SendWeaponAnim( ACT_VM_DRAW )

  self:SetHoldType( self.HoldType )

  self.IdleAnimation = CurTime() + 1

  return true
end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

  self.ShockDamageInfo = DamageInfo()
  self.ShockDamageInfo:SetDamage( self.Damage )
  self.ShockDamageInfo:SetDamageType( DMG_DISSOLVE )
  self.ShockDamageInfo:SetInflictor( self )

  if ( CLIENT ) then return end

  local filter = RecipientFilter()
  filter:AddAllPlayers()

  self.ChargingUpSound = CreateSound( self, "nextoren/weapons/gauss/gauss_charge_start.wav", filter )
  self.LoopSound = CreateSound( self, "nextoren/weapons/gauss/gauss_siege_loop.wav", filter )
  self.ShootSound = CreateSound( self, "nextoren/weapons/gauss/gauss_siege_fire1.wav", filter )
  self.ShootSound_Loop = CreateSound( self, "nextoren/weapons/gauss/gauss_precision_charge_idle_new.wav", filter )

end

function SWEP:Holster()

  if ( self.Shooting || self.Charging ) then

    return false

  end

  return true

end

function SWEP:Equip(owner)

  owner:CompleteAchievement("gauss")

end

function SWEP:ImpactEffect( tr )

  if ( tr.HitSky ) then return end

  local effect = EffectData()
  effect:SetOrigin( tr.HitPos )
  effect:SetNormal( tr.HitNormal )

  util.Effect( "cball_explode", effect, true, true )

  return true
end

function SWEP:Tracer( tr )

  local effectdata = EffectData()
  effectdata:SetOrigin( tr.HitPos )
  effectdata:SetStart( self.Owner:GetShootPos() )
  effectdata:SetAttachment( 1 )
  effectdata:SetEntity( self )

  util.Effect( "gauss_effect", effectdata, true, true )

end

SWEP.CanCharge = true

local maxs = Vector( 4, 8, 8 )

function SWEP:Think()

  self:NextThink( CurTime() )

  if ( ( self.IdleAnimation || 0 ) < CurTime() && !self.Charging ) then

    self:SendWeaponAnim( self.Idle )

  end

  if ( SERVER && self.Shooting ) then

    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = tr.start + self.Owner:GetAimVector() * 32800
    tr.filter = self.Owner
    tr.mins = -maxs
    tr.maxs = maxs

    tr = util.TraceHull( tr )

    local ent = tr.Entity

    if ( ent && ent:IsValid() && ent:IsPlayer() || ent && ent:IsValid() && ( ent:GetOwner() && ent:GetOwner():IsValid() && ent:GetOwner():IsPlayer() && ent:GetOwner():GetRoleName() == "SCP173" ) ) then

      --self.ShockDamageInfo:SetDamageForce( ent:GetAimVector() * 120 )
      self.ShockDamageInfo:SetAttacker( self.Owner ) -- Update attacker ( In case new weapon owner )

      if ( ent:IsPlayer() && ent:GTeam() != TEAM_SCP ) then -- Human

        self.ShockDamageInfo:SetDamage( 9999 )
        ent.disintegrate = true

        timer.Simple( 5, function()

          if ( ent && ent:IsValid() ) then

            ent.disintegrate = nil

          end

        end )

      else

        self.ShockDamageInfo:SetDamage( 250 )

      end

      ent:TakeDamageInfo( self.ShockDamageInfo )

    end

    if ( self.t_StartShoot < CurTime() - 8 ) then

      self.Shooting = false

      if ( SERVER ) then

        self.ShootSound_Loop:Stop()

      end

      self.CanCharge = false

    end

  end

  if ( CLIENT && self.Charging ) then

    self.Owner.wep_dlight = DynamicLight( self.Owner:EntIndex() )
    if ( self.Owner.wep_dlight ) then

      self.Owner.wep_dlight.pos = self.Owner:GetShootPos()
      self.Owner.wep_dlight.r = 0
      self.Owner.wep_dlight.g = 0
      self.Owner.wep_dlight.b = 210
      self.Owner.wep_dlight.brightness = 2
      self.Owner.wep_dlight.Decay = 40
      self.Owner.wep_dlight.Size = 256
      self.Owner.wep_dlight.DieTime = CurTime() + .1

    end

  end

  if ( self.Shooting ) then -- Shared

    local tr = self.Owner:GetEyeTrace()
    self:ImpactEffect( tr ) -- Create effect on tr.HitPos
    self:Tracer( tr )

    if ( self.t_StartShoot < CurTime() - 8 ) then

      self.Shooting = false

      if ( SERVER ) then

        self.ShootSound_Loop:Stop()

      end

      self.CanCharge = false

    end

  end

end

function SWEP:CanPrimaryAttack() return false end

function SWEP:OnDrop()

  if ( self.Shooting ) then

    self.Shooting = nil
    self.ShootSound_Loop:Stop()
    self.CanCharge = false

    return
  end

end

function SWEP:Shoot()

  if ( self.Shooting || !self.CanCharge ) then return end

  self.IdleAnimation = CurTime() + 1.8
  self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )

  if ( SERVER ) then

    self.LoopSound:Stop()

    self.ShootSound:Play()

    timer.Simple( .4, function()

      if ( self && self:IsValid() ) then

        self.ShootSound_Loop:Play()

      end

    end )

  end

  self.Charging = false
  self.Shooting = true

  self.t_StartShoot = CurTime()

end

function SWEP:SecondaryAttack()

  if ( ( self.NextChargeAttempt || 0 ) > CurTime() || !self.CanCharge || self.Charging ) then return end

  self.NextChargeAttempt = CurTime() + 1.5

  if ( !self.Charging ) then

    self.Charging = true

    if ( SERVER ) then

      self.ChargingUpSound:Play()

      timer.Simple( 2, function()

        if ( !self.LoopSound:IsPlaying() ) then

          self.LoopSound:Play()

        end

      end )

    end

    timer.Simple( 6, function()

      if ( self && self:IsValid() ) then

        self:Shoot()

      end

    end )

    self:SendWeaponAnim( ACT_VM_DEPLOY )

  end

end

function SWEP:CreateWorldModel()

  if ( !self.WModel ) then

    self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
    self.WModel:SetNoDraw( true )

  end

  return self.WModel

end

function SWEP:DrawWorldModel()

  local pl = self.Owner

  if ( pl && pl:IsValid() ) then

    if ( self.Charging ) then

      pl.wep_dlight = DynamicLight()
      if ( pl.wep_dlight ) then

        pl.wep_dlight.pos = pl:GetShootPos()
        pl.wep_dlight.r = 0
        pl.wep_dlight.g = 0
        pl.wep_dlight.b = 210
        pl.wep_dlight.brightness = 2
        pl.wep_dlight.Decay = 40
        pl.wep_dlight.Size = 256
        pl.wep_dlight.DieTime = CurTime() + .1

      end

    end

    local bone = pl:LookupBone( "ValveBiped.Bip01_R_Hand" )
    if ( !bone ) then return end
    local pos, ang = pl:GetBonePosition( bone )

    if ( bone ) then

      local wm = self:CreateWorldModel()

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
