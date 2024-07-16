ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName		= "Alpha Warhead"
ENT.Category		= "Breach"
ENT.Spawnable		= true
ENT.AdminOnly		= false

ENT.TurningOn = false
ENT.ExplosionTime = 120

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Activated" )
	self:NetworkVar( "Int", 0, "DeactivationTime" )
  
	self:SetDeactivationTime(0)
end

net.Receive( "NukeStart", function()
	local nuke = net.ReadBool()
	SetGlobalBool( "NukeTime", nuke )
end )

BREACH.TimeDecision = {
	{ sound = "nextoren/sl/Resume90.ogg", time = 90, triggertime = 90 },
	{ sound = "nextoren/sl/Resume80.ogg", time = 80, triggertime = 80 },
	{ sound = "nextoren/sl/Resume70.ogg", time = 70, triggertime = 70 },
	{ sound = "nextoren/sl/Resume60.ogg", time = 60, triggertime = 60 },
	{ sound = "nextoren/sl/Resume50.ogg", time = 50, triggertime = 50 },
	{ sound = "nextoren/sl/Resume40.ogg", time = 40, triggertime = 40 },
	{ sound = "nextoren/sl/Resume30.ogg", time = 30, triggertime = 0 }
}