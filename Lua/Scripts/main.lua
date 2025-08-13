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

local limbs = {
    LimbType.RightArm,
    LimbType.LeftArm,
    LimbType.RightLeg,
    LimbType.LeftLeg
}

local organs = {
    "ntc_cyberliver",
    "ntc_cyberkidney",
    "ntc_cyberlung",
    "ntc_cyberheart",
    "ntc_cyberbrain"
}

local function isInTable(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

--better chances needs to be done
local function cyberifyPerson(character)

    local shuffledLimbs = {}
    for i = 1, #limbs do
        table.insert(shuffledLimbs, limbs[i])
    end
    
    -- Fisher-Yates shuffle algorithm
    for i = #shuffledLimbs, 2, -1 do
        local j = math.random(i)
        shuffledLimbs[i], shuffledLimbs[j] = shuffledLimbs[j], shuffledLimbs[i]
    end

    local cyberLimbs = math.random(1, 4)
    
    for i = 1, cyberLimbs do
        NTCyb.CyberifyLimb(character, shuffledLimbs[i])
    end

    --organs
    --some bug happens:
    --organs are not given
    --masive error apears in console

    --sometimes there won't be any organs
    local cyberOrgans = math.random(0, 5)

    if cyberOrgans == 0 then
        --debug
        print("No cyber organs will be given to " .. character.Name)
        return
    end

    local shuffledOrgans = {}

    for i = 1, #organs do
        table.insert(shuffledOrgans, organs[i])
    end

    for i = #shuffledOrgans, 2, -1 do
        local j = math.random(i)
        shuffledOrgans[i], shuffledOrgans[j] = shuffledOrgans[j], shuffledOrgans[i]
    end

    for i = 1, cyberOrgans do
        --50% means augmented, 100% fully cybernetic
        local percent = 100

        if math.random() < 0.75 then
            percent = 50
        end

        shuffledOrgans[i] = shuffledOrgans[i]

        --to prevent brain from locating intself in torso
        -- `SetAffliction` uses torso as a default limb
        if shuffledOrgans[i] == "ntc_cyberbrain" then
            HF.SetAfflictionLimb(character, shuffledOrgans[i], LimbType.Head, percent)
        else
            HF.SetAffliction(character, shuffledOrgans[i], percent)
        end
        --debug
        print("Given " .. shuffledOrgans[i] .. " to " .. character.Name .. " with " .. percent .. "%")

    end

end

local allHumans = {}
local cyborgs = {}

Hook.Add("roundStart", "NTCT", function ()
    Timer.Wait(function ()

        --get all humans except crew members, and "canonical" characters
        for character in Character.CharacterList do
            if not character.IsOnPlayerTeam and character.IsHuman and not isInTable(uniqueNPC, character.Name) then
                --debug
                --print("Found human character: " .. character.Name)
                table.insert(allHumans, character)
            end
        end

        --Must be changed and be depended on difficulty (the further you go, the harder the levels are, more cyborgs are spawned)
        local cyborgsAmount = math.random(0, #allHumans)

        --debug
        print("Cyborgs Amount: " .. cyborgsAmount)
        print("Humans Amount: " .. #allHumans)

        --there can be a scenario with no cyborgs to spawn
        if cyborgsAmount < 1 then
            print("No cyborgs")
            return
        end

        --assign random humans
        for i = 1, cyborgsAmount do
            local human = allHumans[math.random(1, #allHumans)]
            table.insert(cyborgs, human)
        end

        --debug
        print("All Humans: ")
        for _, human in ipairs(allHumans) do
            print(" - " .. human.Name)
        end

        --debug
        print("Cyborgs: ")
        for _, cyborg in ipairs(cyborgs) do
            print(" - " .. cyborg.Name)
        end

        --When I understood the weakness of my flesh, it disgusted me...
        for _, cyborg in ipairs(cyborgs) do
            cyberifyPerson(cyborg)
        end

    end, 1000)
end)
