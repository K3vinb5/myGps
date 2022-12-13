ClientId = -1
local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function getModemSide()
    local side
    local args_scanner = fs.open("myGps/orientation.txt","r")
    side = args_scanner.readLine()
    args_scanner.close()
    return side;
end

local function getCoordinates()
    local x, y
    local args_scanner = fs.open("myGps/coordinates.txt", "r")
    x = tonumber(args_scanner.readLine())
    y = tonumber(args_scanner.readLine())
    args_scanner.close()
    return x, y
end

local function sendMessage()
    
    rednet.open(getModemSide())

    rednet.send(ClientId, getCoordinates(), os.getComputerLabel())

    rednet.close(getModemSide())
end

local function receiveMessage()

    rednet.open(getModemSide())

    local senderId, message, protocol = rednet.receive()
    ClientId = senderId
    rednet.close(getModemSide())
    sendMessage()
    
    return "Request by: " .. senderId
end

-- Main
local lastRequest = ""
while (true) do
    print("My id is: " .. os.getComputerID() .. "\n\nWaiting for requests...")
    print("Last request: " .. lastRequest)
    lastRequest = receiveMessage()
end