---@diagnostic disable: undefined-field
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

shell.run("clear")
print("\nMade by Kevinb5")
local tab_validInput = {"right", "left", "down", "up", "front", "back"}

print("On what side do you have your modem, ex:[right, left, down, up, front, back]\n")
local input = io.read()
local success = false
if has_value(tab_validInput, input) then
    local args_scanner = fs.open("myGps/orientation.txt", "w")
    args_scanner.writeLine(input);
    args_scanner.close();
    print("\nDone!")
    shell.run("clear")
    success = true
     
else
    print("Invalid input")
    os.reboot()
end

if (success) then
    print("Do you wish to run this computer to run as a client or server\n0 -> client\n1 -> server")
    local input = tonumber(io.read())
    if (input == 0) then
        local args_scanner = fs.open("myGps/serverIds.txt", "w")
        for i=1,3,1 do
            print("Insert server" .. i .. "'s ID")
            local string = io.read()
            args_scanner.writeLine(string)
        end
        args_scanner.close()
    elseif (input == 1) then
        print("What are your coordinates? ex:[x, y]")
        local coordinatesString = io.read()
        local coordinatesTable = split(coordinatesString, ", ")
        local x = coordinatesTable[1]
        local y = coordinatesTable[2]
        local args_scanner = fs.open("myGps/coordinates.txt", "w")
        args_scanner.writeLine(x)
        args_scanner.writeLine(y)
        args_scanner.close()
        shell.run("wget ") --get the startup file
        print("Done!")
    end
end
