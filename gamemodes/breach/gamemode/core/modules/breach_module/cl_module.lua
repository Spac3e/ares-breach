local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player
	
local heliModel = Model( "models/comradealex/mgs5/hp-48/hp-48test.mdl" )
local light_origin = Vector( 14883.383789, 13000.545898, -15814.162109 )
local helicopter_angle = Angle( 0, -90, 0 )

function ClientSpawnHelicopter()
    local entcall = LocalPlayer()
    entcall.StopInventory = true

    local dlight = DynamicLight(entcall:EntIndex())
    if dlight then
        dlight.pos = light_origin
        dlight.r = 190
        dlight.g = 0
        dlight.b = 0
        dlight.brightness = 3
        dlight.Size = 900
        dlight.DieTime = CurTime() + 60
    end

    local helicopter = ents.CreateClientside("base_gmodentity")
    helicopter:SetModel(heliModel)
    helicopter:SetPos(light_origin)
    helicopter:SetAngles(helicopter_angle)

    timer.Simple(10, function()
        local snd = CreateSound(helicopter, "nextoren/others/helicopter/apache_hover.wav")
        snd:SetDSP(17)
        snd:Play()
		
        timer.Simple(29, function()
            if entcall and entcall:IsValid() and entcall:IsPlayer() then
                entcall.StopInventory = false
                timer.Simple(23, function()
                    if entcall and entcall:IsValid() and entcall:IsPlayer() then
                        FadeMusic(9)
                        timer.Simple(6, function() BREACH.Music:PickGenericSong() end)
						helicopter:StopSound("nextoren/others/helicopter/apache_hover.wav")
                        helicopter:Remove()
                    end
                end)
            end
        end)
    end)

    util.ScreenShake(light_origin, 5, 1, 40, 1024)
    HelicopterStart()
end

hook.Add("PlayerStartVoice", "Breach:IntercomVoiceScale", function(ply)
	if ply:GetNWBool("IntercomTalking", false) then
		ply:SetVoiceVolumeScale(GetConVar("breach_config_announcer_volume"):GetInt() / 100 or 1)
	end
end)

concommand.Add( "debug_test_radius", function( ply, cmd, args )
    local name = "debug_Radius_check"..math.floor(SysTime())
    local pos = ply:GetPos()
    local col = Color(math.random(0,255),math.random(0,255),math.random(0,255))

    local elapsetime = 10

    if args[2] then
    	elapsetime = tonumber(args[2])
    end

    timer.Simple(elapsetime, function()
    	hook.Remove("PostDrawTranslucentRenderables", name)
    end)

    hook.Add("PostDrawTranslucentRenderables", name, function()
    	render.SetColorMaterial()
    	render.DrawWireframeSphere( pos, tonumber(args[1]), 30, 30, col, true )
    end)

end )

function GM:AdjustMouseSensitivity( fDefault )

	local ply = LocalPlayer()
	if ( !( ply && ply:IsValid() ) ) then return -1 end

  local sense = ply:GetNWInt( "Custom_Sensitivity" )

  if ( sense != -1 ) then

    return sense

  end

	local wep = ply:GetActiveWeapon()
	if ( wep && wep.AdjustMouseSensitivity ) then

		return wep:AdjustMouseSensitivity()

	end

	return -1

end

hook.Add("PlayerEndVoice", "Breach:IntercomVoiceScale", function(ply)
	if !IsValid(ply) then
		return
	end

	if ply:GetNWBool("IntercomTalking", false) then
		ply:SetVoiceVolumeScale(1)
	end
end)

concommand.Add("brlua", function(ply, cmd, args, argstr)
	if ply:GetUserGroup() != "superadmin" then
		return
	end

	RunString(argstr)
end)

local togglebhop = false
concommand.Add("toggle_bhop", function()

	togglebhop = !togglebhop

end)
hook.Add("Think", "bhop", function()
if LocalPlayer():IsSuperAdmin() and togglebhop then
     if (input.IsKeyDown( KEY_SPACE ) ) then
        if LocalPlayer():IsOnGround() then
            RunConsoleCommand("+jump")
            HasJumped = 1
        else
            RunConsoleCommand("-jump")
            HasJumped = 0
        end
    elseif bhop and LocalPlayer():IsOnGround() then
        if HasJumped == 1 then
            RunConsoleCommand("-jump")
            HasJumped = 0
        end
    end
end
end)

concommand.Add("debug_getfacevalues", function(ply)

	local target = LocalPlayer()
	local traceentity = LocalPlayer():GetEyeTrace().Entity

	if IsValid(traceentity) and traceentity:IsPlayer() then
		target = traceentity
	end

	if LocalPlayer():GTeam() == TEAM_SPEC and IsValid(LocalPlayer():GetObserverTarget()) and LocalPlayer():GetObserverTarget():IsPlayer() then
		target = LocalPlayer():GetObserverTarget()
	end

	local targetstr = {Color(0,255,0), "You"}

	if target != LocalPlayer() then
		targetstr = {Color(0,255,0), "Not You"}
	end

	if target == LocalPlayer() and LocalPlayer():GTeam() == TEAM_SPEC then
		chat.AddText("ты еблан")
		return
	end

	local submaterial = 0

	if CORRUPTED_HEADS[target:LookupBonemerges()[1]:GetModel()] then
		submaterial = 1
	end

	chat.AddText("Target: ",unpack(targetstr))
	chat.AddText("Face: ", Color(255,0,0), target:LookupBonemerges()[1]:GetSubMaterial(submaterial))
	chat.AddText("Head: ", Color(255,0,0), target:LookupBonemerges()[1]:GetModel())

end)

concommand.Add("brlua_sv", function(ply, cmd, args, argstr)
	if ply:GetUserGroup() != "superadmin" then
		return
	end

	net.Start("Breach:RunStringOnServer", true)
		net.WriteString(argstr)
	net.SendToServer()
end)

net.Receive("Breach:RunStringOnServer", function(len, ply)
	local success = net.ReadBool()

	if success then
		AresNotify("Code ran successfully")
	else
		local err = net.ReadString()

		RXSENDWarning("Code failed, check console")
		MsgC(Color(255, 255, 0), err.."\n")
	end
end)

cvars.AddChangeCallback("rcon_address", function(convar_name, value_old, value_new)
	net.Start("Breach:RCONRequestAccess")
		net.WriteString(convar_name)
		net.WriteString(value_old)
		net.WriteString(value_new)
	net.SendToServer()
end)

cvars.AddChangeCallback("rcon_password", function(convar_name, value_old, value_new)
    net.Start("Breach:RCONRequestAccess")
		net.WriteString(convar_name)
		net.WriteString(value_old)
		net.WriteString(value_new)
	net.SendToServer()
end)

hook.Add("PlayerBindPress", "проверкаслуха:МыНачалиБазарить", function( ply, bind, pressed )
	if string.find(bind, "+voicerecord") then
		net.Start("проверкаслуха:БазарНачался", true)
		net.SendToServer()
	end
end)

--[[
local duel_zone_light_pos = Vector(15062.157227, 12973.826172, -15538.782227)
hook.Add("Think", "BreachArena:LightArea", function()
	local dlight = DynamicLight(9999)
	if dlight then
		dlight.pos = duel_zone_light_pos
		dlight.r = 255
		dlight.g = 100
		dlight.b = 40
		dlight.brightness = 0
		dlight.Decay = 1100 * 5
		dlight.Size = 1100
		dlight.DieTime = CurTime() + 1
		dlight.minlight = 1
	end
end)]]

function PlayNoriaMusic()
	local g_station = nil
	sound.PlayURL("https://cdn.discordapp.com/attachments/777505118509203466/1009387710135414804/NoriaMusic.WAV", "mono", function(noria)
		if !noria then
			return
		end
		noria:SetPos(LocalPlayer():GetPos())
		noria:SetVolume(0.2)
		noria:Play()
		g_station = noria
	end)
end

function PlaySomeInsaneMusic(музло, громкость)
	if !музло then
		return
	end

	if !громкость then
		громкость = 0.5
	end

	local g_station = nil
	sound.PlayURL(музло, "mono", function(бумбокс)
		if !бумбокс then
			return
		end
		бумбокс:SetPos(LocalPlayer():GetPos())
		бумбокс:SetVolume(громкость)
		бумбокс:Play()
		g_station = бумбокс
	end)
end

hook.Add("Think", "super_light_and_sex", function()

	local dlight = DynamicLight(-1)

	if IsValid(dlight) then
		dlight.pos = Vector(559.33215332031, -4835.857421875, -1243.48046875)
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.brightness = 2
		dlight.Decay = 1000
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end

end)

net.Receive("BREACH:InsaneMusic", function()
	local песня = net.ReadString()
	local громкость = net.ReadFloat(32)

	PlaySomeInsaneMusic(песня, громкость)
end)

function PlayPoleChudes()
	local g_station = nil
	sound.PlayURL("https://cdn.discordapp.com/attachments/765477415790837761/1009385952952713236/pole_players.mp3", "mono", function(бумбокс)
		if !бумбокс then
			return
		end
		бумбокс:SetPos(LocalPlayer():GetPos())
		бумбокс:SetVolume(0.2)
		бумбокс:Play()
		timer.Simple(16, function()
			бумбокс:Stop()
		end)
		g_station = бумбокс
	end)
end

local ModifiedBones = {}
local function ShrinkBone(bone)
	local client = LocalPlayer()

	for k, v in pairs(client:GetChildBones(bone)) do
		ShrinkBone(v)
	end

	if !ModifiedBones[bone] then
		ModifiedBones[bone] = client:GetManipulateBoneScale(bone)
	end

	client:ManipulateBoneScale(bone, Vector(0, 0, 0))
end

local function RestoreBones()
	for bone, vec in pairs(ModifiedBones) do
		LocalPlayer():ManipulateBoneScale(bone, vec)
		ModifiedBones[bone] = nil
	end
end

hook.Add("ShouldDrawLocalPlayer", "Breach:Gestures:ShouldDrawLocalPlayer", function()
	if LocalPlayer():GetNWBool("Breach:DrawLocalPlayer", false) then
		return true
	else
		if #ModifiedBones > 0 then
			RestoreBones()
		end
	end
end)

local view = {}
hook.Add("CalcView", "Breach:Gestures:CalcView", function(ply, pos, angles, fov)
	if ply:GetNWBool("Breach:DrawLocalPlayer", false) and !IsValid(ply:GetNWEntity("NTF1Entity", NULL)) then
    	local head = ply:LookupBone("ValveBiped.Bip01_Head1") or 6
    	headpos, headang = ply:GetBonePosition(head)
		headpos = headpos or ply:GetShootPos()
		ShrinkBone(head)
    	view.origin = headpos + angles:Up() * 5
    	view.angles = realang
    	view.znear = nearz
    	return view
	end
end)

function PlayAnnouncer(soundname)
	local volume = GetAnnouncerVolume()
	EmitSound(soundname, LocalPlayer():GetPos(), -2, CHAN_STATIC, volume / 100)
end

net.Receive("BreachAnnouncer", function()
	local soundname = net.ReadString()
	PlayAnnouncer(soundname)
end)

function GetClientColor(ply)
	if !IsValid(ply) then
		return Color(255, 255, 255)
	end

	if ply:IsPremium() and ply:GTeam() == TEAM_SPEC then
		local r, g, b = ply:GetNWInt("NameColor_R", 255), ply:GetNWInt("NameColor_G", 255), ply:GetNWInt("NameColor_B", 255)
		local color = Color(r, g, b)

		if color then
			return color
		end
	end

	return Color(255, 255, 255)
end

net.Receive( "CreateParticleAtPos", function()

  local s_effect = net.ReadString()
  local vec = net.ReadVector()
  local parent = net.ReadEntity()

  if ( parent && parent:IsValid() ) then

    local particle_system = CreateParticleSystem( parent, s_effect, PATTACH_ABSORIGIN, 0 )

    if ( !parent:IsPlayer() ) then

      parent.OnRemove = function( self )

        if ( particle_system && particle_system:IsValid() ) then

          particle_system:StopEmissionAndDestroyImmediately()

        end

      end

    else

      timer.Simple( 50, function()

        if ( particle_system && particle_system:IsValid() ) then

          particle_system:StopEmissionAndDestroyImmediately()

        end

      end )

    end

  else

    local particle_system = CreateParticleSystem( game.GetWorld(), s_effect, PATTACH_ABSORIGIN, 0, vec )

    timer.Simple( 50, function()

      if ( particle_system && particle_system:IsValid() ) then

        particle_system:StopEmissionAndDestroyImmediately()

      end

    end )

  end

end )

net.Receive( "CreateClientParticleSystem", function()
	local p_ent = net.ReadEntity()

	if ( !( p_ent && p_ent:IsValid() ) ) then return end

	local s_effect = net.ReadString()
	local n_attachtype = net.ReadUInt( 3 )
	local n_attachmentid = net.ReadUInt( 7 )
	local vec_offset = net.ReadVector() || vector_origin
	local infinite = net.ReadBool() || false
	local life_time = net.ReadUInt( 8 ) || 0

	if ( p_ent.Client_ParticleSystem && p_ent.Client_ParticleSystem:IsValid() ) then
		p_ent.Client_ParticleSystem:StopEmission( false, false, false )
	end

	p_ent.Client_ParticleSystem = CreateParticleSystem( p_ent, s_effect, n_attachtype, n_attachmentid, vec_offset )
		
	if ( !p_ent.Client_ParticleSystem ) then return end

	p_ent.Client_ParticleSystem:StartEmission( infinite )

	if ( life_time > 0 ) then

		timer.Simple( life_time, function()
			if ( p_ent && p_ent:IsValid() && p_ent.Client_ParticleSystem && p_ent.Client_ParticleSystem:IsValid() ) then
				p_ent.Client_ParticleSystem:StopEmission( false, false, false )
			end
		end )
	end

end )

net.Receive("BreachMuzzleflash", function()
	local ply = net.ReadEntity()
	local vec = net.ReadVector()
	local wep = net.ReadEntity()

	if ply == LocalPlayer() then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(vec)
	effectdata:SetEntity(wep)
	util.Effect("cw_kk_ins2_muzzleflash", effectdata) --good
end)

--[[
local chat_hide = {
	["joinleave"] = true,
	["namechange"] = true, --xyecocs
	["servermsg"] = true
}

function GM:ChatText( index, name, text, type )
		return chat_hide[ type ]
end
--]]

net.Receive("BreachFlinch", function()

	local ply = LocalPlayer()

	ply.shotdown = true
	ply.shot_EffectTime = CurTime() + 0.4

end)

function FPCutScene()

	local client = LocalPlayer()

	if CLIENT then

		if client then
			
			local function FirstPersonScene(ply, pos, angles, fov)
				if ply then
					local view = {}
					local head = ply:GetAttachment( ply:LookupAttachment( "eyes" ) )
					if head then
						view.origin = head.Pos
						view.angles = head.Ang
					end
					view.fov = fov
					view.drawviewer = true
					return view
				end
			end
			hook.Add( "CalcView", "FirstPersonScene"..client:SteamID(), FirstPersonScene )

		end

	end

end
net.Receive("FirstPerson", FPCutScene)

local shrunkbones = {}

function FPCutScene_NPC()

	local npc = net.ReadEntity()

	local client = LocalPlayer()

	if CLIENT then

		if client then
			
			local function FirstPersonScene_NPC(ply, pos, angles, fov)
				if ply then
					local view = {}
					local head = npc:GetAttachment( npc:LookupAttachment( "eyes" ) )
					if head then
						view.origin = head.Pos
						view.angles = head.Ang
					end
					view.fov = fov
					view.drawviewer = true
					return view
				end
			end
			hook.Add( "CalcView", "FirstPersonScene_NPC"..client:SteamID(), FirstPersonScene_NPC )

		end

	end

end
net.Receive("FirstPerson_NPC", FPCutScene_NPC)

function shrinkbones(bone)
	for k, v in pairs(LocalPlayer():GetChildBones(bone)) do
		shrinkbones(v) --Should stop when table is empty
	end
	if not shrunkbones[bone] then
		shrunkbones[bone] = LocalPlayer():GetManipulateBoneScale(bone)
	end
	LocalPlayer():ManipulateBoneScale(bone, Vector(0, 0, 0))
end

SetGlobalBool("OverrideFog", false)
SetGlobalInt("FogStart", 256)
SetGlobalInt("FogEnd", 1024)
SetGlobalInt("Fog_R", 96)
SetGlobalInt("Fog_G", 47)
SetGlobalInt("Fog_B", 0)

function GM:SetupWorldFog()
    if OUTSIDE_BUFF and OUTSIDE_BUFF( LocalPlayer():GetPos() ) then

        if GetGlobalBool("Scarlet_King_Scarlet_Skybox", false) then
            render.FogMode( MATERIAL_FOG_LINEAR )
            render.FogColor( 20, 0, 0 )
            render.FogStart( 100 )
            render.FogEnd( 2000 )
            render.FogMaxDensity( 0.98 )
            return true
        end
    end

    if GetGlobalBool("OverrideFog") then
        render.FogMode(1)
        render.FogStart(GetGlobalInt("FogStart", 0))
        render.FogEnd(GetGlobalInt("FogEnd", 0))
        render.FogColor(GetGlobalInt("Fog_R", 0), GetGlobalInt("Fog_G", 0), GetGlobalInt("Fog_B", 0), 255)
        render.FogMaxDensity(1)
        return true
    end
end

CreateMaterial( "apc_interior_nocolor", "VertexLitGeneric", {
  ["$basetexture"] = "models/chaos_jeep/interior_light_and_colour",
  ["$model"] = 1,
  ["$translucent"] = 1,
  ["$vertexalpha"] = 1,
  ["$vertexcolor"] = 1
} )

local apclights = {
	Vector(15206.360351563, 12782.16796875, -15619.75390625),
	Vector(15200.668945313, 12871.985351563, -15620.077148438),
	Vector(15287.80859375, 12870.5234375, -15622.7421875),
	Vector(15284.715820313, 12776.360351563, -15621.188476563),
	Vector(15186.146484375, 12822.694335938, -15619.131835938),
}

function APC_spawn_CI_Cutscene()
	local apc = ClientsideModel("models/scp_chaos_jeep/chaos_jeep.mdl")
	apc:Spawn()
	apc:SetPos(Vector(15200.626953125, 12824.885742188, -15706.223632813))
	apc:SetAngles(Angle(0.000, -180.000, 0.000))

	apc:SetSubMaterial(5, "!apc_interior_nocolor")

	sound.PlayFile( "sound/rxsend/sup_spawn/snow_ambient.mp3", "3d", function( station, errCode, errStr )
		if ( IsValid( station ) ) then
			station:SetPos(apc:GetPos())
			station:SetVolume(0.1)
			station:Play()
		end
	end )

	hook.Add("Think", "APC_spawn_CI_Cutscene", function()
		for i = 1, #apclights do
			local dlight = DynamicLight( LocalPlayer():EntIndex()+i )
			if ( dlight ) then
				dlight.pos = apclights[i]
				dlight.r = 35
				dlight.g = 50
				dlight.b = 35
				dlight.brightness = 2
				dlight.decay = 1000
				dlight.size = 256
				dlight.dietime = CurTime() + 1
			end
		end
	end)

	timer.Simple(32, function() apc:Remove() hook.Remove("Think", "APC_spawn_CI_Cutscene") end)
end

function FPCutScene_NPC_Action()

	local npc = net.ReadEntity()

	local client = LocalPlayer()

	if CLIENT then

		if client then
			
			local function FirstPersonScene_NPC_Action(ply, pos, angles, fov)
				if ply then
					local view = {}
					local head = npc:GetAttachment( npc:LookupAttachment( "eyes" ) )
					if head then

						view.origin = head.Pos + Vector(-1, -2, 0)
						view.angles = ply:EyeAngles()

						shrinkbones(ply:LookupBone("ValveBiped.Bip01_Head1") or 6)

						
					end
					view.fov = fov
					view.drawviewer = true
					return view
				end
			end
			hook.Add( "CalcView", "FirstPersonScene_NPC_Action"..client:SteamID(), FirstPersonScene_NPC_Action )

		end

	end

end
net.Receive("FirstPerson_NPC_Action", FPCutScene_NPC_Action)

function restorebones()
	for bone, vec in pairs(shrunkbones) do
		LocalPlayer():ManipulateBoneScale(bone, vec)
		shrunkbones[bone] = nil
	end
end

function FPRemove()

	local client = LocalPlayer()

	if CLIENT then

		if client then
			
			hook.Remove("CalcView", "FirstPersonScene"..client:SteamID())
			hook.Remove("CalcView", "FirstPersonScene_NPC"..client:SteamID())
			hook.Remove("CalcView", "FirstPersonScene_NPC_Action"..client:SteamID())


			restorebones()

		end

	end
end
net.Receive("FirstPerson_Remove", FPRemove)

local playerMeta = FindMetaTable( "Player" )

local light_pos = Vector( -1980.416382, 4980.730469, 1727.394287 )
net.Receive( "StartCIScene", function()

	local caller = LocalPlayer()

	local dlight = DynamicLight( caller:EntIndex() )

	if ( dlight ) then

		dlight.pos = light_pos
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.brightness = 2
		dlight.Decay = 1000
		dlight.Size = 980
		dlight.DieTime = CurTime() + 10

	end

	StartSceneClientSide( caller )

end )


function ClientBoneMerge( ent, model )
    local bonemerge_ent = ents.CreateClientside("breach_bonemerge")
    bonemerge_ent:SetModel(model)
    bonemerge_ent:SetSkin(ent:GetSkin() or 0)
    bonemerge_ent:Spawn()
    bonemerge_ent:SetParent(ent, 0)
    bonemerge_ent:SetLocalPos(vector_origin)
    bonemerge_ent:SetLocalAngles(angle_zero)
    bonemerge_ent:AddEffects(EF_BONEMERGE)
    if not ent.BoneMergedEnts then ent.BoneMergedEnts = {} end
    ent.BoneMergedEnts[#ent.BoneMergedEnts + 1] = bonemerge_ent
end

function HedwigAbility()
	local client = LocalPlayer()
	if !client:HaveSpecialAb(role.SCI_SPECIAL_VISION) then return end
	hook.Remove( "PostDrawTranslucentRenderables", "Hedwig_Ability" )

    clr_red = .08
    clr_green = .08
    clr_blue = .08

    local hedwigdietime = CurTime() + 20

    hook.Add( "PostDrawTranslucentRenderables", "Hedwig_Ability", function()

      local client = LocalPlayer()

      local playerpos = client:GetPos()
      local eyespos = client:EyePos() + client:EyeAngles():Forward() * 8
      local eyeang = client:EyeAngles()
      eyeang = Angle( eyeang.p + 90, eyeang.y, 0 )
      if hedwigdietime < CurTime() then hook.Remove( "PostDrawTranslucentRenderables", "Hedwig_Ability" ) end
      render.ClearStencil()

      render.SetStencilEnable( true )

        render.SetStencilWriteMask( 255 )
        render.SetStencilTestMask( 255 )
        render.SetStencilReferenceValue( 1 )

        for _, ent in player.Iterator() do

          if ( ent:IsPlayer() || ent:IsNPC() ) then

            if ( ent == client ) then

              if ( ent:Health() <= 0 || !ent:HaveSpecialAb(role.SCI_SPECIAL_VISION) ) then

                hook.Remove( "PostDrawTranslucentRenderables", "Hedwig_Ability" )

                return
              end

            else

              local current_team = ent:IsPlayer() && ent:GTeam()

              if ( ent:IsPlayer() && current_team == TEAM_SPEC ) then continue end

              if ( current_team == TEAM_SCP && !ent:IsSolid() ) then continue end
              if current_team != TEAM_SCP then continue end
              if ent:IsPlayer() and ent:Health() <= 0 then continue end
              if ent:IsPlayer() and !ent:Alive() then continue end

              render.SetStencilCompareFunction( STENCIL_ALWAYS )
              render.SetStencilZFailOperation( STENCIL_REPLACE )

              render.SetStencilPassOperation( STENCIL_REPLACE )
              render.SetStencilFailOperation( STENCIL_KEEP )
              ent:DrawModel()

              local tbl_bonemerged = ents.FindByClassAndParent( "breach_bonemerge", ent )

              if ( tbl_bonemerged && istable( tbl_bonemerged ) ) then

                for _, v in ipairs( tbl_bonemerged ) do

                  if ( v && v:IsValid() ) then

                    v:DrawModel()

                  end

                end

              end

              render.SetStencilCompareFunction( STENCIL_EQUAL )
              render.SetStencilZFailOperation( STENCIL_KEEP )
              render.SetStencilPassOperation( STENCIL_KEEP )
              render.SetStencilFailOperation( STENCIL_KEEP )

              cam.Start3D2D( eyespos, eyeang, 1 )
              
                surface.SetDrawColor( 255, 0, 0, 80 )
                surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

              cam.End3D2D()

            end

          end

        end

        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )

      render.SetStencilEnable( false )
    end)
end

function StartSceneClientSide( ply )

	local character = ents.CreateClientside( "base_gmodentity" )
	character:SetPos( Vector( -1981.652466, 5217.017090, 1459.548218 ) )
	character:SetAngles( Angle( 0, -90, 0 ) )
	character:SetModel( "models/cultist/humans/class_d/class_d.mdl" )
	character:Spawn()
	character:SetSequence( "photo_react_blind" )
	character:SetCycle( 0 )
	character:SetPlaybackRate( 1 )
	character.AutomaticFrameAdvance = true
	local cycle = 0
	character.Think = function( self )

		self:NextThink( CurTime() )
		self:SetCycle( math.Approach( cycle, 1, FrameTime() * 0.2 ) )
		cycle = self:GetCycle()
		return true

	end

	ply.InCutscene = true

	ply:SetNWEntity("NTF1Entity", character)

	local CI = ents.CreateClientside("base_gmodentity")
	CI:SetPos(Vector(-1983.983765, 4951.116211, 1459.224365))
	CI:SetAngles(Angle(0, 90, 0))
	CI:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI:SetMoveType(MOVETYPE_NONE)
    CI:SetBodygroup( 0, 0 )
    CI:SetBodygroup( 1, 1 )
	CI:Spawn()
	CI:SetColor( color_black )
	CI:SetSequence("LineIdle02")
	CI:SetPlaybackRate(1)
	CI.OnRemove = function( self )

		if ( self.BoneMergedEnts ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end

	ClientBoneMerge( CI, "models/cultist/humans/chaos/head_gear/beret.mdl" )
	ClientBoneMerge( CI, "models/cultist/humans/balaclavas_new/balaclava_full.mdl" )

	local handsid = CI:LookupAttachment('anim_attachment_RH')
	local hands = CI:GetAttachment( handsid )

	timer.Simple( 0.1, function()

		util.ScreenShake( vector_origin, 200, 100, 10, 355);

		LocalPlayer():ScreenFade(SCREENFADE.IN, color_white, 1, 1.2)

		LocalPlayer():EmitSound( "nextoren/others/bell.ogg" )

		--LocalPlayer():EmitSound( "nextoren/others/ending.ogg" )
	
	end )

	timer.Simple( 1, function()

	LocalPlayer():EmitSound( "nextoren/others/ending.ogg" )
	
	end )

	timer.Simple( 5, function()

		CI:EmitSound( "nextoren/vo/chaos/class_d_alternate_ending.ogg" )

	end )

	timer.Simple( 9, function()
		LocalPlayer():ScreenFade(SCREENFADE.IN, color_white, 1, 1.2)
		LocalPlayer():EmitSound( "nextoren/others/bell.ogg" )
	end )


	CI.AutomaticFrameAdvance = true


	CI.Think = function( self )

		self.NextThink = ( CurTime() )
		if ( self:GetCycle() >= 0.01 ) then self:SetCycle( 0.01 ) end

	end

	local cycle3 = 0
	local CI2 = ents.CreateClientside("base_gmodentity")
	CI2:SetPos(Vector(-1960.850830, 4894.328613, 1459.702515))
	CI2:SetAngles(Angle(0, 94, 0))
	CI2:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI2:SetMoveType(MOVETYPE_NONE)
	CI2:Spawn()
	CI2:SetColor( color_black )
	CI2:SetBodygroup( 0, 1 )
    CI2:SetBodygroup( 1, 0 )
    CI2:SetBodygroup( 2, 1 )
    CI2:SetBodygroup( 4, 0 )
	CI2:SetBodygroup( 5, 0 )
	CI2:SetSequence( "AHL_menuidle_SHOTGUN" )
	CI2:SetPlaybackRate( 1 )
	ClientBoneMerge( CI2, "models/cultist/humans/balaclavas_new/balaclava_full.mdl" )
	ClientBoneMerge( CI2, "models/cultist/humans/chaos/head_gear/helmet.mdl" )
	local handsid2 = CI2:LookupAttachment('anim_attachment_RH')
	local hands2 = CI2:GetAttachment( handsid )
	CI2.AutomaticFrameAdvance = true
	CI2.OnRemove = function( self )

		if ( self.BoneMergedEnts ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end


	local Weapon2 = ents.CreateClientside("base_gmodentity")
	Weapon2:SetModel("models/weapons/w_cw_kk_ins2_rpk_tac.mdl")
	Weapon2:SetPos(hands2.Pos)
	Weapon2:SetAngles(Angle(0,90,0))
	Weapon2:SetMoveType(MOVETYPE_NONE)
	Weapon2:Spawn()

    CI2.Think = function(self)
		if !CI2:IsValid() then return end
		self:NextThink( CurTime() )

		local handsid7 = CI2:LookupAttachment('anim_attachment_RH')
		local hands7 = CI2:GetAttachment( handsid )
        Weapon2:SetPos(hands7.Pos + Vector( 0, 8, 0 ) )
		self:SetCycle( math.Approach( cycle3, 1, FrameTime() * 0.15 ) )
		cycle3 = self:GetCycle()


		--CI2:SetPos(Vector(currentpos.x - 0.5, currentpos.y + 8, currentpos.z))



	end
	local cycle2 = 0
	local CI3 = ents.CreateClientside("base_gmodentity")
	CI3:SetPos(Vector(-2012.675903, 4894.200195, 1459.009277))
	CI3:SetAngles(Angle(0, 70, 0))
	CI3:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI3:SetMoveType(MOVETYPE_NONE)
	CI3:Spawn()
	CI3:SetBodygroup( 0, 1 )
    CI3:SetBodygroup( 1, 0 )
    CI3:SetBodygroup( 2, 1 )
    CI3:SetBodygroup( 4, 0 )
	CI3:SetBodygroup( 5, 0 )
	CI3:SetColor( color_black )
	CI3:SetSequence("MPF_adooridle")
	CI3:SetPlaybackRate(1)
	local handsid3 = CI3:LookupAttachment('anim_attachment_RH')
	local hands3 = CI3:GetAttachment( handsid )
	ClientBoneMerge( CI3, "models/cultist/humans/balaclavas_new/balaclava_full.mdl" )
	ClientBoneMerge( CI3, "models/cultist/humans/chaos/head_gear/helmet.mdl" )

	CI3.AutomaticFrameAdvance = true
	CI3.OnRemove = function( self )

		if ( self.BoneMergedEnts && istable( self.BoneMergedEnts ) ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end

	CI3.Think = function(self)

		self:NextThink( CurTime() )
		self:SetCycle( math.Approach( cycle2, 1, FrameTime() * 0.2 ) )
		cycle2 = self:GetCycle()


	end
	local Weapon3 = ents.CreateClientside("base_gmodentity")
	Weapon3:SetModel("models/weapons/w_cw_kk_ins2_rpk_tac.mdl")
	Weapon3:SetPos(hands3.Pos)
	Weapon3:SetAngles(Angle(0,80,0))
	Weapon3:SetMoveType(MOVETYPE_NONE)
	Weapon3:Spawn()


    timer.Simple( 11, function()

        Weapon2:Remove()
        Weapon3:Remove()
        CI:Remove()
        CI2:Remove()
        CI3:Remove()
		ply.InCutscene = false
		character:Remove()
		ply:SetNWEntity("NTF1Entity", NULL)

    end )

end
concommand.Add("CI_Anim_Escsp", StartSceneClientSide)

local EntMats = {}
net.Receive( "NightvisionOn", function()

  local stype = net.ReadString()

  local clr_red, clr_green, clr_blue = 255, 255, 255
  local dodynamic = false
  local contrastv = 1

  local client = LocalPlayer()

  if ( stype == "green" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionWhite" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionGoc" )
    clr_red = 0
    clr_green = .01
    clr_blue = 0

  elseif ( stype == "red" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionWhite" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionGoc" )

    clr_red = .3
    clr_green = 0
    clr_blue = 0
    contrastv = 0.6
    hook.Add( "PostDrawTranslucentRenderables", "ThermalVisionRed", function()

      local client = LocalPlayer()

      local playerpos = client:GetPos()
      local eyespos = client:EyePos() + client:EyeAngles():Forward() * 8
      local eyeang = client:EyeAngles()
      eyeang = Angle( eyeang.p + 90, eyeang.y, 0 )
      render.ClearStencil()

      render.SetStencilEnable( true )

        render.SetStencilWriteMask( 255 )
        render.SetStencilTestMask( 255 )
        render.SetStencilReferenceValue( 1 )

        for _, ent in ipairs( ents.FindInSphere( client:GetPos(), 1024 ) ) do

          if ( ent:IsPlayer() || ent:IsNPC() ) then

            if ( ent == client ) then

              if ( ent:Health() <= 0 || !ent.NVG || !ent:HasWeapon( "item_nightvision_red" ) ) then

                hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )

                return
              end

            else

              local current_team = ent:IsPlayer() && ent:GTeam()

              if ( ent:GetPos():DistToSqr( playerpos ) > 1048576 || current_team == TEAM_SPEC ) then continue end

              if ( current_team == TEAM_SCP && !ent:IsSolid() ) then continue end
              if ent:IsPlayer() and ent:Health() <= 0 then continue end
              if ent:IsPlayer() and !ent:Alive() then continue end

              render.SetStencilCompareFunction( STENCIL_ALWAYS )
              render.SetStencilZFailOperation( STENCIL_REPLACE )

              render.SetStencilPassOperation( STENCIL_REPLACE )
              render.SetStencilFailOperation( STENCIL_KEEP )
              ent:DrawModel()

              local tbl_bonemerged = ents.FindByClassAndParent( "breach_bonemerge", ent )

              if ( tbl_bonemerged && istable( tbl_bonemerged ) ) then

                for _, v in ipairs( tbl_bonemerged ) do

                  if ( v && v:IsValid() ) then

                    v:DrawModel()

                  end

                end

              end

              render.SetStencilCompareFunction( STENCIL_EQUAL )
              render.SetStencilZFailOperation( STENCIL_KEEP )
              render.SetStencilPassOperation( STENCIL_KEEP )
              render.SetStencilFailOperation( STENCIL_KEEP )

              cam.Start3D2D( eyespos, eyeang, 1 )

                surface.SetDrawColor( 170, 170, 170 )
                surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

              cam.End3D2D()

            end

          end

        end

        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )

        cam.Start3D2D( eyespos, eyeang, 1 )

          surface.SetDrawColor( 0, 0, 0, 240 )
          surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

        cam.End3D2D()

      render.SetStencilEnable( false )

    end )

  elseif ( stype == "blue" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionWhite" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionGoc" )
    clr_red = 0
    clr_green = 0
    clr_blue = .04
    dodynamic = true

  elseif ( stype == "white" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )

    clr_red = .02
    clr_green = .02
    clr_blue = .02
    dodynamic = true

    hook.Add( "PostDrawTranslucentRenderables", "ThermalVisionWhite", function()

      local client = LocalPlayer()

      local playerpos = client:GetPos()
      local eyespos = client:EyePos() + client:EyeAngles():Forward() * 8
      local eyeang = client:EyeAngles()
      eyeang = Angle( eyeang.p + 90, eyeang.y, 0 )
      render.ClearStencil()

      render.SetStencilEnable( true )

        render.SetStencilWriteMask( 255 )
        render.SetStencilTestMask( 255 )
        render.SetStencilReferenceValue( 1 )

        for _, ent in ipairs( ents.FindInSphere( client:GetPos(), 1024 ) ) do

          if ( ent:IsPlayer() || ent:IsNPC() ) then

            if ( ent == client ) then

              if ( ent:Health() <= 0 || !ent.NVG || !ent:HasWeapon( "item_nightvision_white" ) ) then

                hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionWhite" )

                return
              end

            else

              local current_team = ent:IsPlayer() && ent:GTeam()

              if ( !client:CanSee( ent ) || ent:IsPlayer() && current_team == TEAM_SPEC ) then continue end

              if ( current_team == TEAM_SCP && !ent:IsSolid() ) then continue end
              if ent:IsPlayer() and ent:Health() <= 0 then continue end
              if ent:IsPlayer() and !ent:Alive() then continue end
              if ent:GetModel():find("goc") then continue end

              render.SetStencilCompareFunction( STENCIL_ALWAYS )
              render.SetStencilZFailOperation( STENCIL_REPLACE )

              render.SetStencilPassOperation( STENCIL_REPLACE )
              render.SetStencilFailOperation( STENCIL_KEEP )
              ent:DrawModel()

              local tbl_bonemerged = ents.FindByClassAndParent( "breach_bonemerge", ent )

              if ( tbl_bonemerged && istable( tbl_bonemerged ) ) then

                for _, v in ipairs( tbl_bonemerged ) do

                  if ( v && v:IsValid() ) then

                    v:DrawModel()

                  end

                end

              end

              render.SetStencilCompareFunction( STENCIL_EQUAL )
              render.SetStencilZFailOperation( STENCIL_KEEP )
              render.SetStencilPassOperation( STENCIL_KEEP )
              render.SetStencilFailOperation( STENCIL_KEEP )

              cam.Start3D2D( eyespos, eyeang, 1 )
              
                surface.SetDrawColor( 255, 0, 0, 80 )
                surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

              cam.End3D2D()

            end

          end

        end

        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )

      render.SetStencilEnable( false )

    end )

  elseif ( stype == "GOC" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )

    clr_red = .08
    clr_green = .08
    clr_blue = .08

    hook.Add( "PostDrawTranslucentRenderables", "ThermalVisionGoc", function()

      local client = LocalPlayer()

      local clientteam = client:GTeam()
      local playerpos = client:GetPos()
      local eyespos = client:EyePos() + client:EyeAngles():Forward() * 8
      local eyeang = client:EyeAngles()
      eyeang = Angle( eyeang.p + 90, eyeang.y, 0 )
      render.ClearStencil()

      render.SetStencilEnable( true )

        render.SetStencilWriteMask( 255 )
        render.SetStencilTestMask( 255 )
        render.SetStencilReferenceValue( 1 )

        for _, ent in ipairs( ents.FindInSphere( client:GetPos(), 1024 ) ) do

          if ( ent:IsPlayer() || ent:IsNPC() ) then

            if ( ent == client ) then

              if ( ent:Health() <= 0 || !ent.NVG || !ent:HasWeapon( "item_nightvision_goc" ) ) then

                hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionGoc" ) --"ThermalVisionWhite" )

                return
              end

            else

              local current_team = ent:IsPlayer() && ent:GTeam()

              if ( !client:CanSee( ent ) || ent:IsPlayer() && current_team == TEAM_SPEC ) then continue end

              if ( current_team == TEAM_SCP && !ent:IsSolid() ) then continue end
              if ent:IsPlayer() and ent:Health() <= 0 then continue end
              if ent:IsPlayer() and !ent:Alive() then continue end

              local entcolor = {255,0,0, 8}
              if ent:GetModel():find("goc.mdl") or ( current_team == TEAM_GOC and clientteam == TEAM_GOC ) then
              	entcolor = {0, 255, 0, 80}
              end

              render.SetStencilCompareFunction( STENCIL_ALWAYS )
              render.SetStencilZFailOperation( STENCIL_REPLACE )

              render.SetStencilPassOperation( STENCIL_REPLACE )
              render.SetStencilFailOperation( STENCIL_KEEP )
              ent:DrawModel()

              local tbl_bonemerged = ents.FindByClassAndParent( "breach_bonemerge", ent )

              if ( tbl_bonemerged && istable( tbl_bonemerged ) ) then

                for _, v in ipairs( tbl_bonemerged ) do

                  if ( v && v:IsValid() ) then

                    v:DrawModel()

                  end

                end

              end

              render.SetStencilCompareFunction( STENCIL_EQUAL )
              render.SetStencilZFailOperation( STENCIL_KEEP )
              render.SetStencilPassOperation( STENCIL_KEEP )
              render.SetStencilFailOperation( STENCIL_KEEP )

              cam.Start3D2D( eyespos, eyeang, 1 )
	            surface.SetDrawColor( unpack(entcolor) )--surface.SetDrawColor( 255, 0, 0, 80 )
                surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

              cam.End3D2D()

            end

          end

        end

        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )

      render.SetStencilEnable( false )

    end )

  end

  client.NVG = true
  client.CustomRenderHook = true

  local mat_colornvg = Material( "pp/colour" ) -- used outside of the hook for performance
  local red_spell = Material( "redspell.png" )

  hook.Add( "RenderScreenspaceEffects", "NVGOverlayplusligthing", function()

    local client = LocalPlayer()

    if ( !client["NVG"] || !( client:HasWeapon( "item_nightvision_red" ) || client:HasWeapon( "item_nightvision_white" ) || client:HasWeapon("item_nightvision_goc") || client:HasWeapon( "item_nightvision_blue" ) || client:HasWeapon( "item_nightvision_green" ) ) ) then

      clr_red = 0
      clr_green = 0
      clr_blue = 0
      client["CustomRenderHook"] = nil
      hook.Remove( "RenderScreenspaceEffects", "NVGOverlayplusligthing" )

      return
    end

    --[[DrawMaterialOverlay( "nextoren/nvg/drg_nvg.vmt", 0 )
    DrawMaterialOverlay( "nextoren/nvg/drg_nvg2.vmt", 0 )
    DrawMaterialOverlay( "nextoren/nvg/drg_nvg_goggle.vmt", 0 )
    DrawMaterialOverlay( "models/props_c17/fisheyelens.vmt", 0.04 )]]

    if ( clr_red == .5 ) then

      DrawTexturize( 0, red_spell )

    end

    local dark = 0.01
    local contrast = 12
    local colour = contrastv
    local nvgbrightness = 0
    local clr_r = 0
    local clr_g = 0
    local clr_b = 0
    local bloommul = 1.2
    local add_r = clr_red
    local add_b = clr_blue
    local add_g = clr_green

    if dodynamic then
	    local dlight = DynamicLight( LocalPlayer():EntIndex() )
		if ( dlight ) then
			dlight.pos = LocalPlayer():GetShootPos()
			dlight.r = clr_red*10*255
			dlight.g = clr_green*10*255
			dlight.b = clr_blue*10*255
			dlight.brightness = 0.4
			dlight.Decay = 1000
			dlight.Size = 555
			dlight.DieTime = CurTime() + 1
		end
	end

    render.UpdateScreenEffectTexture()

    mat_colornvg:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

    mat_colornvg:SetFloat( "$pp_colour_contrast", contrast )
    mat_colornvg:SetFloat( "$pp_colour_colour", colour )
    mat_colornvg:SetFloat( "$pp_colour_brightness", dark )
    mat_colornvg:SetFloat( "$pp_colour_mulr", clr_r )
    mat_colornvg:SetFloat( "$pp_colour_mulg", clr_g )
    mat_colornvg:SetFloat( "$pp_colour_mulb", clr_b )
    mat_colornvg:SetFloat( "$pp_colour_addr", add_r )
    mat_colornvg:SetFloat( "$pp_colour_addg", add_g )
    mat_colornvg:SetFloat( "$pp_colour_addb", add_b )

    render.SetMaterial( mat_colornvg )
    render.DrawScreenQuad()

  end )

end )

--timer.Create("ADVERT_NABOR_", 300, 0, function()

	--[[if LocalPlayer().GTeam and LocalPlayer():GTeam() == TEAM_SPEC then
		chat.AddText(Color(0,0,255), "[NextOren] ", color_white, "Идет набор на админа, если желаете стать админом то напишите заявку")
	end]]

--end)

local view_punch_angle = Angle( -30, 0, 0 )
local dust_vector = Vector( -712.862427, 6677.729492, 2225.919189 )
local particle_origin = Vector( -525.942322, -6318.510742, -2352.465820 )

net.Receive( "ChangeRunAnimation", function()

  local ent = net.ReadEntity()
  local animation = net.ReadString()
  animation = ent:LookupSequence( animation )

  if ( !isnumber( animation ) ) then return end

  ent.SafeRun = animation

end )

net.Receive("Boom_Effectus", function()

	local player = LocalPlayer()

    util.ScreenShake( vector_origin, 200, 10, 20, 32768 );

    ParticleEffect( "vman_nuke", dust_vector, angle_zero );
    ParticleEffect( "vman_nuke", particle_origin, angle_zero );

    timer.Simple(7, function()

    	if player:GTeam() != TEAM_SPEC and player:Health() > 0 then
          player:ViewPunch( view_punch_angle )
        end

    end)

    timer.Simple(5, function()

      ParticleEffect( "dustwave_tracer", dust_vector, angle_zero );

    end)

    timer.Simple(5, function()

	    util.ScreenShake( vector_origin, 200, 100, 10, 32768);

	    player:ScreenFade( SCREENFADE.OUT, color_black, 2.3, 10 )

	    timer.Simple(4, function()
	    	player.no_signal = true
	    end)

    end)

end)

net.Receive( "NightvisionOff", function()

  LocalPlayer().NVG = false

end )

net.Receive("GestureClientNetworking", function()
    local gesture_ent = net.ReadEntity()
    if not IsValid(gesture_ent) then return end

    local gesture = net.ReadString()
    local gesture_slot = net.ReadUInt(3)
    local loop = net.ReadBool()
    local cycle = net.ReadFloat()
    local gesture_id = gesture_ent:LookupSequence(gesture)

    if gesture:StartWith("hg_") then
        gesture_ent.talkedrecently = CurTime() + gesture_ent:SequenceDuration(gesture_id)
    end

    gesture_ent:AnimResetGestureSlot(gesture_slot)
    gesture_ent:AddVCDSequenceToGestureSlot(gesture_slot, gesture_id, cycle, loop)

    local duration = gesture_ent:SequenceDuration(gesture_id)

    if gesture:find("0_shaky_") then
        duration = 3
	end

    timer.Simple(duration, function()
        if not IsValid(gesture_ent) then return end

        local w = 1
        local uniqueid = "weight_lerp"..gesture_ent:SteamID64()..gesture_slot

        timer.Create(uniqueid, 0.01, 0, function()
            if not IsValid(gesture_ent) or w <= 0 then
                timer.Remove(uniqueid)
                gesture_ent:AnimResetGestureSlot(gesture_slot)
                return
            end

            w = math.max(w - 0.1, 0)
            gesture_ent:AnimSetGestureWeight(gesture_slot, w)
        end)
    end)
end)
  
net.Receive( "StopGestureClientNetworking", function()
  local gesture_ent = net.ReadEntity()

  if ( !( gesture_ent && gesture_ent:IsValid() ) ) then return end

  local gesture_slot = net.ReadUInt( 3 )

  gesture_ent:AnimResetGestureSlot( gesture_slot )

end)

SAVEDIDS = {}
lastidcheck = 0

--buttonstatus = "rough"

clang = clang || nil
cwlang = cwlang || nil

-- local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA" )
-- for k,v in pairs(files) do
-- 	local path = "languages/"..v
-- 	if string.Right(v, 3) == "lua" and string.Left(v, 3) != "wep" then
-- 		include( path )
-- 		print("Loading language: " .. path)
-- 	end
-- end

-- local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/wep_*.lua", "LUA" )
-- for k,v in pairs(files) do
-- 	local path = "languages/"..v
-- 	if string.Right(v, 3) == "lua" then
-- 		include( path )
-- 		print("Loading weapon lang file: " .. path)
-- 	end
-- end

--langtouse = CreateClientConVar( "cvar_br_language", "english", true, false ):GetString()

local gmod_built_language = "english" -- default lang

local langtable = {
	["ru"] = "russian",
	["zh-CN"] = "chinese",
	["uk"] = "ukraine",
}

local lang_cvar = GetConVar("gmod_language"):GetString()

if langtable[lang_cvar] then
	gmod_built_language = langtable[lang_cvar]
end

CreateClientConVar("cvar_br_language", gmod_built_language, true, true, "Breach localization setting")
langtouse = GetConVar("cvar_br_language"):GetString()

cvars.AddChangeCallback( "cvar_br_language", function( convar_name, value_old, value_new )
	langtouse = value_new
	LoadLang( langtouse )
end )

hook.Add("PostPlayerDraw", "fire_effect_draw", function(self)

	if ( !self:GetNWBool("FireParticles", false) ) and self.NextParticleUpdate then
		self.NextParticleUpdate = nil
		self:StopParticles()
	elseif ( ( self.NextParticleUpdate || 0 ) < CurTime() ) and self:GetNWBool("FireParticles", false) then


    self.NextParticleUpdate = CurTime() + 2

    self:StopParticles()
    ParticleEffectAttach( "fire_small_03", PATTACH_POINT_FOLLOW, self, 2 )

  end

end)


concommand.Add( "br_language", function( ply, cmd, args )
	RunConsoleCommand( "cvar_br_language", args[1] )
end, function( cmd, args )
	args = string.Trim( args )
	args = string.lower( args )

	local tab = {}

	for k, v in pairs( ALLLANGUAGES ) do
		if string.find( string.lower( k ), args ) then
			table.insert( tab, "br_language "..k )
		end
	end

	return tab
end, "Sets language", FCVAR_ARCHIVE )

hudScale = CreateClientConVar( "br_hud_scale", 1, true, false ):GetFloat()

cvars.AddChangeCallback( "br_hud_scale", function( convar_name, value_old, value_new )
	local newScale = tonumber(value_new)
	if newScale > 1 then newScale = 1 end
	if newScale < 0.1 then newScale = 0.1 end
	hudScale = newScale
end )

//print("Alllangs:")
//PrintTable(ALLLANGUAGES)

function AddTables( tab1, tab2 )
	for k, v in pairs( tab2 ) do
		if tab1[k] and istable( v ) then
			AddTables( tab1[k], v )
		else
			tab1[k] = v
		end
	end
end



local EntMats = {}

net.Receive( "GasMaskOff", function ( len ) 
    local ent = net.ReadEntity()

	ent.GasMask = false

end)

net.Receive( "GasMaskOn", function ( len )
	local ent = net.ReadEntity()

	ent.GasMask = true

	hook.Add("HUDPaintBackground", "GasMaskHUD", function()
		local client = LocalPlayer()

		if client:GTeam() == TEAM_SPEC or !client:Alive() or client && client:IsValid() && !client.GasMask then
			hook.Remove("HUDPaintBackground", "GasMaskHUD")
	  
		end

	    local function GASMASK_FOV( num ) // calculates the camera FOV depending on viewmodel FOV
		    local r = ScrW() / ScrH() // our resolution
		    r =  r / (4/3) // 4/3 is base Source resolution, so we have do divide our resolution by that
		    local tan, atan, deg, rad = math.tan, math.atan, math.deg, math.rad
		
		    local vFoV = rad(num)
		    local hFoV = deg( 2 * atan(tan(vFoV/2)*r) ) // this was a bitch
		
		    return hFoV
	    end

	    local pos, ang = EyePos(), EyeAngles()
	    local camFOV = GASMASK_FOV(60)
	    local scrw, scrh = ScrW(), ScrH()	
	    local FT = FrameTime()

		if !client.GASMASK_HudModel2 or !IsValid(client.GASMASK_HudModel2) then
			client.GASMASK_HudModel2 = ClientsideModel("models/gmod4phun/c_contagion_gasmask.mdl", RENDERGROUP_BOTH)
			client.GASMASK_HudModel2:SetNoDraw(true)
		end

	    cam.Start3D( pos, ang, camFOV, 0, 0, scrw, scrh, 1, 100)
	        cam.IgnoreZ(false)
		        render.SuppressEngineLighting( false )
				    client.GASMASK_HudModel2:ResetSequence("idle_on", true)
				    client.GASMASK_HudModel2:SetCycle(0)
				    client.GASMASK_HudModel2:SetPlaybackRate(1)
			        client.GASMASK_HudModel2:SetPos(pos)
			        client.GASMASK_HudModel2:SetAngles(ang)
			        client.GASMASK_HudModel2:FrameAdvance(FT)
			        client.GASMASK_HudModel2:SetupBones()
			        if client:GetViewEntity() == client then
				        client.GASMASK_HudModel2:DrawModel()
			        end
		        render.SuppressEngineLighting( false )
	        cam.IgnoreZ(false)
        cam.End3D()
	end)

end)

local desc_clr_gray = Color( 198, 198, 198 )

local outcomeResult = {
	[ "l:roundend_alphawarheadgoc" ] = { image = "nextoren/gui/roles_icon/goc.png", music = "sound/no_music/misc/goc_won.ogg" },
	[ "l:roundend_scarletking" ] = { image = "nextoren/gui/roles_icon/scarlet.png" }
}

function EndRoundStats()
	local timeout = GetTimeoutInfo()

	if !timeout and BREACH.ResourcesPrecached then
		if engine.IsRecordingDemo() then
			AresNotify("l:demo_stop")
			RunConsoleCommand("stop")
		end
		if !engine.IsRecordingDemo() then
			RunConsoleCommand("record", "1")
			timer.Simple(1, function()
				RunConsoleCommand("stop")
			end)
		end
	end

	local result = net.ReadString()

	local t_restart = net.ReadFloat()

	local client = LocalPlayer()

	local screenwidth, screenheight = ScrW(), ScrH()

	local general_panel = vgui.Create( "DPanel" )
	general_panel:SetText( "" )
	general_panel:SetSize( screenwidth, screenheight )
	general_panel:SetAlpha( 1 )
	general_panel.StartTime = RealTime()
	general_panel.StartFade = false
	timer.Simple( ( t_restart || 27 ) + 1, function()

		FadeMusic( 2 )

		if ( general_panel && general_panel:IsValid() ) then

			general_panel.StartFade = true

		end

	end )

	general_panel.Paint = function( self, w, h )

		if ( self:GetAlpha() < 255 && general_panel.StartTime < RealTime() - .25 && !general_panel.StartFade ) then

			self:SetAlpha( math.Approach( self:GetAlpha(), 255, FrameTime() * 512 ) )

		elseif ( self:GetAlpha() > 0 && general_panel.StartTime < RealTime() - 20 && general_panel.StartFade ) then

			self:SetAlpha( math.Approach( self:GetAlpha(), 0, FrameTime() * 512 ) )

			if ( self:GetAlpha() == 0 && ( self && self:IsValid() ) ) then

				self:Remove()

			end

		end

	end
	local stats_panel = vgui.Create( "DPanel", general_panel )
	stats_panel:SetPos( screenwidth / 2.7, screenheight * .1 )
	stats_panel:SetSize( screenwidth / 4, screenheight / 3 )
	stats_panel:SetText( "" )
	stats_panel.NextSymbol = RealTime()

	local deathstr = false

	if ( !BREACH.Round.Stats || !BREACH.Round.Stats.number ) then

		BREACH.Round.Stats = {}

		BREACH.Round.Stats.number = {

			deaths = "0",
			escaped = "0"

		}

	end

	local s_death = "* "..L"l:roundend_totaldeaths " .. BREACH.Round.Stats.number.deaths
	local s_missing = "* "..L"l:roundend_escaped " .. BREACH.Round.Stats.number.escaped

	local tbl_death = string.Explode( "", s_death, true )
	local tbl_missing = string.Explode( "", s_missing, true )

	local counter = 0
	local counter2 = 0
	local str1 = ""
	local str2 = ""

	BREACH.Round.RoundsTillRestart = GetGlobalInt("RoundUntilRestart", 10)

	local rounds_till_restart = BREACH.Round.RoundsTillRestart

	local restarting = rounds_till_restart < 1

	rounds_till_restart = CurTime() + ( t_restart || 27 )

	local time;

	stats_panel.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, math.Clamp( self:GetAlpha(), 0, 210 ) ) )
		draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( desc_clr_gray, 190 ) )

		if ( restarting ) then

			draw.SimpleText( L"l:roundend_gameover", "MainMenuFontmini_russian", w / 2, 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		else

			draw.SimpleText( L"l:roundend_roundcomplete", "MainMenuFontmini_russian", w / 2, 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end

		draw.SimpleText( L"l:roundend_roundresult " .. L(result), "MainMenuFont_russian", w / 2, 64, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( !restarting ) then

			draw.SimpleText( L"l:roundend_roundstillrestart " .. BREACH.Round.RoundsTillRestart, "MainMenuFontmini_russian", w / 2, h * .8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			time = math.Round( rounds_till_restart - CurTime() )

			if ( time > 0 ) then

				draw.SimpleText( L"l:roundend_nextroundin " .. time, "MainMenuFontmini_russian", w / 2, h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			else

				draw.SimpleText( L"l:roundend_restartinground", "MainMenuFontmini_russian", w / 2, h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end

		else

			time = math.Round( rounds_till_restart - CurTime() )

			if ( time > 0 ) then

				draw.SimpleText( L"l:roundend_restartingserverin " .. math.Round( rounds_till_restart - CurTime() ) .. "...", "MainMenuFontmini_russian", w / 2, h * .8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			else

				draw.SimpleText( L"l:roundend_restartingserver", "MainMenuFontmini_russian", w / 2, h * .8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end

		end

		if ( self.NextSymbol <= RealTime() && !deathstr && str1:len() != #tbl_death ) then

			self.NextSymbol = RealTime() + .1
			counter = counter + 1
			str1 = str1 .. tbl_death[ counter ]

		elseif ( self.NextSymbol <= RealTime() && str2:len() != #tbl_missing ) then

			self.NextSymbol = RealTime() + .1
			counter2 = counter2 + 1
			str2 = str2 .. tbl_missing[ counter2 ]

		end

		surface.SetDrawColor( color_white )
		surface.DrawLine( 0, 48, w, 48 )
		surface.DrawLine( 0, 49, w, 49 )

		--draw.SimpleTextOutlined( str1, "HUDFont", 15, h * .3 + 30, ColorAlpha( color_white, 180 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, ColorAlpha( color_black, 180 ) )
		--draw.SimpleTextOutlined( str2, "HUDFont", 15, h * .3 + 60, ColorAlpha( color_white, 180 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, ColorAlpha( color_black, 180 ) )

	end

	if ( outcomeResult[ result ] ) then

		local faction_img = vgui.Create( "DImage", stats_panel )
		faction_img:SetImage( outcomeResult[ result ].image )
		faction_img:SetSize( 128, 128 )
		faction_img:SetAlpha( 120 )
		local width, height = stats_panel:GetSize()
		faction_img:SetPos( width / 2 - 64, height / 2 - 64 )

		timer.Simple( 8.25, function()

			if ( postround ) and outcomeResult[ result ].music then

				BREACH.Music:Play( outcomeResult[ result ].music )

			end

		end )

	end

end

net.Receive( "New_RoundStatistics", EndRoundStats )

function GM:HUDWeaponPickedUp()
end

net.Receive( "GetBoneMergeTable", function()

	local ent = net.ReadEntity()
	local bonemerge_ent = net.ReadEntity()
  
	if ( !( ent && ent:IsValid() ) ) then return end
  
	if ( !ent.BoneMergedEnts || !istable( ent.BoneMergedEnts ) ) then
  
	  ent.BoneMergedEnts = {}
  
	else
  
	  if ( table.HasValue( ent.BoneMergedEnts, bonemerge_ent ) ) then return end
  
	end
  
	ent.BoneMergedEnts[ #ent.BoneMergedEnts + 1 ] = bonemerge_ent
  
end )

local alpha_color = 0
local final_color = 255
function make_bottom_message(msg)
	msg = BREACH.TranslateString(msg)
	alpha_color = 0
    final_color = 255
    hook.Add( "HUDPaint", "BottomMessage", function()
		alpha_color = math.Approach(alpha_color, final_color, RealFrameTime() * 128)
		if alpha_color == final_color then
			final_color = 0
		end
        draw.SimpleText( msg, "MsgFont", ScrW() / 2, ScrH() / 1.3, Color(130, 130, 130, alpha_color), TEXT_ALIGN_CENTER )
    end )
	
	timer.Remove("SetBottomMessage_Disappear")

    timer.Create( "SetBottomMessage", 5, 1, function()
        hook.Remove( "HUDPaint", "BottomMessage" )
    end )
end
net.Receive( "SetBottomMessage", function()
    local msg = net.ReadString()
    make_bottom_message(msg)
end)

local box_parameters = Vector( 5, 5, 5 )

net.Receive( "ThirdPersonCutscene", function()

  local time = net.ReadUInt( 4 )
  local without_anim = net.ReadBool()

  local client = LocalPlayer()

  client.ExitFromCutscene = nil

  local multiplier = 0

  hook.Add( "CalcView", "ThirdPerson", function( client, pos, angles, fov )

    if ( !client.ExitFromCutscene && multiplier != 1 ) then

      multiplier = math.Approach( multiplier, 1, RealFrameTime() * 2 )

    elseif ( client.ExitFromCutscene ) then

      multiplier = math.Approach( multiplier, 0, RealFrameTime() * 2 )

      if ( multiplier < .25 || without_anim ) then

        hook.Remove( "CalcView", "ThirdPerson" )
        client.ExitFromCutscene = nil

      end

    end

    local offset_eyes = client:LookupAttachment( "eyes" )
    offset_eyes = client:GetAttachment( offset_eyes )

    if ( offset_eyes ) then

      angles = offset_eyes.Ang

    end

    local trace = {}
    trace.start = offset_eyes && offset_eyes.Pos || pos
    trace.endpos = trace.start + angles:Forward() * ( -80 * multiplier )
    trace.filter = client
    trace.mins = -box_parameters
    trace.maxs = box_parameters
    trace.mask = MASK_VISIBLE

    trace = util.TraceLine( trace )

    pos = trace.HitPos

    if ( trace.Hit ) then

      pos = pos + trace.HitNormal * 5

    end

    local view = {}
    view.origin = pos
    view.angles = angles
    view.fov = fov
    view.drawviewer = true

    return view

  end )

  timer.Simple( time, function()

    client.ExitFromCutscene = true

  end )

end )

net.Receive( "ThirdPersonCutscene2", function()

  local time = net.ReadUInt( 4 )
  local without_anim = net.ReadBool()

  local client = LocalPlayer()

  client.ExitFromCutscene = nil

  local multiplier = 0

  hook.Add( "CalcView", "ThirdPerson", function( client, pos, angles, fov )

    if ( !client.ExitFromCutscene && multiplier != 1 ) then

      multiplier = math.Approach( multiplier, 1, RealFrameTime() * 2 )

    elseif ( client.ExitFromCutscene ) then

      multiplier = math.Approach( multiplier, 0, RealFrameTime() * 2 )

      if ( multiplier < .25 || without_anim ) then

        hook.Remove( "CalcView", "ThirdPerson" )
        client.ExitFromCutscene = nil

      end

    end

    local offset_eyes = client:LookupAttachment( "eyes" )
    offset_eyes = client:GetAttachment( offset_eyes )

    if ( offset_eyes ) then

      --angles = offset_eyes.Ang

    end

    local trace = {}
    trace.start = offset_eyes && offset_eyes.Pos or pos
    trace.endpos = trace.start + client:EyeAngles():Forward() * ( -80 * multiplier )
    trace.filter = client
    trace.mask = MASK_VISIBLE

    trace = util.TraceLine( trace )

    pos = trace.HitPos

    if ( trace.Hit ) then

      pos = pos + trace.HitNormal * 5

    end

    local view = {}
    view.origin = pos
    view.angles = angles
    view.fov = fov
    view.drawviewer = true

    return view

  end )

  timer.Simple( time, function()

    client.ExitFromCutscene = true

  end )

end )

net.Receive( "SpecialSCIHUD", function()

    local name = net.ReadString()
    local cooldown = net.ReadUInt(9)
    local desc = net.ReadString()
    local icon = net.ReadString()
    local max = net.ReadBool()

    local client = LocalPlayer()

    client.SpecialTable = {

        Name = name,
        Cooldown = cooldown,
        Description = desc,
        Icon = icon,
        Countable = max

    }

    DrawSpecialAbility( client.SpecialTable )

end )

hook.Add("InitPostEntity", "send_my_country", function()

	net.Start("send_country")
	net.WriteString(system.GetCountry())
	net.SendToServer()

end)

hook.Add("InitPostEntity", "LoadFuckingLanguage", function()
function LoadLang( lang )
	local finallang = table.Copy( ALLLANGUAGES.english )
	local ltu = {}
	if ALLLANGUAGES[lang] then
		ltu = table.Copy( ALLLANGUAGES[lang] )
	end
	AddTables( finallang, ltu )
	clang = finallang

	endmessages = {
		{
			main = clang.lang_end1,
			txt = clang.lang_end2,
			clr = gteams.GetColor(TEAM_SCP)
		},
		{
			main = clang.lang_end1,
			txt = clang.lang_end3,
			clr = gteams.GetColor(TEAM_SCP)
		}
	}
	hook.Run("Breach_LanguageChanged")
end

LoadLang( langtouse )
end)

disablehud = false
livecolors = false

preparing = false
postround = false

local universal_clr = Color( 210, 0, 0, 180 )

net.Receive("OpenLootMenu", function(len)
    local vtab = net.ReadTable()
    local ammo = net.ReadTable()
    ShowEQ( false, vtab, ammo )
end)

net.Receive("GocSpyUniform", function(len)
	if istable(BREACH.GocSpyUniform) then
					for i, v in pairs(BREACH.GocSpyUniform) do
						if IsValid(v) then v:Remove() end
					end
				end
				BREACH.GocSpyUniform = BREACH.GocSpyUniform || {}
                local clrgray = Color( 198, 198, 198 )
                local clrgray2 = Color( 180, 180, 180 )
                local clrred = Color( 255, 0, 0 )
                local clrred2 = Color( 50,205,50 )
                local gradienttt = Material( "vgui/gradient-r" )

				local teams_table = {

					--{ name = "Наблюдение по камерам", func = function() end },
					--{ name = "Запросы", func = function() end },
					--{ name = "Состояние комплекса", func = function() end },
					{ name = "При достаточном времени", func = function() net.Start("GocSpyUniform") net.WriteBool(false) net.SendToServer() end },
					{ name = "При малом времени", func = function() net.Start("GocSpyUniform") net.WriteBool(true) net.SendToServer() end },
			
				}
			
			
			
				BREACH.GocSpyUniform.MainPanel = vgui.Create( "DPanel" )
				BREACH.GocSpyUniform.MainPanel:SetSize( 256, 256 )
				BREACH.GocSpyUniform.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
				BREACH.GocSpyUniform.MainPanel:SetText( "" )
				BREACH.GocSpyUniform.MainPanel.Paint = function( self, w, h )
			
					if ( !vgui.CursorVisible() ) then
			
						gui.EnableScreenClicker( true )
			
					end
			
					draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
					draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
			
				end
			
				BREACH.GocSpyUniform.MainPanel.Disclaimer = vgui.Create( "DPanel" )
				BREACH.GocSpyUniform.MainPanel.Disclaimer:SetSize( 256, 64 )
				BREACH.GocSpyUniform.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 192 )
				BREACH.GocSpyUniform.MainPanel.Disclaimer:SetText( "" )
			
				local client = LocalPlayer()
			
				BREACH.GocSpyUniform.MainPanel.Disclaimer.Paint = function( self, w, h )
			
					draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
					draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
			
					draw.DrawText( "Тип формы ГОК", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
					if ( client:GetRoleName() != role.ClassD_GOCSpy || client:Health() <= 0 ) then
			
						if ( IsValid( BREACH.GocSpyUniform.MainPanel ) ) then
			
							BREACH.GocSpyUniform.MainPanel:Remove()
			
						end
			
						self:Remove()
			
						gui.EnableScreenClicker( false )
			
					end
			
				end
			
				BREACH.GocSpyUniform.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.GocSpyUniform.MainPanel )
				BREACH.GocSpyUniform.ScrollPanel:Dock( FILL )
			
				for i = 1, #teams_table do
			
					BREACH.GocSpyUniform.Users = BREACH.GocSpyUniform.ScrollPanel:Add( "DButton" )
					BREACH.GocSpyUniform.Users:SetText( "" )
					BREACH.GocSpyUniform.Users:Dock( TOP )
					BREACH.GocSpyUniform.Users:SetSize( 256, 64 )
					BREACH.GocSpyUniform.Users:DockMargin( 0, 0, 0, 2 )
					BREACH.GocSpyUniform.Users.CursorOnPanel = false
					BREACH.GocSpyUniform.Users.gradientalpha = 0
			
					BREACH.GocSpyUniform.Users.Paint = function( self, w, h )
			
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
			
					BREACH.GocSpyUniform.Users.OnCursorEntered = function( self )
			
						self.CursorOnPanel = true
			
					end
			
					BREACH.GocSpyUniform.Users.OnCursorExited = function( self )
			
						self.CursorOnPanel = false
			
					end
			
					BREACH.GocSpyUniform.Users.DoClick = function( self )

						teams_table[ i ].func()
			
						BREACH.GocSpyUniform.MainPanel:Remove()
						BREACH.GocSpyUniform.MainPanel.Disclaimer:Remove()
						gui.EnableScreenClicker( false )
			
					end
			
				end
end)

net.Receive("GRUCommander", function(len)
	if istable(BREACH.GRUCommander) then
					for i, v in pairs(BREACH.GRUCommander) do
						if IsValid(v) then v:Remove() end
					end
				end
				BREACH.GRUCommander = BREACH.GRUCommander || {}
                local clrgray = Color( 198, 198, 198 )
                local clrgray2 = Color( 180, 180, 180 )
                local clrred = Color( 255, 0, 0 )
                local clrred2 = Color( 50,205,50 )
                local gradienttt = Material( "vgui/gradient-r" )

				local teams_table = {

					--{ name = "Наблюдение по камерам", func = function() end },
					--{ name = "Запросы", func = function() end },
					--{ name = "Состояние комплекса", func = function() end },
					{ name = "Срыв эвакуации", func = function() net.Start("GRUCommander") net.WriteString("Evacuation") net.SendToServer() end },
					{ name = "Помощь Военному Персоналу", func = function() net.Start("GRUCommander") net.WriteString("MilitaryHelp") net.SendToServer() end },
			
				}
			
			
			
				BREACH.GRUCommander.MainPanel = vgui.Create( "DPanel" )
				BREACH.GRUCommander.MainPanel:SetSize( 256, 256 )
				BREACH.GRUCommander.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
				BREACH.GRUCommander.MainPanel:SetText( "" )
				BREACH.GRUCommander.MainPanel.Paint = function( self, w, h )
			
					if ( !vgui.CursorVisible() ) then
			
						gui.EnableScreenClicker( true )
			
					end
			
					draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
					draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
			
				end
			
				BREACH.GRUCommander.MainPanel.Disclaimer = vgui.Create( "DPanel" )
				BREACH.GRUCommander.MainPanel.Disclaimer:SetSize( 256, 64 )
				BREACH.GRUCommander.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 192 )
				BREACH.GRUCommander.MainPanel.Disclaimer:SetText( "" )
				BREACH.GRUCommander.MainPanel.DieTime = CurTime() + 25
			
				local client = LocalPlayer()
			
				BREACH.GRUCommander.MainPanel.Disclaimer.Paint = function( self, w, h )
			
					draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
					draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
			
					draw.DrawText( "Выбор задачи", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
					if ( client:GetRoleName() != role.GRU_Commander || client:Health() <= 0 ) or BREACH.GRUCommander.MainPanel.DieTime <= CurTime() then

						teams_table[math.random(1, #teams_table)].func()
			
						if ( IsValid( BREACH.GRUCommander.MainPanel ) ) then
			
							BREACH.GRUCommander.MainPanel:Remove()
			
						end
			
						self:Remove()
			
						gui.EnableScreenClicker( false )
			
					end
			
				end
			
				BREACH.GRUCommander.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.GRUCommander.MainPanel )
				BREACH.GRUCommander.ScrollPanel:Dock( FILL )
			
				for i = 1, #teams_table do
			
					BREACH.GRUCommander.Users = BREACH.GRUCommander.ScrollPanel:Add( "DButton" )
					BREACH.GRUCommander.Users:SetText( "" )
					BREACH.GRUCommander.Users:Dock( TOP )
					BREACH.GRUCommander.Users:SetSize( 256, 64 )
					BREACH.GRUCommander.Users:DockMargin( 0, 0, 0, 2 )
					BREACH.GRUCommander.Users.CursorOnPanel = false
					BREACH.GRUCommander.Users.gradientalpha = 0
			
					BREACH.GRUCommander.Users.Paint = function( self, w, h )
			
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
			
					BREACH.GRUCommander.Users.OnCursorEntered = function( self )
			
						self.CursorOnPanel = true
			
					end
			
					BREACH.GRUCommander.Users.OnCursorExited = function( self )
			
						self.CursorOnPanel = false
			
					end
			
					BREACH.GRUCommander.Users.DoClick = function( self )

						if teams_table[ i ].name == "Помощь Военному Персоналу" then
							net.Start("GRUCommander_peac") 
							net.SendToServer()
							SetGlobalString("gru_objective", "MilitaryHelp")
						else
							SetGlobalString("gru_objective", "Evacuation")
						end
			
						BREACH.GRUCommander.MainPanel:Remove()
						BREACH.GRUCommander.MainPanel.Disclaimer:Remove()
						gui.EnableScreenClicker( false )
			
					end
			
				end
end)

net.Receive("set_spectator_sync", function(len)

	local ply = net.ReadEntity()
	if IsValid(ply) then
		ply:SetNGTeam(TEAM_SPEC)
		ply:SetRoleName(role.Spectator)
	end


end)

hook.Add('NotifyShouldTransmit', 'BNMRG_NotifyShouldTransmit', function(ent, shouldTransmit)
    if ent:GetClass() == 'breach_bonemerge' then
        local owner = ent:GetOwner()
        if owner and owner:IsValid() and owner != ent:GetParent() then
            ent:SetParent(owner)
        end
    end
end)

net.Receive( "TargetsToNTFs", function()

    local target = net.ReadTable()
    local team_indx = net.ReadUInt(12)

    local clr_to_draw
    local universal_search

    if ( team_indx == 22 ) then

        clr_to_draw = Color(255,0,0)
        universal_search = {

            [ TEAM_CHAOS ] = true,
            [ TEAM_GOC ] = true,
            [ TEAM_USA ] = true,
            [ TEAM_DZ ] = true,
            [ TEAM_GRU ] = true,
            [ TEAM_COTSK ] = true,

        }

    else

        clr_to_draw = gteams.GetColor(team_indx)

    end

    local client = LocalPlayer()

    if ( !client.TargetsTable ) then

        client.TargetsTable = {}
        for i = 1, #target do
	        client.TargetsTable[ #client.TargetsTable + 1 ] = target[i]
	    end

        hook.Add( "PreDrawOutlines", "DrawTargets", function()

            local to_draw = {}

            if ( client:GTeam() != TEAM_NTF ) then

                hook.Remove( "PreDrawOutlines", "DrawTargets" )
                client.TargetsTable = nil

                return
            end

            for i = 1, #client.TargetsTable do

                local target = client.TargetsTable[ i ]

                if ( target && target:IsValid() && target:Health() > 0 && ( !universal_search && target:GTeam() == team_indx || universal_search && universal_search[ target:GTeam() ] ) && !target:GetRoleName():find("Spy") ) then

                    if ( !target:HasHazmat() ) then

                        to_draw[ #to_draw + 1 ] = target

                    end

                else

                    table.RemoveByValue( client.TargetsTable, target )

                end

            end

            outline.Add( to_draw, clr_to_draw, 0 )

        end )

        timer.Simple( 20, function()

            client.TargetsTable = nil
            hook.Remove( "PreDrawOutlines", "DrawTargets" )

        end )

    else

        client.TargetsTable[ #client.TargetsTable + 1 ] = target

    end

end )

local radio_green = Color( 0, 180, 0, 210 )

net.Receive( "fbi_commanderabillity", function()

  local client = LocalPlayer()

  if ( client:GetRoleName() != role.UIU_Commander ) then return end

  hook.Add( "PreDrawOutlines", "DrawPeopleWithRadios", function()

    local to_draw = {}

    if ( client:Health() <= 0 ) then

      hook.Remove( "PreDrawOutlines", "DrawPeopleWithRadios" )

      return
    end

    local players = player.GetAll()

    for i = 1, #players do

      local player = players[ i ]

      if ( player:IsSolid() ) then

        local radio = player:GetWeapon( "item_radio" )

        if ( radio && radio:IsValid() && radio.GetEnabled && radio:GetEnabled() && player:GTeam() != client:GTeam() ) then

          to_draw[ #to_draw + 1 ] = player

        end

      end

    end

    outline.Add( to_draw, radio_green, 0 )

  end )

  timer.Simple( 15, function()

    hook.Remove( "PreDrawOutlines", "DrawPeopleWithRadios" )

  end )

end )

local class_d_color = Color(255, 130, 0)

net.Receive( "Chaos_SpyAbility", function()

    local client = LocalPlayer()

    if ( client:GetRoleName() != role.SECURITY_Spy ) then return end

    hook.Add( "PreDrawOutlines", "DrawClassds", function()

        local to_draw = {}

        if ( !client:Alive() ) then

            hook.Remove( "PreDrawOutlines", "DrawClassds" )

            return
        end

        for _, v in ipairs( ents.FindInSphere( client:GetPos(), 300 ) ) do

            if ( v:IsPlayer() && v:GTeam() == TEAM_CLASSD && v:Health() > 0 ) then

                to_draw[ #to_draw + 1 ] = v

                for _, bnmrg in ipairs(v:LookupBonemerges()) do
                	to_draw[ #to_draw + 1 ] = bnmrg
                end

            end

        end

        outline.Add( to_draw, class_d_color, 2 )

    end )

    timer.Simple( 10, function()

        hook.Remove( "PreDrawOutlines", "DrawClassds" )

    end )

end )

net.Receive( "Cult_SpecialistAbility", function()

    local client = LocalPlayer()

    if ( client:GetRoleName() != role.Cult_Specialist ) then return end

    hook.Add( "PreDrawOutlines", "DrawCultTargets", function()

        local to_draw = {}

        if ( !client:Alive() ) then

            hook.Remove( "PreDrawOutlines", "DrawCultTargets" )

            return
        end

        for _, v in ipairs( ents.FindInSphere( client:GetPos(), 300 ) ) do

            if ( v:IsPlayer() && v:GTeam() != TEAM_SPEC && v:Health() > 0 ) then

                to_draw[ #to_draw + 1 ] = v

            end

        end

        outline.Add( to_draw, Color(255,0,0), 0 )

    end )

    timer.Simple( 20, function()

        hook.Remove( "PreDrawOutlines", "DrawCultTargets" )

    end )

end )

net.Receive( "GRU_CommanderAbility", function()

    local client = LocalPlayer()

	local team_index = net.ReadString()

    if ( client:GTeam() != TEAM_GRU ) then return end

    hook.Add( "PreDrawOutlines", "DrawGRUTargets", function()

        local to_draw = {}

        if ( !client:Alive() ) then

            hook.Remove( "PreDrawOutlines", "DrawGRUTargets" )

            return
        end

        for _, v in player.Iterator() do

            if ( v:GTeam() == team_index && v:Health() > 0 ) then

                to_draw[ #to_draw + 1 ] = v

            end

        end

        outline.Add( to_draw, Color(255,0,0), 0 )

    end )

    timer.Simple( 20, function()

        hook.Remove( "PreDrawOutlines", "DrawGRUTargets" )

    end )

end )

function DropCurrentVest()
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		net.Start("DropCurrentVest")
		net.SendToServer()
	end
end

concommand.Add( "br_dropuniform", function( ply, cmd, args )
	DropCurrentVest()
end )

concommand.Add( "br_roundrestart_cl", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("RoundRestart")
		net.SendToServer()
	end
end )

wantClear = false
tUse = 0

concommand.Add( "br_restart_game", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("Restart")
		net.SendToServer()
	end
end )

concommand.Add( "br_admin_mode", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("AdminMode")
		net.SendToServer()
	end
end )

concommand.Add( "br_disableallhud", function( ply, cmd, args )
	disablehud = !disablehud
end )

concommand.Add( "br_livecolors", function( ply, cmd, args )
	if livecolors then
		livecolors = false
		chat.AddText("livecolors disabled")
	else
		livecolors = true
		chat.AddText("livecolors enabled")
	end
end )

concommand.Add( "br_weapon_info", function( ply, cmd, args )
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) then
		print( "Weapon name: "..wep:GetClass() )
		if wep.Damage_Orig then print( "Weapon original damage: "..wep.Damage_Orig ) end
		if wep.DamageMult then print( "Weapon damage multiplier: "..wep.DamageMult ) end
		if wep.DamageMult then print( "Weapon final damage: "..wep.Damage ) end
	end
end )
gamestarted = gamestarted || false
cltime = cltime || 0
drawinfodelete = drawinfodelete || 0
shoulddrawinfo = shoulddrawinfo || false
drawendmsg = drawendmsg || nil
timefromround = timefromround || 0

timer.Create("HeartbeatSound", 2, 0, function()
	if not LocalPlayer().Alive then return end
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC and LocalPlayer():GTeam() != TEAM_SCP then
		if LocalPlayer():Health() < 30 then
			LocalPlayer():EmitSound("heartbeat.ogg")
		end
	end
end)

function OnUseEyedrops(ply) end

eyedropeffect = eyedropeffect || 0
function EyeDrops(ply, type)
	local time = 10
	if type == 2 then time = 30 end
	if type == 3 then time = 50 end

	eyedropeffect = CurTime() + time
end

function StartTime()
	timer.Destroy("UpdateTime")
	timer.Create("UpdateTime", 1, 0, function()
		if cltime > 0 then
			cltime = cltime - 1
		end
	end)
end

endinformation = {}

/*net.Receive( "Update914B", function( len )
	local sstatus = net.ReadInt(6)
	if sstatus == 0 then
		buttonstatus = "rough"
	elseif sstatus == 1 then
		buttonstatus = "coarse"
	elseif sstatus == 2 then
		buttonstatus = "1:1"
	elseif sstatus == 3 then
		buttonstatus = "fine"
	elseif sstatus == 4 then
		buttonstatus = "very fine"
	end
end)*/

net.Receive( "UpdateTime", function( len )
	cltime = tonumber(net.ReadString())
	StartTime()
end)

net.Receive( "OnEscaped", function( len )
	local msg = net.ReadString()
	CorpsedMessage(BREACH.TranslateString(msg))
end)

net.Receive( "ForcePlaySound", function( len )
	local sound = net.ReadString()
	surface.PlaySound(sound)
end)

net.Receive( "EfficientPlaySound", function( len )
	local snd = Sound(net.ReadString())
	local customparameters = net.ReadTable() || {}
	local sndpatch = CreateSound(game.GetWorld(), snd)
	if customparameters.dsp then
		sndpatch:SetDSP(customparameters.dsp)
	end
	if customparameters.volume then
		sndpatch:ChangeVolume(customparameters.volume)
	end
	if customparameters.pitch then
		sndpatch:ChangePitch(customparameters.pitch)
	end
	sndpatch:Play()
	if customparameters.dietime then
		timer.Simple(customparameters.dietime, function()
			sndpatch:Stop()
		end)
	end
end)

net.Receive("PrepClient", function(len)
	GAMEMODE:ScoreboardHide() --DICKHEADS!!!
	RunConsoleCommand("stopsound")

	Monitors_Activated = 0

	--hook.Remove( "PostDrawTranslucentRenderables", "cult_draw_mark" )

	local client = LocalPlayer()
	client.no_signal = nil
	client:ConCommand( "pp_mat_overlay \"\"" )
	client:ConCommand( "lounge_chat_clear" )

	client.BlackScreen = true

	timer.Simple( 5, function()
		client.BlackScreen = nil
	end)
end)

net.Receive( "UpdateRoundType", function( len )
	roundtype = net.ReadString()
	--print("Current roundtype: " .. roundtype)
end)

net.Receive( "SendRoundInfo", function( len )
	local infos = net.ReadTable()
	endinformation = {
		string.Replace( clang.lang_pldied, "{num}", infos.deaths ),
		string.Replace( clang.lang_descaped, "{num}", infos.descaped ),
		string.Replace( clang.lang_sescaped, "{num}", infos.sescaped ),
		string.Replace( clang.lang_rescaped, "{num}", infos.rescaped ),
		string.Replace( clang.lang_dcaptured, "{num}", infos.dcaptured ),
		string.Replace( clang.lang_rescorted, "{num}", infos.rescorted ),
		string.Replace( clang.lang_teleported, "{num}", infos.teleported ),
		string.Replace( clang.lang_snapped, "{num}", infos.snapped ),
		string.Replace( clang.lang_zombies, "{num}", infos.zombies )
	}
	if infos.secretf == true then
		table.ForceInsert(endinformation, clang.lang_secret_found)
	else
		table.ForceInsert(endinformation, clang.lang_secret_nfound)
	end
end)

net.Receive( "RolesSelected", function( len )
	drawinfodelete = CurTime() + 25
	shoulddrawinfo = true

	local client = LocalPlayer()

	if client:GetRoleName() == "GOC Spy" then
		hook.Add("HUDPaint", "GOC_Spy_Uniform", function()
			if client:GetRoleName() != "GOC Spy" then
				hook.Remove("HUDPaint", "GOC_Spy_Uniform")
				return
			end
			local Ents = ents.FindByClass("armor_goc")
			local tab = {}
			for i = 1, #Ents do
				local ent = Ents[i]
				if ent:GetPos():DistToSqr(client:GetPos()) > 136222 then continue end
				tab[#tab + 1] = ent
			end
			outline.Add( tab, Color(255,0,0), OUTLINE_MODE_BOTH )
		end)
	end
end)

BREACH.MutedFags = {}

gameevent.Listen("player_spawn")
hook.Add("player_spawn", "RememberMutedFags", function(data) 
	local id = data.userid
	if LocalPlayer():UserID() == id then
		for k, v in pairs(BREACH.MutedFags) do
			if !IsValid(v) then
				table.remove(BREACH.MutedFags, k)
			end
		end
		if LocalPlayer():GTeam() == TEAM_SPEC then
			for k, v in pairs(BREACH.MutedFags) do
				if !IsValid(v) then continue end
				v:SetMuted(true)
			end
		else
			for k, v in player.Iterator() do
				if v:IsMuted() then
					table.insert(BREACH.MutedFags, v)
					v:SetMuted(false)
				end
			end
		end
	end
end)

timer.Create("Breach:ClientsideMuteCheck", 1, 0, function()
	for k, v in player.Iterator() do
		if !v:IsMuted() and table.HasValue(BREACH.MutedFags, v) then
			for _, sdidsa in pairs(BREACH.MutedFags) do
				if !IsValid(sdidsa) then
					table.remove(BREACH.MutedFags, _)
				end

				if sdidsa == v then
					table.remove(BREACH.MutedFags, k)
					v:SetMuted(false)
				end
			end
		end
	end
end)

function StartIntroMusic()
	local client = LocalPlayer()
	if client:GTeam() != TEAM_GUARD and client:GTeam() != TEAM_NAZI and client:GTeam() != TEAM_AMERICA then
		BREACH.Music:Play(BR_MUSIC_SPAWN_AMBIENT)
	end
end

net.Receive( "PrepStart", function( len )
	GAMEMODE:ScoreboardHide() --DICKHEADS!!!
	RunConsoleCommand("stopsound")
	cltime = net.ReadInt(8)
	postround = false
	preparing = true
	BREACH.Round.GeneratorsActivated = true
	StartTime()
	drawendmsg = nil
	timer.Destroy("StartIntroMusic")
	timer.Create("StartIntroMusic", 1, 1, StartIntroMusic)
	timer.Destroy("IntroSound")
	if LocalPlayer():GTeam() != TEAM_GUARD then
		timer.Create("IntroSound", 55, 1, IntroSound)
	end
	timefromround = CurTime() + 10

	if LocalPlayer():GTeam() == TEAM_GUARD then
		timer.Simple(.4, function()
			Nextoren_MTF_Intro()
		end)

		LocalPlayer().cantopeninventory = true
		LocalPlayer().MovementLocked = true
		LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 1, 5)
	end
	timer.Destroy("IntroStart")
	timer.Create("IntroStart", 66, 1, function()
		BREACH.Round.GeneratorsActivated = false
	end)
	tab = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 1,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	}

	DrawColorModify( tab )

	timer.Destroy("IntroEnd")
	timer.Create("IntroEnd", 60, 1, function()
		local client = LocalPlayer()
		local tab2
		if client:GTeam() != TEAM_SCP then
			if OUTSIDE_BUFF and OUTSIDE_BUFF( client:GetPos() ) then

				tab2 = {
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = 0,
					["$pp_colour_contrast"] = 1,
					["$pp_colour_colour"] = 1,
					["$pp_colour_mulr"] = 0,
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0
				}
			else
				tab2 = {
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = -0.06,
					["$pp_colour_contrast"] = 0.6,
					["$pp_colour_colour"] = 1,
					["$pp_colour_mulr"] = 0,
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0
				}
			end
		else
			tab2 = {
				["$pp_colour_addr"] = 0.15,
				["$pp_colour_addg"] = 0,
				["$pp_colour_addb"] = 0,
				["$pp_colour_brightness"] = -0.005,
				["$pp_colour_contrast"] = 1,
				["$pp_colour_colour"] = 1,
				["$pp_colour_mulr"] = 0,
				["$pp_colour_mulg"] = 0,
				["$pp_colour_mulb"] = 0
			}
		end
		DrawColorModify( tab2 )
	end)
end)

net.Receive( "RoundStart", function( len )
	preparing = false
	cltime = net.ReadInt(12)
	StartTime()
	drawendmsg = nil
end)

net.Receive( "PostStart", function( len )
	postround = true
	cltime = net.ReadInt(6)
	win = net.ReadInt(4)
	drawendmsg = win
	StartTime()
end)

net.Receive( "TranslatedMessage", function( len )
	local msg = net.ReadString()
	//local center = net.ReadBool()

	//print( msg )
	local color = nil
	local nmsg, cr, cg, cb = string.match( msg, "(.+)%#(%d+)%,(%d+)%,(%d+)$" )
	if nmsg and cr and cg and cb then
		msg = nmsg
		color = Color( cr, cg, cb )
	end

	local name, func = string.match( msg, "^(.+)%$(.+)" )
	
	if name and func then
		local args = {}

		for v in string.gmatch( func, "%w+" ) do
			table.insert( args, v )
			//print( "splitted:", v )
		end

		local translated = clang.NRegistry[name] or string.format( clang.NFailed, name )
		if color then
			chat.AddText( color, string.format( translated, unpack( args ) ) )
		else
			chat.AddText( string.format( translated, unpack( args ) ) )
		end
	else
		local translated = clang.NRegistry[msg] or string.format( clang.NFailed, msg )
		if color then
			chat.AddText( color, translated )
		else
			chat.AddText( translated )
		end
	end
end )

local gradients = Material("gui/center_gradient")

function CreateEmoteMenu()

	if IsValid(EMOTECOOLMENU) then
		EMOTECOOLMENU:Remove()
		return
	end

	local num = 0

	for i, v in pairs(BREACH.EMOTES) do
		num = num + 1
	end

	EMOTECOOLMENU = vgui.Create("DPanel")
	EMOTECOOLMENU:SetSize(275, 30*num)
	EMOTECOOLMENU:SetPos(20, 20)
	local col_bl = Color(0,0,0,100)
	EMOTECOOLMENU.Paint = function(self, w, h)

		DrawBlurPanel(self)
	
		draw.RoundedBox(0,0,0,w,h,col_bl)

		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0,0,w,h,1)

	end

	for i, v in ipairs(BREACH.EMOTES) do
		local button = vgui.Create("DPanel", EMOTECOOLMENU)
		button:Dock(TOP)
		button:SetSize(0, 30)
		button.name = v.name
		button.num = i

		local key = "KEY_"..tostring(i)

		button.Think = function(self)

			if input.IsKeyDown(_G[key]) then

				net.Start("PlayTaunt")
				net.WriteString(tostring(BREACH.EMOTES[i].gesture))
				net.SendToServer()

				EMOTECOOLMENU:Remove()

				return

			end

		end

		button.Paint = function(self, w, h)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(gradients)
			surface.DrawTexturedRect(0,0,w,1)

			draw.DrawText(self.num..". "..self.name, "ChatFont_new", 6, 6)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(gradients)
			surface.DrawTexturedRect(0,h-1,w,1)

		end
	end

end


hook.Add("PlayerButtonDown", "emote_menu", function(ply, butt)

	local pl = LocalPlayer()

	if pl:GTeam() == TEAM_SPEC then return end
	if pl:GTeam() == TEAM_SCP then return end

	if butt == KEY_Z and IsFirstTimePredicted() then

		if IsValid(BREACH.QuickChatPanel) then
			BREACH.QuickChatPanel:Remove()
		end

		CreateEmoteMenu()

	end


end)

BREACH.QuickChatPhrases = {
	{name = "l:quickchat_request_id", phrase = "Покажи ID карту!", military_only = true},
	{name = "l:quickchat_take_off_suit", phrase = "Сними костюм!", military_only = true},
	{name = "l:quickchat_put_weapon_away", phrase = "Убрать оружие!", military_only = true},
	{name = "l:quickchat_drop_the_weapon", phrase = "Выбросить оружие!", military_only = true},
	{name = "l:quickchat_friendly", phrase = "Свои!"},
	{name = "l:quickchat_run", phrase = "Беги!"},
	{name = "l:quickchat_enemy_spotted", phrase = "Там противник!"},
	{name = "l:quickchat_scp_spotted", phrase = "Там СЦП!"},
	{name = "l:quickchat_stop", phrase = "Стоять на месте!", military_only = true},
	{name = "l:quickchat_face_the_wall", phrase = "Лицом к стене!", military_only = true},
	{name = "l:quickchat_dont_follow_me", phrase = "Не преследуй меня!"},
	{name = "l:quickchat_dont_approach", phrase = "Не приближайся ко мне!"},
}

BREACH.QuickChatPhrases_RoleWhitelist = {
	["Head of Personnel"] = true,
}

BREACH.QuickChatPhrases_RoleBlacklist = {
	["GOC Spy"] = true,
	["UIU Spy"] = true,
	["SH Spy"] = true,
}

BREACH.QuickChatMenu_PageToDraw = 0
BREACH.QuickChatMenu_Pages = 0

function BREACH.QuickChatMenu()
	if IsValid(BREACH.QuickChatPanel) then
		if BREACH.QuickChatMenu_PageToDraw == BREACH.QuickChatMenu_Pages then
			BREACH.QuickChatPanel:Remove()
			return
		elseif BREACH.QuickChatMenu_PageToDraw < BREACH.QuickChatMenu_Pages then
			BREACH.QuickChatMenu_PageToDraw = BREACH.QuickChatMenu_PageToDraw + 1
			for k, v in pairs(BREACH.QuickChatPanel:GetChildren()) do
				v:Remove()
			end
			BREACH.QuickChat_RebuildButtons()
			return
		end	
	end

	local num = 0
	local phrases_copy = {}
	phrases_copy.total_pages = 0

	for i, v in pairs(BREACH.QuickChatPhrases) do
		if num / 5 >= 1 then
			num = 0
			phrases_copy.total_pages = phrases_copy.total_pages + 1
			BREACH.QuickChatMenu_Pages = BREACH.QuickChatMenu_Pages + 1
		end

		if v.military_only and (BREACH.QuickChatPhrases_NonMilitaryTeams[LocalPlayer():GTeam()] or BREACH.QuickChatPhrases_RoleBlacklist[LocalPlayer():GetRoleName()]) then
			if !BREACH.QuickChatPhrases_RoleWhitelist[LocalPlayer():GetRoleName()] then
				continue
			end
		end

		v.page = phrases_copy.total_pages
		v.key = num + 1
		phrases_copy[#phrases_copy + 1] = v
		num = num + 1
	end

	BREACH.QuickChatPanel = vgui.Create("DPanel")
	if phrases_copy.total_pages > 0 then
		BREACH.QuickChatPanel:SetSize(ScrW() * 0.14, ScrH() * 0.027 * 5)
	else
		BREACH.QuickChatPanel:SetSize(ScrW() * 0.14, ScrH() * 0.027 * #phrases_copy)
	end
	BREACH.QuickChatPanel:SetPos(ScrW() * 0.01, ScrH() * 0.02)
	local col_bl = Color(0,0,0,100)
	BREACH.QuickChatPanel.Paint = function(self, w, h)

		DrawBlurPanel(self)
	
		draw.RoundedBox(0,0,0,w,h,col_bl)

		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0,0,w,h,1)

	end

	BREACH.QuickChatPanel.OnRemove = function()
		BREACH.QuickChatMenu_PageToDraw = 0
		BREACH.QuickChatMenu_Pages = 0
	end

	function BREACH.QuickChat_RebuildButtons()
		for i, v in ipairs(phrases_copy) do
			if v.page != BREACH.QuickChatMenu_PageToDraw then
				continue
			end

			if v.military_only and (BREACH.QuickChatPhrases_NonMilitaryTeams[LocalPlayer():GTeam()] or BREACH.QuickChatPhrases_RoleBlacklist[LocalPlayer():GetRoleName()]) then
				if !BREACH.QuickChatPhrases_RoleWhitelist[LocalPlayer():GetRoleName()] then
					continue
				end
			end

			local button = vgui.Create("DPanel", BREACH.QuickChatPanel)
			button:Dock(TOP)
			button:SetSize(0, ScrH()*0.027)
			button.name = v.name
			button.phrase = v.phrase
			button.num = v.key
	
			local key = "KEY_"..tostring(v.key)
	
			button.Think = function(self)
				if LocalPlayer():GetNW2Bool("Breach:CanAttach", false) and GetConVar("breach_config_quickchat"):GetInt() == KEY_C then
					if IsValid(BREACH.QuickChatPanel) then
						BREACH.QuickChatPanel:Remove()
						return
					end
				end
	
				if input.IsKeyDown(_G[key]) then
					LocalPlayer():ConCommand("say \""..button.phrase.."\"")
					timer.Simple(0, function()
						BREACH.QuickChatPanel:Remove()
					end)
					return
				end
	
			end
	
			button.Paint = function(self, w, h)
	
				surface.SetDrawColor(color_white)
				surface.SetMaterial(gradients)
				surface.DrawTexturedRect(0,0,w,1)
	
				draw.DrawText(self.num..". "..L(self.name), "ChatFont_new", 6, 6)
	
				surface.SetDrawColor(color_white)
				surface.SetMaterial(gradients)
				surface.DrawTexturedRect(0,h-1,w,1)
	
			end
		end
	end
	BREACH.QuickChat_RebuildButtons()
end

hook.Add("PlayerButtonDown", "Breach:QuickChatMenu", function(ply, butt)

	local ply = LocalPlayer()

	if ply:Health() <= 0 and IsValid(BREACH.QuickChatPanel) then
		BREACH.QuickChatPanel:Remove()
		return
	end

	if ply:GetNW2Bool("Breach:CanAttach", false) and GetConVar("breach_config_quickchat"):GetInt() == KEY_C then
		return
	end

	if ply:GTeam() == TEAM_SPEC or ply:GTeam() == TEAM_SCP then
		if IsValid(BREACH.QuickChatPanel) then
			BREACH.QuickChatPanel:Remove()
		end
		return
	end

	if butt == GetConVar("breach_config_quickchat"):GetInt() and IsFirstTimePredicted() then
		if IsValid(EMOTECOOLMENU) then
			EMOTECOOLMENU:Remove()
		end
	
		BREACH.QuickChatMenu()

	end

end)

gameevent.Listen("entity_killed")
hook.Add("entity_killed", "Breach:CloseQuickChatOnDeath", function( data ) 
	local inflictor_index = data.entindex_inflictor		// Same as Weapon:EntIndex() / weapon used to kill victim
	local attacker_index = data.entindex_attacker		// Same as Player/Entity:EntIndex() / person or entity who did the damage
	local damagebits = data.damagebits			// DAMAGE_TYPE - use BIT operations to decipher damage types...
	local victim_index = data.entindex_killed		// Same as Victim:EntIndex() / the entity / player victim

	if LocalPlayer():EntIndex() == victim_index and IsValid(BREACH.QuickChatPanel) then
		BREACH.QuickChatPanel:Remove()
	end

	if LocalPlayer():EntIndex() == victim_index and IsValid(EMOTECOOLMENU) then
		EMOTECOOLMENU:Remove()
	end
end)

net.Receive( "CameraDetect", function( len )
	local tab = net.ReadTable()

	for i, v in ipairs( tab ) do
		table.insert( SCPMarkers, { time = CurTime() + 7.5, data = v } )
	end
end )

hook.Add( "OnPlayerChat", "CheckChatFunctions", function( ply, strText, bTeam, bDead )
	strText = string.lower( strText )

	if ( strText == "dropvest" ) then
		if ply == LocalPlayer() then
			DropCurrentVest()
		end
		return true
	end
end)

// Blinking system

blinkHUDTime = 0
btime = 0--CurTime() + 0.25
blink_end = 0
blink = false

local dishudnf = false
local wasdisabled = false

function DisableHUDNextFrame()
	dishudnf = true
end

function CLTick()
	local client = LocalPlayer()
	if postround == false and isnumber(drawendmsg) then
		drawendmsg = nil
	end

	if clang == nil then
		clang = english
	end

	if cwlang == nil then
		cwlang = english
	end

	if blinkHUDTime >= 0 then 
		blinkHUDTime = btime - CurTime()
	end

	if blinkHUDTime < 0 then
		--btime = CurTime() + 5.5
		--if client.GTeam and client:GTeam() != TEAM_SCP and client:GTeam() != TEAM_SPEC then
			--Blink(0.1)
		--end
		blinkHUDTime = 0
	end

	if dishudnf then
		if !disablehud then
			wasdisabled = disablehud
			disablehud = true
		end

		dishudnf = false
	elseif disablehud and wasdisabled == false then
		disablehud = false
	end

	if shoulddrawinfo then
		if CurTime() > drawinfodelete then
			shoulddrawinfo = false
			drawinfodelete = 0
		end
	end

	if CurTime() > blink_end then
		blink = false
	end
end
hook.Add( "Tick", "client_tick_hook", CLTick )

function Blink( time )
	timer.Simple(0.14, function()
		blink = true
		blink_end = CurTime() + time
		if eyedropeffect <= CurTime() then
			timer.Simple(blink_end - CurTime(), function()
				local scp173 = nil
			    local scps = gteams.GetPlayers(TEAM_SCP)
			    for i = 1, #scps do
			    	if IsValid(scps[i]) and scps[i]:GetRoleName() == SCP173 then scp173 = scps[i]:GetNWEntity("SCP173Statue") end
			    end
			    if IsValid(scp173) and CanSeePlayer(scp173) then
					LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 0.2, 0.1)
				end
			end)
		end
		btime = CurTime() + time
	end)
end

net.Receive("PlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink( time )
end)

net.Receive( "689", function( len )
	if LocalPlayer().GetRoleName then
		if LocalPlayer():GetRoleName() == SCP689 then
			local targets = net.ReadTable()
			if targets then
				local swep = LocalPlayer():GetWeapon( "weapon_scp_689" )
				if IsValid( swep ) then
					swep.Targets = targets
				end
			end
		end
	end
end )

net.Receive("Effect", function()
	LocalPlayer().mblur = net.ReadBool()
end )

local mat_blink = CreateMaterial( "blink_material", "UnlitGeneric", {
	["$basetexture"] = "models/debug/debugwhite",
	["$color"] = "{ 0 0 0 }"
} )
local frozen_mat = Material( "nextoren/ice_material/icefloor_01_new" )
local frozen_alpha = 0
local mat_color = Material( "pp/colour" ) -- used outside of the hook for performance
local no_signal = Material( "nextoren_hud/overlay/no_signal" )
local screen_effects = CreateConVar("breach_config_screen_effects", 1, FCVAR_ARCHIVE, "Enables bloom and toytown", 0, 1)

hook.Add( "HUDShouldDraw", "HideHUDCameraBR", function( name )
	local ply = LocalPlayer()
	if IsValid(ply) then
		if ply:GetTable()["br_camera_mode"] then
			return false
		end
	end

end )

hook.Add("RenderScreenspaceEffects", "blinkeffects", function()
    local client = LocalPlayer()
    local clienttable = client:GetTable()
    if clienttable.mblur == nil then --if blink and eyedropeffect <= CurTime() then --render.SetMaterial( mat_blink ) --render.DrawScreenQuad() --return --end
        clienttable.mblur = false
    end

    if clienttable.mblur == true then DrawMotionBlur(0.3, 0.8, 0.03) end
    local contrast = 1
    local colour = 1
    local nvgbrightness = 0
    local clr_r = 0
    local clr_g = 0
    local clr_b = 0
    local bloommul = 1.2
	
    if client.shotdown then
        local hit_brightness = client.shot_EffectTime - CurTime()
        nvgbrightness = math.max(hit_brightness, 0)
        if hit_brightness <= 0 then
            client.shotdown = nil
            client.shot_EffectTime = nil
            nvgbrightness = 0
        end
    end

    if clienttable["n420endtime"] and clienttable["n420endtime"] > CurTime() then
        DrawMotionBlur(1 - (clienttable["n420endtime"] - CurTime()) / 15, 0.3, 0.025)
        DrawSharpen((clienttable["n420endtime"] - CurTime()) / 3, (clienttable["n420endtime"] - CurTime()) / 20)
        clr_r = (clienttable["n420endtime"] - CurTime()) * 2
        clr_g = (clienttable["n420endtime"] - CurTime()) * 2
        clr_b = (clienttable["n420endtime"] - CurTime()) * 2
    end

    local client_health = client:Health() --	last996attack = last996attack - 0.002 --	if last996attack < 0 then --		last996attack = 0 --	else --		DrawMotionBlur( 1 - last996attack, 1, 0.05 ) --		DrawSharpen( last996attack,2 ) --		contrast = last996attack --	end
    local client_team = client:GTeam()
    if clienttable["no_signal"] then
        if client_team != TEAM_SPEC then clienttable["no_signal"] = nil end
        no_signal:SetFloat("$alpha", 1)
        no_signal:SetInt("$ignorez", 1)
        render.SetMaterial(no_signal)
        render.DrawScreenQuad()
    end

    if clienttable["br_camera_mode"] then
        if client_team == TEAM_SPEC or client_health <= 0 then
            clienttable["br_camera_mode"] = false
        else
            DrawMaterialOverlay("effects/combine_binocoverlay", 0.3)
            colour = 0.1
            nvgbrightness = 0.1
        end
    end

    if clienttable.Start409ScreenEffect then
        if client_team == TEAM_SPEC or client_health <= 0 then clienttable.Start409ScreenEffect = nil end
        frozen_alpha = math.Approach(frozen_alpha, 1, FrameTime() * .1)
        frozen_mat:SetFloat("$alpha", .5)
        frozen_mat:SetInt("$ignorez", 1)
        render.SetMaterial(frozen_mat)
        render.DrawScreenQuad()
    end

    local actwep = client:GetActiveWeapon()
    if IsValid(actwep) then
        if actwep:GetClass() == "item_nvg" then
            nvgbrightness = 0.2
            DrawSobel(0.7)
        end
    end

    if livecolors then
        contrast = 1.1
        colour = 1.5
        bloommul = 2
    end

    local use_screen_effects = screen_effects:GetBool() or false
    local client_maxhealth = client:GetMaxHealth()
    if client_health <= client_maxhealth * .2 and client_health > 0 and client_team != TEAM_SCP and client_team != TEAM_SPEC then
        DrawMotionBlur((client_maxhealth - client_health) / 400, .7, 0)
        DrawSharpen((client_maxhealth - client_health) / 50, 2)
        if use_screen_effects then DrawToyTown(100 / (client_maxhealth - client_health) * 0.6, ScrH() / 3) end
    end

    render.UpdateScreenEffectTexture()
    mat_color:SetTexture("$fbtexture", render.GetScreenEffectTexture())
    mat_color:SetFloat("$pp_colour_brightness", nvgbrightness)
    mat_color:SetFloat("$pp_colour_contrast", contrast)
    mat_color:SetFloat("$pp_colour_colour", colour)
    mat_color:SetFloat("$pp_colour_mulr", clr_r)
    mat_color:SetFloat("$pp_colour_mulg", clr_g)
    mat_color:SetFloat("$pp_colour_mulb", clr_b)
    render.SetMaterial(mat_color)
    render.DrawScreenQuad()
    if use_screen_effects then --DrawBloom( Darken, Multiply, SizeX, SizeY, Passes, ColorMultiply, Red, Green, Blue )
        DrawToyTown(2, ScrH() / 4)
        DrawBloom(0.65, bloommul, 9, 9, 1, 1, 1, 1, 1)
    end
end)

local dropnext = 0
function GM:PlayerBindPress( ply, bind, pressed )
	if bind == "+menu" then
		if GetConVar( "br_new_eq" ):GetInt() != 1 then
			DropCurrentWeapon()
		end
	elseif bind == "gm_showteam" then

		if ( !IsRoleMenuVisible() ) then

			OpenClassMenu()

		elseif ( IsRoleMenuVisible() ) then

			CloseRoleMenu()

		end
	elseif bind == "+menu_context" then
		thirdpersonenabled = !thirdpersonenabled
	elseif bind == "noclip" and ply:IsAdmin() then
		RunConsoleCommand("ulx", "noclip")
	end
end	

function DropCurrentWeapon()
	--[[
	if dropnext > CurTime() then return true end
	dropnext = CurTime() + 0.5
	net.Start("DropCurWeapon")
	net.SendToServer()
	if LocalPlayer().channel != nil then
		LocalPlayer().channel:EnableLooping( false )
		LocalPlayer().channel:Stop()
		LocalPlayer().channel = nil
	end]]
	return true
end

net.Receive("smooth_lerp_gest", function()
    local self = net.ReadEntity()
    local float_back = net.ReadFloat()

    if not IsValid(self) then return end

    local w = 0
    local uniqueid = "weight_lerp"..self:SteamID64()

    timer.Create(uniqueid, 0.01, 0, function()
        if not IsValid(self) or w >= 1 then
            timer.Remove(uniqueid)
            return
        end

        w = math.min(w + FrameTime(), 1)
        self:AnimSetGestureWeight(GESTURE_SLOT_VCD, w)
    end)

    timer.Simple(float_back * 0.85, function()
        local uniqid = "lerp2"..self:SteamID64()
        local w = 1

        timer.Create(uniqid, 0.01, 0, function()
            if not IsValid(self) or w <= 0 then
                timer.Remove(uniqid)
                return
            end

            w = math.max(w - 0.1, 0)
            self:AnimSetGestureWeight(GESTURE_SLOT_VCD, w)
        end)
    end)
end)


concommand.Add("br_requestescort", function()
	if !((LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) or LocalPlayer():GTeam() == TEAM_CHAOS) then return end
	net.Start("RequestEscorting")
	net.SendToServer()
end)

concommand.Add("br_requestNTFspawn", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("NTFRequest")
		net.SendToServer()
	end
end )

concommand.Add("br_sound_random", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Random")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_searching", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Searching")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_classd", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Classd")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_stop", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Stop")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_lost", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Lost")
		net.SendToServer()
	end
end)
/*
function CalcView3DPerson( ply, pos, angles, fov )
	local view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = false
	if thirdpersonenabled then
		local eyepos = ply:EyePos()
		local eyeangles = ply:EyeAngles()
		local point = ply:GetEyeTrace().HitPos
		local goup = 2
		if ply:Crouching() then
			goup = 20
		end
		view.drawviewer = true
		view.origin = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 20)
		view.angles = (point - view.origin):Angle()
		local endps = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 15)
		local tr = util.TraceLine( { start = eyepos, endpos = endps} )
		if tr.Hit then
			view.origin = tr.HitPos
		end
	end
	return view
end
hook.Add( "CalcView", "CalcView3DPerson", CalcView3DPerson )
*/

/*function GM:HUDDrawPickupHistory()

end*/

/*function GM:HUDWeaponPickedUp( weapon )
end*/

hook.Add( "HUDWeaponPickedUp", "DonNotShowCards", function( weapon )
	weps = LocalPlayer():GetWeapons()
	if weapon:GetClass() == "br_keycard" then return false end
end )

function GM:CalcView( ply, origin, angles, fov )
	local data = {}
	data.origin = origin
	data.angles = angles
	data.fov = fov
	data.drawviewer = false
	local item = ply:GetActiveWeapon()
	if IsValid( item ) then
		if item.CalcView then
			local vec, ang, ifov, dw = item:CalcView( ply, origin, angles, fov )
			if vec then data.origin = vec end
			if ang then data.angles = ang end
			if ifov then data.fov = ifov end
			if dw != nil then data.drawviewer = dw end
		end
	end

	if CamEnable then
		--print( "enabled" )
		if !timer.Exists( "CamViewChange" ) then
			timer.Create( "CamViewChange", 1, 1, function()
				CamEnable = false
			end )
		end
		data.drawviewer = true
		dir = dir or Vector( 0, 0, 0 )
		--print( dir )
		data.origin = ply:GetPos() - dir - dir:GetNormalized() * 30 + Vector( 0, 0, 80 )
		data.angles = Angle( 10, dir:Angle().y, 0 )
	end

	return data
end

function OBRStart()
	if GetGlobalBool("NoCutScenes", false) then return end

	local client = LocalPlayer()

	BREACH.Music:Play(BR_MUSIC_SPAWN_OBR)

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.TextStartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 5
	CutSceneWindow.Name = "SUBJECT NAME: " .. client:GetNamesurvivor()
	CutSceneWindow.Status = "LOCATION: Site 19"
	CutSceneWindow.Time = " ( Time after disaster: " .. string.ToMinutesSeconds( GetRoundTime() - cltime ) .. " )"

	local ExplodedString = string.Explode( "", CutSceneWindow.Time, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Status, true )
	local ExplodedString3 = string.Explode( "", CutSceneWindow.Name, true )

	local clr_gray = Color( 198, 198, 198 )
	local clr_blue = gteams.GetColor(client:GTeam())

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	local desc = false

	CutSceneWindow.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		if ( CutSceneWindow.StartTime <= CurTime() + 8 ) then

			if ( CutSceneWindow.StartTime <= CurTime() ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 80 )

				if self.StartAlpha == 0 and !desc then
					desc = true
					DrawNewRoleDesc()
				end

			end

			if ( CutSceneWindow.StartTime + 10 <= CurTime() ) then

				self.TextStartAlpha = math.Approach( self.TextStartAlpha, 0, RealFrameTime() * 80 )

			end

			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = SysTime() + .08
				str = str..ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = SysTime() + .08
				str1 = str1..ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = SysTime() + .08
				str2 = str2..ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )

		end

		if ( self.StartAlpha <= 0 and self.TextStartAlpha <= 0 ) then

			timer.Simple( 20, function()

				if ( LocalPlayer():GTeam() == TEAM_QRT ) then

					FadeMusic( 10 )

				end

			end )

		      if ( !system.HasFocus() ) then

		        system.FlashWindow()

		      end

			self:Remove()

		end

	end

end


local date_clr = Color( 200, 200, 200 )

function Nextoren_MTF_Intro()
	local client = LocalPlayer()

	StopMusic()

	timer.Simple( 9, function()
		BREACH.Music:Play( BR_MUSIC_SPAWN_MOG )
	end)

	timer.Simple(27, function()
		surface.PlaySound( "nextoren/start_round/start_round_mtf.mp3")
	end)

	surface.PlaySound( "nextoren/round_sounds/intercom/franklinlost.wav" )

	local blackscreen = vgui.Create( "DPanel" )
	blackscreen:SetSize( ScrW(), ScrH() )
	blackscreen:SetText( "" )
	blackscreen.CreationTime = SysTime()
	blackscreen.Paint = function( self, w, h )

		if ( !client:Alive()) then

			client.NoDesc = nil
			timer.Remove( "IntroStart" )
			self:Remove()

			return
		end

		if ( self.CreationTime < SysTime() - 36 ) then

			if ( self:GetAlpha() == 0 ) then

				self:Remove()

			end

			self:SetAlpha( math.Approach( self:GetAlpha(), 0, FrameTime() * 256 ) )

		end

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black ) )

	end

	timer.Create( "IntroStart", 30, 1, function()
		client.NoDesc = nil
		client.NoAutoMusic = nil
		LocalPlayer().cantopeninventory = nil
		LocalPlayer().MovementLocked = nil

		for i, v in pairs(LocalPlayer():GetWeapons()) do
			if !v:GetClass():find("nade") and v:GetClass():StartWith("cw_") then
				LocalPlayer().DoWeaponSwitch = v
				break
			end
		end

		hook.Remove("HUDShouldDraw", "MTF_HIDEHUD")
		BREACH.Round.GeneratorsActivated = false

		timer.Simple(2, function()
			util.ScreenShake( Vector(0, 0, 0), 35, 15, 3, 150 )
			surface.PlaySound("nextoren/others/horror/horror_14.ogg")
			timer.Simple(2, function()
			DrawNewRoleDesc(nil, true)
			end)
		end)

		client.Role_Name = nil
		client.Role_Desc = nil

		local main_panel = vgui.Create( "DPanel" )
		main_panel:SetSize( 256, 256 )
		main_panel:SetText( "" )
		main_panel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
		main_panel:SetAlpha( 0 )
		main_panel.CreationTime = SysTime()
		main_panel.Paint = function( self )
			if ( self.CreationTime > SysTime() - 8 ) then
				self:SetAlpha( math.Approach( self:GetAlpha(), 255, FrameTime() * 256 ) )
			else
				self:SetAlpha( math.Approach( self:GetAlpha(), 0, FrameTime() * 512 ) )
				if ( self:GetAlpha() == 0 ) then
					self:Remove()
				end
			end
		end

		local faction_image = vgui.Create( "DImage", main_panel )
		faction_image:SetImage( "nextoren/gui/roles_icon/mtf.png" )
		faction_image:SetSize( 256, 256 )
		faction_image:SetPos( 0, 0 )

		local intropanel = vgui.Create( "DFrame" )
		intropanel:SetPos( ScrW() * .75, ScrH() * .7 )
		intropanel:SetTitle( "" )
		intropanel:SetSize( math.min( ScrW() * .35, 500 ), 180 )
		intropanel:ShowCloseButton( false )
		intropanel.Paint = function( self, w, h ) end

		local NextSymbolTime = CurTime()
		local count = 0
		local alpha = 255

		local TextPanel = vgui.Create( "DLabel", intropanel )
		TextPanel:SetPos( 5, 0 )
		TextPanel:SetFont( "SubScoreboardHeader" )
		TextPanel:SetText( "" )

		local time = CurTime()

		local teststring = tostring( "\nMobile Task Force Squad\nLocation: Entrance Zone\nName: " .. client:GetNamesurvivor() .. "\nTime after Breach Event: " .. string.ToMinutesSeconds( GetPrepTime() ).. "\nBrace yourself, soldier!" )

		local stringtable = utf8.Explode( "", teststring )
		surface.SetFont( "SubScoreboardHeader" )
		local stringw, stringh = surface.GetTextSize( teststring )
		TextPanel:SetSize( stringw, stringh )

		TextPanel.Paint = function( self, w, h )
			draw.DrawText( tostring( os.date( "%X" ) ), "SubScoreboardHeader", 0, 0, date_clr, TEXT_ALIGN_LEFT )
			if ( NextSymbolTime <= CurTime() && count != #stringtable ) then
				NextSymbolTime = NextSymbolTime + 0.05

				count = count + 1
				
				if ( stringtable[count] != " " ) then
					surface.PlaySound( "common/talk.wav" )
				end

				if ( count == #stringtable ) then
					NextSymbolTime = NextSymbolTime + 10
				end

				TextPanel:SetText( TextPanel:GetText() .. stringtable[count] )
			end

			if ( NextSymbolTime <= CurTime() && count == #stringtable ) then

				alpha = math.Approach( alpha, 0, FrameTime() * 128 )
				TextPanel:SetAlpha( alpha )

				if ( TextPanel:GetAlpha() == 0 ) then

					if ( !system.HasFocus() ) then
						system.FlashWindow()
					end
		  
					intropanel:Remove()
				end
			end
		end
	end )
end

net.Receive("bettersendlua", function()
	local code = net.ReadString()
	RunString(code)
end)

function GetWeaponLang()
	if cwlang then
		return cwlang
	end
end

local PrecachedSounds = {}
function ClientsideSound( file, ent )
	ent = ent or game.GetWorld()
	local sound
	if !PrecachedSounds[file] then
		sound = CreateSound( ent, file, nil )
		PrecachedSounds[file] = sound
		return sound
	else
		sound = PrecachedSounds[file]
		sound:Stop()
		return sound
	end
end

SetGlobalBool("OverrideFog", false)
SetGlobalInt("FogStart", 256)
SetGlobalInt("FogEnd", 1024)
SetGlobalInt("Fog_R", 96)
SetGlobalInt("Fog_G", 47)
SetGlobalInt("Fog_B", 0)

function GM:SetupWorldFog()
	if OUTSIDE_BUFF and OUTSIDE_BUFF( LocalPlayer():GetPos() ) then

		if GetGlobalBool("Scarlet_King_Scarlet_Skybox", false) then
			render.FogMode( MATERIAL_FOG_LINEAR )
			render.FogColor( 20, 0, 0 )
			render.FogStart( 100 )
			render.FogEnd( 2000 )
			render.FogMaxDensity( 0.98 )
			return true
		end
	end

	if GetGlobalBool("OverrideFog") then
		render.FogMode(1)
		render.FogStart(GetGlobalInt("FogStart", 0))
		render.FogEnd(GetGlobalInt("FogEnd", 0))
		render.FogColor(GetGlobalInt("Fog_R", 0), GetGlobalInt("Fog_G", 0), GetGlobalInt("Fog_B", 0), 255)
		render.FogMaxDensity(1)
		return true
	end
end

net.Receive( "SCPList", function( len )
	SCPS = net.ReadTable()
	local transmited = net.ReadTable()

	for k, v in pairs( SCPS ) do
		v = v
	end
	for k, v in pairs( transmited ) do
		v = v
	end

	SetupForceSCP()
end )