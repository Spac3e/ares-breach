ROUNDS = {}
local select_info = {}

ROUNDS.dull = {
	name = "dull",
	init = function( self ) end,
	setup = function( self ) end,
	roundstart = function( self ) end,
	postround = function( self, winner ) end,
	endcheck = function( self ) return false end,
	getwinner = function( self ) return false end
}

local function RoundEvent(name, time, func)
	print("Round: " .. timer.TimeLeft("RoundTime") or "Neizvesno", "Event: " .. name, "Time: " .. time)

    if not func then
        print("Can't initialize RoundEvent " .. name .. " It missing 'func' argument")
    elseif isfunction(func) then
        timer.Create(name, time, 1, function()
            func()
			print("Round: " .. timer.TimeLeft("RoundTime") or "Neizvesno", "Event: " .. name, "Time: " .. time)
            timer.Remove(name)
        end)

        table.insert(BREACH.Round.timers, name)
    end
end

function RoundPauseTimers()
	FreezeRound(true)

	for _, v in ipairs(BREACH.Round.timers or {}) do
		timer.Pause(v)
	end
end

function RoundResumeTimers()
	FreezeRound(false)

	for _, v in ipairs(BREACH.Round.timers or {}) do
		timer.UnPause(v)
	end
end

local function SetupRoundTimers()
    local time = GetRoundTime()
    local biground = IsBigRound()

    local Event = RoundEvent

    if biground then
		Event("MTFDoor", 30, OpenMTFDoor)
        Event("SecurityDoor", 50, OpenSecurityDoor)

		Event("Announce15Min", 60, function() 
			for k, v in pairs(player.GetAll()) do
				v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:evac_15min', Color(255, 255, 255))
			end
		end)

		Event("DecontOpenSCPs", 240, function()
			OpenSecDoors = true
			SCPLockDownHasStarted = true	
			OpenSCPDoors()
		end)

		Event("Decont10Min", 360, function() 
			for k, v in pairs(player.GetAll()) do
				v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:evac_10min', Color(255, 255, 255))
			end
			PlayAnnouncer('nextoren/round_sounds/main_decont/decont_10_b.mp3')	
		end)

		Event("FunnyDecontMusic", 390, function() BroadcastPlayMusic(BR_MUSIC_LIGHTZONE_DECONT) end)

		Event("Decont1Min", 420, function() 
			for k, v in pairs(player.GetAll()) do
				v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:decont_1min', Color(255, 255, 255))
			end
			timer.Remove('RandomAnnouncer')
			PlayAnnouncer('nextoren/round_sounds/lhz_decont/decont_1_min.ogg')	
		end)

		Event("OpenCheckpoints", 440, OpenCheckpoints)
		Event("DecontEnd", 480, function() CloseCheckpoints() BREACH.Decontamination = true end)

		Event("Decont5Min", 660, function() 
			for k, v in pairs(player.GetAll()) do
				v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:evac_5min', Color(255, 255, 255))
			end
			PlayAnnouncer('nextoren/round_sounds/main_decont/decont_5_b.mp3')	
		end)

		Event("EvacuationTemp", 765, PreEvacTemp)
		Event("EvacuationTechnologies", 830, SpawnEvacuationVehicles)
    else
		Event("MTFDoor", 20, OpenMTFDoor)
		Event("SecurityDoor", 40, OpenSecurityDoor)

		Event("Decont10Min", 180, function() 
			for k, v in pairs(player.GetAll()) do
				v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:evac_10min', Color(255, 255, 255))
			end
			PlayAnnouncer('nextoren/round_sounds/main_decont/decont_10_b.mp3')	
		end)

		Event("DecontOpenSCPs", 160, function() 
			OpenSecDoors = true
			SCPLockDownHasStarted = true	
			OpenSCPDoors()
		end)

		Event("FunnyDecontMusic", 250, function() BroadcastPlayMusic(BR_MUSIC_LIGHTZONE_DECONT) end)

		Event("Decont1Min", 270, function() 
			for k, v in pairs(player.GetAll()) do
				v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:decont_1min', Color(255, 255, 255))
			end
			timer.Remove('RandomAnnouncer')
			PlayAnnouncer('nextoren/round_sounds/lhz_decont/decont_1_min.ogg')	
		end)

		Event("OpenCheckpoints", 290, OpenCheckpoints)

		Event("DecontEnd", 330, function() CloseCheckpoints() BREACH.Decontamination = true end)

		Event("Decont5Min", 480, function() 
			for k, v in pairs(player.GetAll()) do
				v:BrTip(0, '[Ares Breach]', Color(255, 0, 0), 'l:evac_5min', Color(255, 255, 255))
			end
			PlayAnnouncer('nextoren/round_sounds/main_decont/decont_5_b.mp3')
		end)

		Event("EvacuationTemp", 585, PreEvacTemp)
		Event("EvacuationTechnologies", 650, SpawnEvacuationVehicles)
	end

    timer.Create("CheckEscape", 2, 0, CheckEscape)
end

function AddRoundType( name, tab, base, chance )
	if base then
		local bc = ROUNDS[base]

		if bc then
			setmetatable( tab, { __index = bc } )
			tab.BaseClass = bc
		end
	end

	if isnumber( chance ) and number > 0 then
		select_info[name] = chance
	end

	ROUNDS[name] = tab
end

function SelectRoundType(force) --TODO add round types
    BREACH.Round.roundType = ROUNDS.normal
end

AddRoundType( "normal", {
	name = "Containment Breach Scenario | Defualt",

	init = function( self )
		SetGlobalString("RoundName", "normal")

		if CanStartBigRound() then
			SetGlobalBool("BigRound", true)
		else
			SetGlobalBool("BigRound", false)
		end
        
		net.Start("PrepClient")	net.Broadcast()

		BUTTONS = table.Copy(BUTTONS)
		
		ResetSupportTable()
	end,
    setup = function( self )
		SetupPlayers( GetRoleTable( #GetActivePlayers() ) )

		BREACH.Round.SpawnLoot()
    end,
	roundstart = function( self )
		SetupRoundTimers()
		SetupSupportSpawn()
		BREACH.Round.OpenDblock()
	end,
	postround = function( self )
	end,
	endcheck = function( self )
	end,
	getwinner = function( self )
	end
}, "dull" )