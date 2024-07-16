AddCSLuaFile()

--Podziękowania dla Bananowego Tasiemca za model 

if CLIENT then
	SWEP.WepSelectIcon = Material( "nexusproject/papieros.png" )
	SWEP.BounceWeaponIcon = false
end
SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.ViewModel = "models/weapons/bt/c_scp_420j.mdl"
SWEP.WorldModel = "models/weapons/bt/w_scp_420j.mdl"
SWEP.PrintName		= "SCP-420-J"
SWEP.Slot			= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "wos-custom-rece"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.SelectFont = "SCPHUDMedium"
SWEP.FajnyOpis = "Dzięki niemu możesz się odstresować, zniwelować zmęczenia, odzyskać świadomość, a efektem ubocznym jest chwilowa możliwość rozmowy z SCP."
SWEP.JakiPrzedmiot = "Przedmiot SCP"
SWEP.UseHands = true
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

SWEP.Idledelay = 0
SWEP.LoopLockidle = true

SWEP.Sounddelay = 0
SWEP.LoopLocksound = true

SWEP.Sound2delay = 0
SWEP.LoopLocksound2 = true

SWEP.Throwdelay = 0
SWEP.LoopLockthrow = true

SWEP.Removedelay = 0
SWEP.LoopLockremove = true

SWEP.IsUsed = false

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Idledelay = CurTime() + 0.5
    self.LoopLockidle = false
end



SWEP.Lang = nil

function SWEP:Initialize()

	self:SetHoldType(self.HoldType)
end

function SWEP:Holster()
	if self.IsUsed == false then
		return true
	else
		return false
	end
end

function SWEP:OnUse()
	self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 45, 0,  self.Owner:GetMaxHealth() ) )
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

			return false end
			
				if ent:GetNWBool( "chujowybricz" ) then 
		
if SERVER then
                        local text3 = "Muszę wpierw zdjąć zbroję, aby tego użyć.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )
                        net.WriteString( 10 ) --czas
                        net.Send( self.Owner )
end
			return false end


	if not IsFirstTimePredicted() then return end
		if ( self.Owner:Health() == self.Owner:GetMaxHealth() ) then

if SERVER then
                        local text3 = "Czuję się bardzo dobrze.."
                        net.Start( "DrawShadowTextToClient3" )
                        net.WriteString( text3 or "" )

                        net.Send( self.Owner )
end
end


	if self.IsUsed == true or self.LoopLockidle == false then return end
	
	self.IsUsed = true

    if self.Owner:GetActiveWeapon():GetClass() == "item_scp_420j" then
		self.Owner:StopSound("scp420/420_j.mp3")
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
		self.Throwdelay = CurTime() + 4
	    self.LoopLockthrow = false

		self.Sounddelay = CurTime() + 1.83
	    self.LoopLocksound = false
		self.Sound2delay = CurTime() + 0.87
	    self.LoopLocksound2 = false
	self.Owner.n420endtime = CurTime() + 15
	
	if !SERVER then return end
		self.Owner:SendLua( 'addSwiadomosc(30)' )
		self.Owner:SendLua( 'addZmeczenie(25)' )
	self:OnUse()
	
	end
	

end

function SWEP:SecondaryAttack()
end

function SWEP:PlayerShouldDie()
	self.OnUse()
end

function SWEP:Think()
	if self.Idledelay <= CurTime() and self.LoopLockidle == false then
		self.LoopLockidle = true
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	end
	if self.Sounddelay <= CurTime() and self.LoopLocksound == false then
		self.LoopLocksound = true
		self.Owner:EmitSound("scp420/420_j.mp3")
	end
	if self.Sound2delay <= CurTime() and self.LoopLocksound2 == false then
		self.LoopLocksound2 = true
		self.Owner:EmitSound("scp420/lighter_sound.wav")
	end
	if self.Throwdelay <= CurTime() and self.LoopLockthrow == false then
		self.LoopLockthrow = true
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_2)
		self.Removedelay = CurTime() + 1.5
		self.LoopLockremove = false
	end
	if self.Removedelay <= CurTime() and self.LoopLockremove == false then
		self.LoopLockremove = true
		if SERVER then
		self.Owner:StripWeapon("item_scp_420j")
		end
	end
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(0)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then

			local offsetVec = Vector(6, -2, -0.5)
			local offsetAng = Angle(0, 0, 0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end