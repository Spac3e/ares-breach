AddCSLuaFile()

if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/nvg_3.png" )

end


SWEP.Base = "weapon_base"
SWEP.PrintName = "Прототип тепловизора"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.HoldType = "normal"
SWEP.ViewModel		= "models/cultist/items/nightvision/v_night_vision.mdl"
SWEP.WorldModel		= "models/cultist/items/nightvision/w_nvg_forface.mdl"
SWEP.DrawCrosshair = false

SWEP.HitDistance = 50

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize		= 5
SWEP.Secondary.DefaultClip	= 5
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay = 5

SWEP.Nightvision = false
SWEP.NextReload = CurTime()

SWEP.Slot				= 0
SWEP.SlotPos			= 0
--Link2006's fix for Nightvision;
SWEP.droppable				= true


function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	if ( SERVER ) then

		self.NvOwner = self.Owner

	end

	self:SetHoldType("normal")

end

SWEP.NextAttack = 0

function SWEP:PrimaryAttack()

	if ( self.NextAttack > CurTime() ) then return end
	self.NextAttack = CurTime() + 1

	self:Reload()

end

function SWEP:CanSecondaryAttack()

	return false

end

local banned_models = {

	[ "models/cultist/humans/sci/hazmat_2.mdl" ] = true,
	[ "models/cultist/humans/sci/hazmat_1.mdl" ] = true,
	[ "models/cultist/humans/goc/goc.mdl" ] = true,
	[ "models/cultist/humans/chaos/chaos.mdl" ] = true,
	--[ "models/cultist/humans/obr/obr.mdl" ] = true,
	[ "models/cultist/humans/mog/mog_hazmat.mdl" ] = true,
	[ "models/cultist/humans/class_d/class_d_fat_new.mdl" ] = true

}

local function CheckEquip( player )

	if ( !istable( player.BoneMergedEnts ) ) then return true end

	for _, v in ipairs( player.BoneMergedEnts ) do

		if ( v && v:IsValid() && v:GetModel():find( "_nvg_" ) ) then

			return false

		end

	end

	return true

end

function SWEP:Reload()

	if ( ( self.IdleDelay || 0 ) > CurTime() ) then return end

	if ( !self.Nightvision && !CheckEquip( self.Owner ) ) then

		self.IdleDelay = CurTime() + 3

		if ( CLIENT ) then

			BREACH.Player:ChatPrint( true, true, "l:take_off_nvg_first" )

		end

		return
	end

	if ( !self.Nightvision ) then

		self.Nightvision = true
		self.IdleDelay = CurTime() + 2
		self:PlaySequence( "puton" )

	else

		self.Nightvision = false
		self.IdleDelay = CurTime() + .75
		self:PlaySequence( "putoff" )

	end

	if ( SERVER ) then

		if ( self.Nightvision ) then

			timer.Simple(1.2, function()

				if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) ) then return end

				self.Owner:ScreenFade( SCREENFADE.IN, color_black, 2, 0 )

				if ( self.Owner:Alive() ) then

					--self.Nightvision = true
					self.Owner:DrawViewModel( false )

					self.Nightvision_Owner = self.Owner
					self.Owner:EmitSound( "nextoren/weapons/items/nightvision/nvgturnon.wav", 75, 100, 1, CHAN_STATIC )
					if ( !banned_models[self.Owner:GetModel()] or self.Owner:GetRoleName() == role.ClassD_GOCSpy) then

						Bonemerge( "models/cultist/items/nightvision/bonemerge_nvg_forface.mdl", self.Owner )
						for _, v in ipairs( self.Owner.BoneMergedEnts ) do

							if ( v && v:IsValid() && v:GetModel():find( "_nvg_" ) ) then
					
								v:SetSkin( 2 )
								local nvg_bonemerge = v

								self.Owner.NVG_Bonemerged = nvg_bonemerge
								--self.Owner:EmitSound( "nextoren/weapons/items/nightvision/nvgturnon.wav", 75, 100, 1, CHAN_STATIC )
								
							end
					
						end

					end


					net.Start( "NightvisionOn" )

						net.WriteString( "GOC" )

					net.Send( self.Owner )

				end

			end)

		elseif ( !self.Nightvision ) then

			self.Owner:DrawViewModel( true )

			self.Owner:ScreenFade( SCREENFADE.IN, color_black, 0.9, 0 )

			if ( self.Owner.NVG_Bonemerged && self.Owner.NVG_Bonemerged:IsValid() ) then

				self.Owner.NVG_Bonemerged:Remove()

			end

			self.Nightvision_Owner = nil

			if ( self.Owner:Alive() ) then

				--self.Nightvision = false
				net.Start( "NightvisionOff" )
				net.Send( self.Owner )

			end

		end

	end

end

function SWEP:Deploy()

	if ( !self.Nightvision ) then

		self.Owner:DrawViewModel( true )

	else

		self.Owner:DrawViewModel( false )

	end

	self.IdleDelay = CurTime() + .5
  self.HolsterDelay = nil
  self:PlaySequence( "deploy" )

	if ( SERVER ) then

		self.NvOwner = self.Owner

	end

end

function SWEP:Holster()

  if ( self.Nightvision ) then return true end

  if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + 1
		self.IdleDelay = CurTime() + 1
		self:PlaySequence( "holster" )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then

		return true

	end

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle", true )

	end

end

function SWEP:DrawWorldModel()

	if ( !IsValid( self.Owner ) ) then

		self:DrawModel()
		self:SetSkin( 2 )

	end

end

function SWEP:OnDrop()

	self.Nightvision = false

	if ( SERVER && self.Nightvision_Owner ) then

		if ( self.Nightvision_Owner && self.Nightvision_Owner:IsValid() && self.Nightvision_Owner:Health() > 0 && istable( self.Nightvision_Owner.BoneMergedEnts ) ) then

			if ( self.Nightvision_Owner.NVG_Bonemerged && self.Nightvision_Owner.NVG_Bonemerged:IsValid() ) then

				self.Nightvision_Owner.NVG_Bonemerged:Remove()
				self.Nightvision_Owner:SendLua( 'LocalPlayer().NVG = nil' )
				self.Nightvision_Owner = nil

			end

		end

	end

	if ( SERVER ) then

		net.Start( "NightvisionOff" )
		net.Send( self.Owner )
		return true

	end

end

function SWEP:OnRemove()

	self.Nightvision = false

	if ( SERVER ) then

		net.Start( "NightvisionOff" )
		net.Send( self.Owner )

	end

end
