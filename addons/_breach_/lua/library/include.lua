local function includeSV(path) if SERVER then include(path) end end

local function includeCL(path) if SERVER then AddCSLuaFile(path) end if CLIENT then include(path) end end

local function includeSH(path) if SERVER then AddCSLuaFile(path) end include(path) end

function brlib.Include(strFile)
    if not strFile then
        return
    end

    if SERVER then
        if string.find(strFile, "cl_") then
            includeCL(strFile)
        elseif string.find(strFile, "sv_") then
            return includeSV(strFile)
        else
            return includeSH(strFile)
        end
    else
        if not string.find(strFile, "sv_") then
            return include(strFile)
        end
    end
end

local included = {}

function brlib.IncludeDir(strDir, bRecursive)
    if not strDir:EndsWith("/") then
        strDir = strDir .. "/"
    end
    
    if string.find(strDir, "_client") then
        local files, _ = file.Find(strDir .. "*.lua", "LUA", "namedesc")

        for k, v in ipairs(files) do
            if not included[v] then
                includeCL(strDir..v)
                included[v] = true
            end
        end
        return
    end

    if string.find(strDir, "_server") then
        local files, _ = file.Find(strDir .. "*.lua", "LUA", "namedesc")

        for k, v in ipairs(files) do
            if not included[v] then
                includeSV(strDir .. v)
                included[v] = true
            end
        end
        return
    end

    if bRecursive then
        local files, folders = file.Find(strDir .. "*", "LUA", "namedesc")
        
        for _, folder in ipairs(folders) do
            for _, File in ipairs(file.Find(strDir .. folder .. "/sh_*.lua", "LUA")) do
                if not included[File] then
                    brlib.Include(strDir .. folder .. "/" .. File)
                    included[File] = true
                end
            end
        end

        for _, folder in ipairs(folders) do
            for _, File in ipairs(file.Find(strDir .. folder .. "/sv_*.lua", "LUA")) do
                if not included[File] then
                    includeSV(strDir .. folder .. "/" .. File)
                    included[File] = true
                end
            end
        end

        for _, folder in ipairs(folders) do
            for _, File in ipairs(file.Find(strDir .. folder .. "/cl_*.lua", "LUA")) do
                if not included[File] then
                    includeCL(strDir .. folder .. "/" .. File)
                    included[File] = true
                end
            end
        end

        for k, v in ipairs(folders) do
            brlib.IncludeDir(strDir..v, bRecursive)
        end

        local files, _ = file.Find(strDir .. "*.lua", "LUA", "namedesc")

        for k, v in ipairs(files) do
            if not included[v] then
                brlib.Include(strDir..v)
                included[v] = true
            end
        end
    else
        local files, _ = file.Find(strDir .. "*.lua", "LUA", "namedesc")

        for k, v in ipairs(files) do
            if not included[v] then
                brlib.Include(strDir .. v)
                included[v] = true
            end
        end
    end
end
