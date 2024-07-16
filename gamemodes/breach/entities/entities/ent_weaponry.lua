
AddCSLuaFile()

ENT.Type        = "anim"
ENT.Category    = "Breach"

ENT.Model       = Model( "models/cultist/armory/armory.mdl" )

function ENT:Initialize()
  if ( SERVER ) then
    self:SetModel( self.Model )
    self:SetMoveType( MOVETYPE_NONE )
    self.BannedUsers = {}
  end
  self:SetSolid( SOLID_VPHYSICS )
end

if ( SERVER ) then

  local Teams_Setup = {
    {
      [ TEAM_SECURITY ] = {
        [role.SECURITY_Chief] = { weapon = "cw_kk_ins2_deagle", ammo = { type = "Revolver", quantity = 64 } },
        [role.SECURITY_IMVSOLDIER] = { weapon = "cw_kk_ins2_cstm_g19", ammo = { type = "Pistol", quantity = 80 } },
        [role.SECURITY_Sergeant] = { weapon = "cw_kk_ins2_m9", ammo = { type = "Pistol", quantity = 70 } },
        [role.SECURITY_OFFICER] = { weapon = "cw_kk_ins2_g18", ammo = { type = "Pistol", quantity = 64 } },
        [role.SECURITY_Shocktrooper] = { weapon = "cw_kk_ins2_cstm_uzi", ammo = { type = "Pistol", quantity = 150 } },
        [role.SECURITY_Warden] = { weapon = "cw_kk_ins2_cstm_cobra", ammo = { type = "Pistol", quantity = 80 } },
        [role.SECURITY_Recruit] = { weapon = "cw_kk_ins2_g17", ammo = { type = "Pistol", quantity = 48 } }
      },
      [ TEAM_CHAOS ] = {
        [role.SECURITY_Spy] = {
          { weapon = "cw_kk_ins2_g18", ammo = { type = "Pistol", quantity = 64 } },
          { weapon = "cw_kk_ins2_g17", ammo = { type = "Pistol", quantity = 48 } },
          { weapon = "cw_kk_ins2_cstm_g19", ammo = { type = "Pistol", quantity = 80 } },

        }
      }
    },
    {

      [ TEAM_GUARD ] = {

        [role.MTF_HOF] = { type = "Revolver", quantity = 20 },
        [role.MTF_Chem] = { type = "SMG1", quantity = 300 },
        [role.MTF_Com] = { type = "AR2", quantity = 500 },
        [role.MTF_Engi] = { type = "Sniper", quantity = 60 },
        [role.MTF_Guard] = { type = "AR2", quantity = 400 },
        [ role.MTF_Jag ] = { type = "AR2", quantity = 600 },
        [ role.MTF_Left ] = { type = "AR2", quantity = 360 },
        [ role.MTF_Medic ] = { type = "SMG1", quantity = 240 },
        [ role.MTF_Security ] = { type = "Pistol", quantity = 100 },
        [ role.MTF_Shock ] = { type = "Shotgun", quantity = 120 },
        [ role.MTF_Specialist ] = { type = "AR2", quantity = 450 }

      },
      [ TEAM_SECURITY ] = {

        [role.SECURITY_Chief] = {

          weapon = { "cw_kk_ins2_uar556", "item_nightvision_blue" },
          ammo = { type = "AR2", quantity = 180 },
          bodygroups = {

            [ 0 ] = "1",
            [ 1 ] = "1",
            [ 7 ] = "1"

          },

          damage_modifiers = {
            ["HITGROUP_HEAD"] = 1,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 1,
            ["HITGROUP_RIGHTARM"] = 1,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 1,
            ["HITGROUP_RIGHTLEG"] = 1
           },
           bonemerge = "models/cultist/humans/balaclavas_new/balaclava_half.mdl",

        },
        [role.SECURITY_IMVSOLDIER] = {

          weapon = { "cw_kk_ins2_blackout", "item_nightvision_blue" },
          ammo = { type = "AR2", quantity = 180 },
          bodygroups = {

            [ 0 ] = "2",
            [ 1 ] = "1",
            [ 7 ] = "1"

          },
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.9,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 1,
            ["HITGROUP_RIGHTARM"] = 1,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 1,
            ["HITGROUP_RIGHTLEG"] = 1
           },

        },
        [role.SECURITY_Sergeant] = {

          weapon = { "cw_kk_ins2_cstm_kriss", "item_nightvision_green" },
          ammo = { type = "SMG1", quantity = 210 },
          bodygroups = {

            [ 0 ] = "2",
            [ 1 ] = "1",
            [ 7 ] = "1"

          },
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 1,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 1,
            ["HITGROUP_RIGHTARM"] = 1,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 1,
            ["HITGROUP_RIGHTLEG"] = 1
           },

        },
        [role.SECURITY_OFFICER] = {

          weapon = { "cw_kk_ins2_cq300", "item_nightvision_green" },
          ammo = { type = "AR2", quantity = 180 },
          bodygroups = {

            [ 0 ] = "1",
            [ 1 ] = "1",
            [ 7 ] = "1"

          },
          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.8,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 1,
            ["HITGROUP_RIGHTARM"] = 1,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 0.9,
            ["HITGROUP_RIGHTLEG"] = 0.9
           },
          bonemerge = "models/cultist/humans/mog/heads/head_main.mdl"

        },
        [role.SECURITY_Shocktrooper] = {

          weapon = { "cw_kk_ins2_cstm_ksg", "item_nightvision_green" },
          ammo = { type = "Shotgun", quantity = 110 },
          bodygroups = {

            [ 0 ] = "2",
            [ 1 ] = "2",
            [ 3 ] = "1",
            [ 5 ] = "1",
            [ 7 ] = "1"

          },

          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.65,
            ["HITGROUP_CHEST"] = 0.65,
            ["HITGROUP_LEFTARM"] = 0.65,
            ["HITGROUP_RIGHTARM"] = 0.65,
            ["HITGROUP_STOMACH"] = 0.65,
            ["HITGROUP_GEAR"] = 0.65,
            ["HITGROUP_LEFTLEG"] = 0.65,
            ["HITGROUP_RIGHTLEG"] = 0.65
           },

        },
        [role.SECURITY_Warden] = {

          weapon = { "cw_kk_ins2_uar556", "item_nightvision_green" },
          ammo = { type = "AR2", quantity = 180 },
          bonemerge = true,
          bodygroups = {

            [ 0 ] = "1",
            [ 1 ] = "2",
            [ 2 ] = "1",
            [ 3 ] = "1",
            [ 7 ] = "1"

          },

          damage_modifiers = {
            ["HITGROUP_HEAD"] = 0.8,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 1,
            ["HITGROUP_RIGHTARM"] = 1,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 1,
            ["HITGROUP_RIGHTLEG"] = 1
           },

          bonemerge = "models/cultist/humans/mog/heads/head_main.mdl"

         },
        [role.SECURITY_Recruit] = {

          weapon = { "cw_kk_ins2_cq300", "item_nightvision_green" },
          ammo = { type = "AR2", quantity = 180 },
          bodygroups = {

            [ 0 ] = "1",
            [ 1 ] = "1",
            [ 7 ] = "1"

          },

          damage_modifiers = {
            ["HITGROUP_HEAD"] = 1,
            ["HITGROUP_CHEST"] = 0.8,
            ["HITGROUP_LEFTARM"] = 1,
            ["HITGROUP_RIGHTARM"] = 1,
            ["HITGROUP_STOMACH"] = 0.8,
            ["HITGROUP_GEAR"] = 0.8,
            ["HITGROUP_LEFTLEG"] = 1,
            ["HITGROUP_RIGHTLEG"] = 1
           },

        }

      }

    }

  }

  local vec_to_check = Vector( 7460.145020, -4383.012695, 1.331047 )

  function ENT:Use( survivor )

    if ( ( self.NextUse || 0 ) > CurTime() ) then return end

    self.NextUse = CurTime() + .25

    local pl_team = survivor:GTeam()
    local n_type = vec_to_check == self:GetPos() && 1 || 2
    local current_table = Teams_Setup[ n_type ]

    if ( !current_table[ pl_team ] || !current_table[ pl_team ][ survivor:GetRoleName() ] ) or survivor:GetRoleName() == role.Dispatcher then

      survivor:AresNotify("l:weaponry_cant_use")

      return
    end

    if ( self.BannedUsers[ survivor ] ) then

      if ( n_type == 1 ) then

        survivor:AresNotify("l:weaponry_took_ammo_security_pt1")

      else

        if ( pl_team == TEAM_GUARD ) then

          survivor:AresNotify("l:weaponry_took_ammo_already")

        else

        survivor:AresNotify("l:weaponry_took_uniform_already")

        end

      end

      return
    end

    self.BannedUsers[ survivor ] = true

    if ( self:GetPos() == vec_to_check ) then
      local survivor_table

      if ( pl_team == TEAM_CHAOS ) then
        if ( survivor.HeadEnt && survivor.HeadEnt:IsValid() && survivor.HeadEnt:GetModel() == "models/cultist/humans/balaclavas_new/balaclava_full.mdl" ) then
          survivor_table = current_table[ pl_team ][ survivor:GetRoleName() ][ 1 ]
        else
          if ( survivor.HeadEnt && survivor.HeadEnt:IsValid() && survivor.HeadEnt:GetModel() == "models/cultist/humans/balaclavas_new/balaclava_half.mdl" ) then
          survivor_table = current_table[ pl_team ][ survivor:GetRoleName() ][ 3 ]
        else
          survivor_table = current_table[ pl_team ][ survivor:GetRoleName() ][ 2 ]
      end
    end

      else

        survivor_table = current_table[ pl_team ][ survivor:GetRoleName() ]

      end


      survivor:Give( survivor_table.weapon )
      survivor:SetAmmo( survivor_table.ammo.quantity, survivor_table.ammo.type )
      survivor:EmitSound( "nextoren/entities/weaponry/pickup_" .. math.random( 1, 5 ) .. ".wav", 75, math.random( 80, 100 ), 1, CHAN_STATIC )

      survivor:AresNotify("l:weaponry_took_ammo_security_pt2")

    else

      local survivor_table = current_table[ pl_team ][ survivor:GetRoleName() ]

      if ( pl_team == TEAM_GUARD ) then

        survivor:SetAmmo( survivor_table.quantity, survivor_table.type )
        survivor:EmitSound( "nextoren/equipment/ammo_pickup.wav", 75, math.random( 80, 100 ), 1, CHAN_STATIC )

        if survivor:GetRoleName() == role.MTF_Shock then
          survivor:BreachGive("cw_kk_ins2_nade_anm14")
        end

        survivor:AresNotify("l:weaponry_take_ammo")

      else

        if survivor:GetMaxSlots() - survivor:GetPrimaryWeaponAmount() < #survivor_table.weapon then
          survivor:AresNotify("l:weaponry_need_slots_pt1 "..tostring(#survivor_table.weapon).." l:weaponry_need_slots_pt2")
          return
        end
        
        survivor:ClearBodyGroups()
        survivor:ScreenFade( SCREENFADE.OUT, color_black, .1, 1 )
        survivor:Give( "inspect_hands" )

        local old_weapon = survivor:GetActiveWeapon()

				if ( old_weapon != NULL ) then

					old_weapon = old_weapon:GetClass()

				end

        survivor:SelectWeapon( "inspect_hands" )
        timer.Simple( .75, function()

          if ( survivor && survivor:IsValid() ) then

            survivor:SelectWeapon( "inspect_hands" )

            local wep = survivor:GetWeapon( "inspect_hands" )
    				wep.weapon_to_select = old_weapon

          end

        end )

        survivor:EmitSound( Sound("nextoren/others/cloth_pickup.wav"), 125, 100, 1.25, CHAN_VOICE)
        survivor:ScreenFade(SCREENFADE.IN, color_black, 1, 1)
        if survivor:IsFemale() then
          survivor:SetModel("models/cultist/humans/mog/mog_woman_capt.mdl")
        else
          survivor:SetModel("models/cultist/humans/mog/mog.mdl")
          if survivor_table.bonemerge then
            for _, bnmrg in ipairs(survivor:LookupBonemerges()) do
              if bnmrg:GetModel():find("male_head") or bnmrg:GetModel():find("balaclava") then
                local copytext = bnmrg:GetSubMaterial(0)
                local bnmrg_new
                if survivor_table.bonemerge != true then
                  bnmrg_new = Bonemerge(survivor_table.bonemerge, survivor)
                else
                  bnmrg_new = Bonemerge(PickHeadModel(), survivor)
                end
                bnmrg_new:SetSubMaterial(0, copytext)
                bnmrg:Remove()
              end
            end
          end
        end
        survivor:ClearBodyGroups()
        survivor:SetupHands()
        if ( survivor_table.bodygroups ) then
          for id, value in pairs( survivor_table.bodygroups ) do
            survivor:SetBodygroup( id, value )
          end
        end
        survivor.ScaleDamage = survivor_table.damage_modifiers
        for i = 1, #survivor_table.weapon do
          local weapon = survivor_table.weapon[ i ]
          survivor:Give( weapon )
        end
        survivor:SetAmmo( survivor_table.ammo.quantity, survivor_table.ammo.type )
        survivor:AresNotify("l:weaponry_mtf_armor_pt1 ", gteams.GetColor(TEAM_GUARD), "l:weaponry_mtf_armor_pt2")
      end
    end

  end

end

if ( CLIENT ) then

  function ENT:Draw()

    self:DrawModel()

  end

end
