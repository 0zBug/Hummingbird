
local Connections, Yeilds = {}, {}

local Time = os.clock()

local namecall
namecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local s = os.clock() - Time

    for i, v in next, Connections do
        v.Function(s)
    end

    for Index, Yield in next, Yeilds do
        local Elapsed = Time - Yield[1]
        if Elapsed >= Yield[2] then
            table.remove(Yeilds, Index)
            coroutine.resume(Yield[3], Elapsed)
        end
    end

    Time = os.clock()

    return namecall(...)
end))

return {
    Connect = function(self, Function)
        local Connection = {
            Function = Function,
            Id = #Connections + 1,
            Disconnect = function(Connection)
                table.remove(Connections, Connection.Id)
            end
        }

        Connections[Connection.Id] = Connection

        return Connection
    end,
    Wait = function(self, Time)
        local Time = (type(t) ~= "number" or Time < 0) and 0 or Time
        table.insert(Yeilds, {os.clock(), Time, coroutine.running()})
        return coroutine.yield()
    end
}
