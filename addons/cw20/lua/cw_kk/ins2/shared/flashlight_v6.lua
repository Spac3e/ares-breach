// V6 FLASHLIGHT

CustomizableWeaponry_KK.ins2.flashlight.v6 = CustomizableWeaponry_KK.ins2.flashlight.v6 || {}
setmetatable(CustomizableWeaponry_KK.ins2.flashlight.v6, CustomizableWeaponry_KK.ins2.flashlight)

if ( CLIENT ) then

	CustomizableWeaponry_KK.ins2.flashlight.v6.white = Color( 90, 90, 145 )
	CustomizableWeaponry_KK.ins2.flashlight.v6.texture = "nextoren/flashlight/weapon_flashlight"

	local thinkRate = 1 * .150
	local nextupdatet = 0
	--local flashlightupdatet = 0

	function CustomizableWeaponry_KK.ins2.flashlight.v6:Think()

		local curTime = CurTime()

		if ( curTime < nextupdatet ) then return end

		nextupdatet = curTime + thinkRate
		local entities = ents.FindInSphere( LocalPlayer():GetPos(), 1024 )

		for _, wep in ipairs( entities ) do

			if ( !wep.CW20Weapon ) then continue end

			// if swep has attachment ...
			if ( !self:getFL( wep ) ) then continue end

			// ... but no ProjectedTexture, create it
			if ( IsValid( wep._KK_INS2_CL_FL ) ) then continue end

			local pt = ProjectedTexture()
			pt:SetTexture( self.texture )
			pt:SetEnableShadows( false )
			pt:SetFarZ( 512 )
			pt:SetFOV( 60 )

			local particle_flashlight_effect

			hook.Add( "Think", pt, function()

				if !( wep && wep:IsValid() ) then pt:Remove() hook.Remove( "Think", pt ) return end

				local carrier = self:getFL( wep )

				if ( !carrier ) then

					if ( particle_flashlight_effect && particle_flashlight_effect:IsValid() ) then

						particle_flashlight_effect:StopEmissionAndDestroyImmediately()
						particle_flashlight_effect = nil

					end

					hook.Remove( "Think", pt )
					pt:Remove()

					return
				end

				local wepOK = carrier && wep.ActiveAttachments[ carrier.name ] && carrier.getLEMState( wep )
				local ownOK = !( wep.Owner && wep.Owner:IsValid() ) || ( ( wep.Owner && wep.Owner:IsValid() ) && wep.Owner:GetActiveWeapon() == wep )
				--local lowner = wep.Owner == LocalPlayer() && wep.Owner:ShouldDrawLocalPlayer() // local player owns but in 3rd person

				if ( wepOK && wep:IsDormant() ) then

					if ( particle_flashlight_effect && particle_flashlight_effect:IsValid() ) then

						particle_flashlight_effect:StopEmissionAndDestroyImmediately()
						particle_flashlight_effect = nil

					end

					hook.Remove( "Think", pt )
					pt:Remove()

					return
				end

				if ( ownOK && wep.Old_Owner && wep.Old_Owner:IsValid() && wep.Old_Owner != wep.Owner ) then

					if ( particle_flashlight_effect && particle_flashlight_effect:IsValid() ) then

						particle_flashlight_effect:StopEmissionAndDestroyImmediately()
						particle_flashlight_effect = nil

					end

					wep.Old_Owner = wep.Owner

					return
				end

				if wepOK && ownOK then

					pt:SetNearZ( 1 )

					if ( particle_flashlight_effect && particle_flashlight_effect:IsValid() ) then

						particle_flashlight_effect:SetShouldDraw( true )

					end

				else

					pt:SetNearZ( 0 )

					if ( particle_flashlight_effect && particle_flashlight_effect:IsValid() ) then

						particle_flashlight_effect:SetShouldDraw( false )

					end

				end

				local client = LocalPlayer()

				local nowner = !( wep.Owner && wep.Owner:IsValid() )
				local fowner = wep.Owner != client

				if ( nowner || fowner ) then

					if ( !( wep.WMEnt && wep.WMEnt:IsValid() ) ) then

						hook.Remove( "Think", pt )

						if ( pt && pt:IsValid() ) then

							pt:Remove()

						end

						return
					end

					local wment = wep.WMEnt

					local att = wment:GetAttachment( 1 )

					if ( att ) then

						pt:SetAngles( att.Ang )
						pt:SetPos( att.Pos )

						if ( !( particle_flashlight_effect && particle_flashlight_effect:IsValid() ) ) then

							particle_flashlight_effect = CreateParticleSystem( wment, "aircraft_landing_light02", PATTACH_POINT_FOLLOW, 1 )
							wep.Old_Owner = wep.Owner

							wep.OnRemove = function( self )

								if ( particle_flashlight_effect && particle_flashlight_effect:IsValid() ) then

									particle_flashlight_effect:StopEmissionAndDestroyImmediately()

								end

							end

						end

					else

						pt:SetAngles( wment:GetAngles() )
						pt:SetPos( wment:GetPos() )

					end

				end

				--if ( !wep:IsDormant() ) then

					if ( pt:GetColor() != self.white ) then

						pt:SetColor( self.white )

					end

					if ( ownOK && wepOK && pt:GetNearZ() != 1 ) then

						pt:SetNearZ( 1 )

						if ( particle_flashlight_effect && particle_flashlight_effect:IsValid() ) then

							particle_flashlight_effect:SetShouldDraw( true )

						end

					end

					pt:Update()

				--end

			end )

			wep._KK_INS2_CL_FL = pt

		end

	end

	hook.Add( "Think", CustomizableWeaponry_KK.ins2.flashlight.v6, CustomizableWeaponry_KK.ins2.flashlight.v6.Think )

	function CustomizableWeaponry_KK.ins2.flashlight.v6.elementRender(wep, attBeamSource)

		if !attBeamSource then return end
		if !( wep._KK_INS2_CL_FL && wep._KK_INS2_CL_FL:IsValid() ) then return end

		wep._KK_INS2_CL_FL:SetAngles( attBeamSource.Ang )
		wep._KK_INS2_CL_FL:SetPos( attBeamSource.Pos )

	end

end

function CustomizableWeaponry_KK.ins2.flashlight.v6.attach(wep, att)
	-- wep.dt.INS2LAMMode = 0
	wep:SetNWInt("INS2LAMMode", 0)
end

function CustomizableWeaponry_KK.ins2.flashlight.v6:detach()
end
