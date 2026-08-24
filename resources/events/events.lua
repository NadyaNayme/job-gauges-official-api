local settings = require("resources/database/settings")
local spells = require("resources/data/spells")

local events = {
    playerData = {
        inCombat = false,
        combatStyle = 'necromancy',
        activeAspect = nil,
        ultimates = {
            greaterSunshineUnlocked = 0,
            greaterDeathsSwiftnessUnlocked = 0
        },
        necromancy = {
            necrosisStacks = '0',
            residualSoulStacks = '0',
            livingDeath = {
                active = 0,
                remainingDuration = 0,
                activeStart = 0,
                activeEnd = 0,
                cooldown = 0,
                onCooldown = 0
            },
            deathSparkStacks = '0',

            conjures = {
                skeletonWarrior = {
                    active = 0,
                    remainingDuration = 0,
                    activeStart = 0,
                    activeEnd = 0,
                    stacks = 0
                },
                putridZombie = {
                    active = 0,
                    remainingDuration = 0,
                    activeStart = 0,
                    activeEnd = 0,
                },
                vengefulGhost = {
                    active = 0,
                    remainingDuration = 0,
                    activeStart = 0,
                    activeEnd = 0,
                },
                phantomGuardian = {
                    active = 0,
                    remainingDuration = 0,
                    activeStart = 0,
                    activeEnd = 0,
                    stacks = 0
                }
            },

            incantations = {
                threadsOfFate = {
                    active = 0,
                    remainingDuration = 0,
                    activeStart = 0,
                    activeEnd = 0,
                    cooldown = 0,
                    onCooldown = 0
                },
                invokeDeath = {
                    active = 0,
                    remainingDuration = 0,
                    activeStart = 0,
                    activeEnd = 0,
                    cooldown = 0,
                    onCooldown = 0
                },
                splitSoul = {
                    active = 0,
                    remainingDuration = 0,
                    activeStart = 0,
                    activeEnd = 0,
                    cooldown = 0,
                    onCooldown = 0
                },
                darkness = {
                    active = 0,
                    remainingDuration = 0,
                    activeStart = 0,
                    activeEnd = 0,
                    cooldown = 0,
                    onCooldown = 0
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
                activeStart = 0,
                activeEnd = 0,
                cooldown = 0,
                onCooldown = 0
            },
            tsunami = {
                active = 0,
                remainingDuration = 0,
                activeStart = 0,
                activeEnd = 0,
                cooldown = 0,
                onCooldown = 0
            },
            sunshine = {
                active = 0,
                remainingDuration = 0,
                activeStart = 0,
                activeEnd = 0,
                cooldown = 0,
                onCooldown = 0
            },
            instability = {
                active = 0,
                remainingDuration = 0,
                activeStart = 0,
                activeEnd = 0,
                cooldown = 0,
                onCooldown = 0
            },
            soulfire = {
                active = 0,
                remainingDuration = 0,
                activeStart = 0,
                activeEnd = 0,
                cooldown = 0,
                onCooldown = 0
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

local function updateActiveSpell(spellId)
    local spell = spells[spellId]

    if not spell then
        return
    end

    events.playerData.magic.activeSpell.name = spell.name
    events.playerData.magic.activeSpell.icon = spell.icon
end

Event.VarTransmit.Subscribe("cooldownTracking", function(event)
    -- Ignore anything that hasn't changed value
	if event.oldValue == event.newValue then
		return
	end

    -- Living Death
    if event.var.configName == "COMBATV2_BUFF_NECROMANCY_UNDEAD_INSTINCT_ABILITY_STRUCT" then
        if event.oldValue == -1 then 
            events.playerData.necromancy.livingDeath.active = 1
            events.playerData.necromancy.livingDeath.remainingDuration = 50
            if settings.Get('automaticallySwapGauge') == 'dynamic' then
                events.playerData.combatStyle = 'necromancy'
            end
        else 
            events.playerData.necromancy.livingDeath.active = 0
            events.playerData.necromancy.livingDeath.remainingDuration = 0
            events.playerData.necromancy.livingDeath.cooldown = 100
        end
    end

    -- Runic Charge
    if event.var.configName == "COMBATV2_BUFF_MAGIC_WRACK_ACTIVE" then
        if event.oldValue == 0 and event.newValue == 1 then
            events.playerData.magic.runicCharge.active = 1
            events.playerData.magic.runicCharge.remainingDuration = 25
            events.playerData.magic.runicCharge.cooldown = 50
            if settings.Get('automaticallySwapGauge') == 'dynamic' then
                events.playerData.combatStyle = 'magic'
            end
        else
            events.playerData.magic.runicCharge.active = 0
            events.playerData.magic.runicCharge.remainingDuration = 0
        end
    end

    -- Sunshine
    if event.var.configName == "COMBATV2_COOLDOWN_MAGIC_SUNSHINE_START" then
        if event.oldValue ~= event.newValue then
            events.playerData.magic.sunshine.active = 1
            if events.playerData.ultimates.greaterSunshineUnlocked == 1 then
                events.playerData.magic.sunshine.remainingDuration = ULT_GREATER_DURATION
            else 
                if (isPlantedFeetEquipped()) then
                    events.playerData.magic.sunshine.remainingDuration = ULT_GREATER_DURATION
                else
                    events.playerData.magic.sunshine.remainingDuration = ULT_NORMAL_DURATION
                end
            end
            events.playerData.magic.sunshine.cooldown = 100
            if settings.Get('automaticallySwapGauge') == 'dynamic' then
                events.playerData.combatStyle = 'magic'
            end
        end
    end

    -- Tsunami
    if event.var.configName == "COMBATV2_BUFF_MAGIC_CRITICAL_STRIKE_ADRENALINE_EFFECT" then
        if event.oldValue == 0 and event.newValue == 1 then
            events.playerData.magic.tsunami.active = 1
            events.playerData.magic.tsunami.remainingDuration = 50
            events.playerData.magic.tsunami.cooldown = 100
            if settings.Get('automaticallySwapGauge') == 'dynamic' then
                events.playerData.combatStyle = 'magic'
            end
        end
    end

    -- The user can reset their cooldowns at the Altar of War. The altar does this
    -- by setting all _END values to 0, forcing them to be off cooldown.
    if event.var.configName == "COMBATV2_COOLDOWN_NECROMANCY_DEATH_TOUCH_END" then
        if event.newValue == 0 then
            events.playerData.necromancy.livingDeath.cooldown = 0
            events.playerData.necromancy.livingDeath.onCooldown = 0
        end
    end
    if event.var.configName == "COMBATV2_COOLDOWN_MAGIC_SUNSHINE_END" then
        if event.newValue == 0 then
            events.playerData.magic.sunshine.cooldown = 0
            events.playerData.magic.sunshine.onCooldown = 0
        end
    end
    if event.var.configName == "COMBATV2_COOLDOWN_MAGIC_TSUNAMI_END" then
        if event.newValue == 0 then
            events.playerData.magic.tsunami.cooldown = 0
            events.playerData.magic.tsunami.onCooldown = 0
        end
    end
    if event.var.configName == "COMBATV2_ABILITY_WEAPON_COOLDOWN_INSTABILITY_END" then
        if event.newValue == 0 then
            events.playerData.magic.instability.cooldown = 0
            events.playerData.magic.instability.onCooldown = 0
        end
    end
    if event.var.configName == "COMBATV2_ABILITY_WEAPON_COOLDOWN_SOULFIRE_END" then
        if event.newValue == 0 then
            events.playerData.magic.soulfire.cooldown = 0
            events.playerData.magic.soulfire.onCooldown = 0
        end
    end

    -- Treat the player as Out of Combat if they can manage to bank so the gauges don't block the bank UI
    if event.var.configName == "BANK_TEMP" then
        events.playerData.inCombat = false
    end

    -- Update the player's autocast spell whenever it changes
    if event.var.configName == "LASTCASTSPELL" then
        updateActiveSpell(event.newValue)
    end

end)

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
                tbl.onCooldown = 0
                tbl.active = 0
            end
        end
    end
end

Event.ServerLogic.Subscribe("decrementCooldowns", function()
    decrementTimers(events.playerData)
end)

local function getRemainingTicks(startVar, endVar)
    return var.VarPlayer[endVar].value - var.VarPlayer[startVar].value 
end

local function updatePlayerData()

    -- Player Status Updates
    events.playerData.inCombat = (var.VarClient["COMBATV2_TARGET_SIDE_PANEL_HEALTH"].value > 0)

    -- Necromancy Updates
    events.playerData.necromancy.necrosisStacks = var.VarPlayer["COMBATV2_BUFF_NECROMANCY_NECROSIS_STACKS"].value
    events.playerData.necromancy.residualSoulStacks = var.VarPlayer["COMBATV2_BUFF_NECROMANCY_RESIDUAL_SOUL_STACKS"].value
    events.playerData.necromancy.deathSparkStacks = var.VarPlayer["COMBATV2_BUFF_NECRO_RASIAL_ARMGUARD_T95_PASSIVE_STACKS"].value
    
    -- START NECROMANCY CONJURES

    -- Skeleton Warrior
    -- Active
    events.playerData.necromancy.conjures.skeletonWarrior.active = var.VarPlayer["COMBATV2_ABILITY_NECROMANCY_CONJURE_SKELETON_WARRIOR_ACTIVE"].value
    -- Remaining Duration
    if events.playerData.necromancy.conjures.skeletonWarrior.active == 1
        and events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration <= 0 then
        local skeletonTicks = getRemainingTicks(
                "COMBATV2_BUFF_NECROMANCY_SPIRIT_SKELETON_WARRIOR_START",
                "COMBATV2_BUFF_NECROMANCY_SPIRIT_SKELETON_WARRIOR_END"
        )
        if skeletonTicks > 0 then
            events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration = skeletonTicks
            else events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration = 0
        end
        elseif events.playerData.necromancy.conjures.skeletonWarrior.active == 0 then
        events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration = 0
    end
    -- Stacks
    events.playerData.necromancy.conjures.skeletonWarrior.stacks = var.VarPlayer["COMBATV2_BUFF_NECROMANCY_SPIRIT_SKELETON_WARRIOR_STACKS"].value
    if events.playerData.necromancy.conjures.skeletonWarrior.active == 0 then 
        events.playerData.necromancy.conjures.skeletonWarrior.stacks = 0
    end

    -- Putrid Zombie
    -- Active
    events.playerData.necromancy.conjures.putridZombie.active = var.VarPlayer["COMBATV2_ABILITY_NECROMANCY_CONJURE_PUTRID_ZOMBIE_ACTIVE"].value
    -- Remaining Duration
    if events.playerData.necromancy.conjures.putridZombie.active == 1
        and events.playerData.necromancy.conjures.putridZombie.remainingDuration <= 0 then
        local zombieTicks = getRemainingTicks(
                "COMBATV2_BUFF_NECROMANCY_SPIRIT_PUTRID_ZOMBIE_START",
                "COMBATV2_BUFF_NECROMANCY_SPIRIT_PUTRID_ZOMBIE_END"
        )
        if zombieTicks > 0 then
            events.playerData.necromancy.conjures.putridZombie.remainingDuration = zombieTicks
            else events.playerData.necromancy.conjures.putridZombie.remainingDuration = 0
        end
        elseif events.playerData.necromancy.conjures.putridZombie.active == 0 then
        events.playerData.necromancy.conjures.putridZombie.remainingDuration = 0
    end
    
    -- Vengeful Ghost
    -- Active
    events.playerData.necromancy.conjures.vengefulGhost.active = var.VarPlayer["COMBATV2_ABILITY_NECROMANCY_CONJURE_VENGEFUL_GHOST_ACTIVE"].value
    -- Remaining Duration
    if events.playerData.necromancy.conjures.vengefulGhost.active == 1
        and events.playerData.necromancy.conjures.vengefulGhost.remainingDuration <= 0 then
        local ghostTicks = getRemainingTicks(
                "COMBATV2_BUFF_NECROMANCY_SPIRIT_VENGEFUL_GHOST_START",
                "COMBATV2_BUFF_NECROMANCY_SPIRIT_VENGEFUL_GHOST_END"
        )
        if ghostTicks > 0 then
            events.playerData.necromancy.conjures.vengefulGhost.remainingDuration = ghostTicks
            else events.playerData.necromancy.conjures.vengefulGhost.remainingDuration = 0
        end
        elseif events.playerData.necromancy.conjures.vengefulGhost.active == 0 then
        events.playerData.necromancy.conjures.vengefulGhost.remainingDuration = 0
    end
    
    -- Phantom Guardian
    -- Active
    events.playerData.necromancy.conjures.phantomGuardian.active = var.VarPlayer["COMBATV2_ABILITY_NECROMANCY_CONJURE_PHANTOM_GUARDIAN_ACTIVE"].value
    -- Remaining Duration
    if events.playerData.necromancy.conjures.phantomGuardian.active == 1
        and events.playerData.necromancy.conjures.phantomGuardian.remainingDuration <= 0 then
        local guardianTicks = getRemainingTicks(
                "COMBATV2_BUFF_NECROMANCY_SPIRIT_PHANTOM_GUARDIAN_START",
                "COMBATV2_BUFF_NECROMANCY_SPIRIT_PHANTOM_GUARDIAN_END"
        )
        if guardianTicks > 0 then
            events.playerData.necromancy.conjures.phantomGuardian.remainingDuration = guardianTicks
            else events.playerData.necromancy.conjures.phantomGuardian.remainingDuration = 0
        end
        elseif events.playerData.necromancy.conjures.phantomGuardian.active == 0 then
        events.playerData.necromancy.conjures.phantomGuardian.remainingDuration = 0
    end
    -- Stacks
    events.playerData.necromancy.conjures.phantomGuardian.stacks = var.VarPlayer["COMBATV2_BUFF_NECROMANCY_SPIRIT_PHANTOM_GUARDIAN_STACKS"].value    
    if events.playerData.necromancy.conjures.phantomGuardian.active == 0 then 
        events.playerData.necromancy.conjures.phantomGuardian.stacks = 0
    end

    -- END NECROMANCY CONJURES

    -- START INCANTATIONS
    events.playerData.necromancy.incantations.threadsOfFate.active = var.VarPlayer["COMBATV2_BUFF_NECROMANCY_THREADS_OF_FATE_ACTIVE"].value
    events.playerData.necromancy.incantations.darkness.active = var.VarPlayer["COMBATV2_BUFF_NECROMANCY_DARKNESS_ACTIVE"].value
    events.playerData.necromancy.incantations.invokeDeath.active = var.VarPlayer["COMBATV2_BUFF_NECROMANCY_INVOKE_DEATH_ACTIVE"].value
    events.playerData.necromancy.incantations.splitSoul.active = var.VarPlayer["COMBATV2_BUFF_NECROMANCY_SPLIT_SOUL_ACTIVE"].value
    -- END INCANTATIONS


    -- Magic
    updateActiveSpell(var.VarPlayer["LASTCASTSPELL"].value)
    events.playerData.ultimates.greaterSunshineUnlocked = var.VarPlayer["COMBATV2_ABILITY_MAGIC_GREATER_SUNSHINE_UNLOCKED"].value
    events.playerData.ultimates.greaterDeathsSwiftnessUnlocked = var.VarPlayer["COMBATV2_ABILITY_RANGED_GREATER_DEATHS_SWIFTNESS_UNLOCKED"].value

end

Event.Logic.Subscribe("updatePlayerData", updatePlayerData)

return events
