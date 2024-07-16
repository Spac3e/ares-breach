--[[


addons/[weapons]_ballistic_shields/lua/weapons/heavy_shield/shared.lua

--]]

if SERVER then 
	include( "ballistic_shields/sh_bs_util.lua" ) 
	include( "ballistic_shields/sv_bs_util.lua" ) 
end
include( "bs_config.lua" ) 
include( "ballistic_shields/sh_bs_lang.lua" ) 

SWEP.PrintName = "Баллистический щит"
SWEP.Author	= "D3G"
SWEP.Instructions = "RMB - Toggle visibility"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/shield/w_shield.mdl"
SWEP.InvIcon = Material( "nextoren/gui/icons/shield.png" )

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
SWEP.HoldType = "shield"
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:DrawWorldModel()

	if !self:GetOwner():IsPlayer() then
		self:SetNoDraw(false)
		self:DrawModel()
	else
		self:SetNoDraw(true)
		--self:DrawModel()
	end
end

local function bsGetHoldType(ply)
	if (ply:LookupAttachment( "anim_attachment_RH" )>0) then return {1,"anim_attachment_RH"} end
	if (ply:LookupAttachment( "forward" )>0) then return {2,"forward"} end
	return {3, "anim_attachment_head"}
end

local ShieldIcon = Material( "nextoren/gui/icons/shield.png" )
local BackgroundIcon = Material("bshields/ui/background")
function SWEP:DrawHUD()
	if(bshields.config.disablehud) then return end
	surface.SetDrawColor(255,255,255,200)	
	surface.SetMaterial(BackgroundIcon)
	surface.DrawTexturedRect( ScrW()/2-ScrH()/10, ScrH()/2-ScrH()/30+ScrH()/3, ScrH()/5, ScrH()/15)

	local aim = LocalPlayer():GetAimVector()
	local tr = util.TraceLine( {
		start  = LocalPlayer():GetShootPos() ,
		endpos = LocalPlayer():GetShootPos() + aim * 70,
		filter = LocalPlayer()
	} )
	surface.SetDrawColor(255,255,255,125)
	if(!IsValid(tr.Entity) || !DarkRP || !(tr.Entity:isDoor())) then
		draw.SimpleTextOutlined( bshields.lang[bshields.config.language].hshieldprim, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/22, Color( 255, 255, 255, 25 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	else
		draw.SimpleTextOutlined( bshields.lang[bshields.config.language].hshieldprim, "bshields.HudFont", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/22, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	end
	surface.SetMaterial(ShieldIcon)
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
		owner.bs_shield = ents.Create("bs_hshield")
		owner.bs_shield:SetCollisionGroup( COLLISION_GROUP_DEBRIS  )
		owner.bs_shield:SetMoveType( MOVETYPE_NONE ) 
		owner.bs_shield:SetPos(owner:GetPos())
		owner.bs_shield:SetParent( owner, owner:LookupAttachment(holdtype[2])) 
		owner.bs_shield:SetLocalAngles( bshields.shields[holdtype[1]][1].angles ) 
		owner.bs_shield:SetLocalPos( bshields.shields[holdtype[1]][1].position ) 
		owner.bs_shield:Spawn()
		owner.bs_shield.ShieldOwner = owner
		net.Start( "bs_shield_info" )
		net.WriteUInt( owner.bs_shield:EntIndex(), 16 ) 
		net.Send( owner )
	end
end

local function canRam(ply)
	return IsValid(ply) and (ply.warranted == true or ply:isWanted() or ply:isArrested())
end

function SWEP:PrimaryAttack()
	if(!DarkRP) then return end
	self:SetNextPrimaryFire( CurTime() + 1 )
	local owner = self.Owner
	if(!owner.allowhshield) then if SERVER then owner:ChatPrint( bshields.lang[bshields.config.language].hshieldcd1..(math.ceil(timer.TimeLeft("bshields_hcd_"..owner:EntIndex())) or 0)..bshields.lang[bshields.config.language].hshieldcd2 ) end  return end
	owner:LagCompensation(true)
	local trace = owner:GetEyeTrace()
	owner:LagCompensation(false)

	local ent = trace.Entity
	if !IsValid(ent) then return end
	if !(ent:isDoor() || (bshields.config.breachfdoors && ent.isFadingDoor && !ent.fadeActive)) then return end
	if ent.toDetonate then return end
	if owner:EyePos():DistToSqr(trace.HitPos) > 3000 then return end

	if SERVER then
		if ent.isFadingDoor && !ent.fadeActive && bshields.config.breachfdoors then
			local fowner = ent:CPPIGetOwner()		
			if !canRam(fowner) then 
				self.Owner:ChatPrint(DarkRP.getPhrase("warrant_required"))
				return
			end
			ent:EmitSound("npc/metropolice/gear2.wav") 
			ent:EmitSound("ballistic_shields/bomb_ticking.wav", 70, 100, 1) 
			ent.toDetonate = true
			timer.Simple(3.4, function()
				if(!IsValid(ent)) then return end
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() )
				effectdata:SetMagnitude( 5 )
				effectdata:SetScale( 2 )
				effectdata:SetRadius( 5 )
				util.Effect( "HelicopterMegaBomb", effectdata, true, true )
				ent:EmitSound( "physics/metal/metal_box_break1.wav" )
				ent:EmitSound( "ambient/explosions/explode_2.wav", 400 )
				ent:fadeActivate()
				ent.toDetonate = false
				timer.Simple(8, function()
					if IsValid(ent) && ent.fadeActive then
						ent:fadeDeactivate() 
					end 
				end)
			end)
		end

		if ent:isDoor() then
			local allowed = false
			if GAMEMODE.Config.doorwarrants && ent:isKeysOwned() && !ent:isKeysOwnedBy(ply) then
				for _, v in ipairs(player.GetAll()) do
					if ent:isKeysOwnedBy(v) && canRam(v) then
						allowed = true
						break
					end
				end
			else
				allowed = bshields.config.breachudoors
			end
			local keysDoorGroup = ent:getKeysDoorGroup()
			if GAMEMODE.Config.doorwarrants && keysDoorGroup then
				local teamDoors = RPExtraTeamDoors[keysDoorGroup]
				if teamDoors then
					allowed = false
					for _, v in ipairs(player.GetAll()) do
						if table.HasValue(teamDoors, v:Team()) && canRam(v) then
							allowed = true
							break
						end
					end
				end
			end
			if !allowed then
				self.Owner:ChatPrint(DarkRP.getPhrase("warrant_required"))
				return
			end

			local direction = owner:GetAimVector()
			ent:EmitSound("npc/metropolice/gear2.wav") 
			ent:EmitSound("ballistic_shields/bomb_ticking.wav", 70, 100, 1) 
			ent.toDetonate = true
			timer.Simple(3.4, function()
				if(!IsValid(ent)) then return end
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() - Vector(0,0,24) )
				effectdata:SetMagnitude( 5 )
				effectdata:SetScale( 2 )
				effectdata:SetRadius( 5 )
				util.Effect( "HelicopterMegaBomb", effectdata, true, true )
				ent:EmitSound( "physics/metal/metal_box_break1.wav" )
				ent:EmitSound( "ambient/explosions/explode_1.wav", 400 )
				if(ent:GetClass() != "prop_door_rotating") then
					ent:keysUnLock()
					ent:Fire("open", "", 0)
					ent:Fire("setanimation", "open", 0)
					ent.toDetonate = false
				else
					local door = ents.Create( "prop_physics" )
					door:SetCollisionGroup(COLLISION_GROUP_NONE)
					door:SetMoveType(MOVETYPE_VPHYSICS)
					door:SetSolid(SOLID_BBOX) 
					door:SetPos(ent:GetPos() + Vector(0,0,1))
					door:SetAngles(ent:GetAngles()) 
					door:SetModel(ent:GetModel())
					door:SetSkin(ent:GetSkin()) 
					ent:Extinguish() 
					ent:SetNoDraw(true) 
					ent:SetNotSolid(true)
					ent:Fire("unlock", 0)
					ent:Fire("open", 0)
					door:Spawn()
					door:GetPhysicsObject():AddVelocity(direction*700)
					ent.phys_door = door
				end
				timer.Simple(bshields.config.doorrespawn, function()
					if(!IsValid(ent)) then return end
					ent:SetNoDraw(false) 
					ent:SetNotSolid(false)
					ent.toDetonate = false
					if(IsValid(ent.phys_door)) then ent.phys_door:Remove() end
				end)
			end)
		end
	end
	owner.allowhshield = false
	timer.Create("bshields_hcd_"..owner:EntIndex(), bshields.config.hshieldcd, 1, function()
		if(IsValid(owner)) then
			owner.allowhshield = true
		end
	end)
end

function SWEP:SecondaryAttack()
	--[[
	if CLIENT then
		if(!self.CanVisToggle) then return end
		surface.PlaySound( "weapons/smg1/switch_single.wav" )
		if(!self.VisToggle) then
			Entity(LocalPlayer().bs_shieldIndex):SetColor(Color( 0, 0, 0, 125 ))
			self.VisToggle = true
		else
			Entity(LocalPlayer().bs_shieldIndex):SetColor(Color( 255, 255, 255 ))
			self.VisToggle = false
		end
		self.CanVisToggle = false
		timer.Simple(0.1, function()
			self.CanVisToggle = true
		end)
	end
	--]]
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
