
--TOBE changed
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

local cyberthings = {
    LimbType.RightArm,
    LimbType.LeftArm,
    LimbType.RightLeg,
    LimbType.LeftLeg,
    "ntc_cyberliver",
    "ntc_cyberkidney",
    "ntc_cyberlung",
    "ntc_cyberheart",
    "ntc_cyberbrain"
}

local function chancePercentage(percentage)
    if math.random() * 100 < percentage then
        return true
    else
        return false
    end
end

local function isInTable(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

local function chanceForNextAugmentation(n)
    local a = 1.3

    --f\left(x\right)=100\cdot\left(\frac{1}{a}\right)^{x}
    return math.floor(100 * (1/a)^n)
end

local function addCyberOrgan(character, organ)
    local percent = 50

    if chancePercentage(25) then
        percent = 100
    end

    --`HF.SetAffliction` by default places affliction on torso, wich we don't want for cyberbrain
    if organ == "ntc_cyberbrain" then
        HF.SetAfflictionLimb(character, organ, LimbType.Head, percent)
    else
        HF.SetAffliction(character, organ, percent)
    end
end

local function cyberifyPerson(character)

    --Fisher–Yates shuffle
    local shuffled = {}

    for i = 1, #cyberthings do
        table.insert(shuffled, cyberthings[i])
    end

    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[i], shuffled[j]
    end

    --First augmentation is guaranteed, but every next one is 1.3 times unlikely
    for i = 1, #cyberthings do
        if chancePercentage(chanceForNextAugmentation(i - 1)) then
            local thing = table.remove(cyberthings, i)
            
            --organ
            if type(thing) == "string" then
                addCyberOrgan(character, thing)

            --limb
            else
                NTCyb.CyberifyLimb(character, thing)
            end
        else
            break
        end
    end
end

Hook.Add("roundStart", "NTCT", function ()
    Timer.Wait(function ()

        local chance = math.floor(Level.Loaded.Difficulty / 2)

        local humans = {}
        local cyborgs = {}

        --get all alive humans except crew members, and "canonical" characters
        for character in Character.CharacterList do
            if not character.IsOnPlayerTeam and character.IsHuman and not character.IsDead and not isInTable(uniqueNPC, character.Name) then
                table.insert(humans, character)

                if chancePercentage(chance) then
                    table.insert(cyborgs, character)
                end
            end
        end


        --debug
        print("Cyborgs Amount: " .. #cyborgs)
        print("Humans Amount: " .. #humans)

        --there can be a scenario with no cyborgs to spawn
        if #cyborgs < 1 then
            print("No cyborgs")
            return
        end

        --When I understood the weakness of my flesh, it disgusted me...
        for _, cyborg in ipairs(cyborgs) do
            cyberifyPerson(cyborg)
        end

    end, 1000)
end)
