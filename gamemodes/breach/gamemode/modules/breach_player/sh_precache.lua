
BREACH.ResourcesPrecached = BREACH.ResourcesPrecached or false

function PrecacheDir( dir )

  local files, directories = file.Find( dir .. "*", "GAME" )

  if files == nil and directories == nil then return end

  if directories != nil then
    for _, fdir in pairs( directories ) do

      if ( fdir != ".svn" ) then

        PrecacheDir( dir .. fdir .. "/" )

      end

    end
  end

  for _, v in ipairs( files ) do

    local fname = string.lower( dir .. v )
    local tmpmat;
    local ismodel = -1
    local ismaterial = -1
    local isparticle = -1
    local issound = -1
    ismodel = (string.find(fname,".mdl"))
    ismaterial = (string.find(fname,".vtf") or string.find(fname,".vmt"))
    isparticle = (string.find(fname,".pcf"))
    issound = (string.find(fname,".wav") or string.find(fname,".mp3") or string.find(fname,".ogg") )

    if ( ismaterial ) then

      if ( ismaterial >= 0 ) then

        tmpmat = Material( fname, "mips" )

      end

    elseif ( isparticle ) then

      if ( isparticle >= 0 ) then

        PrecacheParticleSystem( fname )

      end

    elseif ( issound ) then

      if ( issound >= 0 ) then

        util.PrecacheSound( fname )

      end

    elseif ( ismodel ) then

      if ( ismodel >= 0 ) then

        util.PrecacheModel( fname )

      end

    end

  end

end

function FullyPrecacheDir( dir )

  local files, directories = file.Find( dir .. "*", "GAME" )

  if files == nil and directories == nil then return end

  if directories != nil then
    for _, fdir in pairs( directories ) do

      if ( fdir != ".svn" ) then

        FullyPrecacheDir( dir .. fdir .. "/" )

      end

    end
  end

  for _, v in ipairs( files ) do

    local fname = string.lower( dir .. v )
    local tmpmat;
    local ismodel = -1
    local ismaterial = -1
    local isparticle = -1
    local issound = -1
    ismodel = (string.find(fname,".mdl"))
    ismaterial = (string.find(fname,".vtf") or string.find(fname,".vmt"))
    isparticle = (string.find(fname,".pcf"))
    issound = (string.find(fname,".wav") or string.find(fname,".mp3") or string.find(fname,".ogg") )

    if ( ismaterial ) then

      if ( ismaterial >= 0 ) then

        tmpmat = Material( fname, "mips" )

      end

    elseif ( isparticle ) then

      if ( isparticle >= 0 ) then

        PrecacheParticleSystem( fname )

      end

    elseif ( issound ) then

      if ( issound >= 0 ) then

        util.PrecacheSound( fname )

      end

    elseif ( ismodel ) then

      if ( ismodel >= 0 ) then

        util.PrecacheModel( fname )
		
		if CLIENT then
			local precachemodel = ClientsideModel(fname)
			if precachemodel then
				precachemodel:SetPos(LocalPlayer():GetPos())
				precachemodel:Spawn()
				precachemodel:Remove()
			end
		end

      end

    end

  end

end

function PrecachePlayerSounds( ply )
  if BREACH.ResourcesPrecached then return end
  BREACH.ResourcesPrecached = true

  local StartTime = SysTime()

  PrecacheDir( "models/cultist/" )
  PrecacheDir( "models/weapons/" )
  PrecacheDir( "sound/nextoren/" )
  PrecacheDir( "models/gmod4phun/" )
  PrecacheDir( "sound/no_music/" )
  PrecacheDir( "sound/player/")
  PrecacheDir( "sound/cw/")
  PrecacheDir( "sound/common/")
  PrecacheDir( "sound/physics/")
  PrecacheDir( "models/props_gffice/" )
  PrecacheDir( "models/cultist_props/" )
  PrecacheDir( "models/cult_props/" )
  PrecacheDir( "models/noundation/" )
  PrecacheDir( "models/props_beneric/" )
  PrecacheDir( "models/props_canteen/" )
  PrecacheDir( "models/props_glackmesa/" )
  PrecacheDir( "models/props_gm/" )
  PrecacheDir( "models/props_guestionableethics/" )
  PrecacheDir( "models/next_breach/" )
  PrecacheDir( "models/models/" )
  PrecacheDir( "sound/weapons/")
  PrecacheDir( "sound/bullet/" )
  PrecacheDir( "models/scp_helicopter/" )
  PrecacheDir( "models/scp_chaos_jeep/" )

  if ( CLIENT ) then

    PrecacheDir( "sound/ttt_foundation/" )
    PrecacheDir( "materials/models/cultist/" )
    PrecacheDir( "materials/models/all_scp_models/" )
    PrecacheDir( "materials/nextoren/" )
    PrecacheDir( "materials/nextoren_hud/" )

  end

  print( "End time: ", SysTime() - StartTime )

  --[[

  local StartTime = SysTime()
  PrecacheDir( "models/breach/" )
  PrecacheDir( "models/breach_anims/" )
  PrecacheDir( "models/breach_animations/" )
  PrecacheDir( "models/bumans/" )
  print("Fully precaching breach models...")
  FullyPrecacheDir( "models/cultist/" )
  print("Fully precaching breach models time: ", SysTime() - StartTime )
  print("Fully precaching CW 2.0 attachments...")
  FullyPrecacheDir("models/weapons/upgrades/")
  print("Fully precaching CW 2.0 attachments time: ", SysTime() - StartTime )
  PrecacheDir( "models/weapons/" )
  PrecacheDir( "sound/nextoren/" )
  PrecacheDir( "models/gmod4phun/" )
  PrecacheDir( "sound/no_music/" )
  PrecacheDir( "sound/player/")
  PrecacheDir( "sound/cw/")
  PrecacheDir( "sound/common/")
  PrecacheDir( "sound/physics/")
  PrecacheDir( "models/props_gffice/" )
  PrecacheDir( "models/cultist_props/" )
  PrecacheDir( "models/cult_props/" )
  PrecacheDir( "models/noundation/" )
  PrecacheDir( "models/props_beneric/" )
  PrecacheDir( "models/props_canteen/" )
  PrecacheDir( "models/props_glackmesa/" )
  PrecacheDir( "models/props_gm/" )
  PrecacheDir( "models/props_guestionableethics/" )
  PrecacheDir( "models/next_breach/" )
  PrecacheDir( "models/models/" )
  PrecacheDir( "sound/weapons/")
  PrecacheDir( "sound/bullet/" )
  PrecacheDir( "models/scp_helicopter/" )
  PrecacheDir( "models/scp_chaos_jeep/" )
  PrecacheDir( "models/props_gab/" )
  PrecacheDir( "models/props_blastpit/" )
  PrecacheDir( "models/oar/" )
  PrecacheDir( "models/props_industrial/" )
  PrecacheDir( "models/props_stalkyard/" )
  PrecacheDir( "models/props_inbound/" )
  PrecacheDir( "models/props_garines/" )
  PrecacheDir( "models/props_equipment/" )
  PrecacheDir( "models/props_rooftop/" )
  PrecacheDir( "models/foundation/" )

  util.PrecacheModel( "models/comradealex/mgs5/hp-48/hp-48test.mdl" )

  if ( CLIENT ) then

    PrecacheDir( "sound/ttt_foundation/" )
    PrecacheDir( "materials/models/cultist/" )
    PrecacheDir( "materials/models/all_scp_models/" )
    PrecacheDir( "materials/nextoren/" )
    PrecacheDir( "materials/nextoren_hud/" )

    print( "Content precaching time: ", SysTime() - StartTime )

	print("Fully precaching CW20 weapons...")
	for k, v in ipairs(weapons.GetList()) do
		if string.StartWith(v["ClassName"], "cw_") then
			if v["WorldModel"] then
				local wmodel = ClientsideModel(v["WorldModel"])
				if wmodel then
					wmodel:SetPos(LocalPlayer():GetPos())
					wmodel:Spawn()
					wmodel:Remove()
				end
			end

			if v["ViewModel"] then
				local vmodel = ClientsideModel(v["ViewModel"])
				if vmodel then
					vmodel:SetPos(LocalPlayer():GetPos())
					vmodel:Spawn()
					vmodel:Remove()
				end
			end
		end
	end

  end

  print( "End time: ", SysTime() - StartTime )

  --]]

end

if SERVER then
  hook.Add("InitPostEntity", "Breach:PrecacheResources", function()
    PrecachePlayerSounds()
  end)
end