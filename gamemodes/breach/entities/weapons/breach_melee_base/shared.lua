AddCSLuaFile()

SWEP.ViewModel = "models/weapons/breach_melee/v_fireaxe.mdl"
SWEP.WorldModel = "models/weapons/breach_melee/w_fireaxe.mdl"
SWEP.DrawWorldModel = true

SWEP.UseHands = true
SWEP.ShowWorldModel = true
SWEP.HoldType = "melee"
SWEP.Multiplier = 1

SWEP.Spawnable = true
SWEP.ViewModelFlip = false
SWEP.ImpactDecal = "ManhackCut"
SWEP.ButtonDecal = "Light"

SWEP.PrimaryAttackImpactTime = 0.05
SWEP.PrimaryAttackDamageWindow = 0.1
SWEP.PrimaryDamage = 45
SWEP.SecondaryDamage = 80

SWEP.PrimaryStamina = 15
SWEP.SecondaryStamina = 15
SWEP.DamageForce = 2


SWEP.PrimaryAttackDelay = 2
SWEP.PrimaryAttackRange = 50

SWEP.attackRange = 2
SWEP.PushVelocity = 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Called = false

SWEP.SecondaryAttackDelay = .8
SWEP.Secondary.Ammo = "none"

SWEP.Animations = {}


SWEP.PrimaryHitAABB = {

  Vector( -10, -5, -5 ),
  Vector( -10, 5, 5 )

}

SWEP.SecondaryAttackAABB = {

  Vector( -10, -5, -5 ),
  Vector( -10, 5, 5 )

}

SWEP.Holster = Sound( "weapons/cwc_cbar/drawn.wav" )

function SWEP:isBackstab( ent )

  local ourEye = self.Owner:EyeAngles()
  ourEye.p = 0
  ourEye = ourEye:Forward()

  local ang = ent:EyeAngles()
  ang.p = 0
  ang = ang:Forward()

  return ang:DotProduct( ourEye ) >= .7

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )
  self:SendWeaponAnim( ACT_VM_DRAW )

end

function SWEP:SendWeaponAnimTwo( anim, speed, cycle )

  if ( !anim ) then return end

  speed = speed || 1
  cycle = cycle || 0

  if ( self.animCallbacks && self.animCallbacks[anim] ) then

    self.animCallbacks[anim](self)

  end


  self:playAnimation( anim, speed, cycle )

end

function SWEP:playAnimation( anim, speed, cycle, ent )

  ent = ent || self.Owner:GetViewModel()
  cycle = cycle || 0
  speed = speed || 0

  local foundAnim = anim

  if ( ent:IsValid() ) then

    foundAnim = self.Animations[anim]

    if ( !foundAnim ) then return end

    if ( istable( foundAnim ) ) then

      foundAnim = table.Random( foundAnim )

    end

  end

  if ( SERVER ) then return end

  if ( ent:IsValid() ) then

    ent:ResetSequence( foundAnim )

    if ( cycle > 0 ) then

      ent:SetCycle( cycle )

    else

      ent:SetCycle( 0 )

    end

  end


  if ( ent:IsValid() ) then

    ent:SetPlaybackRate( speed )

  end

end


function SWEP:CreateBloodEffectPl( ent, trace )

  local effectData = EffectData()

  effectData:SetOrigin( trace.HitPos )
  effectData:SetEntity( ent )

  util.Effect( "BloodImpact", effectData )

end

local traceData = { }
local bullet = { }
bullet.Damage = 0
bullet.Force = 0
bullet.Tracer = 0
bullet.Num = 1
bullet.Spread = Vector( 0, 0, 0 )

local noNormal = Vector( 1, 1, 1 )

function SWEP:IndividualThink()

  if ( IsFirstTimePredicted() ) then

    local CT = CurTime()
    local vm = self.Owner:GetViewModel()

    if ( self.Attacking && self.attackDamageTime && CT > self.attackDamageTime && CT < self.attackDamageTime + self.attackDamageTimeWindow ) then

      self.Owner:LagCompensation( true )

        local eyeAngles = self.Owner:EyeAngles()
        local forward = eyeAngles:Forward()
        traceData.start = self.Owner:GetShootPos()
        traceData.endpos = traceData.start + forward * self.attackRange

        traceData.mins = self.attackAABB[1]:Rotate( eyeAngles )
        traceData.maxs = self.attackAABB[2]:Rotate( eyeAngles )

        traceData.filter = self.Owner

        local trace = util.TraceHull( traceData )

      self.Owner:LagCompensation( false )

      self:EmitSound( "weapons/cwc_cbar/swingn" .. math.random( 1, 4 ) .. ".wav" )

      if ( trace.Hit ) then

        local effectData = EffectData()

          effectData:SetDamageType( DMG_SLASH )
          effectData:SetEntity( trace.Entity )
          effectData:SetHitBox( -1 )
          effectData:SetMagnitude( 4 )
          effectData:SetNormal( trace.HitNormal )
          effectData:SetOrigin( trace.HitPos )
          effectData:SetScale( 4 )
          effectData:SetStart( trace.HitNormal )
          effectData:SetSurfaceProp( trace.SurfaceProps )
          effectData:SetFlags( 3 )

        util.Effect( "melee_effects", effectData )

        local ent = trace.Entity

        if ( ent && ent:IsValid() ) then

          if ( ent:IsPlayer() ) then

            self:EmitSound( "weapons/cwc_cbar/nhit" .. math.random( 1, 8 ) .. ".wav", 110, 100, 1, CHAN_WEAPON )
            self:CreateBloodEffectPl( ent, trace )

          elseif ( ent:IsNPC() ) then

            self:EmitSound( "weapons/cwc_cbar/nhit" .. math.random( 1, 8 ) .. ".wav", 110, 100, 1, CHAN_WEAPON )
            self:CreateBloodEffectPl( ent, trace )

          elseif ( ent:GetClass() == "func_button" ) then

            ChangeSkinKeypad( self.Owner, ent, false )
            --ent:EmitSound( "KeycardUse1.ogg" )
            local MuzzleEffect = EffectData() -- AirboatMuzzleFlash
            MuzzleEffect:SetStart( ent:GetPos() )
            MuzzleEffect:SetOrigin( ent:GetPos() )
            MuzzleEffect:SetScale( math.Rand( 0, 1 ) )
            MuzzleEffect:SetMagnitude( math.Rand( 10, 15 ) )

            util.Effect( "HelicopterMegaBomb", MuzzleEffect )

            ent:EmitSound( "ambient/energy/spark"..math.random( 1, 5 )..".wav" )
            util.Decal( self.ButtonDecal, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal )

          else

            if ( ent:GetClass() == "prop_ragdoll" ) then

              self:EmitSound( "weapons/cwc_cbar/nhit" .. math.random( 1, 8 ) .. ".wav", 110, 100, 1, CHAN_WEAPON )
              self:CreateBloodEffectPl( ent, trace )

            end

            if ( SERVER ) then

              local phys = ent:GetPhysicsObject()

              if ( phys && phys:IsValid() ) then

                phys:AddVelocity( forward * self.PushVelocity )

              end

            end

          end

          if ( SERVER ) then

            local forceDir = noNormal
            local forceMultiplier = 0

            if ( !ent:IsPlayer() && !ent:IsNPC() ) then

              forceDir = trace.HitNormal

            end

            local dmg

            if ( self:isBackstab( ent ) ) then

              if IsValid(ent) and ent:IsPlayer() then self.Owner:CompleteAchievement("backstab") end

              dmg = self.PrimaryDamage * math.random( 3, 4 )

            else

              dmg = self.PrimaryDamage * math.Rand( 1, 1.7 )

            end


            local damageInfo = DamageInfo()
            damageInfo:SetDamage( dmg )
            damageInfo:SetAttacker( self.Owner )
            damageInfo:SetDamageType( DMG_SLASH )
            damageInfo:SetInflictor( self )
            damageInfo:SetDamageForce( forward * self.DamageForce * forceDir )
            damageInfo:SetDamagePosition( trace.HitPos )

            if ent.DamageModifier then
              damageInfo:ScaleDamage(ent.DamageModifier)
            end

            if ent:IsPlayer() and ent:GTeam() == TEAM_SCP and ent:GetRoleName() == SCP096 then
              if !table.HasValue(ent:GetActiveWeapon().victims, self.Owner) and self.Owner:GTeam() != TEAM_DZ then
                table.insert( ent:GetActiveWeapon().victims, self.Owner )

                net.Start( "GetVictimsTable" )

                  net.WriteTable( ent:GetActiveWeapon().victims )

                net.Send( ent )

                if !ent:GetActiveWeapon().IsInRage and !ent:GetActiveWeapon().IsCrying then
                  ent:GetActiveWeapon():StartWatching()
                end
              end
            end

            ent:TakeDamageInfo( damageInfo )

          end

        else

          self:EmitSound( "weapons/cwc_cbar/wallheavy" .. math.random( 1, 3 ) .. ".wav" )

          if ( CLIENT ) then

            util.Decal( self.ImpactDecal, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal )

          end

        end

        self.Attacking = false

      end

    end

  end

end


function SWEP:beginAttack( timeToImpact, damageWindow, damage, range, aabb )

  self.attackDamageTime = CurTime() + timeToImpact
  self.attackDamageTimeWindow = damageWindow
  self.attackDamage = damage
  self.attackRange = range
  self.attackAABB = aabb

  if ( self.Owner && self.Owner:IsValid() ) then

    self.Owner:MeleeViewPunch( ( self.PrimaryDamage || 1 ) * .25 )

  end

end

function SWEP:Deploy()

  self:SendWeaponAnim( ACT_VM_DRAW )
  self:EmitSound( self.Holster )

end

function SWEP:PrimaryAttack()

  if ( ( self.ReloadWait || 0 ) >= CurTime() ) then return end

  if ( IsFirstTimePredicted() ) then

    timer.Simple( .1, function() self:beginAttack( self.PrimaryAttackImpactTime, self.PrimaryAttackDamageWindow, self.PrimaryAttackDamage, self.PrimaryAttackRange, self.PrimaryHitAABB ) end )
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self:SetCycle( 0 )
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

  end

  local time = CurTime() + self.PrimaryAttackDelay
  self:SetNextPrimaryFire( time )
  self:SetNextSecondaryFire( time )
  if CLIENT then

    UpdateStamina_Breach(self.Owner.Stamina - self.PrimaryStamina)

  end

  self.ReloadWait = time
  self.Attacking = true

  timer.Simple( 0.8, function() self:SendWeaponAnim( ACT_VM_IDLE ) end)

end

function SWEP:SecondaryAttack()

  if ( ( self.ReloadWait || 0 ) >= CurTime() ) then return end

  if ( IsFirstTimePredicted() ) then

    timer.Simple( .1, function() self:beginAttack( self.PrimaryAttackImpactTime, self.PrimaryAttackDamageWindow, self.SecondaryDamage, self.PrimaryAttackRange, self.PrimaryHitAABB ) end )
    self:SendWeaponAnim( ACT_VM_SWINGHARD )
    self:SetCycle( 0 )
    self.SecondaryAttack = true
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

  end

  local time = CurTime() + self.PrimaryAttackDelay
  self:SetNextPrimaryFire( time )
  self:SetNextSecondaryFire( time )

  if CLIENT then

    UpdateStamina_Breach(self.Owner.Stamina - self.SecondaryStamina)

  end

  self.ReloadWait = time
  self.Attacking = true

end

function SWEP:Think()

  if ( self.IndividualThink ) then

    self:IndividualThink()

    if ( !IsValid( self ) || !IsValid( self.Owner ) ) then return end

  end

end
