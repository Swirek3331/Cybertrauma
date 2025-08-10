local uniqueNPC = { --I hope localization won't break this
    "Artie Dolittle",
    "Captain Hognose",
    "Ignatius May",
    "Aunt Doris",
    "Victoria Petran",
    "Sootman",
    "Jacov Subra",
    "Jestmaster",
    "Severo Ruiz",
    "Dr. af Grann"
}

local function isInTable(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

local allHumans = {}
local cyborgs = {}

Hook.Add("roundStart", "NTCT", function ()
    Timer.Wait(function ()

        for character in Character.CharacterList do
            if not character.IsOnPlayerTeam and character.IsHuman and not isInTable(uniqueNPC, character.Name) then
                print("Found human character: " .. character.Name)
                table.insert(allHumans, character)
            end
        end

        --Must be changed and be depended on difficulty (the further you go, the harder the levels are, more cyborgs are spawned)
        local cyborgsAmount = math.random(1, #allHumans)
        print("Cyborgs Amount: " .. cyborgsAmount)

        for i = 1, cyborgsAmount do
            local human = allHumans[math.random(1, #allHumans)]
            table.insert(cyborgs, human)
        end


        print("All Humans: ")
        for _, human in ipairs(allHumans) do
            print(" - " .. human.Name)
        end

        print("Cyborgs: ")
        for _, cyborg in ipairs(cyborgs) do
            print(" - " .. cyborg.Name)
        end

    end, 1000)
end)
