BREACH.Round = BREACH.Round or {
    roundType = roundType or ""
}

MAP_LOADED = MAP_LOADED or false

local function CleanupEntities()
    for _, ent in ents.Iterator() do
		local class = ent:GetClass()

		ent:StopParticles()
		
        if class:find("br_") or class:find("breach_") or class:find("cw_") or class:find("item_") or class:find("armor_") or class:find("scp_") or class:find("bonemerge") or class == "base_gmodentity" then
            SafeRemoveEntity(ent)
        end

        if ent:CreatedByMap() then
            ent:RemoveAllDecals()
            ent:Extinguish()
        end
    end
end

local function CleanupPlayers()
    for _, v in player.Iterator() do
		v:SetGTeam(TEAM_SPEC)
        v:RemoveAllDecals()
        v:Extinguish()
		v:RemoveAllAmmo()
		v:StripWeapons()

		player_manager.SetPlayerClass( v, "class_breach" )
		player_manager.RunClass( v, "SetupDataTables" )

        v:SetModelScale( 1 )
		v:SetCrouchedWalkSpeed(0.6)
		v.mblur = false
		v:Freeze(false)
		v.MaxUses = nil
		v.blinkedby173 = false
		v.scp173allow = false
		v.scp1471stacks = 1
		v.usedeyedrops = false
		v.isescaping = false
		v.mvpstatistics = {}

		v:bSendLua( "CL_BLOOD_POOL_ITERATION = CL_BLOOD_POOL_ITERATION + 1 CamEnable = false" )
	end
end

local function ResetRoundStats()
    preparing = false
	postround = false
    gamestarted = false
	
	forcesupportplys = {}
	forcesupportname = nil
	forceround = nil

    Recontain106Used = false
	OMEGAEnabled = false
	OMEGADoors = false
	nextgateaopen = 0
	spawnedntfs = 0
	roundstats = {
		descaped = 0,
		rescaped = 0,
		sescaped = 0,
		dcaptured = 0,
		rescorted = 0,
		deaths = 0,
		teleported = 0,
		snapped = 0,
		zombies = 0,
		secretf = false
	}

	inUse = false

    SetGlobalBool("Evacuation_HUD", false)
	SetGlobalBool("NukeTime", false)
	SetGlobalBool("Evacuation", false)
	
	Monitors_Activated = 0
	OpenSecDoors = false
	SCPLockDownHasStarted = false

    BREACH.Evacuation = false 
	BREACH.Decontamination = false
    BREACH.Round.roundType = nil
	BREACH.Round.timers = {}

	timer.Remove("BreachRoundSetup")
    timer.Remove("PreparingTime")
	timer.Remove("NukeTimer")
	timer.Remove("RoundTime")
	timer.Remove("PostTime")
	timer.Remove("GateOpen")
	timer.Remove("PlayerInfo")
	timer.Remove("NTFEnterTime")
	timer.Remove("966Debug")
	timer.Remove("MTFDebug")
	timer.Remove("PunishEnd")
	timer.Remove("GateExplode")
    timer.Remove("RandomAnnouncer")
    timer.Remove("CheckEscape")

	timer.Remove("SupportSpawnFirst")
	timer.Remove("SupportSpawnSecond")

	timer.Remove("MTFDoor")
	timer.Remove("FunnyDecontMusic")
	timer.Remove("SecurityDoor")
	timer.Remove("Announce15Min")
	timer.Remove("Decont1Min")
	timer.Remove("OpenCheckpoints")
	timer.Remove("DecontEnd")
	timer.Remove("Decont10Min")
	timer.Remove("Decont5Min")
	timer.Remove("EvacuationTemp")
	timer.Remove("EvacuationTechnologies")
	timer.Remove("Breach.Decont-Gas")

    Radio_RandomizeChannels()
end

function CanStartBigRound()
    local can = false
    local players = GetActivePlayers()

    if #players >= 32 then
        can = true
    end

    return can
end

function RoundEnd(result, fake)
	print( "Round end, starting postround..." )

	postround = true

	result = result or "l:roundend_alphawarhead"

	AlphaWarheadBoomEffect()

	timer.Simple(5, function()
		for _, v in player.Iterator() do
			if v:GTeam() != TEAM_SPEC and not fake then
				v:Kill()
				v:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 255 ), 0.6, 4 )
				v:bSendLua("util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 3, 5000 )")

				timer.Simple(9, function()
					for _, v in player.Iterator() do
						v:bSendLua("LocalPlayer().no_signal = true")
					end
				end)	
			end
		end
	end)

	for _, v in player.Iterator() do v:bSendLua("StopMusic(1) surface.PlaySound('nextoren/ending/nuke.mp3')") end

	net.Start("New_RoundStatistics") 
		net.WriteString(result)
		net.WriteFloat(27)
	net.Broadcast() 

	timer.Create("PostTime", GetPostTime(), 1, function()
		postround = false
		RoundRestart()
	end)
end

function RoundRestart()
    assert( MAP_LOADED, "Map config is not loaded and game will not start! Change map to supported one in order to play this gamemode!" )

	print( "(Re)starting round..." )

	if GetGlobalInt("RoundUntilRestart") then
		if GetGlobalInt("RoundUntilRestart", 10) < 1 and game.GetIPAddress() == "37.230.137.74:27015" then
			--BREACH.Relay:SendRoundStats("закончи")
			RestartGame()
		else
			--SetGlobalInt("RoundUntilRestart", 10)
		end

		SetGlobalInt("RoundUntilRestart", GetGlobalInt("RoundUntilRestart") - 1)
	end

	--BREACH.Relay:SendRoundStats("продолжай")

	local t_start = SysTime()
	util.TimerCycle()

	CleanupPlayers()
	print( string.format( "Players cleaned - %i ms!", util.TimerCycle() ) )

	CleanupEntities()
	print( string.format( "Entities cleaned - %i ms!", util.TimerCycle() ) )

	game.CleanUpMap( false, nil, function() end)
	print( string.format( "Map cleaned - %i ms!", util.TimerCycle() ) )

	ResetRoundStats()
	print( string.format( "Round data reset - %i ms!", util.TimerCycle() ) )

    if #GetActivePlayers() < BREACH.CFG.RoundMinPlayers then
		MsgC( Color( 255, 50, 50 ), "Not enough players to start round! Round restart canceled!\n" )

		gamestarted = false BroadcastLua('gamestarted = false')

		for k, v in player.Iterator() do
			v:KillSilent()
			v:SetSpectator()
		end

		return
	end

    SelectRoundType()

	timer.Simple(.53, function()	
		-- Start round
		local prep = BREACH.Round.roundType.preptime or GetPrepTime()
		local roundtime = BREACH.Round.roundType.roundtime or GetRoundTime()
	
		net.Start("UpdateRoundType")
		net.WriteString(BREACH.Round.roundType.name)
		net.Broadcast()
	
		gamestarted = true BroadcastLua('gamestarted = true')

		print( "Initializing round..." )

		BREACH.Round.roundType.init()
		
		preparing = true
	
		print( string.format( "Took - %i ms to initialize round!", util.TimerCycle() ) )
	
		BREACH.Round.roundType.setup()

		print( "Preparing started..." )
	
		net.Start("PrepStart")
			net.WriteInt(roundtime, 8) -- #Todo
		net.Broadcast()

		timer.Create("PreparingTime", prep, 1, function()
			preparing = false

			net.Start("RoundStart")
				net.WriteInt(roundtime, 12)
			net.Broadcast()

			timer.Create("RoundTime", roundtime, 1, function()
				RoundEnd()
			end)

			BREACH.Round.roundType.roundstart()
			
			print( "Ending preparing, starting round... God, bless this round" )
		end)
	end)
end

function FreezeRound(state)
	if state then
		timer.Pause("RoundTime")
	else
		timer.UnPause("RoundTime")
	end
end

local abouttostart = false
function CheckRoundStart()
	if not gamestarted and #GetActivePlayers() >= 10 then
		if !abouttostart then
			abouttostart = true

            local time = 145

            SetGlobalBool("EnoughPlayersCountDown", true)
            SetGlobalInt("EnoughPlayersCountDownStart", CurTime() + time)
        
			BroadcastPlayMusic(nil, BR_MUSIC_COUNTDOWN)

			timer.Simple(time - 4, function()
				for _, v in player.Iterator() do 
					v:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5.7, 6)
				end
			end)

			timer.Simple(time, function()
				SetGlobalBool("EnoughPlayersCountDown", false)

				abouttostart = false

				if not gamestarted then
					if #GetActivePlayers() < 10 then
						MsgC( Color( 255, 50, 50 ), "Round start terminated due to not enough players!" )
						return
					end

					gamestarted = true BroadcastLua('gamestarted = true')
					RoundRestart()
				end
			end)
		end
	end
end