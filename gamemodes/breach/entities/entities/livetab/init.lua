AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetBroadcastStatus( false )
    self:SetSupportChannel( 100.1 )
  	self:SetModel("models/next_breach/gas_monitor.mdl");
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	--self:SetAngles( Angle( 0, -90, 0 ) )
	self:SetColor( ColorAlpha( color_white, 1 ) )
	self.SoundStarted = false
	
	if self:GetPos() == Vector(-2961.718750, 3574.164307, 59.353367) and preparing then
		timer.Simple(52, function()
			if not IsValid(self) then
				return
			end

			self:SetBroadcastStatus( true )
		end)

		timer.Simple(56, function()
			if not IsValid(self) then
				return
			end

			sound.Play("screen.lockdown", self:GetPos() )

			timer.Simple(54, function()
				if not IsValid(self) then
					return
				end
	
				self:SetBroadcastStatus( false )
			end)
		end)
	end

	self:SetSupportChannel(Radio_GetChannel(TEAM_GUARD))
end

function ENT:Use( activator, caller )
   return
end
 
function ENT:Think()
end