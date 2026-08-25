local settings = require("resources/database/settings")
local spells = require("resources/data/spells")

local events = {
    playerData = {
        inCombat = false,
        activeAspect = nil,
        combatStyle = nil,
        ultimates = {
            greaterSunshineUnlocked = nil,
            greaterDeathsSwiftnessUnlocked = nil
        },
        necromancy = {
            necrosisStacks = 0,
            residualSoulStacks = 0,
            livingDeath = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            bloat = {
                active = 0,
                remainingDuration = 0,
            },
            deathSparkStacks = 0,

            conjures = {
                skeletonWarrior = {
                    active = 0,
                    remainingDuration = 0,
                    stacks = 0
                },
                putridZombie = {
                    active = 0,
                    remainingDuration = 0,
                },
                vengefulGhost = {
                    active = 0,
                    remainingDuration = 0,
                },
                phantomGuardian = {
                    active = 0,
                    remainingDuration = 0,
                    stacks = 0
                }
            },

            incantations = {
                threadsOfFate = {
                    active = 0,
                    remainingDuration = 0,
                    cooldown = 0,
                },
                invokeDeath = {
                    active = 0,
                    remainingDuration = 0,
                    cooldown = 0,
                },
                splitSoul = {
                    active = 0,
                    remainingDuration = 0,
                    cooldown = 0,
                },
                darkness = {
                    active = 0,
                    remainingDuration = 0,
                    cooldown = 0,
                }
            }
        },
        magic = {
            activeSpell = {
                icon = '',
                name = ''
            },
            runicCharge = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            tsunami = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            sunshine = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            instability = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            soulfire = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            stacks = {
                exsanguinate = 0,
                incite_fear = 0
            }
        }
    }
}

local ULT_GREATER_DURATION = 62
local ULT_NORMAL_DURATION = 50

-- Used for Sunshine & Death's Swiftness checks
local function isPlantedFeetEquipped()
    local rank = var.VarPlayer.INVENT_PERK_PLANTEDFEET.value
    return rank ~= nil and rank > 0
end

local function getSunshineDuration()
    if events.playerData.ultimates.greaterSunshineUnlocked == 1
        or isPlantedFeetEquipped()
    then
        return ULT_GREATER_DURATION
    end

    return ULT_NORMAL_DURATION
end

local function getDeathsSwiftnessDuration()
    if events.playerData.ultimates.greaterDeathsSwiftnessUnlocked == 1
        or isPlantedFeetEquipped()
    then
        return ULT_GREATER_DURATION
    end

    return ULT_NORMAL_DURATION
end

-- New spells may be added in the future and since spells are hard-coded
-- rather than data driven, we need to do a nil check to make sure we have the data
local function updateActiveSpell(spellId)
    local spell = spells[spellId]

    -- Known Issue: This can result in stale state if a user sets an unsupported spell as active.
    -- Keeping this bug around means users will report it and I can update spells.lua faster :)
    if not spell then
        local lastKnownSpell = settings.Get('lastKnownActiveSpell')
        if lastKnownSpell then
            local spell = spells[lastKnownSpell]            
            events.playerData.magic.activeSpell.name = spell.name
            events.playerData.magic.activeSpell.icon = spell.icon
        end
        return
    end

    events.playerData.magic.activeSpell.name = spell.name
    events.playerData.magic.activeSpell.icon = spell.icon
    settings.Set('lastKnownActiveSpell', spell)
end

local function swapGaugeToCombatStyle(style)
    settings.Set('lastKnownCombatStyle', style)
    if settings.Get('automaticallySwapGauge') == 'dynamic' then
        events.playerData.combatStyle = style
    end
end

local function handleLivingDeath(event)
    if event.oldValue == -1 then
        events.playerData.necromancy.livingDeath.active = 1
        events.playerData.necromancy.livingDeath.remainingDuration = 50

        swapGaugeToCombatStyle('necromancy')
    else
        events.playerData.necromancy.livingDeath.active = 0
        events.playerData.necromancy.livingDeath.remainingDuration = 0
        events.playerData.necromancy.livingDeath.cooldown = 100
    end
end

local function handleRunicCharge(event)
    if event.oldValue == 0 and event.newValue == 1 then
        events.playerData.magic.runicCharge.active = 1
        events.playerData.magic.runicCharge.remainingDuration = 25
        events.playerData.magic.runicCharge.cooldown = 50

        swapGaugeToCombatStyle('magic')
    else
        events.playerData.magic.runicCharge.active = 0
        events.playerData.magic.runicCharge.remainingDuration = 0
    end
end

local function handleSunshine(event)
    events.playerData.magic.sunshine.active = 1
    events.playerData.magic.sunshine.remainingDuration = getSunshineDuration()
    events.playerData.magic.sunshine.cooldown = 100

    swapGaugeToCombatStyle('magic')
end

local function handleSoulfire(event)
    events.playerData.magic.soulfire.active = 1
    events.playerData.magic.soulfire.remainingDuration = 0
    events.playerData.magic.soulfire.cooldown = 75

    swapGaugeToCombatStyle('magic')
end

local function handleInstability(event)
    events.playerData.magic.instability.active = 1
    events.playerData.magic.instability.remainingDuration = 50
    events.playerData.magic.instability.cooldown = 100

    swapGaugeToCombatStyle('magic')
end

local function handleTsunami(event)
    if event.oldValue == 0 and event.newValue == 1 then
        events.playerData.magic.tsunami.active = 1
        events.playerData.magic.tsunami.remainingDuration = 50
        events.playerData.magic.tsunami.cooldown = 100

        swapGaugeToCombatStyle('magic')
    end
end

-- Treats the player as 'Out of Combat' if they bank, so the gauge doesn't block the bank UI
local function handleBank()
    events.playerData.inCombat = false
end

local function handleLastCastSpell(event)
    updateActiveSpell(event.newValue)
end

local VAR_TRANSMIT_HANDLERS = {
    COMBATV2_BUFF_NECROMANCY_UNDEAD_INSTINCT_ABILITY_STRUCT = handleLivingDeath,
    COMBATV2_BUFF_MAGIC_WRACK_ACTIVE = handleRunicCharge,
    COMBATV2_COOLDOWN_MAGIC_SUNSHINE_START = handleSunshine,
    COMBATV2_ABILITY_WEAPON_COOLDOWN_SOULFIRE_START = handleSoulfire,
    COMBATV2_ABILITY_WEAPON_COOLDOWN_INSTABILITY_START = handleInstability,
    COMBATV2_BUFF_MAGIC_CRITICAL_STRIKE_ADRENALINE_EFFECT = handleTsunami,

    BANK_TEMP = handleBank,
    LASTCASTSPELL = handleLastCastSpell,
}

local COOLDOWN_RESET_MAP  = {
    COMBATV2_COOLDOWN_NECROMANCY_DEATH_TOUCH_END =
        events.playerData.necromancy.livingDeath,

    COMBATV2_COOLDOWN_MAGIC_SUNSHINE_END =
        events.playerData.magic.sunshine,

    COMBATV2_COOLDOWN_MAGIC_TSUNAMI_END =
        events.playerData.magic.tsunami,

    COMBATV2_ABILITY_WEAPON_COOLDOWN_INSTABILITY_END =
        events.playerData.magic.instability,

    COMBATV2_ABILITY_WEAPON_COOLDOWN_SOULFIRE_END =
        events.playerData.magic.soulfire,
}

-- The user can reset their cooldowns at the Altar of War. The altar does this
-- by setting all _END values to 0, forcing them to be off cooldown.
local function handleCooldownReset(event)
    if event.newValue ~= 0 then
        return
    end

    local ability = COOLDOWN_RESET_MAP [event.var.configName]

    if ability then
        ability.cooldown = 0
    end
end

local function decrementTimers(tbl)
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            decrementTimers(value)

        elseif (key == "remainingDuration" or key == "cooldown")
            and type(value) == "number"
            and value > 0 then

            tbl[key] = value - 1

            -- Force inactive if the ability is active but has no remaining duration and no remaining cooldown
            -- this is necessary because some abilities (non-Necromancy ultimates) don't transmit anything when they end, unlike Living Death
            if (tbl.active == 1 and tbl.remainingDuration == 0 and tbl.cooldown == 0) then
                tbl.active = 0
            end
        end
    end
end

local function getRemainingTicks(startVar, endVar)
    return var.VarPlayer[endVar].value - var.VarPlayer[startVar].value 
end

local function updateInCombatState()
    events.playerData.inCombat = 
        var.VarClient["COMBATV2_TARGET_SIDE_PANEL_HEALTH"].value > 0
end

local function updateNecromancyResources()
    local necromancy = events.playerData.necromancy

    necromancy.necrosisStacks =
        var.VarPlayer["COMBATV2_BUFF_NECROMANCY_NECROSIS_STACKS"].value

    necromancy.residualSoulStacks =
        var.VarPlayer["COMBATV2_BUFF_NECROMANCY_RESIDUAL_SOUL_STACKS"].value

    necromancy.deathSparkStacks =
        var.VarPlayer["COMBATV2_BUFF_NECRO_RASIAL_ARMGUARD_T95_PASSIVE_STACKS"].value
end

local CONJURE_DEFINITIONS = {
    skeletonWarrior = {
        activeVar = "COMBATV2_ABILITY_NECROMANCY_CONJURE_SKELETON_WARRIOR_ACTIVE",
        startVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_SKELETON_WARRIOR_START",
        endVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_SKELETON_WARRIOR_END",
        stacksVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_SKELETON_WARRIOR_STACKS",
    },

    putridZombie = {
        activeVar = "COMBATV2_ABILITY_NECROMANCY_CONJURE_PUTRID_ZOMBIE_ACTIVE",
        startVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_PUTRID_ZOMBIE_START",
        endVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_PUTRID_ZOMBIE_END",
    },

    vengefulGhost = {
        activeVar = "COMBATV2_ABILITY_NECROMANCY_CONJURE_VENGEFUL_GHOST_ACTIVE",
        startVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_VENGEFUL_GHOST_START",
        endVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_VENGEFUL_GHOST_END",
    },

    phantomGuardian = {
        activeVar = "COMBATV2_ABILITY_NECROMANCY_CONJURE_PHANTOM_GUARDIAN_ACTIVE",
        startVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_PHANTOM_GUARDIAN_START",
        endVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_PHANTOM_GUARDIAN_END",
        stacksVar = "COMBATV2_BUFF_NECROMANCY_SPIRIT_PHANTOM_GUARDIAN_STACKS",
    },
}

local function updateConjure(name, definition)
    local conjure = events.playerData.necromancy.conjures[name]

    conjure.active = var.VarPlayer[definition.activeVar].value

    if conjure.active == 1 and conjure.remainingDuration <= 0 then
        local remainingTicks = getRemainingTicks(
            definition.startVar,
            definition.endVar
        )

        conjure.remainingDuration = math.max(0, remainingTicks)

        swapGaugeToCombatStyle('necromancy')

    elseif conjure.active == 0 then
        conjure.remainingDuration = 0
    end

    if definition.stacksVar then
        conjure.stacks = var.VarPlayer[definition.stacksVar].value

        if conjure.active == 0 then
            conjure.stacks = 0
        end
    end
end

local function updateConjures()
    for name, definition in pairs(CONJURE_DEFINITIONS) do
        updateConjure(name, definition)
    end
end

local function updateIncantations()
    local incantations = events.playerData.necromancy.incantations

    incantations.threadsOfFate.active =
        var.VarPlayer["COMBATV2_BUFF_NECROMANCY_THREADS_OF_FATE_ACTIVE"].value

    incantations.darkness.active =
        var.VarPlayer["COMBATV2_BUFF_NECROMANCY_DARKNESS_ACTIVE"].value

    incantations.invokeDeath.active =
        var.VarPlayer["COMBATV2_TARGET_SIDE_PANEL_TARGET_DEATH_MARK"].value

    incantations.splitSoul.active =
        var.VarPlayer["COMBATV2_BUFF_NECROMANCY_SPLIT_SOUL_ACTIVE"].value

    if (incantations.threadsOfFate.active == 1 or incantations.invokeDeath.active == 1 or incantations.splitSoul.active == 1) then
        swapGaugeToCombatStyle('necromancy')
    end
end

local function updateBloat()
    local bloat = events.playerData.necromancy.bloat

    local bloatIsActive = 
        var.VarPlayer["COMBATV2_TARGET_SIDE_PANEL_TARGET_NECROMANCY_BLOATED"].value

    -- This is intentionally "fuzzy" in that it completely resets the duration if Bloat is re-applied before it falls off
    -- the player cannot always know when their target was Bloated, such as during Group Content. If the debuff is seen around
    -- was previously not seen, it is assumed to be fresh. When it falls off - the bar will immediately display 0s remaining.
    -- This makes it useful to know that Bloat needs to be re-applied, but the timer is only guaranteed to be accurate in solo content
    -- when a player does not re-apply the debuff before it falls off.
    if bloat.active == 0 and bloatIsActive == 1 then
        bloat.remainingDuration = 33
        bloat.active = bloatIsActive
    elseif bloat.remainingDuration == 0 and bloatIsActive == 1 then
        bloat.remainingDuration = 33
    elseif bloatIsActive == 0 then
        bloat.active = 0
        bloat.remainingDuration = 0
    end

end

local function updateNecromancy()
    updateNecromancyResources()
    updateConjures()
    updateIncantations()
    updateBloat()
end

local function checkGreaterUnlocks()
    events.playerData.ultimates.greaterSunshineUnlocked = 
        var.VarPlayer["COMBATV2_ABILITY_MAGIC_GREATER_SUNSHINE_UNLOCKED"].value

    events.playerData.ultimates.greaterDeathsSwiftnessUnlocked = 
        var.VarPlayer["COMBATV2_ABILITY_RANGED_GREATER_DEATHS_SWIFTNESS_UNLOCKED"].value
end

local weaponCategories = {
    [id.Category.WEAPON_STAFF]      = "magic",
    [id.Category.WEAPON_ELEMENTAL]  = "magic",
    [id.Category.WEAPON_WAND]       = "magic",

    [id.Category.WEAPON_THROWN]     = "ranged",
    [id.Category.WEAPON_ARTILLERY]  = "ranged",
    [id.Category.WEAPON_CHARGEBOW]  = "ranged",
    [id.Category.WEAPON_GRENADE]    = "ranged",
    [id.Category.WEAPON_JAVELIN]    = "ranged",
    [id.Category.WEAPON_XBOW]       = "ranged",
    [id.Category.WEAPON_BOW]        = "ranged",
    [id.Category.WEAPON_2HXBOW]     = "ranged",
    [id.Category.WEAPON_THROWNDART] = "ranged",
    [id.Category.WEAPON_THROWNAXE]  = "ranged",
    [id.Category.WEAPON_THROWNKNIFE] = "ranged",
    [id.Category.WEAPON_BLOWPIPE]   = "ranged",

    [id.Category.WEAPON_HACKSWORD]  = "melee",
    [id.Category.WEAPON_STABSWORD]  = "melee",
    [id.Category.WEAPON_BLUNT]      = "melee",
    [id.Category.WEAPON_AXE]        = "melee",
    [id.Category.WEAPON_SPEAR]      = "melee",
    [id.Category.WEAPON_SPIKED]     = "melee",
    [id.Category.WEAPON_BANNER]     = "melee",
    [id.Category.WEAPON_FUN]        = "melee",
    [id.Category.WEAPON_HEAVYSWORD] = "melee",
    [id.Category.WEAPON_CLAW]       = "melee",
    [id.Category.WEAPON_POLEARM]    = "melee",
    [id.Category.WEAPON_PICK]       = "melee",
    [id.Category.WEAPON_WHIP]       = "melee",
    [id.Category.WEAPON_SHORTSWORD] = "melee",
    [id.Category.WEAPON_LONGSWORD]  = "melee",
    [id.Category.WEAPON_WARHAMMER]  = "melee",
    [id.Category.WEAPON_BATTLEAXE]  = "melee",
    [id.Category.WEAPON_DAGGER]     = "melee",
    [id.Category.WEAPON_SCIMITAR]   = "melee",
    [id.Category.WEAPON_MACE]       = "melee",
    [id.Category.WEAPON_2HSWORD]    = "melee",
    [id.Category.WEAPON_MAUL]       = "melee",
    [id.Category.WEAPON_CLAWS]      = "melee",
    [id.Category.WEAPON_2H_SWORD]   = "melee",
    [id.Category.WEAPON_PICKAXE]    = "melee",
    [id.Category.WEAPON_HALBERD]    = "melee",
    [id.Category.WEAPON_MATTOCK]    = "melee",

    [id.Category.WEAPON_ARMGUARD]   = "necromancy",
}

local checkOnce = false

local function updatePlayerData()
    updateInCombatState()
    updateNecromancy()

    if (not checkOnce) then
        checkGreaterUnlocks()
        updateActiveSpell(var.VarPlayer["LASTCASTSPELL"].value)
        swapGaugeToCombatStyle(settings.Get('lastKnownCombatStyle'))
        checkOnce = true
    end

end

local function updateCombatStyle()
    if settings.Get('automaticallySwapGauge') ~= 'mainhand' then return end

    local worn = Inventory.Find(config.Inv.WORN)
    local wornObj = worn:GetSlot(4)

    if wornObj and wornObj.obj then
        local wornObjCategory = id.Category.FromID(wornObj.obj.category)
        if wornObjCategory == nil then return end

        local combatStyle = weaponCategories[id.Category[wornObjCategory]]

        if combatStyle then
            events.playerData.combatStyle = combatStyle
            settings.Set("lastKnownCombatStyle", combatStyle)
            log(combatStyle)
        end
    end
end

Event.GameStateChanged.Subscribe("dataInitialization", function()
    if GameState.FromID(gameStateChangedEvent.newState) == 30 then
        checkGreaterUnlocks()
        updateActiveSpell(var.VarPlayer["LASTCASTSPELL"].value)
        swapGaugeToCombatStyle(settings.Get('lastKnownCombatStyle'))
    end
end)

Event.VarTransmit.Subscribe("cooldownTracking", function(event)
    -- Ignore anything that hasn't changed value
    if event.oldValue == event.newValue then
        return
    end

    local handler = VAR_TRANSMIT_HANDLERS[event.var.configName]
    if handler then
        handler(event)
    end

    handleCooldownReset(event)
end)

Event.ServerLogic.Subscribe("decrementCooldowns", function()
    decrementTimers(events.playerData)
end)
Event.Logic.Subscribe("updatePlayerData", function() 
    updatePlayerData()
end)
Event.ServerLogic.Subscribe("wornMainhand", function() 
    updateCombatStyle()
end)

return events
