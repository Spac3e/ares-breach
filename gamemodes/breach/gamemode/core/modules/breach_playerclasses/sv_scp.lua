SCPObjects = {}
SCPNoSelectObjects = {}
TransmitSCPS = {}

SCP_VALID_ENTRIES = {
	base_speed = true,
	run_speed = true,
	max_speed = true,
	base_health = true,
	max_health = true,
	jump_power = true,
	crouch_speed = true,
	no_ragdoll = true,
	model_scale = true,
	hands_model = true,
	prep_freeze = true,
	no_spawn = true,
	no_model = true,
	no_swep = true,
	no_strip = true,
	no_select = true,
	no_draw = true,
}

SCP_DYNAMIC_VARS = {}

local lua_override = false

util.AddNetworkString("SelectSCPClientside")
util.AddNetworkString("SCPSelect_Menu")

net.Receive("SelectSCPClientside", function(len,ply)
	local scp = net.ReadString()
	local scp_obj = GetSCP( scp )
	if scp_obj then
		ply:SetupNormal()
		scp_obj:SetupPlayer( ply )
		ply:SendLua("if ( IsValid( BREACH.Demote.MainPanel ) ) then BREACH.Demote.MainPanel:Remove() end")
	end
end)

function SendSCPList( ply )
	net.Start( "SCPList" )
		net.WriteTable( SCPS )	
		net.WriteTable( TransmitSCPS )
	net.Send( ply )
end

function GetSCP( name )
	return SCPObjects[name] or SCPNoSelectObjects[name]
end

function RegisterSCP( name, model, weapon, static_stats, dynamic_stats, custom_callback, post_callback )
	--RegisterSCP( "name", "path_to_model", "SWEP_class_name", {entry = value} )
	if !name or !model or !weapon or !static_stats then return end

	dynamic_stats = dynamic_stats or {}

	if SCPObjects[name] then
		error( "SCP " .. name .. "is already registered!" )
	end

	local rolename = name

	local spawn = _G["SPAWN_"..name] || SPAWN_SCP_RANDOM
	if !static_stats.no_spawn and !dynamic_stats.no_spawn then
		if !spawn or ( !isvector( spawn ) and !istable( spawn ) ) then
			error( "No spawn position entry for: ".."SPAWN_"..name )
		end
	end

	local scp = ObjectSCP( name, model, weapon, spawn, static_stats, dynamic_stats )

	if custom_callback and isfunction( custom_callback ) then
		scp:SetCallback( custom_callback )
	end

	if post_callback and isfunction( post_callback ) then
		scp:SetCallback( post_callback, true )
	end

	if !scp.basestats.no_select then
		SCPObjects[name] = scp
		table.insert( SCPS, name )
	else
		SCPNoSelectObjects[name] = scp
		table.insert( TransmitSCPS, name )
	end
	return true
end


-----SCP class-----
ObjectSCP = {}
ObjectSCP.__index = ObjectSCP

/*ObjectSCP.name = ""
ObjectSCP.basestats = {}
ObjectSCP.callback = function() end
ObjectSCP.post = function() end
ObjectSCP.swep = ""
ObjectSCP.model = ""
ObjectSCP.spawnpos = nil*/

function ObjectSCP:Create( name, model, weapon, pos, static_stats, dynamic_stats )
	local scp = setmetatable( {}, ObjectSCP )
	scp.Create = function() end

	scp.name = name
	scp.model = model
	scp.swep = weapon
	scp.spawnpos = pos
	scp.basestats = {}

	scp.callback = function() end
	scp.post = function() end

	if !SCP_DYNAMIC_VARS[name] then
		SCP_DYNAMIC_VARS[name] = {}
	end

	local dv = SCP_DYNAMIC_VARS[name]

	for k, v in pairs( dynamic_stats ) do
		if SCP_VALID_ENTRIES[k] then
			local istab = istable( v )
			local var = istab and v.var or v

			if dv[k] then
				var = dv[k]
			else
				dv[k] = var
			end

			if istab then
				if v.min or v.max then
					if !isnumber( var ) then
						ErrorNoHalt( name.." entry: "..k..". Number expected, got "..type( var ) )
						continue
					end

					if v.min then
						var = math.max( v.min, var )
					end

					if v.max then
						var = math.min( v.max, var )
					end
				end
			end

			scp.basestats[k] = var
		else
			print( "Invalid dynamic stat entry '"..k.."' for "..name )
		end
	end

	for k, v in pairs( static_stats ) do
		if SCP_VALID_ENTRIES[k] then
			scp.basestats[k] = v
		else
			print( "Invalid static stat entry '"..k.."' for "..name )
		end
	end

	return scp
end

function ObjectSCP:SetCallback( cb, post )
	if post then
		self.post = cb
	else
		self.callback = cb
	end
end

function ObjectSCP:SetupPlayer( ply, ... )	
	if self.callback then
		if self.callback( ply, self.basestats, ... ) then
			return
		end
	end

	ply:SetupNormal()
	ply:UnSpectate()
	ply:GodDisable()

	if !self.basestats.no_strip then
		ply:StripWeapons()
		ply:RemoveAllAmmo()
	end

	local pos = self.spawnpos
	
	if pos and !self.basestats.no_spawn then
		if istable( pos ) then
			pos = table.Random( pos )
		end
		ply:Spawn()
		ply:SetPos( pos )
	end

	ply:SetGTeam( TEAM_SCP )
	ply:SetRoleName( self.name )

	if !self.basestats.no_model then
		ply:SetModel( self.model )
	end

	ply:SetModelScale( self.basestats.model_scale or 1 )

	ply:SetHealth( self.basestats.base_health or 1500 )
	ply:SetMaxHealth( self.basestats.max_health or 1500 )
	ply:SetWalkSpeed( self.basestats.base_speed or 200 ) -- по идее должна быть в районе 100
	ply:SetSlowWalkSpeed( self.basestats.base_speed - 40 or 80)
	ply:SetRunSpeed( self.basestats.run_speed or 200 )
	ply:SetMaxSpeed( self.basestats.max_speed or 200 )
	ply:SetCrouchedWalkSpeed( self.basestats.crouch_speed or 0.6 )
	ply:SetJumpPower( self.basestats.jump_power or 200 )
	ply:SetLadderClimbSpeed(140)

	local wep = ply:Give( self.swep )
	timer.Simple(0.1, function() ply:SelectWeapon(self.swep) end)
	if IsValid( wep ) then
		wep.ShouldFreezePlayer = self.basestats.prep_freeze == true
	end

	ply:SetArmor( 0 )

	ply:Flashlight( false )
	ply:AllowFlashlight( false )
	ply:SetNoDraw( self.basestats.no_draw == true )
	ply:SetNoTarget( true )

	if ply:IsPremium() and ply.alreadyselectedscp != true then net.Start("SCPSelect_Menu") net.WriteTable(SCPS) net.Send(ply) end
    if ply:GetRoleName() == "SCP062DE" and !ply:IsPremium() then ply:bSendLua("SCP062de_Menu()") end
	if ply:GetRoleName() == "SCP076" then ply.DamageModifier = 0.7 end

	ply.BaseStats = nil
	ply.UsingArmor = nil
	ply.alreadyselectedscp = true

	ply.Active = true
	ply.canblink = false
	ply.noragdoll = self.basestats.no_ragdoll == true

	ply.handsmodel = self.basestats.hands_model
	ply:SetupHands()

	net.Start( "RolesSelected" )
	net.Send( ply )

	if self.post then
		self.post( ply )
	end
end

setmetatable( ObjectSCP, { __call = ObjectSCP.Create } )
--------------------------------------------------------------------------------

timer.Simple(0, function()
	RegisterSCPList()
	SetupForceSCP()
	for k, v in player.Iterator() do
		SendSCPList( v )
	end
	if not (scpsready or nil) then
		BREACH.Msg("SCPs has been successfully registered!\n", CLR_MSG_GREEN)
	end
	scpsready = true
end)

function RegisterSCPList()
	RegisterSCP( "SCP049", "models/cultist/scp/scp_049.mdl", "weapon_scp_049_redux", {
		jump_power = 0,
	}, {
		base_health = 2200,
		max_health = 2200,
		base_speed = 135,
		run_speed = 135,
		max_speed = 135,
	} )

	RegisterSCP( "SCP076", "models/cultist/scp/scp_076.mdl", "weapon_scp_076", {
		jump_power = 0,
	}, {
		base_health = 1100,
		max_health = 1100,
		base_speed = 220,
		run_speed = 220,
		max_speed = 220,
	}, nil, function( ply )
	end )

	RegisterSCP( "SCP082", "models/cultist/scp/scp_082.mdl", "weapon_scp_082", {
		jump_power = 0,
	}, {
		base_health = 2400,
		max_health = 2400,
		base_speed = 160,
		run_speed = 160,
		max_speed = 160,
	}, nil, function( ply )
	end )

	RegisterSCP( "SCP1903", "models/cultist/scp/scp_1903.mdl", "weapon_scp_1903", {
		jump_power = 0,
	}, {
		base_health = 2400,
		max_health = 2400,
		base_speed = 135,
		run_speed = 135,
		max_speed = 135,
	}, nil, function( ply )
	end )

	RegisterSCP( "SCP096", "models/cultist/scp/scp_096.mdl", "weapon_scp096", {
		jump_power = 0,
	}, {
		base_health = 1450,
		max_health = 1450,
		base_speed = 120,
		run_speed = 500,
		max_speed = 500,
	} )

	RegisterSCP( "SCP106", "models/cultist/scp/scp_106.mdl", "weapon_scp_106", {
		jump_power = 0,
	}, {
		base_health = 1600,
		max_health = 1600,
		base_speed = 170,
		run_speed = 170,
		max_speed = 170,
	} )
	RegisterSCP( "SCP062DE", "models/cultist/scp/scp_062de.mdl", "", {
		jump_power = 0,
	}, {
		base_health = 3200,
		max_health = 3200,
		base_speed = 135,
		run_speed = 115,
		max_speed = 115,
	} )
	RegisterSCP( "SCP457", "models/cultist/scp/scp_457.mdl", "weapon_scp_457", {
		jump_power = 0,
		//no_draw = true,
	}, {
		base_health = 2300,
		max_health = 2300,
		base_speed = 135,
		run_speed = 125,
		max_speed = 125,
	} )

	RegisterSCP( "SCP682", "models/cultist/scp/scp_682.mdl", "weapon_scp_682", {
		jump_power = 0,
		no_ragdoll = true,
	}, {
		base_health = 6800,
		max_health = 6800,
		base_speed = 125,
		run_speed = 125,
		max_speed = 125,
	} )

	RegisterSCP( "SCP811", "models/cultist/scp/scp_811.mdl", "weapon_scp_811", {
		jump_power = 0,
	}, {
		base_health = 3200,
		max_health = 3200,
		base_speed = 120,
		run_speed = 120,
		max_speed = 120,
	} )

	RegisterSCP( "SCP939", "models/cultist/scp/scp_939.mdl", "weapon_scp_939", {
		jump_power = 0,
	}, {
		base_health = 3200,
		max_health = 3200,
		base_speed = 130,
		run_speed = 130,
		max_speed = 130,
	} )
	/*
	RegisterSCP( "SCP062FR", "models/cultist/scp/scp_062fr.mdl", "weapon_scp_062", {
		jump_power = 0,
	}, {
		base_health = 2600,
		max_health = 2600,
		base_speed = 190,
		run_speed = 190,
		max_speed = 190,
	} )
	*/
	RegisterSCP( "SCP999", "models/cultist/scp/scp_999_new.mdl", "weapon_scp_999", {
		jump_power = 0,
	}, {
		base_health = 1000,
		max_health = 1000,
		base_speed = 150,
		run_speed = 150,
		max_speed = 150,
	} )

	RegisterSCP( "SCP542", "models/cultist/scp/scp_542.mdl", "weapon_scp_542", {
		jump_power = 0,
	}, {
		base_health = 2100,
		max_health = 2100,
		base_speed = 125,
		run_speed = 125,
		max_speed = 125,
	} )

	RegisterSCP( "SCP2012", "models/shaky/scp/scp2012/scp_2012.mdl", "weapon_scp_2012", {
		jump_power = 0,
	}, {
		base_health = 2300,
		max_health = 2300,
		base_speed = 130,
		run_speed = 130,
		max_speed = 130,
	} )
	RegisterSCP( "SCP638", "models/cultist/scp/scp638/scp_638.mdl", "weapon_scp_638", {
		jump_power = 0,
	}, {
		base_health = 2300,
		max_health = 2300,
		base_speed = 130,
		run_speed = 130,
		max_speed = 130,
	} )
	/*
	RegisterSCP( "SCP912", "models/cultist/scp/scp_912.mdl", "weapon_scp_912", {
		jump_power = 0,
	}, {
		base_health = 1000,
		max_health = 1000,
		base_speed = 165,
		run_speed = 165,
		max_speed = 165,
	} )*/
	RegisterSCP( "SCP973", "models/cultist/scp/scp_973/scp_973.mdl", "weapon_scp_973", {
		jump_power = 0,
	}, {
		base_health = 2700,
		max_health = 2700,
		base_speed = 130,
		run_speed = 130,
		max_speed = 130,
	} )
	--[[RegisterSCP( "SCP8602", "models/cultist/scp/scp_860.mdl", "weapon_scp_860", {
		jump_power = 0,
	}, {
		base_health = 2700,
		max_health = 2700,
		base_speed = 160,
		run_speed = 325,
		max_speed = 160,
	} )--]]
end

SPAWN_SCP049 = Vector(7507, -371, 64)
SPAWN_SCP106 = Vector(7079, 3857, -383)
SPAWN_SCP682 = Vector(1919, 3017, -319)