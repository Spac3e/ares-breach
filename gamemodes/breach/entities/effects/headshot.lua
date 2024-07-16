AddCSLuaFile()

function EFFECT:Init( data )

  local pos = data:GetOrigin()
  local norm = data:GetNormal()
  local ent = data:GetEntity()

  if ( ent:IsPlayer() ) then

    --print( "true dismember" )
    --ent:Dismember( DISMEMBER_HEAD )

  end

  --sound.Play( "physics/flesh/flesh_bloody_impact_hard1.wav", pos, 77, math.Rand( 50, 100 ) )
  --sound.Play( "physics/body/body_medium_break"..math.random( 2, 4 )..".wav", pos, 77, math.Rand( 90, 110 ) )

  --local emitter = ParticleEmitter( pos )
  --for i = 1, 12 do

    --local particle = emitter:Add( "!sprite_bloodspray"..math.random( 8 ), pos )
    --particle:SetVelocity( norm * 32 + VectorRand() * 16 )
    --particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
    --particle:SetStartAlpha( 200 )
    --particle:SetEndAlpha( 0 )
    --particle:SetStartSize( math.Rand( 13, 14 ) )
    --particle:SetEndSize( math.Rand( 10, 12 ) )
    --particle:SetRoll( 180 )
    --particle:SetDieTime( 3 )
    --particle:SetColor( 255, 0, 0 )
    --particle:SetLighting( true )

  --end

  --local particle = emitter:Add( "!sprite_bloodspray"..math.random( 8 ), pos )
  --particle:SetVelocity( norm * 32 )
  --particle:SetDieTime( math.Rand( 2.25, 3 ) )
  --particle:SetStartAlpha( 200 )
  --particle:SetEndAlpha( 0 )
  --particle:SetStartSize( math.Rand( 28, 32 ) )
  --particle:SetEndSize( math.Rand( 14, 28 ) )
  --particle:SetRoll( 180 )
  --particle:SetColor( 255, 0, 0 )
  --particle:SetLighting( true )
  --emitter:Finish() emitter = nil collectgarbage( "step", 64 )

  local maxbound = Vector( 3, 3, 3 )
  local minbound = maxbound * -1
  for i = 1, math.random( 5, 8 ) do

    local dir = ( norm * 2 + VectorRand() ) / 3
    dir:Normalize()
    local eRag = ent:GetNWEntity( "RagdollEntityNO" )
    --ent = ClientsideModel( "models/props_junk/Rock001a.mdl", RENDERGROUP_OPAQUE )
    --if ( ent:IsValid() ) then

      --ent:SetMaterial( "models/flesh" )
      --ent:SetParent( eRag )
      --ent:AddEffects( EF_BONEMERGE )
      --ent:DrawShadow( false )
      --ent:Spawn()
      --ent:SetModelScale( math.Rand( .2, .5 ), 0 )
      --ent:SetPos( pos + dir * 6 )

      if ( eRag:IsValid() ) then

        local boneIndex = eRag:LookupBone( "ValveBiped.Bip01_Head1" )
        local fx = EffectData()
        fx:SetFlags( 1 )
        fx:SetMagnitude( boneIndex )
        fx:SetOrigin( eRag:GetBonePosition( boneIndex ) )
        fx:SetEntity(eRag)
        fx:SetColor( BLOOD_COLOR_RED )
        util.Effect( "br_blood_stream", fx )
        util.Effect( "br_blood_spray", fx )

      end

      --ent:PhysicsInit( minbound, maxbound )
      --ent:SetCollisionBounds( minbound, maxbound )

      --local phys = ent:GetPhysicsObject()
      --if ( phys:IsValid() ) then

        --phys:SetMaterial( "zombieflesh" )
        --phys:SetVelocityInstantaneous( dir * math.Rand( 50, 300 ) )
        --phys:AddAngleVelocity( VectorRand() * 3000 )

      --end

      --SafeRemoveEntityDelayed( ent, 8 )


    --end

  end

end

function EFFECT:Think()

  return false

end

function EFFECT:Render()

end
