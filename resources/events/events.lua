local settings = require("resources/database/settings")
local spells = require("resources/data/spells")
local weapons = require("resources/data/weapons")

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
            deathGrasp = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            deathEssence = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            soulCrush = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
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
            upkeep = {
                blood_tithe = {
                    stacks = 0,
                    remainingDuration = 0,
                    name = 'Blood Tithe'
                },
                incite_fear = {
                    stacks = 0,
                    remainingDuration = 0,
                    name = 'Incite Fear'
                },
                essence_corruption = {
                    stacks = 0,
                    remainingDuration = 0,
                    name = 'Essence Corruption'
                }
            }
        },
        ranged = {
            activeAmmo = {
                icon = 0,
                name = '',
                configName = '',
            },
            quiverAmmo = {
                icon = 0,
                name = '',
                configName = '',
            },
            arrows = {
                bikArrows = {
                    stacks = 0,
                    remainingDuration = 0,
                },
                wenArrows = {
                    stacks = 0,
                    remainingDuration = 0,
                },
                deathsporeArrows = {
                    stacks = 0,
                    remainingDuration = 0,
                },
                splinteringArrows = {
                    stacks = 0,
                    remainingDuration = 0,
                }
            },
            deathsSwiftness = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            crystalRain = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            splitSoul = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            searingWinds = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            shadowImbued = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            perfectEquilibrium = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
                stacks = 0,
            }
        },
        melee = {
            blackhole = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            igneousShowdown = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            bloodlust = {
                stacks = 0
            },
            chaosRoar = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            meteorStrike = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            },
            berserk = {
                active = 0,
                remainingDuration = 0,
                cooldown = 0,
            }
        }
    }
}

local ULT_GREATER_DURATION = 62
local ULT_NORMAL_DURATION = 50

local function getRemainingTicks(startVar, endVar)
    return var.VarPlayer[endVar].value - var.VarPlayer[startVar].value 
end

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

local function updateActiveSpell(spellId)
    if spellId == nil then
        events.playerData.magic.activeSpell.name = nil
        events.playerData.magic.activeSpell.icon = nil
        return
    end

    local spell = spells[spellId]

    if not spell then
        events.playerData.magic.activeSpell.name = nil
        events.playerData.magic.activeSpell.icon = nil
        return
    end

    events.playerData.magic.activeSpell.name = spell.name
    events.playerData.magic.activeSpell.icon = spell.icon
    settings.Set('playerState.activeSpell', spellId)
end

local function swapGaugeToCombatStyle(style)
    if settings.Get('generalSettings.automaticSwapping') == 'dynamic' then
        events.playerData.combatStyle = style
    end

    if settings.Get('playerState.combatStyle') ~= style then
        settings.Set('playerState.combatStyle', style)
    end
end

local function checkEquippedMainhand()
    if settings.Get('generalSettings.automaticSwapping') ~= 'mainhand' then return end

    local worn = Inventory.Find(config.Inv.WORN)
    local wornObj = worn:GetSlot(4)

    if wornObj and wornObj.obj then
        local wornObjCategory = id.Category.FromID(wornObj.obj.category)
        if wornObjCategory == nil then return end

        local combatStyle = weapons[id.Category[wornObjCategory]]

        if combatStyle then
            events.playerData.combatStyle = combatStyle
            settings.Set("playerState.combatStyle", combatStyle)
        end
    end
end

local function returnEquippedMainhand()
    local worn = Inventory.Find(config.Inv.WORN)
    local wornObj = worn:GetSlot(4)

    if wornObj and wornObj.obj then
        return wornObj.obj.configName
    end
    return nil
end

local function handleDeathGrasp(event)
    events.playerData.necromancy.deathGrasp.remainingDuration = 0
    events.playerData.necromancy.deathGrasp.cooldown = 50

    swapGaugeToCombatStyle('necromancy')
end

local function handleDeathEssence(event)
    events.playerData.necromancy.deathEssence.active = 1
    events.playerData.necromancy.deathEssence.remainingDuration = 50
    events.playerData.necromancy.deathEssence.cooldown = 100

    swapGaugeToCombatStyle('necromancy')
end

local function handleSoulCrush(event)
    events.playerData.necromancy.soulCrush.active = 1
    events.playerData.necromancy.soulCrush.remainingDuration = 50
    events.playerData.necromancy.soulCrush.cooldown = 100

    swapGaugeToCombatStyle('necromancy')
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

    -- When you have >1 Essence Corruption stacks there is a 30% chance to reset the cooldown of the 3 Magic bleeds (Combust, Corruption, Roar Special Attack)
    -- unlike War's Altar of War which resets _END variables to 0, the reset for Roar sets _END = _START so we need to detect that and set the cooldown to 0 when
    -- it happens
    if (var.VarPlayer["COMBATV2_ABILITY_WEAPON_COOLDOWN_SOULFIRE_END"].value == var.VarPlayer["COMBATV2_ABILITY_WEAPON_COOLDOWN_SOULFIRE_START"].value) then
        events.playerData.magic.soulfire.cooldown = 0
    else 
        events.playerData.magic.soulfire.cooldown = 75
    end
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

local function handleCrystalRain(event)
    events.playerData.ranged.crystalRain.remainingDuration = 0
    events.playerData.ranged.crystalRain.cooldown = 50

    swapGaugeToCombatStyle('ranged')
end

local function handleSplitSoul(event)
    events.playerData.ranged.splitSoul.active = 1
    events.playerData.ranged.splitSoul.remainingDuration = 25
    events.playerData.ranged.splitSoul.cooldown = 0 -- ECB has no Cooldown

    swapGaugeToCombatStyle('ranged')
end

local function handleDeathsSwiftness(event)
    events.playerData.ranged.deathsSwiftness.active = 1
    events.playerData.ranged.deathsSwiftness.remainingDuration = getDeathsSwiftnessDuration()
    events.playerData.ranged.deathsSwiftness.cooldown = 100

    swapGaugeToCombatStyle('ranged')
end

local function handleSearingWinds(event)
    events.playerData.ranged.searingWinds.active = 1
    events.playerData.ranged.searingWinds.remainingDuration = getRemainingTicks("COMBATV2_COOLDOWN_RANGED_GALESHOT_START", "COMBATV2_BUFF_RANGED_SEARING_WINDS_END")
    events.playerData.ranged.searingWinds.cooldown = 34

    swapGaugeToCombatStyle('ranged')
end

local function pauseSearingWinds(event)
    events.playerData.ranged.searingWinds.remainingDuration = events.playerData.ranged.searingWinds.remainingDuration + 1
end

local function handleShadowImbued(event)
    if event.newValue == 1 then
        events.playerData.ranged.shadowImbued.active = 1
        events.playerData.ranged.shadowImbued.remainingDuration = 50
        events.playerData.ranged.shadowImbued.cooldown = 100

        swapGaugeToCombatStyle('ranged')
    end
end

local function extendShadowImbued(event)
    if events.playerData.ranged.shadowImbued.remainingDuration > 0 and events.playerData.ranged.shadowImbued.remainingDuration < 49 then
        events.playerData.ranged.shadowImbued.remainingDuration = events.playerData.ranged.shadowImbued.remainingDuration + 6
        if events.playerData.ranged.shadowImbued.cooldown == 100 then
        events.playerData.ranged.shadowImbued.cooldown = events.playerData.ranged.shadowImbued.cooldown - 5
        end
    end
end

local function handlePerfectEquilibrium(event)
    events.playerData.ranged.perfectEquilibrium.active = 1
    events.playerData.ranged.perfectEquilibrium.cooldown = 0

    swapGaugeToCombatStyle('ranged')
end

local function handleSpecialAttacks(event)
    -- BOLG
    if returnEquippedMainhand():find("EGWD_ZAMORAK_BOSS_RANGED_WEAPON", 1, true) then
        events.playerData.ranged.perfectEquilibrium.remainingDuration = 50
    end

    -- ECB
    if returnEquippedMainhand():find("DUNGEON_ULTHVEN_2H_RANGED", 1, true) then
        handleSplitSoul(event)
    end
end

local function handleInciteFear(event)
    events.playerData.magic.upkeep.incite_fear.stacks = event.newValue
    if event.oldValue > 0 and event.newValue ~= 0 then
        events.playerData.magic.upkeep.incite_fear.remainingDuration = 34
    elseif event.newValue >= 1 then
        events.playerData.magic.upkeep.incite_fear.remainingDuration = 34
    else
        events.playerData.magic.upkeep.incite_fear.remainingDuration = 0
    end
end

local function handleBloodTithe(event)
    events.playerData.magic.upkeep.blood_tithe.stacks = event.newValue
    if event.oldValue > 0 and event.newValue ~= 0 then
        events.playerData.magic.upkeep.blood_tithe.remainingDuration = 34
    elseif event.newValue >= 1 then
        events.playerData.magic.upkeep.blood_tithe.remainingDuration = 34
    else
        events.playerData.magic.upkeep.blood_tithe.remainingDuration = 0
    end
end

local function handleEssenceCorruption(event)
    events.playerData.magic.upkeep.essence_corruption.stacks = event.newValue
    if event.oldValue > 0 and event.newValue ~= 0 then
        events.playerData.magic.upkeep.essence_corruption.remainingDuration = 50
    elseif event.newValue >= 1 then
        events.playerData.magic.upkeep.essence_corruption.remainingDuration = 50
    else
        events.playerData.magic.upkeep.essence_corruption.remainingDuration = 0
    end
end

-- When the player has maximum stacks for Exsanguinate or Incite Fear the VarTransmit stops transmitting the Stacks value
-- So to determine if the Timer should reset for the player's Stacks to be maintained - the activeSpell is checked and
-- the appropriate spell timer is reinitialized. The stacks are set because if the plugin is started when already at maximum stacks,
-- they display as `0` until you lose them and gain them again.
local function handleCappedStacks(event)
    local bloodTithe = var.VarPlayer["COMBATV2_BUFF_BLOOD_TITHE_STACKS"].value
    local glacialEmbrace = var.VarPlayer["COMBATV2_BUFF_GLACIAL_EMBRACE_STACKS"].value

    if events.playerData.magic.activeSpell.name == "Exsanguinate" and bloodTithe == 12 then
        events.playerData.magic.upkeep.blood_tithe.remainingDuration = 33
        events.playerData.magic.upkeep.blood_tithe.stacks = 12
    end

    if events.playerData.magic.activeSpell.name == "Incite Fear" and glacialEmbrace == 5 then
        events.playerData.magic.upkeep.incite_fear.remainingDuration = 33
        events.playerData.magic.upkeep.incite_fear.stacks = 5
    end

end

-- Similar to Exsanguinate and Incite Fear, the Roar of Awakening's Essence Corruption stacks stop transmitting at 100
-- so to determine whether the timer should restart to 30s, I check to see if the player has a Roar equipped when they use 
-- one of the Magic bleeds (Roar Weapon Special, Combust, or Corruption Blast) and restart the timer.
local function handleCappedEssenceCorruption(event)
    local essenceCorruption = var.VarPlayer["COMBATV2_BUFF_MAGIC_DEVOURER_T95_PASSIVE_STACKS"].value
    local equippedMainhand = returnEquippedMainhand()
    if equippedMainhand == nil then return end
    if equippedMainhand:find("MAGIC_DEVOURER_WAND_T95", 1, true) and essenceCorruption == 100 then
        events.playerData.magic.upkeep.essence_corruption.remainingDuration = 50
        events.playerData.magic.upkeep.essence_corruption.stacks = 100
    end
end

-- Melee Events

local function handleBlackhole(event)
    events.playerData.melee.blackhole.active = 1
    events.playerData.melee.blackhole.remainingDuration = 35
    events.playerData.melee.blackhole.cooldown = 100

    swapGaugeToCombatStyle('melee')
end

local function handleIgneousShowdown(event)
    events.playerData.melee.igneousShowdown.active = 1
    events.playerData.melee.igneousShowdown.remainingDuration = 0
    events.playerData.melee.igneousShowdown.cooldown = 100

    swapGaugeToCombatStyle('melee')
end

local function handleBloodlust(event)
    events.playerData.melee.bloodlust.stacks = event.newValue

    swapGaugeToCombatStyle('melee')
end

local function handleChaosRoar(event)
    if event.newValue == 0 then 
        events.playerData.melee.chaosRoar.active = 0
        events.playerData.melee.chaosRoar.remainingDuration = 0
    else 
        events.playerData.melee.chaosRoar.active = 1
        events.playerData.melee.chaosRoar.remainingDuration = 10
        events.playerData.melee.chaosRoar.cooldown = 100

    swapGaugeToCombatStyle('melee')
    end
end

local function handleChaosRoarUse(event)
    if event.oldValue == 46279 then
        events.playerData.melee.chaosRoar.active = 0
        events.playerData.melee.chaosRoar.remainingDuration = 0
    end
end

local function handleMeteorStrike(event)
    if event.newValue == 0 then 
        events.playerData.melee.meteorStrike.active = 0
        events.playerData.melee.meteorStrike.remainingDuration = 0
    else
        events.playerData.melee.meteorStrike.active = 1
        events.playerData.melee.meteorStrike.remainingDuration = 50
        events.playerData.melee.meteorStrike.cooldown = 100

        swapGaugeToCombatStyle('melee')
    end
end

-- Check for Vestment Robes to extend Berserk's timer
local function checkForVestmentsSetEffect()
    local THREE_SET_VESTMENTS = var.VarPlayer["COMBAT_SET_EGWD_ZAM_MELEE"].value
    return (THREE_SET_VESTMENTS >= 3)
end

-- Hits of Greater Flurry add +1 tick to Berserk, essentially pausing it similar to Rapid Fire & Imbue Shadows.
local function pauseBerserk(event)
    if event.newValue - event.oldValue == 1 then
        events.playerData.melee.berserk.remainingDuration = events.playerData.melee.berserk.remainingDuration + 1
    end
end

local function handleBerserk(event)
    local wearingVestmentsSet = checkForVestmentsSetEffect()

    if event.newValue == 1 then
        events.playerData.melee.berserk.active = 1
        events.playerData.melee.berserk.remainingDuration = 33
        if wearingVestmentsSet then events.playerData.melee.berserk.remainingDuration = 43 end
        events.playerData.melee.berserk.cooldown = 100
    elseif events.playerData.melee.berserk.remainingDuration == 0 then 
        events.playerData.melee.berserk.active = 0
        events.playerData.melee.berserk.remainingDuration = 0
    end

    swapGaugeToCombatStyle('melee')
end

-- Treats the player as 'Out of Combat' if they bank, so the gauge doesn't block the bank UI
local function handleBank()
    events.playerData.inCombat = false
end

local function handleLastCastSpell(event)
    updateActiveSpell(event.newValue)
end

local VAR_TRANSMIT_HANDLERS = {
    COMBATV2_COOLDOWN_WEAPON_NECRO_UNDERWORLD_ARMGUARD_T70_START = handleDeathGrasp,
    COMBATV2_COOLDOWN_WEAPON_NECRO_RASIAL_ARMGUARD_T95_START = handleDeathEssence,
    COMBATV2_COOLDOWN_WEAPON_NECRO_DEVOURER_ARMGUARD_T95_START = handleSoulCrush,
    COMBATV2_BUFF_NECROMANCY_UNDEAD_INSTINCT_ABILITY_STRUCT = handleLivingDeath,
    COMBATV2_BUFF_MAGIC_WRACK_ACTIVE = handleRunicCharge,
    COMBATV2_COOLDOWN_MAGIC_SUNSHINE_START = handleSunshine,
    COMBATV2_ABILITY_WEAPON_COOLDOWN_SOULFIRE_END = handleSoulfire,
    COMBATV2_ABILITY_WEAPON_COOLDOWN_INSTABILITY_START = handleInstability,
    COMBATV2_BUFF_MAGIC_CRITICAL_STRIKE_ADRENALINE_EFFECT = handleTsunami,
    COMBATV2_COOLDOWN_RANGED_DEATHS_SWIFTNESS_START = handleDeathsSwiftness,
    COMBATV2_COOLDOWN_RANGED_GALESHOT_START = handleSearingWinds,
    COMBATV2_BUFF_RANGED_SEARING_WINDS_END = pauseSearingWinds,
    COMBATV2_BUFF_RANGED_IMBUED_SHADOWS_ACTIVE = handleShadowImbued,
    COMBATV2_COOLDOWN_RANGED_SHADOW_TENDRILS_START = extendShadowImbued,
    EGWD_ZAMORAK_BOSS_TEMP_2  = handlePerfectEquilibrium,
    COMBATV2_COOLDOWN_CONSTITUTION_SPECIAL_ATTACK_END = handleSpecialAttacks,
    COMBATV2_BUFF_GLACIAL_EMBRACE_STACKS = handleInciteFear,
    COMBATV2_BUFF_BLOOD_TITHE_STACKS = handleBloodTithe,
    COMBATV2_BUFF_MAGIC_DEVOURER_T95_PASSIVE_STACKS = handleEssenceCorruption,
    COMBATV2_GLOBAL_COOLDOWN_START = handleCappedStacks,
    COMBATV2_ABILITY_WEAPON_COOLDOWN_SOULFIRE_START = handleCappedEssenceCorruption,
    COMBATV2_COOLDOWN_MAGIC_COMBUST_START = handleCappedEssenceCorruption,
    COMBATV2_COOLDOWN_MAGIC_CORRUPTION_START = handleCappedEssenceCorruption,
    COMBATV2_ABILITY_WEAPON_COOLDOWN_CRYSTAL_RAIN_END = handleCrystalRain,
    COMBATV2_ABILITY_WEAPON_COOLDOWN_BLACK_HOLE_START = handleBlackhole,
    COMBATV2_ABILITY_WEAPON_COOLDOWN_IGNEOUS_SHOWDOWN_START = handleIgneousShowdown,
    COMBATV2_BUFF_MELEE_BLOODLUST_STACKS = handleBloodlust,
    COMBATV2_COOLDOWN_STRENGTH_CHAOS_ROAR_START = handleChaosRoar,
    COMBATV2_BUFF_MELEE_METEOR_STRIKE_ADRENALINE_EFFECT = handleMeteorStrike,
    COMBATV2_BUFF_MELEE_BERSERK_ACTIVE = handleBerserk,
    COMBATV2_BUFF_MELEE_BERSERK_END = pauseBerserk,
    COMBATV2_JUST_USED_ABILITY = handleChaosRoarUse,


    BANK_TEMP = handleBank,
    LASTCASTSPELL = handleLastCastSpell,
}

local COOLDOWN_RESET_MAP  = {

    COMBATV2_COOLDOWN_WEAPON_NECRO_UNDERWORLD_ARMGUARD_T70_END =
        events.playerData.necromancy.deathGrasp,

    COMBATV2_COOLDOWN_WEAPON_NECRO_RASIAL_ARMGUARD_T95_END =
        events.playerData.necromancy.deathEssence,

    COMBATV2_COOLDOWN_WEAPON_NECRO_DEVOURER_ARMGUARD_T95_END =
        events.playerData.necromancy.soulCrush,

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

    COMBATV2_COOLDOWN_RANGED_DEATHS_SWIFTNESS_END =
        events.playerData.ranged.deathsSwiftness,

    COMBATV2_COOLDOWN_RANGED_GALESHOT_END =
        events.playerData.ranged.searingWinds,

    COMBATV2_COOLDOWN_RANGED_IMBUE_SHADOWS_END =
        events.playerData.ranged.shadowImbued,

    COMBATV2_ABILITY_WEAPON_COOLDOWN_CRYSTAL_RAIN_END =
        events.playerData.ranged.crystalRain,

    COMBATV2_ABILITY_WEAPON_COOLDOWN_BLACK_HOLE_END =
        events.playerData.melee.blackhole,

    COMBATV2_ABILITY_WEAPON_COOLDOWN_IGNEOUS_SHOWDOWN_END =
        events.playerData.melee.igneousShowdown,

    COMBATV2_COOLDOWN_STRENGTH_CHAOS_ROAR_END =
        events.playerData.melee.chaosRoar,

    COMBATV2_COOLDOWN_ATTACK_METEOR_STRIKE_END =
        events.playerData.melee.meteorStrike,

    COMBATV2_COOLDOWN_STRENGTH_BERSERK_END =
        events.playerData.melee.berserk,
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

    if (incantations.threadsOfFate.active == 1 or incantations.splitSoul.active == 1) then
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

local function updatePerfectEquilibrium()

    events.playerData.ranged.perfectEquilibrium.active =
        var.VarPlayer["COMBATV2_BUFF_BALANCE_BY_FORCE_ACTIVE"].value

    events.playerData.ranged.perfectEquilibrium.stacks =
        var.VarPlayer["COMBATV2_BUFF_PERFECT_EQUILIBRIUM_STACKS"].value
end

local function updateRanged()
    updatePerfectEquilibrium()
end

local function checkGreaterUnlocks()
    events.playerData.ultimates.greaterSunshineUnlocked = 
        var.VarPlayer["COMBATV2_ABILITY_MAGIC_GREATER_SUNSHINE_UNLOCKED"].value

    events.playerData.ultimates.greaterDeathsSwiftnessUnlocked = 
        var.VarPlayer["COMBATV2_ABILITY_RANGED_GREATER_DEATHS_SWIFTNESS_UNLOCKED"].value
end

local function updateBloodlustStacks(value)
    events.playerData.melee.bloodlust.stacks = value
end

local checkOnce = false

local function updatePlayerData()
    updateInCombatState()
    updateNecromancy()
    updateRanged()

    if (not checkOnce) then
        checkGreaterUnlocks()
        updateActiveSpell(var.VarPlayer["LASTCASTSPELL"].value)
        updateBloodlustStacks(var.VarPlayer["COMBATV2_BUFF_MELEE_BLOODLUST_STACKS"].value)
        swapGaugeToCombatStyle(settings.Get('playerState.combatStyle'))
        checkOnce = true
    end

end

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
    checkEquippedMainhand()
end)

return events
