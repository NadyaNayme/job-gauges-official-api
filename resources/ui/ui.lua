local settings = require("resources/database/settings")
local events = require("resources/events/events")
local sprites = require("resources/ui/sprites")
local guthixian = require("resources/data/guthixian")

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
local OFFSET_POSITION_X = settings.Get("gaugeOffsetX")
local OFFSET_POSITION_Y = settings.Get("gaugeOffsetY")
local isDraggingOverlay = false

local GAUGE_COMPONENT_POSITIONS = {
    necromancy = {
        conjureUndeadArmy = { x = 0, y = 0 },
        livingDeath = { x = 40, y = 0 },
        residualSoulsStacks = { x = 2, y = 44 },
        bloat = { x = 2, y = 87 },
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
        soulfire = { x = 0, y = -34 },
        instability = { x = 40, y = -34 },
        activeSpell = { x = 88, y = -24 },
        upkeep = {
            bloodTithe = { x = 0, y = 50 },
            inciteFear = { x = 0, y = 70 },
            essenceCorruption = { x = 0, y = 90 },
        },
    },
    
    ranged = {
        deathsSwiftness = { x = 80, y = 0 },
        searingWinds = { x = 0, y = 0 },
        shadowImbued = { x = 40, y = 0 },
        perfectEquilibrium = { x = -20, y = -40 },
        guthixianRunes = { x = 20, y = -30 }
    }
}

local RUNE_LAYOUT = {
    BALANCE = {
        [1] = { x_offset = 0,   size = { width = 24, height = 24 } },
        [2] = { x_offset = 12,  size = { width = 24, height = 24 } },
        [3] = { x_offset = 28,  size = { width = 24, height = 24 } },
        [4] = { x_offset = 36,  size = { width = 24, height = 24 } },
        [5] = { x_offset = 50,  size = { width = 24, height = 24 } },
        [6] = { x_offset = 66,  size = { width = 24, height = 24 } },
        [7] = { x_offset = 82,  size = { width = 24, height = 24 } },
        stacksText = { x = 120, y = -30},
    },

    NYU = {
        [1] = { x_offset = 0,   size = { width = 24, height = 24 } },
        [2] = { x_offset = 12,  size = { width = 24, height = 24 } },
        [3] = { x_offset = 28,  size = { width = 24, height = 24 } },
        stacksText = { x = 67, y = -30},
    },

    SEVEN = {
        [1] = { x_offset = 0,   size = { width = 24, height = 24 } },
        [2] = { x_offset = 12,  size = { width = 24, height = 24 } },
        [3] = { x_offset = 24,  size = { width = 24, height = 24 } },
        [4] = { x_offset = 36,  size = { width = 24, height = 24 } },
        [5] = { x_offset = 48,  size = { width = 24, height = 24 } },
        [6] = { x_offset = 60,  size = { width = 24, height = 24 } },
        [7] = { x_offset = 72,  size = { width = 24, height = 24 } },
        stacksText = { x = 120, y = -30},
    },

    THREE = {
        [1] = { x_offset = 0,   size = { width = 24, height = 24 } },
        [2] = { x_offset = 12,  size = { width = 24, height = 24 } },
        [3] = { x_offset = 24,  size = { width = 24, height = 24 } },
        stacksText = { x = 67, y = -30},
    },
}

local INACTIVE_RUNE_COLOUR = Vector4.new(1.0, 0.1, 0.1, 1.0)
local ACTIVE_RUNE_COLOUR = Vector4.new(0.3686, 0.9922, 0.5765, 1.0)
local ACTIVE_RUNE_SHADOW_COLOUR = Vector4.new(0.1, 0.1, 0.1, 1.0)
local INACTIVE_RUNE_SHADOW_COLOUR = Vector4.new(0.8, 0.8, 0.8, 0.25)
local RUNE_SHADOW_OFFSET = 1

local function getRuneLayout(perfectEquilibriumActive)
    local selectedGuthixianRune = settings.Get("selectedGuthixianRune") or "lore"

    if selectedGuthixianRune == "lore" then
        if perfectEquilibriumActive then
            return RUNE_LAYOUT.NYU
        else
            return RUNE_LAYOUT.BALANCE
        end
    else
        if perfectEquilibriumActive then
            return RUNE_LAYOUT.THREE
        else
            return RUNE_LAYOUT.SEVEN
        end
    end
end

local bolgLetters = {}

local function createBOLGLetters(parent)
    for i = 1, 7 do

        local shadow = ui.Sprite.new(parent)
        shadow:SetSize(0, 0)

        local sprite = ui.Sprite.new(parent)
        sprite:SetSize(0, 0)
        sprite:MoveToFront()

        bolgLetters[i] = {
            shadow = shadow,
            sprite = sprite,
        }
    end
end

local function updateBOLGLetters(stacks, perfectEquilibriumActive)

    local word

    local selectedGuthixianRune = settings.Get("selectedGuthixianRune") or "lore"

    if selectedGuthixianRune == "lore" then
        if perfectEquilibriumActive then
            word = "NYU"
        else
            word = "BALANCE"
        end
    else
        if perfectEquilibriumActive then
            word = selectedGuthixianRune:rep(3)
        else
            word = selectedGuthixianRune:rep(7)
        end
    end

    local layout

    if selectedGuthixianRune == "lore" then
        if perfectEquilibriumActive then
            layout = RUNE_LAYOUT.NYU
        else
            layout = RUNE_LAYOUT.BALANCE
        end
    else
        if perfectEquilibriumActive then
            layout = RUNE_LAYOUT.THREE
        else
            layout = RUNE_LAYOUT.SEVEN
        end
    end

    local position = GAUGE_COMPONENT_POSITIONS.ranged.guthixianRunes

    for i = 1, #bolgLetters do

        local rune = bolgLetters[i]
        local sprite = rune.sprite
        local shadow = rune.shadow
        local runeLayout = layout[i]

        if runeLayout then

            local letter

            if selectedGuthixianRune == "lore" then
                letter = word:sub(i, i)
            else
                letter = selectedGuthixianRune
            end

            local spriteId = guthixian[letter]

            shadow.sprite = spriteId
            sprite.sprite = spriteId

            local x = runeLayout.x_offset + position.x + OFFSET_POSITION_X
            local y = position.y + OFFSET_POSITION_Y

            shadow:SetPos(
                x + RUNE_SHADOW_OFFSET,
                y + RUNE_SHADOW_OFFSET
            )

            shadow:SetSize(
                runeLayout.size.width,
                runeLayout.size.height
            )

            sprite:SetPos(
                x,
                y
            )

            sprite:SetSize(
                runeLayout.size.width,
                runeLayout.size.height
            )

            if i <= stacks then
                sprite.colour = ACTIVE_RUNE_COLOUR
                shadow.colour = ACTIVE_RUNE_SHADOW_COLOUR
            else
                sprite.colour = INACTIVE_RUNE_COLOUR
                shadow.colour = INACTIVE_RUNE_SHADOW_COLOUR
            end

        else
            shadow:SetSize(0, 0)
            sprite:SetSize(0, 0)
        end
    end
end

local function hexToVector4(hex)
    if hex == nil then return end
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

local ABILITY_SHADOW_COLOUR = hexToVector4(settings.Get("abilityShadowColour"))
local ABILITY_SHADOW_SIZE = 42
local ABILITY_SHADOW_OFFSET = -1
local abilityShadows = {}

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

local function setAbilityIndicatorSprite(indicator, sprite, shadowSprite)
    indicator.shadow.sprite = shadowSprite
    indicator.sprite.sprite = sprite
end

local function createAbilityIndicator(parent, position)
    local layer = ui.Layer.new(parent)
    layer:SetSize(40, 40, 1.0, 1.0)

    local shadow = ui.Sprite.new(layer)
    shadow:SetPos(
        math.floor(position.x + OFFSET_POSITION_X + ABILITY_SHADOW_OFFSET),
        math.floor(position.y + OFFSET_POSITION_Y + ABILITY_SHADOW_OFFSET)
    )
    shadow:SetSize(scaleToFactor(ABILITY_SHADOW_SIZE), scaleToFactor(ABILITY_SHADOW_SIZE))
    shadow.colour = ABILITY_SHADOW_COLOUR

    local sprite = ui.Sprite.new(layer)
    sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
    sprite:SetSize(scaleToFactor(40), scaleToFactor(40))
    sprite:MoveToFront()

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
    table.insert(abilityShadows, shadow)

    return {
        layer = layer,
        shadow = shadow,
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

local function createMagicUpkeepIndicator(parent, position)
    local layer = ui.Layer.new(parent)
    layer:SetSize(90, 24, 1.0, 1.0)

    local timeText = ui.Text.new(layer)
    timeText:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + 4 + OFFSET_POSITION_Y)
    )
    timeText:SetSize(28, 16)
    timeText.content = ""
    timeText.font = id.Font.MUSEO_SANS_13PT_BOLD
    timeText.colour = FONT_COLOUR
    timeText.isShadowed = true

    local sprite = ui.Sprite.new(layer)
    sprite:SetPos(
        math.floor(position.x + 32 + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
    sprite:SetSize(scaleToFactor(24), scaleToFactor(21))

    local stacksText = ui.Text.new(layer)
    stacksText:SetPos(
        math.floor(position.x + 58 + OFFSET_POSITION_X),
        math.floor(position.y + 4 + OFFSET_POSITION_Y)
    )
    stacksText:SetSize(28, 16)
    stacksText.content = ""
    stacksText.font = id.Font.MUSEO_SANS_13PT_BOLD
    stacksText.colour = FONT_COLOUR
    stacksText.isShadowed = true

    table.insert(fontTexts, timeText)
    table.insert(fontTexts, stacksText)

    return {
        layer = layer,
        timeText = timeText,
        sprite = sprite,
        stacksText = stacksText,
    }
end

local function setAbilityIndicatorPosition(indicator, position)
    indicator.shadow:SetPos(
        math.floor(position.x + OFFSET_POSITION_X + ABILITY_SHADOW_OFFSET),
        math.floor(position.y + OFFSET_POSITION_Y + ABILITY_SHADOW_OFFSET)
    )

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

local function setMagicUpkeepIndicatorPosition(indicator, position)
    indicator.timeText:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + 4 + OFFSET_POSITION_Y)
    )

    indicator.sprite:SetPos(
        math.floor(position.x + 32 + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.stacksText:SetPos(
        math.floor(position.x + 58 + OFFSET_POSITION_X),
        math.floor(position.y + 4 + OFFSET_POSITION_Y)
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

    local bloat = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.bloat,
        132,
        24
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

    local soulfire = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.soulfire
    )

    local instability = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.instability
    )

    local activeSpellSprite = createSpriteIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.activeSpell,
        24,
        21
    )

    local bloodTithe = createMagicUpkeepIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.upkeep.bloodTithe
    )

    local inciteFear = createMagicUpkeepIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.upkeep.inciteFear
    )

    local essenceCorruption = createMagicUpkeepIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.upkeep.essenceCorruption
    )

    local rangedGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local deathsSwiftness = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.deathsSwiftness
    )

    local searingWinds = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.searingWinds
    )

    local shadowImbued = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.shadowImbued
    )

    local perfectEquilibrium = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.perfectEquilibrium
    )

    createBOLGLetters(rangedGaugeLayer)

    local perfectEquilibriumStacksText = ui.Text.new(rangedGaugeLayer)
    perfectEquilibriumStacksText:SetSize(22, 24)
    perfectEquilibriumStacksText:MoveToFront()
    perfectEquilibriumStacksText.content = "0"
    perfectEquilibriumStacksText.font = id.Font.MUSEO_SANS_15PT_BOLD
    perfectEquilibriumStacksText.colour = FONT_COLOUR
    perfectEquilibriumStacksText.isShadowed = true
    perfectEquilibriumStacksText.alignHorizontal = ui.AlignMode.CENTRE
    perfectEquilibriumStacksText.alignVertical = ui.AlignMode.CENTRE

    table.insert(fontTexts, perfectEquilibriumStacksText)
    

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
            bloat,
            positions.necromancy.bloat
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

        setAbilityIndicatorPosition(
            soulfire,
            positions.magic.soulfire
        )

        setAbilityIndicatorPosition(
            instability,
            positions.magic.instability
        )

        setSpriteIndicatorPosition(
            activeSpellSprite,
            positions.magic.activeSpell
        )

        setMagicUpkeepIndicatorPosition(
            bloodTithe,
            positions.magic.upkeep.bloodTithe
        )

        setMagicUpkeepIndicatorPosition(
            inciteFear,
            positions.magic.upkeep.inciteFear
        )

        setMagicUpkeepIndicatorPosition(
            essenceCorruption,
            positions.magic.upkeep.essenceCorruption
        )

        setAbilityIndicatorPosition(
            deathsSwiftness,
            positions.ranged.deathsSwiftness
        )

        setAbilityIndicatorPosition(
            searingWinds,
            positions.ranged.searingWinds
        )

        setAbilityIndicatorPosition(
            shadowImbued,
            positions.ranged.shadowImbued
        )

        setAbilityIndicatorPosition(
            perfectEquilibrium,
            positions.ranged.perfectEquilibrium
        )

    local perfectEquilibriumActive = events.playerData.ranged.perfectEquilibrium.active == 1
    local layout = getRuneLayout(perfectEquilibriumActive)

    perfectEquilibriumStacksText:SetPos(
        math.floor(layout.stacksText.x + OFFSET_POSITION_X),
        math.floor(layout.stacksText.y + OFFSET_POSITION_Y)
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

  local tabs = settingsBox:AddTabs({ "General", "Necromancy", "Magic", "Melee", "Ranged" }, { height = -20, heightAnchor = 1.0 })

  local generalPage = tabs:GetPage(1)
  local necromancyPage = tabs:GetPage(2)
  local magicPage = tabs:GetPage(3)
  local meleePage = tabs:GetPage(4)
  local rangedPage = tabs:GetPage(5)

  -- Page: General
    generalSettings.Create(generalPage, {
        setFontColour = function(colour)
            FONT_COLOUR = hexToVector4(colour)

            for _, text in ipairs(fontTexts) do
                text.colour = FONT_COLOUR
            end
        end,

        setAbilityShadowColour = function(colour)
            ABILITY_SHADOW_COLOUR = hexToVector4(colour)
            for _, ability in ipairs(abilityShadows) do
                ability.colour = ABILITY_SHADOW_COLOUR
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
    rangedSettings.Create(rangedPage)

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

local function updateMagicUpkeepIndicator(indicator, upkeep, sprite)
    indicator.sprite.sprite = sprite
    indicator.timeText.content = tostring(ticksToSeconds(upkeep.remainingDuration))
    indicator.stacksText.content = tostring(upkeep.stacks)
end

local function updateOverlays()

    if overlaySprites == nil then return end

    local necroSettings = settings.Get("necroVisibleGaugeComponents")
    local magicSettings = settings.Get("magicVisibleGaugeComponents")
    local rangedSettings = settings.Get("rangedVisibleGaugeComponents")

    local playerData = events.playerData
    local necromancy = playerData.necromancy
    local magic = playerData.magic
    local ranged = playerData.ranged
    -- local melee = playerData.melee
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
                setAbilityIndicatorSprite(
                    conjureUndeadArmy,
                    overlaySprites.necromancy.conjures.active,
                    overlaySprites.utility.shadow
                )
                conjureUndeadArmy.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                if lowestDuration then
                    conjureUndeadArmy.text.content =
                        tostring(ticksToSeconds(lowestDuration))
                else
                    conjureUndeadArmy.text.content = ""
                end
            else 
                setAbilityIndicatorSprite(
                    conjureUndeadArmy,
                    overlaySprites.necromancy.conjures.inactive,
                    overlaySprites.utility.shadow
                )
                conjureUndeadArmy.text.content = ""
        end
    else 
        conjureUndeadArmy.layer.hidden = true
    end

    if necroSettings["show-living-death"] then 
        livingDeath.layer.hidden = false
        if necromancy.livingDeath.active == 1
            then 
                setAbilityIndicatorSprite(
                    livingDeath,
                    overlaySprites.necromancy.living_death.active,
                    overlaySprites.utility.shadow
                )
                livingDeath.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                livingDeath.text.content = tostring(ticksToSeconds(necromancy.livingDeath.remainingDuration))
            elseif necromancy.livingDeath.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    livingDeath,
                    overlaySprites.necromancy.living_death.inactive,
                    overlaySprites.utility.shadow
                )
                livingDeath.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                livingDeath.text.content = tostring(ticksToSeconds(necromancy.livingDeath.cooldown))
            else
                setAbilityIndicatorSprite(
                    livingDeath,
                    overlaySprites.necromancy.living_death.active,
                    overlaySprites.utility.shadow
                )
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

    if necroSettings["show-bloat"] then
        bloat:SetSize(scaleToFactor(132), scaleToFactor(24))

        if necromancy.bloat.active then
            if necromancy.bloat.remainingDuration < 1 then
                bloat.sprite = overlaySprites.necromancy.bloat.expired
            elseif necromancy.bloat.remainingDuration < 3 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_0
            elseif necromancy.bloat.remainingDuration < 6 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_10
            elseif necromancy.bloat.remainingDuration < 9 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_20
            elseif necromancy.bloat.remainingDuration < 12 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_30
            elseif necromancy.bloat.remainingDuration < 15 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_40
            elseif necromancy.bloat.remainingDuration < 18 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_50
            elseif necromancy.bloat.remainingDuration < 21 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_60
            elseif necromancy.bloat.remainingDuration < 24 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_70
            elseif necromancy.bloat.remainingDuration < 27 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_80
            elseif necromancy.bloat.remainingDuration < 30 then
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_90
            else
                bloat.sprite = overlaySprites.necromancy.bloat.bloat_100
            end
        else
            bloat.sprite = overlaySprites.necromancy.bloat.expired
        end
    else
        bloat:SetSize(0, 0)
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
                    setAbilityIndicatorSprite(
                        sunshine,
                        overlaySprites.magic.sunshine.greater_active,
                        overlaySprites.utility.shadow
                    )
                else
                    setAbilityIndicatorSprite(
                        sunshine,
                        overlaySprites.magic.sunshine.active,
                        overlaySprites.utility.shadow
                    )
                end
                if ticksToSeconds(magic.sunshine.remainingDuration) == 0.0 then
                    magic.sunshine.active = 0
                end
                sunshine.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                sunshine.text.content = tostring(ticksToSeconds(magic.sunshine.remainingDuration))
            elseif magic.sunshine.cooldown >= 1 then 
                if ultimates.greaterSunshineUnlocked == 1 then
                    setAbilityIndicatorSprite(
                        sunshine,
                        overlaySprites.magic.sunshine.greater_inactive,
                        overlaySprites.utility.shadow
                    )
                else
                    setAbilityIndicatorSprite(
                        sunshine,
                        overlaySprites.magic.sunshine.inactive,
                        overlaySprites.utility.shadow
                    )
                end
                sunshine.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                sunshine.text.content = tostring(ticksToSeconds(magic.sunshine.cooldown))
            else
                if ultimates.greaterSunshineUnlocked == 1 then
                    setAbilityIndicatorSprite(
                        sunshine,
                        overlaySprites.magic.sunshine.greater_active,
                        overlaySprites.utility.shadow
                    )
                else
                    setAbilityIndicatorSprite(
                        sunshine,
                        overlaySprites.magic.sunshine.active,
                        overlaySprites.utility.shadow
                    )
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
                setAbilityIndicatorSprite(
                    tsunami,
                    overlaySprites.magic.tsunami.active,
                    overlaySprites.utility.shadow
                )
                if ticksToSeconds(magic.tsunami.remainingDuration) == 0.0 then
                    magic.tsunami.active = 0
                end
                tsunami.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                tsunami.text.content = tostring(ticksToSeconds(magic.tsunami.remainingDuration))
            elseif magic.tsunami.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    tsunami,
                    overlaySprites.magic.tsunami.inactive,
                    overlaySprites.utility.shadow
                )
                tsunami.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                tsunami.text.content = tostring(ticksToSeconds(magic.tsunami.cooldown))
            else
                setAbilityIndicatorSprite(
                    tsunami,
                    overlaySprites.magic.tsunami.active,
                    overlaySprites.utility.shadow
                )
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
                setAbilityIndicatorSprite(
                    runicCharge,
                    overlaySprites.magic.runicCharge.active,
                    overlaySprites.utility.shadow
                )
                if ticksToSeconds(magic.runicCharge.remainingDuration) == 0.0 then
                    magic.runicCharge.active = 0
                end
                runicCharge.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                runicCharge.text.content = tostring(ticksToSeconds(magic.runicCharge.remainingDuration))
            elseif magic.runicCharge.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    runicCharge,
                    overlaySprites.magic.runicCharge.inactive,
                    overlaySprites.utility.shadow
                )
                runicCharge.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                runicCharge.text.content = tostring(ticksToSeconds(magic.runicCharge.cooldown))
            else
                setAbilityIndicatorSprite(
                    runicCharge,
                    overlaySprites.magic.runicCharge.active,
                    overlaySprites.utility.shadow
                )
                runicCharge.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                runicCharge.text.content = "Ready"
        end
    else 
        runicCharge.layer.hidden = true
    end

    if magicSettings["show-soulfire"] then 
        soulfire.layer.hidden = false
        if magic.soulfire.active == 1
            then 
                soulfire.sprite.sprite = overlaySprites.magic.soulfire.active
                if ticksToSeconds(magic.soulfire.remainingDuration) == 0.0 then
                    magic.soulfire.active = 0
                end
                soulfire.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                soulfire.text.content = tostring(ticksToSeconds(magic.soulfire.remainingDuration))
            elseif magic.soulfire.cooldown >= 1 then 
                soulfire.sprite.sprite = overlaySprites.magic.soulfire.inactive
                soulfire.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                soulfire.text.content = tostring(ticksToSeconds(magic.soulfire.cooldown))
            else
                soulfire.sprite.sprite = overlaySprites.magic.soulfire.active
                soulfire.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                soulfire.text.content = "Ready"
        end
    else 
        soulfire.layer.hidden = true
    end

    if magicSettings["show-instability"] then 
        instability.layer.hidden = false
        if magic.instability.active == 1
            then 
                instability.sprite.sprite = overlaySprites.magic.instability.active
                if ticksToSeconds(magic.instability.remainingDuration) == 0.0 then
                    magic.instability.active = 0
                end
                instability.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                instability.text.content = tostring(ticksToSeconds(magic.instability.remainingDuration))
            elseif magic.instability.cooldown >= 1 then 
                instability.sprite.sprite = overlaySprites.magic.instability.inactive
                instability.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                instability.text.content = tostring(ticksToSeconds(magic.instability.cooldown))
            else
                instability.sprite.sprite = overlaySprites.magic.instability.active
                instability.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                instability.text.content = "Ready"
        end
    else 
        instability.layer.hidden = true
    end

    if magicSettings["show-active-spell"] then 
        activeSpellSprite:SetSize(scaleToFactor(24), scaleToFactor(21))
        activeSpellSprite.sprite = id.Sprite[magic.activeSpell.icon]
    else
        activeSpellSprite:SetSize(0, 0)
    end

    updateMagicUpkeepIndicator(
        bloodTithe,
        magic.upkeep.blood_tithe,
        id.Sprite["SPELL_ANCIENT_MAGICKS_ICON_EXSANGUINATE"]
    )

    updateMagicUpkeepIndicator(
        inciteFear,
        magic.upkeep.incite_fear,
        id.Sprite["SPELL_ANCIENT_MAGICKS_ICON_INCITE_FEAR"]
    )

    updateMagicUpkeepIndicator(
        essenceCorruption,
        magic.upkeep.essence_corruption,
        id.Sprite["ELIDINIS_BOSS_CORRUPTION"]
    )

    -- Ranged Gauge
    -- Death's Swiftness
    if rangedSettings["show-deaths-swiftness"] then 
        deathsSwiftness.layer.hidden = false
        if ranged.deathsSwiftness.active == 1
            then 
                if ultimates.greaterDeathsSwiftnessUnlocked == 1 then
                    setAbilityIndicatorSprite(
                        deathsSwiftness,
                        overlaySprites.ranged.deaths_swiftness.greater_active,
                        overlaySprites.utility.shadow
                    )
                else
                    setAbilityIndicatorSprite(
                        deathsSwiftness,
                        overlaySprites.ranged.deaths_swiftness.active,
                        overlaySprites.utility.shadow
                    )
                end
                if ticksToSeconds(ranged.deathsSwiftness.remainingDuration) == 0.0 then
                    ranged.deathsSwiftness.active = 0
                end
                deathsSwiftness.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                deathsSwiftness.text.content = tostring(ticksToSeconds(ranged.deathsSwiftness.remainingDuration))
            elseif ranged.deathsSwiftness.cooldown >= 1 then 
                if ultimates.greaterDeathsSwiftnessUnlocked == 1 then
                    setAbilityIndicatorSprite(
                        deathsSwiftness,
                        overlaySprites.ranged.deaths_swiftness.greater_inactive,
                        overlaySprites.utility.shadow
                    )
                else
                    setAbilityIndicatorSprite(
                        deathsSwiftness,
                        overlaySprites.ranged.deaths_swiftness.inactive,
                        overlaySprites.utility.shadow
                    )
                end
                deathsSwiftness.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                deathsSwiftness.text.content = tostring(ticksToSeconds(ranged.deathsSwiftness.cooldown))
            else
                if ultimates.greaterDeathsSwiftnessUnlocked == 1 then
                    setAbilityIndicatorSprite(
                        deathsSwiftness,
                        overlaySprites.ranged.deaths_swiftness.greater_active,
                        overlaySprites.utility.shadow
                    )
                else
                    setAbilityIndicatorSprite(
                        deathsSwiftness,
                        overlaySprites.ranged.deaths_swiftness.active,
                        overlaySprites.utility.shadow
                    )
                end
                deathsSwiftness.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                deathsSwiftness.text.content = "Ready"
        end
    else 
        deathsSwiftness.layer.hidden = true
    end

    -- Searing Winds
    if rangedSettings["show-searing-winds"] then 
        searingWinds.layer.hidden = false
        if ranged.searingWinds.active == 1
            then 
                setAbilityIndicatorSprite(
                    searingWinds,
                    overlaySprites.ranged.searing_winds.active,
                    overlaySprites.utility.shadow
                )
                if ticksToSeconds(ranged.searingWinds.remainingDuration) == 0.0 then
                    ranged.searingWinds.active = 0
                end
                searingWinds.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                searingWinds.text.content = tostring(ticksToSeconds(ranged.searingWinds.remainingDuration))
            elseif ranged.searingWinds.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    searingWinds,
                    overlaySprites.ranged.searing_winds.inactive,
                    overlaySprites.utility.shadow
                )
                searingWinds.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                searingWinds.text.content = tostring(ticksToSeconds(ranged.searingWinds.cooldown))
            else
                setAbilityIndicatorSprite(
                    searingWinds,
                    overlaySprites.ranged.searing_winds.active,
                    overlaySprites.utility.shadow
                )
                searingWinds.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                searingWinds.text.content = "Ready"
        end
    else 
        searingWinds.layer.hidden = true
    end

    -- Shadow Imbued
    if rangedSettings["show-shadow-imbued"] then 
        shadowImbued.layer.hidden = false
        if ranged.shadowImbued.active == 1
            then 
                setAbilityIndicatorSprite(
                    shadowImbued,
                    overlaySprites.ranged.shadow_imbued.active,
                    overlaySprites.utility.shadow
                )
                if ticksToSeconds(ranged.shadowImbued.remainingDuration) == 0.0 then
                    ranged.shadowImbued.active = 0
                end
                shadowImbued.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                shadowImbued.text.content = tostring(ticksToSeconds(ranged.shadowImbued.remainingDuration))
            elseif ranged.shadowImbued.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    shadowImbued,
                    overlaySprites.ranged.shadow_imbued.inactive,
                    overlaySprites.utility.shadow
                )
                shadowImbued.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                shadowImbued.text.content = tostring(ticksToSeconds(ranged.shadowImbued.cooldown))
            else
                setAbilityIndicatorSprite(
                    shadowImbued,
                    overlaySprites.ranged.shadow_imbued.active,
                    overlaySprites.utility.shadow
                )
                shadowImbued.text.font = id.Font.MUSEO_SANS_11PT_REGULAR
                shadowImbued.text.content = "Ready"
        end
    else 
        shadowImbued.layer.hidden = true
    end

    -- Perfect Equilibrium
    if rangedSettings["show-perfect-equilibrium"] then 
        perfectEquilibrium.layer.hidden = false
        updateBOLGLetters(
            ranged.perfectEquilibrium.stacks,
            ranged.perfectEquilibrium.active == 1
        )
        if ranged.perfectEquilibrium.active == 1
            then 
                setAbilityIndicatorSprite(
                    perfectEquilibrium,
                    overlaySprites.ranged.perfect_equilibrium.active,
                    overlaySprites.utility.shadow
                )

                if ticksToSeconds(ranged.perfectEquilibrium.remainingDuration) == 0.0 then
                    ranged.perfectEquilibrium.active = 0
                end

                perfectEquilibrium.text.font = id.Font.MUSEO_SANS_13PT_BOLD
                perfectEquilibrium.text.content =
                    tostring(ticksToSeconds(ranged.perfectEquilibrium.remainingDuration))
            else
                setAbilityIndicatorSprite(
                    perfectEquilibrium,
                    overlaySprites.ranged.perfect_equilibrium.inactive,
                    overlaySprites.utility.shadow
                )
                perfectEquilibrium.text.content = ""
        end

        perfectEquilibriumStacksText.content =
            tostring(ranged.perfectEquilibrium.stacks)
    else 
        perfectEquilibrium.layer.hidden = true
    end

    local perfectEquilibriumActive = ranged.perfectEquilibrium.active == 1
    local layout = getRuneLayout(perfectEquilibriumActive)

    perfectEquilibriumStacksText:SetPos(
        math.floor(layout.stacksText.x + OFFSET_POSITION_X),
        math.floor(layout.stacksText.y + OFFSET_POSITION_Y)
    )

    if Mouse.IsAvailable() and Keyboard.IsAvailable() then
        local shiftDown = Keyboard.IsShiftDown()
        local altDown = Keyboard.IsAltDown()
        
        if shiftDown and altDown then
            isDraggingOverlay = true
            
            local mousePositionXY = Mouse.GetPosition()
            OFFSET_POSITION_X = mousePositionXY.x
            OFFSET_POSITION_Y = mousePositionXY.y
            updateOverlayPositions()
        else
            if isDraggingOverlay then
                isDraggingOverlay = false
                
                settings.Set("gaugeOffsetX", OFFSET_POSITION_X)
                settings.Set("gaugeOffsetY", OFFSET_POSITION_Y)
            end
        end
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
