SWEP.AbilityIcons = {

  {

    ["Name"] = "Smoke Grenade",
    ["Description"] = "Throw a smoke grenade you can see through.",
    ["Cooldown"] = "55",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_F"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/scp_912/smoke.png",
    ["Abillity"] = nil

  },

  --[[
  {

    ["Name"] = "Nerve Grenade",
    ["Description"] = "Throw a special grenade to temporarily blind other people.",
    ["Cooldown"] = "79",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_G"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/scp_912/nerve_gas.png",
    ["Abillity"] = nil

  },]]

  {

    ["Name"] = "Stealth Style",
    ["Description"] = "You taking out a special knife, your footsteps are deaf and you are faster than before",
    ["Cooldown"] = "200",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_G"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/scp_912/knife.png",
    ["Abillity"] = nil

  },

  --[[
  {

    ["Name"] = "Sprint",
    ["Description"] = "Now you can sprint for 17 seconds.",
    ["Cooldown"] = "60",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_2"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/scp_912/sprint.png",
    ["Abillity"] = nil

  },]]

}

SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-912"
SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.HoldType = "scp638"

SWEP.Base = "breach_scp_base"

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()

end

local w = 64
local h = 64
local padding = 133

local RageIcon = Material( "nextoren/gui/special_abilities/scp912_m4a1.png", "smooth" )

local function DrawHUD()

  local client = LocalPlayer()

  if ( client:GetRoleName() != SCP912 ) then

    hook.Remove( "HUDPaint", "SCP_912_HUD" )

    return
  end

  local percent = client:GetNWInt("scp_912_kills", 0)/5--2/5
  local actualpercent = math.Round( percent * 100 )
  local percentclr = Color( 155, 155, 155, 100 )

  local y = ScrH() * .8
  local color = color_white

  render.SetMaterial( RageIcon )
  render.DrawQuadEasy( Vector( ScrW() / 2, y ),

    Vector( 0, 0, -1 ),
    w, h,
    Color( 10, 10, 40, 240 ),
    -90

  )

  render.SetScissorRect( ScrW() / 2 + 30, y + h / 2 - ( h * percent ), padding + w, ScrH(), true )
  render.SetMaterial( RageIcon )
  render.DrawQuadEasy( Vector( ScrW() / 2, y),

    Vector( 0, 0, -1 ),
    w, h,
    color,
    -90

  )
  render.SetScissorRect( 0, y + h / 2, padding + w, ScrH(), false )


  if ( actualpercent < 100 ) then

    --draw.SimpleText( actualpercent, "char_title24", ScrW() / 2, y, percentclr, 1, 1, .5, Color( 0, 0, 0, 255 ) )
    draw.SimpleText( actualpercent, "char_title24", ScrW() / 2, y, percentclr, 1, 1 )

    if ( actualpercent >= 50 ) then

      draw.SimpleText( "T", "char_title20", ScrW() / 2, y - 16, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

  else

    draw.SimpleText( "T", "char_title24", ScrW() / 2, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

  end

end

function SWEP:Initialize()
  if CLIENT then
    hook.Add("HUDPaint", "SCP_912_HUD", function()
      if LocalPlayer():GetRoleName() != SCP912 or !LocalPlayer():HasWeapon("weapon_scp_912") then 
        hook.Remove("HUDPaint", "SCP_912_HUD")
        return
      end
      self:DrawHUD()
    end)
  end
end

if SERVER then
  hook.Add( "PlayerDeath", "SCP_912_playerkillcheck", function( victim, inflictor, attacker )
    if IsValid(attacker) and attacker:IsPlayer() and attacker:GetRoleName() == SCP912 and attacker:GetActiveWeapon():GetClass() == "cw_kk_scp_912_deagle" then
      attacker:SetNWInt("scp_912_kills", math.min(5, attacker:GetNWInt("scp_912_kills", 0) + 1))
    end
  end)
end

function SWEP:Deploy()

  if ( CLIENT ) then
    hook.Add( "HUDPaint", "SCP_912_HUD", DrawHUD )
  end

  self.Owner:SetNWInt("scp_912_kills", 0)

  if SERVER then
    local deploycd = SysTime() + 1
    hook.Add( "PlayerButtonDown", "SCP912_Buttons", function( caller, button )

      if ( caller:GetRoleName() != "SCP912" ) then return end

      local wep = caller:GetWeapon("weapon_scp_912")

      if ( wep == NULL || !wep.AbilityIcons ) then return end

      --if !wep.haspicked and button != MOUSE_LEFT and button != MOUSE_RIGHT and deploycd <= SysTime() then
        --caller:SelectWeapon("cw_kk_scp_912_deagle")
        --wep.haspicked = true
      --end

      --[[
      if button == KEY_2 and wep.AbilityIcons[3].CooldownTime <= CurTime() then

        self:Cooldown(3, tonumber(wep.AbilityIcons[3].Cooldown))

        if self.AbilityIcons[1].CooldownTime <= CurTime() + 15 then
          self:Cooldown(1, 20)
        end
        if self.AbilityIcons[2].CooldownTime <= CurTime() + 15 then
          self:Cooldown(2, 20)
        end

        caller:BrProgressBar("l:sprint", 15, "nextoren/gui/special_abilities/scp_912/sprint.png", NULL, true, function()
        end)

        local saverun = caller:GetRunSpeed()
        local savewalk = caller:GetWalkSpeed()
        caller:SetRunSpeed(215)
        caller:SetWalkSpeed(215)

        timer.Simple(15, function()
          if caller:GetRoleName() == SCP912 then
            caller:SetRunSpeed(saverun)
            caller:SetWalkSpeed(savewalk)
          end
        end)

      else]]if button == KEY_G and wep.AbilityIcons[2].CooldownTime <= CurTime() and caller:GetActiveWeapon():GetClass() == "cw_kk_scp_912_deagle" then
        self:Cooldown(2, tonumber(wep.AbilityIcons[2].Cooldown))

        if self.AbilityIcons[1].CooldownTime <= CurTime() + 25 then
          self:Cooldown(1, 30)
        end

        caller:BreachGive('weapon_scp_912_knife')
        caller:GetActiveWeapon().SwitchWep = caller:GetWeapon("weapon_scp_912_knife")

        local smokeScreen = ents.Create("cw_smokescreen_912")
        smokeScreen:SetPos(caller:GetPos())
        smokeScreen:Spawn()

        caller:ScreenFade(SCREENFADE.IN, Color(255,0,0, 50), 4, 1)
        local saverun = caller:GetRunSpeed()
        local savewalk = caller:GetWalkSpeed()
        caller:SetRunSpeed(270)
        caller:SetWalkSpeed(270)

        caller:BrProgressBar("l:ragemode", 10, "nextoren/gui/special_abilities/scp_912/knife.png", NULL, true, function()
        end)

        timer.Simple(10, function()
          if caller:GetRoleName() == SCP912 then
            caller:SelectWeapon("cw_kk_scp_912_deagle")
            caller:SetRunSpeed(saverun)
            caller:SetWalkSpeed(savewalk)
          end
        end)
      elseif button == KEY_T and caller:GetActiveWeapon():GetClass() == "cw_kk_scp_912_deagle" and caller:GetNWInt("scp_912_kills", 0) == 5 then
        caller:SetNWInt("scp_912_kills", 0)
        --caller:StripWeapon("cw_kk_scp_912_deagle")
        caller:BreachGive("cw_kk_scp_912")
        local wep = caller:GetWeapon("cw_kk_scp_912")
        hook.Add("Think", "SCP912FIXGIVE", function()
          if !IsValid(caller) or !IsValid(wep) then hook.Remove("Think", "SCP912FIXGIVE") end
          if wep != caller:GetActiveWeapon() then
            caller:SelectWeapon("cw_kk_scp_912")
          else
            hook.Remove("Think", "SCP912FIXGIVE")
          end
        end)
        hook.Add("Think", "SCP912TAKEAWAY", function()
          if !IsValid(caller) or !IsValid(wep) then hook.Remove("Think", "SCP912FIXGIVE") end
          if wep:Clip1() == 0 and caller:GetAmmoCount("SMG1") == 0 then
            hook.Remove("Think", "SCP912TAKEAWAY")
            timer.Simple(0.5, function()
              caller:SelectWeapon("cw_kk_scp_912_deagle")
            end)
          end
        end)
        wep:SetClip1(wep:GetMaxClip1() + 1)
        caller:SetAmmo(30*2, "SMG1")
          timer.Simple(2, function()
          wep:attachSpecificAttachment("kk_ins2_suppressor_sec")
          wep:attachSpecificAttachment("kk_ins2_vertgrip") end)
      elseif button == KEY_F and wep.AbilityIcons[1].CooldownTime <= CurTime() and caller:GetActiveWeapon():GetClass() == "cw_kk_scp_912_deagle" then
        self:Cooldown(1, tonumber(wep.AbilityIcons[1].Cooldown))

        caller:PlayGestureSequence("gesture_item_throw")

        caller:BrProgressBar("l:throwing_grenade", 0.86, "nextoren/gui/special_abilities/scp_912/smoke.png", NULL, true, function()

          caller:ViewPunch(Angle(15,0,0))

          local smokecock = ents.Create("cw_smoke_912")
          smokecock:SetOwner(caller)
          smokecock:SetPos(caller:EyePos())
          smokecock.grenadetype = 1
          smokecock:Spawn()

          local phys = smokecock:GetPhysicsObject()

          if IsValid(phys) then
            phys:SetVelocity(caller:EyeAngles():Forward()*800)
            phys:SetAngleVelocity(Vector(1000,1000,0))
          end

        end)

        --[[
      elseif button == KEY_G and wep.AbilityIcons[2].CooldownTime <= CurTime() then
        self:Cooldown(2, tonumber(wep.AbilityIcons[2].Cooldown))

        caller:PlayGestureSequence("gesture_item_throw")

        caller:BrProgressBar("l:throwing_grenade", 0.86, "nextoren/gui/special_abilities/scp_912/nerve_gas.png", NULL, true, function()

          caller:ViewPunch(Angle(15,0,0))

          local smokecock = ents.Create("cw_smoke_912")
          smokecock:SetOwner(caller)
          smokecock:SetPos(caller:EyePos())
          smokecock.grenadetype = 2
          smokecock:Spawn()

          local phys = smokecock:GetPhysicsObject()

          if IsValid(phys) then
            phys:SetVelocity(caller:EyeAngles():Forward()*800)
            phys:SetAngleVelocity(Vector(1000,1000,0))
          end

        end)]]


      end

    end)
  end

  self:SetHoldType( self.HoldType )

  if ( CLIENT ) then

    self:ChooseAbility( self.AbilityIcons )

    colour = 0

  end

  if SERVER then

    self.Owner:BreachGive("cw_kk_scp_912_deagle")
    self.Owner:GiveAmmo(999999, "SMG1", true)
    self.Owner:SelectWeapon("cw_kk_scp_912_deagle")

    local wep = self.Owner:GetWeapon("cw_kk_scp_912_deagle")
    wep:SetClip1(wep:GetMaxClip1())
    timer.Simple(1, function()
    wep:attachSpecificAttachment("kk_ins2_suppressor_sec")
    wep:attachSpecificAttachment("kk_ins2_vertgrip") end)

  end

end

if ( SERVER ) then
  
  function SWEP:OnRemove()


    local players = player.GetAll()

    local SCP912_exists

    for i = 1, #players do

      local player = players[ i ]

      if ( player:GetRoleName() == "SCP912" ) then

        SCP638_exists = true

        break
      end

    end

    if ( !SCP912_exists ) then

      hook.Remove( "PlayerButtonDown", "SCP912_Buttons" )

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
