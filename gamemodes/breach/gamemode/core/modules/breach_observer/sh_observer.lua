BREACH.observer = BREACH.observer or {}
BREACH.observer.types = BREACH.observer.types or {}
BREACH.observer.renderall = true

if CLIENT then
    function BREACH.observer:RegisterESPType(type, func, optionName, optionNiceName, optionDesc, bDrawClamped)  
        BREACH.observer.types[string.lower(type)] = {string.lower(optionName) .. "ESP", func, bDrawClamped}
    end
    
    function BREACH.observer:ShouldRenderAnyTypes()
        for _, v in pairs(BREACH.observer.types) do
            if (BREACH.observer.renderall) then
                return true
            end
        end
    
        return false
    end
end