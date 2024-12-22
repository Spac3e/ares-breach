-- Credits: G-Force (STEAM_0:1:19084184)

if not SERVER then return end

-- GLOBAL VARIABLES
--[[TDMCars                 = TDMCars                   or {}

-- CALLBACK FUNCTIONS
TDMCars.Think           = TDMCars.Think             or {}
TDMCars.EnterEvent      = TDMCars.EnterEvent        or {}
TDMCars.ExitEvent       = TDMCars.ExitEvent         or {}
TDMCars.SpawnEvent      = TDMCars.SpawnEvent        or {}
TDMCars.RemoveEvent     = TDMCars.RemoveEvent       or {}

-- CACHING
TDMCars.VehiclesSpawned = TDMCars.VehiclesSpawned   or {}
TDMCars.ActiveThinks    = TDMCars.ActiveThinks      or {}

-- Adding vehicle to cache list on creation
hook.Add( "OnEntityCreated", "TDMCars_OnEntityCreated", function( ent )
    if ent:GetClass() == "prop_vehicle_jeep" then
        timer.Simple( 0, function()
            TDMCars.VehiclesSpawned[ ent ] = true

            local mdl = ent:GetModel():lower()
            local callback = TDMCars.SpawnEvent[ mdl ]

            if callback then
                TDMCars.SpawnEvent[ mdl ]( ent )
            end
        end )
    end
end )

-- Removing vehicle from cache list on removal
hook.Add( "EntityRemoved", "TDMCars_EntityRemoved", function( ent )
    if ent:GetClass() == "prop_vehicle_jeep" then
        local mdl = ent:GetModel():lower()
        TDMCars.VehiclesSpawned[ ent ] = nil

        local callback = TDMCars.RemoveEvent[ mdl ]
        if callback then
            TDMCars.RemoveEvent[ mdl ]( ent )
        end
    end
end )

-- Adding vehicle to think list on entry
hook.Add( "PlayerEnteredVehicle", "TDMCars_PlayerEnteredVehicle", function( ply, ent )
    if ent:GetClass() == "prop_vehicle_jeep" then
        local mdl = ent:GetModel():lower()

        local think = TDMCars.Think[ mdl ]
        if think then
            local steamid = ply:SteamID()
            hook.Add( "Think", "TDMCars_Player" .. steamid, function()
                if IsValid( ply ) and IsValid( ent ) then
                    think( ply, ent )
                else
                    hook.Remove( "Think", "TDMCars_Player" .. steamid )
                end
            end )

            TDMCars.ActiveThinks[ ply ] = ent
        end

        local callback = TDMCars.EnterEvent[ mdl ]
        if callback then
            TDMCars.EnterEvent[ mdl ]( ply, ent )
        end
    end
end )

-- Removing vehicle from think list on entry
hook.Add( "PlayerLeaveVehicle", "TDMCars_PlayerLeaveVehicle", function( ply, ent )
    if ent:GetClass() == "prop_vehicle_jeep" then
        local mdl = ent:GetModel():lower()

        if TDMCars.ActiveThinks[ ply ] then
            hook.Remove( "Think", "TDMCars_Player" .. ply:SteamID() )
            TDMCars.ActiveThinks[ ply ] = nil
        end

        local callback = TDMCars.ExitEvent[ mdl ]
        if callback then
            TDMCars.ExitEvent[ mdl ]( ply, ent )
        end
    end
end )]]
