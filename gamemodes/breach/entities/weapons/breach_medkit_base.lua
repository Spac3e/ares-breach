SWEP.InvIcon = Material( "nextoren/gui/icons/med_1.png" )
SWEP.ProgressIcon = "nextoren/gui/icons/med_1.png"

SWEP.PrintName = "Medkit Base Name"

SWEP.ViewModel    = "models/cultist/items/medkit/v_medkit.mdl"
SWEP.WorldModel   = "models/cultist/items/medkit/w_medkit.mdl"

SWEP.Pos = Vector( -6, -1, -2 )
SWEP.Ang = Angle( -90, -50, 180 )

SWEP.HoldType   = "heal"
SWEP.UseHands = true

SWEP.Healing = false

SWEP.Skin = 0

SWEP.PercentHeal = .5 -- 50%

SWEP.Heal_Left = 3

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

  self:SetSkin( 0 )

end

function SWEP:Holster()
  return self.Healing
end


function SWEP:Deploy()

  self.HolsterDelay = nil
  self.IdleDelay = CurTime() + 1
  self:PlaySequence( "deploy" )

  timer.Simple( .1, function()

    if ( self && self:IsValid() ) then

      self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )

    end

  end )

end

function SWEP:MakeHealSound()
  for i = 1, 3 do
    timer.Create("Heal_Sound_"..i.."_"..self.Owner:SteamID64(), 0.6 + (i - 1), 1, function()
      self:EmitSound("nextoren/charactersounds/start_healing.wav", 100, 100, 1.25, CHAN_WEAPON)
    end)
  end
end

function SWEP:StopHealSound()
  for i = 1, 3 do
    timer.Remove("Heal_Sound_"..i.."_"..self.Owner:SteamID64())
  end
end

function SWEP:Heal( target )

  local animation
  local heal_time

  if ( self.Owner:IsFrozen() || self.Owner:GetMoveType() != MOVETYPE_WALK ) then return end

  if ( target ) then

    if ( target:Health() >= target:GetMaxHealth() ) then

      BREACH.Players:ChatPrint( self.Owner, true, true, target:GetNamesurvivor() .. " не нуждается в лечении." )

      return
    end

    BREACH.Players:ChatPrint( target, true, true, "Подождите: " .. self.Owner:GetNamesurvivor() .. " пытается Вас вылечить." )

    animation = "l4d_Heal_Friend_Standing"

    heal_time = select( 2, self.Owner:LookupSequence( animation ) )

    self.Healing = true

    self.Owner:BrProgressBar( "l:medkit_healing " .. target:GetName() .. "...", heal_time, self.ProgressIcon, target, false, function()

      self.Heal_Left = self.Heal_Left - 1

      self.Healing = false

      BREACH.Players:ChatPrint( self.Owner, true, true, "Лечение завершено. Здоровье " .. target:GetNamesurvivor() .. " восстановлено." )
      BREACH.Players:ChatPrint( target, true, true, "Ваше здоровье было восстановлено благодаря " .. self.Owner:GetNamesurvivor() )
      self.Owner:AddToMVP("heal", math.min(target:GetMaxHealth() - target:Health(), target:GetMaxHealth() * self.PercentHeal))
      target:AnimatedHeal( target:GetMaxHealth() * self.PercentHeal )

      self.Owner:SetNWEntity( "NTF1Entity", NULL )

    end, function() self:MakeHealSound() self.Owner:SetNWEntity("NTF1Entity", self.Owner) self.Owner:SetForcedAnimation( animation, heal_time ) end, function() self:StopHealSound() self.Owner:SetNWEntity("NTF1Entity", NULL) self.Owner:StopForcedAnimation() end)

  else

    if ( !self.Owner:Crouching() ) then

      animation = "l4d_Heal_Self_Standing_06"

    else

      animation = "l4d_Heal_Self_Crouching"

    end

    self.Healing = true

    heal_time = select( 2, self.Owner:LookupSequence( animation ) )
    

    self.Owner:BrProgressBar( "l:medkit_healing", heal_time, self.ProgressIcon, nil, false, function()

      if ( !( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) ) ) then return end

      self.Healing = false

      BREACH.Players:ChatPrint( self.Owner, true, true, "l:medkit_heal_ended" )

    self.Owner:AddToMVP("heal", math.min(self.Owner:GetMaxHealth() - self.Owner:Health(), self.Owner:GetMaxHealth() * self.PercentHeal))
    self.Owner:AnimatedHeal( self.Owner:GetMaxHealth() * self.PercentHeal )
    self.Owner:SetNWEntity( "NTF1Entity", NULL )

      self.Heal_Left = self.Heal_Left - 1

    end, function() self:MakeHealSound() self.Owner:SetNWEntity("NTF1Entity", self.Owner) self.Owner:SetForcedAnimation( animation, heal_time ) end, function() self:StopHealSound() self.Owner:SetNWEntity("NTF1Entity", NULL) self.Owner:StopForcedAnimation() end)

  end

end

function SWEP:PrimaryAttack()

  if ( self:GetNWEntity( "NTF1Entity" ) == self.Owner ) then return end

  self:SetNextPrimaryFire( CurTime() + .25 )

  if ( CLIENT ) then return end

  local current_health, max_health = self.Owner:Health(), self.Owner:GetMaxHealth()

  if ( current_health >= max_health ) then

    BREACH.Players:ChatPrint( self.Owner, true, true, "Вы не нуждаетесь в лечении." )

  else

    self:Heal()

  end

end

local maxs = Vector( 8, 2, 18 )

function SWEP:SecondaryAttack()

  if ( self:GetNWEntity( "NTF1Entity" ) == self.Owner ) then return end

  self:SetNextSecondaryFire( CurTime() + .25 )

  if ( CLIENT ) then return end

  local trace = {}
  trace.start = self.Owner:GetShootPos()
  trace.endpos = trace.start + self.Owner:GetAimVector() * 80
  trace.mask = MASK_SHOT
  trace.filter = { self, self.Owner }
  trace.maxs = maxs
  trace.mins = -maxs

  trace = util.TraceHull( trace )

  local target = trace.Entity

  if ( target:IsPlayer() && !( target:GTeam() == TEAM_SCP || target:GTeam() == TEAM_SPEC ) ) then

    self:Heal( target )

  end

end

function SWEP:Holster()

  if ( !self.HolsterDelay ) then

    self.HolsterDelay = CurTime() + 1
    self.IdleDelay = CurTime() + 3

    self:PlaySequence( "deploy_off" )
    self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )

  end

  if ( ( self.HolsterDelay || 0 ) < CurTime() ) then return true end

end

function SWEP:Think()

  if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

    self.IdlePlaying = true
    self:PlaySequence( "idle", true )

  end

  if ( SERVER ) then

    if ( self.Heal_Left <= 0 ) then

      self.Owner:SetActiveWeapon( self.Owner:GetWeapon( "v92_eq_unarmed" ) )
      self:Remove()

    end

  end

end

function SWEP:PreDrawViewModel( vm, wep, ply )

  if ( vm:GetSkin() != self.Skin ) then

    vm:SetSkin( self.Skin )

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

    local wm = self:CreateWorldModel()

    local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
    if ( !bone ) then return end

    local pos, ang = self.Owner:GetBonePosition( bone )

    if ( wm && wm:IsValid() ) then

      ang:RotateAroundAxis( ang:Right(), self.Ang.p )
      ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
      ang:RotateAroundAxis( ang:Up(), self.Ang.r )

      wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
      wm:SetRenderAngles( ang )

      if ( wm:GetSkin() != self.Skin ) then

        wm:SetSkin( self.Skin )

      end

      wm:DrawModel()

    end

  else

    if ( self:GetSkin() != self.Skin ) then

      self:SetSkin( self.Skin )

    end
    self:DrawModel()

  end

end
