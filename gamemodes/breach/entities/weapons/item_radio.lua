AddCSLuaFile()

if CLIENT then
	net.Receive( "SetFrequency", function( len )

		local wep = net.ReadEntity()
		local freq = net.ReadFloat()

		wep.Channel = math.Round(freq, 1)

		if ( wep.SetKeyRedact ) then

			wep:SetKeyRedact( false )

		end

	end )
elseif ( SERVER ) then
	util.AddNetworkString( "SetFrequency" )
	util.AddNetworkString( "RadioHooks" )
	util.AddNetworkString( "GetRadioChannel" )

	net.Receive( "SetFrequency", function( len, ply )

		local wep = net.ReadEntity()
		local freq = net.ReadFloat()

		freq = tonumber( string.sub( tostring( freq ), 1, 5 ) )
		wep.Channel = freq

		if ( wep.SetKeyRedact ) then

			wep:SetKeyRedact( false )

		end

	end )

	hook.Add( "PlayerButtonDown", "Radio_TriggerOn", function( caller, button )

		if ( caller:GTeam() == TEAM_SPEC || caller:GTeam() == TEAM_SCP ) then return end

		if ( !caller:HasWeapon( "item_radio" ) ) then return end

		if ( caller:IsFrozen() || caller:GetMoveType() != MOVETYPE_WALK ) then return end

		if ( button == KEY_G ) then

			local radio = caller:GetWeapon( "item_radio" )

			if ( radio && radio:IsValid() && ( radio.NextKeyTrap || 0 ) < CurTime() ) then

				radio.NextKeyTrap = CurTime() + 2.25
				radio:SecondaryAttack()

			end

		end

	end )

end

if ( CLIENT ) then

	local radioicon = Material( "nextoren/gui/icons/radio.png" )

	local boxclr11 = ColorAlpha( color_black, 155 )
	local boxclr22 = Color( 255, 255, 255, 155 )
	local onclr = Color( 0, 255, 0 )
	local offclr = Color( 255, 0, 0 )

	local redact_clr = Color( 90, 90, 255 )
	local NextWave = 0

	net.Receive( "RadioHooks", function()

		hook.Add( "HUDPaintBackground", "Radio_HUD", function()

			local client = LocalPlayer()

			if ( !client:HasWeapon( "item_radio" ) ) then

				hook.Remove( "HUDPaintBackground", "Radio_HUD" )

				return
			end

			local wep = client:GetWeapon( "item_radio" )
			local screenwidth = ScrW()
			local screenheight = ScrH()

			local line_pos = screenheight / 1.4 + 30

			draw.RoundedBox( 0, screenwidth - 100, screenheight / 1.4, 100, 60, boxclr11 )
			draw.RoundedBox( 0, screenwidth - 100, line_pos, 100, 2, boxclr22 )

			surface.SetDrawColor( color_white )
			surface.SetMaterial( radioicon )
			surface.DrawTexturedRect( screenwidth - 100 - 34,	screenheight / 1.4, 32, 35)
			surface.SetDrawColor( color_black )
			surface.DrawOutlinedRect( screenwidth - 100 - 34, screenheight / 1.4, 32, 35 )
			surface.DrawOutlinedRect( screenwidth - 100, screenheight / 1.4, 100, 60 )

			if ( wep:GetEnabled() ) then

				draw.SimpleText( "ON", "char_title24", screenwidth - 50, line_pos - 12, onclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "ON", "char_title24", screenwidth - 52, line_pos - 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			else

				draw.SimpleText( "OFF", "char_title24", screenwidth - 50, line_pos - 12, offclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "OFF", "char_title24", screenwidth - 52, line_pos - 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end

			draw.SimpleText( wep.Channel, "char_title24", screenwidth - 50, line_pos + 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end )

		net.Receive( "GetRadioChannel", function()

			local channel = net.ReadFloat()

			local radio = LocalPlayer():GetWeapon( "item_radio" )

			if ( radio && radio:IsValid() ) then

				radio.Channel = math.Round( channel, 1 )

			end

		end )

		timer.Simple( 1, function()

			hook.Add( "CreateMove", "RadioFrequencyChanger", function( cmd )

				local client = LocalPlayer()

				if ( !client:HasWeapon( "item_radio" ) ) then

					hook.Remove( "CreateMove", "RadioFrequencyChanger" )

					return
				end

				if ( client:GetWeapon( "item_radio" ).GetEnabled && client:GetWeapon( "item_radio" ):GetEnabled() && cmd:GetMouseWheel() != 0 && client:GetWeapon( "item_radio" ).OnRedacted ) then

					local radio = client:GetWeapon( "item_radio" )
					if ( cmd:GetMouseWheel() > 0 && ( NextWave || 0 ) <= CurTime() ) then

						NextWave = CurTime() + .2
						radio:PlaySequence( "use_idle" )

						radio.Channel = radio.Channel + .1
						if ( !string.match( tostring( radio.Channel ), "%d%d%d%.%d" ) ) then

							radio.Channel = radio.Channel + .1

						end

						net.Start( "SetFrequency" )

							net.WriteEntity( radio )
							net.WriteFloat( radio.Channel )

						net.SendToServer()

						if ( radio.Channel == 1000 ) then

							radio.Channel = 100.1

							return
						end

					elseif ( cmd:GetMouseWheel() < 0 && radio.Channel > 1 && radio.OnRedacted && ( NextWave || 0 ) <= CurTime() ) then

						NextWave = CurTime() + .2
						radio:PlaySequence( "use_idle" )
						radio.Channel = radio.Channel - .1
						if ( !string.match( tostring( radio.Channel ), "%d%d%d%.%d" ) ) then

							radio.Channel = radio.Channel - .1

						end

						net.Start( "SetFrequency" )

							net.WriteEntity( radio )
							net.WriteFloat( radio.Channel )

						net.SendToServer()

					end

				end

			end )

		end )

	end )

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/radio.png" )
	SWEP.TextureBin = surface.GetTextureID( "effects/combine_binocoverlay" )
	
	surface.CreateFont( "RadioOFFONFont", {
		font = "brradiofont",
		extended = false,
		size = 36,
		weight = 200,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	function SWEP:PostDrawViewModel( vm, weapon, ply )

		local BoneIndex = vm:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if ( !BoneIndex ) then return end
		local BonePos, BoneAng = vm:GetBonePosition( BoneIndex )
		local TextPos = BonePos + BoneAng:Forward() * 4.9 + BoneAng:Right() * 2.66 + BoneAng:Up() * -2.89
		local TextAngle = BoneAng
		local clr;
		local txt;

		TextAngle:RotateAroundAxis( TextAngle:Right(), 191 )
		TextAngle:RotateAroundAxis( TextAngle:Up(), -3.1 )
		TextAngle:RotateAroundAxis( TextAngle:Forward(), 90 )

		cam.Start3D2D( TextPos, TextAngle, .01 )

			if ( self:GetEnabled() ) then

				surface.SetDrawColor( 0, 0, 255, 100 )
				surface.DrawRect( 0, 0, 145, 58)

				surface.SetDrawColor( 0, 0, 255 )
				surface.SetTexture( self.TextureBin )
				surface.DrawTexturedRect( 0, 0, 145, 58 )

				if ( self:GetKeyRedact() ) then

					clr = redact_clr
					txt = self.Channel_Key || self.Channel

				else

					clr = color_white
					txt = self.Channel

				end

				draw.SimpleText( "Channel: " .. txt, "RadioOFFONFont", 18, 10, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

			end

		cam.End3D2D()

	end

end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cultist/items/danradio/c_radio.mdl"
SWEP.WorldModel		= "models/cultist/items/danradio/w_radio.mdl"
SWEP.PrintName		= "Рация"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "items"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true

SWEP.Equipableitem 		= true

SWEP.UseHands = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

SWEP.Channel = 100.1
SWEP.Enabled = false

SWEP.Skin = 0

SWEP.Pos = Vector( 2, 4, 2 )
SWEP.Ang = Angle( 0, 90, 0 )

sound.Add( {

	name = "radio.toggle",
	channel = CHAN_WEAPON,
	pitch = { 100, 105 },
	volume = .35,
	sound = "weapons/radio/radio_on.wav"

} )

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Enabled" )
	self:NetworkVar( "Bool", 1, "Redacting" )
	self:NetworkVar( "Bool", 2, "KeyRedact" )

	self:SetEnabled( false )
	self:SetKeyRedact( false )
	self:SetRedacting( false )

end

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

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
			wm:DrawModel()

		end

	else

		self:SetRenderOrigin( nil )
		self:SetRenderAngles( nil )
		self:DrawModel()

	end

end

function SWEP:Holster()

	if ( IsFirstTimePredicted() ) then

		self:SetKeyRedact( false )
		self:SetRedacting( false )

	end

	return true

end

function SWEP:PlaySequence( seq_id)

	self.IdlePlaying = false

	local vm = self.Owner:GetViewModel()

	if ( isstring( seq_id ) ) then

		seq_id = vm:LookupSequence( seq_id )

	end

	vm:ResetSequence( seq_id )
	vm:SetPlaybackRate( 1.0 )
	vm:SetCycle( 0 )

end

function SWEP:Equip( new_owner )

	net.Start( "RadioHooks" )
	net.Send( new_owner )

end

function SWEP:Deploy()

	self.IdleDelay = CurTime() + 1.2

	self:PlaySequence( "draw" )

	if ( self:GetSkin() != 0 ) then

		self:SetSkin( 0 )

	end

	return true

end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Think()

	if ( !self:GetRedacting() && !self.IdlePlaying && ( self.IdleDelay || 0 ) < CurTime() ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle", true )

	end

end

function SWEP:PrimaryAttack()

	if ( !self:GetEnabled() ) then return end

	self:SetNextPrimaryFire( CurTime() + .25 )

	if ( CLIENT ) then return end

	self:ToggleKeyRedact()

end

function SWEP:Reload()

	if ( ( self.NextCheck || 0 ) > CurTime() ) then return end

	if ( !self:GetRedacting() ) then

		self.NextCheck = CurTime() + 1
		self.IdleDelay = CurTime() + 1

		self:SetRedacting( true )

		if ( CLIENT ) then

			BREACH.Player:ChatPrint( true, true, "l:radio_edit_info" )

		end

		self:PlaySequence( "use" )

	else

		self.NextCheck = CurTime() + 1
		self.IdleDelay = CurTime() + 3

		self:SetRedacting( false )

		self:PlaySequence( "unuse" )

	end

end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire( CurTime() + 2.25 )

	if ( SERVER ) then

		if ( !self:GetEnabled() ) then

			self.Owner:EmitSound( "radio.toggle" )

		end

		self:SetEnabled( !self:GetEnabled() )

	end

end

if ( CLIENT ) then

	function SWEP:DrawHUD()

		if ( self:GetKeyRedact() && !self.Hook_Added ) then

			self.Hook_Added = true

			BREACH.Player:ChatPrint( true, true, "l:radio_entered_edit" )
			BREACH.Player:ChatPrint( true, true, "l:radio_exit_info" )

			hook.Add( "PlayerButtonDown", "Radio_KeyTrapper", function( caller, key )

				if ( !caller:HasWeapon( "item_radio" ) ) then

					hook.Remove( "PlayerButtonDown", "Radio_KeyTrapper" )

					return
				end

				local radio = caller:GetWeapon( "item_radio" )

				if ( !( radio && radio:IsValid() ) ) then

					hook.Remove( "PlayerButtonDown", "Radio_KeyTrapper" )

					return
				end

				if ( !radio:GetKeyRedact() ) then

					radio.Hook_Added = nil
					radio.Channel_Key = nil
					hook.Remove( "PlayerButtonDown", "Radio_KeyTrapper" )

					return
				end

				if ( ( radio.GetNextTrap || 0 ) > CurTime() ) then return end

				radio.GetNextTrap = CurTime() + .01

				if ( !radio.Channel_Key ) then

					radio.Channel_Key = tostring( radio.Channel )

				end

				local channel_len = radio.Channel_Key:len()

				if ( key == KEY_BACKSPACE && channel_len > 0 ) then

					radio.Channel_Key = string.sub( radio.Channel_Key, 1, -2 )

				elseif ( key == KEY_ENTER ) then

					if ( channel_len == 5 ) then

						radio.Channel = tonumber( radio.Channel_Key )

						if ( radio.Channel < 100.1 ) then

							radio.Channel = 100.1
							radio.Channel_Key = "100.1"

						end

						net.Start( "SetFrequency" )

							net.WriteEntity( radio )
							net.WriteFloat( tonumber( radio.Channel_Key ) )

						net.SendToServer()

					else

						BREACH.Player:ChatPrint( true, true, "l:radio_bad_channel" )

						net.Start( "SetFrequency" )

							net.WriteEntity( radio )
							net.WriteFloat( radio.Channel )

						net.SendToServer()

					end

				else

					key = input.GetKeyName( key )

					if ( key != "." && channel_len == 3 || channel_len != 3 && !isnumber( tonumber( key ) ) || channel_len == 5 ) then return end

					radio.Channel_Key = radio.Channel_Key .. key

				end

			end )

		end

	end

else

	function SWEP:ToggleKeyRedact()

		if ( !self:GetKeyRedact() ) then

			self:SetKeyRedact( true )

		else

			self:SetKeyRedact( false )

		end

	end

end
