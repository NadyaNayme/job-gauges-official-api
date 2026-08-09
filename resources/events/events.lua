local events = {
    currentTick = 0,
    playerData = {
        inCombat = false,
        combatStyle = 'necromancy',
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
        }
    }
}

Event.VarTransmit.Subscribe("livingDeath", function(event)
	if event.oldValue == event.newValue then
		return
	end

    if event.var.configName == "COMBATV2_BUFF_NECROMANCY_UNDEAD_INSTINCT_ABILITY_STRUCT" then
        if event.oldValue == -1 then 
            events.playerData.necromancy.livingDeath.active = 1
            events.playerData.necromancy.livingDeath.remainingDuration = 50
        else 
            events.playerData.necromancy.livingDeath.active = 0
            events.playerData.necromancy.livingDeath.remainingDuration = 0
            events.playerData.necromancy.livingDeath.cooldown = 100
        end
    end

    if event.var.configName == "COMBATV2_COOLDOWN_NECROMANCY_DEATH_TOUCH_END" then
        if event.newValue == 0 then
            events.playerData.necromancy.livingDeath.cooldown = 0
            events.playerData.necromancy.livingDeath.onCooldown = 0
        end
    end

end)

Event.Logic.Subscribe("cdTick", function(e) events.currentTick = e.logicTick end)

Event.ServerLogic.Subscribe("decrementCooldowns", function()

    -- Living Death
    if events.playerData.necromancy.livingDeath.remainingDuration > 0 then 
        events.playerData.necromancy.livingDeath.remainingDuration = events.playerData.necromancy.livingDeath.remainingDuration - 1
    end

    if events.playerData.necromancy.livingDeath.cooldown > 0 then 
        events.playerData.necromancy.livingDeath.cooldown = events.playerData.necromancy.livingDeath.cooldown - 1
    end

    -- Skeleton Warrior
    if events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration > 0 then 
        events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration = events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration - 1
    end
    -- Putrid Zombie
    if events.playerData.necromancy.conjures.putridZombie.remainingDuration > 0 then 
        events.playerData.necromancy.conjures.putridZombie.remainingDuration = events.playerData.necromancy.conjures.putridZombie.remainingDuration - 1
    end
    -- Vengeful Ghost
    if events.playerData.necromancy.conjures.vengefulGhost.remainingDuration > 0 then 
        events.playerData.necromancy.conjures.vengefulGhost.remainingDuration = events.playerData.necromancy.conjures.vengefulGhost.remainingDuration - 1
    end
    -- Phantom Guardian
    if events.playerData.necromancy.conjures.phantomGuardian.remainingDuration > 0 then 
        events.playerData.necromancy.conjures.phantomGuardian.remainingDuration = events.playerData.necromancy.conjures.phantomGuardian.remainingDuration - 1
    end
end)

local function remainingTicks(name, name2)
    local cooldownStart = var.VarPlayer[name].value
    local cooldownEnd = var.VarPlayer[name2].value
    return cooldownEnd - cooldownStart
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
        local skeletonTicks = remainingTicks(
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
        local zombieTicks = remainingTicks(
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
        local ghostTicks = remainingTicks(
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
        local guardianTicks = remainingTicks(
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


end

Event.Logic.Subscribe("updatePlayerData", updatePlayerData)

return events
