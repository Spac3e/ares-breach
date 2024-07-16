AddCSLuaFile();

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName 	= "Intercom"

ENT.Spawnable 	= true
ENT.AdminOnly 	= false

-------------------------------------------
---------------|PARAMS SIDE|---------------
-------------------------------------------

ENT.Lang = {["Ready"] = "Нажмите Е для начала", ["Transmitting"] = "ПЕРЕДАЧА...", ["Cooldown"] = "ПЕРЕЗАПУСК"};
ENT.ALang = "Осталось #T сек";
ENT.MainTimer = "IntercomTMR";
ENT.SecondTimer = "IntercomKMP";

-------------------------------------------
---------------|FUNCS  SIDE|---------------
-------------------------------------------

function ENT:StartTransmitting()
	timer.Remove("IntercomTimer_ChangeStatus")
	self:PlaySoundStart();
	self:SetStatus("Transmitting");
	self:SetWTFTimer(20);
	self:GetTalker():SetNWBool("IntercomTalking", true)
	self:GetTalker().IntercomTalk = true
	if timer.Exists(self.MainTimer) then timer.Stop(self.MainTimer); timer.Remove(self.MainTimer); end
	timer.Create(self.MainTimer, 1, 21, function()

		if self:GetWTFTimer() == 0 then self:EndTransmitting(); else self:SetWTFTimer(self:GetWTFTimer() - 1); end

	end);

	timer.Create("CheckDistationFromIntercom" .. self:GetTalker():SteamID(), 1, 20, function()

		if ( !self:GetTalker() ) then return end

		local talker = self:GetTalker()

		if ( talker:Health() <= 0 || talker:GTeam() == TEAM_SPEC ) then

			self:EndTransmitting()

		end

		if ( self:GetPos():DistToSqr( talker:GetPos() ) > 22500 ) then

			if timer.Exists("CheckDistationFromIntercom" ..talker:SteamID()) then self:EndTransmitting(); timer.Remove("CheckDistationFromIntercom" ..talker:SteamID()); end

		end

	end)

end

function ENT:EndTransmitting()

	self:GetTalker():SetNWBool("IntercomTalking", false)
	self:GetTalker().IntercomTalk = nil
	self:PlaySoundEnd();
	self:SetWTFTimer(0);
	self:StartCooldown();

end

function ENT:StartCooldown()

	self:SetStatus("Cooldown");
	self:SetWTFTimer(120);
	if ( timer.Exists( self.MainTimer ) ) then

		timer.Stop(self.MainTimer);
		timer.Remove(self.MainTimer);

	end

	timer.Create(self.MainTimer, 1, self:GetWTFTimer() + 1, function()

		if self:GetWTFTimer() == 0 then self:EndCooldown(); else self:SetWTFTimer(self:GetWTFTimer() - 1); end

	end);

end

function ENT:EndCooldown()

	self:SetWTFTimer(0);
	self:SetStatus("Ready");

end

-------------------------------------------
---------------|SOUND EFFEC|---------------
-------------------------------------------

function ENT:PlaySoundStart()

	--net.Start( "ForcePlaySound" )

		--net.WriteString( "nextoren/entities/intercom/start.mp3" )

	--net.Broadcast()
	PlayAnnouncer("nextoren/entities/intercom/start.mp3")

end

function ENT:PlaySoundEnd()

	--net.Start( "ForcePlaySound" )

		--net.WriteString( "nextoren/entities/intercom/stop.mp3" )

	--net.Broadcast()
	PlayAnnouncer("nextoren/entities/intercom/stop.mp3")
	/*
	net.Start( "IntercomStatus" )

		net.WriteEntity( self:GetTalker() )
		net.WriteBool( false )

	net.Broadcast()*/
	timer.Remove( "CheckDistationFromIntercom" ..self:GetTalker():SteamID() );

end



-------------------------------------------
---------------|SERVER SIDE|---------------
-------------------------------------------

function ENT:SetupDataTables()

	self:NetworkVar("String", 0, "Status");
	self:NetworkVar("Int", 0, "WTFTimer");
	self:NetworkVar("Entity", 0, "Talker");

end

function ENT:Initialize()

	if ( SERVER ) then

		self:SetModel("models/next_breach/gas_monitor.mdl");
		self:SetColor( color_white );
		self:PhysicsInit( SOLID_NONE )
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid( SOLID_NONE )
		self:SetUseType(SIMPLE_USE)
		self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
		local Physics = self:GetPhysicsObject();
		if ( Physics:IsValid() ) then

			Physics:Wake();

		end

	end

	--self:SetPos( Vector( -2590.555664, 2270.446777, 320.494934 ) )
	--self:SetAngles( Angle( 0, 180, 0 ) )
	self:SetPos( Vector( -2590.555664, 2270.446777, 320.494934 ) )
	self:SetAngles( Angle( 0, 180, 0 ) )
	self:SetStatus("Ready");
	self:SetWTFTimer(0);
	self:SetTalker( nil );

end

function ENT:OnTakeDamage( dmginfo )

	return false

end

if CLIENT then
	BREACH = BREACH || {}
	local gradient = Material("vgui/gradient-r")
	local gradients = Material("gui/center_gradient")
	
	function ENT:CameraView( ply )
	
		ply.CameraEnabled = true
		
		net.Start("CameraPVS")
			net.WriteBool(true)
		net.SendToServer()

		if ply.CameraEnabled then
	
			fovcam = 60
	
			eyeAtt = ply:GetAttachment(ply:LookupAttachment("eyes"))
	
			if not CurView then
				CurView = angles
			else
				CurView = LerpAngle(mclamp(FrameTime() * (35 * (1 - mclamp(100, 0, 0.8))), 0, 1), CurView, angles + Angle(0, 0, eyeAtt.Ang.r * 0.1))
			end
	
			surface.PlaySound( "nextoren/Camera.ogg" )
	
			timer.Create("CameraSound", 5, 0, function()
				if !ply.CameraEnabled then return end
				surface.PlaySound( "nextoren/Camera.ogg" )
			end)
	
			hook.Add( "CalcView", "CameraView", function( ply, pos, ang, fov )
	
				if ply.CameraEnabled then
	
					local drawviewer = false
	
					local cameraviews = {
						origin = CamerasTable[ 1 ].Vector - Vector( 0, 0, 10 ),
						angles = CurView,
						fov = fovcam,
						drawviewer = true
					}
	
					return cameraviews
					  
				end
	
			end)
			
	
			BREACH.MainPanel_CamHud = vgui.Create( "DPanel" )
			BREACH.MainPanel_CamHud:SetSize( 1980, 1080 )
			BREACH.MainPanel_CamHud:SetPos( 0, 0 )
			BREACH.MainPanel_CamHud:SetText( "" )
			BREACH.MainPanel_CamHud.Paint = function( self, w, h )
	
				local cc_grain = surface.GetTextureID ( "overlays/cc_grain")
				local camcorder_noise = surface.GetTextureID ( "overlays/camcorder_noise")
				local camcorder_visor2 = surface.GetTextureID ( "overlays/camcorder_visor2")
				local camcorder_rec = surface.GetTextureID ( "overlays/camcorder_rec")
				local vignette = surface.GetTextureID ( "overlays/cc_vignette")
		
				local w,h = ScrW(),ScrH()
				surface.SetDrawColor ( 255, 255, 255, 255 )
				surface.SetTexture ( vignette )
				surface.DrawTexturedRect ( 0,0, w, h )
		
				local w,h = ScrW(),ScrH()
				surface.SetDrawColor ( 255, 255, 255, 255 )
				surface.SetTexture ( cc_grain )
				surface.DrawTexturedRect ( 0,0, w, h )
			
				local w,h = ScrW(),ScrH()
				surface.SetDrawColor ( 255, 255, 255, 255 )
				surface.SetTexture ( camcorder_noise )
				surface.DrawTexturedRect ( 0,0, w, h )
		
				local w,h = ScrW(),ScrH()
				
				surface.SetDrawColor ( 255, 255, 255, 255 )
				surface.SetTexture ( camcorder_visor2 )
				surface.DrawTexturedRect ( 0, 0, w, h )
				
				surface.SetDrawColor ( 255, 255, 255, 255 )
				surface.SetTexture ( camcorder_rec )
				surface.DrawTexturedRect ( w * 0.84, h * 0.14, 128, 64 )
	
				if camera_nvg == true then
					local w,h = ScrW(),ScrH()
	
					surface.SetDrawColor ( 136, 242, 173, 15 )
					surface.DrawRect ( 0,0, w, h )
	
				end
			
	
			end
	
			BREACH.MainPanel_Cameras = vgui.Create( "DPanel" )
			BREACH.MainPanel_Cameras:SetSize( 256, 256 )
			BREACH.MainPanel_Cameras:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
			BREACH.MainPanel_Cameras:SetText( "" )
			BREACH.MainPanel_Cameras.DieTime = CurTime() + 10
			BREACH.MainPanel_Cameras.Paint = function( self, w, h )
	
				if ( !vgui.CursorVisible() ) then
	
					gui.EnableScreenClicker( false )
				end
	
				if ( input.IsKeyDown( KEY_F3 ) ) then
	
					if ( ( self.NextCall || 0 ) >= CurTime() ) then return end
		
					self.NextCall = CurTime() + 1
	
					if ( vgui.CursorVisible() ) then
		
						gui.EnableScreenClicker( false )
						BREACH.MainPanel228:SetVisible( false )
		
					else
		
						gui.EnableScreenClicker( true )
						BREACH.MainPanel228:SetVisible( true )
		
					end
		
				end
	
				if ( input.IsKeyDown( KEY_N ) ) then
	
					if ( ( self.NextCall2 || 0 ) >= CurTime() ) then return end
		
					self.NextCall2 = CurTime() + 1
	
					if ( !camera_nvg ) then
		
						camera_nvg = true
		
					else
		
						camera_nvg = false
		
					end
		
				end
	
				if ( input.IsKeyDown( KEY_C ) ) then
	
					if fovcam == 10 then return end
		
					fovcam = fovcam - 1
		
				end
	
				if ( input.IsKeyDown( KEY_M ) ) then
	
					if fovcam == 90 then return end
		
					fovcam = fovcam + 1
		
				end
				
			end
	
			local CLOSE2225 = vgui.Create( "DButton", MainPanel_Cameras )
			CLOSE2225:SetPos( 0, 1000 )
			CLOSE2225:SetSize( 350, 40 )
			CLOSE2225:SetText("")
			CLOSE2225:MoveToFront()
			CLOSE2225.DoClick = function()
		  
			  BREACH.MainPanel_Cameras:Remove()
			  BREACH.MainPanel_CamHud.Paint = function( self, w, h )
			  end
			  BREACH.MainPanel_CamHud:Remove()
			  BREACH.MainPanel228:Remove()
			  hook.Remove("CalcView", "CameraView")
			  gui.EnableScreenClicker( false )
			  CLOSE2225:Remove()
			  ply.CameraEnabled = false
			  net.Start("CameraPVS")
			  	net.WriteBool(false)
			  net.SendToServer()
	
			end
		  
			CLOSE2225.OnCursorEntered = function()
		  
			  surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )
		  
			end
		  
			CLOSE2225.FadeAlpha = 0
	
			surface.CreateFont("MainMenuFont", {
	
				font = "Conduit ITC",
				size = 24,
				weight = 800,
				blursize = 0,
				scanlines = 0,
				antialias = true,
				underline = false,
				italic = false,
				strikeout = false,
				symbol = false,
				rotary = false,
				shadow = true,
				additive = false,
				outline = false
			  
			  })
		  
			CLOSE2225.Paint = function(self, w, h)
		  
			  draw.SimpleText( "Назад", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		  
			  if ( self:IsHovered() ) then
		  
				self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )
		  
			  else
		  
				self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )
		  
				end
		  
			  surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
			  surface.SetMaterial( gradient )
			  surface.DrawTexturedRect(0, 0, w, h )
		  
			end
	
			BREACH.MainPanel228 = vgui.Create( "DPanel" )
			BREACH.MainPanel228:SetSize( 256, 768 )
			BREACH.MainPanel228:SetPos( ScrW() / 2 - 896, ScrH() / 2 - 384 )
			BREACH.MainPanel228:SetText( "" )
			BREACH.MainPanel228.DieTime = CurTime() + 10
	
			BREACH.ScrollPanel_Cameras = vgui.Create( "DScrollPanel", BREACH.MainPanel228 )
			BREACH.ScrollPanel_Cameras:Dock( FILL )
	
			for i = 1, #CamerasTable do
	
				BREACH.Cameras = BREACH.ScrollPanel_Cameras:Add( "DButton" )
				BREACH.Cameras:SetText( "" )
				BREACH.Cameras:Dock( TOP )
				BREACH.Cameras:SetSize( 256, 64 )
				BREACH.Cameras:DockMargin( 0, 0, 0, 2 )
				BREACH.Cameras.CursorOnPanel = false
				BREACH.Cameras.gradientalpha = 0
		
				BREACH.Cameras.Paint = function( self, w, h )
		
					if ( self.CursorOnPanel ) then
		
						self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 64 )
		
					else
		
						self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 128 )
		
					end
		
					draw.RoundedBox( 0, 0, 0, w, h, color_black )
					draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )
		
					surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
					surface.SetMaterial( gradient )
					surface.DrawTexturedRect( 0, 0, w, h )
		
					draw.SimpleText( CamerasTable[ i ].Name, "ChatFont_new", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
				end
		
				BREACH.Cameras.OnCursorEntered = function( self )
		
					self.CursorOnPanel = true
		
				end
		
				BREACH.Cameras.OnCursorExited = function( self )
		
					self.CursorOnPanel = false
		
				end
		
				BREACH.Cameras.DoClick = function( self )
	
					hook.Add( "CalcView", "CameraView", function( ply, pos, ang, fov )
	
						if ply.CameraEnabled then
	
							local drawviewer = false
		
							local cameraviews = {
								origin = CamerasTable[ i ].Vector - Vector( 0, 0, 10 ),
								angles = CurView,
								fov = fovcam,
								drawviewer = true
							}
		
							return cameraviews
							  
						end
		
					end)
	
					ply.CurCam = CamerasTable[ i ]
							  
		
				end
	
	
	
				BREACH.MainPanel228:SetVisible( false )
	
			end
	
		end
	
	
	
	end
end

if SERVER then util.AddNetworkString("OpenIntercomMenu") util.AddNetworkString("IntercomAction") end

if SERVER then
	net.Receive("IntercomAction", function(len, ply)
		--if ply:GetRoleName() != role.Dispatcher then return end
		local intercom = net.ReadEntity()
		local actionname = net.ReadString()
		intercom = ply:GetEyeTrace().Entity
		if actionname == "transmit" then
			if intercom:GetStatus() != "Transmitting" then
				intercom:SetTalker(ply)
				intercom:StartTransmitting()
			else
				intercom:EndTransmitting()
			end
		end
		if actionname == "cooldown" then
			if intercom:GetStatus() == "Cooldown" then
				intercom:EndCooldown()
			end
		end
		if intercom:GetStatus() == "Transmitting" then return end
		timer.Remove("IntercomTimer_ChangeStatus")
		if actionname == "sci" then
			intercom:SetStatus("Scientist")
			timer.Create("IntercomTimer_ChangeStatus", 5, 1, function()
				if IsValid(intercom) then intercom:SetStatus("") end
			end)
		end
		if actionname == "mil" then
			intercom:SetStatus("Military")
			timer.Create("IntercomTimer_ChangeStatus", 5, 1, function()
				if IsValid(intercom) then intercom:SetStatus("") end
			end)
		end
		if actionname == "camera" then
			ply:SetViewEntity(ents.FindByClass("br_camera")[1])

			ply.CameraLook = true

			net.Start("camera_enter")
			net.Send(ply)
		end
		if actionname == "live" then
			intercom:SetStatus("Alive")
			timer.Create("IntercomTimer_ChangeStatus", 5, 1, function()
				if IsValid(intercom) then intercom:SetStatus("") end
			end)
		end
	end)
end

if CLIENT then
	net.Receive("OpenIntercomMenu", function()
		--if activator:GetRoleName() == role.MTF_HOF or activator:GetRoleName() == role.Dispatcher then
				if istable(BREACH.DispatchSpecial) then
					if BREACH.DispatchSpecial.MainPanel and IsValid(BREACH.DispatchSpecial.MainPanel.Disclaimer) then BREACH.DispatchSpecial.MainPanel.Disclaimer:Remove() end
					for i, v in pairs(BREACH.DispatchSpecial) do
						if IsValid(v) then v:Remove() end
					end
				end
				BREACH.DispatchSpecial = BREACH.DispatchSpecial || {}
                local clrgray = Color( 198, 198, 198 )
                local clrgray2 = Color( 180, 180, 180 )
                local clrred = Color( 255, 0, 0 )
                local clrred2 = Color( 50,205,50 )
                local gradienttt = Material( "vgui/gradient-r" )

				local teams_table = {

					--{ name = "Наблюдение по камерам", func = function() end },
					--{ name = "Запросы", func = function() end },
					--{ name = "Состояние комплекса", func = function() end },
					{ name = "Просмотр камер", func = function() net.Start("IntercomAction") net.WriteEntity(LocalPlayer():GetEyeTrace().Entity) net.WriteString("camera") net.SendToServer() end },
					{ name = "Живые сущности в ОЗ", func = function() net.Start("IntercomAction") net.WriteEntity(LocalPlayer():GetEyeTrace().Entity) net.WriteString("live") net.SendToServer() end },
					{ name = "Научный персонал в ОЗ", func = function() net.Start("IntercomAction") net.WriteEntity(LocalPlayer():GetEyeTrace().Entity) net.WriteString("sci") net.SendToServer() end },
					{ name = "Военный персонал в ОЗ", func = function() net.Start("IntercomAction") net.WriteEntity(LocalPlayer():GetEyeTrace().Entity) net.WriteString("mil") net.SendToServer() end },
					--{ name = "Восстановить кулдаун", func = function() net.Start("IntercomAction") net.WriteEntity(LocalPlayer():GetEyeTrace().Entity) net.WriteString("cooldown") net.SendToServer() end },
					--{ name = "Передача голоса", func = function() net.Start("IntercomAction") net.WriteEntity(LocalPlayer():GetEyeTrace().Entity) net.WriteString("transmit") net.SendToServer() end }
			
				}
			
			
			
				BREACH.DispatchSpecial.MainPanel = vgui.Create( "DPanel" )
				BREACH.DispatchSpecial.MainPanel:SetSize( 256, 256 )
				BREACH.DispatchSpecial.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
				BREACH.DispatchSpecial.MainPanel:SetText( "" )
				BREACH.DispatchSpecial.MainPanel.Paint = function( self, w, h )
			
					if ( !vgui.CursorVisible() ) then
			
						gui.EnableScreenClicker( true )
			
					end
			
					draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
					draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
			
					if ( input.IsKeyDown( KEY_BACKSPACE ) ) then
			
						self:Remove()
						BREACH.DispatchSpecial.MainPanel.Disclaimer:Remove()
						gui.EnableScreenClicker( false )
			
					end
			
				end
			
				BREACH.DispatchSpecial.MainPanel.Disclaimer = vgui.Create( "DPanel" )
				BREACH.DispatchSpecial.MainPanel.Disclaimer:SetSize( 256, 64 )
				BREACH.DispatchSpecial.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 192 )
				BREACH.DispatchSpecial.MainPanel.Disclaimer:SetText( "" )
			
				local client = LocalPlayer()
			
				BREACH.DispatchSpecial.MainPanel.Disclaimer.Paint = function( self, w, h )
			
					draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
					draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
			
					draw.DrawText( "Панель интеркома", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
					if ( client:GetRoleName() != role.MTF_HOF || client:Health() <= 0 ) then
			
						if ( IsValid( BREACH.DispatchSpecial.MainPanel ) ) then
			
							BREACH.DispatchSpecial.MainPanel:Remove()
			
						end
			
						self:Remove()
			
						gui.EnableScreenClicker( false )
			
					end
			
				end
			
				BREACH.DispatchSpecial.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.DispatchSpecial.MainPanel )
				BREACH.DispatchSpecial.ScrollPanel:Dock( FILL )
			
				for i = 1, #teams_table do
			
					BREACH.DispatchSpecial.Users = BREACH.DispatchSpecial.ScrollPanel:Add( "DButton" )
					BREACH.DispatchSpecial.Users:SetText( "" )
					BREACH.DispatchSpecial.Users:Dock( TOP )
					BREACH.DispatchSpecial.Users:SetSize( 256, 64 )
					BREACH.DispatchSpecial.Users:DockMargin( 0, 0, 0, 2 )
					BREACH.DispatchSpecial.Users.CursorOnPanel = false
					BREACH.DispatchSpecial.Users.gradientalpha = 0
			
					BREACH.DispatchSpecial.Users.Paint = function( self, w, h )
			
						if ( self.CursorOnPanel ) then
			
							self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 128 )
			
						else
			
							self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 256 )
			
						end
			
						draw.RoundedBox( 0, 0, 0, w, h, color_black )
						draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )
			
						surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
						surface.SetMaterial( gradienttt )
						surface.DrawTexturedRect( 0, 0, w, h )
			
						draw.SimpleText( teams_table[ i ].name, "ChatFont_new", w / 2, h / 2, clrgray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
					end
			
					BREACH.DispatchSpecial.Users.OnCursorEntered = function( self )
			
						self.CursorOnPanel = true
			
					end
			
					BREACH.DispatchSpecial.Users.OnCursorExited = function( self )
			
						self.CursorOnPanel = false
			
					end
			
					BREACH.DispatchSpecial.Users.DoClick = function( self )

						teams_table[ i ].func()
			
						BREACH.DispatchSpecial.MainPanel:Remove()
						BREACH.DispatchSpecial.MainPanel.Disclaimer:Remove()
						gui.EnableScreenClicker( false )
			
					end
			
				end

			--end
	end)
end

ENT.DispatchCD = 0

function ENT:Use(activator, caller)
	--if activator:GetRoleName() == role.Dispatcher and self.DispatchCD <= CurTime() then
	if activator:GetRoleName() == role.MTF_HOF and self.DispatchCD <= CurTime() and self:GetStatus() != "Transmitting" then
		self.DispatchCD = CurTime() + 10
		net.Start("OpenIntercomMenu")
		net.Send(activator)
		return
	end
	if self:GetStatus() == "Cooldown" then return end
	if self:GetStatus() == "Alive" or self:GetStatus() == "Scientist" or self:GetStatus() == "Military" then return end
	if activator:GTeam() == TEAM_SPEC or activator:GTeam() == TEAM_SCP then return end
	if self:GetStatus() != "Transmitting" then
		self:SetTalker(activator)
		self:StartTransmitting()
	else
		self:EndTransmitting()
	end

end

function ENT:OnRemove()

	if ( self:GetTalker() && self:GetTalker():IsValid() && self:GetTalker():IsPlayer() ) then

		if ( timer.Exists( self.MainTimer ) ) then

			timer.Remove("CheckDistationFromIntercom" ..self:GetTalker():SteamID());
			timer.Stop(self.MainTimer);
			timer.Remove(self.MainTimer);

			self:PlaySoundEnd();

			net.Start( "IntercomStatus" )

				net.WriteEntity( self:GetTalker() )
				net.WriteBool( false )

			net.Broadcast()

		end

	end

end

-------------------------------------------
---------------|CLIENT SIDE|---------------
-------------------------------------------


local blockedbyonp = Material("overlays/fbi_openup")
local text_clr = Color( 200, 200, 200, 100 )
local ready_clr = Color( 0, 180, 40, 210 )
local offset_angle = Angle( 0, 180, 90 )

function ENT:Draw()

	self:DrawModel();
	
	local Distancetointercom = LocalPlayer():GetPos():DistToSqr( self:GetPos() )
	if ( Distancetointercom > ( 500 * 500 ) || BREACH.Round && ( BREACH.Round.MonitorsActivated || 0 ) > 2 ) then return end

	local Y = {-75, -30, -22};
	if self:GetStatus() == "Transmitting" || self:GetStatus() == "Cooldown" then Y[1], Y[2], Y[3] = -90, -45, -37; end


	cam.Start3D2D(self:LocalToWorld(Vector(6, 3, -10)), self:LocalToWorldAngles( offset_angle ), 0.25);

		--draw.RoundedBox(0, -120, -102, 80, 115, Color(0, 0, 0, 250))
		if ( self:GetStatus() == "Transmitting"  ) then

			draw.DrawText(string.Replace("TRANSMITTING...", "#T", tostring(self:GetWTFTimer())), "LZTextVerySmall", 24, -50, text_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		elseif ( self:GetStatus() == "Cooldown" ) then

			draw.DrawText(string.Replace( "REBOOT: "..self:GetWTFTimer(), "#T", tostring(self:GetWTFTimer())), "LZTextSmall", 24, -50, text_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		elseif ( self:GetStatus() == "Military" ) then
			local amount = 0
			for i, v in pairs(player.GetAll()) do
				if IsValid(v) and ( v:GTeam() == TEAM_GUARD or v:GTeam() == TEAM_SECURITY or v:GTeam() == TEAM_QRT or v:GetModel():find("/security/") ) and v:IsEntrance() then
					amount = amount + 1
				end
			end
			draw.DrawText(string.Replace( "MILITARY: "..amount, "#T", tostring(self:GetWTFTimer())), "LZTextSmall", 24, -50, text_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		elseif ( self:GetStatus() == "Scientist" ) then
			local amount = 0
			for i, v in pairs(player.GetAll()) do
				if IsValid(v) and ( v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_SPECIAL or v:GetModel():find("/sci/") ) and !v:GetModel():find("hazmat") and v:GetRoleName() != role.Dispatcher and v:IsEntrance() then
					amount = amount + 1
				end
			end
			draw.DrawText(string.Replace( "SCIENTIST: "..amount, "#T", tostring(self:GetWTFTimer())), "LZTextSmall", 24, -50, text_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		elseif ( self:GetStatus() == "Alive" ) then

			local amount = 0
			for i, v in pairs(player.GetAll()) do
				if IsValid(v) and v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v:IsEntrance() then
					amount = amount + 1
				end
			end
			draw.DrawText(string.Replace( "ALIVE: "..amount, "#T", tostring(self:GetWTFTimer())), "LZTextSmall", 24, -50, text_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		else

			draw.DrawText( "Press E to start", "LZTextSmall", 24, -50, ready_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		end


	cam.End3D2D();

end
