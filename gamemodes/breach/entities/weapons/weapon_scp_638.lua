SWEP.AbilityIcons = {

  {

    ["Name"] = "Bite",
    ["Description"] = "Take a bite out of your opponent.",
    ["Cooldown"] = "3",
    ["CooldownTime"] = 0,
    ["KEY"] = "LMB",
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/638/638_fear_scream.png",
    ["Abillity"] = nil

  },
  {

    ["Name"] = "Targeted Scream",
    ["Description"] = "Scream at your target from medium distances.",
    ["Cooldown"] = "25",
    ["CooldownTime"] = 0,
    ["KEY"] = "RMB",
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/638/638_targeted_scream.png",
    ["Abillity"] = nil

  },
  {

    ["Name"] = "Fear Scream",
    ["Description"] = "Scream and damage people from close distance.",
    ["Cooldown"] = "35",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_F"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/638/638_cone_damage.png",
    ["Abillity"] = nil

  },--[[
  {

    ["Name"] = "Slow Scream",
    ["Description"] = "Scream to make people from close distance slower.",
    ["Cooldown"] = "40",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_G"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/638/638_slow_scream.png",
    ["Abillity"] = nil

  },--]]
  {

    ["Name"] = "∞ Decibels",
    ["Description"] = "Make the most loudest scream and slowly damage everybody.",
    ["Cooldown"] = "60",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_C"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/638/638_aoe_scream.png",
    ["Abillity"] = nil

  },

}

SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-638"
SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.HoldType = "scp638"

SWEP.Base = "breach_scp_base"

local prim_maxs = Vector( 12, 2, 32 )

local clr_red = Color( 140, 0, 0, 210 )

function SWEP:PrimaryAttack()

  self:SetNextPrimaryFire( CurTime() + 3 )

  self.AbilityIcons[1].CooldownTime = self:GetNextPrimaryFire()

  self.Owner:LagCompensation( true )

  local trace = {}
  trace.start = self.Owner:GetShootPos()
  trace.endpos = trace.start + self.Owner:GetAimVector() * 80
  trace.filter = self.Owner
  trace.mins = -prim_maxs
  trace.maxs = prim_maxs

  trace = util.TraceHull( trace )

  local target = trace.Entity

  if ( CLIENT ) then

    if ( target && target:IsValid() && target:IsPlayer() && target:GTeam() != TEAM_SCP ) then

      local effectData = EffectData()
      effectData:SetOrigin( trace.HitPos )
      effectData:SetEntity( target )

      util.Effect( "BloodImpact", effectData )

    end

    return
  end

  if ( target && target:IsValid() && target:IsPlayer() && target:Health() > 0 && target:GTeam() != TEAM_SCP ) then

    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    self.dmginfo = DamageInfo()
    self.dmginfo:SetDamageType( DMG_SLASH )
    self.dmginfo:SetDamage( math.random(70,80) )
    self.dmginfo:SetDamageForce( target:GetAimVector() * 25 )
    self.dmginfo:SetInflictor( self )
    self.dmginfo:SetAttacker( self.Owner )

    self.Owner:EmitSound( "npc/antlion/shell_impact4.wav" )
   -- self.Owner:MeleeViewPunch( self.dmginfo:GetDamage() - 15 )
    self.Owner:ViewPunch(Angle(18, 0, 0))

    target:MeleeViewPunch( self.dmginfo:GetDamage() )
    target:TakeDamageInfo( self.dmginfo )

  else

    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Owner:EmitSound( "npc/zombie/claw_miss"..math.random( 1, 2 )..".wav" )
    self.Owner:ViewPunch(Angle(-5, 0, 0))
    timer.Simple(.1, function()
      self.Owner:ViewPunch(Angle(15, 0, 0))
    end)

  end

  self.Owner:LagCompensation( false )

end

function SWEP:SecondaryAttack()
  self.AbilityIcons[ 2 ].CooldownTime = CurTime() + tonumber(self.AbilityIcons[ 2 ].Cooldown)
  self:SetNextSecondaryFire( self.AbilityIcons[ 2 ].CooldownTime)

  if SERVER then

    --self.Owner:EmitSound(string soundName, number soundLevel = 75, number pitchPercent = 100, number volume = 1, number channel = CHAN_AUTO, CHAN_WEAPON for weapons, number soundFlags = 0, number dsp = 0)
    self.Owner:EmitSound("nextoren/scp/638/targeted_scream.ogg", 125, math.random(90,110), 1, CHAN_VOICE)

    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + self.Owner:GetAimVector() * 323
    trace.filter = self.Owner
    trace.mins = -Vector( 12, 4, 32 )
    trace.maxs = Vector( 12, 4, 32 )
    trace = util.TraceHull( trace )

    local users = ents.FindInSphere(self.Owner:GetPos(), 450)

    for _, tr in pairs(users) do
      if IsValid(tr) and tr:IsPlayer() then
        if tr:GTeam() != TEAM_SCP and tr:GTeam() != TEAM_SPEC then
          tr:SetNWInt( "Custom_Sensitivity", .2 )

              tr:ScreenFade( SCREENFADE.OUT, clr_gray, .2, 8 )
              tr:ScreenFade( SCREENFADE.IN, ColorAlpha( color_white, 40 ), 1.9, .2 )
              tr:ScreenFade( SCREENFADE.OUT, ColorAlpha( color_white, 30 ), 2.1, 2 )

              net.Start( "ForcePlaySound" )

                net.WriteString( "nextoren/others/player_breathing_knockout01.wav" )

              net.Send( tr )

              tr:SetDSP( 15, true )

              timer.Simple( 4, function()

                if ( tr && tr:IsValid() ) then

                  tr:SetDSP( 0, true )

                end

              end )

              timer.Simple( 5, function()

                if ( tr && tr:IsValid() ) then

                  tr:SetNWInt( "Custom_Sensitivity", -1 )

                end

              end )
          timer.Create("638_damage_"..tr:UniqueID(), 0.5, 4, function()
            tr:TakeDamage(15, self.Owner, self.Owner:GetActiveWeapon())
            local savename = tr:GetNamesurvivor()
            tr:SetRunSpeed(tr:GetRunSpeed() - 30)
            tr:SetWalkSpeed(tr:GetWalkSpeed() - 30)
            timer.Simple(4.5, function()
              if tr:GetNamesurvivor() == savename then
                tr:SetRunSpeed(tr:GetRunSpeed() + 30)
                tr:SetWalkSpeed(tr:GetWalkSpeed() + 30)
              end
            end)
          end)
        end
      end
    end
  end

end

function SWEP:CanSeePlayer( v )

  return self.UsingSpecialAbility && v:Health() <= v:GetMaxHealth() * .5 || v:GetVelocity():Length2DSqr() > .25 || v:GetStamina() < 20 || v:KeyDown( IN_ATTACK ) || v:IsSpeaking() || v:IsTyping()

end

function SWEP:Deploy()

  --if SERVER then
    hook.Add( "PlayerButtonDown", "SCP638_Buttons", function( caller, button )

      if ( caller:GetRoleName() != "SCP638" ) then return end

      local wep = caller:GetActiveWeapon()

      if ( wep == NULL || !wep.AbilityIcons ) then return end

      if ( button == KEY_F && !( ( wep.AbilityIcons[ 3 ].CooldownTime || 0 ) > CurTime() ) ) then

        wep.AbilityIcons[ 3 ].CooldownTime = CurTime() + wep.AbilityIcons[ 3 ].Cooldown

        for i = 1, #wep.AbilityIcons do
          if wep.AbilityIcons[i].CooldownTime < CurTime() or i < 3 then
            wep.AbilityIcons[i].CooldownTime = CurTime() + 15
          end
        end

        if SERVER then
          self:SetNextPrimaryFire(CurTime() + 15)
          self:SetNextSecondaryFire(CurTime() + 15)
          net.Start("ThirdPersonCutscene")
          net.WriteUInt(12, 4)
          net.WriteBool(false)
          net.Send(caller)
          local saverun = caller:GetRunSpeed()
          local savewalk = caller:GetWalkSpeed()
          caller:SetRunSpeed(200)
          caller:SetWalkSpeed(caller:GetRunSpeed())
          caller:EmitSound("nextoren/scp/638/high_decibel_scream.ogg", 125, 150, 1.25, CHAN_VOICE)
          timer.Create("SCP_638_RUN_ATTACK", 0.5, 11, function()
            if caller:GetRoleName() != "SCP638" then timer.Remove("SCP_638_RUN_ATTACK") return end

            local plys = ents.FindInSphere(caller:GetPos(), 320)

            for i = 1, #plys do

              local ply = plys[i]

              if IsValid(ply) and ply:IsPlayer() then

                if ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_SPEC then

                  ply:TakeDamage(10, caller, caller:GetActiveWeapon())

                end

              end

            end
          end)
          timer.Simple(12, function()
            if IsValid(caller) and caller:GetRoleName() == "SCP638" then
              caller:SetRunSpeed(saverun)
              caller:SetWalkSpeed(savewalk)
            end
          end)
        end
      elseif ( button == KEY_C && !( ( wep.AbilityIcons[ 4 ].CooldownTime || 0 ) > CurTime() ) ) then

        wep.AbilityIcons[ 4 ].CooldownTime = CurTime() + wep.AbilityIcons[ 4 ].Cooldown

        for i = 1, #wep.AbilityIcons do
          if wep.AbilityIcons[i].CooldownTime < CurTime() or i < 3 then
            wep.AbilityIcons[i].CooldownTime = CurTime() + 17
          end
        end

        if SERVER then

          self:SetNextPrimaryFire(CurTime() + 17)
          self:SetNextSecondaryFire(CurTime() + 17)
          net.Start("ThirdPersonCutscene")
          net.WriteUInt(8, 4)
          net.WriteBool(false)
          net.Send(caller)
          caller:SetMoveType(MOVETYPE_OBSERVER)
          caller:SetNWAngle("ViewAngles", caller:GetAngles())
          caller:EmitSound("nextoren/scp/638/high_decibel_scream.ogg", 1255, math.random(90,110), 1.25, CHAN_VOICE)

          timer.Create("SCREAMER_DODAMAGE_"..caller:SteamID64(), 1, 8, function()

            if caller:GetRoleName() != "SCP638" then timer.Remove("SCREAMER_DODAMAGE_"..caller:SteamID64()) return end

            local plys = ents.FindInSphere(caller:GetPos(), 320)

            for i = 1, #plys do

              local ply = plys[i]

              if IsValid(ply) and ply:IsPlayer() then

                if ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_SPEC then

                  ply:TakeDamage(25, caller, caller:GetActiveWeapon())

                end

              end

            end

          end)

          caller:SetForcedAnimation("BoomerVar_squat", caller:SequenceDuration(caller:LookupSequence("BoomerVar_squat")), nil, function()
            caller:SetForcedAnimation("Crouch_idle_upper_knife", 6.5, nil, function()
              caller:SetNWAngle("ViewAngles", Angle(0,0,0))
              caller:SetMoveType(MOVETYPE_WALK)
            end)
          end)

        end

      end

    end)
  --end

  self.Owner:DrawViewModel( false )

  if ( SERVER ) then

    self.Owner:DrawWorldModel( false )

  end

  self:SetHoldType( self.HoldType )

  if ( CLIENT ) then

    self:ChooseAbility( self.AbilityIcons )

    colour = 0

  end

end

if ( SERVER ) then
  
  function SWEP:OnRemove()


    local players = player.GetAll()

    local SCP638_exists

    for i = 1, #players do

      local player = players[ i ]

      if ( player:GetRoleName() == "SCP638" ) then

        SCP638_exists = true

        break
      end

    end

    if ( !SCP638_exists ) then

      hook.Remove( "PlayerButtonDown", "SCP638_Buttons" )

    end


    local players = player.GetAll()

    for i = 1, #players do

      local player = players[ i ]

      if ( player && player:IsValid() ) then

        --RecursiveSetPreventTransmit( player, self.Owner, false )

      end

    end

  end

else

  function SWEP:DrawHUD()

    if ( !self.Deployed ) then

      self.Deployed = true

      self:Deploy()

    end

  end

end
