SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-076-2"
SWEP.Base = "breach_scp_base"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.ViewModel        = "models/weapons/tfa_l4d2/c_kf2_katana.mdl"
SWEP.WorldModel       = "models/weapons/tfa_l4d2/w_kf2_katana.mdl"
SWEP.UseHands = true
SWEP.ViewModelFOV = 65

SWEP.UnDroppable = true
SWEP.droppable = false

SWEP.Pos = Vector( -17,0,-3 )
SWEP.Ang = Angle( -90,-160,-90 )

SWEP.IdlePos = Vector( -14,0,-3 )
SWEP.IdleAng = Angle( -105,-160,-115 )

SWEP.HoldType         = "katana"

SWEP.AbilityIcons = {

  {

    [ "Name" ] = "Special",
    [ "Description" ] = "Вы делаете специальную атаку которая убивает всех.",
    [ "Cooldown" ] = 100,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = _G["KEY_Q"],
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/scp_076_combo.png",
    [ "Abillity" ] = nil

  },

  {

    [ "Name" ] = "Shuriken",
    [ "Description" ] = "Вы бросаете сюрикен.",
    [ "Cooldown" ] = 50,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = "RMB",
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/scp_076_throw.png",
    [ "Abillity" ] = nil

  },

  {

    [ "Name" ] = "speed",
    [ "Description" ] = "Вы ускоряетесь и атакуете значительно быстрее в течении 15 секунд.",
    [ "Cooldown" ] = 80,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = _G["KEY_R"],
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/scp_076_stance_defend.png",
    [ "Abillity" ] = nil

  },

}

function SWEP:SetupDataTables()

  self:NetworkVar("Bool", 0, "InSeq")
  
  self:SetInSeq(false)

end

function SWEP:AnimationsChange(rage)

  if ( SERVER ) then

    net.Start( "ChangeAnimations" )

      net.WriteEntity( self.Owner )
      net.WriteBool( rage )

    net.Broadcast()

  end

  if ( rage ) then

    self.Owner.SafeModelWalk = self.Owner:LookupSequence( "wos_phalanx_r_run" )
    self.Owner.SafeRun = self.Owner:LookupSequence( "wos_phalanx_r_run" )

  else

    self.Owner.SafeModelWalk = self.Owner:LookupSequence( "s_run" )
    self.Owner.SafeRun = self.Owner:LookupSequence( "s_run" )

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

  local pl = self:GetOwner()

  if ( pl && pl:IsValid() ) and !self:GetInSeq() then

    local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
    if ( !bone ) then return end

    local wm = self:CreateWorldModel()
    local pos, ang = self.Owner:GetBonePosition( bone )

    if ( wm && wm:IsValid() ) then

      local use_ang = self.Ang
      local use_pos = self.Pos

      if self.Owner:GetVelocity():Length2DSqr() <= .25 then

        use_ang = self.IdleAng
        use_pos = self.IdlePos

      end

      ang:RotateAroundAxis( ang:Right(), use_ang.p )
      ang:RotateAroundAxis( ang:Forward(), use_ang.y )
      ang:RotateAroundAxis( ang:Up(), use_ang.r )

      wm:SetRenderOrigin( pos + ang:Right() * use_pos.x + ang:Forward() * use_pos.y + ang:Up() * use_pos.z )
      wm:SetRenderAngles( ang )
      wm:DrawModel()

    end

  else

    self:SetRenderOrigin( nil )
    self:SetRenderAngles( nil )
    self:DrawModel()

  end

end

local sequence = "wos_judge_h_left_t3"

function SWEP:Deploy()

  self:SetHoldType( self.HoldType )

  if ( SERVER ) then

    self.Owner.forward_076 = false

    hook.Add( "SetupMove", "SCP_076_move_forward", function(ply, mv, cu)
      if ply.forward_076 and ply:GetRoleName() == SCP076 then
        mv:SetForwardSpeed(115)
        mv:SetSideSpeed(0)
        mv:SetUpSpeed(0)
      end
    end)

    hook.Add( "PlayerButtonDown", "SCP_076_abil", function( ply, butt )

      if ( butt == KEY_Q ) then

        if ( ply:GetRoleName() == "SCP076" ) then

          if self.AbilityIcons[1].CooldownTime <= CurTime() then

            self:Cooldown(1, self.AbilityIcons[1].Cooldown)

            if self.AbilityIcons[2].CooldownTime < CurTime() + 3 then

              self:Cooldown(2, 3)

            end

            ply.forward_076 = true

            self:SetInSeq(true)

            self.noattack = true

            ply:SetForcedAnimation(sequence, ply:SequenceDuration(ply:LookupSequence(sequence)), nil, function()
              self.killmode = false
              ply:SetRunSpeed(ply.rememberspeed)
              ply:SetWalkSpeed(ply.rememberspeed)
              ply:SetNoCollideWithTeammates(false)
              self.noattack = false
            end)

            net.Start("ThirdPersonCutscene2")
              net.WriteUInt(2, 4)
              net.WriteBool(false)
            net.Send(ply)

            timer.Create("slash_076_"..ply:SteamID64(), 1.1, 1, function()
              ply.forward_076 = false
              local pos = ply:GetPos()
              local ang = ply:GetAngles()
             -- ang.r = 0
              local endpos = ply:EyePos() + ang:Forward() * 150
              endpos.z = ply:GetPos().z
              local trace = util.TraceLine({
                filter = player.GetAll(),
                start = ply:GetPos(),
                endpos = endpos
              })
              self.killmode = true
              ply.rememberspeed = ply:GetRunSpeed()
              ply:SetRunSpeed(0)
              ply:SetWalkSpeed(0)
              ply:SetNoCollideWithTeammates(true)
              ply:SetVelocity(ang:Forward()*3000)
            end)

          end


        end

      end

    end )

  end

  if ( !IsFirstTimePredicted() ) then

    return

  else

    self.ShouldDraw = nil
    self.HolsterDelay = nil

  end

  if ( !self.OldWeapon || self.Old_Weapon && self.OldWeapon != self.Owner.Old_Weapon:GetClass() ) then

    if ( self.Owner.Old_Weapon && self.Owner.Old_Weapon:IsValid() && self.Owner:HasWeapon( self.Owner.Old_Weapon:GetClass() ) ) then

      self.OldWeapon = self.Owner.Old_Weapon:GetClass()

    end

  end

  self.IdleDelay = CurTime() + 1.46
  self:PlaySequence( "deploy" )

 -- self:EmitSound( "weapons/universal/uni_weapon_draw_02.wav", 75, 80, 1, CHAN_WEAPON )
  timer.Simple(0.55, function() self:EmitSound("weapons/l4d2_kf2_katana/knife_deploy.wav", 75, 80, 1, CHAN_WEAPON ) end)

  timer.Simple( 0, function()

    if ( self && self:IsValid() ) then

      self.ShouldDraw = true

    end

  end )

end

local gestures = {
  "l4d_katana_swing_w2e_layer",
  "wos_phalanx_h_s1_t2",
  "wos_phalanx_b_s2_t2"
}

local cycles = {
  ["wos_phalanx_h_s1_t2"] = 0.3,
}

local maxs = Vector(16,16,72)
local mins = Vector(-16,-16,0)

function SWEP:PrimaryAttack()

  if self.Owner.ForceAnimSequence then return end

  if !IsFirstTimePredicted() then return end

  if SERVER then
    if self.fasterattack then
      self:SetNextPrimaryFire(CurTime() + 0.25)
    else
      self:SetNextPrimaryFire(CurTime() + 0.6)
    end
  end

  self.Owner:LagCompensation(true)
  local trace = util.TraceHull({
    start = self.Owner:GetShootPos(),
    endpos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward()*75,
    filter = self.Owner,
    ignoreworld = true,
    mask = MASK_SHOT_HULL,
    mins = mins,
    maxs = maxs
  })
  self.Owner:LagCompensation(false)
  local target = trace.Entity

 -- if SERVER then

    if ( target && target:IsValid() && target:IsPlayer() && target:GTeam() != TEAM_SCP ) then

      if SERVER then

        local dmg = DamageInfo()

        dmg:SetDamage(target:GetMaxHealth()*.35)

        dmg:SetDamageType(DMG_SLASH)
        dmg:SetInflictor(self)
        dmg:SetAttacker(self.Owner)
        dmg:SetDamageForce(200 * self.Owner:GetAimVector())

        target:TakeDamageInfo(dmg)

      else

        local effectData = EffectData()
        effectData:SetOrigin( trace.HitPos )
        effectData:SetEntity( target )
        util.Effect( "BloodImpact", effectData )

      end

    end
  --end

  local sequence = math.random(2, 5)
  self.IdlePlaying = false
  self.IdleDelay = CurTime() + 1
  if SERVER then self:PlaySequence( sequence ) end

  if SERVER then
    if self.Owner:GetEyeTrace().Hit and (!IsValid(trace.Entity) or !trace.Entity:IsPlayer()) and self.Owner:GetEyeTrace().HitPos:DistToSqr(self.Owner:GetShootPos()) < 9300 then
      self.Owner:EmitSound("weapons/l4d2_kf2_katana/katana_impact_world"..math.random(1,2)..".wav")
    elseif IsValid(target) and target:IsPlayer() and target:GTeam() != TEAM_SCP then
      self.Owner:EmitSound("weapons/l4d2_kf2_katana/melee_katana_0"..math.random(1,3)..".wav")
    else
      self.Owner:EmitSound("weapons/l4d2_kf2_katana/katana_swing_miss"..math.random(1,2)..".wav")
    end
  end

  if SERVER then
    local cycle = 0
    local gesture = gestures[math.random(1,#gestures)]
    if cycles[gesture] then cycle = cycles[gesture] end
    self.Owner:PlayGestureSequence(self.Owner:LookupSequence(gesture), GESTURE_SLOT_ATTACK_AND_RELOAD, nil, cycle)
  end

end

function SWEP:SecondaryAttack()

  if self.Owner.ForceAnimSequence then return end

  self:SetNextSecondaryFire(CurTime() + self.AbilityIcons[2].Cooldown)
  self.AbilityIcons[2].CooldownTime = CurTime() + self.AbilityIcons[2].Cooldown

  if SERVER then
    self:SetNoDraw(true)
    self.Owner:PlayGestureSequence(self.Owner:LookupSequence("wos_phalanx_unsheathe_hip"), GESTURE_SLOT_CUSTOM)
   -- self.Owner:SetNWEntity("NTF1Entity", self.Owner)
    timer.Create("throw", 0.6, 1, function()
      local current_angles = self.Owner:GetAngles()
      local projectile = ents.Create( "ent_scp_shuriken" )
      projectile:SetOwner( self.Owner )
      projectile:SetPos( self.Owner:GetShootPos() + current_angles:Forward() * 48 )
      projectile:SetAngles( current_angles )
      projectile:SetVelocity( self.Owner:GetAimVector() * 2100 )
      projectile:SetGravity( .05 )
      projectile:Spawn()
      local phy = projectile:GetPhysicsObject()
      if IsValid(phy) then
        phy:SetVelocity(self.Owner:EyeAngles():Forward()*100)
      end
      timer.Simple(0.7, function()
        self:SetNoDraw(false)
        --self.Owner:SetNWEntity("NTF1Entity", NULL)
      end)
    end)
  end

end

function SWEP:Reload()
  if self.Owner.ForceAnimSequence then return end
  if self.AbilityIcons[3].CooldownTime > CurTime() then return end
    self.AbilityIcons[3].CooldownTime = CurTime() + self.AbilityIcons[3].Cooldown
    if self.AbilityIcons[2].CooldownTime < CurTime() + 15 then
      self.AbilityIcons[2].CooldownTime = CurTime() + 15
      self:SetNextSecondaryFire(CurTime() + 15)
    end
    if self.AbilityIcons[1].CooldownTime < CurTime() + 15 then
      self.AbilityIcons[1].CooldownTime = CurTime() + 15
    end
    self:AnimationsChange(true)
    self.Owner.rememberspeed = self.Owner:GetWalkSpeed()
    self.Owner:SetWalkSpeed(self.Owner.rememberspeed + 100)
    self.Owner:SetRunSpeed(self.Owner:GetWalkSpeed())
    local savedmodifier = self.Owner.DamageModifier
    if SERVER then
      self.Owner.DamageModifier = math.Max(savedmodifier - 0.3, 0.1)
    end
    self.fasterattack = true
    if SERVER then
      net.Start("ThirdPersonCutscene2")
        net.WriteUInt(9, 4)
        net.WriteBool(false)
      net.Send(self.Owner)
    end
    timer.Simple(9, function()
      self.fasterattack = false
      self.Owner.DamageModifier = savedmodifier
      self.Owner:SetWalkSpeed(self.Owner.rememberspeed)
      self.Owner:SetRunSpeed(self.Owner:GetWalkSpeed())
      self:AnimationsChange(false)
    end)
end

function SWEP:GetPrimaryAmmoType()
  return SHOTGUN_AMMO
end

function SWEP:Think()

  if SERVER then

    if self.killmode and self.Owner:Health() > 0 and self.Owner:Alive() then
      local Ents = ents.FindInSphere(self.Owner:GetPos(), 100)

      for _, ply in ipairs(Ents) do
        if ply and ply:IsValid() and ply:IsLineOfSightClear(self.Owner:GetPos()) and ply:IsPlayer() and ply:GTeam() != TEAM_DZ and ply:Health() > 0 and ply:Alive() and ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_SPEC then
        
          local dmginfo = DamageInfo()
          dmginfo:SetDamage(210312)
          dmginfo:SetDamageForce(Vector(0,0,0))
          dmginfo:SetInflictor(self)
          dmginfo:SetAttacker(self.Owner)
          ply.forceremovehead = true
          ply:TakeDamageInfo(dmginfo)
          sound.Play("weapons/l4d2_kf2_katana/melee_katana_0"..math.random(1,3)..".wav", ply:GetPos(), 45, 100, 100)
         -- ply:EmitSound("weapons/l4d2_kf2_katana/melee_katana_0"..math.random(1,3)..".wav")

        end
      end

    end

  end

  if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

    self.IdlePlaying = true
    self:PlaySequence( "idle", true )

  end

end


function SWEP:OnRemove()

  local players = player.GetAll()

  for i = 1, #players do

    local player = players[ i ]

    if ( player && player:IsValid() && player:GetRoleName() == "SCP0762" ) then return end

  end

  hook.Remove( "PlayerButtonDown", "SCP_076_abil" )
  hook.Remove( "SetupMove", "SCP_076_move_forward" )

end