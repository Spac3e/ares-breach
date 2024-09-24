local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local pcall = pcall;
local unpack = unpack;
local tonumber = tonumber;
local tostring = tostring;
local ents = ents;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player
-- gamemodes/breach/gamemode/modules/util/sh_util.lua
-- Retrieved by https://github.com/lewez/glua-steal
--[BDerma Utilities]--
--[Custom Derma for Br menu]
local blurScreen = Material("pp/blurscreen")
local EMeta = FindMetaTable( "Entity" )
local WMeta = FindMetaTable( "Weapon" )
BREACH = BREACH || {}

function EMeta:GetBodyGroupsString()

    local bodygroups = self:GetBodyGroups()
    local curstr = ""

    for _, bg in ipairs(bodygroups) do
        curstr = curstr..tostring(self:GetBodygroup(bg.id))
    end

    return curstr

end

function WMeta:PlaySequence( seq_id, idle )

  if ( !idle ) then

    self.IdlePlaying = false

  end

  if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) ) then return end

	local vm = self.Owner:GetViewModel()

  if ( !( vm && vm:IsValid() ) ) then return end

	if ( isstring( seq_id ) ) then

		seq_id = vm:LookupSequence( seq_id )

	end

  vm:SetCycle( 0 )
  vm:SetPlaybackRate( 1.0 )
	vm:SendViewModelMatchingSequence( seq_id )

end

function BDerma_BackGround(panel, starttime)

  local Fraction = 1
  if (starttime) then
    Fraction = math.Clamp( (SysTime() - starttime) / 1, 0, 1)
  end
  DisableClipping(true)
  local X, Y = 0, 0
  local scrW, scrH = ScrW(), ScrH()
  surface.SetDrawColor(255, 255, 255)
  surface.SetMaterial(blur)

  for i=0.33, 1, 0.33 do
    blur:SetFloat("$blur", (i / 3) * (amount or 6))
    blur:Recompute()
    render.UpdateScreenEffectTexture()
    render.SetScissorRect(x, y, x + w, y + h, true)
    surface.DrawTexturedRect(X * -1, Y * -1, scrW, scrH)
    render.SetScissorRect(0, 0, 0, 0, false)
  end
end

function BREACH.FindPlayer( name )

  name = string.lower( name );

  for _, v in player.Iterator() do

    if ( string.find( string.lower( v:Nick() ), name ) ) then

      return v;

    end

    if ( ( string.lower( v:SteamID() ) ) == name ) then

      return v;

    end

  end

end


BREACH.Utils = {}
BREACH.Utils.TimeUnits = {}

do

	local minuteSecond = 60
	local hourSecond = 60 * minuteSecond
	local daySecond = 24 * hourSecond
	local weekSecond = 7 * daySecond
	local monthSecond = 30 * daySecond
	local yearSecond = 12 * monthSecond
	local centurySecond = 100 * yearSecond
	local millenniumSecond = 10 * centurySecond

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "mi",
		NameSignular = "millennium",
		NamePlural = "millennia",
		Seconds = millenniumSecond
	})

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "c",
		NameSignular = "century",
		NamePlural = "centuries",
		Seconds = centurySecond
	})

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "y",
		NameSignular = "year",
		NamePlural = "years",
		Seconds = yearSecond
	})

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "M",
		NameSignular = "month",
		NamePlural = "months",
		Seconds = monthSecond
	})

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "w",
		NameSignular = "week",
		NamePlural = "weeks",
		Seconds = weekSecond
	})

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "d",
		NameSignular = "day",
		NamePlural = "days",
		Seconds = daySecond
	})

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "h",
		NameSignular = "hour",
		NamePlural = "hours",
		Seconds = hourSecond
	})

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "m",
		NameSignular = "minute",
		NamePlural = "minutes",
		Seconds = minuteSecond
	})

	table.insert(BREACH.Utils.TimeUnits, {
		NameSingle = "s",
		NameSignular = "second",
		NamePlural = "seconds",
		Seconds = 1
	})

end

function util.FormatTime( seconds, depth )

  if ( !isnumber( seconds ) ) then return seconds end

  local units = BREACH.Utils.TimeUnits

  if ( seconds < units[ #units ].Seconds ) then

    return "zero " .. units[ #units ].NameSignular

  end

  depth = depth || 0

  local txt = {}

  for _, v in ipairs( units ) do

    if ( seconds >= v.Seconds ) then

      local count = math.floor( seconds / v.Seconds )
      seconds = seconds - count * v.Seconds

      if ( count > 1 ) then

        txt[ #txt + 1 ] = count .. " " .. v.NamePlural

      else

        txt[ #txt + 1 ] = "one " .. v.NameSignular

      end

      if ( depth > 0 ) then

        depth = depth - 1

        if ( depth < 1 ) then break end

      end

    end

  end

  local str = table.concat( txt, ", ", 1, #txt - 1 )

  if ( #str > 0 ) then

    str = str .. " and "

  end

  return str .. txt[ #txt ]

end

function sql.GetColumns(name)
  local rows = newMysql.queryValue("SELECT sql FROM sqlite_master WHERE name = '" .. name .. "'")
  if ( !rows ) then
    return {}
  end
  rows = string.sub(rows, 16 + string.len(name), -2)
  local expld = string.Explode(",", rows)
  result = {}
  for _, v in pairs(expld) do
    v = string.Trim(v)
    local columns = string.Explode(" ", v)[1]
    if (columns[1] == "\"" && columns[#columns] == "\"") then
      columns = columns:sub(columns, 2, -2)
    end

    table.insert(result, string.lower(columns))
  end

  return result
end

function string.ConvertToTime(str)
  local units = BREACH.Utils.TimeUnits
  local seconds = 0
  local valid = false
  for unit, timeUnit in string.gmatch(str, "([%d-]+)%s*(%a+)") do

    unit = tonumber(unit)
    if ( !unit ) then return end


    for _, v in pairs(units) do
      if (timeUnit == v.NameSingle || timeUnit == v.NameSignular || timeUnit == v.NamePlural) then
        valid = true
        seconds = seconds + unit * v.Seconds
      end
    end

    if ( !valid ) then return end

  end

  if ( !valid ) then return end

  return seconds
end


function string.GetArguments(txt, limit)

  local args = {}

  for k, v in pairs(string.Explode('"', txt)) do

    if ( k % 2 ) == 0 then

      table.insert( args, v )

    else

      for _, v in ipairs( string.Explode( " ", v ) ) do

        if ( #v > 0 ) then

          table.insert( args, v )

        end

      end

    end

  end

  if ( limit && #args > limit ) then

    args[ limit ] = table.concat( args, " ", limit )

    for i = limit + 1, #args do

      args[ i ] = nil

    end

  end

  return args
end

function string.UpperizeFirst(str)

  return string.upper(str[1]) .. str:sub(2)

end

function boolean_to_number( value )

  return value && 1 || 0

end

function table.NiceConcat(tab)
  if ( #tab > 1 ) then

    local str = tab[ 1 ]

    for i = 2, #tab - 1 do

      str = str .. ", " .. tab[ i ]

    end

    return str .. " and " .. tab[ #tab ]

  elseif ( #tab == 1 ) then

    return tab[ 1 ]

  else

    return ""

  end

end

function util.IsPlayer(ply)

  return IsEntity(ply) && ply:IsValid() && ply:IsPlayer()

end

function util.IsSpectator( ply )

  return ply:GTeam() == TEAM_SPEC

end

function util.DoNothing() end

local totable = string.utf8ToTable
local string_len = utf8.len

local string_sub = utf8.sub

local string_find = string.find

function string.utf8ToTable( str )

  local tbl = {}



  for i = 1, string_len( str ) do



    tbl[ i ] = string_sub( str, i, i )



  end



  return tbl


end

local Eng_Alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}

function util.PickRandomLetter(capitalize)
  if capitalize then
    local ran = math.random(1, 2)
    if ran == 1 then return string.upper(Eng_Alphabet[math.random(1, #Eng_Alphabet)]) end
  end
  return Eng_Alphabet[math.random(1, #Eng_Alphabet)]
end

local Ran_Symb = {'!', '@', '#', '$', '%', '^', '&', '*', ';', ':', "/", "?"}

function util.Symb_PickRandomLetter()
  return Ran_Symb[math.random(1, #Ran_Symb)]
end

local Rus_Alphabet = {'а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я'}

function util.Ru_PickRandomLetter(capitalize)
  if capitalize then
    local ran = math.random(1, 2)
    if ran == 1 then return string.upper(Rus_Alphabet[math.random(1, #Rus_Alphabet)]) end
  end
  return Rus_Alphabet[math.random(1, #Rus_Alphabet)]
end

function util.Encrypt_Text(text, rus)
  local explodedtext = string.Explode(" ", text)
  local Encrypted_txt = ""
  for _, text in pairs(explodedtext) do
    if text:StartWith(":") and text:EndsWith(":") then Encrypted_txt = Encrypted_txt..text.." " continue end
    local encryptext = ""
    for i = 1, #text do
      encryptext = encryptext..util.Symb_PickRandomLetter()
    end
     Encrypted_txt = Encrypted_txt..encryptext.." "
  end
  return Encrypted_txt
end


function string.utf8Explode( separator, str, withpattern )


  if ( separator == "" ) then return string.utf8ToTable( str ) end

  if ( withpattern == nil ) then withpattern = false end



  local ret = {}

  local current_pos = 1



  for i = 1, string_len( str ) do



    local start_pos, end_pos = string_find( str, separator, current_pos, !withpattern )



    if ( !start_pos ) then break end



    ret[ i ] = string_sub( str, current_pos, start_pos - 1 )

    current_pos = end_pos + 1



  end



  ret[ #ret + 1 ] = string_sub( str, current_pos )



  return ret

end

if ( EMeta ) then

  local modelBoneCache = {}

  if ( SERVER ) then

    function EMeta:SetupBones()

    end

  end

  function EMeta:GetClosestBone( pos )

    local biggestDist = math.huge
    local b

    for i = 0, self:GetBoneCount() - 1 do

      local p = self:GetBoneCenter( i )
      local d = pos:Distance( p )

      if ( d < biggestDist ) then

        biggestDist = d
        d = i

      end

    end

    return b

  end

  function EMeta:GetClosestPhysicsEnabledBone( pos )

    local bonelist = {}

    for i = 0, self:GetBoneCount() - 1 do

      local p = self:GetBoneCenter( i )
      local d = pos:Distance( p )

      if ( d < biggestDist ) then

        biggestDist = d
        b = i

      end

    end

    return b

  end

  function EMeta:GetClosestPhysicsEnabledBone( pos )

    local bonelist = {}

    for i = 0, self:GetBoneCount() - 1 do

      local phys = self:TranslateBoneToPhysBone( i )

      if ( !table.HasValue( bonelist, phys ) ) then

        bonelist[ #bonelist + 1 ] = i

      end

    end

    return self:GetClosestBoneInList( pos, bonelist )

  end

  function EMeta:GetClosestBoneInList( pos, list )

    if ( !list ) then return self:GetClosestBone( pos ) end

    local biggestDist = math.huge
    local b = parentBone

    for _, boneName in ipairs( list ) do

      local bone = self:LookupBone( boneName )

      if ( bone ) then

        local p = self:GetBoneCenter( bone )
        local d = pos:Distance( p )

        if ( d < biggestDist ) then

          biggestDist = d
          b = bone

        end

      end

    end

    if ( !b ) then return self:GetClosestBone( pos ) end

    return b

  end

  function EMeta:GetBoneCenter( bone )

    self:SetupBones()
    local rootpos, rootang = self:GetBonePosition( bone )
    local t = self:GetChildBones( bone )

    if ( #t == 1 ) then

      local p = self:GetBonePosition( t[1] )
      if ( self:BoneHasFlag( t[1], BONE_USED_BY_VERTEX_MASK ) ) then return end

    else

      local par = self:GetBoneParent( bone )

      if ( par && par != -1 ) then

        local parpos = self:GetBonePosition( par )

        return rootpos + self:BoneLength( bone ) * ( rootpos - parpos ):GetNormalized() / 2

      end

    end

    return rootpos + self:BoneLength( bone ) * rootang:Forward() / 2

  end

  function EMeta:GetChildBonesRecursive( bone )

    local mdl = self:GetModel()

    if ( !modelBoneCache[mdl] ) then

      modelBoneCache[mdl] = {}

    end

    local mdlT = modelBoneCache[mdl]

    if ( mdlT[bone] ) then

      return mdlT[bone]

    else

      if ( isstring( bone ) ) then

        bone = self:LookupBone( bone )

        if ( !bone ) then

          mdlT[bone] = {}

          return mdlT[bone]

        end

      end

      self:SetupBones()

      local t = {}
      t[ #t + 1 ] = bone
      local childBones = self:GetChildBones( bone )

      for _, childBone in ipairs( childBones ) do

        local tAppend = self:GetChildBonesRecursive( childBone )

        for _, b in ipairs( tAppend ) do

          t[ #t + 1 ] = b

        end

      end

      mdlT[ bone ] = t

      return t

    end

  end

end


if ( CLIENT ) then


  net.Receive( "CreateClientParticleSystem", function()



    local p_ent = net.ReadEntity()



    if ( !( p_ent && p_ent:IsValid() ) ) then return end



    local s_effect = net.ReadString()

    local n_attachtype = net.ReadUInt( 3 )

    local n_attachmentid = net.ReadUInt( 7 )

    local vec_offset = net.ReadVector() || vector_origin

    local infinite = net.ReadBool() || false

    local life_time = net.ReadUInt( 8 ) || 0



    if ( p_ent.Client_ParticleSystem && p_ent.Client_ParticleSystem:IsValid() ) then



      p_ent.Client_ParticleSystem:StopEmission( false, false, false )



    end



    p_ent.Client_ParticleSystem = CreateParticleSystem( p_ent, s_effect, n_attachtype, n_attachmentid, vec_offset )

    p_ent.Client_ParticleSystem:StartEmission( infinite )



    if ( life_time > 0 ) then



      timer.Simple( life_time, function()



        if ( p_ent && p_ent:IsValid() && p_ent.Client_ParticleSystem && p_ent.Client_ParticleSystem:IsValid() ) then



          p_ent.Client_ParticleSystem:StopEmission( false, false, false )



        end



      end )



    end



  end )



end