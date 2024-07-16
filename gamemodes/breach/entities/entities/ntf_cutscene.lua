AddCSLuaFile()

ENT.Base = "base_anim"

ENT.PrintName		= "Scarlet_King"

ENT.Type			= "anim"

ENT.Spawnable		= true

ENT.AdminSpawnable	= true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Owner = nil

ENT.AutomaticFrameAdvance = true

function ENT:Initialize()

	self.Entity:SetModel( "models/cultist/scp/scarlet_king.mdl" )

	self.Entity:SetMoveType(MOVETYPE_NONE )

	self:SetCollisionGroup( COLLISION_GROUP_NONE    )

	self:SetPos(Vector(-676.172058, 6937.478027, 2070.031250))

	self:SetModelScale(2.5, 0)

	if SERVER then
		self.ForceLook = ents.Create("point_forcelook")
		self.ForceLook:SetPos(Vector(-676.172058, 6937.478027, 2070.031250))
		self.ForceLook:Spawn()
	end

	self:SetAngles(Angle(0, -90, 0))

	self:SetLocalVelocity( Vector( 0, 0, -150 ) )

	self:ResetSequence( "anm4" )
	
	self:SetPlaybackRate( 0.5 )

	self:EmitSound("nextoren/scp/001/laugh.mp3", 135, 100, 1.3)

	local cultist_spawns = {
		Vector(-753.114990, 6855.894531, 2048.031250),
		Vector(-690.914001, 6855.760254, 2048.031250),
		Vector(-612.210449, 6855.635254, 2048.031250),
		Vector(-609.702820, 6797.275391, 2048.031250),
		Vector(-685.446594, 6797.565918, 2048.031250),
		Vector(-761.290710, 6797.873047, 2048.031250),
	}

	if SERVER then
		for _, v in ipairs(player.GetAll()) do

			if v:GTeam() == TEAM_SPEC then continue end
			v:StopForcedAnimation()
			local SpawnPos = GroundPos(Vector(math.random(-219, -2194), math.random(6490, 7346), 2320))
			if v:GTeam() == TEAM_COTSK then
				SpawnPos = table.remove(cultist_spawns, math.random(1, #cultist_spawns))
				v:SetNWEntity("NTF1Entity", v)
				v:SetNWAngle("ViewAngles", Angle(0, 90, 0))
				v:SetForcedAnimation("0_cult_ritual", 6)
			end

			v:SetPos(SpawnPos)

			v:StripWeapons()

			v:SetMoveType(MOVETYPE_OBSERVER)

			if v:GTeam() != TEAM_SCP then
				v:BreachGive("br_holster")
				v:SelectWeapon("br_holster")
			end

		end
	end

	ParticleEffectAttach("mr_red_mist_big", PATTACH_ABSORIGIN_FOLLOW, self, 8 )

	timer.Simple(2, function()
		if IsValid(self) then
	
			self:ResetSequence( "idle_knife" ) 
		
			self:SetPlaybackRate( 1 )

		end
	
		timer.Simple(1, function()
			self:EmitSound("nextoren/scp/001/rescue.mp3", 135, 100, 1.3)
			self:ResetSequence( "anm2" ) 
			
			self:SetPlaybackRate( 1 )
		end)
	
		timer.Simple(3, function() 
	
			self:ResetSequence( "anm4" )
		
			self:SetPlaybackRate( 0.5 )
			ParticleEffectAttach("core_finish", PATTACH_ABSORIGIN_FOLLOW, self, 11 )
			for _, ply in ipairs(player.GetAll()) do
				if ply:GTeam() == TEAM_COTSK && ply:Alive() && ply:Health() > 0 then
					ParticleEffectAttach("slave_finish", PATTACH_ABSORIGIN_FOLLOW, ply, 8 )
					if SERVER then

						ply:SetNWEntity("NTF1Entity", NULL)

						ply:SetNWAngle("ViewAngles", Angle(0, 0, 0))

						ply:StopForcedAnimation()

						ply:AddToStatistics("l:cotsk_summon_bonus", 895)
						ply:LevelBar()
						ply:SetSpectator()
	
					end
					
					timer.Simple(5, function()
						ply:StopParticles()
					end)
				end
			end

			timer.Simple(2, function()
				self:EmitSound("nextoren/scp/001/dialogue.mp3", 135, 100, 1.3)
				self:ResetSequence( "anm3" )
		
				self:SetPlaybackRate( 1 )
			end)

		end)
	
		timer.Simple(10, function()
			self:ResetSequence( "anm6" ) --2
	
			self:SetPlaybackRate( 0.5 )
			
			timer.Simple(2, function()
				self:EmitSound("nextoren/scp/001/attack.mp3", 135, 100, 1.3)
				ParticleEffectAttach("core_finish", PATTACH_ABSORIGIN_FOLLOW, self, 11 )
				for _, ply in ipairs(player.GetAll()) do
					if SERVER then ply:ScreenFade(SCREENFADE.IN, Color(255,0,0,120), 2, 0) end
					if ply:GTeam() != TEAM_SPEC && ply:Alive() && ply:Health() > 0 then
						ParticleEffectAttach("infect2", PATTACH_ABSORIGIN_FOLLOW, ply, 8 )
						timer.Simple(.5,  function()
							if SERVER then
								ply:Kill()
							end
						end)
						
						timer.Simple(3, function()
							ply:StopParticles()
						end)
					end
				end
			end)
	
		end)

		timer.Simple(12.5, function()
			if SERVER then
				for _, ply in ipairs(player.GetAll()) do
					ply:ScreenFade(SCREENFADE.OUT, Color(255,0,0,255), 1, 3)
				end
			end
			timer.Simple(3, function()
				if CLIENT then
					surface.PlaySound("nextoren/ending/nuke.mp3")
					LocalPlayer().no_signal = true
				else
					RoundEnd(false, "l:roundend_scarletking")
				end
			end)
		end)
	
		timer.Simple(19, function()
			if SERVER then
				self:StopParticles()
				self:Remove()
				self.ForceLook:Remove()
			end
		end)
	end)

end



