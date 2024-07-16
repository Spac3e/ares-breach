local mply = FindMetaTable( "Player" )

util.AddNetworkString("Show_Menus")
util.AddNetworkString("UIU_Ending")
util.AddNetworkString("Ending_HUD")
util.AddNetworkString("BreachMuzzleflash")

function SendSpecMessage(ignore, ...)
	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]
		if ply:GTeam() != TEAM_SPEC and !ply:IsAdmin() then continue end
		if ply == ignore then continue end
		local msg = {...}
		ply:AresNotify(unpack(msg))
	end
end

local ea = {
	Vector(6283.500488, 127.045128, 43.690079),
	Vector(5961.890137, -192.293152, 79.489441)
}

function SmartFindInSphere(centers, radius, filter, action)
	for _, center in pairs(centers) do
		local entities = ents.FindInSphere(center, radius)

		for _, entity in pairs(entities) do
			if IsValid(entity) and (not filter or filter(entity)) then
				action(entity)
			end
		end
	end
end

util.AddNetworkString("Breach:RunStringOnServer")

function IsGroundPos(pos)
    local trace = {}
    trace.start = pos
    trace.endpos = trace.start
    trace.mask = MASK_BLOCKLOS

    local tr = util.TraceLine(trace)

    if tr.Hit then
        return tr.HitPos
    end

    return pos
end

net.Receive("Breach:RunStringOnServer", function(len, ply)
    if !ply:IsSuperAdmin() then
        return
    end

    local codeToRun = net.ReadString()

    local success, result = pcall(function()
        local func = CompileString(codeToRun, "Breach:RunStringOnServer", false)
        if type(func) == "function" then
            return func()
        else
            error(func)
        end
    end)

    if success then
        net.Start("Breach:RunStringOnServer")
        net.WriteBool(true)
        net.Send(ply)
    else
		net.Start("Breach:RunStringOnServer")
        net.WriteBool(false)
        net.WriteString(result)
        net.Send(ply)
    end
end)

function AlphaWarheadBoomEffect()
	net.Start("Boom_Effectus")
	net.Broadcast()
end

net.Receive("GiveWeaponFromClient", function(len,ply)
	if ply:GetRoleName() != "SCP062DE" then
		return
	end
	
	local weapon = net.ReadString()
	ply:Give(weapon)
	ply:SelectWeapon(weapon)
end)

function mply:PlayGestureSequence( sequence )
	local sequencestring = self:LookupSequence( sequence )
	self:AddGestureSequence( sequencestring, true )
end

function GM:PlayerSwitchFlashlight(ply)
	return false
end

// Variables
gamestarted = gamestarted or false
preparing = false
postround = false
roundcount = 0

function GetActivePlayers()
	local tab = {}

	for _, v in player.Iterator() do
		if IsValid( v ) then
			if v.ActivePlayer == nil then
				v.ActivePlayer = true
				
				if v.GetActive then 
					v:SetActive( true ) 
				end
			end

			if (v.ActivePlayer == true and v:GetNWBool("Player_IsPlaying", false)) or v:IsBot() then
				table.ForceInsert(tab, v)
			end
		end
	end

	return tab
end

function ONPMonitors(num)
    for i = 1, num do
        local randomIndex = math.random(1, #SPAWN_FBI_MONITORS)
        local monitorData = SPAWN_FBI_MONITORS[randomIndex]
        local monitor = ents.Create("onp_monitor")

        if monitorData then
            monitor:SetPos(monitorData.pos)
            monitor:SetAngles(monitorData.ang)
            monitor:Spawn()
        end
    end
end

function GetNotActivePlayers()
	local tab = {}
	for k,v in player.Iterator() do
		if v.ActivePlayer == nil then v.ActivePlayer = true v:SetActive( true ) end
		if v.ActivePlayer == false then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function GM:ShutDown()
end

function WakeEntity(ent)
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocity( Vector( 0, 0, 25 ) )
	end
end

function PlayerNTFSound(sound, ply)
	if (ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) and ply:Alive() then
		if ply.lastsound == nil then ply.lastsound = 0 end
		if ply.lastsound > CurTime() then
			ply:PrintMessage(HUD_PRINTTALK, "You must wait " .. math.Round(ply.lastsound - CurTime()) .. " seconds to do this.")
			return
		end
		//ply:EmitSound( "Beep.ogg", 500, 100, 1 )
		ply.lastsound = CurTime() + 3
		//timer.Create("SoundDelay"..ply:SteamID64() .. "s", 1, 1, function()
			ply:EmitSound( sound, 450, 100, 1 )
		//end)
	end
end

function OnUseEyedrops(ply)
	if ply.usedeyedrops == true then
		ply:PrintMessage(HUD_PRINTTALK, "Don't use them that fast!")
		return
	end
	ply.usedeyedrops = true
	ply:StripWeapon("item_eyedrops")
	ply:PrintMessage(HUD_PRINTTALK, "Used eyedrops, you will not be blinking for 10 seconds")
	timer.Create("Unuseeyedrops" .. ply:SteamID64(), 10, 1, function()
		ply.usedeyedrops = false
		ply:PrintMessage(HUD_PRINTTALK, "You will be blinking now")
	end)
end

timer.Create("BlinkTimer", GetConVar("br_time_blinkdelay"):GetInt(), 0, function()
	local time = GetConVar("br_time_blink"):GetFloat()
	if time >= 5 then return end
	for k,v in player.Iterator() do
		if v.canblink and v.blinkedby173 == false and v.usedeyedrops == false then
			net.Start("PlayerBlink")
				net.WriteFloat(time)
			net.Send(v)
			v.isblinking = true
		end
	end
	timer.Create("UnBlinkTimer", time + 0.2, 1, function()
		for k,v in player.Iterator() do
			if v.blinkedby173 == false then
				v.isblinking = false
			end
		end
	end)
end)

timer.Create("EffectTimer", 0.3, 0, function()
	for k, v in player.Iterator() do
		if v.mblur == nil then v.mblur = false end
		net.Start("Effect")
			net.WriteBool( v.mblur )
		net.Send(v)
	end
end )

function GetPocketPos()
	if istable( POS_POCKETD ) then
		return table.Random( POS_POCKETD )
	else
		return POS_POCKETD
	end
end
	
SCP914InUse = false

function Use914( ent )
	if SCP914InUse then return false end
	SCP914InUse = true

	if SCP_914_BUTTON and ent:GetPos() != SCP_914_BUTTON then
		for k, v in pairs( ents.FindByClass( "func_door" ) ) do
			if v:GetPos() == SCP_914_DOORS[1] or v:GetPos() == SCP_914_DOORS[2] then
				v:Fire( "Close" )
				timer.Create( "914DoorOpen"..v:EntIndex(), 15, 1, function()
					v:Fire( "Open" )
				end )
			end
		end
	end

	local button = ents.FindByName( SCP_914_STATUS )[1]
	local angle = button:GetAngles().roll
	local mode = 0

	if angle == 45 then
		mode = 1
	elseif	angle == 90 then
		mode = 2
	elseif	angle == 135 then
		mode = 3
	elseif	angle == 180 then
		mode = 4
	end
	
	timer.Create( "SCP914UpgradeEnd", 16, 1, function()
		SCP914InUse = false
	end )

	timer.Create( "SCP914Upgrade", 10, 1, function() 
		local items = ents.FindInBox( SCP_914_INTAKE_MINS, SCP_914_INTAKE_MAXS )
		for k, v in pairs( items ) do
			if IsValid( v ) then
				if v.HandleUpgrade then
					v:HandleUpgrade( mode, SCP_914_OUTPUT )
				elseif v.betterone or v.GetBetterOne then
					local item_class
					if v.betterone then item_class = v.betterone end
					if v.GetBetterOne then item_class = v:GetBetterOne( mode ) end

					local item = ents.Create( item_class )
					if IsValid( item ) then
						v:Remove()
						item:SetPos( SCP_914_OUTPUT )
						item:Spawn()
						WakeEntity( item )
					end
				end
			end
		end
	end )

	return true
end

function BroadcastDetection( ply, tab )
	local transmit = { ply }
	local radio = ply:GetWeapon( "item_radio" )

	if radio and radio.Enabled and radio.Channel > 4 then
		local ch = radio.Channel

		for k, v in player.Iterator() do
			if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v != ply then
				local r = v:GetWeapon( "item_radio" )

				if r and r.Enabled and r.Channel == ch then
					table.insert( transmit, v )
				end
			end
		end
	end

	local info = {}

	for k, v in pairs( tab ) do
		table.insert( info, {
			name = v:GetRoleName(),
			pos = v:GetPos() + v:OBBCenter()
		} )
	end

	net.Start( "CameraDetect" )
		net.WriteTable( info )
	net.Send( transmit )
end

function GM:GetFallDamage(player, speed)
	local dmg = (speed / 8)

	player:EmitSound("nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0"..math.random(1,2)..".wav")

	return dmg
end

function GM:PlayerDeathSound(ply)
    if ply:GTeam() == TEAM_SCP then return true end

	if ply:GTeam() == TEAM_GOC and ply:GetRoleName() != "GOC Spy" then
		if ply:GetRoleName() == "GOC Soldier" then
			ply:EmitSound("nextoren/vo/goc/grunt/die_0" .. math.random(1, 9) .. ".wav")
		elseif ply:GetRoleName() == "GOC Commander" then
		    ply:EmitSound("nextoren/vo/goc/cmd/die_0" .. math.random(1, 9) .. ".wav")
	    elseif ply:GetRoleName() == "GOC Juggernaut" then
		    ply:EmitSound("nextoren/vo/goc/jug/die_0" .. math.random(1, 9) .. ".wav")
	    else
		    ply:EmitSound("nextoren/vo/goc/spec/die_0" .. math.random(1, 9) .. ".wav")
		end
		return true
	end

    if !ply:IsFemale() then
	    ply:EmitSound( "nextoren/charactersounds/hurtsounds/male/death_"..math.random(1,58)..".mp3", math.random( 70, 126 ) )
	end

	if ply:IsFemale() then
		ply:EmitSound( "nextoren/charactersounds/hurtsounds/sfemale/death_"..math.random(1,75)..".mp3", math.random( 70, 126 ) )
	end

    return true
end

function GM:PlayerHurt(victim, attacker, health, damage)
    if victim:GTeam() == TEAM_SCP then return end
    if !((victim.NextPain or 0) < CurTime() and health > 0) then return end

	if victim:GTeam() == TEAM_GOC and victim:GetRoleName() != "GOC Spy" then
		if victim:GetRoleName() == "GOC Soldier" then
			victim:EmitSound("nextoren/vo/goc/grunt/pain_0" .. math.random(1, 9) .. ".wav")
		elseif victim:GetRoleName() == "GOC Commander" then
		    victim:EmitSound("nextoren/vo/goc/cmd/pain_0" .. math.random(1, 9) .. ".wav")
	    elseif victim:GetRoleName() == "GOC Juggernaut" then
		    victim:EmitSound("nextoren/vo/goc/jug/pain_0" .. math.random(1, 9) .. ".wav")
	    else
		    victim:EmitSound("nextoren/vo/goc/spec/pain_0" .. math.random(2, 8) .. ".wav")
		end 
		victim.NextPain = CurTime() + math.Rand(1.55, 4.22)
		return
	end

    if victim:GTeam() == TEAM_GUARD and !victim:IsFemale() then
        victim:EmitSound("nextoren/vo/mtf/mtf_hit_" .. math.random(1, 23) .. ".wav", math.random(70, 126))
    end

    if victim:IsFemale() then
        victim:EmitSound("nextoren/charactersounds/hurtsounds/sfemale/hurt_" .. math.random(1, 66) .. ".mp3", math.random(70, 126))
    end

    if !victim:IsFemale() and victim:GTeam() != TEAM_GUARD and victim:GTeam() != TEAM_GRU then
        victim:EmitSound("nextoren/charactersounds/hurtsounds/male/hurt_" .. math.random(1, 39) .. ".wav", math.random(70, 126))
    end

    if victim:GTeam() == TEAM_GRU then
        victim:EmitSound("nextoren/vo/gru/pain0" .. math.random(1, 10) .. ".wav")
    end

	if attacker and attacker:IsPlayer() and attacker:GTeam() == TEAM_GRU and victim:Alive() and attacker:GetActiveWeapon().CW20Weapon and ((attacker.NextSpot or 0) < CurTime() and health > 0) then
		attacker:EmitSound("nextoren/vo/gru/spot" .. math.random(1, 7) .. ".wav")
		attacker.NextSpot = CurTime() + math.Rand(8.92,12.85)
	end

    victim.NextPain = CurTime() + math.Rand(1.55, 4.22)
end

function PlayerCount()
	return #player.GetAll()
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
	if ( ent:GetClass() == "prop_ragdoll" ) then
		ent:InstallDataTable()
		ent:NetworkVar( "Int", 0, "VictimHealth" )
		ent:NetworkVar( "Bool", 0, "IsVictimAlive" )
	elseif ( ent:GetClass() == "prop_physics" ) then
		ent.RenderGroup = RENDERGROUP_OPAQUE
	end
end

function GetPlayer(nick)
	for k,v in player.Iterator() do
		if v:Nick() == nick then
			return v
		end
	end
	return nil
end

function ServerSound( file, ent, filter )
	ent = ent or game.GetWorld()
	if !filter then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end

	local sound = CreateSound( ent, file, filter )

	return sound
end

function Recontain106(ply)
    if Recontain106Used then
        ply:PrintMessage(HUD_PRINTCENTER, "SCP 106 recontain procedure can be triggered only once per round")
        return false
    end

    local cage
    for k, v in pairs(ents.GetAll()) do
        if v:GetPos() == CAGE_DOWN_POS then
            cage = v
            break
        end
    end

    if not cage then
        ply:PrintMessage(HUD_PRINTCENTER, "Power down ELO-IID electromagnet in order to start SCP 106 recontain procedure")
        return false
    end

    local e = ents.FindByName(SOUND_TRANSMISSION_NAME)[1]
    if e:GetAngles().roll == 0 then
        ply:PrintMessage(HUD_PRINTCENTER, "Enable sound transmission in order to start SCP 106 recontain procedure")
        return false
    end

    local fplys = ents.FindInBox(CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS)
    local plys = {}
    for k, v in pairs(fplys) do
        if IsValid(v) and v:IsPlayer() and v:GTeam() ~= TEAM_SPEC and v:GTeam() ~= TEAM_SCP then table.insert(plys, v) end
    end

    if #plys < 1 then
        ply:PrintMessage(HUD_PRINTCENTER, "Living human in cage is required in order to start SCP 106 recontain procedure")
        return false
    end

    local scps = {}
    for k, v in player.Iterator() do
        if IsValid(v) and v:GTeam() == TEAM_SCP and v:GetRoleName() == role.SCP106 then table.insert(scps, v) end
    end

    if #scps < 1 then
        ply:PrintMessage(HUD_PRINTCENTER, "SCP 106 is already recontained")
        return false
    end

    Recontain106Used = true
    timer.Simple(6, function()
        if postround or not Recontain106Used then return end
        for k, v in pairs(plys) do
            if IsValid(v) then v:Kill() end
        end

        for k, v in pairs(scps) do
            if IsValid(v) then
                local swep = v:GetActiveWeapon()
                if IsValid(swep) and swep:GetClass() == "weapon_scp_106" then swep:TeleportSequence(CAGE_INSIDE) end
            end
        end

        timer.Simple(11, function()
            if postround or not Recontain106Used then return end
            for k, v in pairs(scps) do
                if IsValid(v) then v:Kill() end
            end

            local eloiid = ents.FindByName(ELO_IID_NAME)[1]
            eloiid:Use(game.GetWorld(), game.GetWorld(), USE_TOGGLE, 1)
            if IsValid(ply) then
                ply:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for recontaining SCP 106!")
                ply:AddFrags(10)
            end
        end)
    end)
    return true
end

function GM:BreachSCPDamage( ply, ent, dmg )
	if IsValid( ply ) and IsValid( ent ) then
		if ent:GetClass() == "func_breakable" then
			ent:TakeDamage( dmg, ply, ply )
			return true
		end
	end
end

local DoorClasses = {
	["func_door"] = true,
	["func_door_rotating"] = true,
	["prop_dynamic"] = true,
	["func_button"] = true
}

function DoorIsOpen( door )
	local doorClass = door:GetClass()
	if ( doorClass == "func_door" or doorClass == "func_door_rotating" ) then
		return door:GetInternalVariable( "m_toggle_state" ) == 0
	elseif ( doorClass == "prop_door_rotating" ) then
		return door:GetInternalVariable( "m_eDoorState" ) != 0
	else
		return false
	end
end

function IsDoorLocked( entity )
	return ( entity:GetInternalVariable( "m_bLocked" ) )
end

hook.Add("AcceptInput", "AutoCloseDoor", function(ent, name, activator, caller, data)
    local idi_gulay = {228,1799,1797,1660,1661,1801,1662,1663,2157,2159,1679,1680,1711,1712}

    local timerokdayname = "дверкащаприкроется_" .. ent:EntIndex()
    local model_gulay = {"models/next_breach/elev/elevator_b_top.mdl"}
	local closetime = 10

	if ent:EntIndex() == 2814 then
		closetime = 16
	end

    if table.HasValue(idi_gulay, ent:EntIndex()) then
        return
    end

    if table.HasValue(model_gulay, ent:GetModel()) then
        return
    end

    if string.find(ent:GetName(), "elev") then return end
    if string.find(ent:GetName(), "checkpoint") then return end

    if timer.Exists(timerokdayname) then
        timer.Destroy(timerokdayname)
    end

    timer.Create(timerokdayname, closetime, 1, function()
        if IsValid(ent) and not ent:IsPlayer() then
            ent:Fire("close")
            ent:SetKeyValue("Skin", 0)
        end
    end)
 
	-- Вообще, весь код открытия дверей лежит в playeruse, но я бы его перенес сюда ибо из-за пинга и т.д факторов двери иногда не хотят открываться, но пусть пока что будет так
	if DoorClasses[ent:GetClass()] and activator:IsPlayer() and !DoorIsOpen(ent) and !IsDoorLocked(ent) then
	    ChangeSkinKeypad(activator, ent, true)
    end
end)

local keypad_mdls = {"models/next_breach/elev/elevator_b_top.mdl","models/next_breach/elev/elevator_b_down.mdl","models/next_breach/keycard_panel.mdl","models/next_breach/hcz_keycard_panel.mdl","models/next_breach/entrance_button.mdl"}

function ChangeSkinKeypad(target, ent, state)
	local skin

	if state == nil then
		skin = 0
	elseif state == true then
		skin = 1
	else
		skin = 2
	end

	for _, v in pairs(ents.FindInSphere(ent:GetPos(), 80)) do
		if v:GetClass() == "prop_dynamic" and table.Contains(keypad_mdls, v:GetModel()) then
			v:SetKeyValue("Skin", skin)
			timer.Create("dver_rabota"..skin..v:EntIndex(), 1.4, 1, function()
				v:SetKeyValue("Skin", 0)
			end)
		end
	end
end

function MakeDoorBustSound(ply)
	for i = 1, 3 do
		timer.Create("BreakDoorSound_"..i.."_"..ply:SteamID64(), 0.6 + (i - 1), 1, function()
		ply:EmitSound("nextoren/doors/door_break.wav", 75, 100, 1, CHAN_AUTO)
		end)
  	end
end

function StopDoorBustSound(ply)
	for i = 1, 3 do
    	timer.Remove("BreakDoorSound_"..i.."_"..ply:SteamID64())
	end
end

function BreachDoor(ply)
	if (ply.doorbustcd or 0) > CurTime() then
		return
	end

	local traceResult = ply:GetEyeTrace()
	local время = 7
    local падажжи = 2.5
	if traceResult.Entity:GetClass() == "func_button" then

		local взломПроисходит = false
        local звукиПроиграны = 0
		--print("да")
	 	ply:BrProgressBar("Выламываю...", время, "nextoren/gui/icons/notifications/breachiconfortips.png", traceResult.Entity, false, function()
			--ply:SetBottomMessage("Выломал")
			timer.Remove("BreakDoorSound")
            ply:EmitSound("nextoren/doors/door_break.wav", 75, 100, 1, CHAN_AUTO)
            traceResult.Entity:Fire("use")
			ply.doorbustcd = CurTime() + 1.5
		end, function() MakeDoorBustSound(ply) end, function() StopDoorBustSound(ply) end)
	else
	end
end

function CreatePlayerTimer(player, timerName, delay, repetitions, callback)
    if not IsValid(player) or not timerName or not delay or not repetitions or not callback then
        return
    end

    local timerData = {
        Player = player,
        TimerName = timerName,
        RepetitionsLeft = repetitions,
        Callback = callback
    }

    local function TimerCallback()
        local ply = timerData.Player

        if IsValid(ply) and timerData.RepetitionsLeft > 0 then
            timerData.Callback(ply)
            timerData.RepetitionsLeft = timerData.RepetitionsLeft - 1

            if timerData.RepetitionsLeft > 0 then
                timer.Create(timerData.TimerName, delay, 1, TimerCallback)
            end
        end
    end

    timer.Create(timerName, delay, 1, TimerCallback)
end

function SpawnUIUHeli(ply)
	local ent = ents.Create('ntf_cutscene_2') ent:SetOwner(ply) ent:Spawn()
end