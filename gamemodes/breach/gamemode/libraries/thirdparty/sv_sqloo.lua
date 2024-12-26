local success = pcall(require, "mysqloo")

if (not success) then
    error("MySQLOO Isn't installed so, database won't work properly.")
    return
end

sqloo = sqloo or {}

local colorWhite = color_white
local colorSuccess = Color(0, 255, 0)
local colorError = Color(255, 0, 0)

local function prepareArguments(query, lastIsCallback, ...)
    local count = select("#", ...)

    if (count > 0) then
        local lastArgument, callback

        if (lastIsCallback) then
            lastArgument = select(count, ...)

            if (isfunction(lastArgument)) then
                callback = lastArgument
                count = count - 1
            end
        end

        for i = 1, count do
            local arg = select(i, ...)

            if (arg == nil) then
                query:setNull(i)
            elseif (isnumber(arg)) then
                query:setNumber(i, arg)
            elseif (isbool(arg)) then
                query:setBoolean(i, arg)
            else
                query:setString(i, tostring(arg))
            end
        end

        if (lastIsCallback and callback) then
            query.onSuccess = function(self, data)
                callback(data, self)
            end
        end
    end
end

local TRANSACTION = {}
TRANSACTION.__index = TRANSACTION

function TRANSACTION:Query(str)
    local query = self.database.handler:query(str)

    self.handler:addQuery(query)

    return self
end

function TRANSACTION:Start(callback)
    local obj = self.handler

    if (callback) then
        obj.onSuccess = function(query, data)
            callback(data, query)
        end
    end

    obj.onError = function(query, errorText)
        self.database:Error(errorText, query)
    end

    obj.onAborted = obj.onError

    obj:start()
end

local DATABASE = {}
DATABASE.__index = DATABASE
DATABASE.__tostring = function(self)
    return (self.schema .. "@" .. self.hostname)
end

AccessorFunc(DATABASE, "connected", "Connected")

function DATABASE:Log(text)
    MsgC(Color(200, 200, 0), "[MySQL] ", colorWhite, tostring(self), " -> ", text, "\n")
end

function DATABASE:Error(text)
    MsgC(Color(200, 200, 0), "[MySQL] ", colorError, "[ERROR] ", colorWhite, tostring(self), " -> ", text, "\n")
end

function DATABASE:Success(text)
    MsgC(Color(200, 200, 0), "[MySQL] ", colorSuccess, "[SUCCESS] ", colorWhite, tostring(self), " -> ", text, "\n")
end

function DATABASE:Query(str, callback)
    local obj = self.handler:query(str)

    if (callback) then
        obj.onSuccess = function(query, data)
            callback(data, query)
        end
    end

    obj.onError = function(query, errorText)
        self:Error(errorText)
    end

    obj.onAborted = obj.onError

    obj:start()

    return obj
end

function DATABASE:Transaction()
    local handler = self.handler:createTransaction()

    local transaction = setmetatable({
        database = self,
        handler = handler
    }, TRANSACTION)

    return transaction
end

function DATABASE:Escape(escape)
    return self.handler:escape(tostring(escape))
end

function sqloo.Create(hostname, username, password, schema, port, socket)
    local id = util.CRC(hostname .. "_" .. schema)
    local db = setmetatable({
        hostname = hostname,
        username = username,
        schema = schema,
        port = port,
        id = id
    }, DATABASE)

    db.handler = mysqloo.connect(hostname, username, password, schema, port, socket)
    db.handler.onConnected = function(handler)
        handler:setCharacterSet("utf8mb4")

        db:SetConnected(true)

        hook.Run("sqloo.OnConnected", db)
    end
    db.handler.onConnectionFailed = function(handler, errorText)
        db:Error(errorText)
    end

    db.handler:connect()

    timer.Create("sqloo.Ping_" .. id, 300, 0, function()
        db.handler:ping()
    end)

    return db
end