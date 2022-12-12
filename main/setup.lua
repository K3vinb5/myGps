local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

shell.run("clear")
print("\nMade by Kevinb5")
local tab_validInput = {"right", "left", "down", "up", "front", "back"}

print("On what side do you have your modem, [ right, left, down, up, front, back ]\n")
local input = io.read()

if has_value(tab_validInput, input) then
    local args_scanner = fs.open("GPS/gps.txt", "w")
    args_scanner.writeLine(input);
    args_scanner.close();
    print("Done!")
else
    print("Invalid input")
    os.exit(1, true)
end

