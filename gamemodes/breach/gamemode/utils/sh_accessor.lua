function BREACH.Accessor(meta, key, name, type)
    name = name or (string.upper(string.Left(key, 1)) .. string.sub(key, 2))

    local function getter(self)
        return self[key]
    end

    meta["Get" .. name] = getter

    if type == FORCE_BOOL then
        meta["Is" .. name] = getter
    end

    meta["Set" .. name] = function(self, value)
        self[key] = value
        return self
    end
end