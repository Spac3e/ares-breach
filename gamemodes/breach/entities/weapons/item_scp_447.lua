AddCSLuaFile()


if CLIENT then
SWEP.InvIcon = Material( "nextoren/gui/icons/scp/447.png" )
	SWEP.BounceWeaponIcon = false
	
end
if CLIENT then
	SWEP.PrintName		= "SCP-447"	
	SWEP.Author = "Azus"
	SWEP.Contact = "Azus" 
	SWEP.Purpose = "Azus"
	SWEP.Slot      = 3
    SWEP.SlotPos   = 1
	end

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= "models/cultist/scp_items/447/scp_447.mdl"
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType = "items"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.SelectFont = "SCPHUDMedium"

SWEP.Toggleable = true
SWEP.Selectable = false

SWEP.Group 		= "gasmask"

SWEP.droppable				= true
SWEP.teams					= {2,3,5,6,7,8,9,10,11,12}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

SWEP.Primary.Delay			= 2.5	 
SWEP.HealthBonus	= 50
SWEP.HealAmount		= 3
SWEP.HealTimer		= 6
SWEP.HealId			= ""


function SWEP:Initialize()
	self:SetHoldType( self.HoldType )

end

function SWEP:Equip()

end

function SWEP:Deploy()

end

function SWEP:Holster()
	local owner = self.Owner
	return true
end

function SWEP:OnRemove()
	self:RemoveSelf()
	return true
end


function SWEP:RemoveSelf()
	local owner = self.Owner
	if !SERVER then return end
	self:Remove()
end

function SWEP:Reload()
end

function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		local ent = nil
		local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 ),
			filter = self.Owner,
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			mask = MASK_SHOT_HULL
		} )
		ent = tr.Entity


		if IsValid(ent) then
				if SERVER then		
		if ent:IsRagdoll() then
	if ent.Infected409 or ent.zainfekowanyy then 
if SERVER then
                        local text3 = "To ciało jest niezdatne do pokrycia śluzem SCP-447"
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
return false end





		local scp447 = player.GetBySteamID( ent:GetNWString( "ragdollid" ) )
		
			if IsValid(scp447) then
		if scp447:IsPlayer() then
		if scp447:GetNClass() == ROLES.ROLE_MTFNTF or scp447:GetNClass() == ROLES.ROLE_CHAOS or scp447:GetNClass() == ROLES.ROLE_ESCIPI or scp447:GetNClass() == ROLES.ROLE_ANDROIDD or scp447:GetNClass() == ROLES.ROLE_ANDROIDD2 or scp447:GetNClass() == ROLES.ROLE_MEDBOTGOC or scp447:GetNClass() == ROLES.ROLE_WYLAPYWANIA then return end
	if SERVER then
  self.Owner:BrProgressBar( "Nakładam SCP-447 na ciało..", 3, "nextoren/gui/icons/scp/447.png")
end	
timer.Simple( 3, function() 
		if IsValid(self) then
			scp447:SetGTeam(ent:GetNWString( "klasarag4" ))
			scp447:SetNClass(ent:GetNWString( "siematunazwapostaci" ))
			scp447:Spawn()
			 scp447:SetupNormal()
		 scp447:SetWalkSpeed(100)
             scp447:SetRunSpeed(210) 
			 scp447:SetJumpPower(190)
			scp447:SetHealth(90)
			scp447:SetMaxHealth(90)
			scp447:SetPos(ent:GetPos())
			scp447:Give("v92_eq_rece")
			scp447:Give("br_id")
			scp447:SetNWBool( "chujowybricz", false )
			scp447.mniejstaminy = true
			ent:Remove()
if SERVER then
self:Remove()
end
end	
end)
else
if SERVER then
                        local text3 = "To ciało jest niezdatne do pokrycia śluzem SCP-447"
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
end
end
end
end
else
if SERVER then
                        local text3 = "Pokrywasz się śluzem SCP-447, Twoje ciało zostało zregenerowane.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
self.Owner:SetKrwawienie( false )
self.Owner:SetNWInt("SCP330_TookMore", -1)
if SERVER then
self.Owner:StripWeapon( self:GetClass() )
end
if CLIENT then
self.Owner:SelectWeapon("v92_eq_rece")
end
end
end



function SWEP:Think()
	
end