--[[


addons/[weapons]_ballistic_shields/lua/weapons/deployable_shield/shared.lua

--]]

if SERVER then 
	include( "ballistic_shields/sh_bs_util.lua" ) 
	include( "ballistic_shields/sv_bs_util.lua" ) 
end
include( "bs_config.lua" ) 
include( "ballistic_shields/sh_bs_lang.lua" ) 


SWEP.PrintName = "Bouclier déployable"
SWEP.Author	= "D3G"
SWEP.Instructions = "LMB - Deploy shield | RMB - Toggle visibility"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = ""
SWEP.WorldModel = "models/bshields/dshield.mdl"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom	= false

SWEP.Slot = 5
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Category = "Ballistic shields"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.CanVisToggle = true
SWEP.VisToggle = false
SWEP.HitDistance = 55

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	self:SetHoldType("melee2")
end

function SWEP:DrawWorldModel()
	self:SetNoDraw( true ) 
end

local function bsGetHoldType(ply)
	if (ply:LookupAttachment( "anim_attachment_RH" )>0) then return {1,"anim_attachment_RH"} end
	if (ply:LookupAttachment( "forward" )>0) then return {2,"forward"} end
	return {3, "anim_attachment_head"}
end

local ShieldIcon = Material("bshields/ui/deployable_shield", "smooth")
local ShieldIconClosed = Material("bshields/ui/deployable_shield_closed", "smooth")
local BackgroundIcon = Material("bshields/ui/background")
function SWEP:DrawHUD()
	if(bshields.config.disablehud) then return end
	surface.SetDrawColor(255,255,255,200)	
	surface.SetMaterial(BackgroundIcon)
	surface.DrawTexturedRect( ScrW()/2-ScrH()/10, ScrH()/2-ScrH()/30+ScrH()/3, ScrH()/5, ScrH()/15)

	local aim = LocalPlayer():GetAimVector()
	local tr = util.TraceLine( {
		start  = LocalPlayer():GetShootPos() ,
		endpos = LocalPlayer():GetShootPos() + aim * 120,
		filter = LocalPlayer()
	} )
	surface.SetDrawColor(255,255,255,125)
	if(tr.HitPos:DistToSqr(LocalPlayer():GetPos()))>550 && tr.HitPos.z<=(LocalPlayer():GetPos().z+30) && (tr.HitWorld || (IsValid(tr.Entity) && tr.Entity:GetClass() == "prop_physics")) then
		draw.SimpleTextOutlined( bshields.lang[bshields.config.language].dshieldprim, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/22, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
		surface.SetMaterial(ShieldIcon)
	else
		draw.SimpleTextOutlined( bshields.lang[bshields.config.language].dshieldprim, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/22, Color( 255, 255, 255, 25 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
		surface.SetMaterial(ShieldIconClosed)
	end
	surface.DrawTexturedRect( ScrW()/2-ScrH()/10.2, ScrH()/2-ScrH()/32+ScrH()/3, ScrH()/16, ScrH()/16) 
	if(self.VisToggle) then
		draw.SimpleTextOutlined( bshields.lang[bshields.config.language].sec, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/48, Color( 255, 255, 255, 25 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	else
		draw.SimpleTextOutlined( bshields.lang[bshields.config.language].sec, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/48, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	end
end

function SWEP:Deploy() 
	self.CanVisToggle = true
	self.VisToggle = false
	if SERVER then
		local owner = self.Owner
		local holdtype = bsGetHoldType(owner)
		bshield_remove(owner)
		owner.bs_type = 2
		owner.bs_shield = ents.Create("bs_dshield")
		owner.bs_shield:SetCollisionGroup( COLLISION_GROUP_DEBRIS  )
		owner.bs_shield:SetMoveType( MOVETYPE_NONE ) 
		owner.bs_shield:SetPos(owner:GetPos())
		owner.bs_shield:SetParent( owner, owner:LookupAttachment(holdtype[2])) 
		owner.bs_shield:SetLocalAngles( bshields.shields[holdtype[1]][2].angles ) 
		owner.bs_shield:SetLocalPos( bshields.shields[holdtype[1]][2].position ) 
		owner.bs_shield:Spawn()
		net.Start( "bs_shield_info" )
		net.WriteUInt( owner.bs_shield:EntIndex(), 16 ) 
		net.Send( owner )
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		local owner = self:GetOwner()
		local aim = owner:GetAimVector()
		local tr = util.TraceLine( {
			start  = owner:GetShootPos() ,
			endpos = owner:GetShootPos() + aim * 120,
			filter = owner
		} )
		if(tr.HitPos:DistToSqr(owner:GetPos()))>550 && tr.HitPos.z<=(owner:GetPos().z+30) && (tr.HitWorld || (IsValid(tr.Entity) && tr.Entity:GetClass() == "prop_physics")) then
			shield = ents.Create("bs_shield")
			shield:SetPos(tr.HitPos + Vector(0,0,28.5) - aim * 10)
			shield:SetAngles(Angle(0,aim:Angle().y,0))
			shield:Spawn()
			shield:EmitSound( "npc/combine_soldier/gear1.wav" )
			shield.Owner = owner
			bshield_remove(owner)
			owner:StripWeapon( "deployable_shield" )
			table.insert(owner.bs_shields, shield)
			if(table.Count(owner.bs_shields)>bshields.config.maxshields) then
				if(IsValid(owner.bs_shields[1])) then owner.bs_shields[1]:Remove() end
				table.remove(owner.bs_shields, 1) 
			end
		end
		self:SetNextPrimaryFire( CurTime() + 0.5 )
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then
		if(!self.CanVisToggle) then return end
		surface.PlaySound( "weapons/smg1/switch_single.wav" )
		if(!self.VisToggle) then
			Entity(LocalPlayer().bs_shieldIndex):SetColor(Color( 0, 0, 0, 125 ))
			self.VisToggle = true
		else
			Entity(LocalPlayer().bs_shieldIndex):SetColor(Color( 255, 255, 255 ))
			self.VisToggle = false
			self.VisToggle = false
		end
		self.CanVisToggle = false
		timer.Simple(0.1, function()
			self.CanVisToggle = true
		end)
	end
end

if CLIENT then return end

function SWEP:Holster()
	bshield_remove(self.Owner)
	return true
end
function SWEP:OnRemove()
	bshield_remove(self.Owner)
	return true
end
function SWEP:OnDrop()
	bshield_remove(self.Owner)
	return true
end
