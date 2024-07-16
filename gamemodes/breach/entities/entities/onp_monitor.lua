AddCSLuaFile()
ENT.Type 			= "anim"
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT
ENT.Monitor_Idle				= Material( "nextoren/onp_monitor.png" )
ENT.Monitor_Hacking 		= Material( "nextoren/monitor_hacking_3" )

if ( CLIENT ) then

  net.Receive( "Monitor_Progress", function()

    local monitorvalue = net.ReadUInt( 3 )

    Monitors_Activated = monitorvalue

  end )

end

if ( SERVER ) then

  util.AddNetworkString( "Monitor_Progress" )

end

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Hacking" )

end

function ENT:Initialize()

  UIUHackingInProccess = nil

	self:SetModel( "models/hunter/plates/plate1x3.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

  Monitors_Activated = 0

  m_UIUCanEscape = nil

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetRenderMode( 1 )

	self:SetColor( ColorAlpha( color_white, 1 ) )

	local physobj = self:GetPhysicsObject()

	if ( physobj && physobj:IsValid() ) then

		physobj:EnableMotion( false )

	end

end

function ENT:GetRotatedVec( vec )

	local v = self:WorldToLocal( vec )
	v:Rotate( self:GetAngles() )
	return self:LocalToWorld( v )

end

local clr_red = Color( 255, 0, 0 )
local vec_offset = Vector( -2.1, 0, -35 )
local angle_offset = Angle( -90, 90, 90 )

function ENT:OnRemove()

  if ( self.hack_snd ) then

    self.hack_snd:Stop()
    timer.Remove( "Monitor_Hacking" .. self:EntIndex() )

  end

end

function ENT:Use( activator )

  if activator:GTeam() == TEAM_SCP then return end

  if ( self:GetHacking() ) then

    if ( activator:GTeam() != TEAM_USA ) then

      timer.Remove( "Monitor_Hacking" .. self:EntIndex() )
      UIUHackingInProccess = nil
      self.hack_snd:Stop()
      self:SetHacking( false )

      local filter = RecipientFilter()
    	filter:AddAllPlayers()

      self.hack_snd = CreateSound( self, "nextoren/others/monitor/start_hacking.wav", filter )
      self.hack_snd:SetDSP( 17 )
      self.hack_snd:Play()
      self.hack_snd:ChangePitch( 80, 0 )

      timer.Simple( 1, function()

        if ( self.hack_snd ) then

          self.hack_snd:Stop()

        end

      end )

    end

    return

  elseif ( activator:GTeam() != TEAM_USA ) then

    return

  end

  if ( UIUHackingInProccess ) then return end

  UIUHackingInProccess = true

	self:SetHacking( true )

	timer.Create( "Monitor_Hacking" .. self:EntIndex(), 30, 1, function()

		if ( self && self:IsValid()  ) then

			self.hack_snd:Stop()

      if ( SERVER ) then

			  self:Remove()
        Monitors_Activated = ( Monitors_Activated || 0 ) + 1

        net.Start( "Monitor_Progress" )

          net.WriteUInt( Monitors_Activated, 3 )

        net.Broadcast()

        local players = player.GetAll()
        local units = {}

        for i = 1, #players do

          local player = players[ i ]

          if ( player:GTeam() == TEAM_USA ) then

            player:AddToStatistics( "l:uiu_obj_bonus", 40 )
            units[ #units + 1 ] = player

          end

        end

        local monitors_left = 5 - Monitors_Activated

        if ( monitors_left > 0 ) then

          BREACH.Players:ChatPrint( units, true, true, "l:uiu_remaining_computers " .. monitors_left )

        else

          m_UIUCanEscape = true
          BREACH.Players:ChatPrint( units, true, true, "l:uiu_mission_complete" )

        end

      end

      UIUHackingInProccess = nil

		end

	end )

	if ( CLIENT ) then return end

	local filter = RecipientFilter()
	filter:AddAllPlayers()

	self.hack_snd = CreateSound( self, "nextoren/others/monitor/start_hacking.wav", filter )
	self.hack_snd:SetDSP( 17 )
	self.hack_snd:Play()

end

function ENT:Draw()

	--self:DrawModel()
  self:DestroyShadow()

	local pos = self:GetRotatedVec( self.Entity:GetPos() + self.Entity:GetUp() * 54 + self.Entity:GetRight() * -32 )

	local maxs = select( 2, self:GetCollisionBounds() )

	local pos = self.Entity:GetPos() + self.Entity:GetUp() * 2
	render.SetMaterial( self:GetHacking() && self.Monitor_Hacking || self.Monitor_Idle )
	render.DrawQuadEasy(
		pos,
		self.Entity:GetUp(),
		22, 18,
		color_white,
		180
	)

  --[[local DistanceFromMonitor = LocalPlayer():GetPos():DistToSqr( self:GetPos() )

  if ( DistanceFromMonitor < ( 500 * 500 ) && self.LoadedComplete ) then

    cam.Start3D2D( self:GetPos() - vec_offset, self:GetAngles() + angle_offset, .1 )

      draw.SimpleText( string.ToMinutesSeconds( timer.TimeLeft( "NukeTimer" ) ), "RadioOFFONFont", 0, 400, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    cam.End3D2D()

  end]]

end
