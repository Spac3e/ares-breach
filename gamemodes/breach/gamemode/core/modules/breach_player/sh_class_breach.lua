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

DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.AvoidPlayers = false
PLAYER.TeammateNoCollide = false

PLAYER.GetHandsModel = function(self)
    local name = player_manager.TranslateToPlayerModelName(self.Player)
    return player_manager.TranslatePlayerHands(name)
end

PLAYER.SetupDataTables = function(self)
	local ply = self.Player
	ply:NetworkVar( "String", 0, "RoleName" )
	ply:NetworkVar( "String", 1, "LastRole" )
	ply:NetworkVar( "String", 2, "Namesurvivor")
	ply:NetworkVar( "String", 3, "UsingCloth")
	ply:NetworkVar( "String", 4, "ForcedAnimation")
	ply:NetworkVar( "Int", 0, "NEXP" )
	ply:NetworkVar( "Int", 1, "NLevel" )
	ply:NetworkVar( "Int", 2, "NGTeam" )
	ply:NetworkVar( "Int", 4, "MaxSlots" )
	ply:NetworkVar( "Int", 3, "LastTeam" )
	ply:NetworkVar( "Int", 5, "SpecialMax" )
    ply:NetworkVar( "Int", 6, "PenaltyAmount" )
	ply:NetworkVar( "Int", 7, "NEscapes" )
    ply:NetworkVar( "Int", 8, "NDeaths" )
	ply:NetworkVar( "Float", 0, "SpecialCD" )
	ply:NetworkVar( "Float", 1, "StaminaScale" )
	ply:NetworkVar( "Float", 6, "Stamina")
	ply:NetworkVar( "Float", 7, "Elo")
	ply:NetworkVar( "Bool", 0, "NActive" )
	ply:NetworkVar( "Bool", 1, "NPremium" )
	ply:NetworkVar( "Bool", 2, "Active" )
	ply:NetworkVar( "Bool", 3, "Energized" )
	ply:NetworkVar( "Bool", 4, "Boosted" )
	ply:NetworkVar( "Bool", 5, "Adrenaline" )
	ply:NetworkVar( "Bool", 6, "Female" )
	ply:NetworkVar( "Bool", 7, "Stunned" )
	ply:NetworkVar( "Bool", 8, "InDimension")

	if SERVER then
		ply:SetRoleName("Spectator")
		ply:SetNamesurvivor( "none" )
		ply:SetLastRole( "" )
		ply:SetLastTeam( 0 )

		if BREACH.DataBaseSystem then
			BREACH.DataBaseSystem:LoadPlayer(ply, function()
				BREACH.DataBaseSystem:Log("Data was successfully loaded for " .. ply:Nick())
			end)
		end

		ply:SetNGTeam(1)
		ply:SetNActive(true)
		ply:SetNPremium( ply.Premium or false )
		ply:SetSpecialCD( 0 )
		ply:SetInDimension( false )
		ply:SetAdrenaline( false )
		ply:SetEnergized( false )
		ply:SetBoosted( false )
		ply:SetMaxSlots( 8 )
		ply:SetFemale( false )
		ply:SetSpecialMax( 0 )
		ply:SetStunned(false)
		ply:SetStaminaScale(1.0)
	end
end

player_manager.RegisterClass("class_breach", PLAYER, "player_default")