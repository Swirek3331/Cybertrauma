NTCT = {}
NTCT.Name = "Cybertrauma"
NTCT.Version = "0.2"
NTCT.Path = table.pack(...)[1]
Timer.Wait(function() if NTC ~= nil and NTC.RegisterExpansion ~= nil then NTC.RegisterExpansion(NTCT) end end,1)

if (Game.IsMultiplayer and SERVER) or not Game.IsMultiplayer then

    Timer.Wait(function()
        if NTC == nil then
            print("Error loading Cybertrauma: It appears Neurotrauma isn't loaded!")
            return
        end

        if NTCyb == nil then
           print("Error loading Cybertrauma: It appears NT Cybernetics isn't loaded!")
           return
        end

        dofile(NTCT.Path .. "/Lua/Scripts/main.lua")
    end, 1)
end