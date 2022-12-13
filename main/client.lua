ComputerIds = {}
DistanceToServers = {}
CoordinatesOfServers = {}

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function getIds()
    local ListcomputerIds = {}

    if file_exists("myGps/serverIds.txt") then
        local args_scanner = fs.open("myGps/serverIds.txt","r")
        for i=1,3,1 do
            ListcomputerIds[i] = tonumber(args_scanner.readLine())
        end
        args_scanner.close()
    else
        print("serverIds.txt file does not exist")
        --exit later
    end

    return ListcomputerIds[1], ListcomputerIds[2], ListcomputerIds[3]

end

local function getModemSide()
    local args_scanner = fs.open("myGps/orientation.txt","r")
    local side = args_scanner.readLine()
    args_scanner.close()
    return side
end

local function insertId(id, distance, table)
    if(id == ComputerIds.id1)  then
        table.server1 = distance
    elseif (id == ComputerIds.id2) then
        table.server2 = distance
    elseif (id == ComputerIds.id3) then
        table.server3 = distance
    end
end

function trackPhone(x1,y1,r1,x2,y2,r2,x3,y3,r3)
    local A = 2*x2 - 2*x1
    local B = 2*y2 - 2*y1
    local C = math.pow(r1,2) - math.pow(r2,2) - math.pow(x1,2) + math.pow(x2,2) - math.pow(y1,2) + math.pow(y2,2)
    local  D = 2*x3 - 2*x2
    local  E = 2*y3 - 2*y2
    local  F = math.pow(r2,2) - math.pow(r3,2) - math.pow(x2,2) + math.pow(x3,2) - math.pow(y2,2) + math.pow(y3,2)
    local  x = (C*E - F*B) / (E*A - B*D)
     local  y = (C*D - A*F) / (B*D - A*E)
    return x,y
end

function locate()

    rednet.open(getModemSide())

    for i=1,3,1 do
        rednet.send(os.getComputerID(), {"Proceed"}, os.getComputerLabel())
    end

    for i=1,3,1 do
        local senderId, message, distance, protocol = rednet.receive()
        insertId(senderId, distance, DistanceToServers)
        insertId(senderId, message, CoordinatesOfServers)
    end

    rednet.close(getModemSide())

    local x, y = trackPhone(CoordinatesOfServers.server1[1], CoordinatesOfServers.server1[2], DistanceToServers.server1, CoordinatesOfServers.server2[1], CoordinatesOfServers.server2[2], DistanceToServers.server2, CoordinatesOfServers.server3[1], CoordinatesOfServers.server3[2], DistanceToServers.server3 )
    return x,y
end

-- Main --

ComputerIds.id1, ComputerIds.id2, ComputerIds.id3 = getIds()


