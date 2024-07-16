ENT.Author = "Ethorbit"
ENT.PrintName = "Turret"

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "FOVLimit")
	self:NetworkVar("Float", 0, "LastTargetLock")
	self:NetworkVar("Float", 1, "NextShoot")
	self:NetworkVar("Bool", 0, "TargetVisible")
end