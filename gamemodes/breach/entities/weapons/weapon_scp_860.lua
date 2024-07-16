SWEP.AbilityIcons = {

  {

    Name = "Когти",
    Description = "Атака когтями нанося 45% от максимального здоровья игрока",
    Cooldown = 0.75,
    CooldownTime = 0,
    KEY = "LMB",
    Icon = "abils/860_claws.png"

  },

  {

    Name = "Чутье хищника",
    Description = "Вы можете видеть всех через стены и перестаете издавать шум ходьбы на 10 секунд",
    Cooldown = 60,
    CooldownTime = 0,
    KEY = "RMB",
    Icon = "abils/860_sense.png"

  },

  {

    Name = "Рывок",
    Description = "Вы делаете рывок на 9 секунд и вы можете использовать только способность \"Телепортация\"",
    Cooldown = 45,
    CooldownTime = 0,
    KEY = _G["KEY_LSHIFT"],
    Icon = "abils/860_sprint.png"

  },

  {

    Name = "Телепортация",
    Description = "Телепортируете себя и человека в свой лес.",
    Cooldown = 85,
    CooldownTime = 0,
    KEY = _G["KEY_F"],
    Icon = "abils/860_shift.png"

  },

}

SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-860-2"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.WorldModel = "models/cultist/items/blue_screwdriver/w_screwdriver.mdl"
SWEP.ViewModel = ""
SWEP.HoldType = "scp860"
SWEP.Base = "breach_scp_base"
SWEP.IgniteRadius = 260
SWEP.IgniteTime = 2

SWEP.droppable = false

local victim_teleport = Vector(14504.359375, -11216.834961, -3396.027588)
local teleport_860 = Vector(10766.436523, -11217.120117, -3396.127441)

function SWEP:CanPrimaryAttack()

  return false

end

local prim_maxs = Vector( 12, 2, 32 )

function SWEP:Initialize()

  hook.Add("PlayerButtonDown", "SCP8602", function(ply, butt)
    if ply:GetRoleName() != "SCP8602" then return end

    if butt == KEY_LSHIFT and self.AbilityIcons[3].CooldownTime <= CurTime() then
      self.AbilityIcons[3].CooldownTime = CurTime() + self.AbilityIcons[3].Cooldown
      if SERVER then
        self.Owner:SetWalkSpeed(300)
        self.Owner:SetRunSpeed(300)
        timer.Create("SCP860_SPEED", 9, 1, function()
          self.Owner:SetRunSpeed(190)
          self.Owner:SetWalkSpeed(190)
        end)
      end
    elseif butt == KEY_F and self.AbilityIcons[4].CooldownTime <= CurTime() then
      if SERVER then
        local trace = {}
        trace.start = self.Owner:GetShootPos()
        trace.endpos = trace.start + self.Owner:GetAimVector() * 135
        trace.filter = self.Owner
        trace.mins = -prim_maxs
        trace.maxs = prim_maxs

        trace = util.TraceHull( trace )

        local ply = trace.Entity
        if IsValid(ply) and ply:IsPlayer() and ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_SPEC then
          self:Cooldown(4, self.AbilityIcons[4].Cooldown)
          self:Cooldown(2, 0)
          self:Cooldown(3, 0)
          self.Owner:ScreenFade(SCREENFADE.IN, color_black, 1,0.1)
          net.Start("ForcePlaySound")
          net.WriteString("shaky/860/shift.ogg")
          net.Send(self.Owner)
          self.Owner:AnimatedHeal(750)
          ply:ScreenFade(SCREENFADE.IN, color_black, 2,1.5)

          sound.Play("shaky/860/shift2.ogg", ply:GetPos(), 100, 100, 100)

          timer.Simple(2, function()
            if IsValid(ply) then
              net.Start("ForcePlaySound")
              net.WriteString("shaky/860/shift_port"..math.random(1,2)..".ogg")
              net.Send(ply)
            end
          end)

          self.Owner:SetPos(teleport_860)
          self.Owner:SetEyeAngles(Angle(1.616812, -93.878120, 0.000000))
          ply:SetPos(victim_teleport)
        end
      end
    end

  end)

  self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()

end

function SWEP:OnRemove()
  hook.Remove("PlayerButtonDown", "SCP8602")
end

function SWEP:SecondaryAttack()

  if self.AbilityIcons[2].CooldownTime > CurTime() then return end
  if self.Owner:GetWalkSpeed() == 300 then return end
  self.AbilityIcons[2].CooldownTime = CurTime() + self.AbilityIcons[2].Cooldown

  if CLIENT then
    self.Owner:ScreenFade(SCREENFADE.IN, color_black, 1,0.1)
    surface.PlaySound("shaky/860/sense.wav")
  end

  if CLIENT then
    hook.Add("HUDPaint", "SCP_860_VISION", function()
      if LocalPlayer():GTeam() != TEAM_SCP then
        hook.Remove("HUDPaint", "SCP_860_VISION")
        return
      end
      local allplys = player.GetAll()
      for i = 1, #allplys do
        local ply = allplys[i]
        if ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then continue end
        local render = ply:LookupBonemerges()
        render[#render + 1] = ply
        outline.Add(render, Color(255,0,0), OUTLINE_MODE_BOTH )
      end
    end)
    timer.Simple(10, function()
      hook.Remove("HUDPaint", "SCP_860_VISION")
    end)
  end

end

function SWEP:PrimaryAttack()
  if self.AbilityIcons[1].CooldownTime > CurTime() then return end
  self.AbilityIcons[1].CooldownTime = CurTime() + self.AbilityIcons[1].Cooldown

  if timer.Exists("SCP860_SPEED") then
      self.Owner:SetRunSpeed(190)
      self.Owner:SetWalkSpeed(190)
      timer.Remove("SCP860_SPEED")
  end

  local trace = {}
  trace.start = self.Owner:GetShootPos()
  trace.endpos = trace.start + self.Owner:GetAimVector() * 80
  trace.filter = self.Owner
  trace.mins = -prim_maxs
  trace.maxs = prim_maxs

  trace = util.TraceHull( trace )
  local tar = trace.Entity

  if ( CLIENT ) then
    if ( tar && tar:IsValid() && tar:IsPlayer() && tar:GTeam() != TEAM_SCP ) then
      local effectData = EffectData()
      effectData:SetOrigin( trace.HitPos )
      effectData:SetEntity( tar )
      util.Effect( "BloodImpact", effectData )
    end
    return
  end

  if ( IsValid(tar) && tar:IsPlayer() && tar:Health() > 0 && tar:GTeam() != TEAM_SCP ) then

    self.Owner:EmitSound( "shaky/860/claws.ogg", 89, 100, 1, CHAN_WEAPON, 0, 0 )

    self.dmginfo = DamageInfo()
    self.dmginfo:SetDamageType( DMG_SLASH )
    self.dmginfo:SetDamage( tar:GetMaxHealth()*.45 )
    self.dmginfo:SetDamageForce( self.Owner:GetAimVector() * 25 )
    self.dmginfo:SetInflictor( self )
    self.dmginfo:SetAttacker( self.Owner )

    self.Owner:MeleeViewPunch( 3 )

    tar:MeleeViewPunch( self.dmginfo:GetDamage() )
    tar:TakeDamageInfo( self.dmginfo )

  else

    self.Owner:MeleeViewPunch( 1 )
    self.Owner:EmitSound( "npc/zombie/claw_miss"..math.random( 1, 2 )..".wav", 89, 100, 1, CHAN_WEAPON, 0, 0 )

  end

end


function SWEP:DrawWorldModel()

end

function SWEP:Think()

end

local function DrawCirlce(x, y, radius, color, progress, angle)

  local circle = {}
        
  local percentage = ((progress - 0)/(100-0))
        
  local x1, y1 = x + radius, y + radius
        
  local seg = 32
  if !angle then angle = 180 end
        
  table.insert( circle, { x = x1, y = y1 } )
  for i = 0, seg do
      local a = math.rad( (( i / seg ) * (-360*percentage))+angle )
      table.insert( circle, { x = x1 + math.sin( a ) * radius, y = y1 + math.cos( a ) * radius } )
  end
  table.insert( circle, { x = x1, y = y1 } )

  draw.NoTexture()
  surface.SetDrawColor( color )
  surface.DrawPoly( circle )    
        
end
    
local function DrawCircularBar(x, y, progress, radius, thickness, angle, col)
        
  render.SetStencilWriteMask( 0xFF )
  render.SetStencilTestMask( 0xFF )
  render.SetStencilReferenceValue( 0 )
  render.SetStencilCompareFunction( STENCIL_ALWAYS )
  render.SetStencilPassOperation( STENCIL_KEEP )
  render.SetStencilFailOperation( STENCIL_KEEP )
  render.SetStencilZFailOperation( STENCIL_KEEP )
  render.ClearStencil()
        
  render.SetStencilEnable( true )
  render.SetStencilReferenceValue( 1 )
  render.SetStencilCompareFunction( STENCIL_NEVER )
  render.SetStencilFailOperation( STENCIL_REPLACE )
        
  DrawCirlce(x-(radius-thickness), y-(radius-thickness), radius-thickness, col, 100)
            
  render.SetStencilCompareFunction( STENCIL_GREATER )
  render.SetStencilFailOperation( STENCIL_KEEP )      
  DrawCirlce(x-radius, y-radius, radius, col, progress, angle)   
  render.SetStencilEnable( false )
end

local icon = Material(SWEP.AbilityIcons[3].Icon)
local icon2 = Material(SWEP.AbilityIcons[2].Icon)

function SWEP:DrawHUDBackground()
  local w, h = ScrW(), ScrH()
  if self.AbilityIcons[3].CooldownTime - 36 > CurTime() and self.Owner:GetWalkSpeed() == 300 then
    DrawCircularBar(w/2,h-300, 100, 57, 9, 0, Color(0,0,0,145))
    DrawCircularBar(w/2,h-300, (self.AbilityIcons[3].CooldownTime - 36 - CurTime())/9*100, 55, 4.5, 0, gteams.GetColor(TEAM_SCP))
    surface.SetDrawColor( color_white )
    surface.SetMaterial( icon )
    surface.DrawTexturedRect( w/2-32, h-332, 64, 64 )
  elseif self.AbilityIcons[2].CooldownTime - 50 > CurTime() then
    DrawCircularBar(w/2,h-300, 100, 57, 9, 0, Color(0,0,0,145))
    DrawCircularBar(w/2,h-300, (self.AbilityIcons[2].CooldownTime - 50 - CurTime())/10*100, 55, 4.5, 0, gteams.GetColor(TEAM_SCP))
    surface.SetDrawColor( color_white )
    surface.SetMaterial( icon2 )
    surface.DrawTexturedRect( w/2-32, h-332, 64, 64 )
  end
end
