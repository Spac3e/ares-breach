AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Scarlet Cutscene"
ENT.Author = "Shaky"
ENT.Category = "BREACH SCARLET KING"

ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.AutomaticFrameAdvance = true

function ENT:LinearMotion(endpos, speed)
if !IsValid(self) then return end
	timer.Remove(self:GetClass().."_linear_motion")

	local ratio = 0
	local time = 0
	local startpos = self:GetPos()

	timer.Create(self:GetClass().."_linear_motion", FrameTime(), 9999999999999, function()
		if !IsValid(self) then return end
	    ratio = speed + ratio
	    time = time + FrameTime()
	    self:SetPos(LerpVector(ratio, startpos, endpos))

	    if self:GetPos():DistToSqr(endpos) < 1 then
	    	self:SetPos(endpos)
	    end

	    if self:GetPos() == endpos then
	    	timer.Remove(self:GetClass().."_linear_motion")
	    end
	end)
end

function ENT:Think()
	self:NextThink( CurTime() )

	return true
end

function ENT:Initialize()

	self:SetModel("models/cultist/scp/scarlet_king_shaky.mdl")

	self:SetPlaybackRate( 1 )

	local physobj = self:GetPhysicsObject()
	if IsValid(physobj) then
		physobj:EnableMotion(false)
	end

	self:SetPos(Vector(7079.519043, 2238.759521, -300))
	self:SetAngles(Angle(0, -180, 0))
	if SERVER then
		self:LinearMotion(Vector(7079.519043, 2238.759521, 4.417228), 0.005)
	end
	timer.Simple(1, function()
		self:SetPlaybackRate( 1 )
		self:SetCycle(0)
		self:SetSequence( self:LookupSequence("anm_spawn") )
		if SERVER then
			timer.Simple(3.2, function()
				self:SetPlaybackRate(0.7)
				AlphaWarheadBoomEffect()
				timer.Simple(4.5, function()
					 net.Start("New_RoundStatistics") 
					    net.WriteString("l:roundend_scarletking")
					    net.WriteFloat(27)
					  net.Broadcast()
				end)
				timer.Simple(27, function()
				    RoundRestart()
				end)
				for i, v in pairs(player.GetAll()) do
					v:ScreenFade(SCREENFADE.IN, Color(255,0,0,50), 4, 1)
					if v:GTeam() == TEAM_COTSK then
						v:AddToStatistics("l:escaped", 600)
						v:LevelBar()
						v:SetupNormal()
						v:SetSpectator()
					end
					timer.Simple(1, function()
						if v:GTeam() != TEAM_SPEC and v:Health() > 0 then
							v:Kill()
						end
					end)
				end
			end)
		end
	end)

end