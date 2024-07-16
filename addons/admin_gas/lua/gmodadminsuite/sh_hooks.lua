GAS_Hooking = GAS_Hooking or {
	HookTable = {},
	Superiors = {},
	Feedbacks = {},
	Inferiors = {},
}
GAS.Hooking = GAS_Hooking

function GAS.Hooking:OverrideHooks(hook_name)
	GAS.Hooking.HookTable[hook_name] = GAS.Hooking.HookTable[hook_name] or {}
	GAS:InitPostEntity(function()
		local hook_tbl = hook.GetTable()[hook_name]
		if (hook_tbl ~= nil) then
			for hook_identifier, hook_func in pairs(hook_tbl) do
				GAS.Hooking.HookTable[hook_name][hook_identifier] = hook_func
				hook.Remove(hook_name, hook_identifier)
			end
		end
		GAS:hook(hook_name, "GAS_Overriding_Hook", function(...)
			-- call the superior hooks
			-- if they return a value, always return it
			if (GAS.Hooking.Superiors[hook_name] ~= nil) then
				for hook_identifier, hook_func in pairs(GAS.Hooking.Superiors[hook_name]) do
					local my_return = {hook_func(...)}
					if (#my_return > 0) then
						return unpack(my_return)
					end
				end
			end

			-- call the regular hooks
			-- don't return their value(s), store them for later
			local their_finishing_return
			for hook_identifier, hook_func in pairs(GAS.Hooking.HookTable[hook_name]) do
				local their_return = {hook_func(...)}
				if (#their_return > 0) then
					their_finishing_return = their_return
					break
				end
			end

			-- if there are no feedback hooks or inferior hooks, return the regular value(s) (if any)
			if (GAS.Hooking.Feedbacks[hook_name] == nil and GAS.Hooking.Inferiors[hook_name] == nil) then
				if (their_finishing_return ~= nil) then
					return unpack(their_finishing_return)
				else
					return
				end
			end

			-- call the feedback hooks with the regular value(s) as the first argument
			-- if they return a value, always return it
			if (GAS.Hooking.Feedbacks[hook_name] ~= nil) then
				for hook_identifier, hook_func in pairs(GAS.Hooking.Feedbacks[hook_name]) do
					local my_return = {hook_func(their_finishing_return, ...)}
					if (#my_return > 0) then
						return unpack(my_return)
					end
				end
			end

			-- if there are no regular value(s), call the inferior hooks, otherwise, return the regular value(s)
			-- if they return a value, always return it
			if (their_finishing_return == nil) then
				if (GAS.Hooking.Inferiors[hook_name] ~= nil) then
					for hook_identifier, hook_func in pairs(GAS.Hooking.Inferiors[hook_name]) do
						local my_return = {hook_func(...)}
						if (#my_return > 0) then
							return unpack(my_return)
						end
					end
				end
			else
				return unpack(their_finishing_return)
			end
		end)
	end)
end

--# Superior hooking #--
-- "call my hooks before any others, and override their return value(s) with mine"

function GAS.Hooking:SuperiorHook(hook_name, identifier, func)
	if (GAS.Hooking.HookTable[hook_name] == nil) then
		GAS.Hooking:OverrideHooks(hook_name)
	end
	GAS.Hooking.Superiors[hook_name] = GAS.Hooking.Superiors[hook_name] or {}
	GAS.Hooking.Superiors[hook_name][identifier] = func
end

--# Feedback hooking #--
-- "call others' hooks before mine, but pass their return value(s) to my hook function and override their return value(s) with mine"

function GAS.Hooking:FeedbackHook(hook_name, identifier, func)
	if (GAS.Hooking.HookTable[hook_name] == nil) then
		GAS.Hooking:OverrideHooks(hook_name)
	end
	GAS.Hooking.Feedbacks[hook_name] = GAS.Hooking.Feedbacks[hook_name] or {}
	GAS.Hooking.Feedbacks[hook_name][identifier] = func
end

--# Inferior hooking #--
-- "call others' hooks before mine, and override my return value(s) with theirs"

function GAS.Hooking:InferiorHook(hook_name, identifier, func)
	if (GAS.Hooking.HookTable[hook_name] == nil) then
		GAS.Hooking:OverrideHooks(hook_name)
	end
	GAS.Hooking.Inferiors[hook_name] = GAS.Hooking.Inferiors[hook_name] or {}
	GAS.Hooking.Inferiors[hook_name][identifier] = func
end

-- backwards compatibility with old hooking lib
GAS.InferiorHook = GAS.Hooking.InferiorHook
GAS.SuperiorHook = GAS.Hooking.SuperiorHook

--[=[
--# Superior hooking #--

GAS_Logging_SuperiorHooks = GAS_Logging_SuperiorHooks or {}
function GAS:SuperiorHook(hook_name, identifier, func)
	local function Hook()
		GAS:hook(hook_name, identifier, function(...)
			local my_return = func(...)
			if (my_return ~= nil) then
				return my_return
			end
			for _,hook_func in pairs(GAS_Logging_SuperiorHooks[hook_name]) do
				local other_return = hook_func(...)
				if (other_return ~= nil) then
					return other_return
				end
			end
		end)
	end

	if (not GAS_Logging_SuperiorHooks[hook_name]) then
		GAS_Logging_SuperiorHooks[hook_name] = {}
		GAS:InitPostEntity(function()
			local hook_table = hook.GetTable()[hook_name]
			if (hook_table) then
				for hook_identifier, hook_func in pairs(hook_table) do
					hook.Remove(hook_name, hook_identifier)
					GAS_Logging_SuperiorHooks[hook_name][hook_identifier] = hook_func
				end
			end
			Hook()
		end)
	else
		Hook()
	end
end

--# Inferior Hooking #--

GAS_Logging_InferiorHooks = GAS_Logging_InferiorHooks or {}
function GAS:InferiorHook(hook_name, identifier, func)
	local function Hook()
		GAS:hook(hook_name, identifier, function(...)
			local finishing_return
			for _,hook_func in pairs(GAS_Logging_InferiorHooks[hook_name]) do
				local other_return = hook_func(...)
				if (other_return ~= nil) then
					finishing_return = other_return
					break
				end
			end
			if (finishing_return == nil) then
				local my_return = func(...)
				return my_return
			else
				return finishing_return
			end
		end)
	end

	if (GAS_Logging_InferiorHooks[hook_name] == nil) then
		GAS_Logging_InferiorHooks[hook_name] = {}
		GAS:InitPostEntity(function()
			local hook_table = hook.GetTable()[hook_name]
			if (hook_table) then
				for hook_identifier, hook_func in pairs(hook_table) do
					hook.Remove(hook_name, hook_identifier)
					GAS_Logging_InferiorHooks[hook_name][hook_identifier] = hook_func
				end
			end
			Hook()
		end)
	else
		Hook()
	end
end

--# Inferior Feedback Hooking #--

function GAS:InferiorFeedbackHook(hook_name, identifier, func)
	local function Hook()
		GAS:hook(hook_name, identifier, function(...)
			local finishing_return
			for _,hook_func in pairs(GAS_Logging_InferiorHooks[hook_name]) do
				local other_return = hook_func(...)
				if (other_return ~= nil) then
					finishing_return = other_return
					break
				end
			end
			local my_return = func(finishing_return, ...)
			if (my_return ~= nil) then
				return my_return
			else
				return finishing_return
			end
		end)
	end

	if (GAS_Logging_InferiorHooks[hook_name] == nil) then
		GAS_Logging_InferiorHooks[hook_name] = {}
		GAS:InitPostEntity(function()
			local hook_table = hook.GetTable()[hook_name]
			if (hook_table) then
				for hook_identifier, hook_func in pairs(hook_table) do
					hook.Remove(hook_name, hook_identifier)
					GAS_Logging_InferiorHooks[hook_name][hook_identifier] = hook_func
				end
			end
			Hook()
		end)
	else
		Hook()
	end
end
]=]