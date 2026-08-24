local settings = require("resources/database/settings")
local events = require("resources/events/events")
local sprites = require("resources/ui/sprites")

local generalSettings = require("resources/ui/settings/general")
local necromancySettings = require("resources/ui/settings/necromancy")
local magicSettings = require("resources/ui/settings/magic")
local meleeSettings = require("resources/ui/settings/melee")
local rangedSettings = require("resources/ui/settings/ranged")

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

local function createAbilityIndicator(parent, position)
    local layer = ui.Layer.new(parent)
    layer:SetSize(40, 40, 1.0, 1.0)

    local sprite = ui.Sprite.new(layer)
    sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
    sprite:SetSize(scaleToFactor(40), scaleToFactor(40))

    local text = ui.Text.new(layer)
    text:SetPos(
        math.floor(position.x + 8 + OFFSET_POSITION_X),
        math.floor(position.y + 14 + OFFSET_POSITION_Y)
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

local function createSpriteIndicator(parent, position, width, height)
    local sprite = ui.Sprite.new(parent)

    sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
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

local function setSpriteIndicatorPosition(indicator, position)
    indicator:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
end

local CreateUI = function()
    local gameArea = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__GAME_AREA)
    if not gameArea then
    log("Can't find game area")
    return
    end

    local jobGaugeLayer = createGaugeLayer(gameArea)
    local overlaySprites = sprites.CreateSprites(jobGaugeLayer)

    local necromancyGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local conjureUndeadArmy = createAbilityIndicator(necromancyGaugeLayer, GAUGE_COMPONENT_POSITIONS.necromancy.conjureUndeadArmy)
    local livingDeath = createAbilityIndicator(necromancyGaugeLayer, GAUGE_COMPONENT_POSITIONS.necromancy.livingDeath)


    local residualSoulsStacks = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.residualSoulsStacks,
        132,
        24
    )

    local necrosisStacks = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.necrosisStacks,
        132,
        20
    )

    local invokeDeath = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.invokeDeath,
        24,
        21
    )

    local threadsOfFate = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.threadsOfFate,
        24,
        21
    )

    local darkness = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.darkness,
        24,
        21
    )

    local splitSoul = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.splitSoul,
        24,
        21
    )

  -- Magic Overlay
    local magicGaugeLayer = createGaugeLayer(jobGaugeLayer)

    local tsunami = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.tsunami
    )

    local sunshine = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.sunshine
    )

    local runicCharge = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.runicCharge
    )

    local activeSpellSprite = createSpriteIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.activeSpell,
        24,
        21
    )

    local rangedGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local meleeGaugeLayer = createGaugeLayer(jobGaugeLayer)  

    local function updateOverlayPositions()
        local positions = GAUGE_COMPONENT_POSITIONS
        setAbilityIndicatorPosition(
            conjureUndeadArmy,
            positions.necromancy.conjureUndeadArmy
        )

        setAbilityIndicatorPosition(
            livingDeath,
            positions.necromancy.livingDeath
        )

        setSpriteIndicatorPosition(
            residualSoulsStacks,
            positions.necromancy.residualSoulsStacks
        )

        setSpriteIndicatorPosition(
            necrosisStacks,
            positions.necromancy.necrosisStacks
        )

        setSpriteIndicatorPosition(
            invokeDeath,
            positions.necromancy.invokeDeath
        )

        setSpriteIndicatorPosition(
            threadsOfFate,
            positions.necromancy.threadsOfFate
        )

        setSpriteIndicatorPosition(
            darkness,
            positions.necromancy.darkness
        )

        setSpriteIndicatorPosition(
            splitSoul,
            positions.necromancy.splitSoul
        )

        setAbilityIndicatorPosition(
            runicCharge,
            positions.magic.runicCharge
        )

        setAbilityIndicatorPosition(
            tsunami,
            positions.magic.tsunami
        )

        setAbilityIndicatorPosition(
            sunshine,
            positions.magic.sunshine
        )

        setSpriteIndicatorPosition(
            activeSpellSprite,
            positions.magic.activeSpell
        )
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

  local tabs = settingsBox:AddTabs({ "General", "Necromancy", "Magic", "Melee", "Ranged", "Debug" }, { height = -20, heightAnchor = 1.0 })

  local generalPage = tabs:GetPage(1)
  local necromancyPage = tabs:GetPage(2)
  local magicPage = tabs:GetPage(3)
  local meleePage = tabs:GetPage(4)
  local rangedPage = tabs:GetPage(5)
  local debugPage = tabs:GetPage(6)

  -- Page: General
    generalSettings.Create(generalPage, {
        setFontColour = function(colour)
            FONT_COLOUR = hexToVector4(colour)

            for _, text in ipairs(fontTexts) do
                text.colour = FONT_COLOUR
            end
        end,

        setOffsetX = function(value)
            OFFSET_POSITION_X = value
        end,

        setOffsetY = function(value)
            OFFSET_POSITION_Y = value
        end,

        updateOverlayPositions = updateOverlayPositions,
    })
        
    necromancySettings.Create(necromancyPage)
    magicSettings.Create(magicPage)
    -- meleeSettings.Create(meleePage)
    -- rangedSettings.Create(rangedPage)

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
    rangedGaugeLayer.hidden = true
    meleeGaugeLayer.hidden = true

    local combatStyle = events.playerData.combatStyle

    if combatStyle == "necromancy" then
        necromancyGaugeLayer.hidden = false

    elseif combatStyle == "magic" then
        magicGaugeLayer.hidden = false

    elseif combatStyle == "ranged" then
        rangedGaugeLayer.hidden = false

    elseif combatStyle == "melee" then
        meleeGaugeLayer.hidden = false
    end
end

local function getLowestConjureDuration(conjures)
    local lowestDuration = nil

    for _, conjure in pairs(conjures) do
        if conjure.active == 1 and conjure.remainingDuration > 0 then
            if lowestDuration == nil
                or conjure.remainingDuration < lowestDuration
            then
                lowestDuration = conjure.remainingDuration
            end
        end
    end

    return lowestDuration
end

local function updateOverlays()

    if overlaySprites == nil then return end

    local necroSettings = settings.Get("necroVisibleGaugeComponents")
    local magicSettings = settings.Get("magicVisibleGaugeComponents")

    local playerData = events.playerData
    local necromancy = playerData.necromancy
    local magic = playerData.magic
    local ultimates = playerData.ultimates

    if playerData.combatStyle == nil then
        playerData.combatStyle = settings.Get('lastKnownCombatStyle')
    end

    updateGaugeVisibility()
    
    if playerData.inCombat ~= true and settings.Get("hideGaugeOutOfCombat") == "combat-visible" then
        necromancyGaugeLayer.hidden = true
        magicGaugeLayer.hidden = true
        rangedGaugeLayer.hidden = true
        meleeGaugeLayer.hidden = true
     end

    -- Conjure Undead Army
    if necroSettings["show-conjures"] then 
        conjureUndeadArmy.layer.hidden = false

        local conjures = necromancy.conjures
        local lowestDuration = getLowestConjureDuration(conjures)

        if conjures.skeletonWarrior.active == 1
        or conjures.putridZombie.active == 1
        or conjures.vengefulGhost.active == 1
        or conjures.phantomGuardian.active == 1
            then
                conjureUndeadArmy.sprite.sprite = overlaySprites.necromancy.conjures.active
                conjureUndeadArmy.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                if lowestDuration then
                    conjureUndeadArmy.text.content =
                        tostring(ticksToSeconds(lowestDuration))
                else
                    conjureUndeadArmy.text.content = ""
                end
            else 
                conjureUndeadArmy.sprite.sprite = overlaySprites.necromancy.conjures.inactive
                conjureUndeadArmy.text.content = ""
        end
    else 
        conjureUndeadArmy.layer.hidden = true
    end

    if necroSettings["show-living-death"] then 
        livingDeath.layer.hidden = false
        if necromancy.livingDeath.active == 1
            then 
                livingDeath.sprite.sprite = overlaySprites.necromancy.living_death.active
                livingDeath.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                livingDeath.text.content = tostring(ticksToSeconds(necromancy.livingDeath.remainingDuration))
            elseif necromancy.livingDeath.cooldown >= 1 then 
                livingDeath.sprite.sprite = overlaySprites.necromancy.living_death.inactive
                livingDeath.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                livingDeath.text.content = tostring(ticksToSeconds(necromancy.livingDeath.cooldown))
            else
                livingDeath.sprite.sprite = overlaySprites.necromancy.living_death.active
                livingDeath.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                livingDeath.text.content = "Ready"
        end
    else 
        livingDeath.layer.hidden = true
    end
    
    -- Residual Soul Stacks
    if necroSettings["show-residual-souls"] then 
        residualSoulsStacks:SetSize(scaleToFactor(132), scaleToFactor(24))
        if necromancy.residualSoulStacks == 0 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.zero
        elseif necromancy.residualSoulStacks == 1 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.one
        elseif necromancy.residualSoulStacks == 2 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.two
        elseif necromancy.residualSoulStacks == 3 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.three
        elseif necromancy.residualSoulStacks == 4 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.four
        elseif necromancy.residualSoulStacks == 5 then
                residualSoulsStacks.sprite = overlaySprites.necromancy.souls.five
        end
    else 
        residualSoulsStacks:SetSize(0, 0)
    end

    -- Necrosis Stacks
    if necroSettings["show-necrosis-stacks"] then 
        necrosisStacks:SetSize(scaleToFactor(132), scaleToFactor(20))
        if necromancy.necrosisStacks == 0 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.zero
        elseif necromancy.necrosisStacks == 2 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.two
        elseif necromancy.necrosisStacks == 4 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.four
        elseif necromancy.necrosisStacks == 6 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.six
        elseif necromancy.necrosisStacks == 8 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.eight
        elseif necromancy.necrosisStacks == 10 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.ten
        elseif necromancy.necrosisStacks == 12 then
                necrosisStacks.sprite = overlaySprites.necromancy.necrosis.twelve
        end
    else 
        necrosisStacks:SetSize(0, 0)
    end

    -- Incantations
    if necroSettings["show-darkness"] then 
        darkness:SetSize(scaleToFactor(24), scaleToFactor(21))
        if necromancy.incantations.darkness.active == 1 then
            darkness.sprite = overlaySprites.necromancy.incantations.darkness.active
            else darkness.sprite = overlaySprites.necromancy.incantations.darkness.inactive
        end
    else
        darkness:SetSize(0, 0)
    end
    if necroSettings["show-threads-of-fate"] then 
        threadsOfFate:SetSize(scaleToFactor(24), scaleToFactor(21))
    if necromancy.incantations.threadsOfFate.active == 1 then
        threadsOfFate.sprite = overlaySprites.necromancy.incantations.threadsOfFate.active
        else threadsOfFate.sprite = overlaySprites.necromancy.incantations.threadsOfFate.inactive
        end
    else
        threadsOfFate:SetSize(0, 0)
    end
    if necroSettings["show-split-soul"] then 
        splitSoul:SetSize(scaleToFactor(24), scaleToFactor(21))
    if necromancy.incantations.splitSoul.active == 1 then
        splitSoul.sprite = overlaySprites.necromancy.incantations.splitSoul.active
        else splitSoul.sprite = overlaySprites.necromancy.incantations.splitSoul.inactive
        end
    else
        splitSoul:SetSize(0, 0)
    end
    if necroSettings["show-invoke-death"] then 
        invokeDeath:SetSize(scaleToFactor(24), scaleToFactor(21))
    if necromancy.incantations.invokeDeath.active == 1 then
        invokeDeath.sprite = overlaySprites.necromancy.incantations.invokeDeath.active
        else invokeDeath.sprite = overlaySprites.necromancy.incantations.invokeDeath.inactive
        end
    else
        invokeDeath:SetSize(0, 0)
    end

    -- Magic Gauge
    -- Sunshine
    if magicSettings["show-sunshine"] then 
        sunshine.layer.hidden = false
        if magic.sunshine.active == 1
            then 
                if ultimates.greaterSunshineUnlocked == 1 then
                    sunshine.sprite.sprite = overlaySprites.magic.sunshine.greater_active
                else
                    sunshine.sprite.sprite = overlaySprites.magic.sunshine.active
                end
                if ticksToSeconds(magic.sunshine.remainingDuration) == 0.0 then
                    magic.sunshine.active = 0
                end
                sunshine.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                sunshine.text.content = tostring(ticksToSeconds(magic.sunshine.remainingDuration))
            elseif magic.sunshine.cooldown >= 1 then 
                sunshine.sprite.sprite = overlaySprites.magic.sunshine.inactive
                sunshine.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                sunshine.text.content = tostring(ticksToSeconds(magic.sunshine.cooldown))
            else
                if ultimates.greaterSunshineUnlocked == 1 then
                    sunshine.sprite.sprite = overlaySprites.magic.sunshine.greater_active
                else
                    sunshine.sprite.sprite = overlaySprites.magic.sunshine.active
                end
                sunshine.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                sunshine.text.content = "Ready"
        end
    else 
        sunshine.layer.hidden = true
    end

    -- Tsunami
    if magicSettings["show-tsunami"] then 
        tsunami.layer.hidden = false
        if magic.tsunami.active == 1
            then 
                tsunami.sprite.sprite = overlaySprites.magic.tsunami.active
                if ticksToSeconds(magic.tsunami.remainingDuration) == 0.0 then
                    magic.tsunami.active = 0
                end
                tsunami.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                tsunami.text.content = tostring(ticksToSeconds(magic.tsunami.remainingDuration))
            elseif magic.tsunami.cooldown >= 1 then 
                tsunami.sprite.sprite = overlaySprites.magic.tsunami.inactive
                tsunami.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                tsunami.text.content = tostring(ticksToSeconds(magic.tsunami.cooldown))
            else
                tsunami.sprite.sprite = overlaySprites.magic.tsunami.active
                tsunami.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                tsunami.text.content = "Ready"
        end
    else 
        tsunami.layer.hidden = true
    end

    -- Runic Charge
    if magicSettings["show-runic-charge"] then 
        runicCharge.layer.hidden = false
        if magic.runicCharge.active == 1
            then 
                runicCharge.sprite.sprite = overlaySprites.magic.runicCharge.active
                if ticksToSeconds(magic.runicCharge.remainingDuration) == 0.0 then
                    magic.runicCharge.active = 0
                end
                runicCharge.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                runicCharge.text.content = tostring(ticksToSeconds(magic.runicCharge.remainingDuration))
            elseif magic.runicCharge.cooldown >= 1 then 
                runicCharge.sprite.sprite = overlaySprites.magic.runicCharge.inactive
                runicCharge.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                runicCharge.text.content = tostring(ticksToSeconds(magic.runicCharge.cooldown))
            else
                runicCharge.sprite.sprite = overlaySprites.magic.runicCharge.active
                runicCharge.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                runicCharge.text.content = "Ready"
        end
    else 
        runicCharge.layer.hidden = true
    end

    if magicSettings["show-active-spell"] then 
        activeSpellSprite:SetSize(scaleToFactor(24), scaleToFactor(21))
        activeSpellSprite.sprite = id.Sprite[magic.activeSpell.icon]
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
