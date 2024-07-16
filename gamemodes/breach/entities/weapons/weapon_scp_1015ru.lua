AddCSLuaFile()

SWEP.HotKeyTable = {}

function toLines(text, font, mWidth)
  surface.SetFont(font)
  
  local buffer = { }
  local nLines = { }

  for word in string.gmatch(text, "%S+") do
    local w,h = surface.GetTextSize(table.concat(buffer, " ").." "..word)
    if w > mWidth then
      table.insert(nLines, table.concat(buffer, " "))
      buffer = { }
    end
    table.insert(buffer, word)
  end
    
  if #buffer > 0 then -- If still words to add.
    table.insert(nLines, table.concat(buffer, " "))
  end
  
  return nLines
end

function drawMultiLine(text, font, mWidth, spacing, x, y, color, alignX, alignY, oWidth, oColor)
  local mLines = toLines(text, font, mWidth)

  for i,line in pairs(mLines) do
    if oWidth and oColor then
      draw.SimpleTextOutlined(line, font, x, y + (i - 1) * spacing, color, alignX, alignY, oWidth, oColor)
    else
      draw.SimpleText(line, font, x, y + (i - 1) * spacing, color, alignX, alignY)
    end
  end
    
  return (#mLines - 1) * spacing
  -- return #mLines * spacing
end

local blur = Material("pp/blurscreen")

function DrawBlurPanel( panel, amount, heavyness )

  local x, y = panel:LocalToScreen( 0, 0 )
  local scrW, scrH = ScrW(), ScrH()
  surface.SetDrawColor( 255, 255, 255 )
  surface.SetMaterial(blur)

  for i = 1, ( heavyness || 3 ) do

    blur:SetFloat( "$blur", ( i / 3 ) * ( amount || 6 ) )
    blur:Recompute()
    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )

  end

end

function SWEP:Initialize()


  self.Owner.EquipTime = RealTime()

  for i = 1, #self.AbilityIcons do

    if ( self.AbilityIcons[ i ].KEY != "Nonekey" ) then

      self.HotKeyTable[ #self.HotKeyTable + 1 ] = self.AbilityIcons[ i ].KEY

    end

  end


  if ( self.NotDrawVW ) then

    self:DrawViewModel( false )

  end

  if ( self.NotDrawWM ) then

    self.Owner:DrawWorldModel( false )

  end


end

function SWEP:ForbidAbility( id, b_forbid )

  if ( !self.AbilityIcons || !self.AbilityIcons[ id ] ) then return end

  self.AbilityIcons[ id ].Forbidden = b_forbid

  if ( SERVER ) then

    if ( id > 15 ) then return end -- Only 4 byte

    net.Start( "ForbidTalant" )

      net.WriteBool( b_forbid )
      net.WriteUInt( id, 4 )

    net.Send( self.Owner )

  end

end

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

  surface.SetFont( "ChatFont_new" )
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
    drawMultiLine( name, "ChatFont_new", w, 16, 5, 0, clrred, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

    local namewidth, nameheight = surface.GetTextSize( name )
    drawMultiLine( text, "ChatFont_new", w + 32, 16, 5, nameheight * 1.4, clrgray, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

    local line_height = nameheight * 1.15

    surface.DrawLine( 0, line_height, w, line_height )
    surface.DrawLine( 0, line_height + 1, w, line_height + 1 )

    draw.SimpleTextOutlined( cooldown, "ChatFont_new", w - 8, 3, clrred2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, blackalpha )

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

    surface.SetFont( "ChatFont_new" )
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

      draw.SimpleTextOutlined( key, "ChatFont_new", w - ( text_sizew / 4 ), 4, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1.5, color_black )

      if ( self.PaintOverride && isfunction( self.PaintOverride ) ) then

        self:PaintOverride( w, h )

        return
      end

      if ( ( ( BREACH.Abilities.AbilityIcons[ i ].CooldownTime || 0 ) - CurTime() ) > 0 ) then

        if ( BREACH.Abilities.AbilityIcons[ i ].Using ) then

          BREACH.Abilities.AbilityIcons[ i ].Using = false

        end

        draw.SimpleTextOutlined( math.Round( BREACH.Abilities.AbilityIcons[ i ].CooldownTime - CurTime() ), "ChatFont_new", 32, 32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )

      elseif ( BREACH.Abilities.AbilityIcons[ i ].Forbidden ) then

        if ( !( primary_wep && primary_wep:IsValid() ) ) then return end

        local number_cooldown = tonumber( BREACH.Abilities.AbilityIcons[ i ].Cooldown )
        if ( ( primary_wep:GetRage() || 0 ) < number_cooldown ) then

          local value = math.Round( number_cooldown - primary_wep:GetRage() )
          draw.SimpleText( value, "ChatFont_new", 32, 32, ColorAlpha( color_white, 210 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

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

function SWEP:SetupDataTables()

  self:NetworkVar( "Int", 0, "CountRage" )

  self:NetworkVar( "Bool", 0, "InRage" )

end

function SWEP:Initialize()

  self:SetCountRage(0)

  self:SetInRage(false)

  self:SetHoldType(self.HoldType)

end

function SWEP:DrawHUD()

  if ( !IsValid( BREACH.Abilities ) ) then

    self:ChooseAbility( self.AbilityIcons )

  end

  if ( input.IsKeyDown( KEY_F3 ) && ( self.NextPush || 0 ) <= CurTime() ) then

    self.NextPush = CurTime() + .5
    gui.EnableScreenClicker( !vgui.CursorVisible() )

  end

  surface.SetDrawColor( color_white )
  surface.SetMaterial( Material("nextoren/gui/special_abilities/scp_1015_rage.png") )
  surface.DrawTexturedRect( 928, 810, 64, 64 )

  draw.RoundedBox( 0, 928, 810, 64, 64, ColorAlpha( darkgray, 190 ) )

  if self:GetInRage() == false then

    draw.SimpleText( self:GetCountRage(), "ChatFont_new", 960, 845, ColorAlpha( color_white, 210 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

  else

    draw.SimpleText( math.Round( ( CurTime() + tonumber( 30 ) ) - CurTime() ), "ChatFont_new", 960, 845, ColorAlpha( color_white, 210 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

  end

end

SWEP.Base 		= "weapon_scp_base"
SWEP.PrintName	= "SCP-1015-RU"
SWEP.HoldType	= "scp1015ru"

SWEP.ViewModel = "models/cultist/scp/1015ru_hands.mdl"

SWEP.AttackDelay			= 5
SWEP.NextAttackW			= 0

if CLIENT then
	SWEP.WepSelectIcon 	= Material("breach/wep_049.png")
end

SWEP.AbilityIcons = {

	{
  
	  Name = "Grab",
	  Description = "Жертва гарантированно обездвиживается.",
	  Cooldown = 35,
	  KEY = "RMB",
	  Icon = "nextoren/gui/special_abilities/scp_1015_grab.png"
  
	},
  {
  
	  Name = "Cartoonism",
	  Description = "Используйте на обездвиженных жертв.",
	  Cooldown = 2,
	  KEY = "R",
	  Icon = "nextoren/gui/special_abilities/scp_1015_cartoonism.png"
  
	},
  {
  
	  Name = "Attack",
	  Description = "Возможность обездвижить на несколько секунд.",
	  Cooldown = 1,
	  KEY = "LMB",
	  Icon = "nextoren/gui/special_abilities/scp_1015_attack.png"
  
	}
  
} 

SWEP.attack_damage = math.random( 10, 20 )

function SWEP:Rage()

  self:SetCountRage(self:GetCountRage() - 100)
  self.OldWalkSpeed = self.Owner:GetWalkSpeed()
  self.OldRunSpeed = self.Owner:GetRunSpeed()
  self.Owner:SetWalkSpeed(300)
  self.Owner:SetRunSpeed(300)
  self.attack_damage_old = self.attack_damage
  self.attack_damage = math.random( 60, 100 )

  self.OldRoleName = self.Owner:GetRoleName()

  self:SetInRage(true)

  self.OldHoldType = self:GetHoldType()

  self:SetHoldType("scp1015ru_rage")

  timer.Create("1015RU_Rage"..self.Owner:EntIndex(), 20, 1, function()
    if self.Owner:GetRoleName() != self.OldRoleName or !self.Owner:Alive() or self.Owner:GTeam() != TEAM_SCP then return end
    self.attack_damage = self.attack_damage_old
    self.Owner:SetWalkSpeed(self.OldWalkSpeed)
    self.Owner:SetRunSpeed(self.OldRunSpeed)
    self:SetInRage(false)
    self:SetHoldType(self.OldHoldType)
  end)

end

function SWEP:Think()

  if self:GetCountRage() >= 100 then

    self:Rage()

  end

end


function SWEP:Reload()
  
  if ( ( self.AbilityIcons[ 2 ].CooldownTime || 0 ) > CurTime() ) then return end
      
  self.AbilityIcons[ 2 ].CooldownTime = CurTime() + tonumber( self.AbilityIcons [ 2 ].Cooldown )

  local player = self.Owner:GetEyeTrace().Entity
  if player:IsPlayer() then
    if player.unconscious then
      net.Start("ThirdPersonCutscene")
	      net.WriteUInt(5, 4)
		    net.WriteBool(false)
	    net.Send(self.Owner)
      ParticleEffect( "Blood_Drain2", self.Owner:GetBonePosition( self.Owner:LookupBone( "ValveBiped.Bip01_Spine1" ) ) + self.Owner:GetAimVector() * 28 + Vector( 0, 0, 8 ), self.Owner:GetAngles(), self.Owner )ParticleEffect( "Blood_Drain2", self.Owner:GetBonePosition( self.Owner:LookupBone( "ValveBiped.Bip01_Spine1" ) ) + self.Owner:GetAimVector() * 28 + Vector( 0, 0, 8 ), self.Owner:GetAngles(), self.Owner )
      self.Owner:Freeze(true)
      self.Owner:Set1015RUSequence(true)
      timer.Create("1015RU_Special_2"..self.Owner:EntIndex(), 5, 1, function()
        ParticleEffect( "Blood_Drain2", self.Owner:GetBonePosition( self.Owner:LookupBone( "ValveBiped.Bip01_Spine1" ) ) + self.Owner:GetAimVector() * 28 + Vector( 0, 0, 8 ), self.Owner:GetAngles(), self.Owner )
        self.Owner:SetHealth(self.Owner:GetMaxHealth() + self.Owner:GetMaxHealth() / 10)
        self.Owner:Freeze(false)
        self.Owner:Set1015RUSequence(false)

        self:SetCountRage(self:GetCountRage() + 15)
        
        player:Kill()
        player:Set1015RUSequenceVictim(false)
        player:Set1015RUSequenceVictimGetup(false)
        player:Freeze(false)
        player.unconscious = false
        timer.Remove("1015RU_VictimUncons"..player:EntIndex())
        timer.Simple(3, function()
          self.Owner:StopParticles()
        end)
      end)

    end

  end

end

function SWEP:SecondaryAttack()

  if ( ( self.AbilityIcons[ 1 ].CooldownTime || 0 ) > CurTime() ) then return end
      
  self.AbilityIcons[ 1 ].CooldownTime = CurTime() + tonumber( self.AbilityIcons [ 1 ].Cooldown )

  self.Owner:DoSecondaryAttack()

  local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 165
	trace.filter = self.Owner
	trace.mins = -self.maxs
	trace.maxs = self.maxs

	trace = util.TraceHull( trace )

  local player = trace.Entity

  if player:IsPlayer() then

    if player.unconscious then return end

    if ( CLIENT ) then

      if ( player && player:IsValid() && player:IsPlayer() && player:GTeam() != TEAM_SCP ) then
  
        local effectData = EffectData()
        effectData:SetOrigin( trace.HitPos )
        effectData:SetEntity( player )
  
        util.Effect( "BloodImpact", effectData )
  
      end
  
      return
    end

    player:EmitSound( "npc/antlion/shell_impact4.wav" )
    player:Freeze(true)
    player:SetStunned(true)

    timer.Create("1015RU_GrabVictim"..player:EntIndex(), 2, 1, function()
      player:Freeze(false)
      player:SetStunned(false)
    end)
  end
end

SWEP.maxs = Vector( 8, 10, 5 )

function SWEP:PrimaryAttack()
  if ( ( self.AbilityIcons[ 3 ].CooldownTime || 0 ) > CurTime() ) then return end
      
  self.AbilityIcons[ 3 ].CooldownTime = CurTime() + tonumber( self.AbilityIcons [ 3 ].Cooldown )

  self.Owner:DoAttackEvent()

  local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 165
	trace.filter = self.Owner
	trace.mins = -self.maxs
	trace.maxs = self.maxs

	trace = util.TraceHull( trace )

  local target = trace.Entity

  if ( CLIENT ) then

    if ( target && target:IsValid() && target:IsPlayer() && target:GTeam() != TEAM_SCP ) then

      local effectData = EffectData()
      effectData:SetOrigin( trace.HitPos )
      effectData:SetEntity( target )

      util.Effect( "BloodImpact", effectData )

    end

    return
  end

  if ( target && target:IsValid() && target:IsPlayer() && target:Health() > 0 && target:GTeam() != TEAM_SCP ) then

    self.dmginfo = DamageInfo()
    self.dmginfo:SetDamageType( DMG_SLASH )
    self.dmginfo:SetDamage( self.attack_damage )
    self.dmginfo:SetDamageForce( target:GetAimVector() * 120 )
    self.dmginfo:SetInflictor( self )
    self.dmginfo:SetAttacker( self.Owner )

    target:EmitSound( "npc/antlion/shell_impact4.wav" )

    target:TakeDamageInfo( self.dmginfo )

    target:ViewPunch( AngleRand( 10, 2, 10 ) )

    target:SetEyeAngles(target:GetAngles() + AngleRand( 10, 2, 10 ))

    random = math.random( 1, 3 )

    unconscious_vict = 3 == random

    if unconscious_vict then
      target:Freeze(true)
      target.unconscious = true
      target:Set1015RUSequenceVictim(true)
      local anim_getup = "l4d_GetUpFrom_Incap"
      timer.Create("1015RU_VictimUncons"..target:EntIndex(), 30, 1, function()
        target.unconscious = false
        target:Set1015RUSequenceVictim(false)
        target:Set1015RUSequenceVictimGetup(true)
        timer.Create("1015RU_VictimUncons2"..target:EntIndex(), target:SequenceDuration( target:LookupSequence(anim_getup) ) / 1.2, 1, function()
          target:Set1015RUSequenceVictimGetup(false)
          target:Freeze(false)
        end)
      end)
    end

  else
    self.Owner:EmitSound( "npc/zombie/claw_miss"..math.random( 1, 2 )..".wav" )
  end

end