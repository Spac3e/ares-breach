AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("create_294_menu")
util.AddNetworkString("send_drink")


local napitki = {
    ["cola"] = {
        effect = function(ply, ent) end,
        sip = "slurp",
        snd = "",
    },
    ["tnt"] = {
        effect = function(ply, ent) ply:Kill() end,
        sip = "slurp",
        snd = "",
    }
}

net.Receive("send_drink", function(len,ply)
    local str = net.ReadString()
    local ent = net.ReadEntity()
  
    if not napitki[str] then
        return
    end

    ent:SpawnDrink(ply, str, ent)
end)

function ENT:SpawnDrink(ply, str, ent)
    local entA = self:GetAngles()
	local pos = self:GetPos() + entA:Right()*9 + entA:Up()*32 + entA:Forward()*13
    local napitok = napitki[str]

    local drink = ents.Create("item_drink_294")
    drink:SetPos(pos)
    --drink:SetOwner(ply)
    drink:Spawn()

    drink.effect = napitok.effect
    drink.sip = napitok.sip

    self:EmitSound( "scp_294_redux/outofrange.wav" )
end

function ENT:Initialize()
    self:SetModel( "models/vinrax/scp294/scp294_ru.mdl" )
    self:SetPos(Vector(195.409302, 3096.036865, -127.968750))
    self:SetAngles(Angle(0,90,0))
    self:PhysWake()
	self:SetSolid( SOLID_VPHYSICS )
    self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
end

function ENT:Use(activator,caller)
    net.Start("create_294_menu")
    net.Send(activator)
end