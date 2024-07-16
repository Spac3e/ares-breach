BREACH.Round = BREACH.Round or {}

function GetRoleTable(all)
    local classd, security, scientist, mtf, specials = {}, {}, {}, {}, {}
    local all_start = all
    local roletable = BREACH_ROLES

    if all_start < 15 then
        classd = {count = math.Round(all_start * 0.43), roles = roletable.CLASSD.classd["roles"], spawns = SPAWN_CLASSD}
        all = all - classd.count

        scientist = {count = math.Round(all_start * 0.31), roles = roletable.SCI.sci["roles"], spawns = SPAWN_SCIENT}
        all = all - scientist.count

        mtf = {count = math.Round(all_start * 0.19), roles = roletable.MTF.mtf["roles"], spawns = SPAWN_GUARD}
        all = all - mtf.count

        print("Класс-Д: " .. classd.count, "МОГ: " .. mtf.count, "Уч: " .. scientist.count)
        return {classd, scientist, mtf}
    elseif all_start < 20 then
        classd = {count = math.Round(all_start * 0.34), roles = roletable.CLASSD.classd["roles"], spawns = SPAWN_CLASSD}
        all = all - classd.count

        security = {count = math.Round(all_start * 0.2), roles = roletable.SECURITY.security["roles"], spawns = SPAWN_SECURITY}
        all = all - security.count

        mtf = {count = math.Round(all_start * 0.2), roles = roletable.MTF.mtf["roles"], spawns = SPAWN_GUARD}
        all = all - mtf.count

        scientist = {count = math.Round(all_start * 0.3), roles = roletable.SCI.sci["roles"], spawns = SPAWN_SCIENT}
        all = all - scientist.count

        print("Класс-Д: " .. classd.count, "МОГ: " .. mtf.count, "СБ: " .. security.count, "Уч: " .. scientist.count)
        return {classd, security, mtf, scientist}
    else
        classd = {count = math.Round(all_start * 0.38), roles = roletable.CLASSD.classd["roles"], spawns = SPAWN_CLASSD}
        all = all - classd.count

        security = {count = math.Round(all_start * 0.18), roles = roletable.SECURITY.security["roles"], spawns = SPAWN_SECURITY}
        all = all - security.count

        mtf = {count = math.Round(all_start * 0.21), roles = roletable.MTF.mtf["roles"], spawns = SPAWN_GUARD}
        all = all - mtf.count

        scientist = {count = math.Round(all_start * 0.35), roles = roletable.SCI.sci["roles"], spawns = SPAWN_SCIENT}
        all = all - scientist.count

        specials = {count = 1, roles = roletable.SPECIAL.special["roles"], spawns = SPAWN_SCIENT}
        all = all - specials.count

        print("Класс-Д: " .. classd.count, "МОГ: " .. mtf.count, "СБ: " .. security.count, "Уч: " .. scientist.count, "Спец.Уч: " .. specials.count)
        return {classd, security, mtf, scientist, specials}
    end
end

function SetupPlayers(tab)
    local players = player.GetAll()
    local all = #players
    local scp = 0

    if all < 23 then
        scp = 1
    else
        scp = 2
    end

    local scpplayer = {}
    local SCP = table.Copy(SCPS)

    for _, v in pairs(players) do
        table.insert(scpplayer, v)
    end

    local ply = table.remove(scpplayer, math.random(#scpplayer))

    for i = 1, scp do
        if #SCP == 0 then 
            break 
        end

        if not IsValid(ply) then
            continue
        end

        local obj = GetSCP(table.remove(SCP, math.random(#SCP)))

        table.RemoveByValue(players, ply)

        obj:SetupPlayer(ply)
        ply:SetGTeam(TEAM_SCP)

        all = all - 1
    end

    for _, v in ipairs(tab) do
        local inuse = {}
        local spawns = table.Copy(v["spawns"])

        for i = 1, v["count"] do   
            local roles = table.Copy(v["roles"])
            local selected
            local ply = table.remove(players, math.random(#players))

            if not IsValid(ply) then
                continue
            end

            repeat
                local role = table.remove(roles, math.random(#roles))
                inuse[role["name"]] = inuse[role["name"]] or 0

                if role["max"] == 0 or inuse[role["name"]] < role["max"] then
                    if role["level"] <= ply:GetLevel() then
                        selected = role
                        break
                    end
                end
            until #roles == 0

            if not selected then
                selected = v["roles"][1]
            end

            inuse[selected["name"]] = inuse[selected["name"]] + 1

            if #spawns == 0 then 
                spawns = table.Copy(v["spawns"])
            end

            local spawn = table.remove(spawns, math.random(#spawns))

            ply:SetupNormal()
            ply:ApplyRoleStats(selected)
            ply:SetPos(spawn)

            print("Спавн " ..ply:Nick() .. " за роль: " .. selected["name"])
        end
    end
end

-- ДАЛЬШЕ ИДЁТ ПРОТИВНЫЙ МУСОР
function CheckEscape()
    for _, v in pairs(ents.FindInSphere(POS_UIUTUNNEL, 15)) do
        if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_GOC then            
            if v:GTeam() == TEAM_USA then
                if not GetGlobalBool("Evacuation") or m_UIUCanEscape then
                    v:Evacuate()
                end
            elseif v:GTeam() == TEAM_CLASSD and v:CanEscapeFBI() then
                v:Evacuate()
            elseif v:GTeam() != TEAM_USA then
                v:Evacuate()
            end
        end
    end

    for k, v in pairs(ents.FindInSphere(POS_UNKNOWNTUNNEL, 50)) do
        if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:CanEscapeChaosRadio() and not v.escaping then
            v.escaping = true
            v:ConCommand("stopsound")
            v:Freeze(true)
            net.Start("StartCIScene")
            net.Send(v)
            timer.Simple(9, function()
                v:AddToStatistics("l:ending_captured_by_unknown", 1200)
                v:Evacuate()
                v:Freeze(false)
                v.escaping = false
            end)
        end
    end

    for k, v in pairs(ents.FindInSphere(POS_ESCAPEALL, 75)) do
        if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:CanEscapeHand() then
            v:AddToStatistics("l:ending_escaped_site19", 730)
            v:Evacuate()
        end
    end

    for k, v in pairs(ents.FindInSphere(POS_CARESCAPE, 800)) do
        if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:CanEscapeCar() and v:InVehicle() then
            v:ExitVehicle()
            v:AddToStatistics("l:ending_car", 900)
            timer.Simple(0.1, function()
                v:Evacuate()
            end)
        end
        if v:GetModel() == "models/scpcars/scpp_wrangler_fnf.mdl" then
            v:Remove()
        end
    end

    for k, v in pairs(ents.FindInSphere(POS_O5EXIT, 225)) do
        if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:CanEscapeO5() then
            v:AddToStatistics("l:ending_o5", 840)
            v:Evacuate()
        end
    end
end

function BREACH.Round.OpenDblock()
	for _, box in pairs(ents.FindInBox( Vector( 7815, -6224, 239 ), Vector( 7900, -4864, 460 ) )) do
		if IsValid(box) then
			if box:GetClass() == "func_door" then 
				box:Fire("open") 
			end
		end
    end

    for _, box in pairs(ents.FindInBox( Vector( 6256, -6260, 117 ), Vector( 6057, -4922, 310 ) )) do
		if IsValid(box) then
			if box:GetClass() == "func_door" then 
				box:Fire("open") 
			end
		end
    end
end

function OpenMTFDoor()
	local sbdoors = {Vector(-1065, 5475, 50),Vector(-1851, 5388, 76),Vector(-2147, 5706, 58)}

    timer.Create("RandomAnnouncer", math.random(46,53), math.random(5,7), function()
        for _, v in ipairs(player.GetAll()) do
            if not IsValid(v) then
                return
            end

            if v:Outside() then
                return
            end

            local announcement = "nextoren/round_sounds/intercom/"..math.random(1,19)..".ogg"

            net.Start( "BreachAnnouncer" )
                net.WriteString( announcement )
            net.Send(v)    
        end
    end)

	SmartFindInSphere(sbdoors, 5, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("unlock")
		end
	end)
end

function OpenSecurityDoor()
	sound.Play( 'nextoren/others/button_unlocked.wav', Vector(4743, -2750, 66) ) OpenSecDoors = true
end

function OpenSCPDoors()
    local ai_scp_door = {Vector(2568, 3005, -320), Vector(2602, 3134, -328), Vector(2537, 3134, -331), Vector(5838, 1514, 52), Vector(5287, 1528, 67), Vector(6984, 2523, 58), Vector(4988, 3573, 57), Vector(8271, 912, 50), Vector(7562, -267, 57), Vector(5419, 334, 66), Vector(3707, 434, 54), Vector(2422, 1526, 70)}
    
    --SmartFindInSphere(ai_scp_door, 3, function(sphere) if sphere:GetModel() == "models/next_breach/light_cz_door.mdl" then sphere:Remove() end end)
    
    SmartFindInSphere(BREACH.CFG.RoundSCPDoors, 50, function(sphere)
        if sphere:GetClass() == "func_door" then
            sphere:Fire("unlock")
            sphere:Fire("open")
        elseif sphere:GetClass() == "func_button" then
            sphere:Fire("open")
            sphere:Fire("unlock")
        elseif sphere:GetClass() == "func_rot_button" then
            sphere:Fire("open")
            sphere:Fire("unlock")
        end

        if sphere:GetModel() == "models/next_breach/light_cz_door.mdl" then sphere:Remove() end
    end)
end

function SpawnEvacuationVehicles()
	local heli = ents.Create('heli')
	heli:Spawn()
	local btr = ents.Create('apc')
	btr:Spawn()
	local portal = ents.Create('portal')
	portal:Spawn()
	SetGlobalBool('Evacuation_HUD', true)
	for k, v in pairs(player.GetAll()) do
		v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:evac_start', Color(255, 0, 0))
	end
	PlayAnnouncer('nextoren/round_sounds/main_decont/final_nuke.mp3')
end

function OpenCheckpoints()
	SmartFindInSphere(BREACH.CFG.RoundCheckpoints, 5, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("open")
		end
	end)

	PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_countdown.ogg" )

	local SPAWN_ALARMS = {
		Vector(9634.434570, -626.971497, 196.748062),
		Vector(8159.033691, -1593.655762, 206.421295),
		Vector(7455.475586, -1095.210327, 94.144287),
		Vector(6881.367188, -1601.432983, 159.702118),
		Vector(4764.329102, -2223.142334, 168.979858)
	}

	for _, v in pairs(SPAWN_ALARMS) do
		local ent = ents.Create("br_alarm")
		if IsValid(ent) then
			ent:SetPos(v)
			ent:Spawn()
			WakeEntity(ent)
		end
	end	
end

function InGas(ply)
    if not GAS_AREAS then return false end

    local pos = ply:GetPos()
    for _, v in pairs(GAS_AREAS) do
        local pos1, pos2 = v[1], v[2]
        OrderVectors(pos1, pos2)

        if pos:WithinAABox(pos1, pos2) then
            return true
        end
    end

    return false
end

function CloseCheckpoints()
	PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_ending.ogg" )
	
	for k,v in pairs(ents.FindByClass("br_alarm")) do v:Remove() end

    SmartFindInSphere(BREACH.CFG.RoundCheckpoints, 40, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("close")
			sphere:Fire("unlock")
		end
	end)

    local kashli_na_vbr = {
        "nextoren/unity/cough1.ogg",
        "nextoren/unity/cough2.ogg",
        "nextoren/unity/cough3.ogg"
    }

    local whitelistmodels = {
        "models/cultist/humans/mog/mog_hazmat.mdl",
        "models/cultist/humans/sci/hazmat_1.mdl",
        "models/cultist/humans/sci/hazmat_2.mdl",
        "models/cultist/humans/dz/dz.mdl",
        "models/cultist/humans/goc/goc.mdl",
        "models/cultist/humans/scp_special_scp/special_5.mdl",
        "models/cultist/humans/scp_special_scp/special_6.mdl",
        "models/cultist/humans/scp_special_scp/special_8.mdl",
        "models/cultist/scp/173.mdl"
    }

    local roleswhitelist = {
        [role.DZ_Gas] = true,
    }

    timer.Create("Breach.Decont-Gas", 3, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            if not IsValid(ply) or not ply:Alive() or ply:GTeam() == TEAM_SPEC or ply.GASMASK_Equiped or whitelistmodels[ply:GetModel()] or roleswhitelist[ply:GetRoleName()] then 
                continue 
            end

            if InGas(ply) then
                if ply:GetMoveType() != MOVETYPE_NOCLIP then
                    ply:TakeDamage(ply:GetMaxHealth() / 10)
                    ply:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)])
                end
            end
        end
    end)
end

function PreEvacTemp()
    BroadcastPlayMusic(BR_MUSIC_EVACUATION)
    for k,v in pairs(player.GetAll()) do 
		v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:evac_start_leave_immediately', Color(255, 0, 0)) 
    end 
    PlayAnnouncer( 'nextoren/round_sounds/intercom/start_evac.ogg' ) 
    SetGlobalBool('Evacuation', true) 
    BREACH.Evacuation = true
end