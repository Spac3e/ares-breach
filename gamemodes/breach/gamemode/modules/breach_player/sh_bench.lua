--[[
MIT License

Copyright (c) 2022 Aleksandrs Filipovskis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local tableInsert = table.insert
local tableSort = table.sort

local MsgC = MsgC
local ipairs = ipairs
local SysTime = SysTime

local colorWhite = color_white
local colorGreen = Color(0, 255, 0)
local colorRed = Color(255, 0, 0)

-- ANCHOR Wrapper

local WRAPPER = {}
WRAPPER.__index = WRAPPER

function WRAPPER:SetTitle(title)
    self.title = title

    return self
end

function WRAPPER:SetCalls(calls)
    self.calls = calls

    return self
end

function WRAPPER:SetJitDisabled(bool)
    self.jitDisabled = bool

    return self
end

function WRAPPER:AddFunction(id, func)
    tableInsert(self.data, {
        id = id,
        func = func
    })

    return self
end

function WRAPPER:AddResult(id, runtime)
    tableInsert(self.results, {
        id = id,
        runtime = runtime
    })
end

function WRAPPER:SortResults()
    tableSort(self.results, function(res1, res2)
        return res1.runtime < res2.runtime
    end)
end

function WRAPPER:PrintResults()
    MsgC(colorWhite, "= BENCHMARK =\n")

    if (self.title) then
        MsgC(colorWhite, "Title: " .. (self.title) .. "\n")
    end

    MsgC(colorWhite, jit.version .. ": " .. (self.jitDisabled and "Disabled" or "Enabled") .. "\n")
    MsgC(colorWhite, "Calls: " .. string.Comma(self.calls) .. "\n")
    MsgC(colorWhite, "Arch: " .. jit.arch .. "\n")
    MsgC(colorWhite, "Results: \n")

    local first = self.results[1].runtime

    for pos, data in ipairs(self.results) do
        local posColor = (pos == 1 and colorGreen or colorRed)
        local slowText = (pos > 1 and " (" .. (data.runtime / first * 100 - 100) .. "% slower)" or "")

        MsgC(posColor, (pos .. ". \"" .. data.id .. "\""), colorWhite, ":\t" .. tostring(data.runtime) .. slowText)
        Msg("\n")
    end

    Msg("\n")
end

function WRAPPER:Run(func, calls)
    local start = SysTime()

    for i = 1, calls do
        func()
    end

    local delta = SysTime() - start

    return delta
end

function WRAPPER:Start()
    if (table.IsEmpty(self.data)) then
        return
    end

    local calls = self.calls

    if (self.jitDisabled) then
        jit.off()
    end

    for _, method in ipairs(self.data) do
        local id = method.id
        local func = method.func
        local runtime = self:Run(func, calls)

        self:AddResult(id, runtime)
    end

    if (self.jitDisabled) then
        jit.on()
    end

    self:SortResults()
    self:PrintResults()
end

-- ANCHOR Methods

function gbench()
    return setmetatable({
        data = {},
        stack = {},
        results = {},
        calls = 1000
    }, WRAPPER)
end