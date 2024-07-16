--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/sh_registry_tbl.lua

--]]

-- Optimization library
-- Helps with optimizing pairs() into ipairs() for some stuff
-- Basically just a table that makes sure there are no duplicates

AddCSLuaFile()

local setmetatable = setmetatable
local rawget = rawget
local rawset = rawset
local isnumber = isnumber

local function __index_func(self, i)
	if (isnumber(i)) then
		return rawget(self, "seq")[i]
	else
		return rawget(self, "kv")[i]
	end
end

local function __call_func(self, i, method)
	local kv = rawget(self, "kv")

	if (method == nil and kv[i] ~= nil) then -- remove

		local seq = rawget(self, "seq")
		local seq_i = rawget(self, "seq_i")
		local seq_r = rawget(self, "seq_r")
		
		kv[i] = nil
		seq[seq_r[i]] = nil
		for shift=seq_r[i]+1,seq_i do
			if (seq[shift] ~= nil) then
				seq_r[seq[shift]] = shift - 1
			end
			seq[shift-1] = seq[shift]
		end
		
		seq_r[i] = nil

		rawset(self, "seq_i", seq_i - 1)

	elseif (method ~= nil and kv[i] == nil) then -- add

		local seq = rawget(self, "seq")
		local seq_i = rawget(self, "seq_i")
		local seq_r = rawget(self, "seq_r")

		kv[i] = method
		seq[seq_i] = i
		seq_r[i] = seq_i

		rawset(self, "seq_i", seq_i + 1)

	end
end

local function ipairs_func(self)
	return ipairs(rawget(self, "seq"))
end

local function pairs_func(self)
	return pairs(rawget(self, "kv"))
end

local function ipairs_pop_func(self)
	local n, prev_n
	return function()
		n = self:len()
		if (n > 0) then
			assert(prev_n == nil or n < prev_n, "ipairs_pop requires element to always be popped")
			prev_n = n
			return n, rawget(self, "seq")[n]
		end
	end
end

local ipairs_poppy_func
do
	local active_ipairs_pop
	local function pop_func()
		active_ipairs_pop(rawget(active_ipairs_pop, "seq")[rawget(active_ipairs_pop, "poppy_i")], nil)
	end
	ipairs_poppy_func = function(self)
		self(NULL, nil)
		active_ipairs_pop = self
		rawset(self, "poppy_i", self:len() + 1)
		return function()
			rawset(self, "poppy_i", rawget(self, "poppy_i") - 1)
			if (rawget(self, "poppy_i") > 0) then
				return rawget(self, "poppy_i"), rawget(self, "seq")[rawget(self, "poppy_i")], pop_func
			end
		end
	end
end

local function len_func(self)
	self(NULL, nil)
	return rawget(self, "seq_i") - 1
end

local function sequential_func(self)
	self(NULL, nil)
	return rawget(self, "seq")
end

local function dictionary_func(self)
	self(NULL, nil)
	return rawget(self, "kv")
end

function GAS:Registry()
	local Registry = {
		seq = {},
		seq_i = 1,
		seq_r = {},
		kv = {},
		ipairs = ipairs_func,
		ipairs_pop = ipairs_pop_func,
		ipairs_poppy = ipairs_poppy_func,
		pairs = pairs_func,
		len = len_func,
		sequential = sequential_func,
		dictionary = dictionary_func
	}

	setmetatable(Registry, {
		__index = __index_func,
		__call = __call_func
	})
	
	return Registry
end