AddCSLuaFile()

ENT.Type        = "anim"
ENT.Category    = "Breach"

ENT.Model       = Model( "models/cultist/scp_items/009/w_scp_009.mdl" )

function ENT:Initialize()

	self:SetModel(self.Model)

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)

	if SERVER then
		self:SetTrigger(true)
	end

end

if SERVER then
	local mply = FindMetaTable("Player")

	function mply:Make009Statue()

		if self.GASMASK_Equiped == true then return end

		if self.Used500 then return end

		local ragdoll
		if self:HasWeapon("item_special_document") then
			local document = ents.Create("item_special_document")
			document:SetPos(self:GetPos() + Vector(0,0,20))
			document:Spawn()
			document:GetPhysicsObject():SetVelocity(Vector(table.Random({-100,100}),table.Random({-100,100}),175))
		end
		if !self.DeathAnimation then
			ragdoll = ents.Create("prop_ragdoll")
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetSkin(self:GetSkin())

			ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

			for i = 0, 9 do
				ragdoll:SetBodygroup(i, self:GetBodygroup(i))
			end
			ragdoll:SetPos(self:GetPos())
			ragdoll:Spawn()
			
			ragdoll:SetMaterial("nextoren/ice_material/red_icefloor_01_new")

			if ( ragdoll && ragdoll:IsValid() ) then

					for i = 1, ragdoll:GetPhysicsObjectCount() do

						local physicsObject = ragdoll:GetPhysicsObjectNum( i )
						local boneIndex = ragdoll:TranslatePhysBoneToBone( i )
						local position, angle = self:GetBonePosition( boneIndex )

						if ( physicsObject && physicsObject:IsValid() ) then

							physicsObject:SetPos( position )
							physicsObject:SetMass( 65 )
							physicsObject:SetAngles( angle )
							physicsObject:EnableMotion(false)
							physicsObject:Wake()

					end
				end

			end

			local bonemerges = ents.FindByClassAndParent("v", self)
			if istable(bonemerges) then
				for _, bnmrg in pairs(bonemerges) do
					if IsValid(bnmrg) and !bnmrg:GetNoDraw() then
						local bnmrg_rag = Bonemerge(bnmrg:GetModel(), ragdoll)
						bnmrg_rag:SetMaterial("nextoren/ice_material/red_icefloor_01_new")
					end
				end
			end

		end
	
		self:AddToStatistics("l:scp009_death", -100)
		self:LevelBar()

		local pos = self:GetPos()
		local ang = self:GetAngles()

		self:SetupNormal()
		self:SetSpectator()
		--self:SetPos(pos)
		--self:SetAngles(ang)
		--self:SetLocalAngles(ang)

		return ragdoll

	end
end

function ENT:Draw()

	self:DrawModel()

end

function ENT:IsSeen( ent )



  local trace = {}

  trace.start = self:GetPos()

  trace.endpos = ent:EyePos()

  trace.filter = { self, ent }

  trace.mask = MASK_BULLET

  local tr = util.TraceLine( trace )



  if ( tr.Fraction == 1.0 ) then



    return true;



  end



  return false;



end

function ENT:PhysicsCollide(entity)
	self:EmitSound("scp009/shatter.ogg")
	local eff = EffectData()
	eff:SetScale(25)
	eff:SetOrigin(self:GetPos())
	if !self.noharm then
		util.Effect("projectile_009_explode", eff)
	else
		BroadcastLua("ParticleEffect(\"gas_explosion_main\", Vector("..tostring(self:GetPos().x)..", "..tostring(self:GetPos().y)..", "..tostring(self:GetPos().z).."), Angle(0,0,0), game.GetWorld())")
	end

	local Ents = ents.FindInSphere(self:GetPos(), 255)

	for i, v in pairs(Ents) do

		if v:IsPlayer() and self:IsSeen(v) and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP and !v:HasHazmat() and (v:GTeam() != TEAM_GOC or v:GetRoleName():find("spy")) then

			if !self.noharm then
				v:Make009Statue()
			else
				v:SetMaterial("nextoren/ice_material/red_icefloor_01_new")
				for _, l in pairs(v:LookupBonemerges()) do l:SetMaterial("nextoren/ice_material/red_icefloor_01_new") end
			end

		end

	end

	self:Remove()
end

if SERVER then
	concommand.Add("funny_scp009", function(ply)
		if !ply:IsSuperAdmin() then return end
		local proj = ents.Create("projectile_scp_009")
		proj:SetOwner(ply)
		proj:SetPos(ply:EyePos())
		proj:SetAngles(ply:EyeAngles())
		proj.noharm = true
		proj:SetModelScale(1)
		proj:Spawn()
		proj:PhysWake()
		proj:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		local phy = proj:GetPhysicsObject()
			if IsValid(phy) then
				phy:EnableGravity(false)
				phy:SetVelocity(ply:GetAimVector()*30)
				proj.vel = ply:GetAimVector()*30
				phy:SetAngleVelocity(Vector(math.random(-100,100),55,math.random(-100,100)))
			end
	end)
end
