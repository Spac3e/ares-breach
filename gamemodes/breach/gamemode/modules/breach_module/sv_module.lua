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

local weapons_table = {
	"cw_kk_ins2_doi_mp40",
	"cw_kk_ins2_doi_k98k",
	"cw_kk_ins2_doi_g43"
}

net.Receive("GiveWeaponFromClient", function(len, ply)
    if not IsValid(ply) or ply:GetRoleName() ~= "SCP062DE" then
        return
    end

    local weapon = net.ReadString()

    if not weapons_table[weapon] then
        return
    end

    if ply:HasWeapon(weapon) then
        return
    end

    ply:Give(weapon)
    ply:SelectWeapon(weapon)

	ply.weaponfromclient = true
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

function GM:GetFallDamage(ply, speed)
    local dmg = speed / 8
    local ground = ply:GetGroundEntity()

    if ground:IsPlayer() then
		ground:TakeDamage(ply:GetRoleName() == "Class-D Fat" and dmg * 10 or dmg * 1.65, ply, ply)
	end

    ply:EmitSound("nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0" .. math.random(1, 2) .. ".wav")

    return dmg
end

function GM:PlayerDeathSound(ply)
    return true
end

function GM:PlayerHurt(victim, attacker, health, damage)
	if victim:GTeam() == TEAM_SCP and !victim.Zombie then
		return
	end

	if victim:WouldDieFrom(damage) then
		return victim:Voice("die")
	end

    if !((victim.NextPain or 0) < CurTime() and health > 0) then return end

	victim:Voice("hit")

	if attacker and attacker:IsPlayer() and attacker:GTeam() == TEAM_GRU and victim:Alive() and attacker:GetActiveWeapon().CW20Weapon and ((attacker.NextSpot or 0) < CurTime() and health > 0) then
		attacker:EmitSound("nextoren/vo/gru/spot" .. math.random(1, 7) .. ".wav")
		attacker.NextSpot = CurTime() + math.Rand(8.92,12.85)
	end

    victim.NextPain = CurTime() + math.Rand(1.55, 4.22)
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