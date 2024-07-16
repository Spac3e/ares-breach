AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"
ENT.Category    = "Breach"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model       = Model( "models/props/scp_vendor.mdl" )

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Activated" )

end

ENT.DeclareSoda = {

  [ "gold_coin" ] = "item_drink_energy",
  [ "silver_coin" ] = "item_drink_soda",
  [ "copper_coin" ] = "item_drink_water"

}

local soda_vec, soda_ang = Vector( 20, 0, -25 ), Angle( -90, -90, 0 )

function ENT:CreateSoda( sodatype )

  local pos, ang = LocalToWorld( soda_vec, soda_ang, self:GetPos(), self:GetAngles() )
  local soda = ents.Create( sodatype )
  soda:SetPos( pos )
  soda:SetAngles( ang )
  soda:Spawn()

end

function ENT:Initialize()

  self:SetModel( self.Model )
  self:SetSolid( SOLID_BBOX )
  self:PhysicsInit( SOLID_BBOX )
  self:SetMoveType(MOVETYPE_NONE)
  self:SetActivated( false )
  --self:SetPos( Vector( 6400.649902, -1866.018677, 42.445602 ) )
  --self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
  self:SetPlaybackRate( 1.0 )
  self.Activated = false
  self.Opened = false

  self:SetCollisionBounds( Vector( -24, -24, 0 ), Vector( 24, 24, 40 ) )

  self.idlesound = CreateSound( self, "nextoren/others/vending_machine_sounds/machine_idle.wav" )
  self.idlesound:Play()

  local phys = self:GetPhysicsObject()

  if ( phys && phys:IsValid() ) then

    phys:EnableMotion( false )
    phys:Wake()

  end

  if ( SERVER ) then

    self:SetUseType( SIMPLE_USE )

  end

end

function ENT:OnRemove()

  self.idlesound:Stop()

end

function ENT:Think()

  self:NextThink( CurTime() )

end

function ENT:Use( caller )

  if ( CLIENT ) then return end

  if ( ( self.NextUse || 0 ) > CurTime() ) then return end

  if ( !caller:IsPlayer() ) then return end

  local wep = caller:GetActiveWeapon()
  local is_coin = wep != NULL && string.find( wep:GetClass(), "coin" )

  if ( !is_coin ) then

    self.NextUse = CurTime() + 1
    self:EmitSound( "nextoren/others/vending_machine_sounds/need_coin.wav" )
    caller:SetBottomMessage( "l:vendor_no_money" )

  else

    self.NextUse = CurTime() + 1

    wep:Remove()
    caller:SetBottomMessage( "l:vendor_bought" )

    self:CreateSoda( self.DeclareSoda[ wep:GetClass() ] )
    self:EmitSound( "nextoren/others/vending_machine_sounds/coin_insert.wav" )
    self:EmitSound( "nextoren/others/vending_machine_sounds/can_buy.wav" )

  end

end

function ENT:Draw()

  self:DrawModel()

end
