local settings = require("resources/database/settings")
local events = require("resources/events/events")
local overlay = require("resources/ui/overlay")

local M = {}

-- ============================================================
-- Constants / Configuration
-- ============================================================

-- Globals
local UI_GAUGE_SCALE = 1
local OFFSET_POSITION_X = settings.Get("necroUISettings")["necromancy_gauge_offset_x"]
local OFFSET_POSITION_Y = settings.Get("necroUISettings")["necromancy_gauge_offset_y"]

local GAUGE_COMPONENT_POSITIONS = {
    necromancy = {
        conjureUndeadArmy = { x = 0, y = 0 },
        livingDeath = { x = 40, y = 0 },
        residualSoulsStacks = { x = 2, y = 44 },
        necrosisStacks = { x = 2, y = 67 },

        invokeDeath = { x = 84, y = 0 },
        threadsOfFate = { x = 108, y = 0 },
        darkness = { x = 84, y = 22 },
        splitSoul = { x = 108, y = 22 },
    },

    magic = {
        runicCharge = { x = 0, y = 0 },
        tsunami = { x = 40, y = 0 },
        sunshine = { x = 80, y = 0 },
        activeSpell = { x = 124, y = 11 },
    }
}

local function hexToVector4(hex)
    local r = math.floor(hex / 16777216) % 256
    local g = math.floor(hex / 65536) % 256
    local b = math.floor(hex / 256) % 256
    local a = hex % 256

    return Vector4.new(
        r / 255,
        g / 255,
        b / 255,
        a / 255
    )
end

local FONT_COLOUR = hexToVector4(settings.Get('fontColour'))
local fontTexts = {}

local function ticksToSeconds(ticks)
    local durationDisplayMode = settings.Get("showPreciseDurations")
    if durationDisplayMode == "precise-ticks" then 
        return ticks * 0.6
    else 
        return math.ceil(ticks * 0.6)
    end
end

local function scaleToFactor(number)
    return math.floor(number * UI_GAUGE_SCALE)
end

local function createGaugeLayer(parent)
    local layer = ui.Layer.new(parent)
    layer:SetSize(600, 600, 1.0, 1.0)
    return layer
end

local function createAbilityLayer(parent)
    local layer = ui.Layer.new(parent)
    layer:SetSize(40, 40, 1.0, 1.0)
    return layer
end

local function createIconLayer(parent)
    local layer = ui.Layer.new(parent)
    layer:SetSize(24, 21, 1.0, 1.0)
    return layer
end

local function createAbilityIndicator(parent, x, y)
    local layer = ui.Layer.new(parent)
    layer:SetSize(40, 40, 1.0, 1.0)

    local sprite = ui.Sprite.new(layer)
    sprite:SetPos(
        math.floor(x + OFFSET_POSITION_X),
        math.floor(y + OFFSET_POSITION_Y)
    )
    sprite:SetSize(scaleToFactor(40), scaleToFactor(40))

    local text = ui.Text.new(layer)
    text:SetPos(
        math.floor(x + 8 + OFFSET_POSITION_X),
        math.floor(y + 14 + OFFSET_POSITION_Y)
    )
    text:SetSize(22, 15)
    text:MoveToFront()
    text.content = ""
    text.font = id.Font.MUSEO_SANS_13PT_BOLD
    text.colour = FONT_COLOUR
    text.isShadowed = true
    text.alignHorizontal = ui.AlignMode.CENTRE
    text.alignVertical = ui.AlignMode.CENTRE

    table.insert(fontTexts, text)

    return {
        layer = layer,
        sprite = sprite,
        text = text,
    }
end

local function createSpriteIndicator(parent, x, y, width, height)
    local sprite = ui.Sprite.new(parent)

    sprite:SetPos(
        math.floor(x + OFFSET_POSITION_X),
        math.floor(y + OFFSET_POSITION_Y)
    )

    sprite:SetSize(
        scaleToFactor(width),
        scaleToFactor(height)
    )

    return sprite
end

local function setAbilityIndicatorPosition(indicator, position)
    indicator.sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.text:SetPos(
        math.floor(position.x + 8 + OFFSET_POSITION_X),
        math.floor(position.y + 14 + OFFSET_POSITION_Y)
    )
end

local CreateUI = function()
    local gameArea = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__GAME_AREA)
    if not gameArea then
    log("Can't find game area")
    return
    end

    local jobGaugeLayer = createGaugeLayer(gameArea)
    local overlaySprites = overlay.CreateSprites(jobGaugeLayer)

    local necromancyGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local conjureUndeadArmy = createAbilityIndicator(necromancyGaugeLayer, GAUGE_COMPONENT_POSITIONS.necromancy.conjureUndeadArmy.x, GAUGE_COMPONENT_POSITIONS.necromancy.conjureUndeadArmy.y)
    local livingDeath = createAbilityIndicator(necromancyGaugeLayer, GAUGE_COMPONENT_POSITIONS.necromancy.livingDeath.x, GAUGE_COMPONENT_POSITIONS.necromancy.livingDeath.y)


    local residualSoulsStacks = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.residualSoulsStacks.x,
        GAUGE_COMPONENT_POSITIONS.necromancy.residualSoulsStacks.y,
        132,
        24
    )

    local necrosisStacks = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.necrosisStacks.x,
        GAUGE_COMPONENT_POSITIONS.necromancy.necrosisStacks.y,
        132,
        20
    )

    local invokeDeath = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.invokeDeath.x,
        GAUGE_COMPONENT_POSITIONS.necromancy.invokeDeath.y,
        24,
        21
    )

    local threadsOfFate = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.threadsOfFate.x,
        GAUGE_COMPONENT_POSITIONS.necromancy.threadsOfFate.y,
        24,
        21
    )

    local darkness = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.darkness.x,
        GAUGE_COMPONENT_POSITIONS.necromancy.darkness.y,
        24,
        21
    )

    local splitSoul = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.splitSoul.x,
        GAUGE_COMPONENT_POSITIONS.necromancy.splitSoul.y,
        24,
        21
    )

  -- Magic Overlay
    local magicGaugeLayer = createGaugeLayer(jobGaugeLayer)

    local tsunami = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.tsunami.x,
        GAUGE_COMPONENT_POSITIONS.magic.tsunami.y
    )

    local sunshine = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.sunshine.x,
        GAUGE_COMPONENT_POSITIONS.magic.sunshine.y
    )

    local runicCharge = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.runicCharge.x,
        GAUGE_COMPONENT_POSITIONS.magic.runicCharge.y
    )

    local activeSpellSprite = createSpriteIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.activeSpell.x,
        GAUGE_COMPONENT_POSITIONS.magic.activeSpell.y,
        24,
        21
    )

    local rangedGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local meleeGaugeLayer = createGaugeLayer(jobGaugeLayer)  

    local function updateOverlayPositions()
        
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

    local fontColourPicker = generalPage:AddColourPicker({
        value = settings.Get("fontColour"),
        alphaSlider = true,
        buttonSize = 48,
        windowTitle = "Font Colour",
        tooltip = "Choose the colour of duration and cooldown text",
        acceptText = "Set Color",
        onChange = function(_, colour)
            settings.Set("fontColour", string.format("0x%08X", colour))
            local function updateFontColour(colour)
                FONT_COLOUR = hexToVector4(colour)

                for _, text in ipairs(fontTexts) do
                    text.colour = FONT_COLOUR
                end
            end
            updateFontColour(colour)
        end,
    })

    generalPage:AddText("Dynamically swap active style gauge based on active buffs (ie. after Ultimate Ability used)")
    local dynamicGaugeSetting = generalPage:AddRadioButton({
        { text = "Yes", value = "dynamic" },
        { text = "No", value = "static" },
    }, {
        selectedValue = settings.Get("automaticallySwapGauge"),

        onChange = function(group, colour)
            settings.Set("automaticallySwapGauge", colour)
        end,
    })

    generalPage:AddText("Hide the combat style gauge while out of combat")
    local hideGaugeOutOfCombatRadio = generalPage:AddRadioButton({
        { text = "Yes", value = "combat-visible" },
        { text = "No", value = "always-visible" },
    }, {
        selectedValue = settings.Get("hideGaugeOutOfCombat"),

        onChange = function(group, value)
            settings.Set("hideGaugeOutOfCombat", value)
        end,
    })

    generalPage:AddText("Show precise time remaining or round to the nearest second?")
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

    local necroComponentSettings = settings.Get("necroVisibleGaugeComponents")

    local necroVisibleGaugeComponents = necroPage:AddCheckboxButton({
        { text = "Show Conjures", value = "show-conjures", selected = necroComponentSettings["show-conjures"] },
        { text = "Show Residual Souls", value = "show-residual-souls", selected = necroComponentSettings["show-residual-souls"] },
        { text = "Show Necrosis Stacks", value = "show-necrosis-stacks", selected = necroComponentSettings["show-necrosis-stacks"] },
        { text = "Show Bloat", value = "show-bloat", selected = necroComponentSettings["show-bloat"] },
        { text = "Show Living Death", value = "show-living-death", selected = necroComponentSettings["show-living-death"] },
        { text = "Show Invoke Death", value = "show-invoke-death", selected = necroComponentSettings["show-invoke-death"] },
        { text = "Show Darkness", value = "show-darkness", selected = necroComponentSettings["show-darkness"] },
        { text = "Show Threads of Fate", value = "show-threads-of-fate", selected = necroComponentSettings["show-threads-of-fate"] },
        { text = "Show Split Soul", value = "show-split-soul", selected = necroComponentSettings["show-split-soul"] },
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

  -- Page: Magic

    local magicComponentSettings = settings.Get("magicVisibleGaugeComponents")

    local magicVisibleGaugeComponents = magicPage:AddCheckboxButton({
        { text = "Show Sunshine", value = "show-sunshine", selected = magicComponentSettings["show-sunshine"] },
        { text = "Show Tsunami", value = "show-tsunami", selected = magicComponentSettings["show-tsunami"] },
        { text = "Show Runic Charge", value = "show-runic-charge", selected = magicComponentSettings["show-runic-charge"] },
        { text = "Show Instability (Fractured Staff of Armadyl Special Attack)", value = "show-instability", selected = magicComponentSettings["show-instability"] },
        { text = "Show Soulfire (Roar of Awakening Special Attack)", value = "show-soulfire", selected = magicComponentSettings["show-soulfire"] },
        { text = "Show Active Spell", value = "show-active-spell", selected = magicComponentSettings["show-active-spell"] },
    }, {
        onChange = function(group, values, changedValue, selected)
            local current = settings.Get("magicVisibleGaugeComponents")
            current[changedValue] = selected
            settings.Set("magicVisibleGaugeComponents", current)
        end,
    })

  -- Page: Melee

  -- Page: Ranged

  -- Page: Debug
  debugPage:AddTitle("Player State")

  local playerInCombatDebugLabel = debugPage:AddText("In Combat: false")

    debugPage:AddText("Force Active Combat Style (Changing this setting will disable the Dynamic Swapping setting)")
    local forceCombatStyle = debugPage:AddRadioButton({
        { text = "Necromancy", value = "necromancy" },
        { text = "Magic", value = "magic" },
        { text = "Ranged", value = "ranged" },
        { text = "Melee", value = "melee" }
    }, {
        selectedValue = '',

        onChange = function(_, value)
            events.playerData.combatStyle = value
            dynamicGaugeSetting:SetSelectedValue('static')
            settings.Set('automaticallySwapGauge', 'static')
            settings.Set('lastKnownCombatStyle', value)
        end,
    })

  

local function updateDebugData()
    playerInCombatDebugLabel.content = "In Combat: " .. tostring(events.playerData.inCombat)
end

Event.VarTransmit.Subscribe("updateDebugData", updateDebugData)

local function updateGaugeVisibility()
    necromancyGaugeLayer.hidden = true
    magicGaugeLayer.hidden = true
    -- rangedGaugeLayer.hidden = true
    -- meleeGaugeLayer.hidden = true

    if events.playerData.combatStyle == nil then
        events.playerData.combatStyle = settings.Get('lastKnownCombatStyle')
    end

    if events.playerData.combatStyle == 'necromancy' then
        necromancyGaugeLayer.hidden = false

    elseif events.playerData.combatStyle == 'magic' then
        magicGaugeLayer.hidden = false

    elseif events.playerData.combatStyle == 'ranged' then
        -- rangedGaugeLayer.hidden = false

    elseif events.playerData.combatStyle == 'melee' then
        -- meleeGaugeLayer.hidden = false
    end
end

local function updateOverlays()

    if overlaySprites == nil then return end

    updateGaugeVisibility()
    
    if events.playerData.inCombat ~= true and settings.Get("hideGaugeOutOfCombat") == "combat-visible" then
        necromancyGaugeLayer.hidden = true
        magicGaugeLayer.hidden = true
        rangedGaugeLayer.hidden = true
        meleeGaugeLayer.hidden = true
     end

    -- Conjure Undead Army
    if settings.Get("necroVisibleGaugeComponents")["show-conjures"] then 
        conjureUndeadArmy.layer.hidden = false
        if events.playerData.necromancy.conjures.skeletonWarrior.active == 1
        or events.playerData.necromancy.conjures.putridZombie.active == 1
        or events.playerData.necromancy.conjures.vengefulGhost.active == 1
        or events.playerData.necromancy.conjures.phantomGuardian.active == 1
            then
                conjureUndeadArmy.sprite.sprite = overlaySprites.necromancy.conjures.active
                conjureUndeadArmy.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                if (events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration > 0) then
                    conjureUndeadArmy.text.content = tostring(ticksToSeconds(events.playerData.necromancy.conjures.skeletonWarrior.remainingDuration))
                end
            else 
                conjureUndeadArmy.sprite.sprite = overlaySprites.necromancy.conjures.inactive
                conjureUndeadArmy.text.content = ""
        end
    else 
        conjureUndeadArmy.layer.hidden = true
    end

    if settings.Get("necroVisibleGaugeComponents")["show-living-death"] then 
        livingDeath.layer.hidden = false
        if events.playerData.necromancy.livingDeath.active == 1
            then 
                livingDeath.sprite.sprite = overlaySprites.necromancy.living_death.active
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.playerData.combatStyle = 'necromancy'
                    settings.Set('lastKnownCombatStyle', 'necromancy')
                end
                livingDeath.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                livingDeath.text.content = tostring(ticksToSeconds(events.playerData.necromancy.livingDeath.remainingDuration))
            elseif events.playerData.necromancy.livingDeath.cooldown >= 1 then 
                livingDeath.sprite.sprite = overlaySprites.necromancy.living_death.inactive
                livingDeath.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                livingDeath.text.content = tostring(ticksToSeconds(events.playerData.necromancy.livingDeath.cooldown))
            else
                livingDeath.sprite.sprite = overlaySprites.necromancy.living_death.inactive
                livingDeath.text.content = ""
                if ticksToSeconds(events.playerData.necromancy.livingDeath.cooldown) == 0.0 then
                    livingDeath.sprite.sprite = overlaySprites.necromancy.living_death.active
                    livingDeath.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                    livingDeath.text.content = "Ready"
                end
        end
    else 
        livingDeath.layer.hidden = true
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
        sunshine.layer.hidden = false
        if events.playerData.magic.sunshine.active == 1
            then 
                if events.playerData.ultimates.greaterSunshineUnlocked == 1 then
                    sunshine.sprite.sprite = overlaySprites.magic.sunshine.greater_active
                else
                    sunshine.sprite.sprite = overlaySprites.magic.sunshine.active
                end
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.playerData.combatStyle = 'magic'
                    settings.Set('lastKnownCombatStyle', 'magic')
                end
                if ticksToSeconds(events.playerData.magic.sunshine.remainingDuration) == 0.0 then
                    events.playerData.magic.sunshine.active = 0
                end
                sunshine.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                sunshine.text.content = tostring(ticksToSeconds(events.playerData.magic.sunshine.remainingDuration))
            elseif events.playerData.magic.sunshine.cooldown >= 1 then 
                sunshine.sprite.sprite = overlaySprites.magic.sunshine.inactive
                sunshine.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                sunshine.text.content = tostring(ticksToSeconds(events.playerData.magic.sunshine.cooldown))
            else
                if events.playerData.ultimates.greaterSunshineUnlocked == 1 then
                    sunshine.sprite.sprite = overlaySprites.magic.sunshine.greater_inactive
                else
                    sunshine.sprite.sprite = overlaySprites.magic.sunshine.inactive
                end
                sunshine.text.content = ""
                if ticksToSeconds(events.playerData.magic.sunshine.cooldown) == 0.0 then
                    if events.playerData.ultimates.greaterSunshineUnlocked == 1 then
                        sunshine.sprite.sprite = overlaySprites.magic.sunshine.greater_active
                    else
                        sunshine.sprite.sprite = overlaySprites.magic.sunshine.active
                    end
                    sunshine.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                    sunshine.text.content = "Ready"
                end
        end
    else 
        sunshine.layer.hidden = true
    end

    -- Tsunami
    if settings.Get("magicVisibleGaugeComponents")["show-tsunami"] then 
        tsunami.layer.hidden = false
        if events.playerData.magic.tsunami.active == 1
            then 
                tsunami.sprite.sprite = overlaySprites.magic.tsunami.active
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.playerData.combatStyle = 'magic'
                    settings.Set('lastKnownCombatStyle', 'magic')
                end
                if ticksToSeconds(events.playerData.magic.tsunami.remainingDuration) == 0.0 then
                    events.playerData.magic.tsunami.active = 0
                end
                tsunami.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                tsunami.text.content = tostring(ticksToSeconds(events.playerData.magic.tsunami.remainingDuration))
            elseif events.playerData.magic.tsunami.cooldown >= 1 then 
                tsunami.sprite.sprite = overlaySprites.magic.tsunami.inactive
                tsunami.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                tsunami.text.content = tostring(ticksToSeconds(events.playerData.magic.tsunami.cooldown))
            else
                tsunami.sprite.sprite = overlaySprites.magic.tsunami.inactive
                tsunami.text.content = ""
                if ticksToSeconds(events.playerData.magic.tsunami.cooldown) == 0.0 then
                    tsunami.sprite.sprite = overlaySprites.magic.tsunami.active
                    tsunami.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                    tsunami.text.content = "Ready"
                end
        end
    else 
        tsunami.layer.hidden = true
    end

    -- Runic Charge
    if settings.Get("magicVisibleGaugeComponents")["show-runic-charge"] then 
        runicCharge.layer.hidden = false
        if events.playerData.magic.runicCharge.active == 1
            then 
                runicCharge.sprite.sprite = overlaySprites.magic.runicCharge.active
                if settings.Get('automaticallySwapGauge') == 'dynamic' then
                    events.playerData.combatStyle = 'magic'
                    settings.Set('lastKnownCombatStyle', 'magic')
                end
                if ticksToSeconds(events.playerData.magic.runicCharge.remainingDuration) == 0.0 then
                    events.playerData.magic.runicCharge.active = 0
                end
                runicCharge.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                runicCharge.text.content = tostring(ticksToSeconds(events.playerData.magic.runicCharge.remainingDuration))
            elseif events.playerData.magic.runicCharge.cooldown >= 1 then 
                runicCharge.sprite.sprite = overlaySprites.magic.runicCharge.inactive
                runicCharge.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                runicCharge.text.content = tostring(ticksToSeconds(events.playerData.magic.runicCharge.cooldown))
            else
                runicCharge.sprite.sprite = overlaySprites.magic.runicCharge.inactive
                if ticksToSeconds(events.playerData.magic.runicCharge.cooldown) == 0.0 then
                    runicCharge.sprite.sprite = overlaySprites.magic.runicCharge.active
                    runicCharge.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                    runicCharge.text.content = "Ready"
                end
        end
    else 
        runicCharge.layer.hidden = true
    end

    if settings.Get("magicVisibleGaugeComponents")["show-active-spell"] then 
        activeSpellSprite:SetSize(scaleToFactor(24), scaleToFactor(21))
        activeSpellSprite.sprite = id.Sprite[events.playerData.magic.activeSpell.icon]
    else
        activeSpellSprite:SetSize(0, 0)
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
