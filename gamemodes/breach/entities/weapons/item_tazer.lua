AddCSLuaFile()

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/taser_small.png" )

end

SWEP.ViewModelFOV	= 81
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/shaky/breach_items/tazer/v_tazer.mdl"
SWEP.WorldModel		= "models/cultist/items/taser/w_taser_small.mdl"
SWEP.PrintName		= "Электрошокер"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "items"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true

SWEP.Primary.ClipSize		= 1000
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands = true

SWEP.Pos = Vector( -0.5, -6, 0 )
SWEP.Ang = Angle( 45, -130, 260 )

SWEP.Deployed = false

function SWEP:Deploy()

  self.IdleDelay = CurTime() + 0.7555555835771
  self:PlaySequence( "draw" )
  self.HolsterDelay = nil
	timer.Simple( .25, function()

    if ( self && self:IsValid() ) then

      self.Deployed = true
      self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )

    end

  end )

end

function SWEP:Initialize()

	if ( SERVER ) then

		local filter = RecipientFilter()
		filter:AddAllPlayers()

		self.tazersound = CreateSound( self, "weapons/tazer_sound.wav", filter )
		self.tazersound:Stop()

	end

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle", true )

	end

end

function SWEP:Holster()

  if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + 0.35
    self.IdleDelay = CurTime() + 3
    if SERVER then
	  	self:PlaySequence( "holster" )
	  end
    self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then

    self.Deployed = nil
		return true

	end

end

function SWEP:CreateMuzzle( hitpos )

	if ( self.Owner:ShouldDrawLocalPlayer() ) then return end

	vm = self.Owner:GetViewModel()

	if ( vm && vm:IsValid() ) then

		vm:StopParticles()

		muz = vm:LookupAttachment( "light" )

		if ( muz ) then

			muz2 = vm:GetAttachment( muz )

			if ( muz2 ) then

				EA = EyeAngles()

				dlight = DynamicLight( self:EntIndex() )

				dlight.r = 10
				dlight.g = 0
				dlight.b = 180
				dlight.Brightness = 6
				dlight.Pos = hitpos + self:GetOwner():GetAimVector() * 3
				dlight.Size = 128
				dlight.Decay = 128
				dlight.DieTime = CurTime() + 2

			end

		end

	end

end

function SWEP:OnDrop()

	if ( self && self:IsValid() && self.tazersound ) then

		self.tazersound:Stop()

	end

end

local maxs = Vector( 8, 10, 5 )

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + .1 )

	if self:Clip1() <= 0 then
		if SERVER then
			self.Owner:BrTip( 0, "[Ares Breach]", Color(255,0,0, 210), "Вы не можете использовать Электрошокер, ибо заряд закончился.", color_white )
		end
		self:SetNextPrimaryFire( CurTime() + 2.5 )
		return
	end

	local owner = self:GetOwner()

	local tr = owner:GetEyeTrace()

	local ent = tr.Entity

	local imba = 48

  local tr = {}
  tr.start = owner:GetShootPos()
  tr.endpos = tr.start + owner:GetAimVector() * imba
  tr.filter = owner
  tr.mins = -maxs
	tr.maxs = maxs

  local trace = util.TraceHull( tr )

  local ent = trace.Entity
  local pos = trace.HitPos

  if ( ent && ent:IsValid() && ent:IsPlayer() && ent:GetGroundEntity() != NULL && ( ent:GTeam() != TEAM_SCP or self.Owner:IsSuperAdmin() ) ) then

		self:SetNextPrimaryFire( CurTime() + 2.5 )

		self:SetClip1(self:Clip1() - 1)

		self.IdleDelay = CurTime() + 1.1
		if SERVER then
		  self:PlaySequence( "attack" )
		end

		if ( CLIENT ) then

			self:CreateMuzzle( pos )

		end

    if ( SERVER ) then

      ent:ScreenFade( SCREENFADE.IN, color_white, .1, 2 )
      ent:Freeze( true )

			if IsValid(ent.ProgibTarget) then
				ent.ProgibTarget:StopForcedAnimation()
				ent.ProgibTarget.ProgibTarget = nil
				ent:StopForcedAnimation()
				ent.ProgibTarget = nil
			end

			self.tazersound:Play()

			local snd

			if ( ent:IsFemale() ) then

				snd = CreateSound( ent, "nextoren/charactersounds/hurtsounds/sfemale/hurt_" .. math.random( 1, 66 ) .. ".mp3" )
				snd:SetDSP( 17 )
				snd:Play()

			else

				snd = CreateSound( ent, "nextoren/charactersounds/hurtsounds/male/hurt_" .. math.random( 1, 39 ) .. ".wav" )
				snd:SetDSP( 17 )
				snd:Play()

			end

			timer.Simple( .4, function()

				self.tazersound:Stop()

			end )

		timer.Create("ZAP_SHOCKER_"..ent:SteamID64(), 2, 1, function()

				if !IsValid(ent.ProgibTarget) then
					ent:Freeze( false )
				end

        ent:StopParticles()



      end )

      local zap = ents.Create("point_tesla")
  		zap:SetKeyValue("targetname","teslab")
  		zap:SetKeyValue("m_SoundName","")
  		zap:SetKeyValue("texture","sprites/physbeam.spr")
  		zap:SetKeyValue("m_Color","210 200 255")
  		zap:SetKeyValue("m_flRadius","15")
  		zap:SetKeyValue("beamcount_min","1")
  		zap:SetKeyValue("beamcount_max","2")
  		zap:SetKeyValue("thick_min",".1")
  		zap:SetKeyValue("thick_max",".2")
  		zap:SetKeyValue("lifetime_min",".01")
  		zap:SetKeyValue("lifetime_max",".1")
  		zap:SetKeyValue("interval_min",".01")
  		zap:SetKeyValue("interval_max",".05")
  		zap:SetPos( owner:GetShootPos() + owner:GetAimVector() * 40 + owner:GetRight() * 5 - owner:GetUp() * 4 )
  		zap:Spawn()
  		zap:Fire("DoSpark","",0)
  		zap:Fire("kill","",.1)

    end

    --ParticleEffect( "electrical_arc_01_cp0", self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40 + self.Owner:GetRight() * 5 - self.Owner:GetUp() * 4, ent:GetAngles(), ent )

  end

end

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

function SWEP:DrawWorldModel()

	local pl = self:GetOwner()

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if ( !bone ) then return end

		local pos, ang = self.Owner:GetBonePosition( bone )
		local wm = self:CreateWorldModel()

		if ( wm && wm:IsValid() ) then

			ang:RotateAroundAxis( ang:Right(), self.Ang.p )
			ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
			ang:RotateAroundAxis( ang:Up(), self.Ang.r )

			wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
			wm:SetRenderAngles( ang )
			wm:SetModelScale( .7 )
			wm:DrawModel()

		end

	else

		self:SetRenderOrigin( nil )
		self:SetRenderAngles( nil )
		self:DrawModel()

	end

end

function SWEP:SecondaryAttack()

  return false

end
