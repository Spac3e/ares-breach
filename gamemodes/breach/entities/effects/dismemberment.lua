AddCSLuaFile()

function EFFECT:Init( data )

  self.eEnt = data:GetEntity()
  self.iScale = math.Round( data:GetScale() )

  self.DieTime = CurTime() + 4

end


local Dismembers = { DISMEMBER_HEAD, DISMEMBER_LEFTLEG, DISMEMBER_RIGHTLEG, DISMEMBER_LEFTARM, DISMEMBER_RIGHTARM }

local DismemberBones = {

  { ToZero = { "ValveBiped.Bip01_Head1" }, ToBleed = { ["ValveBiped.Bip01_Head"] = true } },
  { ToZero = { "ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot" }, ToBleed = { [ "ValveBiped.Bip01_L_Thigh" ] = true } },
  { ToZero = { "ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot" }, ToBleed = { [ "ValveBiped.Bip01_R_Thigh" ] = true } },
  { ToZero = { "ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand" }, ToBleed =  { [ "ValveBiped.Bip01_L_UpperArm" ] = true } },
  { ToZero = { "ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand" }, ToBleed = { [ "ValveBiped.Bip01_R_UpperArm" ] = true } }

}

local BoneTranslates = {}

local function CollideCallback( particle, hitpos, hitnormal )

  if ( particle:GetDieTime() == 0 ) then return end
  particle:SetDieTime( 0 )

  if ( math.random( 6 ) == 1 ) then

    sound.Play( "physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random( 95, 105 ) )

  end

  util.Decal( "Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal )

end


function EFFECT:Think()

  local eEnt = self.eEnt

  --print( self.SetDoll )
  if ( !self.SetDoll && eEnt:IsValid() && eEnt:IsPlayer() ) then

    local eRag = eEnt:GetNWEntity( "RagdollEntityNO" )

    print( eRag, " - eRag" )
    if ( eRag && eRag:IsValid() ) then

      self.SetDoll = true
      self.eRagdoll = eRag
      --[[local boneIndex = eRag:LookupBone( "ValveBiped.Bip01_Head1" )
      local fx = EffectData()
      fx:SetFlags( 1 )
      fx:SetMagnitude( boneIndex )
      eRag:SetupBones()
      fx:SetOrigin( eRag:GetBonePosition( boneIndex ) )
      fx:SetColor( eRag:GetBloodColor() )
      util.Effect( "lg_blood_stream", fx )]]
      eRag.Dismemberment = bit.bor( ( eRag.Dismemberment || 0 ), self.iScale )
      print( eRag.Dismemberment )
      self.DieTime = CurTime() + math.Rand( 5, 7 )
      eRag.NextEmit = 0
      self.Entity:SetRenderBounds( Vector( -128, -128, -128 ), Vector( 128, 128, 128 ) )

    end


  end

  if ( self.eRagdoll && self.eRagdoll:IsValid() ) then

    self.Entity:SetPos( self.eRagdoll:GetPos() )

  end



  return CurTime() < self.DieTime
end

function EFFECT:Render()

  local eRagdoll = self.eRagdoll
  local fCurTime = CurTime()

  if ( eRagdoll && eRagdoll:IsValid() && eRagdoll.NextEmit <= fCurTime ) then

    eRagdoll.NextEmit = fCurTime + .05

    local emitter = ParticleEmitter( eRagdoll:GetPos() )
    emitter:SetNearClip( 20, 30 )

    local iDismemberment = 1

    --print( Dismembers )
    --for index, iDismemberPart in pairs( Dismembers ) do

    --  print( index )


      if ( 2 > 1 ) then

        for _, sZeroBone in pairs( DismemberBones[1].ToZero ) do

          local mdl = string.lower( eRagdoll:GetModel() )


          local iBone = eRagdoll:LookupBone( sZeroBone )

          if ( iBone && iBone > 0 ) then

            eRagdoll:ManipulateBoneScale( iBone, vector_tiny )

          end

        end

        for sZeroBone in pairs( DismemberBones[1].ToBleed ) do

          local mdl = string.lower( eRagdoll:GetModel() )


          local iBone = eRagdoll:LookupBone( sZeroBone )
          if ( iBone && iBone > 0 ) then

            local delta = math.max( 0, self.DieTime - fCurTime )

            if ( 0 < delta ) then

              local vBonePos, aBoneAng = eRagdoll:GetBonePosition( iBone )

              if ( vBonePos && aBoneAng ) then

                emitter:SetPos( vBonePos )
                local vForward = aBoneAng:Forward()

                for i = 1, math.random( 0, 2 ) do

                  local particle = emitter.Add( "effects/blood_puff", vBonePos )
                  local force = math.min( 1.5, delta ) * math.Rand( 175, 300 )
                  particle:SetVelocity( force * vForward + .2 * force * VectorRand() )
                  particle:SetDieTime( math.Rand( 2.25, 3 ) )
                  particle:SetStartAlpha( 240 )
                  particle:SetEndAlpha( 0 )
                  particle:SetStartSize( math.random( 1, 8 ) )
                  particle:SetEndSize( 0 )
                  particle:SetRoll( math.Rand( 0, 360 ) )
                  particle:SetRollDelta( math.Rand( -40, 40 ) )
                  particle:SetColor( Color( 255, 0, 0 ) )
                  particle:SetAirResistance( 5 )
                  particle:SetBounce( 0 )
                  particle:SetGravity( Vector( 0, 0, -600 ) )
                  patricle:SetCollide( true )
                  particle:SetCollideCallback( CollideCallback )
                  particle:SetLighting( true )

                end

                local particle = emitter:Add( "effects/blood_puff", vBonePos )
                local vel = eRagdoll:GetVelocity()
                particle:SetVelocity( vel )
                particle:SetDieTime( math.Rand( .5, .75 ) )
                particle:SetStartAlpha( 240 )
                particle:SetEndAlpha( 0 )
                particle:SetStartSize( math.random( 0, 12 ) )
                particle:SetEndSize( 0 )
                particle:SetRoll( math.Rand( 0, 360 ) )
                local vellength = vel:Length() * .45
                particle:SetRollDelta( math.Rand( -vellength, vellength ) )
                particle:SetColor( Color( 255, 0, 0 ) )
                particle:SetAirResistance( 20 )
                particle:SetLighting( true )

              end

            end

          end

        end

      end
      emitter:Finish() emitter = nil; collectgarbage( "step", 64 )

    end


--  end

end
