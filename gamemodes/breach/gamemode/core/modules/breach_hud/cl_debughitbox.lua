local hitboxCurrentlyRendering = false
local renderAll = false
local renderRagDolls = false
local renderLocalPlayer = false
local zeroAngle = Angle(0, 0, 0)

local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player
local render = render

local function HitboxRender()

    for _, ent in pairs(ents.GetAll()) do

        --if ply == LocalPlayer() then continue end

        if not renderAll then

            if not ent:IsPlayer() and not ent:IsRagdoll() and not ent:IsNPC() then continue end

            if not renderLocalPlayer and ent == LocalPlayer() then continue end

            if not renderRagDolls and ent:IsRagdoll() then continue end

        end

        if ent:GetHitBoxGroupCount() == nil then continue end

        for group=0, ent:GetHitBoxGroupCount() - 1 do
            
             for hitbox=0, ent:GetHitBoxCount( group ) - 1 do

                 local pos, ang =  ent:GetBonePosition( ent:GetHitBoxBone(hitbox, group) )
                 local mins, maxs = ent:GetHitBoxBounds(hitbox, group)

                render.DrawWireframeBox( pos, ang, mins, maxs, Color(51, 204, 255, 255), true )
            end
        end

        render.DrawWireframeBox( ent:GetPos(), zeroAngle, ent:OBBMins(), ent:OBBMaxs(), Color(255, 204, 51, 255), true )

    end
end 

concommand.Add( "debug_hitbox", function( ply, cmd, args, str)

    if !ply:IsSuperAdmin() then
        ply:RXSENDWarning("I would like to debug your non-existent superadmin rights.")
        return
    end

    if hitboxCurrentlyRendering then
        hook.Remove("PostDrawOpaqueRenderables", "HitboxRender")
        hitboxCurrentlyRendering = false
    else
        hook.Add("PostDrawOpaqueRenderables", "HitboxRender", HitboxRender )
        hitboxCurrentlyRendering = true
    end

end )

concommand.Add( "debug_hitbox_renderall", function( ply, cmd, args, str)

    renderAll = not renderAll

end )

concommand.Add( "debug_hitbox_renderragdolls", function( ply, cmd, args, str)

    renderRagDolls = not renderRagDolls

end )

concommand.Add( "debug_hitbox_renderclient", function( ply, cmd, args, str)

    renderLocalPlayer = not renderLocalPlayer

end )