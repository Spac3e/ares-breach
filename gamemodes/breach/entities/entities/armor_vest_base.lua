AddCSLuaFile()

ENT.PrintName		= "Base Armor"
ENT.Author		    = "Kanade"
ENT.Type			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.ArmorType = "armor_light"

function ENT:Initialize()

	self.Entity:SetModel(self.Model)

	self.Entity:PhysicsInit(SOLID_VPHYSICS)

	//self.Entity:SetMoveType(MOVETYPE_VPHYSICS)

	self.Entity:SetMoveType(MOVETYPE_NONE)

	self.Entity:SetSolid(SOLID_BBOX)

	if SERVER then

		self:SetUseType(SIMPLE_USE)

	end
	
	//local phys = self.Entity:GetPhysicsObject()

	//if phys and phys:IsValid() then phys:Wake() end

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) 

	timer.Simple( .2, function()

		if ( !( self && self:IsValid() ) ) then return end

		self:SetPos( Vector( self:GetPos().x, self:GetPos().y, self:GetPos().z  ) )

	end )

end

function ENT:Use(ply)
	if ply:GetRoleName() == "Class-D Fat" then return end
	if ply:GetRoleName() == "Class-D Bor" then return end
	if ply:GTeam() == TEAM_CLASSD or ply:GTeam() == TEAM_SCI or ply:GetRoleName() == "GOC Spy" or ply:GetRoleName() == "SH Spy" or ply:GetRoleName() == "UIU Spy" then 
		if SERVER then
			if ply:GetUsingArmor() != "" then
				ply:BrTip( 0, "[Ares Breach]", Color(255, 0, 0), "l:take_off_vest_to_wear_vest", Color(255, 255, 255) )
				return
			end

			if ( ply:GetUsingCloth() != "armor_sci" and ply:GetUsingCloth() != "armor_medic" and ply:GetUsingCloth() != "" ) or ply:GetModel():find("goc.mdl") then
				ply:BrTip( 0, "[Ares Breach]", Color(255, 0, 0), "l:take_off_uniform_to_wear_vest", Color(255, 255, 255) )
				return
			end

			ply:BrProgressBar("l:progress_wait", 1.5, "nextoren/gui/icons/hand.png", self, false, function()
				if !IsValid(self) or !self.ArmorModel then return end
				ply.VestBonemerge = Bonemerge(self.ArmorModel, ply)

				ply.BodyResist = self.MaxHitsHelmet
	
				ply:BrTip( 0, "[Ares Breach]", Color(255, 0, 0), "l:put_on_vest", Color(255, 255, 255))
		
				ply:SetUsingArmor(self:GetClass())

				if ply:GetUsingHelmet() != "" then
					ply:CompleteAchievement("armor")
				end
				self:Remove()
			end)
			
		end
	else
		if SERVER then
			ply:BrTip(0, "[Ares Breach]", Color(255, 0, 0), "l:you_cant_wear_vest", Color(255, 255, 255) )
		end
	end
end

function ENT:Draw()
	self:DrawModel()
end