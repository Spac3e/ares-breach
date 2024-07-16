local isAutoRefresh = GAS_Hooking ~= nil

GAS_Hooking = GAS_Hooking or {
	Superiors = {},
	Feedbacks = {},
	Inferiors = {},
	Observers = {},
	Listening = {}
}
GAS.Hooking = GAS_Hooking

--# Superior hooking #--
-- "call my hooks before any others, and override their return value(s) with mine"

function GAS.Hooking:SuperiorHook(hook_name, identifier, func)
	GAS.Hooking.Superiors[hook_name] = GAS.Hooking.Superiors[hook_name] or {}
	GAS.Hooking.Superiors[hook_name][identifier] = func
	GAS.Hooking.Listening[hook_name] = true
end

--# Feedback hooking #--
-- "call others' hooks before mine, but pass their return value(s) to my hook function and override their return value(s) with mine"

function GAS.Hooking:FeedbackHook(hook_name, identifier, func)
	GAS.Hooking.Feedbacks[hook_name] = GAS.Hooking.Feedbacks[hook_name] or {}
	GAS.Hooking.Feedbacks[hook_name][identifier] = func
	GAS.Hooking.Listening[hook_name] = true
end

--# Inferior hooking #--
-- "call others' hooks before mine, and override my return value(s) with theirs"

function GAS.Hooking:InferiorHook(hook_name, identifier, func)
	GAS.Hooking.Inferiors[hook_name] = GAS.Hooking.Inferiors[hook_name] or {}
	GAS.Hooking.Inferiors[hook_name][identifier] = func
	GAS.Hooking.Listening[hook_name] = true
end

--# Observer hooking #--
-- "call my hook before anything else, but don't allow it to override any return values"

function GAS.Hooking:ObserverHook(hook_name, identifier, func)
	GAS.Hooking.Observers[hook_name] = GAS.Hooking.Observers[hook_name] or {}
	GAS.Hooking.Observers[hook_name][identifier] = func
	GAS.Hooking.Listening[hook_name] = true
end

-- backwards compatibility with old hooking lib
GAS.InferiorHook = GAS.Hooking.InferiorHook
GAS.SuperiorHook = GAS.Hooking.SuperiorHook

if isAutoRefresh then return end

GAS:InitPostEntity(function() timer.Simple(1, function()

	GAS_HOOK_CALL = GAS_HOOK_CALL or hook.Call
	local GAS_HOOK_CALL = GAS_HOOK_CALL

	local GAS_Hooking = GAS_Hooking
	
	local function my_hook_call(name, gm, ...)
		if GAS_Hooking.Listening[name] then
			if GAS_Hooking.Observers[name] then
				for _, v in pairs(GAS_Hooking.Observers[name]) do
					v(...)
				end
			end

			if GAS_Hooking.Superiors[name] then
				for _, v in pairs(GAS_Hooking.Superiors[name]) do
					local my_return = {v(...)}
					if #my_return > 0 then
						return unpack(my_return)
					end
				end
			end

			local their_return = {GAS_HOOK_CALL(name, gm, ...)}

			if GAS_Hooking.Feedbacks[name] then
				for _, v in pairs(GAS_Hooking.Feedbacks[name]) do
					local my_return = {v(their_return, ...)}
					if #my_return > 0 then
						return unpack(my_return)
					end
				end
			end

			if GAS_Hooking.Inferiors[name] then
				for _, v in pairs(GAS_Hooking.Inferiors[name]) do
					v(...)
				end
			end

			return unpack(their_return)
		else
			return GAS_HOOK_CALL(name, gm, ...)
		end
	end

	local visited = {}
	local function find(tbl)
		for k,v in pairs(tbl) do
			if v == hook.Call then
				tbl[k] = my_hook_call
				return
			elseif istable(v) and not visited[v] then
				visited[v] = true
				return find(tbl)
			end
		end
	end
	find(debug.getregistry())

	_G.hook.Call = my_hook_call

end) end)
