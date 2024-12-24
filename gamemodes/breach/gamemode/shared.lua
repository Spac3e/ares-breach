// Shared file
GM.Name = "Breach"
GM.Author 	= "NextOren/-Spac3"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode("base")
DEFINE_BASECLASS("gamemode_base")

GM.Base = baseclass.Get("base")

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

BREACH = BREACH || {}
BREACH.Version = "1.2 Experimental"

TEAM_SCP = 1
TEAM_GUARD = 2
TEAM_CLASSD = 3
TEAM_SCI = 5
TEAM_CHAOS = 6
TEAM_SECURITY = 7
TEAM_GRU = 8
TEAM_NTF = 9
TEAM_DZ = 10
TEAM_GOC = 11
TEAM_USA = 12
TEAM_QRT = 13
TEAM_COTSK = 14
TEAM_SPECIAL = 15
TEAM_OSN = 16
TEAM_NAZI = 17
TEAM_AMERICA = 18
TEAM_ARENA = 19
TEAM_SPEC = 20

role = {}
ALLLANGUAGES = {}

russian = russian or {}
nontranslated = {}

BREACH.IncludeDir("core/libraries/thirdparty")
BREACH.IncludeDir("core/libraries")
BREACH.Include("core/sh_core.lua")

if SERVER then
    AddCSLuaFile("core/modules/breach_ui/music.lua")
    AddCSLuaFile("core/modules/breach_module/cl_module.lua")
    AddCSLuaFile("core/modules/breach_module/sh_module.lua")
    include("core/modules/breach_module/sv_module.lua")
    include("core/modules/breach_module/sh_module.lua")
else
    include("core/modules/breach_module/cl_module.lua")
    include("core/modules/breach_module/sh_module.lua")
    include("core/modules/breach_ui/music.lua")
end

BREACH.IncludeDir("configs")
BREACH.IncludeDir("configs/languages")
BREACH.IncludeDir("core/modules", true)