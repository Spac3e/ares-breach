AddCSLuaFile()

local sndpath = "nextoren/weapons/items/gasmask/"

if ( SERVER ) then

  util.AddNetworkString( "GASMASK_RequestWeaponSelect" )

end

if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/gasmask.png" )
  net.Receive( "GASMASK_RequestWeaponSelect", function()

    local wep = net.ReadEntity()
    if ( wep && wep:IsValid() ) then

      input.SelectWeapon( wep )

    end

  end )

end

sound.Add({

  name = "GASMASK_OnOff",
  channel = CHAN_WEAPON,
  volume = 1,
  level = 80,
  pitch = 75,
  sound = {"weapons/universal/uni_weapon_draw_02.wav"}

})

sound.Add( {

  name = "GASMASK_OnOff",
  channel = CHAN_WEAPON,
  volume = 1,
  level = 80,
  pitch = 75,
  sound = {"weapons/universal/uni_weapon_draw_02.wav"}

})

sound.Add({

  name = "GASMASK_Foley",
  channel = CHAN_AUTO,
  volume = 0.35,
  level = 80,
  pitch = 100,
  sound = sndpath.."goprone_03.wav"

})

sound.Add({

  name = "GASMASK_Inhale",
  channel = CHAN_WEAPON,
  volume = 1,
  level = 120,
  pitch = { 98, 102 },
  sound = { sndpath.."focus_inhale_01.wav", sndpath.."focus_inhale_02.wav", sndpath.."focus_inhale_03.wav", sndpath.."focus_inhale_04.wav" }

})

sound.Add({

  name = "GASMASK_Exhale",
  channel = CHAN_WEAPON,
  volume = 1,
  level = 120,
  pitch = { 98, 102 },
  sound = { sndpath.."focus_exhale_01.wav", sndpath.."focus_exhale_02.wav", sndpath.."focus_exhale_03.wav", sndpath.."focus_exhale_04.wav", sndpath .. "focus_exhale_05.wav" }

})

sound.Add({

  name = "GASMASK_BreathingLoop",
  channel = CHAN_AUTO,
  volume = 1,
  level = 100,
  pitch = 100,
  sound = "nextoren/weapons/items/gasmask/gasmask_breathing_loop.wav"

})

sound.Add({

  name = "GASMASK_BreathingLoop2",
  channel = CHAN_AUTO,
  volume = 1,
  level = 100,
  pitch = 100,
  sound = "nextoren/weapons/items/gasmask/gasmask_breathing_loop.wav"

})

SWEP.HoldType = "camera"

SWEP.DrawCrosshair = false
SWEP.Crosshair = false
SWEP.DrawAmmo = false
SWEP.PrintName = "Gas Mask"
SWEP.Slot = 99
SWEP.SlotPos = 99
SWEP.IconLetter = "G"
SWEP.IconLetterSelect = "G"
SWEP.ViewModelFOV = 60
SWEP.SwayScale = 0
SWEP.BobScale = 0

--SWEP.Equipableitem 		= true

SWEP.Instructions = ""
SWEP.Author = ""
SWEP.Contact = ""

SWEP.Weight = 0

SWEP.ViewModelFlip = false

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.UseHands = false

SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 0
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Ammo = "none"

SWEP.ViewModel = ""--"models/gmod4phun/c_contagion_gasmask.mdl"
SWEP.WorldModel = "models/gmod4phun/w_contagion_gasmask.mdl"

function SWEP:GetViewModelPosition( pos, ang )

  return pos, ang

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end


function SWEP:SelectClientWeapon( weapon )

  local ply = self.Owner

  if ( game.SinglePlayer() ) then

    ply:SelectWeapon( weapon:GetClass() )

  else

    net.Start( "GASMASK_RequestWeaponSelect" )

      net.WriteEntity( weapon )

    net.Send( ply )

  end

end

function SWEP:OnDrop()
  self:SetNoDraw(false)
  if self.owner.GASMASK_Equiped then
    self.owner.GASMASK_Ready = false
    self.owner:GASMASK_SetEquipped(false)
    self.owner:GASMASK_RequestToggle()
  end
end

SWEP.owner = "idk man"

function SWEP:OwnerChanged()
  if IsValid(self.Owner) then
    self.owner = self.Owner
  end
end

function SWEP:Deploy()
  self.owner = self.Owner
 -- if SERVER then
    self:SetNoDraw(self.Owner.GASMASK_Equiped == true)
  --end

  return false

end

function SWEP:PrimaryAttack()

  self:SetNextPrimaryFire(CurTime() + 3)
  self:SetNextSecondaryFire(CurTime() + 3)

  if ( SERVER ) then
    local ply = self.Owner

    --[[if ( !self.GASMASK_SignalForDeploy ) then

      ply:StripWeapon( self:GetClass() )

      return
    end]]

    local vm = ply:GetViewModel()

    if ( vm && vm:IsValid() ) then

      vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle_holstered" ) )

    end

    ply.GASMASK_Ready = false
    ply:GASMASK_SetEquipped( !ply.GASMASK_Equiped )
    ply:GASMASK_RequestToggle()

    timer.Simple( 1.8, function()

      if ( !IsValid( self ) ) then return end
      ply.GASMASK_Ready = true
      self:SelectClientWeapon( ply.GASMASK_LastWeapon )
      --ply:StripWeapon( self:GetClass() )

    end )
  end

  self:SetNoDraw(self.Owner.GASMASK_Equiped == true)

  return false

end

function SWEP:SecondaryAttack()

  self:PrimaryAttack()

  return false

end

function SWEP:Holster()

  return self.Owner.GASMASK_Ready

end

function SWEP:Think()

  return true

end
