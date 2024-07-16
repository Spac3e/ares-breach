AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model( "models/cultist/items/ammo_boxes/ammo_box.mdl" )

function ENT:Initialize()

	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )

end

local deathpos = {
	Vector(-937.24810791016, 6998.259765625, 3197.2651367188),
	Vector(8223.384765625, 1690.8590087891, -125.33042907715),
	Vector(-6408.9477539063, -739.78063964844, 3403.3266601563),
	Vector(-7059.4990234375, 2368.1901855469, 3487.8520507813),
	Vector(-2950.8664550781, 4066.2116699219, 33.450950622559),
}

local dimensionpos = {
	Vector(6532.4052734375, -14368.098632813, -15369.505859375)
}

if SERVER then
	function ENT:Think()
	
		local plys = ents.FindInSphere(self:GetPos(), 70)

		for i = 1, #plys do

			local ply = plys[i]

			if IsValid(ply) and ply:IsPlayer() and ply:GTeam() != TEAM_SPEC then

				local rand = math.random(1,3)

				if self.alwaysescape then rand = 1 end

				if rand == 1 then
					ply:ScreenFade(SCREENFADE.IN, color_white, 3,0.5)
					ply:SetPos(ply.ActualPos)
					ply:SetInDimension(false)
					ply:SetNoDraw(false)
					ply:StopMusic()
					ply:SetNoCollideWithTeammates(false)
					ply:SetForcedAnimation( "l4d_GetUpFrom_Incap_04", 5.2, function()

		            if ( ply:IsFemale() ) then

		    					net.Start( "ForcePlaySound" )

		    						net.WriteString( "nextoren/charactersounds/breathing/breathing_female.wav" )

		    					net.Send( ply )

		    				else

		    					net.Start( "ForcePlaySound" )

		    						net.WriteString( "nextoren/others/player_breathing_knockout01.wav" )

		    					net.Send( ply )

		    				end

		            ply:SetDSP( 16 )

		            ply:Freeze( true )
		            ply:SetNWEntity( "NTF1Entity", ply )

		          end, function()

		            ply:ScreenFade( SCREENFADE.IN, color_black, .1, .75 )

		            ply:SetDSP( 1 )

		            ply:Freeze( false )
		            ply:SetNWEntity( "NTF1Entity", NULL )

		          end )
				elseif rand == 2 then
					ply:SetHealth(1)
					ply:ScreenFade(SCREENFADE.IN, Color(255,0,0), 1,1)
					ply:SetPos(deathpos[math.random(1,#deathpos)])
					ply:SetInDimension(false)
					ply:SetNoDraw(false)
					ply:SetNoCollideWithTeammates(false)
					ply:SetLocalVelocity(Vector(0,0,0))
					ply:SetVelocity(Vector(0,0,0))
				elseif rand == 3 then
					ply:ScreenFade(SCREENFADE.IN, color_white, 1,1)
					ply:SetPos(dimensionpos[math.random(1,#dimensionpos)])
				end

			end

		end

	end
end

function ENT:Draw()

end
