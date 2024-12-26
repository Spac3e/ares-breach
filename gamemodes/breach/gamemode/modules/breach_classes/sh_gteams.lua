local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local pcall = pcall;
local unpack = unpack;
local tonumber = tonumber;
local tostring = tostring;
local ents = ents;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player

gteams = {}
gteams.Teams = {}

function gteams.SetUp(index, name, color)
	if isnumber(index) and isstring(name) and IsColor(color) then
		table.ForceInsert(gteams.Teams, {
			index = index,
			name = name,
			color = color,
			points
		})
	else
		ErrorNoHalt( "GTEAMS [ERROR] tried to setup invalid team!" )
		print(debug.traceback())
	end
end

function gteams.GetName(input)
	if isnumber(input) then
		for k,v in pairs(gteams.Teams) do
			if v.index == input then
				return v.name
			end
		end
	elseif isstring(input) then
		for k,v in pairs(gteams.Teams) do
			if v.name == input then
				return v.name
			end
		end
	elseif IsColor(input) then
		for k,v in pairs(gteams.Teams) do
			if v.color == input then
				return v.name
			end
		end
	end
end

function gteams.GetColor(input)
	if isnumber(input) then
		for k,v in pairs(gteams.Teams) do
			if v.index == input then
				return v.color
			end
		end
	elseif isstring(input) then
		for k,v in pairs(gteams.Teams) do
			if v.name == input then
				return v.color
			end
		end
	elseif IsColor(input) then
		for k,v in pairs(gteams.Teams) do
			if v.color == input then
				return v.color
			end
		end
	end
end

function gteams.GetScore(input)
	if isnumber(input) then
		for k,v in pairs(gteams.Teams) do
			if v.index == input then
				return v.points
			end
		end
	elseif isstring(input) then
		for k,v in pairs(gteams.Teams) do
			if v.name == input then
				return v.points
			end
		end
	elseif IsColor(input) then
		for k,v in pairs(gteams.Teams) do
			if v.color == input then
				return v.points
			end
		end
	end
end

function gteams.SetScore(input, amount)
	if isnumber(input) then
		for k,v in pairs(gteams.Teams) do
			if v.index == input then
				v.points = amount
				return
			end
		end
	elseif isstring(input) then
		for k,v in pairs(gteams.Teams) do
			if v.name == input then
				v.points = amount
				return
			end
		end
	elseif IsColor(input) then
		for k,v in pairs(gteams.Teams) do
			if v.color == input then
				v.points = amount
				return
			end
		end
	end
end

function gteams.AddScore(input, amount)
	if isnumber(input) then
		for k,v in pairs(gteams.Teams) do
			if v.index == input then
				v.points = v.points + amount
				return
			end
		end
	elseif isstring(input) then
		for k,v in pairs(gteams.Teams) do
			if v.name == input then
				v.points = v.points + amount
				return
			end
		end
	elseif IsColor(input) then
		for k,v in pairs(gteams.Teams) do
			if v.color == input then
				v.points = v.points + amount
				return
			end
		end
	end
end

function gteams.Valid(input)
	if isnumber(input) then
		for k,v in pairs(gteams.Teams) do
			if v.index == input then
				return true
			end
		end
	elseif isstring(input) then
		for k,v in pairs(gteams.Teams) do
			if v.name == input then
				return true
			end
		end
	elseif IsColor(input) then
		for k,v in pairs(gteams.Teams) do
			if v.color == input then
				return true
			end
		end
	end
	return false
end

local mply = FindMetaTable( "Player" )

function mply:GTeam()
    if !IsValid(self) then return TEAM_SPEC end
	if not self.GetNGTeam then
        player_manager.RunClass( self, "SetupDataTables" )
    end
    if not self.GetNGTeam then return TEAM_SPEC end
    return self:GetNGTeam()
end

function mply:GetGTeam()
    return self:GTeam()
end

function mply:SetGTeam(input)
	if not self.SetNGTeam then
		player_manager.RunClass( self, "SetupDataTables" )
	end

	local team_before = self:GetNGTeam()

	if isnumber(input) then
		for k,v in pairs(gteams.Teams) do
			if v.index == input then
				--LogTeamChangeFromBreach(self, team_before, v.index)
				//if self.SetNGTeam
				self:SetNGTeam(v.index)
				return
			end
		end
	elseif isstring(input) then
		for k,v in pairs(gteams.Teams) do
			if v.name == input then
				--LogTeamChangeFromBreach(self, team_before, v.index)
				self:SetNGTeam(v.index)
				return
			end
		end
	elseif IsColor(input) then
		for k,v in pairs(gteams.Teams) do
			if v.color == input then
				--LogTeamChangeFromBreach(self, team_before, v.index)
				self:SetNGTeam(v.index)
				return
			end
		end
	end
	ErrorNoHalt( "GTEAMS [ERROR] Tried to set an invalid team!" )
	print(debug.traceback())
end

function gteams.CheckTeams()
	print("GTEAMS: List")
	for k,v in pairs(gteams.Teams) do
		print(k .. " - " .. v.name .. "  index: " .. v.index .. "  color: rgb(" .. v.color.r .. "," .. v.color.g .. "," .. v.color.b .. ")")
	end
end

function gteams.CheckPlayers()
	print("GTEAMS: Players")
	for k,v in player.Iterator() do
		local tname = v:GTeam()
		print(v:Nick() .. " - " .. tostring(tname))
	end
end

function gteams.GetPlayers( input )
	local tab = {}
	if isnumber(input) then
		for k,v in player.Iterator() do
			if v:GTeam() == input then
				table.ForceInsert(tab, v)
			end
		end
	else
		ErrorNoHalt( "GTEAMS [ERROR] Tried to get list of players not using an index!" )
		print(debug.traceback())
	end
	return tab
end

function gteams.NumPlayers( input )
	local tab = {}
	if isnumber(input) then
		for k,v in player.Iterator() do
			if v:GTeam() == input then
				table.ForceInsert(tab, v)
			end
		end
	else
		ErrorNoHalt( "GTEAMS [ERROR] Tried to get number of players not using an index!" )
		print(debug.traceback())
	end
	return #tab
end

gteams.SetUp( 0, "Not Set", Color(255,255,255) )
gteams.SetUp( TEAM_SCP, "SCPs", Color(237, 28, 63) )
gteams.SetUp( TEAM_GUARD, "MTF Guards", Color(0, 100, 255) )
gteams.SetUp( TEAM_CLASSD, "Class-Ds", Color(255, 130, 0) )
gteams.SetUp( TEAM_SPEC, "Spectators", Color(141, 186, 160) )
gteams.SetUp( TEAM_SCI, "Scientists", Color(66, 188, 244) )
gteams.SetUp( TEAM_CHAOS, "Chaos Insurgency", Color(29, 81, 56) )
gteams.SetUp( TEAM_SECURITY, "Security Department", Color(123, 104, 238) )
gteams.SetUp( TEAM_GRU, "GRU", Color( 107, 142, 35 ) )
gteams.SetUp( TEAM_NTF, "Nine Tailed Fox", Color(0, 0, 255) )
gteams.SetUp( TEAM_DZ, "Serpents Hand", Color(46, 139, 87) )
gteams.SetUp( TEAM_GOC, "Global Occult Coalition", Color(178, 34, 34) )
gteams.SetUp( TEAM_USA, "Unusual Incidents Unit", color_black )
gteams.SetUp( TEAM_QRT, "Quick Response Team", Color( 25, 25, 112 ) )
gteams.SetUp( TEAM_COTSK, "Children of the Scarlet King", Color( 199, 177, 177 ) )
gteams.SetUp( TEAM_SPECIAL, "Specials", Color(238, 130, 238) )
gteams.SetUp( TEAM_OSN, "Spec. Task Force", Color(94,106,121) )
gteams.SetUp( TEAM_NAZI, "Nazi Germany", Color(35,35,35) )
gteams.SetUp( TEAM_AMERICA, "American Army", Color(255,0,0) )
gteams.SetUp( TEAM_ARENA, "Arena Participants", Color(128,0,128) )
gteams.SetUp( 21, "Spectators", Color(141, 186, 160) ) --fake spectator team just for the scoreboard

TEAM_CB = TEAM_SECURITY
TEAM_OBR = TEAM_QRT