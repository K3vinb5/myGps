
ComputerIds = {}
DistanceToServers = {server1=0, server2=0, server3=0}
CoordinatesOfServers = {server1x=0, server1y=0, server2x=0, server2y=0, server3x=0, server3y=0}

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

local function insertIdIntoDistance(id, distance)
    if(id == ComputerIds.id1)  then
        DistanceToServers.server1 = distance
    elseif (id == ComputerIds.id2) then
        DistanceToServers.server2 = distance
    elseif (id == ComputerIds.id3) then
        DistanceToServers.server3 = distance
    end
end


local function insertIdIntoCoordinates(id, coordinates)
    if(id == ComputerIds.id1)  then
        CoordinatesOfServers.server1x = coordinates[1]
        CoordinatesOfServers.server1y = coordinates[2]
    elseif (id == ComputerIds.id2) then
        CoordinatesOfServers.server2x = coordinates[1]
        CoordinatesOfServers.server2y = coordinates[2]
    elseif (id == ComputerIds.id3) then
        CoordinatesOfServers.server3x = coordinates[1]
        CoordinatesOfServers.server3y = coordinates[2]
    end
end

local function track(x1,y1,r1,x2,y2,r2,x3,y3,r3)
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

    
    rednet.send(ComputerIds.id1, {"Proceed"}, os.getComputerLabel())
    rednet.send(ComputerIds.id2, {"Proceed"}, os.getComputerLabel())
    rednet.send(ComputerIds.id3, {"Proceed"}, os.getComputerLabel())

    for i=1,3,1 do
        local senderId, x, y, distance, protocol = rednet.receive()
        local coordinates = {x,y}
        print(x)
        print(y)
        insertIdIntoDistance(senderId, distance )
        insertIdIntoCoordinates(senderId, coordinates)
    end

    rednet.close(getModemSide())

    local x, y = track(CoordinatesOfServers.server1x, CoordinatesOfServers.server1y, DistanceToServers.server1, CoordinatesOfServers.server2x, CoordinatesOfServers.server2y, DistanceToServers.server2, CoordinatesOfServers.server3x, CoordinatesOfServers.server3y, DistanceToServers.server3 )
    return x,y
end

-- Main --

ComputerIds.id1, ComputerIds.id2, ComputerIds.id3 = getIds()


