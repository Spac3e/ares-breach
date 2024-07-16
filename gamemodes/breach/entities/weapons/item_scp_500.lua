AddCSLuaFile()
if CLIENT then
SWEP.InvIcon = Material( "nextoren/gui/icons/scp/500.png" )
	SWEP.BounceWeaponIcon = false
	
end
SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cultist/scp_items/500/scp500.mdl"
SWEP.WorldModel		= "models/cultist/scp_items/500/scp500.mdl"
SWEP.PrintName		= "SCP-500"
SWEP.Slot			= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "items"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.SelectFont = "SCPHUDMedium"


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

function SWEP:Deploy()
	if not IsFirstTimePredicted() then return end
	self.Owner:DrawViewModel( false )
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

SWEP.Lang = nil

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_500
		self.Author		= self.Lang.author
		self.Contact		= self.Lang.contact
		self.Purpose		= self.Lang.purpose
		self.Instructions	= self.Lang.instructions
	end
	self:SetHoldType(self.HoldType)
end

function SWEP:Think()
	if not IsFirstTimePredicted() then return end
end

function SWEP:OnUse()
	self.Owner:SetHealth( self.Owner:GetMaxHealth() )
	self.Owner:EmitSound("500_consume.wav", 45, math.random(80,120) )
self.Owner:SetKrwawienie( false )
self.Owner:SetNWInt("SCP330_TookMore", -1)
self.Owner.zainfekowany008 = false
self.Owner.Tabletki = false
	if SERVER then
	self.Owner:SendLua( 'addZmeczenie(70)' )
	self.Owner:SendLua( 'addSwiadomosc(70)' )
	
	self.Owner:SetNWFloat("WillLiveUntil_SCP207", -1)
	timer.Remove("infekcja" .. self.Owner:SteamID64())
	timer.Remove("infekcja2".. self.Owner:SteamID64())
	timer.Remove("Radiation" .. self.Owner:SteamID64())
	timer.Remove("FireBlow" .. self.Owner:SteamID64())
	
	timer.Remove( "piciekawy3" .. self.Owner:SteamID() )
	
	timer.Remove("infekcja6101".. self.Owner:SteamID64())
	timer.Remove("infekcja6102".. self.Owner:SteamID64())
	timer.Remove("infekcja6103".. self.Owner:SteamID64())
	timer.Remove("zawalsercabyq".. self.Owner:SteamID())
	

	
	if self.Owner.Infected409 then

	self.Owner.zainfekowanyy = false
	self.Owner.Infected409 = false
	timer.Remove("infekcja2".. self.Owner:SteamID64())
	timer.Remove("infekcja".. self.Owner:SteamID64())
	

	
		self.Owner:SetColor(Color(255, 255, 255, 255 ))
	                  local text3 = "Udało Ci się powstrzymać efekt krystalizacji"
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.Send( self.Owner )
	self.Owner:Give("inspect_hands")
	self.Owner:SelectWeapon("inspect_hands")
	end
	
	end
	self.Owner:StripWeapon( self:GetClass() )
end

function SWEP:PrimaryAttack()
		local ent = self.Owner	

if ent:GetNClass() == ROLES.ROLE_ANDROIDD or ent:GetNClass() == ROLES.ROLE_ANDROIDD2 or ent:GetNClass() == ROLES.ROLE_MEDBOTGOC or ent:GetNClass() == ROLES.ROLE_WYLAPYWANIA then

if SERVER then
                        local text3 = "Jesteś Androidem, jak zamierzasz tego użyć..?"
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end

			return end
				if ent.UsingArmor == "armor_hazmat" then 
		
if SERVER then
                        local text3 = "Muszę wpierw zdjąć zbroję, aby tego użyć.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
			return end
				if ent.UsingArmor == "armor_hazmat_yellow" then 
if SERVER then
                        local text3 = "Muszę wpierw zdjąć zbroję, aby tego użyć.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
			return end
				if ent.UsingArmor == "armor_hazmat_white" then 
if SERVER then
                        local text3 = "Muszę wpierw zdjąć zbroję, aby tego użyć.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
			return end
				if ent.UsingArmor == "armor_hazmat_orange" then 
if SERVER then
                        local text3 = "Muszę wpierw zdjąć zbroję, aby tego użyć.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
			return end
				if ent.UsingArmor == "armor_hazmat_blue" then 
if SERVER then
                        local text3 = "Muszę wpierw zdjąć zbroję, aby tego użyć.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
			return end
				if ent.UsingArmor == "armor_hazmat_black" then 
if SERVER then
                        local text3 = "Muszę wpierw zdjąć zbroję, aby tego użyć.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
			return end

	if not IsFirstTimePredicted() then return end
	if !SERVER then return end
	self:OnUse()
end

function SWEP:SecondaryAttack()
end

function SWEP:PlayerShouldDie()
	self.OnUse()
end