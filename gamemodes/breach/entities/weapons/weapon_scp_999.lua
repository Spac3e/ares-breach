SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-542"
SWEP.Base = "breach_scp_base"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.HoldType = "scp860"
SWEP.maxs = Vector( 8, 10, 5 )

SWEP.AbilityIcons = {

  {

    [ "Name" ] = "Full-Recover",
    [ "Description" ] = "Вы полностью лечите живого человека на которого смотрите (SCP Выдается +250 хп и кд намного больше)",
    [ "Cooldown" ] = 10,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = "LMB",
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/ability_4.png",

  },

  {

    [ "Name" ] = "Global Heal",
    [ "Description" ] = "Вы лечите всех поблизости и самого себя",
    [ "Cooldown" ] = 30,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = "RMB",
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/ability_3.png",

  },

  {

    [ "Name" ] = "Slime Trap",
    [ "Description" ] = "Вы бросаете слизь в человека, из-за чего он застрявает",
    [ "Cooldown" ] = 25,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = _G["KEY_F"],
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/ability_2.png",

  },

  {

    [ "Name" ] = "Slime Blind",
    [ "Description" ] = "Вы бросаете во всех поблизости своей слизью, тем самым ослепляя их",
    [ "Cooldown" ] = 35,
    [ "CooldownTime" ] = 0,
    [ "KEY" ] = _G["KEY_G"],
    [ "Using" ] = false,
    [ "Icon" ] = "nextoren/gui/special_abilities/ability_1.png",

  },

}

function SWEP:Deploy()

  self:SetHoldType( self.HoldType )

  hook.Add( "PlayerButtonDown", "SCP_999_ABIL_USE", function( ply, butt )
    if ply:GetRoleName() != SCP999 then return end
    if butt == KEY_G and self.AbilityIcons[4].CooldownTime <= CurTime() then
      local plys = ents.FindInSphere(ply:GetPos(), 450)

      ply:GetActiveWeapon():Cooldown(4, 35)

      for i, v in pairs(plys) do

        if IsValid(v) and v:IsPlayer() and v != ply and v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC then

          v:ScreenFade(SCREENFADE.IN, Color(239, 114, 19), 2, 9)

        end

      end

    elseif butt == KEY_F and self.AbilityIcons[3].CooldownTime <= CurTime() then

      local tr = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 100
      })

      local v = tr.Entity

      --for i, v in pairs(plys) do

        if IsValid(v) and v:IsPlayer() and v != ply and v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v:Health() > 0 and v:Alive() then

          ply:GetActiveWeapon():Cooldown(3, 25)

          local scp_999 = ents.Create("base_gmodentity")

          scp_999:SetPos( v:GetPos() )
          scp_999:SetModel( "models/cultist/scp/scp_999_new.mdl" )
          scp_999:SetAngles( v:GetAngles() )

          scp_999:Spawn()
          scp_999:SetPlaybackRate( 0 )
          scp_999:SetCycle(1)
          scp_999:SetSequence( scp_999:LookupSequence("die") )
          scp_999.AutomaticFrameAdvance = true
          scp_999.Think = function( self )

            self:NextThink( CurTime() )

            self:SetCycle(1)

            return true
          end

          v:SetMoveType(MOVETYPE_OBSERVER)
          v:SetVelocity(Vector(0,0,0))
          v:SetLocalVelocity(Vector(0,0,0))
          timer.Simple(15, function()

            scp_999:Remove()

            v:SetMoveType(MOVETYPE_WALK)

          end)

        end

      --end

    end
  end)

end

function SWEP:PrimaryAttack()

  local tr = util.TraceLine({
    start = self.Owner:EyePos(),
    endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward()*100,
    filter = self.Owner
  })

  local ply = tr.Entity

  if !IsValid(ply) or !ply:IsPlayer() then return end

  if ply:Health() >= ply:GetMaxHealth() then if SERVER then self.Owner:AresNotify("l:scp999_healthy") end return end

  if SERVER then
    local function start()
      if self.AntiInfiniteHeal then return end
      timer.Create("SCP999_HEAL", 1, 3, function()

        if IsValid(ply) and IsValid(self.Owner) and ply:Health() > 0 and self.Owner:Health() > 0 and self.Owner:GetRoleName() == SCP999 then

          self.AntiInfiniteHeal = true

          ply:ScreenFade(SCREENFADE.IN, Color(0,255,0,155), 0.5, 0)
          self.Owner:ScreenFade(SCREENFADE.IN, Color(0,255,0,155), 0.5, 0)

          ply:AnimatedHeal(10)

        end

      end)

    end

    local function finish()
      self.AntiInfiniteHeal = nil
      if ply:GTeam() == TEAM_SCP then
        ply:AnimatedHeal(95)
        ply:ScreenFade(SCREENFADE.IN, Color(0,255,0,155), 2, 1)
        self:Cooldown(1, 40)
        self:SetNextPrimaryFire(CurTime() + 40)
        self.Owner:AddToStatistics("l:scp999_healing_bonus", 100)
        self.Owner:BrTip(1, "[SCP-999-2] ", Color(255,0,0), "+100 l:exp", color_white)
      else
        ply:AnimatedHeal(ply:GetMaxHealth() - ply:Health())
        ply:ScreenFade(SCREENFADE.IN, Color(0,255,0,155), 2, 1)
        self:Cooldown(1, self.AbilityIcons[1].Cooldown)
        self:SetNextPrimaryFire(CurTime() + self.AbilityIcons[1].Cooldown)
        self.Owner:AddToStatistics("l:scp999_healing_bonus", 45)
        self.Owner:BrTip(1, "[SCP-999-2] ", Color(255,0,0), "+45 l:exp", color_white)
      end
    end

    local function stop()
      timer.Remove("SCP999_HEAL")
    end
    local name = "l:scp999_healing "..ply:GetNamesurvivor()
    if ply:GTeam() == TEAM_SCP then
      name = "l:scp999_healing "..GetLangRole(ply:GetRoleName())
    end
    self.Owner:BrProgressBar(name, 6, self.AbilityIcons[1].Icon, ply, false, finish, start, stop)
  end

end

function SWEP:SecondaryAttack()

  self:SetNextSecondaryFire(CurTime() + self.AbilityIcons[2].Cooldown)
  self.AbilityIcons[2].CooldownTime = CurTime() + self.AbilityIcons[2].Cooldown

  local exp = 0

  local plys = ents.FindInSphere(self.Owner:GetPos(), 450)

  if SERVER then
    for i, v in pairs(plys) do

      if IsValid(v) and v:IsPlayer() and v:GTeam() != TEAM_SPEC then

        v:ScreenFade(SCREENFADE.IN, Color(0,255,0,155), 2, 1)

        if v:GTeam() == TEAM_SCP then
          v:AnimatedHeal(155)
          if v != self.Owner then exp = exp + 50 end
        else
          if v:Health() < v:GetMaxHealth() then
            v:AnimatedHeal(v:GetMaxHealth() - v:Health())
            exp = exp + 40
          end
        end

      end

    end
    if exp != 0 then
      self.Owner:BrTip(1, "[SCP-999-2] ", Color(255,0,0), "+"..tostring(exp).." l:exp", color_white)
      self.Owner:AddToStatistics("l:scp999_healing_bonus", exp)
    end
  end

end

function SWEP:Reload()

end

function SWEP:Think()

end

function SWEP:OnRemove()

  local players = player.GetAll()

  for i = 1, #players do

    local player = players[ i ]

    if ( player && player:IsValid() && player:GetRoleName() == "SCP999" ) then return end

  end

  hook.Remove( "PlayerButtonDown", "SCP_999_ABIL_USE" )

end

function SWEP:DrawHUDBackground()

  local w, h = ScrW(), ScrH()

  local tr = self.Owner:GetEyeTraceNoCursor()

  if IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:Health() > 0 then
    local health = math.floor((tr.Entity:Health()/tr.Entity:GetMaxHealth())*100)
    local col = Color(0,255,0,155)
    local col_black = Color(0,0,0,155)
    if health <= 25 then
      col = Color(Pulsate(2.1)*255,0,0,155)
      col_black.a = Pulsate(2.1)*155
    elseif health <= 55 then
      col = Color(239, 114, 19)
    end
    --draw.SimpleTextOutlined(string Text, string font = "DermaDefault", number x = 0, number y = 0, table color = Color( 255, 255, 255, 255 ), number xAlign = TEXT_ALIGN_LEFT, number yAlign = TEXT_ALIGN_TOP, number outlinewidth, table outlinecolor = Color( 255, 255, 255, 255 ))
    draw.SimpleTextOutlined("HEALTH: "..health..'%', "HUDFontMedium", w/2, h/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, col_black)
  end

end