if ( CLIENT ) then
	SWEP.WepSelectIcon = Material( "nextoren/gui/icons/hacker_hack.png" )
	
		SWEP.BounceWeaponIcon = false
		SWEP.InvIcon = Material( "nextoren/gui/icons/hacker_hack.png" )
	
	end
	
	SWEP.PrintName = "Устройство для взлома"
	SWEP.droppable = false
	SWEP.ViewModelFOV = 45
	SWEP.ViewModelFlip = false
	SWEP.ViewModel	= Model( "models/cultist/items/hacker_crack/v_hacker_hack.mdl" )
	SWEP.WorldModel	= Model( "models/cultist/items/hacker_crack/w_hacker_hack.mdl" )
	
	SWEP.UseHands = true
	
	SWEP.droppable = false
	
	SWEP.Spawnable = true
	SWEP.AdminSpawnable = true
	SWEP.AdminOnly = true
	SWEP.UnDroppable = true
	--SWEP.Category = "More Lockpicks"
	
	SWEP.Primary.ClipSize = -1
	SWEP.Primary.DefaultClip = 0
	SWEP.Primary.Automatic = false
	SWEP.Primary.Ammo = ""
	
	SWEP.Secondary.ClipSize = -1
	SWEP.Secondary.DefaultClip = -1
	SWEP.Secondary.Automatic = false
	SWEP.Secondary.Ammo = ""
	SWEP.LockPickTime = 60
	
	SWEP.HoldType		= "items"
	
	local BannedDoors = {
	
		[ 3667 ] = true,
		[ 3762 ] = true,
		[ 4675 ] = true,
		[ 4403 ] = true
	
	}
	
	local BannedDoors2 = {
	
		[ 4574 ] = true
	
	}
	
	local customtimedoors = {
		{
			button = Vector(9983.000000, -3292.000000, 54.299999),
			time = 100/2,
		},
		{
			button = Vector(302.399994, -4156.640137, -1196.000000),
			time = 110/2,
		},
	}
	
	function SWEP:PlaySequence_hacker( seq_id )
	
		if ( !( self && self:IsValid() ) ) then return end
	
		local vm = self.Owner:GetViewModel()
	
		if ( !( vm && vm:IsValid() ) ) then return end
	
		if ( isstring( seq_id ) ) then
	
			seq_id = vm:LookupSequence( seq_id )
	
		end
	
		vm:SetCycle( 0 )
		vm:ResetSequence( seq_id )
		vm:SetPlaybackRate( 1.0 )
	
	end
	
	function SWEP:Holster()
	
		self.IdleAnimationDelay = CurTime() + 2
	
	
			self.HolsterDelay = CurTime() + 1
			self:PlaySequence_hacker( "holster" )
	
	
	
	
	
			return true
	
	
	
	end
	
	function SWEP:Initialize()
	
		self:SetHoldType( self.HoldType )
	
	end
	
	function SWEP:Deploy()
	
		self.IdleAnimationDelay = CurTime() + 2
		self.IdlePlaying = false
		self.HolsterDelay = nil
	
		self:SendWeaponAnim( ACT_VM_DRAW )
	
	end
	
	local old_hacking
	
	function SWEP:Think()
	
		if ( ( self.IdleAnimationDelay || 0 ) <= CurTime() ) then
	
			if ( !self.IdlePlaying && !self.Hacking ) then
	
				if ( old_hacking ) then
	
					self.IdleAnimationDelay = CurTime() + 2
					self:PlaySequence_hacker( "end_pressing" )
	
					old_hacking = false
					return
				end
	
				self.IdlePlaying = true
				self:PlaySequence_hacker( "idle1" )
	
			elseif ( self.Hacking ) then
	
				self:PlaySequence_hacker( "pressing" )
	
			end
	
			old_hacking = self.Hacking
	
		end
	
	end
	
	function SWEP:PrimaryAttack()
	
		if ( ( self.NextTry || 0 ) >= CurTime() ) then return end
		self.NextTry = CurTime() + 1
	
		local tr = self.Owner:GetEyeTrace()
		local time;
		local ent = tr.Entity
	
		--self:EmitSound( "nextoren/others/hacker/scanning01.wav" )
		if ( ent:GetClass() == "func_button" ) then
	
			self.IdleAnimationDelay = CurTime() + .8
			self.IdlePlaying = false
	
			self:PlaySequence_hacker( "start_pressing" )
			self.Hacking = true
	
			if ( CLIENT ) then return end
	
			if ( ent:GetInternalVariable( "m_iName" ):find( "checkpoint" ) || BannedDoors[ ent:MapCreationID() ] ) then
	
				time = 55
			elseif BannedDoors2[ ent:MapCreationID() ] then
			
			time = 80
			
			else
	
				time = 25
	
			end
	
			for _, tab in ipairs(customtimedoors) do
				if ent:GetPos() == tab.button then
					time = tab.time
					break
				end
			end
	
		self.Owner:BrProgressBar( "l:hacking_door", time, "nextoren/gui/icons/hacker_hack.png", ent, false, function()
			self.Owner:EmitSound( "nextoren/others/chaos_radio_open.wav" )
	
			self:SendWeaponAnim( ACT_VM_IDLE )
	
	
			timer.Simple( 3, function()
	
	
				ent:Fire("use")
	
			end ) end, function()
				self.Owner:EmitSound( "nextoren/others/hacker/scanning01.wav" )
			end, function()
				if IsValid(self) then
					self:SendWeaponAnim( ACT_VM_IDLE )
				end
			end)
	end
	
	end
	
	function SWEP:SecondaryAttack()
	
		self:PrimaryAttack()
	
	end
	
	
	