util.AddNetworkString( "OpenLootMenu" )
util.AddNetworkString( "ShowEQAgain" )
util.AddNetworkString( "ParticleAttach" )
util.AddNetworkString( "LootEnd" )
util.AddNetworkString("LC_TakeWep")
util.AddNetworkString("3DSoundPosition")
util.AddNetworkString("LC_TakeAmmo")
util.AddNetworkString("Breach_DrawEffect")

local LC = LC or {}

net.Receive("LC_TakeAmmo", function(len, ply) 
	local ent = net.ReadEntity()
	local ammotype = net.ReadUInt(16)
	local ammovalue = net.ReadUInt(16)
	local ammoname = game.GetAmmoName(ammotype)

	ply:GiveAmmo(ammovalue, ammoname, true)
	
	if not ent.vtable then
		return
	end

	if not ent.vtable.Ammo or not ent.vtable.Ammo[ammotype] then
		return
	end

    if ent.vtable.Ammo[ammotype] then
        ent.vtable.Ammo[ammotype] = ent.vtable.Ammo[ammotype] - ammovalue

		if ent.vtable.Ammo[ammotype] <= 0 then
            ent.vtable.Ammo[ammotype] = nil
        end
    end
end)

net.Receive("LootEnd", function(len, ply)
	if (ply.ForceAnimSequence) then
		ply:SetForcedAnimation(false)
		--ply.MovementLocked = nil
	end
end)

net.Receive("3DSoundPosition", function(len, ply)
	net.Start("3DSoundPosition")
	net.WriteString(net.ReadString())
	net.WriteVector(net.ReadVector())
	net.WriteUInt(net.ReadUInt(8), 8)
	net.Broadcast()
end)

net.Receive("LC_TakeWep", function(len, ply)
    local ent = net.ReadEntity()
    local wep = net.ReadString()

    if not IsValid(ent) or not ent.vtable or not ent.vtable.Weapons then
        return
    end

	local vtab = ent.vtable
    local index = table.KeyFromValue(vtab.Weapons, wep)

    if not index then
        return
    end

    ply:Give(wep)

    local weapon = ply:GetWeapon(wep)

    if weapon and weapon:IsValid() then
        local wepdata = vtab.Weapons[wep]

        if wepdata then
            for _, pespatron in ipairs(wepdata) do
                if pespatron.ammo then
                    weapon:SetClip1(pespatron.ammo)
                end

				if pespatron.Heal_Left then
					weapon.Heal_Left = pespatron.Heal_Left
				end
            end

            if wepdata.attachments then
				ply:SendLua("LocalPlayer().DoNotPlayInteract = true")

                for _, attach in ipairs(wepdata.attachments) do
                    weapon:attach(attach.category, attach.position - 1)
                end

				ply:SendLua("LocalPlayer().DoNotPlayInteract = nil")
            end
        end
    end

    table.remove(vtab.Weapons, index)
end)

net.Receive( "ShowEQAgain", function( len, ply )
	local ent = ply:GetEyeTrace().Entity
	
	debug.Trace()

	if ( !ent.vtable || !istable( ent.vtable ) || #ent.vtable.Weapons <= 0 ) then
		if ( ply.MovementLocked ) then
			ply:SetForcedAnimation( false )

			ply.MovementLocked = nil

			net.Start( "MovementLocked" )
				net.WriteBool( false )
			net.Send( ply )
		end
		return
	end

	net.Start( "OpenInventory" )
		net.WriteTable( ent.vtable )
	net.Send( ply )
end)

local clr_red = Color( 255, 0, 0 )

local killing_sndlist = {
	"nextoren/others/cannibal/gibbing1.wav",
	"nextoren/others/cannibal/gibbing2.wav",
	"nextoren/others/cannibal/gibbing3.wav"
}

local zombie_footsteps = {
	"nextoren/charactersounds/zombie/foot1.wav",
	"nextoren/charactersounds/zombie/foot2.wav",
	"nextoren/charactersounds/zombie/foot3.wav"
}

local deathclr = Color( 169, 169, 169 )

hook.Add( "KeyPress", "KeyPressForRagdoll", function( ply, key )	
	local tr = ply:GetEyeTrace()
	local trent = ply:GetEyeTrace().Entity
	if ( key != IN_USE and key != IN_RELOAD ) then return end
 	if ( ply:GTeam() == TEAM_SPEC || ply:GTeam() == TEAM_SCP) then return end

	if ( key == IN_USE ) then

		local tr = ply:GetEyeTrace()
		local self = tr.Entity
		if ( !self.breachsearchable || self:GetClass() != "prop_ragdoll" || self:GetPos():DistToSqr( ply:GetPos() ) > 3025 ) then return end

		ply:SetForcedAnimation( "d1_town05_Daniels_Kneel_Entry", 6, nil )
		ply:SetNWEntity( "NTF1Entity", ply )

		ply:BrProgressBar("l:looting_body", 6, "nextoren/gui/icons/notifications/breachiconfortips.png", trent, false, function()
			if ( !self.vtable ) then return end

			if #self.vtable.Weapons == 0 then
				ply:SetNWEntity("NTF1Entity", NULL)
				ply:SetForcedAnimation(false)
				ply:BrTip(3, "[Ares Breach]", Color(210, 0, 0, 200), "Вы ничего не нашли", clr_red)
				return
			end
			
			--ply.MovementLocked = true

			net.Start( "OpenLootMenu" )
				net.WriteTable( self.vtable or {} )
				net.WriteTable( self.vtable.Ammo or {} )
			net.Send( ply )

			net.Start("LootEnd")
			net.Send(ply)

			ply:SetNWEntity( "NTF1Entity", NULL )

			BREACH.Players:ChatPrint( ply, true, true, "Вы обыскали тело " .. self:GetNWString("SurvivorName") )
		end, nil, function()
			if IsValid(ply) and ply:IsPlayer() and ply:Alive() then
				ply:SetNWEntity("NTF1Entity", NULL)
				ply:SetForcedAnimation(false)
			end
		end)
	end
end)

local DeathReasons = {
	[8194] = "l:body_bullets", -- Почему то физичная пуля это отдельный вид урона...
	[DMG_BULLET] = "l:body_bullets",
	[DMG_SLASH] = "l:body_slashed",
	[DMG_ACID] = "l:body_acid",
	[DMG_FALL] = "l:body_fall",
	[DMG_BURN] = "l:body_burned",
	[DMG_CRUSH] = "l:body_crushed",
	["SCP173"] = "У тела свёрнута шея",
	["SCP0492"]  = "На теле обнаружены многочисленные укусы"
}

function CreateUnconsBody( victim )
	victim:SetNoDraw( true )
	victim:SetNotSolid( true )
	victim:SetDSP( 37 )
	victim:Freeze( true )
	CreateLootBox( victim, nil, nil, true )
end

local corpse_mdl = Model( "models/cultist/humans/corpse.mdl" )

function CreateLootBox( ply, inflictor, attacker, knockedout, dmginfo )
	local team = ply:GTeam()
	if ( team == TEAM_SPEC ) then return end

	if ( team == TEAM_SCP and ply.DeathAnimation ) then
		local SCPRagdoll = ents.Create( "base_gmodentity" )

		SCPRagdoll:SetPos( ply:GetPos() )
		SCPRagdoll:SetModel( ply:GetModel() )
		SCPRagdoll:SetMaterial( ply:GetMaterial() )
		SCPRagdoll:SetAngles( ply:GetAngles() )
		SCPRagdoll:Spawn()
		SCPRagdoll:SetPlaybackRate( 1 )
		SCPRagdoll:SetSequence( SCPRagdoll:LookupSequence( ply.DeathAnimation ) )
		SCPRagdoll.AutomaticFrameAdvance = true
		SCPRagdoll.Think = function( self )
			self:NextThink( CurTime() )
			return true
		end
		return
	end

	local LootBox = ents.Create( "prop_ragdoll" )

	ply:SetNWEntity( "RagdollEntityNO", LootBox )

	if ( ply.burnttodeath || ply.Death_ByAcid ) then
		LootBox:SetModel( corpse_mdl )
		LootBox:SetSkin( ply.burnttodeath and 0 || 1 )
		
	else
		LootBox:SetModel( ply:GetModel() )
	end

	for _, v in pairs( ply:GetBodyGroups() ) do
		LootBox:SetBodygroup( v.id, ply:GetBodygroup( v.id ) )
    end
	
	LootBox:SetAngles( ply:GetAngles() )
	LootBox:SetPos( ply:GetPos() )
	LootBox:SetSkin( ply:GetSkin() )
	LootBox:SetColor( ply:GetColor() )
	LootBox:SetMaterial( ply:GetMaterial() )

	-- Fix for deffib
    LootBox.__Team = ply:GetGTeam()
	LootBox.Role = ply:GetRoleName()
	LootBox.__Health = ply:GetMaxHealth()
	LootBox.Cloth = ply:GetUsingCloth()
	LootBox.__Name = ply:GetNamesurvivor() or ""
	LootBox.WalkSpeed = ply:GetWalkSpeed()
	LootBox.RunSpeed = ply:GetRunSpeed()
	LootBox.OldSkin = ply.OldSkin
	LootBox.OldModel = ply.OldModel
	LootBox.OldBodygroups = ply.OldBodygroups
	LootBox.LastHit = ply:LastHitGroup()
	LootBox.KilledByWeapon = true -- ??

	if ply.AbilityTAB and ply.AbilityTAB != nil then
		LootBox.AbilityTable = ply.AbilityTAB
		LootBox.AbilityCD = ply:GetSpecialCD() or 0
		LootBox.AbilityMax = ply:GetSpecialMax() or 0
	end

	LootBox.vtable = {}
	LootBox.vtable.Ammo = ply:GetAmmo()
	LootBox.vtable.Entity = LootBox
	LootBox.vtable.Weapons = {}
	LootBox.vtable.Name = ply:GetNamesurvivor() or ""

	for _, v in ipairs(ply:GetWeapons()) do
		if v:GetClass() == "breach_keycard_support" then
			LootBox.supportkeycard = true
		end
	end

	if ply.BoneMergedEnts and not (ply.burnttodeath or ply.Death_ByAcid) then
		for _, v in pairs(ply.BoneMergedEnts) do
			if IsValid(v) and not v:GetInvisible() then
				local mdl = v:GetModel()
				local mskin = v:GetSkin()

				if v == ply.HeadEnt and not ply.Head_Split then
					Bonemerge(mdl, LootBox, mskin)
				elseif ply.Head_Split and mdl:find("hair") then
					v:Remove()
				else
					Bonemerge(mdl, LootBox, mskin)
				end
			end
		end

		for index, mat in ipairs( ply:GetMaterials() ) do
			LootBox:SetSubMaterial( index - 1, ply:GetSubMaterial( index - 1 ) )
		end

		if ( ply.HeadEnt and ply.HeadEnt:IsValid() and not ply.Head_Split) then
			for index, mat in ipairs( ply.HeadEnt:GetMaterials() ) do
				LootBox.HeadEnt:SetSubMaterial( index - 1, ply.HeadEnt:GetSubMaterial( index - 1 ) )
				LootBox.HeadEnt:SetSkin( ply.HeadEnt:GetSkin() )
			end

			if (ply:GTeam() != TEAM_SCP or victim.IsZombie) then
				local eyes = LootBox.HeadEnt:GetFlexIDByName("Eyes")

				if eyes then
					LootBox.HeadEnt:SetFlexWeight(eyes, 1)
				end
			end
		end
	end

	for _, weapon in ipairs(ply:GetWeapons()) do
		if weapon.droppable != false and not weapon.UnDroppable and (ply:GTeam() ~= TEAM_SCP or ply.AffectedBy049) then
			table.insert(LootBox.vtable.Weapons, weapon:GetClass())
		end

		local class = weapon:GetClass()

		if not LootBox.vtable.Weapons[class] then
			LootBox.vtable.Weapons[class] = {}
		end

		if class:find("item_medkit_") then
			table.insert(LootBox.vtable.Weapons[class], {Heal_Left = weapon.Heal_Left})
		end

		if weapon:Clip1() then
			table.insert(LootBox.vtable.Weapons[class], {ammo = weapon:Clip1()})
		end

		if weapon.CW20Weapon then
			LootBox.vtable.Weapons[class].attachments = {}

            for k, attCategory in pairs(weapon.Attachments) do
                local v = attCategory.last
                local att = CustomizableWeaponry.registeredAttachmentsSKey[attCategory.atts[v]]
                
                if att then
                    local pos = 1

                    if att.dependencies or attCategory.dependencies or (weapon.AttachmentDependencies and weapon.AttachmentDependencies[att.name]) then
                        pos = #LootBox.vtable.Weapons[class].attachments + 1
                    end

                    table.insert(LootBox.vtable.Weapons[class].attachments, pos, {category = k, position = v})
                end
            end
		end
	end

	if ( team == TEAM_SCP and ply.SCPTable and ply.SCPTable.DeleteRagdoll ) then
		LootBox:Remove()
		ply:SetNWEntity( "RagdollEntityNO", nil )
		ply.SCPTable = nil
	end

	if ( team == TEAM_SCP ) then
		if ( ply:HasWeapon( "weapon_scp_049_2" ) ) then
			for index, mat in ipairs( ply:GetMaterials() ) do
				LootBox:SetSubMaterial( index - 1, ply:GetSubMaterial( index - 1 ) )
			end
			if ( ply.HeadEnt and ply.HeadEnt:IsValid() ) then
				for index, mat in ipairs( ply.HeadEnt:GetMaterials() ) do
				LootBox.HeadEnt:SetSubMaterial( index - 1, ply.HeadEnt:GetSubMaterial( index - 1 ) )
				LootBox.HeadEnt:SetSkin( ply.HeadEnt:GetSkin() )
	    	end
		end
		LootBox.breachsearchable = true
		ply:StripWeapon( "weapon_scp_049_2" )
	end

	elseif ( team != TEAM_SCP ) then
		LootBox.breachsearchable = true
	end

	if ( ply:LastHitGroup() == HITGROUP_HEAD and ply.Head_Split ) then
		ParticleEffectAttach( "blood_advisor_pierce_spray", PATTACH_POINT_FOLLOW, LootBox, 1 )

		if ( LootBox:GetModel() == "models/cultist/humans/sci/scientist.mdl" ) then
			LootBox:SetBodygroup( 3, 0 )
		end

		timer.Simple( .25, function()
			local ef_data = { Name = "br_blood_stream", Entity = LootBox, bone_id = LootBox:LookupBone( "ValveBiped.Bip01_Head1" ) }
			NetEffect( ef_data )
			LootBox.HeadEnt:SetSkin( ply:GetSkin() )
			LootBox.HeadEnt:SetBodygroup( 0, math.random( 1, 3 ) )
		end)

		if ( LootBox.BoneMergedEnts and istable( LootBox.BoneMergedEnts ) ) then
			for _, v in ipairs( LootBox.BoneMergedEnts ) do
				if ( v and v:IsValid() and string.find(v:GetModel(), "helmet_cap")) then
					v:Remove()
				end
			end
		end

		ply.Head_Split = nil
	end

	if ( ply.abouttoexplode ) then
		ply.abouttoexplode = nil
		local current_pos = LootBox:GetPos()
		LootBox.breachsearchable = false

		net.Start( "CreateParticleAtPos" )
			net.WriteString( "pillardust" )
			net.WriteVector( current_pos )
		net.Broadcast()

		net.Start( "CreateParticleAtPos" )
			net.WriteString( "gas_explosion_main" )
			net.WriteVector( current_pos )
		net.Broadcast()

		util.BlastDamage( ply, ply, current_pos, 400, 2000 )

		net.Start( "3DSoundPosition" )
			net.WriteString( "sound/nextoren/others/explosion_ambient_" .. math.random( 1, 2 ) .. ".ogg" )
			net.WriteVector( current_pos )
			net.WriteUInt( 8, 4 )
		net.Broadcast()

		local trigger_ent = ents.Create( "base_gmodentity" )

		trigger_ent:SetPos( current_pos )
		trigger_ent:SetNoDraw( true )
		trigger_ent:DrawShadow( false )
		trigger_ent:Spawn()
		trigger_ent.Die = CurTime() + 50
		trigger_ent.OnRemove = function( self )
			self:StopParticles()
		end
		trigger_ent.Think = function( self )
			self:NextThink( CurTime() + .25 )
			if ( self.Die < CurTime() ) then
				self:Remove()
			end

			for _, v in ipairs( ents.FindInSphere( self:GetPos(), 300 ) ) do

				if ( v:IsPlayer() and v:IsSolid() and v:GTeam() != TEAM_SCP ) then
					v:IgniteSequence( 4 )
				end
			end
		end
	end

	if ply:GTeam() != TEAM_SCP and not ply.IsZombie then
		local someshitbloodpolis = {
			[8194] = true, -- physbul
			[DMG_BULLET] = true,
			[DMG_SLASH] = true,
			[DMG_ACID] = true,
			[DMG_FALL] = true,
			[DMG_CRUSH] = true,
			["SCP0492"]  = true,
		}
		
		if ( someshitbloodpolis[ply.type] ) then

			local boneid = 0

			if ply.bloodpool_washeadshot then
				boneid = LootBox:LookupBone("ValveBiped.Bip01_Head1")
			else
				boneid = LootBox:LookupBone("ValveBiped.Bip01_Spine")
			end
			
	
			timer.Simple(3.6, function()
				CreateBloodPoolForRagdoll(LootBox, boneid, ply:GetBloodColor())
			end)
		end
	end

	LootBox:Spawn()

	if ( ply.burnttodeath ) then
		ply.burnttodeath = nil
		--ParticleEffectAttach( "inferno_wall", PATTACH_POINT_FOLLOW, LootBox, 3 )
		ParticleEffectAttach( "smoke_gib_01", PATTACH_POINT_FOLLOW, LootBox, 3 )
		ParticleEffectAttach( "fire_small_03", PATTACH_POINT_FOLLOW, LootBox, 3 )

		if ( LootBox.BoneMergedEnts and istable( LootBox.BoneMergedEnts ) ) then
			for _, v in ipairs( LootBox.BoneMergedEnts ) do
				if ( v and v:IsValid() ) then
					v:Remove()
				end
			end
		end

		LootBox.breachsearchable = false
		LootBox:EmitSound( "player.burning_death" )

		timer.Simple( 20, function()
			if ( LootBox and LootBox:IsValid() ) then
				LootBox:StopParticles()
				LootBox:StopSound( "player.burning_death" )
			end
		end)
	end

	if ( ply.disintegrate ) then
		ply.disintegrate = nil
		LootBox:SetName( "dissolve_target" )

	  local effect = ents.Create( "env_entity_dissolver" )

	  effect:SetKeyValue( "target", "dissolve_target" )
	  effect:SetKeyValue( "dissolvetype", "3" )
	  effect:SetKeyValue( "magnitude", "60" )
	  effect:Spawn()
	  effect:Activate()
	  effect:Fire( "Dissolve", "dissolve_target", 0 )
	end

	if ( ply.Arrow_Parent ) then
		ply.Arrow_Parent = nil

		for _, v in ipairs( ply:GetChildren() ) do
			if ( v and v:IsValid() and v:GetClass():find( "arrow" ) ) then
				v:SetParent( LootBox, v.Bone_ParentID || 0 )
			end
		end

	elseif ( ply.Death_ByAcid ) then
		ply.Death_ByAcid = nil

		timer.Simple( 1, function()
			net.Start( "CreateClientParticleSystem" )
				net.WriteEntity( LootBox )
				net.WriteString( "boomer_leg_smoke" )
				net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )
				net.WriteUInt( 0, 7 )
				net.WriteVector( vector_origin )
				net.WriteBool( true )
			net.Broadcast()
		end)

		LootBox:SetSkin( 1 )

	elseif ( ply.radiation ) then
		ply.radiation = nil

		local particle_emitter = ents.Create( "base_gmodentity" )

		particle_emitter:SetPos( LootBox:GetPos() )
		particle_emitter:SetParent( LootBox, 1 )
		particle_emitter:SetNoDraw( true )
		particle_emitter:DrawShadow( false )
		particle_emitter:AddEffects( EF_BONEMERGE )
		particle_emitter:Spawn()
		particle_emitter.Think = function( self )
			self:NextThink( CurTime() )

			if ( ( self.NextParticle || 0 ) < CurTime() ) then
				self.NextParticle = CurTime() + 3
				ParticleEffect( "rgun1_impact_pap_child", self:GetPos(), angle_zero, LootBox )
			end

			for _, v in ipairs( ents.FindInSphere( self:GetPos(), 400 ) ) do
				if ( v:IsPlayer() and v:IsSolid() and v:Health() > 0 and !string.find(string.lower(v:GetModel()),"hazmat")) then
					local radiation_info = DamageInfo()
					radiation_info:SetDamageType( DMG_RADIATION )
					radiation_info:SetDamage( 4 )
					radiation_info:SetDamageForce( v:GetAimVector() * 4 )
					if ( v:Health() - radiation_info:GetDamage() <= 0 ) then
						v.radiation = true
					end
					radiation_info:ScaleDamage( 1 * ( 1600 / self:GetPos():DistToSqr( v:GetPos() ) ) )
					v:TakeDamageInfo( radiation_info )
				end
			end
		end
	end

	local velocity = ply:GetVelocity() + (ply:GetAimVector() * math.Rand(1, 3))

	if (LootBox and IsValid(LootBox)) then
		local headIndex = LootBox:LookupBone("ValveBiped.Bip01_Head1")
		LootBox:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		for i = 1, LootBox:GetPhysicsObjectCount() do
			local physicsObject = LootBox:GetPhysicsObjectNum(i)
			local boneIndex = LootBox:TranslatePhysBoneToBone(i)
			local position, angle = ply:GetBonePosition(boneIndex)
	
			if (IsValid(physicsObject)) then
				physicsObject:SetPos(position)

				if LootBox:GetModel():find("jag") or LootBox:GetModel():find("jug") then
					physicsObject:SetMass(375)
				else
					physicsObject:SetMass(275)
				end

				physicsObject:SetAngles(angle)
	
				local velocityMultiplier = math.Rand(2, 6)
				local randomMultiplier = math.Rand(0.6, 0.9)
	
				if (boneIndex == headIndex) then
					physicsObject:SetVelocity((velocity / velocityMultiplier) * randomMultiplier)
				else
					physicsObject:SetVelocity((velocity / velocityMultiplier) * randomMultiplier)
				end
	
				if (ply.force) then
					local forceMultiplier = 1.5
					if (boneIndex != headIndex) then
						forceMultiplier = 1
					end
					physicsObject:ApplyForceCenter(ply.force * forceMultiplier)
				end
	
				timer.Simple(0.2, function()
					if (IsValid(physicsObject)) then
						physicsObject:ApplyForceCenter(Vector(0, 0, physicsObject:GetMass() - math.random(4000, 6000)))
					end
				end)
			end
		end
			
		timer.Simple(1, function()
			if IsValid( LootBox ) then
				LootBox:CollisionRulesChanged()
			end
		end)
	end
	
	if ( knockedout ) then
		ply:SetNWEntity( "NTF1Entity", LootBox )

		LootBox:SetDeathReason( "Человек находится в бессознательном состоянии." )
		LootBox.Knockout = true
		LootBox.PlayerHealth = ply:Health()

		if ( ply.BoneMergedEnts ) then
			for _, v in ipairs( ply.BoneMergedEnts ) do
				if ( v and v:IsValid() ) then
					v:SetNoDraw( true )
					v:DrawShadow( false )
				end
			end
		end
	end
	
	if ( ply:Alive() and ply.AffectedBy049 ) then

    	LootBox:SetVictimHealth( ply:Health() )
		LootBox:SetIsVictimAlive( true )
		LootBox:SetOwner( ply )

		LootBox:TakeDamageInfo(dmginfo)

		LootBox.SCP049Victim = true
		LootBox.SCP049User = ply

		timer.Simple( 40, function()
			if ( LootBox and LootBox:IsValid() ) then
				LootBox:SetIsVictimAlive( false )
			end
		end)
	end

	LootBox:SetOwner( ply )
	LootBox.IsInfected = false
	LootBox:SetCollisionGroup( COLLISION_GROUP_WORLD )

	if ( ply.type and DeathReasons[ ply.type ] ) then
		LootBox:SetNWString("DeathReason1", ( DeathReasons[ ply.type ] ))
	else
		LootBox:SetNWString( "DeathReason1", "l:body_death_unknown" )
	end

	LootBox:SetNWInt("DiedWhen", os.time())

    if ply:LastHitGroup() == HITGROUP_HEAD then
		LootBox:SetNWString( "DeathReason2", "l:body_headshot" )
	end	
end

util.AddNetworkString("ParticleAttach")

function NetEffect(data)
    net.Start("Breach_DrawEffect")
		net.WriteEntity(data.Entity)
    	net.WriteString(data.Name)
    	net.WriteUInt(data.bone_id, 8)
    net.Broadcast()
end
