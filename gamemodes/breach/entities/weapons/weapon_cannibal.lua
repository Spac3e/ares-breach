if ( CLIENT ) then
	SWEP.PrintName = "Каннибализм"
	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/canibal.png" )

end

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel						= Model( "models/jessev92/weapons/buddyfinder_c.mdl" )
SWEP.WorldModel						= Model( "models/jessev92/weapons/buddyfinder_w.mdl" )

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.droppable				= false
SWEP.UnDroppable 			= true
SWEP.teams					= {2,3,5,6,7,8,9,10,11,12}
SWEP.HoldType 				= "normal"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.LockPickTime = 60

SWEP.CorpseEated = 0

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

/*---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------*/
SWEP.SoundList = {

  "nextoren/others/cannibal/gibbing1.wav",
  "nextoren/others/cannibal/gibbing2.wav",
  "nextoren/others/cannibal/gibbing3.wav"

}

function SWEP:Deploy()

    self.Owner:DrawViewModel( false )
    if ( SERVER ) then

        self.Owner:DrawWorldModel( false )

    end

end

function SWEP:Think() end

function SWEP:PrimaryAttack()

	if SERVER then

		local tr = self.Owner:GetEyeTraceNoCursor()

		local ent = tr.Entity

		if !ent then return end
		if ent:GetClass() != "prop_ragdoll" then return end
		if ent:GetModel():find("corpse.mdl") then return end

		local uniqid = "GibSound"..self.Owner:SteamID64()

		local function start()
			self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
			timer.Create(uniqid, 1, 8, function()
				self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
			end)
		end

		local function stop()
			timer.Remove(uniqid)
		end

		local function finish()
			if IsValid(ent) then

				ent:SetModel( "models/cultist/humans/corpse.mdl" )
				ent:SetSkin( 2 )

				if ent.vtable and ent.vtable.Weapons and table.HasValue(ent.vtable.Weapons, "item_special_document") then

					table.RemoveByValue(ent.vtable.Weapons, "item_special_document")

					ent:SetNWBool("HasDocument", false)

					local document = ents.Create("item_special_document")
					document:SetPos(ent:GetPos() + Vector(0,0,20))
					document:Spawn()
					document:GetPhysicsObject():SetVelocity(Vector(table.Random({-100,100}),table.Random({-100,100}),175))

				end

				if ent.IsFemale then
					ent:SetBodygroup(0, 1)
				else
					ent:SetBodygroup(0, 0)
				end

				ent.AlreadyEaten = true
				ent.breachsearchable = false

				self.Owner:AddToAchievementPoint("cannibal", 1)
				self.Owner:SetHealth( self.Owner:Health() + 30 )
				self.CorpseEated = self.CorpseEated + 1

				if self.CorpseEated == 5 then
					self.Owner:SetMaxHealth( self.Owner:GetMaxHealth() + 40 )
				elseif self.CorpseEated >= 10 then
					self.Owner:SetMaxHealth( self.Owner:GetMaxHealth() + 20 )
				end

				for i, bnmrg in pairs(ent:LookupBonemerges()) do
					bnmrg:Remove()
				end

			end
		end

		self.Owner:BrProgressBar( "l:cannibal", 8, "nextoren/gui/icons/canibal.png", ent, false, finish, start, stop )

	end

	--[[

	if ( ( self.NextTry || 0 ) >= CurTime() ) then return end
	self.NextTry = CurTime() + 2

	local tr = self.Owner:GetEyeTraceNoCursor()
	local time;
	local ent = tr.Entity
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	if SERVER then
		if ( ent:GetClass() == "prop_ragdoll" && !ent.AlreadyEaten ) then
	
			self.Owner:Freeze(true)
	
			if SERVER then
				self.Owner:BrProgressBar( "Поедаю...", 8, "nextoren/gui/icons/canibal.png")
			end
	
			timer.Create("Gibbing"..self.Owner:SteamID64() , 1 , 1, function() 
				if IsValid(self.Owner) then 
					self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
				end 
			end)
			timer.Create("Gibbing2"..self.Owner:SteamID64() , 4 , 1, function() 
				if IsValid(self.Owner) then 
					self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
				end 
			end)
			timer.Create("Gibbing3"..self.Owner:SteamID64() , 6 , 1, function() 
				if IsValid(self.Owner) then 
					self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
				end 
			end)
			timer.Create("Gibbing4"..self.Owner:SteamID64() , 7 , 1, function() 
				if IsValid(self.Owner) then 
					self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
				end 
			end)
			timer.Create("FinalGibbing"..self.Owner:SteamID64() , 8 , 1, function()
				self.Owner:Freeze(false)
				if ( ent:GetClass() == "prop_ragdoll" ) then
					ent:SetModel( "models/cultist/humans/corpse.mdl" )
					ent:SetSkin( 2 )
	
					if ( ent.BoneMergedEnts ) then
	
						for _, v in ipairs( ent.BoneMergedEnts ) do
	
							if ( v && v:IsValid() ) then
	
								v:Remove()
							end
						end
					end
					if ( ent.BoneMergedHackerHat ) then
	
						for _, v in ipairs( ent.BoneMergedHackerHat ) do
	
							if ( v && v:IsValid() ) then
	
								v:Remove()
							end
						end
					end
					if ( ent.GhostBoneMergedEnts ) then
	
						for _, v in ipairs( ent.GhostBoneMergedEnts ) do
	
							if ( v && v:IsValid() ) then
	
								v:Remove()
							end
						end
					end

					ent.AlreadyEaten = true
					ent.breachsearchable = false
					self.Owner:AddToAchievementPoint("cannibal", 1)
					self.Owner:SetHealth( self.Owner:Health() + 30 )
					self.CorpseEated = self.CorpseEated + 1
					if self.CorpseEated == 5 then
						self.Owner:SetMaxHealth( self.Owner:GetMaxHealth() + 40 )
					elseif self.CorpseEated >= 10 then
						self.Owner:SetMaxHealth( self.Owner:GetMaxHealth() + 20 )
					end
				end
			end)
		end
	end]]
end

function SWEP:DrawWorldModel()

	return false

end

function SWEP:Holster()

	hook.Remove("CalcView", "FirstPersonScene")

	timer.Remove("FinalGibbing")
	timer.Remove("Gibbing")
	timer.Remove("Gibbing2")
	timer.Remove("Gibbing3")
	timer.Remove("Gibbing4")
	timer.Remove("RemoveFP")
	timer.Remove("Standing")

	self.Owner:DoAnimationEvent(ACT_RESET)
	return true

end

function SWEP:OnRemove()

	self.CorpseEated = 0

end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end


