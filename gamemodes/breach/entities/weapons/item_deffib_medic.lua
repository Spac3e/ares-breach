SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/medic_kit.png" )

end

SWEP.PrintName		= "Дефибриллятор"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.WorldModel = "models/cultist/items/defib/w_defib.mdl"
SWEP.ViewModel = "models/cultist/items/defib/v_defib.mdl"
SWEP.HoldType		= "heal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true
SWEP.teams					= {2,3,4,6}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands				= true


SWEP.Pos = Vector( 3,-1,0 )
SWEP.Ang = Angle( 0,0,90 )

SWEP.Pos2 = Vector( 3,-1,0 )
SWEP.Ang2 = Angle( 0,0,90 )

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )
    self.WModel:SetModelScale(0.8)

	end

	return self.WModel

end
function SWEP:CreateWorldModel2()

	if ( !self.WModel2 ) then

		self.WModel2 = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel2:SetNoDraw( true )
    self.WModel2:SetModelScale(0.8)

	end

	return self.WModel2

end
function SWEP:DrawWorldModel()

	local pl = self:GetOwner()

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		local bone2 = self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
		if ( !bone ) then return end

		local wm = self:CreateWorldModel()
		local wm2 = self:CreateWorldModel2()
		local pos, ang = self.Owner:GetBonePosition( bone )
		local pos2, ang2 = self.Owner:GetBonePosition( bone2 )

		if ( wm && wm:IsValid() ) then

			ang:RotateAroundAxis( ang:Right(), self.Ang.p )
			ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
			ang:RotateAroundAxis( ang:Up(), self.Ang.r )

			wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
			wm:SetRenderAngles( ang )
			wm:DrawModel()

		end

		if ( wm2 && wm2:IsValid() ) then

			ang2:RotateAroundAxis( ang2:Right(), self.Ang2.p )
			ang2:RotateAroundAxis( ang2:Forward(), self.Ang2.y )
			ang2:RotateAroundAxis( ang2:Up(), self.Ang2.r )

			wm2:SetRenderOrigin( pos2 + ang2:Right() * self.Pos2.x + ang2:Forward() * self.Pos2.y + ang2:Up() * self.Pos2.z )
			wm2:SetRenderAngles( ang2 )
			wm2:DrawModel()

		end

	else

		self:SetRenderOrigin( nil )
		self:SetRenderAngles( nil )
		self:DrawModel()

	end

end

function SWEP:Deploy()

	self:SendWeaponAnim( ACT_VM_DRAW )
	self.NextThinkt = CurTime() + 2

end

function SWEP:Think()

	if ( ( self.NextThinkt || 0 ) <= CurTime() ) then

		self:SendWeaponAnim( ACT_VM_IDLE )

	end

end

function RevivePlayer( self, ply, body, force, wep )

	if !IsValid(ply) or CLIENT then return end

	if !force then
		if body.__Team == TEAM_SCP then return end

		if body:GetModel():find("corpse.mdl") then self:AresNotify("l:deffib_body_decayed_pt1 ", Color(255,0,0), "l:deffib_body_decayed_pt2") return end

		--if body.DieWhen + 45 <= CurTime() then self:AresNotify("l:deffib_body_too_late_pt1 ", Color(255,0,0), "l:deffib_body_too_late_pt2") return end

		local isheadgibbed = false

		for i, v in pairs(body:LookupBonemerges()) do

			if IsValid(v) and v:GetModel():find("gib_head") then
				isheadgibbed = true
				break
			end

		end

		if ( body.KilledByWeapon and body.LastHit == HITGROUP_HEAD ) or isheadgibbed then self:AresNotify("l:deffib_headshot_pt1 ", Color(255,0,0), "l:deffib_headshot_pt2") return end

		self:BrProgressBar("l:ressurecting_someone", 2,"nextoren/gui/icons/medic_kit.png", body, false, nil, nil, function() self:StopForcedAnimation() end)
	end

	local finishcallback = function()

		if IsValid(wep) then wep:Remove() end

		self:CompleteAchievement("deffib")

		self:SetNWEntity("NTF1Entity", NULL)

		if ply:GTeam() != TEAM_SPEC and ply:Health() > 0 then return end

		if CLIENT then return end
		timer.Remove( "PlayerDeathFromBleeding" .. ply:SteamID64() )

		ply:SetupNormal()
		ply:SetModel(body:GetModel())
		ply:SetSkin(body:GetSkin())
		ply:SetGTeam(body.__Team)
		ply:SetRoleName(body.Role)
		ply:SetMaxHealth(body.__Health) 
		ply:SetHealth(ply:GetMaxHealth() * .65)
		ply:SetUsingCloth(body.Cloth)
		ply:SetNamesurvivor(body.__Name)
		ply.OldSkin = body.OldSkin
		ply.OldModel = body.OldModel
		ply.OldBodygroups = body.OldBodygroups
		ply:SetWalkSpeed(body.WalkSpeed)
		ply:SetRunSpeed(body.RunSpeed)
		ply:SetupHands()
		ply:SetNWAngle("ViewAngles", ply:GetAngles())
		timer.Remove("Death_Scene"..ply:SteamID())
		--ply:StripWeapons()
		--ply:StripAmmo()
		ply:SetMoveType(MOVETYPE_OBSERVER)
		ply:Freeze(true)

		if istable(body.AmmoData) then
			for ammo, amount in pairs(body.AmmoData) do
				ply:SetAmmo(amount, ammo)
			end
		end

		if body.AbilityTable != nil then
			ply:SetNWString("AbilityName", body.AbilityTable[1])
			net.Start("SpecialSCIHUD")
		        net.WriteString(body.AbilityTable[1])
			    net.WriteUInt(body.AbilityTable[2], 9)
			    net.WriteString(body.AbilityTable[3])
			    net.WriteString(body.AbilityTable[4])
			    net.WriteBool(body.AbilityTable[5])
		    net.Send(ply)

		    ply:SetSpecialCD(body.AbilityCD)
		    ply:SetSpecialMax(body.AbilityMax)

		end
		--ply:BreachGive("br_holster")


		--if body.vtable and body.vtable.Weapons then
			for _, v in pairs(body.vtable.Weapons) do
				if weapons.GetStored(v) then
					ply:BreachGive(v)
				end
			end
		--else
			ply:BreachGive("br_holster")
		--end

		if body.supportkeycard then
			ply:Give("breach_keycard_support")
		end

		for _, bnmrg in pairs(body:LookupBonemerges()) do
			local bnmrg_ent = Bonemerge(bnmrg:GetModel(), ply)
			bnmrg_ent:SetSubMaterial(0, bnmrg:GetSubMaterial(0))
			bnmrg_ent:SetSubMaterial(2, bnmrg:GetSubMaterial(2))
			bnmrg_ent:SetSkin(bnmrg:GetSkin())
			bnmrg_ent:SetInvisible(bnmrg:GetInvisible())
		end

		for i = 0, 9 do
			ply:SetBodygroup(i, body:GetBodygroup(i))
		end

		ply:SetPos( Vector(body:GetPos().x, body:GetPos().y, GroundPos(body:GetPos()).z) )
		ply:SetAngles( body:GetAngles() )

		ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		ply:SetForcedAnimation( ply:LookupSequence("l4d_Defib_Jolt"), 8, function() ply:GodEnable() ply:ScreenFade(SCREENFADE.IN, color_white, 4, 0) ply:SetNWEntity("NTF1Entity", ply) end, function()

			ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			ply:SetForcedAnimation( ply:LookupSequence("l4d_Defib_Revive"), ply:SequenceDuration(ply:LookupSequence("l4d_Defib_Revive")), nil, function()

				ply:GodDisable()

				ply:ScreenFade(SCREENFADE.IN, color_black, 1, 0.5)

				ply:SetNWAngle("ViewAngles", Angle(0,0,0))

				ply:SetDSP( 1 )
				ply:Freeze( false )
				ply:SetMoveType(MOVETYPE_WALK)
				ply:SetNWEntity("NTF1Entity", NULL)

			end )

		end )

		body:SetNoDraw(true)

		timer.Simple( .2, function()

			body:Remove()

			if ( ply && ply:IsValid() ) then

				ply:SetNoDraw( false )

			end

		end )

		ply:SetNotSolid( false )

	end

	if !force then

		self:SetForcedAnimation("l4d_defibrillate_incap_standing", 2, function() self:SetNWEntity("NTF1Entity", self) end, finishcallback, function() self:SetNWEntity("NTF1Entity", NULL) end)

	else
		finishcallback()
	end

end

function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()

	local ent = tr.Entity

	self.NextThinkt = CurTime() + 2

  self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )

	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity

	if ( ent && ent:IsValid() && ent:GetClass() == "prop_ragdoll" && !ent.NOREVIVE ) then

		RevivePlayer( self.Owner, ent:GetOwner(), ent, nil, self )

	end

  --[[timer.Simple( .9, function()

	  self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

  end )]]

end

function SWEP:OnDrop()

		if IsValid(self.Owner) then
			self.Owner:BrStopProgressBar("l:ressurecting_someone")
		end

end

function SWEP:Reload()
end

function SWEP:SecondaryAttack()

  return false

end
