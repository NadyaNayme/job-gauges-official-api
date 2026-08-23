local settings = require("resources/database/settings")
local events = require("resources/events/events")
local overlay = require("resources/ui/overlay")

local M = {}

-- Globals
local SCALE = 1
local OFFSET_POSITION_X = settings.Get("necroUISettings")["necromancy_gauge_offset_x"]
local OFFSET_POSITION_Y = settings.Get("necroUISettings")["necromancy_gauge_offset_y"]

-- Helpers
local function ticksToSeconds(ticks)
    local precise = settings.Get("showPreciseDurations")
    if precise == "precise-ticks" then 
        return ticks * 0.6
    else 
        return math.ceil(ticks * 0.6)
    end
end

local function scaleToFactor(number)
    return math.floor(number * SCALE)
end
-- End Helpers

local CreateUI = function()
  local gameArea = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__GAME_AREA)
  if not gameArea then
    log("Can't find game area")
    return
  end

  local jobGaugeLayer = ui.Layer.new(gameArea)
  jobGaugeLayer:SetSize(600, 600, 1.0, 1.0)
  local overlaySprites = overlay.CreateSprites(jobGaugeLayer)

  -- Necromancy Job Gauge
  local necromancyGaugeLayer = ui.Layer.new(jobGaugeLayer)
  necromancyGaugeLayer:SetSize(600, 600, 1.0, 1.0)


  local conjureUndeadArmyLayer = ui.Layer.new(necromancyGaugeLayer)
  conjureUndeadArmyLayer:SetSize(40, 40, 1.0, 1.0)

  local livingDeathLayer = ui.Layer.new(necromancyGaugeLayer)
  livingDeathLayer:SetSize(40, 40, 1.0, 1.0)



    -- Necromancy Overlay Sprites
    local   conjureUndeadArmy = ui.Sprite.new(conjureUndeadArmyLayer)
            conjureUndeadArmy:SetPos(math.floor(0 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
            conjureUndeadArmy:SetSize(scaleToFactor(40), scaleToFactor(40))

    local conjureText = ui.Text.new(conjureUndeadArmyLayer)
        conjureText:SetPos(math.floor(8 + OFFSET_POSITION_X), math.floor(14 + OFFSET_POSITION_Y))
        conjureText:SetSize(22, 15)
        conjureText:MoveToFront()
        conjureText.content = ""
        conjureText.font = id.Font.MUSEO_SANS_15PT_REGULAR
        conjureText.colour = Vector4.new(1.0, 1.0, 1.0, 1.0)
        conjureText.isShadowed = true
        conjureText.alignHorizontal = ui.AlignMode.CENTRE
        conjureText.alignVertical = ui.AlignMode.CENTRE

    local   livingDeath = ui.Sprite.new(livingDeathLayer)
            livingDeath:SetPos(math.floor(40 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
            livingDeath:SetSize(scaleToFactor(40), scaleToFactor(40))

    local livingDeathText = ui.Text.new(livingDeathLayer)
        livingDeathText:SetPos(math.floor(48 + OFFSET_POSITION_X), math.floor(14 + OFFSET_POSITION_Y))
        livingDeathText:SetSize(22, 15)
        livingDeathText:MoveToFront()
        livingDeathText.content = ""
        livingDeathText.font = id.Font.MUSEO_SANS_15PT_REGULAR
        livingDeathText.colour = Vector4.new(1.0, 1.0, 1.0, 1.0)
        livingDeathText.isShadowed = true
        livingDeathText.alignHorizontal = ui.AlignMode.CENTRE
        livingDeathText.alignVertical = ui.AlignMode.CENTRE

    local   residualSoulsStacks = ui.Sprite.new(necromancyGaugeLayer)
            residualSoulsStacks:SetPos(math.floor(2 + OFFSET_POSITION_X), math.floor(44 + OFFSET_POSITION_Y))
            residualSoulsStacks:SetSize(scaleToFactor(132), scaleToFactor(24))

    local   necrosisStacks = ui.Sprite.new(necromancyGaugeLayer)
            necrosisStacks:SetPos(math.floor(2 + OFFSET_POSITION_X), math.floor(67 + OFFSET_POSITION_Y))
            necrosisStacks:SetSize(scaleToFactor(132), scaleToFactor(20))

    local   invokeDeath = ui.Sprite.new(necromancyGaugeLayer)
            invokeDeath:SetPos(math.floor(84 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
            invokeDeath:SetSize(scaleToFactor(24), scaleToFactor(21))

    local   threadsOfFate = ui.Sprite.new(necromancyGaugeLayer)
            threadsOfFate:SetPos(math.floor(108 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
            threadsOfFate:SetSize(scaleToFactor(24), scaleToFactor(21))

    local   darkness = ui.Sprite.new(necromancyGaugeLayer)
            darkness:SetPos(math.floor(84 + OFFSET_POSITION_X), math.floor(22 + OFFSET_POSITION_Y))
            darkness:SetSize(scaleToFactor(24), scaleToFactor(21))

    local   splitSoul = ui.Sprite.new(necromancyGaugeLayer)
            splitSoul:SetPos(math.floor(108 + OFFSET_POSITION_X), math.floor(22 + OFFSET_POSITION_Y))
            splitSoul:SetSize(scaleToFactor(24), scaleToFactor(21))

  -- Magic Overlay
  local magicGaugeLayer = ui.Layer.new(gameArea)
  magicGaugeLayer:SetSize(600, 600, 1.0, 1.0)

  local tsunamiLayer = ui.Layer.new(magicGaugeLayer)
  tsunamiLayer:SetSize(40, 40, 1.0, 1.0)

    local   tsunami = ui.Sprite.new(tsunamiLayer)
            tsunami:SetPos(math.floor(40 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
            tsunami:SetSize(scaleToFactor(40), scaleToFactor(40))

    local tsunamiText = ui.Text.new(tsunamiLayer)
        tsunamiText:SetPos(math.floor(48 + OFFSET_POSITION_X), math.floor(14 + OFFSET_POSITION_Y))
        tsunamiText:SetSize(22, 15)
        tsunamiText:MoveToFront()
        tsunamiText.content = ""
        tsunamiText.font = id.Font.MUSEO_SANS_15PT_REGULAR
        tsunamiText.colour = Vector4.new(1.0, 1.0, 1.0, 1.0)
        tsunamiText.isShadowed = true
        tsunamiText.alignHorizontal = ui.AlignMode.CENTRE
        tsunamiText.alignVertical = ui.AlignMode.CENTRE

    local sunshineLayer = ui.Layer.new(magicGaugeLayer)
    sunshineLayer:SetSize(40, 40, 1.0, 1.0)

    local   sunshine = ui.Sprite.new(sunshineLayer)
            sunshine:SetPos(math.floor(80 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
            sunshine:SetSize(scaleToFactor(40), scaleToFactor(40))

    local sunshineText = ui.Text.new(sunshineLayer)
        sunshineText:SetPos(math.floor(88 + OFFSET_POSITION_X), math.floor(14 + OFFSET_POSITION_Y))
        sunshineText:SetSize(22, 15)
        sunshineText:MoveToFront()
        sunshineText.content = ""
        sunshineText.font = id.Font.MUSEO_SANS_15PT_REGULAR
        sunshineText.colour = Vector4.new(1.0, 1.0, 1.0, 1.0)
        sunshineText.isShadowed = true
        sunshineText.alignHorizontal = ui.AlignMode.CENTRE
        sunshineText.alignVertical = ui.AlignMode.CENTRE

    local runicChargeLayer = ui.Layer.new(magicGaugeLayer)
    runicChargeLayer:SetSize(40, 40, 1.0, 1.0)

    local   runicCharge = ui.Sprite.new(runicChargeLayer)
            runicCharge:SetPos(math.floor(0 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
            runicCharge:SetSize(scaleToFactor(40), scaleToFactor(40))

    local runicChargeText = ui.Text.new(runicChargeLayer)
        runicChargeText:SetPos(math.floor(8 + OFFSET_POSITION_X), math.floor(14 + OFFSET_POSITION_Y))
        runicChargeText:SetSize(22, 15)
        runicChargeText:MoveToFront()
        runicChargeText.content = ""
        runicChargeText.font = id.Font.MUSEO_SANS_15PT_REGULAR
        runicChargeText.colour = Vector4.new(1.0, 1.0, 1.0, 1.0)
        runicChargeText.isShadowed = true
        runicChargeText.alignHorizontal = ui.AlignMode.CENTRE
        runicChargeText.alignVertical = ui.AlignMode.CENTRE

    local   activeSpellLayer = ui.Sprite.new(magicGaugeLayer)
            activeSpellLayer:SetPos(math.floor(124 + OFFSET_POSITION_X), math.floor(11 + OFFSET_POSITION_Y))
            activeSpellLayer:SetSize(scaleToFactor(24), scaleToFactor(21))


    local function updateOverlayPositions()
        conjureUndeadArmy:SetPos(math.floor(0 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
        conjureText:SetPos(math.floor(8 + OFFSET_POSITION_X), math.floor(14 + OFFSET_POSITION_Y))
        livingDeath:SetPos(math.floor(48 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
        livingDeathText:SetPos(math.floor(48 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
        residualSoulsStacks:SetPos(math.floor(0 + OFFSET_POSITION_X), math.floor(50 + OFFSET_POSITION_Y))
        necrosisStacks:SetPos(math.floor(0 + OFFSET_POSITION_X), math.floor(82 + OFFSET_POSITION_Y))
        invokeDeath:SetPos(math.floor(95 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
        threadsOfFate:SetPos(math.floor(125 + OFFSET_POSITION_X), math.floor(0 + OFFSET_POSITION_Y))
        darkness:SetPos(math.floor(95 + OFFSET_POSITION_X), math.floor(26 + OFFSET_POSITION_Y))
        splitSoul:SetPos(math.floor(125 + OFFSET_POSITION_X), math.floor(26 + OFFSET_POSITION_Y))
    end

  local settingsBox = prettyui.Window.new(gameArea, {
    title = "Job Gauges",
    x = 10,
    y = 250,
    width = 800,
    height = 700,
  })

  settingsBox.root.hidden = true
  local itemRibbon = prettyui.RibbonBar.Register({
    id = "job-gauges",
    icon = id.Sprite.RS3_ICON_MENU_HERO,
    tooltip = "Open Job Gauges Settings",
    onClick = function(handle, active) settingsBox.root.hidden = not active end,
  })

  local tabs = settingsBox:AddTabs({ "General", "Necro", "Magic", "Melee", "Ranged", "Debug" }, { height = -20, heightAnchor = 1.0 })

  local generalPage = tabs:GetPage(1)
  local necroPage = tabs:GetPage(2)
  local magicPage = tabs:GetPage(3)
  local meleePage = tabs:GetPage(4)
  local rangedPage = tabs:GetPage(5)
  local debugPage = tabs:GetPage(6)

  -- Page: General
  generalPage:AddTitle("Job Gauge Settings")

    generalPage:AddText("Dynamically swap combat style gauge based on active buffs (ie. after Ultimate Ability used)")
    local automaticallySwapGauge = generalPage:AddRadioButton({
        { text = "Yes", value = "dynamic" },
        { text = "No", value = "static" },
    }, {
        selectedValue = settings.Get("automaticallySwapGauge"),

        onChange = function(group, value)
            settings.Set("automaticallySwapGauge", value)
        end,
    })

    generalPage:AddText("Hide the combat style gauge while out of combat")
    local hideGaugeOutOfCombat = generalPage:AddRadioButton({
        { text = "Yes", value = "combat-visible" },
        { text = "No", value = "always-visible" },
    }, {
        selectedValue = settings.Get("hideGaugeOutOfCombat"),

        onChange = function(group, value)
            settings.Set("hideGaugeOutOfCombat", value)
        end,
    })

    generalPage:AddText("Show precise ticks or round to nearest second?")
    local showPreciseDurations = generalPage:AddRadioButton({
        { text = "Precise Ticks", value = "precise-ticks" },
        { text = "Nearest Second", value = "nearest-second" },
    }, {
        selectedValue = settings.Get("showPreciseDurations"),

        onChange = function(group, value)
            settings.Set("showPreciseDurations", value)
        end,
    })

    generalPage:AddText("Gauge Position - Offset X")
    local necroGaugeOffsetX = generalPage:AddSlider({
        min = 0,
        max = 1920,
        value = settings.Get("necroUISettings")["necromancy_gauge_offset_x"],
        step = 1,
        onChange = function(_, value)
            local current = settings.Get("necroUISettings")
            current["necromancy_gauge_offset_x"] = value
            settings.Set("necroUISettings", current)
            OFFSET_POSITION_X = value
            updateOverlayPositions()
        end,
    })

    generalPage:AddText("Gauge Position - Offset Y")
    local necroGaugeOffsetY = generalPage:AddSlider({
        min = 0,
        max = 1080,
        value = settings.Get("necroUISettings")["necromancy_gauge_offset_y"],
        step = 1,
        onChange = function(_, value)
            local current = settings.Get("necroUISettings")
            current["necromancy_gauge_offset_y"] = value
            settings.Set("necroUISettings", current)
            OFFSET_POSITION_Y = value
            updateOverlayPositions()
        end,
    })
    


  -- Page: Necro

    necroPage:AddTitle("Necromancy Gauge Components")

    local necroComponents = settings.Get("necroVisibleGaugeComponents")

    local necroVisibleGaugeComponents = necroPage:AddCheckboxButton({
        { text = "Show Conjures", value = "show-conjures", selected = necroComponents["show-conjures"] },
        { text = "Show Residual Souls", value = "show-residual-souls", selected = necroComponents["show-residual-souls"] },
        { text = "Show Necrosis Stacks", value = "show-necrosis-stacks", selected = necroComponents["show-necrosis-stacks"] },
        { text = "Show Bloat", value = "show-bloat", selected = necroComponents["show-bloat"] },
        { text = "Show Living Death", value = "show-living-death", selected = necroComponents["show-living-death"] },
        { text = "Show Invoke Death", value = "show-invoke-death", selected = necroComponents["show-invoke-death"] },
        { text = "Show Darkness", value = "show-darkness", selected = necroComponents["show-darkness"] },
        { text = "Show Threads of Fate", value = "show-threads-of-fate", selected = necroComponents["show-threads-of-fate"] },
        { text = "Show Split Soul", value = "show-split-soul", selected = necroComponents["show-split-soul"] },
    }, {
        onChange = function(group, values, changedValue, selected)
            local current = settings.Get("necroVisibleGaugeComponents")
            current[changedValue] = selected
            settings.Set("necroVisibleGaugeComponents", current)
        end,
    })

    necroPage:AddTitle("UI Settings")

    local necroUISettings = necroPage:AddCheckboxButton({
        { text = "Hide Native Residual Souls", value = "hide-residual-souls", selected = settings.Get("necroUISettings")["hide-residual-souls"] }
    }, {
    onChange = function(group, values, changedValue, selected)
        local current = settings.Get("necroUISettings")
        current[changedValue] = selected
        settings.Set("necroUISettings", current)
    end,
    })

    -- necroPage:AddText("Necromancy Gauge Position - Offset X")
    -- local necroGaugeOffsetX = necroPage:AddSlider({
    --     min = 0,
    --     max = 1920,
    --     value = settings.Get("necroUISettings")["necromancy_gauge_offset_x"],
    --     step = 1,
    --     onChange = function(_, value)
    --         local current = settings.Get("necroUISettings")
    --         current["necromancy_gauge_offset_x"] = value
    --         settings.Set("necroUISettings", current)
    --         OFFSET_POSITION_X = value
    --         updateOverlayPositions()
    --     end,
    -- })

    -- necroPage:AddText("Necromancy Gauge Position - Offset Y")
    -- local necroGaugeOffsetY = necroPage:AddSlider({
    --     min = 0,
    --     max = 1080,
    --     value = settings.Get("necroUISettings")["necromancy_gauge_offset_y"],
    --     step = 1,
    --     onChange = function(_, value)
    --         local current = settings.Get("necroUISettings")
    --         current["necromancy_gauge_offset_y"] = value
    --         settings.Set("necroUISettings", current)
    --         OFFSET_POSITION_Y = value
    --         updateOverlayPositions()
    --     end,
    -- })

  -- Page: Magic

    local magicComponents = settings.Get("magicVisibleGaugeComponents")

    local magicVisibleGaugeComponents = magicPage:AddCheckboxButton({
        { text = "Show Sunshine", value = "show-sunshine", selected = magicComponents["show-sunshine"] },
        { text = "Show Tsunami", value = "show-tsunami", selected = magicComponents["show-tsunami"] },
        { text = "Show Runic Charge", value = "show-runic-charge", selected = magicComponents["show-runic-charge"] },
        { text = "Show Instability (Fractured Staff of Armadyl Special Attack)", value = "show-instability", selected = magicComponents["show-instability"] },
        { text = "Show Soulfire (Rod of Awakening Special Attack)", value = "show-soulfire", selected = magicComponents["show-soulfire"] },
        { text = "Show Active Spell", value = "show-active-spell", selected = magicComponents["show-active-spell"] },
    }, {
        onChange = function(group, values, changedValue, selected)
            local current = settings.Get("magicVisibleGaugeComponents")
            current[changedValue] = selected
            settings.Set("magicVisibleGaugeComponents", current)
        end,
    })

    -- magicPage:AddText("Magic Gauge Position - Offset X")
    -- local magicGaugeOffsetX = magicPage:AddSlider({
    --     min = 0,
    --     max = 1920,
    --     value = settings.Get("magicUISettings")["magic_gauge_offset_x"],
    --     step = 1,
    --     onChange = function(_, value)
    --         local current = settings.Get("magicUISettings")
    --         current["magic_gauge_offset_x"] = value
    --         settings.Set("magicUISettings", current)
    --         OFFSET_POSITION_X = value
    --         updateOverlayPositions()
    --     end,
    -- })

    -- magicPage:AddText("Magic Gauge Position - Offset Y")
    -- local magicGaugeOffsetY = magicPage:AddSlider({
    --     min = 0,
    --     max = 1080,
    --     value = settings.Get("magicUISettings")["magic_gauge_offset_y"],
    --     step = 1,
    --     onChange = function(_, value)
    --         local current = settings.Get("magicUISettings")
    --         current["magic_gauge_offset_y"] = value
    --         settings.Set("magicUISettings", current)
    --         OFFSET_POSITION_Y = value
    --         updateOverlayPositions()
    --     end,
    -- })

  -- Page: Melee

  -- Page: Ranged

  -- Page: Debug
  debugPage:AddTitle("Player State")

  local playerInCombatDebugLabel = debugPage:AddText("In Combat: false")

    debugPage:AddText("Force Combat Style")
    local forceCombatStyle = debugPage:AddRadioButton({
        { text = "Necromancy", value = "necromancy" },
        { text = "Magic", value = "magic" },
        { text = "Ranged", value = "ranged" },
        { text = "Melee", value = "melee" }
    }, {
        selectedValue = 'necromancy',

        onChange = function(group, value)
            if settings.Get('automaticallySwapGauge') == 'static' then
                events.combatStyle = value
            end
        end,
    })

  debugPage:AddDivider({
    marginTop = 0,
    marginBottom = 4
  })
  debugPage:AddTitle("Necromancy")
  -- Necromancy Stacks
  local necrosisStacksDebugLabel = debugPage:AddText("Necrosis Stacks: 0")
  local residualSoulsDebugLabel = debugPage:AddText("Residual Souls: 0")

  -- Living Death
  local livingDeathDebugLabel = debugPage:AddText("Living Death: Inactive")
  local livingDeathDurationDebugLabel = debugPage:AddText("Living Death Duration: 0")
  local deathSparkStacksDebugLabel = debugPage:AddText("Death Spark Stacks: 0")

  -- Necromancy Conjures
  debugPage:AddTitle("Conjures")
  -- Skeleton Warrior
  local skeletonWarriorDebugLabel = debugPage:AddText("Skeleton Warrior: Inactive")
  local skeletonWarriorDurationDebugLabel = debugPage:AddText("Skeleton Warrior Duration: 0")
  local skeletonWarriorStacksDebugLabel = debugPage:AddText("Skeleton Warrior Stacks: 0")

  -- Putrid Zombie
  local putridZombieDebugLabel = debugPage:AddText("Putrid Zombie: Inactive")
  local putridZombieDurationDebugLabel = debugPage:AddText("Putrid Zombie Duration: 0")

  -- Vengeful Ghost
  local vengefulGhostDebugLabel = debugPage:AddText("Vengeful Ghost: Inactive")
  local vengefulGhostDurationDebugLabel = debugPage:AddText("Vengeful Ghost Duration: 0")

  -- Phantom Guardian
  local phantomGuardianDebugLabel = debugPage:AddText("Phantom Guardian: Inactive")
  local phantomGuardianDurationDebugLabel = debugPage:AddText("Phantom Guardian Duration: 0")
  local phantomGuardianStacksDebugLabel = debugPage:AddText("Phantom Guardian Stacks: 0")

  -- Necromancy Incantations
  debugPage:AddTitle("Incantations")
  -- Darkness
  local darknessDebugLabel = debugPage:AddText("Darkness: Inactive")
  -- Invoke Death
  local invokeDeathDebugLabel = debugPage:AddText("Invoke Death: Inactive")
  -- Split Soul
  local splitSoulDebugLabel = debugPage:AddText("Split Soul: Inactive")
  -- Threads of Fate
  local threadsOfFateDebugLabel = debugPage:AddText("Threads of Fate: Inactive")

  debugPage:AddTitle("Magic")
  local activeSpellDebugLabel = debugPage:AddText("Active Spell: unset")
  local runicChargeDebugLabel = debugPage:AddText("Runic Charge: Inactive")

local function updateDebugData()

playerInCombatDebugLabel.content = "In Combat: " .. tostring(events.playerData.inCombat)

-- Necromancy
necrosisStacksDebugLabel.content = "Necrosis Stacks: " .. tostring(events.playerData.necromancy.necrosisStacks)
residualSoulsDebugLabel.content = "Residual Soul Stacks: " .. tostring(events.playerData.necromancy.residualSoulStacks)
livingDeathDebugLabel.content = "Living Death: " .. (events.playerData.necromancy.livingDeath.active == -1 and "Inactive" or "Active")
livingDeathDebugLabel.content = "Living Death: " .. tostring(ticksToSeconds(events.playerData.necromancy.livingDeath.remainingDuration))
deathSparkStacksDebugLabel.content = "Death Spark Stacks: " .. tostring(events.playerData.necromancy.deathSparkStacks)
-- Conjures
skeletonWarriorDebugLabel.content = "Skeleton Warrior: " .. (events.playerData.necromancy.conjures.skeletonWarrior.active == 1 and "Active" or "Inactive")
skeletonWarriorDurationDebugLabel.content = "Skeleton Warrior Duration: " .. tostring(ticksToSeconds(events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration))
skeletonWarriorStacksDebugLabel.content = "Skeleton Warrior Stacks: " .. tostring(events.playerData.necromancy.conjures.skeletonWarrior.stacks)
putridZombieDebugLabel.content = "Putrid Zombie: " .. (events.playerData.necromancy.conjures.putridZombie.active == 1 and "Active" or "Inactive")
putridZombieDurationDebugLabel.content = "Putrid Zombie Duration: " .. tostring(ticksToSeconds(events.playerData.necromancy.conjures.putridZombie.remainingDuration))
vengefulGhostDebugLabel.content = "Vengeful Ghost: " .. (events.playerData.necromancy.conjures.vengefulGhost.active == 1 and "Active" or "Inactive")
vengefulGhostDurationDebugLabel.content = "Vengeful Ghost Duration: " .. tostring(ticksToSeconds(events.playerData.necromancy.conjures.vengefulGhost.remainingDuration))
phantomGuardianDebugLabel.content = "Phantom Guardian: " .. (events.playerData.necromancy.conjures.phantomGuardian.active == 1 and "Active" or "Inactive")
phantomGuardianDurationDebugLabel.content = "Phantom Guardian Duration: " .. tostring(ticksToSeconds(events.playerData.necromancy.conjures.phantomGuardian.remainingDuration))
phantomGuardianStacksDebugLabel.content = "Phantom Guardian Stacks: " .. tostring(events.playerData.necromancy.conjures.phantomGuardian.stacks)
-- Incantations
darknessDebugLabel.content = "Darkness: " .. (events.playerData.necromancy.incantations.darkness.active == 1 and "Active" or "Inactive")
invokeDeathDebugLabel.content = "Invoke Death: " .. (events.playerData.necromancy.incantations.invokeDeath.active == 1 and "Active" or "Inactive")
splitSoulDebugLabel.content = "Split Soul: " .. (events.playerData.necromancy.incantations.splitSoul.active == 1 and "Active" or "Inactive")
threadsOfFateDebugLabel.content = "Threads of Fate: " .. (events.playerData.necromancy.incantations.threadsOfFate.active == 1 and "Active" or "Inactive")

-- Magic
activeSpellDebugLabel.content = "Active Spell: ".. (events.playerData.magic.active_spell.name)
runicChargeDebugLabel.content = "Runic Charge: ".. (events.playerData.magic.runic_charge.active == 1 and "Active" or "Inactive")

end
Event.VarTransmit.Subscribe("updateDebugData", updateDebugData)

local function updateOverlays()

    if overlaySprites == nil then return end

    if events.combatStyle == 'necromancy' then
        necromancyGaugeLayer.hidden = false
        magicGaugeLayer.hidden = true
        -- rangedGaugeLayer.hidden = true
        -- meleeGaugeLayer.hidden = true
    elseif events.combatStyle == 'magic' then
        necromancyGaugeLayer.hidden = true
        magicGaugeLayer.hidden = false
        -- rangedGaugeLayer.hidden = true
        -- meleeGaugeLayer.hidden = true
    elseif events.combatStyle == 'ranged' then
        necromancyGaugeLayer.hidden = true
        magicGaugeLayer.hidden = true
        -- rangedGaugeLayer.hidden = false
        -- meleeGaugeLayer.hidden = true
    elseif events.combatStyle == 'melee' then
        necromancyGaugeLayer.hidden = true
        magicGaugeLayer.hidden = true
        -- rangedGaugeLayer.hidden = true
        -- meleeGaugeLayer.hidden = false
    else
        necromancyGaugeLayer.hidden = true
        magicGaugeLayer.hidden = true
        -- rangedGaugeLayer.hidden = true
        -- meleeGaugeLayer.hidden = true
    end
    
    if events.playerData.inCombat ~= true and settings.Get("hideGaugeOutOfCombat") == "combat-visible" then
        necromancyGaugeLayer.hidden = true
     end

    -- Conjure Undead Army
    if settings.Get("necroVisibleGaugeComponents")["show-conjures"] then 
        conjureUndeadArmyLayer.hidden = false
        if events.playerData.necromancy.conjures.skeletonWarrior.active == 1
        or events.playerData.necromancy.conjures.putridZombie.active == 1
        or events.playerData.necromancy.conjures.vengefulGhost.active == 1
        or events.playerData.necromancy.conjures.phantomGuardian.active == 1
            then
                conjureUndeadArmy.sprite = overlaySprites.necromancy.conjures.active
                if ticksToSeconds(events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration) == 0.0 then return end
                conjureText.content = tostring(ticksToSeconds(events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration))
            else 
                conjureUndeadArmy.sprite = overlaySprites.necromancy.conjures.inactive
                conjureText.content = ""
        end
    else 
        conjureUndeadArmyLayer.hidden = true
    end

    if settings.Get("necroVisibleGaugeComponents")["show-living-death"] then 
        livingDeathLayer.hidden = false
        if events.playerData.necromancy.livingDeath.active == 1
            then 
                livingDeath.sprite = overlaySprites.necromancy.living_death.active
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.combatStyle = 'necromancy'
                end
                if ticksToSeconds(events.playerData.necromancy.livingDeath.remainingDuration) == 0.0 then return end
                livingDeathText.content = tostring(ticksToSeconds(events.playerData.necromancy.livingDeath.remainingDuration))
            elseif events.playerData.necromancy.livingDeath.cooldown >= 1 then 
                livingDeath.sprite = overlaySprites.necromancy.living_death.inactive
                livingDeathText.content = tostring(ticksToSeconds(events.playerData.necromancy.livingDeath.cooldown))
            else
                livingDeath.sprite = overlaySprites.necromancy.living_death.inactive
                livingDeathText.content = ""
                if ticksToSeconds(events.playerData.necromancy.livingDeath.cooldown) == 0.0 then
                    livingDeath.sprite = overlaySprites.necromancy.living_death.active
                    livingDeathText.content = "RDY"
                end
        end
    else 
        livingDeathLayer.hidden = true
    end
    
    -- Residual Soul Stacks
    if settings.Get("necroVisibleGaugeComponents")["show-residual-souls"] then 
        residualSoulsStacks:SetSize(scaleToFactor(132), scaleToFactor(24))
        if events.playerData.necromancy.residualSoulStacks == 0 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.zero
        elseif events.playerData.necromancy.residualSoulStacks == 1 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.one
        elseif events.playerData.necromancy.residualSoulStacks == 2 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.two
        elseif events.playerData.necromancy.residualSoulStacks == 3 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.three
        elseif events.playerData.necromancy.residualSoulStacks == 4 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.four
        elseif events.playerData.necromancy.residualSoulStacks == 5 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.five
        end
    else 
        residualSoulsStacks:SetSize(0, 0)
    end

    -- Necrosis Stacks
    if settings.Get("necroVisibleGaugeComponents")["show-necrosis-stacks"] then 
        necrosisStacks:SetSize(scaleToFactor(132), scaleToFactor(20))
        if events.playerData.necromancy.necrosisStacks == 0 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.zero
        elseif events.playerData.necromancy.necrosisStacks == 2 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.two
        elseif events.playerData.necromancy.necrosisStacks == 4 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.four
        elseif events.playerData.necromancy.necrosisStacks == 6 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.six
        elseif events.playerData.necromancy.necrosisStacks == 8 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.eight
        elseif events.playerData.necromancy.necrosisStacks == 10 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.ten
        elseif events.playerData.necromancy.necrosisStacks == 12 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.twelve
        end
    else 
        necrosisStacks:SetSize(0, 0)
    end

    -- Incantations
    if settings.Get("necroVisibleGaugeComponents")["show-darkness"] then 
        darkness:SetSize(scaleToFactor(24), scaleToFactor(21))
        if events.playerData.necromancy.incantations.darkness.active == 1 then
            darkness.sprite = overlaySprites.necromancy.incantations.darkness.active
            else darkness.sprite = overlaySprites.necromancy.incantations.darkness.inactive
        end
    else
        darkness:SetSize(0, 0)
    end
    if settings.Get("necroVisibleGaugeComponents")["show-threads-of-fate"] then 
        threadsOfFate:SetSize(scaleToFactor(24), scaleToFactor(21))
    if events.playerData.necromancy.incantations.threadsOfFate.active == 1 then
        threadsOfFate.sprite = overlaySprites.necromancy.incantations.threadsOfFate.active
        else threadsOfFate.sprite = overlaySprites.necromancy.incantations.threadsOfFate.inactive
        end
    else
        threadsOfFate:SetSize(0, 0)
    end
    if settings.Get("necroVisibleGaugeComponents")["show-split-soul"] then 
        splitSoul:SetSize(scaleToFactor(24), scaleToFactor(21))
    if events.playerData.necromancy.incantations.splitSoul.active == 1 then
        splitSoul.sprite = overlaySprites.necromancy.incantations.splitSoul.active
        else splitSoul.sprite = overlaySprites.necromancy.incantations.splitSoul.inactive
        end
    else
        splitSoul:SetSize(0, 0)
    end
    if settings.Get("necroVisibleGaugeComponents")["show-invoke-death"] then 
        invokeDeath:SetSize(scaleToFactor(24), scaleToFactor(21))
    if events.playerData.necromancy.incantations.invokeDeath.active == 1 then
        invokeDeath.sprite = overlaySprites.necromancy.incantations.invokeDeath.active
        else invokeDeath.sprite = overlaySprites.necromancy.incantations.invokeDeath.inactive
        end
    else
        invokeDeath:SetSize(0, 0)
    end

    -- Magic Gauge
    -- Sunshine
    if settings.Get("magicVisibleGaugeComponents")["show-sunshine"] then 
        sunshineLayer.hidden = false
        if events.playerData.magic.sunshine.active == 1
            then 
                if events.playerData.ultimates.greater_sunshine_unlocked == 1 then
                    sunshine.sprite = overlaySprites.magic.sunshine.greater_active
                else
                    sunshine.sprite = overlaySprites.magic.sunshine.active
                end
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.combatStyle = 'magic'
                end
                if ticksToSeconds(events.playerData.magic.sunshine.remainingDuration) == 0.0 then
                    events.playerData.magic.sunshine.active = 0
                end
                sunshineText.content = tostring(ticksToSeconds(events.playerData.magic.sunshine.remainingDuration))
            elseif events.playerData.magic.sunshine.cooldown >= 1 then 
                sunshine.sprite = overlaySprites.magic.sunshine.inactive
                sunshineText.content = tostring(ticksToSeconds(events.playerData.magic.sunshine.cooldown))
            else
                if events.playerData.ultimates.greater_sunshine_unlocked == 1 then
                    sunshine.sprite = overlaySprites.magic.sunshine.greater_inactive
                else
                    sunshine.sprite = overlaySprites.magic.sunshine.inactive
                end
                sunshineText.content = ""
                if ticksToSeconds(events.playerData.magic.sunshine.cooldown) == 0.0 then
                    if events.playerData.ultimates.greater_sunshine_unlocked == 1 then
                        sunshine.sprite = overlaySprites.magic.sunshine.greater_active
                    else
                        sunshine.sprite = overlaySprites.magic.sunshine.active
                    end
                    sunshineText.content = "RDY"
                end
        end
    else 
        sunshineLayer.hidden = true
    end

    -- Tsunami
    if settings.Get("magicVisibleGaugeComponents")["show-tsunami"] then 
        tsunamiLayer.hidden = false
        if events.playerData.magic.tsunami.active == 1
            then 
                tsunami.sprite = overlaySprites.magic.tsunami.active
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.combatStyle = 'magic'
                end
                if ticksToSeconds(events.playerData.magic.tsunami.remainingDuration) == 0.0 then
                    events.playerData.magic.tsunami.active = 0
                end
                tsunamiText.content = tostring(ticksToSeconds(events.playerData.magic.tsunami.remainingDuration))
            elseif events.playerData.magic.tsunami.cooldown >= 1 then 
                tsunami.sprite = overlaySprites.magic.tsunami.inactive
                tsunamiText.content = tostring(ticksToSeconds(events.playerData.magic.tsunami.cooldown))
            else
                tsunami.sprite = overlaySprites.magic.tsunami.inactive
                tsunamiText.content = ""
                if ticksToSeconds(events.playerData.magic.tsunami.cooldown) == 0.0 then
                    tsunami.sprite = overlaySprites.magic.tsunami.active
                    tsunamiText.content = "RDY"
                end
        end
    else 
        tsunamiLayer.hidden = true
    end

    -- Runic Charge
    if settings.Get("magicVisibleGaugeComponents")["show-runic-charge"] then 
        runicChargeLayer.hidden = false
        if events.playerData.magic.runic_charge.active == 1
            then 
                runicCharge.sprite = overlaySprites.magic.runic_charge.active
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.combatStyle = 'magic'
                end
                if ticksToSeconds(events.playerData.magic.runic_charge.remainingDuration) == 0.0 then
                    events.playerData.magic.runic_charge.active = 0
                end
                runicChargeText.content = tostring(ticksToSeconds(events.playerData.magic.runic_charge.remainingDuration))
            elseif events.playerData.magic.runic_charge.cooldown >= 1 then 
                runicCharge.sprite = overlaySprites.magic.runic_charge.inactive
                runicChargeText.content = tostring(ticksToSeconds(events.playerData.magic.runic_charge.cooldown))
            else
                runicCharge.sprite = overlaySprites.magic.runic_charge.inactive
                if ticksToSeconds(events.playerData.magic.runic_charge.cooldown) == 0.0 then
                    runicCharge.sprite = overlaySprites.magic.runic_charge.active
                    runicChargeText.content = "RDY"
                end
        end
    else 
        runicChargeLayer.hidden = true
    end

    -- Active Spell
    if settings.Get("magicVisibleGaugeComponents")["show-active-spell"] then 
        activeSpellLayer.hidden = false
        if events.playerData.magic.tsunami.active == 1
            then 
                tsunami.sprite = overlaySprites.magic.tsunami.active
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.combatStyle = 'magic'
                end
                if ticksToSeconds(events.playerData.magic.tsunami.remainingDuration) == 0.0 then
                    events.playerData.magic.tsunami.active = 0
                end
                tsunamiText.content = tostring(ticksToSeconds(events.playerData.magic.tsunami.remainingDuration))
            elseif events.playerData.magic.tsunami.cooldown >= 1 then 
                tsunami.sprite = overlaySprites.magic.tsunami.inactive
                tsunamiText.content = tostring(ticksToSeconds(events.playerData.magic.tsunami.cooldown))
            else
                tsunami.sprite = overlaySprites.magic.tsunami.inactive
                tsunamiText.content = ""
                if ticksToSeconds(events.playerData.magic.tsunami.cooldown) == 0.0 then
                    tsunami.sprite = overlaySprites.magic.tsunami.active
                    tsunamiText.content = "RDY"
                end
        end
    else 
        activeSpellLayer.hidden = true
    end

    if settings.Get("magicVisibleGaugeComponents")["show-active-spell"] then 
        activeSpellLayer:SetSize(scaleToFactor(24), scaleToFactor(21))
        activeSpellLayer.sprite = id.Sprite[events.playerData.magic.active_spell.icon]
    else
        activeSpellLayer:SetSize(0, 0)
    end

end

Event.Logic.Subscribe("updateOverlays", updateOverlays)

  return {
    Destroy = function()
      if settingsBox then
        settingsBox:Destroy()
        settingsBox = nil
      end
      itemRibbon:Destroy()
    end,
  }
end

M.CreateUI = CreateUI

return M


