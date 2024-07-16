AddCSLuaFile()

if ( CLIENT ) then

  SWEP.BounceWeaponIcon = false
  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/178.png" )

end

if ( SERVER ) then

  util.AddNetworkString("Glasses")
  util.AddNetworkString("GlassesOFF")

end

SWEP.ViewModel = "models/cultist/scp_items/178/v_178.mdl"
SWEP.WorldModel = "models/cultist/scp_items/178/w_178.mdl"
SWEP.Category = "NextOren"
SWEP.Spawnable = true
SWEP.PrintName = "SCP-198"
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.HoldType = "items"
SWEP.droppable = true
SWEP.teams = {2,3,5,6}
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

function SWEP:Initialize()

  self:SetHoldType(self.HoldType)
  self:SetCollisionGroup(COLLISION_GROUP_WORLD)
  if (SERVER) then

    self.GlassesOwner = self:GetOwner()

  end
  self:SetHoldType("items")

end

function SWEP:Think()


  if ( ( self.tNextThink || 0 ) >= CurTime() || self.Equipped ) then return end

  self.tNextThink = CurTime() + 1.2
  self:SendWeaponAnim( ACT_VM_IDLE )

end

function SWEP:Deploy()

  self.tNextThink = CurTime() + .9
  self:SendWeaponAnim( ACT_VM_DRAW )

  if ( SERVER ) then

    self.GlassesOwner = self:GetOwner()

  end

end

function SWEP:PrimaryAttack()

  if ( self.Equipped ) then return end

  self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

  self.tNextThink = CurTime() + 1.3

  self.Equipped = true

  timer.Simple( .4, function()

    if ( !IsValid( self.Owner ) ) then return end

    self.Owner:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), .2, 1.4 )

  end )

  timer.Simple( 1.8, function()

    if ( !IsValid( self.Owner ) ) then return end

    if ( SERVER ) then

      timer.Create("Damage"..self.Owner:SteamID(), math.random(5,10), 0, function()

        if ( !self.Owner:Alive() || self.Owner:GTeam() == TEAM_SPEC ) then timer.Remove( "Damage"..self.Owner:SteamID() ) return end
        self.Owner:SetHealth( math.Clamp( self.Owner:Health() - math.random(10,15), 0, self.Owner:GetMaxHealth() ) )

        if ( self.Owner:Health() <= 0 ) then

          self.Owner:Kill()

        end

      end)

      net.Start("Glasses")
      net.Send(self.Owner)

    end

  end )

end

function SWEP:SecondaryAttack()

  if ( !self.Equipped ) then return end

  self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )

  self.tNextThink = CurTime() + .7
  self.Equipped = false

  if ( SERVER ) then

    timer.Remove("Damage"..self.Owner:SteamID())

  end

  if ( CLIENT ) then

    hook.Remove( "RenderScreenspaceEffects", "Glasses" )

  end

end

function SWEP:OnDrop()

  if ( !self.Owner:IsValid() ) then return end

  timer.Remove( "Damage"..self.Owner:SteamID() )

end

function SWEP:OnRemove()

  if ( !self.Owner:IsValid() ) then return end

  timer.Remove( "Damage"..self.Owner:SteamID() )

end

if (CLIENT) then
  net.Receive("Glasses", function(len, ply)


    local mat_glasses = Material("pp/colour")
    hook.Add("RenderScreenspaceEffects", "Glasses", function()

      if ( !LocalPlayer():HasWeapon("weapon_scp_198") ) then

        hook.Remove("RenderScreenspaceEffects", "Glasses")

      end
      --DrawMaterialOverlay("effects/combine_binocoverlay",0)
      DrawMaterialOverlay( "models/effects/comball_tape", 0.5 )
      --DrawMaterialOverlay( "effects/tp_eyefx/tpeye", 1 )
      local dark = 0
      local contrast = 1
      local colour = 1
      local nvgbrightness = 0
      local clr_r = 0
      local clr_g = 0
      local clr_b = 0
      local bloommul = 1.2
      local add_r = 0.3
      local add_b = 0.4
      local add_g = 0

      render.UpdateScreenEffectTexture()

      mat_glasses:SetTexture("$fbtexture", render.GetScreenEffectTexture())

      mat_glasses:SetFloat("$pp_colour_contrast", contrast)
      mat_glasses:SetFloat("$pp_colour_colour", colour)
      mat_glasses:SetFloat( "$pp_colour_mulr", clr_r )
      mat_glasses:SetFloat( "$pp_colour_mulg", clr_g )
      mat_glasses:SetFloat( "$pp_colour_mulb", clr_b )
      mat_glasses:SetFloat( "$pp_colour_addr", add_r )
      mat_glasses:SetFloat( "$pp_colour_addg", add_g )
      mat_glasses:SetFloat( "$pp_colour_addb", add_b )

      render.SetMaterial( mat_glasses )
      render.DrawScreenQuad()
    end)
  end)

end
