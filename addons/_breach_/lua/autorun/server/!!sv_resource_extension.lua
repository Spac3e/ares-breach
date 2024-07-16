-- https://github.com/danielga/gm_stringtable
if not pcall( require, "stringtable" ) or (stringtable == nil) then
    MsgN( "Please install binnary module: https://github.com/danielga/gm_stringtable" )
    return
end

local function downloadables()
    return stringtable.Find( "downloadables" )
end

function resource.GetAll()
    local data = downloadables()
    if (data ~= nil) then
        return data:GetStrings()
    end
end

function resource.HasFile( path )
    local strings = resource.GetAll()
    for num = 0, #strings do
        if (strings[ num ] == path) then
            return true
        end
    end

    return false
end

function resource.HasWorkshop( wsid )
    local searchable = wsid .. ".gma"
    local strings = resource.GetAll()
    for num = 0, #strings do
        if (strings[ num ] == searchable) then
            return true
        end
    end

    return false
end

function resource.Clear()
    local data = downloadables()
    if (data ~= nil) then
        data:Lock( true )
        data:DeleteAllStrings()
        data:Lock( false )
    end
end

do

    local isstring = isstring
    function resource.RemoveWorkshop( wsid )
        if isstring( wsid ) then
            local searchable = wsid .. ".gma"
            local data = downloadables()
            if (data ~= nil) then
                local strings = data:GetStrings()
                data:Lock( true )
                data:DeleteAllStrings()

                for num = 0, #strings do
                    local str = strings[ num ]
                    if (str == nil) then continue end
                    if (str == searchable) then continue end
                    data:AddString( true, str )
                end

                data:Lock( false )
            end
        end

        if istable( wsid ) then
            local searchable = {}
            for num, workshopid in ipairs( wsid ) do
                table.insert( searchable, workshopid .. ".gma" )
            end

            local data = downloadables()
            if (data ~= nil) then
                local strings = data:GetStrings()
                data:Lock( true )
                data:DeleteAllStrings()

                for num = 0, #strings do
                    local str = strings[ num ]
                    if (str == nil) then continue end

                    local remove = false
                    for num, path in ipairs( searchable ) do
                        if (str == path) then
                            remove = true
                            break
                        end
                    end

                    if (remove) then continue end

                    data:AddString( true, str )
                end

                data:Lock( false )
            end
        end
    end

    function resource.RemoveFile( path )
        if isstring( path ) then
            local data = downloadables()
            if (data ~= nil) then
                local strings = data:GetStrings()
                data:Lock( true )
                data:DeleteAllStrings()

                for num = 0, #strings do
                    local str = strings[ num ]
                    if (str == nil) then continue end
                    if (str == path) then continue end
                    data:AddString( true, str )
                end

                data:Lock( false )
            end
        end

        if istable( path ) then
            local data = downloadables()
            if (data ~= nil) then
                local strings = data:GetStrings()
                data:Lock( true )
                data:DeleteAllStrings()

                for num = 0, #strings do
                    local str = strings[ num ]
                    if (str == nil) then continue end

                    local remove = false
                    for num, file_path in ipairs( path ) do
                        if (str == file_path) then
                            remove = true
                            break
                        end
                    end

                    if (remove) then continue end

                    data:AddString( true, str )
                end

                data:Lock( false )
            end
        end
    end

end

function resource.GetWorkshop()
    local workshop = {}

    for num, path in ipairs( resource.GetAll() ) do
        if (path:sub( #path - 3, #path ) == ".gma") then
            local file_name = string.GetFileFromFilename( path )
            table.insert( workshop, file_name:sub( 1, #file_name - 4 ) )
        end
    end

    return workshop
end

do

    resource.CAddWorkshop = resource.CAddWorkshop or resource.AddWorkshop

    function resource.AddWorkshop( workshopid )
        for num, wsid in ipairs( resource.GetWorkshop() ) do
            if (wsid == "") then
                resource.RemoveWorkshop( wsid )
            end

            if (wsid == workshopid) then return end
        end

        timer.Simple(0, function()
            local result = hook.Run( "OnWorkshopAdded", workshopid )
            if (result == nil) or (result == true) then
                resource.CAddWorkshop( workshopid )
            end
        end)
    end

end