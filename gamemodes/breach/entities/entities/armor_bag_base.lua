AddCSLuaFile()

ENT.PrintName		= "Base Armor"
ENT.Author		    = "Kanade"
ENT.Type			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.ArmorType = "armor_light"
ENT.Slots = 1

function ENT:Initialize()

	self.Entity:SetModel(self.Model)

	self.Entity:PhysicsInit(SOLID_VPHYSICS)

	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)

	--self.Entity:SetMoveType(MOVETYPE_NONE)

	self.Entity:SetSolid(SOLID_VPHYSICS)

	self.Entity:PhysWake()

	if SERVER then

		self:SetUseType(SIMPLE_USE)

	end
	
	//local phys = self.Entity:GetPhysicsObject()

	//if phys and phys:IsValid() then phys:Wake() end

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) 

	timer.Simple( .2, function()

		if ( !( self && self:IsValid() ) ) then return end

		self:SetPos( Vector( self:GetPos().x, self:GetPos().y, self:GetPos().z  ) )

	end )

end

function ENT:Use(ply)
	if !(ply:GetModel():find("class_d") or ply:GetModel():find("scientist") or ply:GetModel():find("hazmat") or ply:GetModel():find("/security/") or ply:GTeam() == TEAM_CLASSD or ply:GTeam() == TEAM_SCI or ply:GTeam() == TEAM_SPECIAL) or ply:GetModel():find("fat") or ply:GetModel():find("bor") or ply:GetModel():find("mog") then return end
	if ply:GetMaxSlots() + self.Slots <= 12 then 
		if SERVER then

			if ply:GetUsingBag() != "" then
				ply:BrTip(0, "[Ares Breach]", Color(255, 0, 0), "l:already_have_the_bag", Color(255, 255, 255))
				return
			end

			ply:BrProgressBar("l:progress_wait", 1.5, "nextoren/gui/icons/hand.png", self, false, function()
				ply:BrTip(0, "[Ares Breach]", Color(255, 0, 0), "l:took_on_the_bag", Color(255, 255, 255))
		
				ply:SetMaxSlots(ply:GetMaxSlots() + self.Slots)
				ply:SetUsingBag(self:GetClass())
				ply.bonemerge_backpack = Bonemerge(self.Bonemerge, ply)
				self:Remove()

				net.Start("ForcePlaySound")
				net.WriteString("nextoren/backpack_puton.ogg")
				net.Send(ply)
			end)
			
		end
	else
		if SERVER then
			ply:BrTip(0, "[Ares Breach]", Color(255, 0, 0), "l:you_cant_wear_the_bag", Color(255, 255, 255) )
		end
	end
end

function ENT:Draw()
	self:DrawModel()
end