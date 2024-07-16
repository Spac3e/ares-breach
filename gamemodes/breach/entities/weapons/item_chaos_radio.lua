AddCSLuaFile()

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/chaos_radio.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cultist/items/danradio/c_radio.mdl"
SWEP.WorldModel		= "models/cultist/items/danradio/w_radio.mdl"
SWEP.PrintName		= "Необычная рация"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "items"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands = true

SWEP.Skin = 1

SWEP.Pos = Vector( 2, 4, 2 )
SWEP.Ang = Angle( 0, 90, 0 )

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

local button_clr = team.GetColor( TEAM_CHAOS )

if ( CLIENT ) then

	local prop_pos = Vector( -2024.000000, 6402.250000, 1717.000000 )

	function SWEP:PostDrawViewModel()

		local to_draw = {}

		for _, ent in ipairs( ents.FindInSphere( self.Owner:GetPos(), 200 ) ) do

			if ( ent:GetClass() == "prop_dynamic" && ent:GetPos() == prop_pos ) then

				to_draw[ #to_draw + 1 ] = ent

			end

		end

		outline.Add( to_draw, ColorAlpha( button_clr, 255 * math.sin( ( RealTime() * 6 ) * .5 / 18 ) ), 0 )

	end

end

function SWEP:DrawWorldModel()

	local pl = self:GetOwner()

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if ( !bone ) then return end

		local wm = self:CreateWorldModel()
		local pos, ang = self.Owner:GetBonePosition( bone )

		if ( wm && wm:IsValid() ) then

			ang:RotateAroundAxis( ang:Right(), self.Ang.p )
			ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
			ang:RotateAroundAxis( ang:Up(), self.Ang.r )

			wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
			wm:SetRenderAngles( ang )

			if ( wm:GetSkin() != self.Skin ) then

				wm:SetSkin( self.Skin )

			end

			wm:DrawModel()

		end

	else

		self:SetRenderOrigin( nil )
		self:SetRenderAngles( nil )

		if ( self:GetSkin() != self.Skin ) then

			self:SetSkin( self.Skin )

		end

		local client = LocalPlayer()

	 	if ( client:GTeam() == TEAM_CLASSD && client:GetPos():DistToSqr( self:GetPos() ) < 6400 ) then

			outline.Add( { self }, button_clr, 2 )

		end

		self:DrawModel()

	end

end

function SWEP:Initialize()

	self:SetSkin( self.Skin )

end

function SWEP:Deploy()

  self.Owner:DrawViewModel( true )
	self.Owner:GetViewModel():SetSkin( 1 )

end

function SWEP:OpenDoor( ent )

	ent:EmitSound( "nextoren/others/chaos_radio_open.wav" )

	timer.Simple( 3, function()

		ent:Fire( "Press" )

		timer.Simple( 6, function()

			ent:Fire( "Press" )

		end )

	end )

end

local button_pos = Vector( -1943.989990, 6385.000000, 1717.000000 )

function SWEP:Think()

	if ( CLIENT ) then return end

	if ( self.Owner:KeyDown( IN_USE ) ) then

		local ent = self.Owner:GetEyeTrace().Entity

		if ( ent && ent:IsValid() && ent:GetClass() == "func_button" && ent:GetPos() == button_pos ) then

			self:Remove()
			self:OpenDoor( ent )

		end

	end

end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 1 )

	if ( CLIENT ) then return end

	local ent = self.Owner:GetEyeTrace().Entity

	if ( ent && ent:IsValid() && ent:GetClass() == "func_button" && ent:GetPos() == button_pos ) then

		self:Remove()
		self:OpenDoor( ent )

	end

end

function SWEP:CanSecondaryAttack()

  return false

end
