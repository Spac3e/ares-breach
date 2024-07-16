BREACH = BREACH || {}

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

BREACH.MainMenu_Spawns = {
	{Vector(-84, 6467, 2600), Angle(4, 165, 0)},
	{Vector(-1095, 5070, 2186), Angle(7, 39, 0)},
	{Vector(-3914, 7253, 2877), Angle(14, -45, 0)},
	{Vector(2853, 6458, 1687), Angle(11, 138, 0)},
	{Vector(-7363, 1724, 2466), Angle(9, 41, 0)},
	{Vector(-1979, 2092, 15), Angle(1, -134, 0)},
	{Vector(-1364, 2508, 60), Angle(8, 54, 0)},
	{Vector(0, 3220, 132), Angle(5, 61, 0)},
	{Vector(9093, -3421, 160), Angle(17, -151, 0)},
	{Vector(7877, -3493, 177), Angle(5, -0, 0)},
	{Vector(6839, -5624, 290), Angle(5, 53, 0)}
}

hook.Add("SetupMove", "SCP_DOWN_SPEED", function( ply, mv, cmd )
	if ply:GTeam() == TEAM_SCP then
		local speedmultiply = math.min(1, ply:GetNWInt("Speed_Multiply", 1))

		if speedmultiply < 1 then
			local speed = ply:GetRunSpeed() * speedmultiply

			mv:SetMaxSpeed( speed )
			mv:SetMaxClientSpeed( speed )
		end
	end
end)

function BREACH.TranslateString(str)
	if SERVER then return str end --серверу все равно не надо ничего переводить

	local isfound = true

	local tab = string.Explode(" ", str)
	if #tab >= 2 then
		for k, v in ipairs(tab) do
			if v:find("dont_translate:") then
				tab[k] = string.Replace(v, "dont_translate:", "")
				continue
			end

			if v:find("l:") then
				local explosion = string.Explode("l:", v)
				local before = explosion[1] or "" --SOMEINSANETEXTBEFOREPHRASEl:massfucktest
				local phrase = explosion[2]

				if ALLLANGUAGES[langtouse][phrase] then
					tab[k] = before..ALLLANGUAGES[langtouse][phrase]
				else
					if ALLLANGUAGES["russian"][phrase] then
						tab[k] = ALLLANGUAGES["russian"][phrase]
					else
						isfound = false
						tab[k] = before.."recursive phrase not found "..phrase
					end
				end
			end
		end

		str = ""
		if string.len(tab[2]) == 0 then
			for k, v in ipairs(tab) do
				if string.len(v) == 0 then
					str = str.." "
				else
					str = str..v
				end
			end
		else
			for k, v in ipairs(tab) do
				if string.len(v) == 0 then
					str = str.." "
				else
					str = str..v.." "
				end
			end
		end

		return str, isfound
	end

	--text doesn't have spaces
	if str:find("dont_translate:") then
		return string.Replace(str, "dont_translate:", "")
	end
	if str:find("l:") then
		local explosion = string.Explode("l:", str)
		local before = explosion[1] or "" --SOMEINSANETEXTBEFOREPHRASEl:massfucktest
		local phrase = explosion[2]

		if ALLLANGUAGES[langtouse][phrase] then
			str = before..ALLLANGUAGES[langtouse][phrase]
			return str, isfound
		else
			if ALLLANGUAGES["russian"][phrase] then
				return ALLLANGUAGES["russian"][phrase], isfound
			else
				isfound = false
				return before.."phrase not found "..phrase, isfound
			end
		end

		return str, isfound
	end

	return str, isfound
end

function BREACH.TranslateNonPrefixedString(str)
	if ALLLANGUAGES[langtouse][str] then
		return ALLLANGUAGES[langtouse][str]
	else
		return ALLLANGUAGES["russian"][str] or "non prefixed phrase not found "..str --fallback
	end
end

--BREACH.TranslateString alias
function L(str)
	return BREACH.TranslateString(str)
end

NEXTOREN_SEXY_CHEMIST = {
	["76561198439587764"] = true, -- GOOGLENSKY
	["76561198358765564"] = true, -- Подгузник
	["76561198309170158"] = true, -- Денис
	["76561198142404712"] = true, -- vadicmoc
	["76561198839329687"] = true, -- prince of darkness
	["76561198056740424"] = true, -- Строптивец
	["76561198389204738"] = true, -- Horizontal_Eye
	["76561199011368505"] = true, -- Товарищь Говночист
	["76561198983025294"] = true, -- Doctor. Cat
	["76561198106253632"] = true, -- БЕЗУМНЫЙ МУЖЧИНА
	["76561198878159478"] = true, -- WUNDERWULF :DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
	["76561199137632323"] = true, -- jitheat
}

NEXTOREN_YOUTUBERS = { -- Жесткие тюбики
	["76561198889301217"] = "https://www.youtube.com/channel/UCHG-qnA4i270X2_KpPLeHXw",
	["76561199112412418"] = "https://www.youtube.com/@quinwise9214", -- quinwise
	["76561198030081688"] = "https://www.youtube.com/channel/UCnDtpUcUDiJ2KoZ7p3Nehlg", -- narkis
	["76561198385923312"] = "https://www.youtube.com/channel/UCmmyGXrAMiA_vD0w5t4F08g", -- kowka
}

function util.PaintDown(start, effname, ignore) --From TTT
	local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})
  
	util.Decal(effname, btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal)
end

local function DoBleed(ent)
	if not IsValid(ent) or (ent:IsPlayer() and (not ent:Alive() or ent:GTeam() == TEAM_SCP or ent:GTeam() == TEAM_SPEC)) then
	  return
	end
  
	local jitter = VectorRand() * 30
	jitter.z = 20
  
	util.PaintDown(ent:GetPos() + jitter, "Blood", ent)
end
  
function util.StartBleeding(ent, dmg, t)
	  --print(dmg)
	if dmg < 5 or not IsValid(ent) then
	  return
	end
  
	if ent:IsPlayer() and (not ent:Alive() or ent:GTeam() == TEAM_SCP or ent:GTeam() == TEAM_SPEC) then
	  return
	end
  
	local times = math.Clamp(math.Round(dmg / 15), 1, 20)
  
   local delay = math.Clamp(t / times , 0.1, 2)
  
	if ent:IsPlayer() then
	  times = times * 2
	  delay = delay / 2
	end
  
   timer.Create("bleed" .. ent:EntIndex(), delay, times, function() DoBleed(ent) end)
end

function GM:GrabEarAnimation(ply)
	return false
end

NextOren_HEADS_BLACKHEADS = {
	["models/all_scp_models/shared/heads/head_1_7"] = true,
	["models/all_scp_models/shared/heads/head_1_8"] = true,
}

NextOren_Team_SteamIDs = {
	['76561197987190249'] = true, --джилед
	['76561198019442318'] = true, --культист
	['76561198286190382'] = true, --буржуй
	['76561198049524525'] = true, --шварц
}

GRU_Objectives = {
	["Evacuation"] = "Срыв эвакуации",
	["MilitaryHelp"] = "Помощь военному персоналу",
}

local mply = FindMetaTable("Player")

function SteamID64IsNOTeam(steamid64)
	return NextOren_Team_SteamIDs[tostring(steamid64)]
end

function mply:IsNOTeam()
	return NextOren_Team_SteamIDs[self:SteamID64()]
end

BREACH.QuickChatPhrases_NonMilitaryTeams = {
	[TEAM_CLASSD] = true,
	[TEAM_SCI] = true,
	[TEAM_SPECIAL] = true,
	[TEAM_GOC] = true,
}

MINPLAYERS = 2

team.SetUp(1, "Oh you got an ass on you alright. See, thats what he's talking about. Spread your ass open dude. You could do the rump shaker huh, the thug shaker, give me the thug shaker dude shake your ass. Take your hands off it and shake that shit, pull your shirt up I know you can shake it, shake it! Yeah that's some thug ass right there. Oh yeah, that'll work. You got the booty dude. God damn. It look good bro? Yeah. Yeah, nice huh. Alright that'll work for him. Put that condom on, you ready to sit on that shit? You got- Lets just get it over with. Alright lets get it over with, you- your alright.", Color(0, 255, 0))

game.AddDecal( "Decal106", "decals/decal106" )

local rolecache = {}

hook.Add("Breach_LanguageChanged", "UpdateRoleCache", function()
	rolecache = {}
end)

local function GetLangRoleForCache(rl)
	if clang == nil then
		clang = english
	end

	if string.StartWith(rl, "SCP") then
		return role[rl] or "LANG ERROR!"
	end

	local rolef = nil
	for k,v in pairs(role) do
		if rl == v then
			rolef = k
		end
	end

	if rolef != nil then
		return clang.role[rolef] or "LANG ERROR!"
	else
		return rl or "LANG ERROR!"
	end
end

function GetLangRole(rl)
	local role = rolecache[rl]

	if !role then
		rolecache[rl] = GetLangRoleForCache(rl)
		role = rolecache[rl]
	end

	return rolecache[rl]
end

function NormalVector(vec)

	return "Vector("..vec.x..", "..vec.y..", "..vec.z..")"

end

function NormalAngle(ang)

	return "Angle("..ang.p..", "..ang.y..", "..ang.r..")"

end

function GetLangWeapon(rl)
	if clang == nil then clang = english end

	if isstring(clang.weaponry[rl]) and clang.LangName != "Русский" then
		return clang.weaponry[rl]
	else
		local weptable = weapons.Get(rl)
		if !istable(weptable) then
			local enttable = scripted_ents.Get(rl)
			if !istable(enttable) then
				return rl
			end
			return enttable.PrintName
		end
		return weptable.PrintName
	end
end

SCPS = {}

SCP106 = "SCP106"
SCP049 = "SCP049"
SCP638 = "SCP638"
SCP8602 = "SCP8602"
SCP062FR = "SCP062FR"
SCP1015RU = "SCP1015RU"
SCP035 = "SCP035"
SCP1027RU = "SCP1027RU"
SCP062DE = "SCP062DE"
SCP096 = "SCP096"
SCP542 = "SCP542"
SCP999 = "SCP999"
SCP1903 = "SCP1903"
SCP973 = "SCP973"
SCP457 = "SCP457"
SCP173 = "SCP173"
SCP2012 = "SCP2012"
SCP082 = "SCP082"
SCP939 = "SCP939"
SCP811 = "SCP811"
SCP682 = "SCP682"
SCP076 = "SCP076"
SCP912 = "SCP912"

// SCI
role.SCI_Assistant = "Assistant"
role.SCI_Grunt = "Scientist"
role.SCI_Tester = "Researcher"
role.SCI_Recruiter = "Ethics Comitee"
role.SCI_Medic = "Medic"
role.SCI_Cleaner = "Cleaner"
role.SCI_Head = "Head of Personnel"
role.SCI_SpyUSA = "UIU Spy"

//GAY MODES
role.USA = "USA Soldier"
role.Nazi = "Reich Soldat"

role.CTFCI = "CI Raider"
role.CTFQRT = "QRT Defender"
role.ArenaParticipant = "Arena participant"

// Class D 
role.ClassD_FartInhaler = "Class-D FartInhaler"
role.ClassD_Default = "Class-D"
role.ClassD_Pron = "Class-D Pron"
role.ClassD_Thief = "Class-D Thief"
role.ClassD_Fat = "Class-D Fat"
role.ClassD_Bor = "Class-D Bor"
role.ClassD_Hack = "Class-D Hacker"
role.ClassD_Cannibal = "Class-D Cannibal"
role.ClassD_Probitiy = "Class-D Probitiy"
role.ClassD_Fast = "Class-D Fast"
role.ClassD_Killer = "Class-D Killer"
role.ClassD_Hitman = "Class-D Stealthy"
role.ClassD_Banned = "Class-D Banned"

// Security
role.SECURITY_Recruit = "Security Rookie"
role.SECURITY_Sergeant = "Security Sergeant"
role.SECURITY_OFFICER = "Security Officer"
role.SECURITY_Warden = "Security Warden"
role.SECURITY_Shocktrooper = "Security Shock trooper"
role.SECURITY_IMVSOLDIER = "Security Specialist"
role.SECURITY_Chief = "Security Chief"

// MTF
role.MTF_Guard = "MTF Guard"
role.MTF_Medic = "MTF Medic"
role.MTF_Left = "MTF Left"
role.MTF_Chem = "MTF Chemist"
role.MTF_Shock = "MTF Shock trooper"
role.MTF_Specialist = "MTF Specialist"
role.MTF_Com = "Head of Security"
role.MTF_Engi = "MTF Engineer"
role.MTF_HOF = "Head of Facility"
role.MTF_Security = "MTF Security"
role.Dispatcher = "Dispatcher"
role.MTF_Jag = "MTF Juggernaut"

// Special Sci 
role.SCI_SPECIAL_DAMAGE = "Kelen"
role.SCI_SPECIAL_HEALER = "Matilda"
role.SCI_SPECIAL_SLOWER = "Speedwone"
role.SCI_SPECIAL_SPEED = "Lomao"
role.SCI_SPECIAL_MINE = "Feelon"
role.SCI_SPECIAL_BOOSTER = "Georg"
role.SCI_SPECIAL_SHIELD = "Shieldmeh"
role.SCI_SPECIAL_INVISIBLE = "Ruprecht"
role.SCI_SPECIAL_VISION = "Hedwig"

// NTF
role.NTF_Soldier = "NTF Grunt"
role.NTF_Specialist = "NTF Specialist"
role.NTF_Sniper = "NTF Sniper"
role.NTF_Commander = "NTF Commander"
role.NTF_Pilot = "NTF Pilot"

// OSN
role.OSN_Soldier = "STS Grunt"
role.OSN_Specialist = "STS Specialist"
role.OSN_Commander = "STS Commander"

// GRU
role.GRU_Soldier = "GRU Soldier"
role.GRU_Specialist = "GRU Specialist"
role.GRU_Jugg = "GRU Juggernaut"
role.GRU_Commander = "GRU Commander"

// UIU 
role.UIU_Soldier = "UIU Soldier"
role.UIU_Commander = "UIU Commander"
role.UIU_Specialist = "UIU Specialist"
role.UIU_Clocker = "UIU Infiltrator"

// DZ
role.DZ_Grunt = "SH Soldier"
role.DZ_Gas = "SH Chemist"
role.DZ_Psycho = "SH Psycho"
role.DZ_Commander = "SH Commander"
role.SCI_SpyDZ = "SH Spy"

// GOC
role.Goc_Grunt = "GOC Soldier"
role.Goc_Commander = "GOC Commander"
role.Goc_Jag = "GOC Juggernaut"
role.Goc_Special = "GOC Specialist"
role.Goc_Liq = "GOC Liq"
role.ClassD_GOCSpy = "GOC Spy"

// QRT 
role.QRT_Soldier = "QRT Soldier"
role.QRT_Medic = "QRT Medic"
role.QRT_ShockTrooper = "QRT Shock trooper"
role.QRT_Commander = "QRT Commander"
role.QRT_Machinegunner = "QRT Machinegunner"
role.QRT_Shield = "QRT Shield"
role.QRT_Marksmen = "QRT Marksman"

// Chaos Insurgency
role.SECURITY_Spy = "CI Spy"
role.Chaos_Grunt = "CI Soldier"
role.Chaos_Commander = "CI Commander"
role.Chaos_Jugg = "CI Juggernaut"
role.Chaos_Demo = "CI Demoman"

// COTSK 
role.Cult_Grunt = "COTSK Grunt"
role.Cult_Psycho = "COTSK Psycho"
role.Cult_Commander = "COTSK Commander"
role.Cult_Specialist = "COTSK Specialist"

// SKP
role.SKP_Soldat = "SKP Soldat"
role.SKP_Offizier = "SKP Offizier"
role.SKP_Machinegunner = "SKP Machinegunner"
role.SKP_Jager = "SKP Jager"

// Other
role.Spectator = "Spectator"
role.vort = "vort"
role.vort2 = "vort2"
role.vort3 = "vort3"

// SCP
role.SCP049 = "SCP-049"
role.SCP062DE = "SCP-062-DE"
role.SCP062FR = "SCP-062-FR"
role.SCP1903 = "SCP-1903"
role.SCP8602 = "SCP-860-2"
role.SCP638 = "SCP-638"
role.SCP106 = "SCP-106"
role.SCP096 = "SCP-096"
role.SCP973 = "SCP-973"
role.SCP457 = "SCP-457"
role.SCP999 = "SCP-999-2"
role.SCP173 = "SCP-173"
role.SCP2012 = "SCP-2012"
role.SCP082 = "SCP-082"
role.SCP939 = "SCP-939"
role.SCP682 = "SCP-682"
role.SCP811 = "SCP-811"
role.SCP542 = "SCP-542"
role.SCP076 = "SCP-076-2"
role.SCP912 = "SCP-912"

Radio_RandChannelList = Radio_RandChannelList || {



	{
		teams = {TEAM_GUARD, TEAM_SECURITY, TEAM_QRT, TEAM_NTF},
		allowedroles = {"CI Spy"},
		blockedroles = {},
		chan = 101.1,
	},

	{
		teams = {TEAM_DZ},
		allowedroles = {},
		blockedroles = {},
		chan = 102.1,
	},

	{
		teams = {TEAM_CHAOS},
		allowedroles = {},
		blockedroles = {"CI Spy"},
		chan = 103.1,
	},

	{
		teams = {TEAM_GRU},
		allowedroles = {},
		blockedroles = {},
		chan = 104.1,
	},

	{
		teams = {TEAM_COTSK},
		allowedroles = {},
		blockedroles = {},
		chan = 105.1,
	},

	{
		teams = {TEAM_GOC},
		allowedroles = {},
		blockedroles = {},
		chan = 106.1,
	},

	{
		teams = {TEAM_USA},
		allowedroles = {},
		blockedroles = {},
		chan = 107.1,
	},


}

function Radio_RandomizeChannels()

	for _, tab in pairs(Radio_RandChannelList) do
		local num1 = tostring(math.random(100, 999))
		local num2 = tostring(math.random(1, 9))

		local Ranchannel = tonumber(num1.."."..num2)

		tab.chan = Ranchannel
	end

end

function Radio_GetChannel(team, rolename)
	for _, tab in pairs(Radio_RandChannelList) do
		if ( table.HasValue(tab.teams, team) and !table.HasValue(tab.blockedroles, rolename) ) or table.HasValue(tab.allowedroles, rolename) then return tab.chan end
	end
	
	return 100.1
end

--[[
	
--]]

if !ConVarExists("br_roundrestart") then CreateConVar( "br_roundrestart", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Restart the round" ) end
if !ConVarExists("br_time_preparing") then CreateConVar( "br_time_preparing", "60", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set preparing time" ) end
if !ConVarExists("br_time_round") then CreateConVar( "br_time_round", "780", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set round time" ) end
if !ConVarExists("br_time_postround") then CreateConVar( "br_time_postround", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set postround time" ) end
if !ConVarExists("br_time_ntfenter") then CreateConVar( "br_time_ntfenter", "360", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time that NTF units will enter the facility" ) end
if !ConVarExists("br_time_blink") then CreateConVar( "br_time_blink", "0.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Blink timer" ) end
if !ConVarExists("br_time_blinkdelay") then CreateConVar( "br_time_blinkdelay", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Delay between blinks" ) end
if !ConVarExists("br_spawnzombies") then CreateConVar( "br_spawnzombies", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do you want zombies?" ) end
if !ConVarExists("br_scoreboardranks") then CreateConVar( "br_scoreboardranks", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "" ) end
if !ConVarExists("br_defaultlanguage") then CreateConVar( "br_defaultlanguage", "english", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_expscale") then CreateConVar( "br_expscale", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_scp_cars") then CreateConVar( "br_scp_cars", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Allow SCPs to drive cars?" ) end
if !ConVarExists("br_allow_vehicle") then CreateConVar( "br_allow_vehicle", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Allow vehicle spawn?" ) end
if !ConVarExists("br_dclass_keycards") then CreateConVar( "br_dclass_keycards", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is D class supposed to have keycards? (D Class Weterans have keycard anyway)" ) end
if !ConVarExists("br_time_explode") then CreateConVar( "br_time_explode", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time from call br_destroygatea to explode" ) end
if !ConVarExists("br_ci_percentage") then CreateConVar("br_ci_percentage", "25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_i4_min_mtf") then CreateConVar("br_i4_min_mtf", "4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_cars_oldmodels") then CreateConVar("br_cars_oldmodels", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Use old cars models?" ) end
if !ConVarExists("br_premium_url") then CreateConVar("br_premium_url", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Link to premium members list" ) end
if !ConVarExists("br_premium_mult") then CreateConVar("br_premium_mult", "1.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Premium members exp multiplier" ) end
if !ConVarExists("br_premium_display") then CreateConVar("br_premium_display", "Premium player %s has joined!", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Text shown to all players when premium member joins" ) end
if !ConVarExists("br_stamina_enable") then CreateConVar("br_stamina_enable", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is stamina allowed?" ) end
if !ConVarExists("br_stamina_scale") then CreateConVar("br_stamina_scale", "1, 1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Stamina regen and use. ('x, y') where x is how many stamina you will receive, and y how many stamina you will lose" ) end
if !ConVarExists("br_rounds") then CreateConVar("br_rounds", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "How many round before map restart? 0 - dont restart" ) end
if !ConVarExists("br_min_players") then CreateConVar("br_min_players", "2", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum players to start round" ) end
if !ConVarExists("br_firstround_debug") then CreateConVar("br_firstround_debug", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Skip first round" ) end
if !ConVarExists("br_force_specialround") then CreateConVar("br_force_specialround", "", {FCVAR_SERVER_CAN_EXECUTE}, "Available special rounds [ infect, multi ]" ) end
if !ConVarExists("br_specialround_pct") then CreateConVar("br_specialround_pct", "10", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Skip first round" ) end
if !ConVarExists("br_cars_ammount") then CreateConVar("br_cars_ammount", "2", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How many cars should spawn?" ) end
if !ConVarExists("br_dropvestondeath") then CreateConVar("br_dropvestondeath", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do players drop vests on death?" ) end
if !ConVarExists("br_force_showupdates") then CreateConVar("br_force_showupdates", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should players see update logs any time they join to server?" ) end
if !ConVarExists("br_allow_scptovoicechat") then CreateConVar("br_allow_scptovoicechat", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Can SCPs talk with humans?" ) end
if !ConVarExists("br_ulx_premiumgroup_name") then CreateConVar("br_ulx_premiumgroup_name", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Name of ULX premium group" ) end
if !ConVarExists("br_experimental_bulletdamage_system") then CreateConVar("br_experimental_bulletdamage_system", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn it off when you see any problems with bullets" ) end
if !ConVarExists("br_experimental_antiknockback_force") then CreateConVar("br_experimental_antiknockback_force", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn it off when you see any problems with bullets" ) end
if !ConVarExists("br_allow_ineye_spectate") then CreateConVar("br_allow_ineye_spectate", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_allow_roaming_spectate") then CreateConVar("br_allow_roaming_spectate", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_scale_bullet_damage") then CreateConVar("br_scale_bullet_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Bullet damage scale" ) end
if !ConVarExists("br_new_eq") then CreateConVar("br_new_eq", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables new EQ" ) end
if !ConVarExists("br_enable_warhead") then CreateConVar("br_enable_warhead", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Enables OMEGA Warhead" ) end
if !ConVarExists("br_scale_human_damage") then CreateConVar("br_scale_human_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Scales damage dealt by humans" ) end
if !ConVarExists("br_scale_scp_damage") then CreateConVar("br_scale_scp_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Scales damage dealt by SCP" ) end
if !ConVarExists("br_scp_penalty") then CreateConVar("br_scp_penalty", "3", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" ) end
if !ConVarExists("br_premium_penalty") then CreateConVar("br_premium_penalty", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" ) end

local random, GetKeys = math.random, table.GetKeys

function table.Random(tab, issequential)
    local keys = issequential and tab or GetKeys(tab)
    local rand = keys[random(1, #keys)]
    return tab[rand], rand 
end

function BREACH.GroundPos( pos )
	local trace = { }
	trace.start = pos;
	trace.endpos = trace.start - vec_up
	trace.mask = MASK_BLOCKLOS

	local tr = util.TraceLine( trace )

	if ( tr.Hit ) then
		return tr.HitPos
	end

	return pos

end

local AllowedModels = {
	["models/cultist/humans/mog/mog.mdl"] = true,
	["models/cultist/humans/chaos/chaos.mdl"] = true,
	["models/cultist/humans/osn/osn.mdl"] = true,
	["models/cultist/humans/ntf/ntf.mdl"] = true,
	["models/cultist/humans/goc/goc.mdl"] = true,
	["models/cultist/humans/fbi/fbi.mdl"] = true,
	["models/cultist/humans/mog/mog_hazmat.mdl"] = true,
	["models/cultist/humans/mog/mog_jagger.mdl"] = true,
	["models/cultist/humans/russian/russians.mdl"] = true,
	["models/cultist/humans/mog/sexy_mog_hazmat.mdl"] = true,
	["models/cultist/humans/mog/mog_woman_capt.mdl"] = true,
	["models/cultist/humans/mog/mog_woman.mdl"] = true,
	["models/cultist/humans/goc/goc_female_commander.mdl"] = true,
	["models/cultist/humans/fbi/fbi_woman.mdl"] = true,
	["models/cultist/humans/obr/obr_new.mdl"] = true,
	["models/cultist/humans/ntf/ntf_female_sniper.mdl"] = true,
}

local canjumpscp = {
	--["SCP076"] = true,
}
local cancrouchscp = {
}

BREACH.EMOTES = {
	{
		name = "Согласиться",
		premium = false,
		gesture = "0_shaky_handgesture_agree"
	},
	{
		name = "Не согласиться",
		premium = false,
		gesture = "0_shaky_handgesture_disagree"
	},
	{
		name = "Неодобрять",
		premium = false,
		gesture = "0_shaky_handgesture_disapprove"
	},
	{
		name = "Отдать честь",
		premium = false,
		gesture = "0_shaky_handgesture_salute"
	},
	{
		name = "Помахать",
		premium = false,
		gesture = "0_shaky_handgesture_wave"
	},
	{
		name = "Показать вперед",
		premium = false,
		gesture = "0_shaky_handgesture_point"
	},
}

if CLIENT then

local induck = false

hook.Add("PlayerBindPress", "ToggleDuck", function(ply, bind, pressed)
	if (string.find(bind, "duck")) then
		return true
	end
end)

hook.Add("PlayerButtonDown", "ToggleDuck", function(ply, button)
	if button == input.GetKeyCode(input.LookupBinding("+duck")) and IsFirstTimePredicted() then
		induck = !induck
		if !induck then ply.crouchcd = CurTime() + 1 end
		if ply.crouchcd and ply.crouchcd > CurTime() and induck then induck = false end
	end
end)

hook.Add("CreateMove", "ToggleDuck", function(cmd)
	local ply = LocalPlayer()

	if induck then
		LocalPlayer():SetDuckSpeed(0.1)
		LocalPlayer():SetUnDuckSpeed(0.1)
		cmd:AddKey(IN_DUCK)
	else
		cmd:RemoveKey(IN_DUCK)
	end

	local movetype = ply:GetMoveType()

	if movetype == MOVETYPE_OBSERVER and induck then
		cmd:RemoveKey(IN_DUCK)
	end

	if ply:GTeam() != TEAM_SCP then

		local actwep = ply:GetActiveWeapon()
		local actwepvalid = IsValid(actwep)
		local actwep_class = actwepvalid and actwep:GetClass()

		if actwepvalid then
			if actwep_class == "item_shield" then
				cmd:RemoveKey(IN_DUCK)
			end
		end
	end

	--всегда на конце
	if !cmd:KeyDown(IN_DUCK) then
		induck = false
	end
end)

end

hook.Add("SetupMove", "OverrideMovement", function(ply, mv, cmd)
	local movetype = ply:GetMoveType()
	if movetype == MOVETYPE_NOCLIP or movetype == MOVETYPE_OBSERVER then
	return
end

hook.Add("SetupMove", "StanceSpeed", function(ply, mv, cmd)
    local velLength = ply:GetVelocity():Length2DSqr()

	if ply:GetRoleName() == "UIU Infiltrator" or ply:GetRoleName() == "Class-D Stealthy" or ply:GetRoleName() == "Class-D Fast" then
		return
	end

    if mv:KeyReleased(IN_SPEED) or (mv:KeyDown(IN_SPEED) and velLength < 0.25) then
        ply.Run_fading = true
    end

    if mv:KeyDown(IN_MOVELEFT) or mv:KeyDown(IN_MOVERIGHT) then
        ply.Run_fading = true
        mv:SetSideSpeed(mv:GetSideSpeed() * 0.35)
    end

    if mv:KeyDown(IN_SPEED) and velLength > 0.25 or (ply.SprintMove and not ply.Run_fading) then
        if ply:IsLeaning() then
            ply:SetNW2Int("LeanOffset", 0)
            ply.OldStatus = nil
        end

        if not ply.SprintMove then
            ply.Run_fading = nil
            ply.SprintMove = true
            ply.Sprint_Speed = ply:GetWalkSpeed()
        end

        ply.Sprint_Speed = math.Approach(ply.Sprint_Speed, ply:GetRunSpeed(), FrameTime() * 128)
        mv:SetMaxClientSpeed(ply.Sprint_Speed)
        mv:SetMaxSpeed(ply.Sprint_Speed)
    elseif ply.SprintMove and ply.Run_fading then
        local walk_Speed = ply:GetWalkSpeed()
        ply.Sprint_Speed = math.Approach(ply.Sprint_Speed, walk_Speed, FrameTime() * 128)
        mv:SetMaxClientSpeed(ply.Sprint_Speed)
        mv:SetMaxSpeed(ply.Sprint_Speed)

        if ply.Sprint_Speed == walk_Speed then
            ply.SprintMove = nil
            ply.Sprint_Speed = nil
        end
    end

    if ply:Crouching() then
        local walk_speed = ply:GetWalkSpeed()
        mv:SetMaxClientSpeed(walk_speed * 0.5)
        mv:SetMaxSpeed(walk_speed * 0.5)
    end

    local wep = ply:GetActiveWeapon()
    if wep != NULL and wep.CW20Weapon and wep.dt.State == CW_AIMING then
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.5)
        mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.5)
    end

    if ply:IsLeaning() then
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.75)
        mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.75)
    end

    if ply.SpeedMultiplier then
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * ply.SpeedMultiplier)
        mv:SetMaxSpeed(mv:GetMaxSpeed() * ply.SpeedMultiplier)
    end
end)

local pl = ply:GetTable()
local rolename = pl:GetRoleName()
local ducking = mv:KeyDown(IN_DUCK)
local jumping = mv:KeyDown(IN_JUMP)
local buttons = mv:GetButtons()

pl.PlayCrouchSound = false
if (ply:KeyPressed(IN_DUCK) and IsFirstTimePredicted()) then
	pl.PlayCrouchSound = true
end

if pl.PlayCrouchSound then
	if AllowedModels[ply:GetModel()] then
		ply:EmitSound( "^nextoren/charactersounds/foley/posechange_" .. math.random( 1, 6 ) .. ".wav", 60, math.random( 100, 105 ), 1, CHAN_STATIC )
	end
	pl.PlayCrouchSound = false
	pl.PlayUnCrouchSoundLater = true
end

if pl.PlayUnCrouchSoundLater and !ducking then
	if AllowedModels[ply:GetModel()] then
		ply:EmitSound( "^nextoren/charactersounds/foley/posechange_" .. math.random( 1, 6 ) .. ".wav", 60, math.random( 90, 95 ), 1, CHAN_STATIC )
	end
	pl.PlayUnCrouchSoundLater = false
end
	if ply:GTeam() != TEAM_SCP then
		if ducking then
			ply:SetDuckSpeed(0.1)
			ply:SetUnDuckSpeed(0.1)
			if jumping and !ply:IsSuperAdmin() then
				mv:SetButtons(buttons - IN_JUMP)
			end
		end

	else

		if jumping and !canjumpscp[rolename] then
			mv:SetButtons(buttons - IN_JUMP)
		end

		if ducking and !cancrouchscp[rolename] then
			mv:SetButtons(buttons - IN_DUCK)
		end

	end

end)

BREACH = BREACH || {}

local mply = FindMetaTable("Player")

-- FORCED ANIM (COCK) --
function mply:StopForcedAnimation()
    if CLIENT then return end
    timer.Remove("SeqF"..self:EntIndex())
    if isfunction(self.StopFAnimCallback) then self.StopFAnimCallback() self.StopFAnimCallback = nil end
    
    self.ForceAnimSequence = nil        
    net.Start("BREACH_EndForcedAnimSync")
    net.WriteEntity(self)
    net.Broadcast()
end

if CLIENT then
    net.Receive("BREACH_EndForcedAnimSync", function(len)
        local ply = net.ReadEntity()
        if IsValid(ply) then
            ply.ForceAnimSequence = nil
        end
    end)
    
    net.Receive("BREACH_SetForcedAnimSync", function(len)
        local ply = net.ReadEntity()
		if not IsValid(ply) then return end
        local sequence = net.ReadUInt(20)
        ply:SetCycle(0)
        ply.ForceAnimSequence = sequence
    end)
end

function BREACH.GroundPos( pos )

	local trace = { }
	trace.start = pos;
	trace.endpos = trace.start - vec_up
	trace.mask = MASK_BLOCKLOS

	local tr = util.TraceLine( trace )

	if ( tr.Hit ) then

		return tr.HitPos

	end

	return pos

end

function GM:EntityFireBullets( ent, data )
end

local mply = FindMetaTable( "Player" )

function mply:ToPD()
	local client = LocalPlayer()
	client:SetPos( Vector(3674.955811, -14796.375000, -2991.968750) )
end

local AllowedModels = {
	["models/cultist/humans/mog/mog.mdl"] = true,
	["models/cultist/humans/chaos/chaos.mdl"] = true,
	["models/cultist/humans/osn/osn.mdl"] = true,
	["models/cultist/humans/chaos/fat/chaos_fat.mdl"] = true,
	["models/cultist/humans/ntf/ntf.mdl"] = true,
	["models/cultist/humans/goc/goc.mdl"] = true,
	["models/cultist/humans/fbi/fbi.mdl"] = true,
    ["models/cultist/humans/nazi/nazi.mdl"] = true,
    ["models/cultist/humans/russian/russians.mdl"] = true,
	["models/cultist/humans/mog/mog_hazmat.mdl"] = true,
	["models/cultist/humans/obr/obr.mdl" ] = true,
	["models/cultist/humans/obr/obr_new.mdl" ] = true,
	["models/cultist/humans/mog/mog_jagger.mdl"] = true,
	["models/cultist/humans/mog/mog_woman_capt.mdl"] = true,
	["models/cultist/humans/mog/mog_woman.mdl"] = true,
	["models/cultist/humans/goc/goc_female_commander.mdl"] = true,
	["models/cultist/humans/fbi/fbi_woman.mdl"] = true,
	["models/cultist/humans/ntf/ntf_female_sniper.mdl"] = true,
	["models/cultist/scp/scp_912.mdl"] = true,
	["models/cultist/humans/mog/sexy_mog_hazmat.mdl"] = true,
}

local silencedwalkroles = {
	[role.UIU_Clocker] = true,
	["SCP457"] = true,
	["SCP096"] = true,
	["SCP062DE"] = true,
	["SCP062FR"] = true,
	["SCP1903"] = true,
	["SCP999"] = true,
	--["SCP076"] = true,
	["SCP106"] = true,
}

SCPFOOTSTEP = {
	["SCP682"] = true,
	["SCP939"] = true,
	["SCP082"] = true,
}

FOOTSTEP_SOUNDTIME = {
	["SCP638"] = 500,
}

function GM:PlayerFootstep(ply)
	return true 
end

local vectorLength2D = FindMetaTable("Vector").Length2D

function PLAYER:IsRunning()
	return vectorLength2D(self:GetVelocity()) > (self:GetWalkSpeed() + 10)
end

local offset = Vector(0, 0, 16)

function PLAYER:GetSurfaceData()
	local mins, maxs = self:GetHull()
	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos() - offset,
		filter = {self},
		mins = mins,
		maxs = maxs,
		collisiongroup = COLLISION_GROUP_PLAYER_MOVEMENT
	})

	return util.GetSurfaceData(tr.SurfaceProps)
end

hook.Add("EntityEmitSound", "Breach-footsteps.EntityEmitSound", function(info)
	-- Гойда рекомпил дефолт шагов сурса
	if IsValid(info.Entity) and info.Entity:IsPlayer() and not IsEmittingPlayerStep and info.OriginalSoundName:find("step") then
		return false
	end
end)

if CLIENT then
    hook.Add("Think", "Breach-footsteps.Think", function()
		for _, client in player.Iterator() do
			if not client.NextStepTime then
				client.NextStepTime = 0
				client.NextStepSide = false
				client.StepSkip = 0
			end

			if client:IsDormant() or client.NextStepTime > CurTime() then
				continue
			end

			if client:GetMoveType() == MOVETYPE_NOCLIP then
				continue
			end

			if client:GetMoveType() != MOVETYPE_LADDER and not client:IsFlagSet(FL_ONGROUND) then
				continue
			end

			--if client:Crouching() then
				--continue
			--end

			local vel = client:GetVelocity():Length()

			if vel < hook.Run("GetMinStepSpeed", client) then
				continue
			end

			local side = client.NextStepSide

			if hook.Run("HandlePlayerStep", client, side) == true then
				continue
			end

			client.NextStepTime = CurTime() + (hook.Run("GetNextStepTime", client, vel) or 0)
			client.NextStepSide = not side
		end
    end)

	hook.Add("HandlePlayerStep", "HandlePlayerStepWater", function(client, side)
		if client:WaterLevel() >= 1 then
			if client.StepSkip == 2 then
				client.StepSkip = 0
			else
				client.StepSkip = client.StepSkip + 1

				return true
			end
		end
	end)

	-- Насрал
	local GAMEMODE = GM or GAMEMODE

	function GAMEMODE:GetMinStepSpeed(client)
		return 150 * client:GetCrouchedWalkSpeed() -- ВАЩЕ ПОИДЕЕ ТУТ НАДО КОНФИГ ВУЛАЕ
	end

	function GAMEMODE:GetNextStepTime(client, vel)
		if not ( IsValid(client) ) then
			return
		end

		if client:GetMoveType() == MOVETYPE_LADDER then
			return 0.45
		end

		local val

		if client:WaterLevel() >= 1 then
			val = 0.6
		else
			if client:KeyDown(IN_WALK) and vel < 90 then
				val = 0.375 / (vel / 90)
			else
				val = math.max(math.Remap(vel, 90, 235, 0.4, 0.3), 0.1)
			end
		end

		if client:Crouching() then
			val = val + 0.1
		end

		return val
	end

	local ladderSurface = util.GetSurfaceData(util.GetSurfaceIndex("ladder"))
	local wadeSurface = util.GetSurfaceData(util.GetSurfaceIndex("wade"))

	function GAMEMODE:GetDefaultStepSound(client, side)
		if client:GetMoveType() == MOVETYPE_LADDER then
			return side and ladderSurface.stepRightSound or ladderSurface.stepLeftSound, 0.5
		elseif client:WaterLevel() >= 1 then
			return side and wadeSurface.stepRightSound or wadeSurface.stepLeftSound, client:IsRunning() and 0.65 or 0.25
		else
			local volume = client:IsRunning() and 0.5 or 0.2
			local snd = "Default.StepRight"

			local prop = client:GetSurfaceData()

			if prop then
				snd = side and prop.stepRightSound or prop.stepLeftSound
			else
				snd = side and "Default.StepRight" or "Default.StepLeft"
			end

			return snd, volume
		end
	end

	function GAMEMODE:ModifyPlayerStep(client, data)
        local gteam = client:GTeam()
        local class = client:GetRoleName()

		if gteam then
			local vel = client:GetVelocity():Length2DSqr()
			local wep = client:GetActiveWeapon()

			if not ( IsValid(client) ) then
				return
			end

			if ( data.ladder or data.submerged ) then
				return
			end

			if client:GetModel():find("goc") then							
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")
			
				if (client:GetRoleName() == "GOC Juggernaut") then
					data.snd = "nextoren/charactersounds/foley_goc/gear" .. math.random(1, 6) .. ".wav"
					data.volume = data.volume * (data.running and 4.3 or 1.8)	
					return true 
				end

				if (vel > 22500) then
					data.snd = "nextoren/charactersounds/foley_goc/gear" .. math.random(1, 6) .. ".wav"
					data.volume = data.volume * (data.running and 0.4 or 0.3)
				else
					data.snd = "nextoren/charactersounds/foley_goc/gear" .. math.random(1, 6) .. ".wav"
					data.volume = data.volume * (data.running and 0.4 or 0.3)			
				end		
	
				return true 
			end

			if client:GetRoleName() == "SCP973" then						
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")

				data.snd = "nextoren/charactersounds/foley_scp/cop_step_" .. math.random(1, 6) .. ".wav"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end
		
			if client:GetRoleName() == "SCP542" then				
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")

				data.snd = "nextoren/charactersounds/foley_scp/ger_walk_" .. math.random(1, 6) .. ".wav"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end

			if client:GetRoleName() == "SCP8602" then					
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")

				if !client.funy_view then client.funy_view = 1 end
				if client.funy_view == -1 then
					client.funy_view = 1
				else
					client.funy_view = -1
				end
				if client:GetRunSpeed() == 300 then
					client:ViewPunch(Angle(3,0,0))
				else
					client:ViewPunch(Angle(2,0,client.funy_view))
				end

				data.snd = "nextoren/scp/682/scp_682_footstep_" .. math.random(1, 4) .. ".ogg"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end

			if client:GetRoleName() == "SCP173" then
				if pl.steps == nil then pl.steps = 0 end
				pl.steps = pl.steps + 1
				if pl.steps > 6 then
					pl.steps = 1
				end

				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")

				data.snd = "173sound" .. math.random(1, 3) .. ".ogg"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end

			if client:GetRoleName() == "SCP2012" then			
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")

				data.snd = "nextoren/scp/2012/footsteps/footstep_" .. math.random(1, 8) .. ".wav"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end

			if SCPFOOTSTEP[client:GetRoleName()] then						
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")
			
				data.snd = "nextoren/scp/682/scp_682_footstep_" .. math.random(1, 4) .. ".wav"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end

			if client:GetRoleName() == "SCP049" then			
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")

				data.snd = "nextoren/scp/049/step" .. math.random(1, 3) .. ".ogg"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end

			if client:GetRoleName() == "SCP076" or client:GetRoleName() == "SCP811" then			
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")
			

				data.snd = "nextoren/charactersounds/zombie/foot" .. math.random(2, 3) .. ".wav"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end

			if client:GetRoleName() == "SCP638" then		
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")
			
				data.snd = "nextoren/charactersounds/zombie/foot" .. math.random(1, 3) .. ".wav"
				data.volume = data.volume * (data.running and 0.4 or 0.3)
				return true 
			end	
		
			if AllowedModels[client:GetModel()] then			
				data.snd = string.Replace(data.snd, ".stepright", "")
				data.snd = string.Replace(data.snd, ".stepleft", "")
			
				local snd2, volume2 = hook.Run("GetDefaultStepSound", client, side)
								
				EmitSound(snd2, client:GetPos(), client:EntIndex(), CHAN_AUTO, data.volume * (data.running and 0.3 or 0.2))

				if (vel > 22500) then
					data.snd = "nextoren/charactersounds/foley/sprint/sprint_" .. math.random(1, 52) .. ".wav"
					data.volume = data.volume * (data.running and 0.5 or 0.4)			
				else
					data.snd = "nextoren/charactersounds/foley/run/run_" .. math.random(1, 40) .. ".wav"
					data.volume = data.volume * (data.running and 0.4 or 0.3)					
				end		
	
				return true 
			end			
		end
		
		if client:Crouching() then
			data.volume = data.volume * 0.65
		end
	end

	function GAMEMODE:HandlePlayerStep(client, side)
		if client:GetNoDraw() or silencedwalkroles[client:GetRoleName()] then
			return true
		end
		
		local snd, volume = hook.Run("GetDefaultStepSound", client, side)
	
		local data = {
			snd = snd,
			volume = volume,
			running = client:IsRunning(),
			ladder = client:GetMoveType() == MOVETYPE_LADDER,
			submerged = client:WaterLevel() >= 1,
		}
	
		if hook.Run("ModifyPlayerStep", client, data) == false then
			return
		end
	
		volume = data.volume * 1
	
		IsEmittingPlayerStep = true
		--if client:GetActiveWeapon():GetClass() == "item_shield" then
			--client:EmitSound( "^player/footstepsnew/shield_step_0"..math.random(1,10)..".wav", 300, math.random( 100, 120 ), 2 * .8)
		--end
		EmitSound(data.snd, client:GetPos(), client:EntIndex(), CHAN_AUTO, volume)
		IsEmittingPlayerStep = nil
	end
end

local meta = FindMetaTable("Player");
local ent = FindMetaTable( "Entity" )

function ent:IsLZ()

	local pos = self:GetPos()
  
	if ( pos.x > 4600 && pos.y > -7003 && pos.y < -1200 && pos.z < 880 || pos.x > 8550 && pos.y < -440 && pos.y > -7000 || ( pos.x > -1000 && pos.x < 1680 ) && pos.y < -3600 && pos.y > -5800 && pos.z < -1000 ) then
  
	  return true
  
	end
  
	if ( pos.x > 7283 && pos.x < 7680 && pos.y < -1075 && pos.y > -1240 ) then
  
	  return true
  
	end
  
	return false
  
end
  
function ent:Outside()



	if ( self:GetPos().z > 880 ) then
  
  
  
	  return true;
  
  
  
	end
  
  
  
	return false
  
  
  
end
  
function ent:IsEntrance()
  
	local pos = self:GetPos()
  
	if ( pos.x < 1767 && pos.x > -3120 && pos.y > 1944 && pos.y < 6600 && pos.z < 880 ) then
  
	  return true
  
	end
  
	return false
  
end

function meta:IsBlack()
	for i, v in pairs(ents.FindByClassAndParent("breach_bonemerge", self)) do
		if IsValid(v) and (v:GetModel():find("balaclava") or v:GetModel():find("head_main_1") ) then
			if NextOren_HEADS_BLACKHEADS[v:GetSubMaterial(0)] then
				return true
			elseif NextOren_HEADS_BLACKHEADS[v:GetSubMaterial(2)] then
				return true
			end
		end
	end
	return false
end
  
function ent:IsHardZone()
	local pos = self:GetPos()

	if ( pos.x < 8320 && pos.x > 1200 && pos.y > -1200 && pos.z < 880 ) then
	  return true
	end
	
  	return false
end

local blockeddoors_scp = {
	Vector(-321, 4784, 53),
	Vector(-2046.5, 6181.5, 181),
	Vector(-3790.4899902344, 2472.5100097656, 53.25),
	Vector(-5028.9702148438, 3993.5, -1947),
}

local banned_models = {

	[ "*506" ] = true,
	[ "*507" ] = true,
	[ "*474" ] = true,
	[ "*473" ] = true,
	[ "*290" ] = true,
	[ "*291" ] = true,
	[ "*344" ] = true,
	[ "models/cult_props/gates/bunker_gates/bunker_door_right.mdl" ] = true,
	[ "models/cult_props/gates/bunker_gates/bunker_door_left.mdl" ] = true,
}

function GM:ShouldCollide( ent1, ent2 )
	local ent1_class = ent1:GetClass()
	local ent2_class = ent2:GetClass()

	if ent1:IsPlayer() and ent1:GTeam() == TEAM_SCP or ent2:IsPlayer() and ent2:GTeam() == TEAM_SCP then
		if ( ent1_class == "func_door"
			or ent2_class == "func_door"
			or ent2_class == "prop_dynamic"
			or ent1_class == "prop_dynamic" )
			and !banned_models[ent1:GetModel()]
			and !banned_models[ent2:GetModel()] then
			
			if (ent1:IsPlayer() and ent1:GetRoleName() == SCP106 or ent2:IsPlayer() and ent2:GetRoleName() == SCP106) then
				if SERVER then
					return SCPLockDownHasStarted != true
				else
					return false
				end
			end
			if (ent1:IsPlayer() and ent1:GetRoleName() == SCP096 and ent1:GetWalkSpeed() != 40 ) or (ent2:IsPlayer() and ent2:GetRoleName() == SCP096 and ent2:GetWalkSpeed() != 40) then
				if SERVER and (ent1:CreatedByMap() or ent2:CreatedByMap()) then
					return false
				end
			end
		end
	end

	return true
end

function GM:Move( ply, mv )
end

player_manager.AddValidModel("12312399", "models/cultist/humans/chaos/fat/chaos_fat.mdl")
player_manager.AddValidHands("12312399", "models/cultist/humans/chaos/hands/c_arms_chaos.mdl", 0, "000000")

player_manager.AddValidModel("777771", "models/shaky/scp/scp2012/scp_2012.mdl")
player_manager.AddValidHands("777771", "models/cultist/scp/scp2012/scp_2012_arms.mdl", 0, "000000")

player_manager.AddValidModel("777772", "models/cultist/scp/scp_076.mdl")
player_manager.AddValidHands("777772", "models/cultist/scp/scp_076_arms.mdl", 0, "000000")

player_manager.AddValidModel("125312399", "models/cultist/humans/osn/osn.mdl")
player_manager.AddValidHands("125312399", "models/cultist/humans/osn/hands/c_arms_osn.mdl", 0, "000000")

player_manager.AddValidModel("125312398", "models/cultist/humans/specialmod/nazi/nazi.mdl")
player_manager.AddValidHands("125312398", "models/cultist/humans/specialmod/nazi/arms/c_arms_nazi.mdl", 0, "000000")

player_manager.AddValidModel("125312397", "models/cultist/humans/specialmod/american/american.mdl")
player_manager.AddValidHands("125312397", "models/cultist/humans/specialmod/american/arms/c_arms_american.mdl", 0, "000000")

player_manager.AddValidModel("125312396", "models/cultist/humans/sci/class_d_fat.mdl")
player_manager.AddValidHands("125312396", "models/cultist/humans/sci/hands/c_arms_sci.mdl", 0, "000000")

player_manager.AddValidModel("125312395", "models/cultist/humans/sci/class_d_bor.mdl")
player_manager.AddValidHands("125312395", "models/cultist/humans/sci/hands/c_arms_sci.mdl", 0, "000000")

player_manager.AddValidModel("21525", "models/cultist/humans/mog/mog_woman_capt.mdl")
player_manager.AddValidHands("21525", "models/cultist/humans/mog/hands/c_arms_mog.mdl", 0, "000000")

player_manager.AddValidModel("6216", "models/cultist/humans/mog/mog_woman.mdl")
player_manager.AddValidHands("6216", "models/cultist/humans/mog/hands/c_arms_mog.mdl", 0, "000000")

player_manager.AddValidModel("62161", "models/cultist/humans/goc/goc_female_commander.mdl")
player_manager.AddValidHands("62161", "models/cultist/humans/goc/hands/c_arms_goc.mdl", 0, "000000")

player_manager.AddValidModel("62162", "models/cultist/humans/fbi/fbi_woman.mdl")
player_manager.AddValidHands("62162", "models/cultist/humans/fbi/hands/c_arms_fbi.mdl", 0, "000000")

player_manager.AddValidModel("62167", "models/cultist/humans/ntf/ntf_female_sniper.mdl")
player_manager.AddValidHands("62167", "models/cultist/humans/ntf/hands/c_arms_ntf.mdl", 0, "000000")

player_manager.AddValidModel("62163", "models/cultist/humans/mog/special_security_woman.mdl")
player_manager.AddValidHands("62163", "models/cultist/humans/mog/hands/c_arms_admin.mdl", 0, "000000")

player_manager.AddValidModel("62164", "models/cultist/humans/security/security_female.mdl")
player_manager.AddValidHands("62164", "models/cultist/humans/security/hands/c_arms_security.mdl", 0, "000000")

player_manager.AddValidModel("62165", "models/cultist/humans/class_d/shaky/class_d_fat_new.mdl")
player_manager.AddValidHands("62165", "models/cultist/humans/class_d/hands/c_arms_class_d.mdl", 0, "000000")

player_manager.AddValidModel("62166", "models/cultist/humans/class_d/shaky/class_d_bor_new.mdl")
player_manager.AddValidHands("62166", "models/cultist/humans/class_d/hands/c_arms_class_d.mdl", 0, "000000")

player_manager.AddValidModel("62167", "models/cultist/humans/obr/obr_new.mdl")
player_manager.AddValidHands("62167", "models/cultist/humans/obr/hands/c_arms_obr_new.mdl", 0, "000000")

player_manager.AddValidModel("62168", "models/cultist/humans/mog/sexy_mog_hazmat.mdl")
player_manager.AddValidHands("62168", "models/cultist/humans/mog/hands/c_arms_hazmat.mdl", 0, "000000")