local V = {

	Name = "SCP_Vehicle",
	Class = "prop_vehicle_jeep",
	Model = "models/tdmcars/jeep_wrangler88.mdl",
  KeyValues = {

		vehiclescript	=	"scripts/vehicles/wrangler88.txt"

	}

}

list.Set( "Vehicles", "wrangler88", V )

--timer.Simple( 5, function()

  VD2 = VD2 || {}

  --VD2.RegisteredVehicles = {}

  function VD2_Setup(ent)

      if !( ent && ent:IsValid() ) then return end

      if !ent:IsVehicle() then return end

      if ent.VehicleSeat then return end

      timer.Simple( .1, function()

        if ( !( ent && ent:IsValid() ) ) then return false end

        ent.VD2_Engine = ent:LookupAttachment("vehicle_engine")

        if ent.VD2_Engine <= 0 then return end

        local hp = GetConVar("vd2_basehp"):GetInt()

        if ( SERVER ) then

          local phys = ent:GetPhysicsObject()

          ent:SetHealth( 400 )
          ent:SetMaxHealth( 400 )
          ent.Locked = true
          if ( phys ) then hp = 500 end

          ent.VD2_Passengers = { ent }

          if ( !ent:IsVehicle() ) then return end

          local class = ent:GetVehicleClass()
          local veh_list = list.Get( "Vehicles" )

          local veh_table = veh_list[ "wrangler88" ]

          local seatdata = veh_table

          local seatdataseats = seatdata.VC_ExtraSeats
          ent.Seats = ent.Seats || {}

          if ( seatdataseats ) then

            for i, k in ipairs( seatdataseats ) do

              local seat = ents.Create( "prop_vehicle_prisoner_pod" )
              local ang = ent:GetAngles()
              local up = ang:Up()
              local right = -ang:Right() * 1.3
              local forward = ang:Forward()
              local pos = ent:GetPos()
              local offset = k.Pos

              local newpos = pos + (offset.x * forward) + (offset.y * right) + (offset.z * up)

              if ( seat ) then

                seat:SetModel( k.Model || "models/props_phx/carseat.mdl" )
                seat:SetKeyValue( "vehiclescript", "scripts/vehicles/prisoner_pod.txt" )
                seat:SetKeyValue( "limitview", "0" )
                seat:SetPos(newpos)
                seat:SetAngles(ang)
                seat:Spawn()
                seat:SetParent(ent)
                seat:SetMoveType(MOVETYPE_NONE)
                seat:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                seat:SetModelScale( 3, 0 )
                seat:Activate()
                seat.VD2 = false
                seat.VD2_Passenger = true
                seat.VD2_ExitAng = k.ExitAng

                seat:SetRenderMode(RENDERMODE_NONE)

                seat:SetVehicleEntryAnim( false )

              end

              ent.VD2_Passengers[i + 1] = seat

            end

          end

        end
      end)
  end

  function VD2_Crash(ent, coldata)
      if !GetConVar("vd2_crash"):GetBool() then return end

      if coldata.DeltaTime < 1 then return end

      local crashvel = coldata.OurOldVelocity:Length()

      if crashvel < 400 then return end

      if coldata.HitEntity:IsNPC() or  coldata.HitEntity:IsPlayer() then return end

      local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)

      dot = math.abs(dot) / 2

      local dmg = DamageInfo()

      dmg:SetDamageType(DMG_CRUSH)
      dmg:SetDamage(crashvel * VD2.CrashMult * dot)

      ent:TakeDamageInfo(dmg)
  end

  local function TableRandomChoiceFast(tbl)

    return tbl[math.random(#tbl)]

  end

  local bannedTeams = {
    [1] = true, -- SCP
  }

local passengerseats = {
{position = Vector(21.587465, 6.265999, 15.578308), angle = Angle(-0.217, -1.114, 7.251), exit = Vector(-68.337494, -57.769089, 19.984171), left = true}, --левое заднее
{position = Vector(23.142925, -42.559750, 13.926813), angle = Angle(-0.129, 2.590, 7.012), exit = Vector(69.206047, -56.263855, 19.418047), left = false}, --правое заднее
{position = Vector(-17.986423, -50.059891, 12.681565), angle = Angle(0.073, 2.424, 6.845), exit = Vector(70.974495, 5.360078, 20.245583), left = false}, --штурман
}

local function IsCarOrSeat(ent)
  if ent:GetModel() == "models/scpcars/scpp_wrangler_fnf.mdl" then
    return true
  end

  if ent.VehicleSeat then
    return true
  end

  return false
end

hook.Add("PlayerUse", "VD2USE", function(ply, ent)
  if !ent:IsVehicle() then return end

  if ent:GetModel() == "models/scpcars/scpp_wrangler_fnf.mdl" then
    if ply:InVehicle() then return end
    if !IsFirstTimePredicted() then return end

    if ply:GetObserverMode() != OBS_MODE_NONE then
      return
    end

    local veh = ent

    if veh.CreatedSeats then
      for k, v in pairs(veh.CreatedSeats) do
        if v.Occupied == false then continue end

        if !IsValid(v.Occupied) then
          veh.CreatedSeats[k].Occupied = false
        end

        if IsValid(v.Occupied) then
          if IsValid(v.Occupied:GetVehicle()) then
            if v.Occupied:GetVehicle():GetModel() == "models/scpcars/scpp_wrangler_fnf.mdl" then
              veh.CreatedSeats[k].Occupied = false
            end
          end

          if !v.Occupied:InVehicle() then
            veh.CreatedSeats[k].Occupied = false
          end
        end
      end
    end

    if veh.Driver then
    for k, v in pairs(veh.CreatedSeats) do
      if !v.Occupied then

        ply:DrawWorldModel( false )

        ply:SetNWEntity("NTF1Entity", ply)

        ply:EmitSound( "nextoren/vehicle/car_enter.wav" )
        ply:EmitSound( "nextoren/vehicle/car_doorslam.wav" )
        ply.EnteringSeat = true
        ply:EnterVehicle(v)
        ply.EnteringSeat = false
        v.Occupied = ply
        return
      end
    end
  end
end
end)

local mplayer = FindMetaTable("Player")

function mplayer:CanEnterThisShit()
  if self:GTeam() == TEAM_SCP or self:GTeam() == TEAM_SPEC then
    return false
  end

  return true
end

  function VD2_EnterVehicle( ply, veh )

	if !IsCarOrSeat(veh) then return end
  if ply.EnteringSeat then return true end

	if !veh.CreatedSeats then
		veh.CreatedSeats = {}
		for k, v in ipairs(passengerseats) do
		local seat = ents.Create( "prop_vehicle_prisoner_pod" )
		seat:SetModel("models/nova/chair_plastic01.mdl")
		seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
		seat:SetKeyValue("limitview", "1")
		seat:SetPos(veh:LocalToWorld(v.position))
		seat:SetAngles(veh:LocalToWorldAngles(v.angle))
		seat:Spawn()
		seat:SetParent(veh)
		seat:SetMoveType(MOVETYPE_NONE)
		seat:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		seat:SetNoDraw(true)
		seat.VehicleSeat = true
		seat.Occupied = false
    seat.ExitPosition = v.exit
    seat.isleft = v.left
		veh.CreatedSeats[k] = seat -- create passenger seat
		end
	end

    veh.TurnedOff = true

		timer.Simple( .1, function()

			if ( !ply:InVehicle() ) then

				ply:DrawViewModel( true )

			end

		end )

    if ( veh.Exploded ) then

      timer.Simple( .1, function() ply:DrawViewModel( true ) end )

      ply:AresNotify( "Машина взорвана!" )

      return false

    end

    if !ply:CanEnterThisShit() then

      ply:AresNotify( "Вы не можете использовать автомобиль." )
      return false

    end

    if veh.Locked == nil then veh.Locked = true end

    if veh.Locked then

      if !veh.VehicleSeat then
        ply:AresNotify( "Машина заперта!" )
        return false
      end

    end

	if veh.VehicleSeat then
			return false
	end

	if !veh.Driver then
		ply:DrawWorldModel( false )

		ply:SetNWEntity("NTF1Entity", ply)

		ply:EmitSound( "nextoren/vehicle/car_enter.wav" )
		ply:EmitSound( "nextoren/vehicle/car_doorslam.wav" )

		veh.Driver = ply
    return true
	end
	
	return false

  end

  function VD2_CanExitVehicle( vehicle, ply )

	if !IsCarOrSeat(vehicle) then return end

    local speed = vehicle:GetVelocity():Length()

    if ( vehicle:GetParent():IsValid() ) then

      speed = vehicle:GetParent():GetVelocity():Length()

    end

    if ( speed > 250 ) then

      ply:setBottomMessage("You cannot exit a moving vehicle!")
      return false

    end
    ply:DrawWorldModel( true )
    timer.Simple( .2, function() ply:DrawViewModel( true ) end)
    ply.NextUseCar = CurTime() + 1.5

  end

  function VD2_ExitVehicle(ply, vehicle)
  
	if !IsCarOrSeat(vehicle) then return end

	if vehicle.Driver == ply then
		vehicle.TurnedOff = true
		vehicle.Driver = nil
	end
    if ( vehicle.VD2_ExitAng ) then

      local ang = vehicle:GetAngles() + vehicle.VD2_ExitAng + Angle(0, 90, 0)
      local newpos = vehicle:GetPos() + ang:Forward() * 64

      newang = vehicle:GetAngles() + Angle(0, 90, 0)
      newang.r = 0

      local tr = util.TraceEntity({

        start = vehicle:GetPos(),
        endpos = newpos,
        filter = {vehicle, vehicle:GetParent()}

      }, ply)

      if ( !tr.Hit ) then

        ply:SetPos(vehicle:GetPos() + ang:Forward() * 64)
        ply:SetEyeAngles(newang)

      end

    end
    ply:SetNWEntity("NTF1Entity", NULL)

    if vehicle.left then
      ply:SetPos(ply:GetPos() + ply:GetAngles():Right()*-45)
    else
      ply:SetPos(ply:GetPos() + ply:GetAngles():Right()*45)
    end

  if vehicle.CreatedSeats then
	for k, v in pairs(vehicle.CreatedSeats) do
		if v.Occupied == ply then
			v.Occupied = nil
		end
	end
end

  end

  function VD2_SwitchSeat(ply, ent)
      if !ent.VD2_Passengers then return end

      local curr_ind = 1

      for i, k in pairs(ent.VD2_Passengers) do

        if k:GetDriver() == ply then

          curr_ind = i
          break

        end

      end


      local maxn = table.maxn(ent.VD2_Passengers)

      for i = 1, maxn do
          local new_ind = curr_ind + i
          if new_ind > maxn then
              new_ind = new_ind - maxn
          end

          local new_seat = ent.VD2_Passengers[new_ind]
          if new_seat then
              if IsValid(new_seat:GetDriver()) then continue end

              local preserve = ply:EyeAngles()

              ply:ExitVehicle()
              new_seat:SetThirdPersonMode(false)
              ply:EnterVehicle(new_seat)

              local ang = preserve - ent:GetAngles()
              ang.r = 0

              ply:SetEyeAngles(ang)

              ply:EmitSound("npc/combine_soldier/gear6.wav")

              break
          end
      end
  end

  function VD2_Explode( ent )

    local OwnerEnt = ent

    if ( IsValid( ent:GetDriver() ) ) then

      OwnerEnt = ent:GetDriver()

    end

    if ( IsValid( OwnerEnt ) && OwnerEnt:IsPlayer() ) then

      OwnerEnt:ExitVehicle()

    end

    ParticleEffect( "pillardust", ent:GetPos(), ent:GetAngles(), ent )
    ParticleEffect( "gas_explosion_main", ent:GetPos(), ent:GetAngles(), ent )

    local fire = ents.Create( "base_gmodentity" )
    fire:SetPos( ent:GetPos() )
    fire:SetNoDraw( true )
    fire:Spawn()
    fire.Think = function( self )

      self:NextThink( CurTime() )

      for _, v in ipairs( ents.FindInSphere( self:GetPos(), 300 ) ) do

        if ( v:IsPlayer() && !( v:Team() == TEAM_SPEC || v:Team() == TEAM_SCP ) ) then

          v:IgniteSequence( 10 )

        end

      end

      return true
    end

    timer.Simple( 62, function()

      if ( fire && fire:IsValid() ) then

        fire:Remove()

      end

    end )

    ent:SetMaterial( "models/prop_pipes/GutterMetal01a" )
    local effectdata = EffectData()
    effectdata:SetOrigin( ent:GetPos() )

    util.Effect( "HelicopterMegaBomb", effectdata )

    util.BlastDamage( ent, ent.Attacker || ent, ent:GetPos(), 600, 1200 )

    local explo = ents.Create( "env_explosion" )
    explo:SetPos( ent:GetPos() )
    explo:SetKeyValue( "iMagnitude", "300" )
    explo:Spawn()
    explo:Activate()
    explo:Fire( "Explode", "", 0 )

    local shake = ents.Create( "env_shake" )
    shake:SetPos( ent:GetPos() )
    shake:SetKeyValue( "amplitude", "2000" )
    shake:SetKeyValue( "radius", "900" )
    shake:SetKeyValue( "duration", "2.5" )
    shake:SetKeyValue( "frequency", "255" )
    shake:SetKeyValue( "spawnflags", "4" )
    shake:Spawn()
    shake:Activate()
    shake:Fire( "StartShake", "", 0 )

    local ar2Explo = ents.Create( "env_ar2explosion" )
    ar2Explo:SetPos( ent:GetPos() )
    ar2Explo:Spawn()
    ar2Explo:Activate()
    ar2Explo:Fire( "Explode", "", 0 )


  end

  --[[function VD2_Think()

    --if ( SERVER ) then

    if ( #VD2.RegisteredVehicles <= 0 ) then return end

    for _, ent in pairs( VD2.RegisteredVehicles ) do

      if ( !( ent && ent:IsValid() ) ) then

        table.remove(VD2.RegisteredVehicles, _)
        continue

      end

    end

    --end

  end]]

  function VD2_Collide( collider, data )

    if ( collider:GetVelocity():Length() < 120 ) then return end

    local dmgamt = math.floor( data.Speed * 4 )

    if ( dmgamt < 1 ) then

      dmgamt = dmgamt * -1

    end

    if ( collider.nextCollide || 0 ) > CurTime() then return end

    collider.nextCollide = CurTime() + .5

    local dmgtype = DMG_CRUSH

    if ( data.HitEntity:IsNPC() ) then

      dmgtype = DMG_DIRECT
      dmgamt = 2
      collider.nextCollide = CurTime() + 0.1

    end

    --if ( ( dmgamt >= 25 ) || dmgtype == DMG_DIRECT ) then

      --[[if ( dmgamt > collider:Health() ) then

        return

      end]]

      local DamageTable = DamageInfo()

      DamageTable:SetDamage( dmgamt )
      DamageTable:SetDamageType( dmgtype )
      DamageTable:SetInflictor( data.HitEntity )

      data.HitEntity:TakeDamageInfo( DamageTable )

  --  end

  end

  function VD2_Damage(ent, dmg)

    if ( !ent:IsVehicle() ) then return end

	if ent:GetModel() != "models/scpcars/scpp_wrangler_fnf.mdl" then return end

    if ( ent.Exploded ) then return end

    local typedmg = dmg:GetDamageType()

    if ( typedmg == DMG_SLASH ) then return end

    if ( typedmg == DMG_BULLET ) then

      dmg:ScaleDamage( 0.15 )
      ent:EmitSound( "physics/metal/metal_sheet_impact_bullet"..math.random( 1, 2 )..".wav" )

    elseif ( typedmg == DMG_BLAST ) then

      dmg:ScaleDamage( 4800 )

    end

    ent:SetHealth( math.Clamp( ent:Health() - dmg:GetDamage(), 0, ent:GetMaxHealth() ) )

    if ( ent:Health() <= ent:GetMaxHealth() / 2 ) then

      if ( !ent.IsSmoking ) then

        ent.IsSmoking = true
        local Engine = ent:LookupAttachment( "vehicle_engine" )

        ParticleEffectAttach( "smoke_barrel", PATTACH_POINT_FOLLOW, ent, Engine )

      end

    end

    if ( ent:Health() <= 0 && !ent.Exploded ) then

      ent.Attacker = dmg:GetAttacker()
      ent.Exploded = true
      ent:Ignite( 120 )
      ent:EnableEngine( false )

      VD2_Explode( ent )

    end

  end

  function VD2_StartEngine( ply, but )

    if ( but != KEY_B ) then return end

    if ( ply:GetVehicle() == NULL ) then return end
	
	if ply:GetVehicle():GetModel() != "models/scpcars/scpp_wrangler_fnf.mdl" then return end

    if ( IsFirstTimePredicted() && ply:GetVehicle().TurnedOff && ply:HasWeapon( "item_keys" ) ) then

      ply:GetVehicle().TurnedOff = false
      ply:EmitSound( "nextoren/vehicle/car_engine_startredux.wav" )

      timer.Simple( 2.7, function()

        ply:EmitSound( "nextoren/vehicle/car_seatbelt_in.wav" )

      end )

      timer.Simple( 5.7, function()

        ply:EmitSound( "nextoren/vehicle/car_seatbelt_in2.wav" )

      end)

      --sound.Play( "nextoren/car_engine.wav", ply:GetVehicle():GetPos() )

      timer.Simple( 1.4, function() ply:GetVehicle():Fire( "turnon", "", 0 ) ply:EmitSound( "nextoren/vehicle/car_seatbeltalarm.wav" ) end)

    elseif ( IsFirstTimePredicted() && ply:GetVehicle().TurnedOff && !ply:HasWeapon( "item_keys" ) ) then

      ply:setBottomMessage( "У вас нет ключей." )

    end

  end

  function VD2_TurnOffEngineWhenPlayerEnter( player, vehicle, role )

	if vehicle:GetModel() != "models/scpcars/scpp_wrangler_fnf.mdl" then return end

    local class = vehicle:GetVehicleClass() != "" && vehicle:GetVehicleClass() || vehicle:GetClass()


    vehicle:Fire( "turnoff", "", 0 )

    if ( vehicle:GetClass() == "prop_vehicle_jeep" && vehicle:GetDriver() == player ) then

      player:setBottomMessage( "Нажмите клавишу \"B\" для активации двигателя.")

    end

  end
  hook.Add("PlayerEnteredVehicle", "EnteredVehicled", VD2_TurnOffEngineWhenPlayerEnter )
  hook.Add("EntityTakeDamage", "VD2_Damage", VD2_Damage)
  hook.Add("OnEntityCreated", "VD2_Setup", VD2_Setup)
  hook.Add("PlayerButtonDown", "VdStartEngine", VD2_StartEngine )
  hook.Add("CanPlayerEnterVehicle", "VD2_EnterVehicle", VD2_EnterVehicle)
  hook.Add("PlayerLeaveVehicle", "VD2_ExitVehicle", VD2_ExitVehicle)
  hook.Add( "CanExitVehicle", "VD2_CanExitVehicle", VD2_CanExitVehicle )

  hook.Add("CanPlayerEnterVehicle", "VD2_CanEnterVehicle", function(ply, vehicle, role)
    if ply:GetObserverMode() != OBS_MODE_NONE then
      return false
    end
  end)

--end)


if SERVER then
concommand.Add("ggeep", function(ply, cmd, args, argstr)
	if !ply:IsSuperAdmin() then return end

	local jeep_1 = ents.Create("prop_vehicle_jeep")
	jeep_1:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
	jeep_1:SetKeyValue("vehiclescript", "scripts/vehicles/wrangler88.txt")
	jeep_1:SetPos(ply:GetEyeTrace().HitPos)  
	jeep_1:SetAngles(ply:GetAngles())
	jeep_1:Spawn()
end)

concommand.Add("sideniespawn", function(ply, cmd, args, argstr)
	if !ply:IsSuperAdmin() then return end

	local seat = ents.Create( "prop_vehicle_prisoner_pod" )
	seat:SetModel("models/nova/chair_plastic01.mdl")
	seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	seat:SetKeyValue("limitview", "1")
	seat:SetPos(ply:GetEyeTrace().HitPos)
	seat:SetAngles(ply:GetAngles())
	seat:Spawn()
	--seat:SetParent(ent)
	seat:SetMoveType(MOVETYPE_NONE)
	seat:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
end)
end