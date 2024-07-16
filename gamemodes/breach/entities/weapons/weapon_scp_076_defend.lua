AddCSLuaFile()

SWEP.Base 					= "weapon_scp_base"
SWEP.PrintName				= "SCP-076-2"

SWEP.ViewModel				= "models/weapons/tfa_l4d2/c_kf2_katana.mdl"
SWEP.WorldModel				= "models/weapons/tfa_l4d2/w_kf2_katana.mdl"

SWEP.HoldType 				= "katana_defend"



SWEP.NextPrimary = 0
SWEP.UseHands = true

BREACH.Abilities = BREACH.Abilities || {}

local clrgray = Color( 198, 198, 198 )
local clrgray2 = Color( 180, 180, 180 )
local clrred = Color( 255, 0, 0 )
local clrred2 = Color( 198, 0, 0 )
local blackalpha = Color( 0, 0, 0, 180 )

local function ForbidTalant()

  local is_forbidden = net.ReadBool()
  local talant_id = net.ReadUInt( 4 )

  if ( !IsValid( BREACH.Abilities ) || #BREACH.Abilities.Buttons == 0 ) then return end

  LocalPlayer():GetActiveWeapon().AbilityIcons[ talant_id ].Forbidden = is_forbidden


end
net.Receive( "ForbidTalant", ForbidTalant )

local function ShowAbilityDesc( name, text, cooldown, x, y )

  if ( IsValid( BREACH.Abilities.TipWindow ) ) then

    BREACH.Abilities.TipWindow:Remove()

  end

  surface.SetFont( "HUDFont" )
  local stringwidth, stringheight = surface.GetTextSize( text )
  BREACH.Abilities.TipWindow = vgui.Create( "DPanel" )
  BREACH.Abilities.TipWindow:SetAlpha( 0 )
  BREACH.Abilities.TipWindow:SetPos( x + 10, ScrH() - 80  )
  BREACH.Abilities.TipWindow:SetSize( 180, stringheight + 76 )
  BREACH.Abilities.TipWindow:SetText( "" )
  BREACH.Abilities.TipWindow:MakePopup()
  BREACH.Abilities.TipWindow.Paint = function( self, w, h )

    if ( !vgui.CursorVisible() ) then

      self:Remove()

    end

    self:SetPos( gui.MouseX() + 15, gui.MouseY() )
    if ( self && self:IsValid() && self:GetAlpha() <= 0 ) then

      self:SetAlpha( 255 )

    end
    DrawBlurPanel( self )
    draw.OutlinedBox( 0, 0, w, h, 2, clrgray2 )
    drawMultiLine( name, "HUDFont", w, 16, 5, 0, clrred, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

    local namewidth, nameheight = surface.GetTextSize( name )
    drawMultiLine( text, "HUDFont", w + 32, 16, 5, nameheight * 1.4, clrgray, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

    local line_height = nameheight * 1.15

    surface.DrawLine( 0, line_height, w, line_height )
    surface.DrawLine( 0, line_height + 1, w, line_height + 1 )

    draw.SimpleTextOutlined( cooldown, "HUDFont", w - 8, 3, clrred2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, blackalpha )

  end

end

local scp_team_index = TEAM_SCP
local darkgray = Color( 105, 105, 105 )

function SWEP:ChooseAbility( table )

  if ( IsValid( BREACH.Abilities ) ) then

    BREACH.Abilities:Remove()

  end

  BREACH.Abilities = vgui.Create( "DPanel" )
  BREACH.Abilities.AbilityIcons = table
  BREACH.Abilities:SetPos( ScrW() / 2 - ( 32 * #BREACH.Abilities.AbilityIcons ), ScrH() / 1.2 )
  BREACH.Abilities:SetSize( 64 * #BREACH.Abilities.AbilityIcons, 64 )
  BREACH.Abilities:SetText( "" )
  BREACH.Abilities.SCP_Name = LocalPlayer():GetRoleName()
  BREACH.Abilities.Alpha = 1
  BREACH.Abilities.Paint = function( self, w, h )

    local client = LocalPlayer()

    if ( client:Health() <= 0 || client:GetRoleName() != self.SCP_Name ) then

      self:Remove()

    end

    if ( self.Alpha != 255 ) then

      self.Alpha = math.Approach( self.Alpha, 255, RealFrameTime() * 512 )
      self:SetAlpha( self.Alpha )

    end

    surface.SetDrawColor( color_white )
    draw.OutlinedBox( 0, 0, w, h, 4, color_black )

  end

  BREACH.Abilities.OnRemove = function()

    gui.EnableScreenClicker( false )

    if ( IsValid( BREACH.Abilities ) && IsValid( BREACH.Abilities.TipWindow ) ) then

      BREACH.Abilities.TipWindow:Remove()

    end

  end

  for i = 1, #BREACH.Abilities.AbilityIcons do

    BREACH.Abilities.Buttons = BREACH.Abilities.Buttons || {}
    BREACH.Abilities.Buttons[ i ] = vgui.Create( "DButton", BREACH.Abilities )
    BREACH.Abilities.Buttons[ i ]:SetPos( 64 * ( i - 1 ), 0 )
    BREACH.Abilities.Buttons[ i ]:SetSize( 64, 64 )
    BREACH.Abilities.Buttons[ i ]:SetText( "" )
    BREACH.Abilities.Buttons[ i ].ID = iForbidTalant
    BREACH.Abilities.Buttons[ i ].OnCursorEntered = function( self )

      ShowAbilityDesc( BREACH.Abilities.AbilityIcons[ i ].Name, BREACH.Abilities.AbilityIcons[ i ].Description, BREACH.Abilities.AbilityIcons[ i ].Cooldown, gui.MouseX(), ( gui.MouseY() || 5 ) )

    end
    BREACH.Abilities.Buttons[ i ].OnCursorExited = function()

      if ( BREACH.Abilities.TipWindow && BREACH.Abilities.TipWindow:Remove() ) then

        BREACH.Abilities.TipWindow:Remove()

      end

    end

    BREACH.Abilities.Buttons[ i ].DoClick = function()  end

    local iconmaterial = Material( BREACH.Abilities.AbilityIcons[ i ].Icon )
    local key = BREACH.Abilities.AbilityIcons[ i ].KEY
    local c_key

    if ( isnumber( key ) ) then

      c_key = key
      key = string.upper( input.GetKeyName( key ) )

    end

    surface.SetFont( "HUDFont" )
    local text_sizew = surface.GetTextSize( key ) + 16

    BREACH.Abilities.Buttons[ i ].Paint = function( self, w, h )

      local client = LocalPlayer()

      if ( !BREACH.Abilities || !BREACH.Abilities.AbilityIcons[ i ] ) then

        self:Remove()

        return
      end

      surface.SetDrawColor( color_white )
      surface.SetMaterial( iconmaterial )
      surface.DrawTexturedRect( 0, 0, 64, 64 )

      if ( c_key && input.IsKeyDown( c_key ) && !client:IsTyping() ) then

        draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( clrgray, 70 ) )

      end

      if ( BREACH.Abilities && !BREACH.Abilities.AbilityIcons[ i ].Using || BREACH.Abilities && BREACH.Abilities.AbilityIcons[ i ].Forbidden ) then

        draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( darkgray, 190 ) )

      end

      draw.SimpleTextOutlined( key, "HUDFont", w - ( text_sizew / 4 ), 4, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1.5, color_black )

      if ( self.PaintOverride && isfunction( self.PaintOverride ) ) then

        self:PaintOverride( w, h )

        return
      end

      if ( ( ( BREACH.Abilities.AbilityIcons[ i ].CooldownTime || 0 ) - CurTime() ) > 0 ) then

        if ( BREACH.Abilities.AbilityIcons[ i ].Using ) then

          BREACH.Abilities.AbilityIcons[ i ].Using = false

        end

        draw.SimpleTextOutlined( math.Round( BREACH.Abilities.AbilityIcons[ i ].CooldownTime - CurTime() ), "HUDFont", 32, 32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )

      elseif ( BREACH.Abilities.AbilityIcons[ i ].Forbidden ) then

        if ( client:GetRoleName() != "SCP973" ) then return end

        local primary_wep = client:GetWeapon( "weapon_scp_973" )

        if ( !( primary_wep && primary_wep:IsValid() ) ) then return end

        local number_cooldown = tonumber( BREACH.Abilities.AbilityIcons[ i ].Cooldown )
        if ( ( primary_wep:GetRage() || 0 ) < number_cooldown ) then

          local value = math.Round( number_cooldown - primary_wep:GetRage() )
          draw.SimpleText( value, "HUDFont", 32, 32, ColorAlpha( color_white, 210 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        end

      else

        if ( !BREACH.Abilities.AbilityIcons[ i ].Using ) then

          BREACH.Abilities.AbilityIcons[ i ].Using = true

        end

      end

    end

  end

end

function SWEP:OnRemove()

  if ( self.RemoveCustomFunc && isfunction( self.RemoveCustomFunc ) ) then

    self.RemoveCustomFunc()

  end

end

function SWEP:Holster()

  if ( self.RemoveCustomFunc && isfunction( self.RemoveCustomFunc ) ) then

    self.RemoveCustomFunc()

  end

end

function SWEP:DrawHUD()

  if ( !IsValid( BREACH.Abilities ) ) then

    self:ChooseAbility( self.AbilityIcons )

  end

  if ( input.IsKeyDown( KEY_F3 ) && ( self.NextPush || 0 ) <= CurTime() ) then

    self.NextPush = CurTime() + .5
    gui.EnableScreenClicker( !vgui.CursorVisible() )

  end

end

SWEP.AbilityIcons = {

  [ 1 ] = {

    Name = "Ускорение",
    Description = "Вы быстрее на 5 секунд.",
    Cooldown = 10,
    CooldownTime = 0,
    KEY = _G[ "KEY_R" ],
    Icon = "nextoren/gui/special_abilities/scp_076_throw.png"

  },

}

function SWEP:Initialize()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self.NextPrimary = CurTime() + 1
  self:SetHoldType(self.HoldType)
	self:EmitSound( "weapons/l4d2_kf2_katana/knife_deploy.wav" )
	local anim_katana = "wos_phalanx_unsheathe_hip"

	--self.Owner:FastForcedGesture(anim_katana)
end

function SWEP:Deploy()
end

function SWEP:Reload()
  --self.Owner:SelectWeapon("weapon_scp_076")
end

function SWEP:Holster()
  --BREACH.Abilities:Remove()
end

function SWEP:PrimaryAttack()
	if postround then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + 1
	self:EmitSound( "weapons/l4d2_kf2_katana/katana_swing_miss"..math.random(1,2)..".wav" )
	self.Owner:LagCompensation( true )
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector()
	local dmg = math.random( 25, 35 )
	local dist = 75

	local damage = DamageInfo()
	damage:SetDamage( dmg )
	damage:SetDamageType( DMG_SLASH )
	damage:SetAttacker( self.Owner )
	damage:SetInflictor( self )
	damage:SetDamageForce( aim * 300 )

	local tr = util.TraceHull( {
		start = pos,
		endpos = pos + aim * dist,
		filter = self.Owner,
		mask = MASK_SHOT_HULL,
		mins = Vector( -10, -5, -5 ),
		maxs = Vector( 10, 5, 5 )
	} )
	if tr.Hit then
		local ent = tr.Entity
		if ent:IsPlayer() then
			if ent:GTeam() != TEAM_SPEC and ent:GTeam() != TEAM_SCP then
				self:EmitSound( "weapons/l4d2_kf2_katana/melee_katana_0"..math.random(1,3)..".wav" )
				if SERVER and ent:GTeam() != TEAM_SCP then
					ent:TakeDamageInfo( damage )
				end
			end
		end
	end
	
	self.Owner:LagCompensation( false )
	self:SendWeaponAnim( table.Random({ACT_VM_MISSLEFT, ACT_VM_MISSRIGHT}) )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end