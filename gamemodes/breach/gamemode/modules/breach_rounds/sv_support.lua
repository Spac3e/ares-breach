SUPPORTTABLE = {}

function ResetSupportTable()
    SUPPORTTABLE = {
        ["ntf"] = true,
        ["chaos"] = true,
        ["goc"] = true,
        ["dz"] = true,
        ["fbi"] = true,
        ["cotsk"] = true
    }
end

function SupportFreeze(ply, support)
	ply:Freeze(true)
	ply.cantopeninventory = true
	ply.supported = true
	ply:ConCommand("lounge_chat_clear")

	if not support == "fbi" or not support == "cotsk" then
		ply:ConCommand("stopsound")
	end
end

local function SendSpawnFunc(support, players)
    if support == "ntf" then
        spawnfunc = function(ply)
            ply:ConCommand("lounge_chat_clear")

            ply.cantopeninventory = true
            ply.supported = true
            timer.Simple(29, function()
                ply.supported = nil
            end)

            timer.Simple(31, function()
                if not IsValid(ply) then return end

                ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 2, 4)
                timer.Simple(2, function()
                    if not IsValid(ply) then return end

                    ply:Freeze(false)
                    ply.cantopeninventory = nil
                end)
            end)

			ply:bSendLua("ClientSpawnHelicopter()")

            local ntf_spawns = {
                mesto_1 = {
                    ang = Angle(0, 90, 0),
                    vec = Vector(14928, 13037, -15760)
                },
                mesto_2 = {
                    ang = Angle(0, 90, 0),
                    vec = Vector(14898, 13037, -15760)
                },
                mesto_3 = {
                    ang = Angle(0, 90, 0),
                    vec = Vector(14861, 13037, -15760)
                },
                mesto_4 = {
                    ang = Angle(0, -90, 0),
                    vec = Vector(14940, 12966, -15760)
                },
                mesto_5 = {
                    ang = Angle(0, -90, 0),
                    vec = Vector(14910, 12966, -15760)
                },
                mesto_6 = {
                    ang = Angle(0, -90, 0),
                    vec = Vector(14895, 12966, -15760)
                }
            }

            local ntf_ani = {"0_chaos_sit_1", "0_chaos_sit_2", "0_chaos_sit_3"}
            local ntfspawns = table.Copy(SPAWN_OUTSIDE)
            for k, v in pairs(players) do
                if v:GTeam() == TEAM_NTF then
                    v:SetMoveType(MOVETYPE_OBSERVER)
                    local SpawnPos = table.Random(ntf_spawns)
                    v:SetPos(SpawnPos.vec)
                    v:SetNWEntity("NTF1Entity", v)
                    v:SetNWAngle("ViewAngles", SpawnPos.ang)
                    v:SetForcedAnimation(table.Random(ntf_ani), 33)

                    timer.Simple(34, function()
                        if not IsValid(v) then return end
                        local spawn = table.remove(ntfspawns, math.random(#ntfspawns))
                        v:SetNWEntity("NTF1Entity", NULL)
                        v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
                        v:StopForcedAnimation()
                        v:SetMoveType(MOVETYPE_WALK)
                        v:SetPos(spawn)
                    end)

                    table.remove(ntf_spawns, k)
                end
            end
        end
    elseif support == "chaos" then
        spawnfunc = function(ply)
            ply:bSendLua("CutScene()")
            
            local cl_spawns = {
                mesto_1 = {
                    Angle = Angle(0, -90, 0),
                    Vector = Vector(15286, 12828, -15659)
                },
                mesto_2 = {
                    Angle = Angle(0, -90, 0),
                    Vector = Vector(15262, 12828, -15659)
                },
                mesto_3 = {
                    Angle = Angle(0, -90, 0),
                    Vector = Vector(15219, 12823, -15658)
                },
                mesto_4 = {
                    Angle = Angle(0, 90, 0),
                    Vector = Vector(15212, 12821, -15658)
                },
                mesto_5 = {
                    Angle = Angle(0, 90, 0),
                    Vector = Vector(15255, 12822, -15658)
                },
                mesto_6 = {
                    Angle = Angle(0, 90, 0),
                    Vector = Vector(15283, 12821, -15658)
                }
            }
            
            local cl_ani = {"0_chaos_sit_1", "0_chaos_sit_2", "0_chaos_sit_3"}

            local ntfspawns = table.Copy(SPAWN_OUTSIDE)
            for k, v in pairs(players) do
                v:bSendLua("APC_spawn_CI_Cutscene()")
                
                if v:GTeam() == TEAM_CHAOS and v:GetModel() == "models/cultist/humans/chaos/chaos.mdl" then
                    v:SetMoveType(MOVETYPE_OBSERVER)
                    SpawnPos = table.Random(cl_spawns)
                    v:SetPos(SpawnPos.Vector)
                    v:SetNWEntity("NTF1Entity", v)
                    v:SetNWAngle("ViewAngles", SpawnPos.Angle)
                    if v:GetRoleName() != "CI Juggernaut" then
                        v:SetForcedAnimation(table.Random(cl_ani), 20)
                    else
                        v:SetForcedAnimation("0_chaos_sit_jug", 20)
                    end

                    timer.Simple(20, function()
                        local spawn = table.remove(ntfspawns, math.random(#ntfspawns))
                        v:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5, 3)
                        v:SetNWEntity("NTF1Entity", NULL)
                        v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
                        v:StopForcedAnimation()
                        v:SetMoveType(MOVETYPE_WALK)
                        v:SetPos(spawn)
                    end)

                    table.RemoveByValue(cl_spawns, SpawnPos)
                end
            end
        end
    elseif support == "goc" then
        spawnfunc = function(ply)
            SupportFreeze(ply)
            ply:bSendLua("GOCStart()")
        end
    elseif support == "dz" then
        spawnfunc = function(ply)
            SupportFreeze(ply)
            ply:bSendLua("SHStart()")
            timer.Simple(6, function()
                net.Start("CreateParticleAtPos", true)
                net.WriteString("Kulkukan_projectile")
                net.WriteVector(Vector(-10466, -77, 1753))
                net.Broadcast()
            end)
        end
    elseif support == "fbi" then
        spawnfunc = function(ply)
            SupportFreeze(ply, "fbi")
            SpawnUIUHeli(ply)
        end
    elseif support == "cotsk" then
        spawnfunc = function(ply)
            SupportFreeze(ply, "cotsk")
            ply:bSendLua("CultStart()")
            local ent = ents.Create("ent_cult_book")
            ent:Spawn()
        end
    elseif support == "gru" then
        spawnfunc = function(ply)
            ply:bSendLua("GRUSpawn()")
            local gru_spawns = {
                mesto_1 = {
                    Angel = Vector(0, 0, 0),
                    Vector = Vector(-10650, -65, 2680)
                },
                mesto_2 = {
                    Angel = Vector(0, 0, 0),
                    Vector = Vector(-10650, -100, 2680)
                },
                mesto_3 = {
                    Angel = Vector(0, 90, 0),
                    Vector = Vector(-10737, -48, 2680)
                },
                mesto_4 = {
                    Angel = Vector(0, 90, 0),
                    Vector = Vector(-10774, -48, 2680)
                },
                mesto_5 = {
                    Angel = Vector(0, -90, 0),
                    Vector = Vector(-10784, -118, 2680)
                },
                mesto_6 = {
                    Angel = Vector(0, -90, 0),
                    Vector = Vector(-10739, -118, 2680)
                }
            }

            local gru_ani = {"0_chaos_sit_1", "0_chaos_sit_2", "0_chaos_sit_3"}
            local btr = ents.Create("prop_dynamic")
            btr:SetModel("models/sw/avia/ka60/ka60.mdl")
            btr:SetPos(Vector(-10827, -84, 2639))
            btr:Spawn()
            timer.Simple(20, function() btr:Remove() end)
            local ntfspawns = table.Copy(SPAWN_OUTSIDE)
            for k, v in pairs(players) do
                if v:GTeam() == TEAM_GRU then
                    v:SetMoveType(MOVETYPE_OBSERVER)
                    SpawnPos = table.Random(gru_spawns)
                    v:SetPos(SpawnPos.Vector)
                    v:SetNWEntity("NTF1Entity", v)
                    v:SetNWAngle("ViewAngles", SpawnPos.Angel:Angle())
                    v:SetForcedAnimation(table.Random(gru_ani), 20)
                    timer.Simple(20, function()
                        if not IsValid(v) then return end
                        local spawn = table.remove(ntfspawns, math.random(#ntfspawns))
                        v:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5, 3)
                        v:SetNWEntity("NTF1Entity", NULL)
                        v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
                        v:StopForcedAnimation()
                        v:SetMoveType(MOVETYPE_WALK)
                        v:SetPos(spawn)
                    end)

                    table.RemoveByValue(gru_spawns, SpawnPos)
                end
            end
        end
    end

    for _, ply in ipairs(players) do
        if isfunction(spawnfunc) then spawnfunc(ply) end
    end
end

local function RoleSpawnRule(faction, players, facname, support, count, spawn)
    local players = table.Copy(players)
    local plys = {}
    
    count = count or 5
    
    for i = 1, count do
        if #players > 0 then
            local ply = table.remove(players, math.random(#players))
            if ply then
                table.insert(plys, ply)
            end
        end
    end

	local inuse = {}

	local spawnpos = spawn or SPAWN_OUTSIDE

	for _, ply in ipairs(plys) do
		local roles = table.Copy(faction.roles)
		local selected

		repeat
			local role = table.remove(roles, math.random(#roles))
			inuse[role.name] = inuse[role.name] or 0

			if role.max == 0 or inuse[role.name] < role.max then
				if role.level <= ply:GetLevel() then
					if not role.customcheck or role.customcheck(ply) then
						selected = role
						break
					end
				end
			end
		until #roles == 0

		if not selected then
			selected = roles[1]
		end

		inuse[selected.name] = inuse[selected.name] + 1

		if #spawnpos >= 0 then
			spawnpos = table.Copy(spawnpos)
		end

		local spawnpos = table.remove(spawnpos, math.random(#spawnpos))

		ply:SetupNormal()
		ply:ApplyRoleStats(selected)
		ply:SetPos(spawnpos)

		SendSpawnFunc(support, plys)

		print("Спавним " .. ply:Nick() .. " за роль: " .. selected.name .. " [" .. facname .. "]")
	end 
end

local function SpawnSupportFunc(support, players)
	if support == "ntf" then
        timer.Simple(43, function()
            for k, v in pairs(player.GetAll()) do
                v:BrTip(0, "[Ares Breach]", Color(255, 0, 0), "l:ntf_enter", Color(255, 255, 255))
            end
            PlayAnnouncer("nextoren/round_sounds/intercom/support/ntf_enter.ogg")
        end)
		RoleSpawnRule(BREACH_ROLES.NTF.ntf, players, "НТФ", support)
	elseif support == "chaos" then
        PlayAnnouncer("nextoren/round_sounds/intercom/support/enemy_enter.ogg")

        timer.Simple(21, function()
            apc2 = ents.Create("prop_dynamic")
            apc2:SetModel("models/scp_chaos_jeep/chaos_jeep.mdl")
            apc2:SetPos(Vector(-10194, 877, 1749))
            apc2:SetAngles(Angle(0, 44, 0))
            apc2:SetBodygroup(1,1)
            apc2:Spawn()

            timer.Simple(30, function()
                if IsValid(apc2) then
                    apc2:Remove()
                    apc2 = nil
                end
            end)
        end)
        
		RoleSpawnRule(BREACH_ROLES.CHAOS.chaos, players, "ПХ", support)
	elseif support == "goc" then
        PlayAnnouncer("nextoren/round_sounds/intercom/support/goc_enter.mp3")

		RoleSpawnRule(BREACH_ROLES.GOC.goc, players, "ГОК", support, 4)
	elseif support == "dz" then
        PlayAnnouncer("nextoren/round_sounds/intercom/support/enemy_enter.ogg")

		RoleSpawnRule(BREACH_ROLES.DZ.dz, players, "ДЗ", support)
	elseif support == "fbi" then
		RoleSpawnRule(BREACH_ROLES.FBI.fbi, players, "ОНП", support, 5, SPAWN_FBI_HELICOPTER)
	elseif support == "cotsk" then
        PlayAnnouncer("nextoren/round_sounds/intercom/support/enemy_enter.ogg")

		RoleSpawnRule(BREACH_ROLES.COTSK.cotsk, players, "ДАК", support)
	elseif support == "gru" then
        PlayAnnouncer("nextoren/round_sounds/intercom/support/enemy_enter.ogg")

		RoleSpawnRule(BREACH_ROLES.GRU.gru, players, "ГРУ", support)
	end
end

net.Receive("ProceedUnfreezeSUP", function(len, ply)
	ply:Freeze(false)
	ply.cantopeninventory = false
	ply.supported = false
end)

function SupportSpawn()
    local players = {}
    local playerset = {}
    local count = 0

    if forcesupportplys and next(forcesupportplys) ~= nil then
        for _, ply in pairs(forcesupportplys) do
            if ply:GTeam() == TEAM_SPEC and not playerset[ply] then
                table.insert(players, ply)
                playerset[ply] = true
                count = count + 1
                if count >= 5 then
                    break
                end
            end
        end
    end

    for _, v in ipairs(player.GetAll()) do
        if count >= 5 then
            break
        end

        if v:GTeam() == TEAM_SPEC and not playerset[v] then
            table.insert(players, v)
            playerset[v] = true
            count = count + 1
        end
    end

    local plys = #players

    if plys < 4 then
        return print("Нет возможности заспавнить поддержку, недостаточно людей")
    end

    if forcesupportname and forcesupportname ~= nil then
        print("Спавним поддержку " .. forcesupportname)
        SpawnSupportFunc(string.lower(forcesupportname), players)
        forcesupportname = nil
        return
    end

    local biground = IsBigRound()

    if not biground then
        for support, active in pairs(SUPPORTTABLE) do
            if support ~= "ntf" and support ~= "chaos" then
                SUPPORTTABLE[support] = false
            end
        end
    end

    local supportvalid = {}

    for support, active in pairs(SUPPORTTABLE) do
        if active then
            table.insert(supportvalid, support)
        end
    end

    if #supportvalid == 0 then
        return print("Нет доступной поддержки для спавна")
    end

    local cursupport = supportvalid[math.random(1, #supportvalid)]

    if SUPPORTTABLE[cursupport] then
        SUPPORTTABLE[cursupport] = false
        SpawnSupportFunc(cursupport, players)
    end
end

function SetupSupportSpawn()
	local biground = IsBigRound()

    -- if postround then return end проверка из-за того что таймер может сработать к примеру при рестарте раунда

	if biground then
		timer.Create("SupportSpawnFirst", 270, 1, function()
            if postround then return end

			for _, v in player.Iterator() do
				if v:GTeam() == TEAM_GOC and v:GetRoleName() == "GOC Spy" then
					if SUPPORTTABLE["cotsk"] then
						SUPPORTTABLE["cotsk"] = false
					end
				end
			end

			SupportSpawn()
		end)

		timer.Create("SupportSpawnSecond", math.Rand(480, 420), 1, function()
            if postround then return end

            if SUPPORTTABLE["cotsk"] and SUPPORTTABLE["cotsk"] != false then
                SUPPORTTABLE["cotsk"] = false
            elseif SUPPORTTABLE["goc"] and SUPPORTTABLE["goc"] != false then
                SUPPORTTABLE["goc"] = false
            elseif SUPPORTTABLE["fbi"] and SUPPORTTABLE["fbi"] != false then
                SUPPORTTABLE["fbi"] = false
            end

			SupportSpawn()
		end)
	else
		timer.Create("SupportSpawnFirst", math.Rand(345, 330), 1, function()
            if postround then return end

			SupportSpawn()
		end)
	end
end

function BREACH.OBRSpawn(count)
    local players = {}

    for _, v in player.Iterator() do
        if v:GTeam() == TEAM_SPEC then
            table.insert(players, v)
        end
    end

    local obrsinuse = {}
    local obrspawns = table.Copy(SPAWN_OBR)
    local obrs = {}

    for i = 1, count do
        if #players == 0 then
            break
        end

        table.insert(obrs, table.remove(players, math.random(#players)))
    end

    for i, v in ipairs(obrs) do
        local obrroles = table.Copy(BREACH_ROLES.OBR.obr.roles)
        local selected

        repeat
            local role = table.remove(obrroles, math.random(#obrroles))
            obrsinuse[role.name] = obrsinuse[role.name] or 0

            if role.max == 0 or obrsinuse[role.name] < role.max then
                if role.level <= v:GetLevel() then
                    if not role.customcheck or role.customcheck(v) then
                        selected = role
                        break
                    end
                end
            end
        until #obrroles == 0

        if not selected then
            ErrorNoHalt("Something went wrong! Error code: 001")
            selected = BREACH_ROLES.OBR.obr.roles[1]
        end

        obrsinuse[selected.name] = obrsinuse[selected.name] + 1

        if #obrspawns == 0 then
            obrspawns = table.Copy(SPAWN_OBR)
        end

        local spawn = table.remove(obrspawns, math.random(#obrspawns))

        v:SetupNormal()
        v:ApplyRoleStats(selected)
        v:SendLua("OBRStart()")
        v:SetPos(spawn)
    end
end

function BREACH.PowerfulUIUSupport()
    local players = {}

    for _, v in player.Iterator() do
        if v:GTeam() == TEAM_SPEC then
            table.insert(players, v)
        end
    end

    local uiusinuse = {}
    local uiuspawns = table.Copy(SPAWN_FBI_HELICOPTER)
    local uius = {}

    for i = 1, 12 do
        if #players == 0 then
            break
        end

        table.insert(uius, table.remove(players, math.random(#players)))
    end

    for i, v in ipairs(uius) do
        local selected = BREACH_ROLES.FBI.fbi.roles[1]

        uiusinuse[selected.name] = uiusinuse[selected.name] or 0

        if selected.max == 0 or uiusinuse[selected.name] < selected.max then
            if selected.level <= v:GetLevel() then
                if not selected.customcheck or selected.customcheck(v) then
                    uiusinuse[selected.name] = uiusinuse[selected.name] or 0

                    if #uiuspawns == 0 then
                        uiuspawns = table.Copy(SPAWN_OUTSIDE)
                    end

                    local spawn = table.remove(uiuspawns, math.random(#uiuspawns))
					
                    v:SetupNormal()
                    v:ApplyRoleStats(selected)
                    
                    SupportFreeze(v, "fbi")

                    SpawnUIUHeli(v)
                    v:SetPos(spawn)
                end
            end
        end
    end

	PlayAnnouncer("nextoren/round_sounds/intercom/support/fbi_enter.ogg")
end

net.Receive( "GRUCommander_peac", function()
	for k,v in player.Iterator() do
		v:BrTip( 0, "[Ares Breach]", Color(230, 0, 0), "В комплекс прибыла дружественая групировка ГРУ для помощи военному персоналу!", Color(200, 255, 255) )
	end
end )