if CLIENT then
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
	net.Receive("UnderhellLocation", function()
		if UH_Location_Color != nil then
			if UH_Location_Color != 0 and UH_Location_Color > 100 then
				UH_Location = net.ReadString()
				return
			end
		end
		timer.Remove("Remove_UH_Location")
		timer.Remove("uh_location_linear_color")
		timer.Remove("Decrease_UH_Location_Color")
		UH_Location = net.ReadString()
		Current_UH_Location = UH_Location
		timer.Create("Remove_UH_Location", 10, 1, function()
			UH_Location = nil
			Current_UH_Location = nil
		end)
		timer.Create("Decrease_UH_Location_Color", 5, 1, function()
			timer.Remove("uh_location_linear_color")
			local ratio = 0
			local time = 0
			UH_Location_Color = 255
	
			timer.Create("uh_location_linear_color", FrameTime(), 999999999, function()
				ratio = 0.007 + ratio
				time = time + FrameTime()
				UH_Location_Color = Lerp(ratio, 255, 0)
			end)
		end)
	
		local ratio = 0
		local time = 0
		UH_Location_Color = 0
	
		timer.Create("uh_location_linear_color", FrameTime(), 999999999, function()
			ratio = 0.007 + ratio
			time = time + FrameTime()
			UH_Location_Color = Lerp(ratio, 0, 255)
		end)
	
	end)
	
	hook.Add("HUDPaint", "UnderhellLocation_Draw", function()
		if UH_Location != nil then
			draw.SimpleTextOutlined(UH_Location, "ScoreboardDefault", ScrW() * 0.75, ScrH() * 0.6, Color(255, 255, 255, UH_Location_Color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.5, Color(0, 0, 0, UH_Location_Color))
		end
	end)
	
	net.Receive("BreachNotifyFromServer", function()
		local message = net.ReadTable()
	
		if message == nil then return end
			for k, v in ipairs(message) do
				if !isstring(v) then
					continue
				end
	
				if v != GetLangRole(v) then
					message[k] = GetLangRole(v)
				end
	
				if v:find("l:") or v:find("dont_translate:") then
					if v:find("l:uiu_remaining_computers") and Monitors_Activated <= 1 then
						BREACH.Music:Play(BR_MUSIC_FBI_AGENTS_START)
					elseif v == "l:uiu_mission_complete" then
						BREACH.Music:Play(BR_MUSIC_FBI_AGENTS_ESCAPE)
					end
					message[k] = BREACH.TranslateString(v)
				end
			end
			chat.AddText(Color(230, 0, 0), "[Ares Breach] ", Color(255, 255, 255), unpack(message))
	end)
	
	net.Receive("BreachWarningFromServer", function()
		local message = net.ReadString()
	
		if message == nil then return end
			chat.AddText(Color(230, 0, 0), "[Ares Breach] ", Color(255, 150, 150), message)
	end)
	
	--1.0 compatibility
	BREACH = BREACH || {}
	BREACH.Player = {}
	function BREACH.Player:ChatPrint(bool1, bool2, ...)
		AresNotify({...})
	end

	function AresNotify(msg)
		if isstring(msg) then
			msg = {msg}
		end
	
		for k, v in ipairs(msg) do
			if IsColor(v) then
				continue
			end
	
			if isstring(v) and (v:find("l:") or v:find("dont_translate:")) then
				msg[k] = BREACH.TranslateString(v)
			end
		end
	
		chat.AddText(Color(230, 0, 0), "[Ares Breach] ", Color(255, 255, 255), unpack(msg))
	end
	
	function RXSENDWarning(message)
	if message == nil then return end
	
	if isstring(message) then message = {message} end
	
	for k, v in ipairs(message) do
				if IsColor(v) then
					continue
				end
				
				if v:find("l:") or v:find("dont_translate:") then
					message[k] = BREACH.TranslateString(v)
				end
			end
			chat.AddText(Color(230, 0, 0), "[Ares Breach] ", Color(255, 150, 150), unpack(message))
	end
	
	end
	
	if SERVER then
	local RunConsoleCommand = RunConsoleCommand;
	local tonumber = tonumber;
	local tostring = tostring;
	local CurTime = CurTime;
	local Entity = Entity;
	local unpack = unpack;
	local table = table;
	local pairs = pairs;
	local concommand = concommand;
	local timer = timer;
	local ents = ents;
	local hook = hook;
	local math = math;
	local pcall = pcall;
	local ErrorNoHalt = ErrorNoHalt;
	local DeriveGamemode = DeriveGamemode;
	local util = util
	local net = net
	local player = player
	util.AddNetworkString("BreachNotifyFromServer")
	
	local mply = FindMetaTable("Player")
	
	--1.0 compatibility
	BREACH = BREACH || {}
	BREACH.Players = {}
	function BREACH.Players:ChatPrint(players, bool1, bool2, ...)
		if istable(players) then
			for k, v in ipairs(players) do
				v:AresNotify(...)
			end
	
		elseif IsEntity(players) then
			players:AresNotify(...)
		end
	end
	
	function mply:AresNotify(...)
	--print(debug.traceback())
		net.Start("BreachNotifyFromServer")
		net.WriteTable({...})
		net.Send(self)
	end
	
	util.AddNetworkString("BreachWarningFromServer")
	
	function mply:RXSENDWarning(message)
		net.Start("BreachWarningFromServer")
		net.WriteString(tostring(message))
		net.Send(self)
	end
	
	util.AddNetworkString("UnderhellLocation")
	
	function mply:LocationNotify(str)
		net.Start("UnderhellLocation")
		net.WriteString(str)
		net.Send(self)
	end
	
	util.AddNetworkString("GamemodeScripts")
	
	end