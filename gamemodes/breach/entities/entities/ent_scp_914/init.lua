AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.PrecacheSound( "nextoren/scp/914/refining.ogg" )

function ENT:Initialize()
	for k,ball in pairs(ents.FindInSphere(Vector(9496, -4767, 61), 16)) do
        if IsValid(ball) then
            if ball:GetModel() != "models/next_breach/gas_monitor.mdl" then
			
				ball:Remove()

			end
        end
    end
	scp_914_r_status = "Very Fine"
	util.AddNetworkString( "914_OPEN_MENU" )
	util.AddNetworkString( "914_edit_status" )
	util.AddNetworkString( "914_status" )
	util.AddNetworkString( "914_run" )
	self:SetModel( "models/next_breach/gas_monitor.mdl" )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetPos(Vector(9497, -4767, 61))
	self:SetAngles(Angle(0,90,0))
	self:SetModelScale( self:GetModelScale() * 1.25, 0 )
	delay_open_914 = 0
	delay_status_914 = 0
	scp_914_spawn_item = "breach_keycard_1"
	scp_914_result_key = "breach_keycard_1"
end

scp_914_items = {
	["breach_keycard_1"] = {
		["Rough"] = {},
		["Coarse"] = {"breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_security_1", "breach_keycard_sci_1"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3"},
	},
	["breach_keycard_2"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5"},
	},
	["breach_keycard_3"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6"},
	},
	["breach_keycard_4"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6"},
	},
	["breach_keycard_security_1"] = {
		["Rough"] = {},
		["Coarse"] = {"breach_keycard_security_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_security_1", "breach_keycard_sci_1"},
		["Fine"] = {"breach_keycard_security_2", "breach_keycard_security_1"},
		["Very Fine"] = {"breach_keycard_security_1", "breach_keycard_security_2", "breach_keycard_security_3"},
	},
	["breach_keycard_security_2"] = {
		["Rough"] = {"breach_keycard_security_1"},
		["Coarse"] = {"breach_keycard_security_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2"},
		["Fine"] = {"breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_1"},
		["Very Fine"] = {"breach_keycard_security_1", "breach_keycard_security_2", "breach_keycard_security_3"},
	},
	["breach_keycard_security_3"] = {
		["Rough"] = {"breach_keycard_security_1"},
		["Coarse"] = {"breach_keycard_security_2", "breach_keycard_security_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3"},
		["Fine"] = {"breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_4", "breach_keycard_security_1"},
		["Very Fine"] = {"breach_keycard_security_1", "breach_keycard_security_2", "breach_keycard_guard_2", "breach_keycard_security_3", "breach_keycard_security_4"},
	},
	["breach_keycard_security_4"] = {
		["Rough"] = {"breach_keycard_security_1"},
		["Coarse"] = {"breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_4", "breach_keycard_guard_4", "breach_keycard_guard_3"},
		["Very Fine"] = {"breach_keycard_security_1", "breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_4", "breach_keycard_6", "breach_keycard_7"},
	},
	["breach_keycard_5"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6"},
	},
	["breach_keycard_6"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6", "breach_keycard_crack", "breach_keycard_7"},
	},
	["breach_keycard_7"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6", "breach_keycard_crack"},
	},


	["breach_keycard_guard_1"] = {
		["Rough"] = {},
		["Coarse"] = {"breach_keycard_1", "breach_keycard_guard_1", "breach_keycard_security_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_guard_1", "breach_keycard_security_1", "breach_keycard_sci_1"},
		["Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_1"},
		["Very Fine"] = {"breach_keycard_guard_1", "breach_keycard_1", "breach_keycard_guard_2", "breach_keycard_guard_3"},
	},
	["breach_keycard_guard_2"] = {
		["Rough"] = {"breach_keycard_guard_1"},
		["Coarse"] = {"breach_keycard_guard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_guard_1", "breach_keycard_guard_2"},
		["Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_1"},
		["Very Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_4", "breach_keycard_5"},
	},
	["breach_keycard_guard_3"] = {
		["Rough"] = {"breach_keycard_guard_1"},
		["Coarse"] = {"breach_keycard_guard_2", "breach_keycard_guard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_guard_1", "breach_keycard_guard_2", "breach_keycard_guard_3"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_4"},
	},
	["breach_keycard_guard_4"] = {
		["Rough"] = {"breach_keycard_guard_1"},
		["Coarse"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4", "breach_keycard_guard_1", "breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_4", "breach_keycard_6", "breach_keycard_crack"},
	},

	["breach_keycard_crack"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6", "breach_keycard_7"},
	},


	["breach_keycard_sci_1"] = {
		["Rough"] = {},
		["Coarse"] = {"breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_security_1", "breach_keycard_sci_1"},
		["Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_1"},
		["Very Fine"] = {"breach_keycard_sci_1", "breach_keycard_sci_2", "breach_keycard_sci_3"},
	},
	["breach_keycard_sci_2"] = {
		["Rough"] = {"breach_keycard_1", "breach_keycard_sci_1"},
		["Coarse"] = {"breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2"},
		["Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_1"},
		["Very Fine"] = {"breach_keycard_sci_1", "breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4"},
	},
	["breach_keycard_sci_3"] = {
		["Rough"] = {"breach_keycard_sci_1"},
		["Coarse"] = {"breach_keycard_sci_2", "breach_keycard_sci_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3"},
		["Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4", "breach_keycard_sci_1"},
		["Very Fine"] = {"breach_keycard_sci_1", "breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4", "breach_keycard_4"},
	},
	["breach_keycard_sci_4"] = {
		["Rough"] = {"breach_keycard_sci_1"},
		["Coarse"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4", "breach_keycard_5"},
		["Very Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4", "breach_keycard_5", "breach_keycard_crack"},
	},


	["item_medkit_1"] = {
		["Rough"] = {},
		["Coarse"] = {"item_medkit_1"},
		["1:1"] = {"item_medkit_1", "item_medkit_3"},
		["Fine"] = {"item_medkit_1", "item_medkit_2"},
		["Very Fine"] = {"item_medkit_1", "item_medkit_2", "item_medkit_3", "item_medkit_4"},
	},

	["item_medkit_2"] = {
		["Rough"] = {},
		["Coarse"] = {"item_medkit_1"},
		["1:1"] = {"item_medkit_2", "item_medkit_4"},
		["Fine"] = {"item_medkit_2", "item_medkit_3"},
		["Very Fine"] = {"item_medkit_1", "item_medkit_2", "item_medkit_3", "item_medkit_4"},
	},

	["item_medkit_3"] = {
		["Rough"] = {},
		["Coarse"] = {"item_medkit_1"},
		["1:1"] = {"item_medkit_3", "item_medkit_1"},
		["Fine"] = {"item_medkit_3", "item_medkit_4"},
		["Very Fine"] = {"item_medkit_1", "item_medkit_2", "item_medkit_3", "item_medkit_4"},
	},

	["item_medkit_4"] = {
		["Rough"] = {},
		["Coarse"] = {"item_medkit_1"},
		["1:1"] = {"item_medkit_4", "item_medkit_2"},
		["Fine"] = {"item_medkit_3", "item_medkit_4"},
		["Very Fine"] = {"item_medkit_1", "item_medkit_2", "item_medkit_3", "item_medkit_4"},
	},


	["copper_coin"] = {
		["Rough"] = {},
		["Coarse"] = {"copper_coin"},
		["1:1"] = {"copper_coin"},
		["Fine"] = {"copper_coin", "silver_coin"},
		["Very Fine"] = {"gold_coin", "copper_coin", "silver_coin"},
	},

	["silver_coin"] = {
		["Rough"] = {"copper_coin"},
		["Coarse"] = {"silver_coin", "copper_coin"},
		["1:1"] = {"copper_coin"},
		["Fine"] = {"copper_coin", "silver_coin", "gold_coin"},
		["Very Fine"] = {"gold_coin", "copper_coin", "silver_coin"},
	},

	["gold_coin"] = {
		["Rough"] = {"copper_coin"},
		["Coarse"] = {"silver_coin", "copper_coin"},
		["1:1"] = {"gold_coin"},
		["Fine"] = {"gold_coin"},
		["Very Fine"] = {"copper_coin"},
	},

	["item_adrenaline"] = {
		["Rough"] = {},
		["Coarse"] = {},
		["1:1"] = {"item_adrenaline"},
		["Fine"] = {"item_adrenaline", "item_syringe"},
		["Very Fine"] = {"item_adrenaline", "item_syringe"},
	},
}

function ENT:Use( activator, caller )
	if CurTime() < delay_open_914 then return end
	local ply = activator
    net.Start( "914_OPEN_MENU" )
    net.WriteEntity(ply)
    net.Send(ply)
	delay_open_914 = CurTime() + 5
end
 
net.Receive( "914_edit_status", function()
    scp_914_r_status = net.ReadString()
end)

net.Receive( "914_run", function()
	visual_work()
end)

function fackt_work()
    local entsinbox = ents.FindInBox(Vector(9553, -4481, 4), Vector(9614, -4606, 125))
    for k, v in ipairs(entsinbox) do
        if v:IsPlayer() and v:Team() != TEAM_SPEC and v:GetMoveType() != MOVETYPE_NOCLIP then
			v:AddToStatistics("l:scp914_death", 50)
            v:LevelBar()
			v:SetupNormal()
			v:SetSpectator()
            local spawn_item1 = ents.Create("item_hamburger")
            spawn_item1:SetPos(Vector(9585, -4979, 66))
            spawn_item1:Spawn()
        else
            if v:GetClass() != "func_door" and v:GetClass() != "prop_dynamic" then
                if scp_914_items[v:GetClass()] == nil then
                    continue
                end
                if table.Count(scp_914_items[v:GetClass()][scp_914_r_status]) > 1 then
                    local spawn_item = ents.Create(table.Random(scp_914_items[v:GetClass()][scp_914_r_status]))
                    spawn_item:SetPos(Vector(9585, -4979, 66))
                    spawn_item:Spawn()
                else
                    if not table.IsEmpty(scp_914_items[v:GetClass()][scp_914_r_status]) then
                        local spawn_item = ents.Create(scp_914_items[v:GetClass()][scp_914_r_status])
                        spawn_item:SetPos(Vector(9585, -4979, 66))
                        spawn_item:Spawn()
                    end
                end
                v:Remove()
            end
        end
    end
end

function visual_work()
	sound.Play( "nextoren/scp/914/refining.ogg", Vector(9566, -4769, 88) )

    timer.Simple(2, function()
        for k, ball in pairs(ents.FindInSphere(Vector(9544, -4556, 66), 50)) do
            if IsValid(ball) and ball:GetClass() == "func_door" then
                ball:Fire("Close")
            end
        end

        for k, ball in pairs(ents.FindInSphere(Vector(9543, -5004, 66), 50)) do
            if IsValid(ball) and ball:GetClass() == "func_door" then
                ball:Fire("Close")
            end
        end
    end)

    timer.Simple(14, function()
        for k, ball in pairs(ents.FindInSphere(Vector(9544, -4556, 66), 15)) do
            if IsValid(ball) and ball:GetClass() == "func_door" then
                ball:Fire("Open")
            end
        end

        for k, ball in pairs(ents.FindInSphere(Vector(9543, -5004, 66), 15)) do
            if IsValid(ball) and ball:GetClass() == "func_door" then
                ball:Fire("Open")
            end
        end

        fackt_work()
    end)
end


function visual_work()
	sound.Play( "nextoren/scp/914/refining.ogg", Vector(9566, -4769, 88) )

    timer.Simple(2, function()
        for k, ball in pairs(ents.FindInSphere(Vector(9544, -4556, 66), 50)) do
            if IsValid(ball) and ball:GetClass() == "func_door" then
                ball:Fire("Close")
            end
        end

        for k, ball in pairs(ents.FindInSphere(Vector(9543, -5004, 66), 50)) do
            if IsValid(ball) and ball:GetClass() == "func_door" then
                ball:Fire("Close")
            end
        end
    end)

    timer.Simple(14, function()
        for k, ball in pairs(ents.FindInSphere(Vector(9544, -4556, 66), 15)) do
            if IsValid(ball) and ball:GetClass() == "func_door" then
                ball:Fire("Open")
            end
        end

        for k, ball in pairs(ents.FindInSphere(Vector(9543, -5004, 66), 15)) do
            if IsValid(ball) and ball:GetClass() == "func_door" then
                ball:Fire("Open")
            end
        end

        fackt_work()
    end)
end

function ENT:Think()
end