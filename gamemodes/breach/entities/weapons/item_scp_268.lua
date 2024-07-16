AddCSLuaFile()

if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/268.png" )

end

SWEP.PrintName = "SCP-268"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 80
SWEP.WorldModel = "models/scp_items/scp268/scp268.mdl"
SWEP.ViewModel = "models/weapons/shaky/scp_items/scp_268/v_scp_268.mdl"
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.UseHands = true

SWEP.Pos = Vector( -2, 6, 1 )
SWEP.Ang = Angle( 60, 90, 240 )

function SWEP:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Active" )
  self:NetworkVar( "Int", 0, "NextEffect" )

end

function SWEP:Deploy()

  self.IdleDelay = CurTime() + 0.95
  self:PlaySequence( "draw" )
  self.HolsterDelay = nil

  self.remember_owner = self:GetOwner()

  --[[

  if ( self:GetNextEffect() - CurTime() < 0 ) then

    self:SetNextEffect( CurTime() + 45 )
    self:ActivateEffect()

  else

    if ( SERVER ) then

      BREACH.Players:ChatPrint( self.Owner, true, true, "l:scp268_reloading" )
      BREACH.Players:ChatPrint( self.Owner, true, true, "l:scp268_reload_when_pt1 " .. math.Round( self:GetNextEffect() - CurTime() ) .. " l:scp268_reload_when_pt2" )

    end

  end]]

end

function SWEP:ActivateEffect()

  self.IdleDelay = CurTime() + self:SequenceDuration("use")

  if ( SERVER ) then

    self:PlaySequence("use")

    if ( !self.Player_Tip || self.Player_Tip != self.remember_owner:Nick() ) then

      self.Player_Tip = self.remember_owner:Nick()

      BREACH.Players:ChatPrint( self.remember_owner, true, true, "l:scp268_activated_first_pt1" )
      BREACH.Players:ChatPrint( self.remember_owner, true, true, "l:scp268_activated_first_pt2" )

    else

      BREACH.Players:ChatPrint( self.remember_owner, true, true, "l:scp268_activated" )

    end

  end

  self.unique_id = "InvisibleChange" .. self.remember_owner:SteamID64()

  timer.Create( self.unique_id, 20, 1, function()

    if ( self && self:IsValid() ) then

      self:DeactivateEffect()

    end

  end )

  self:SetActive( true )

  self.remember_owner:SetNoDraw( true )
  self.remember_owner:DrawShadow( false )

  self.droppable = false

end

function SWEP:DeactivateEffect()

  self.IdleDelay = CurTime() + 1.15

  if ( SERVER ) then

    self:PlaySequence("unuse")

    if ( self && self:IsValid() && self.remember_owner:Health() > 0 ) then

      BREACH.Players:ChatPrint( self.remember_owner, true, true, "l:scp268_end" )

    end

  end

  if ( self.unique_id && isstring( self.unique_id ) ) then

    timer.Remove( self.unique_id )

  end

  self:SetActive( false )

  if ( self.remember_owner && self.remember_owner:IsValid() && self.remember_owner:GTeam() != TEAM_SPEC && self.remember_owner:Health() > 0 ) then

    self.remember_owner:SetNoDraw( false )
    self.remember_owner:DrawShadow( true )

  end

  self.droppable = true

end

function SWEP:Holster()

  if ( self:GetActive() ) then

    self:DeactivateEffect()

    self.UnDroppable = nil

  end

  return true

end

function SWEP:Initialize()

  self:SetHoldType( "normal" )

end

function SWEP:Think()

  if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

    self.IdlePlaying = true
    if !self:GetActive() then
      self:PlaySequence( "idle", true )
    end

  end

  if ( CLIENT ) then

    if ( self:GetActive() && !self.UnDroppable ) then

      self.UnDroppable = true

    elseif ( !self:GetActive() && self.UnDroppable ) then

      self.UnDroppable = nil

    end

  end

  if ( self.Owner && self.Owner:IsValid() ) then

    if ( self:GetActive() ) then

      for _, v in ipairs( ents.FindInSphere( self:GetPos(), 30 ) ) do

        if ( v:IsPlayer() && v:IsSolid() && v != self.Owner ) then

          self:DeactivateEffect()

        end

      end

    end

  end

end

function SWEP:OnDrop()
  if self:GetActive() then
    self:DeactivateEffect()
  end
end

function SWEP:PrimaryAttack()

  if self:GetActive() then
    self:DeactivateEffect()
  else
    if ( self:GetNextEffect() - CurTime() < 0 ) then

      self:SetNextEffect( CurTime() + 45 )
      self:ActivateEffect()
      self:SetNextPrimaryFire(CurTime() + 1)

    else

      if ( SERVER ) then

        self:SetNextPrimaryFire(CurTime() + 1)

        BREACH.Players:ChatPrint( self.Owner, true, true, "l:scp268_reloading" )
        BREACH.Players:ChatPrint( self.Owner, true, true, "l:scp268_reload_when_pt1 " .. math.Round( self:GetNextEffect() - CurTime() ) .. " l:scp268_reload_when_pt2" )

      end

    end
  end

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

local lerp = 0
local remembervalue = 0

function SWEP:DrawHUD(w, h)
  local w, h = ScrW(), ScrH()
  local name = "InvisibleChange" .. self.Owner:SteamID64()
  if timer.Exists(name) then
    lerp = Lerp(FrameTime()*5, lerp, 1)
    remembervalue = timer.TimeLeft(name)
  else
    lerp = Lerp(FrameTime()*11, lerp, 0)
  end
  if lerp > 0 then
    DrawCircularBar(w/2,h-300, (remembervalue/20)*100, 25+lerp*10, lerp*4, 0, Color(255,255,255,lerp*25))
  end
    --DrawCircularBar(w/2,h-300, )
end

function SWEP:DrawWorldModel()

  if ( !( self.Owner && self.Owner:IsValid() ) ) then

    self:DrawModel()

  end

end

function SWEP:SecondaryAttack()

  self:PrimaryAttack()

end

function SWEP:CanPrimaryAttack()

  return true

end
