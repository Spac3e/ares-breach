local table = table

function table.SafeMerge(to, from)
	local oldIndex, oldIndex2 = to.__index, from.__index

	to.__index = nil
	from.__index = nil
		table.Merge(to, from)
	to.__index = oldIndex
	from.__index = oldIndex2
end

function table.Slice(tbl, start, endpos)
	for i = start, endpos do
		table.remove(tbl, start)
	end
end

local function _helper(t, a, b, fn)
    if b < a then return end
    local p = a
    for i = a + 1, b do
        if fn(t[i], t[p]) then
            if i == p + 1 then t[p], t[p + 1] = t[p + 1], t[p]
            else t[p], t[p + 1], t[i] = t[i], t[p], t[p + 1] end
            p = p + 1
        end
    end
    _helper(t, a, p - 1, fn)
    _helper(t, p + 1, b, fn)
end

function table.Sort(t, fn)
    _helper(t, 1, #t, fn)
end

function table.Populate( num )
	local tab = {}

	for i = 1, num do
		tab[i] = i
	end

	return tab
end

function table.CreateLookup( tab, alt )
	local result = {}

	for k, v in pairs( tab ) do
		if alt then
			result[v] = k
		else
			result[v] = true
		end
	end

	return result
end

function table.Round( tab )
	for k, v in pairs( tab ) do
		if istable( v ) then
			table.Round( v )
		elseif isnumber( v ) then
			tab[k] = math.Round( v )
		end
	end
end

function table.AddTables( tab1, tab2 )
	for k, v in pairs( tab2 ) do
		if tab1[k] and istable( v ) then
			table.AddTables( tab1[k], v )
		else
			tab1[k] = v
		end
	end
end

function table.Contains(tbl, key)
	for _, val in pairs(tbl) do
		if val == key then
			return true
		end
	end
	return false
end

--[[-------------------------------------------------------------------------
rpairs
---------------------------------------------------------------------------]]
local function rpairs_iter( tab, i )
	i = i - 1
	local v = tab[i]

	if v then
		return i, v
	end
end

function rpairs( tab, i )
	return rpairs_iter, tab, (i or #tab) + 1
end