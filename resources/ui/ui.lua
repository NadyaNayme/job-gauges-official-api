local settings = require("resources/database/settings")
local events = require("resources/events/events")
local sprites = require("resources/ui/sprites")
local guthixian = require("resources/data/guthixian_runes")

local generalSettings = require("resources/ui/settings/general")
local necromancySettings = require("resources/ui/settings/necromancy")
local magicSettings = require("resources/ui/settings/magic")
local meleeSettings = require("resources/ui/settings/melee")
local rangedSettings = require("resources/ui/settings/ranged")

local M = {}

local function colourToVector4(colour)
    local colour = tonumber(colour)
    local r = math.floor(colour / 0x1000000) % 0x100
    local g = math.floor(colour / 0x10000) % 0x100
    local b = math.floor(colour / 0x100) % 0x100
    local a = colour % 0x100

    return Vector4.new(
        r / 255,
        g / 255,
        b / 255,
        a / 255
    )
end

-- ============================================================ You excited for school tomorrow school today, I mean school today what's a little coffeein this friend fashion before being cheap and funny. This is one of those popular places to cruise them. She's on this space. I shall she goes proved and what would you do anything and make you feel like my bus on your sideshifts at all and I'm sure you feel that way I'm feeling from workers free legs are in I appreciate and I've took a lot here to say that now I think what's in right now for minutes to couple don't forget to meet pressure so you can keep it still a very small life and I was to choose one and vice versa I would probably do for funding prize is machines like subrays to get money to kill it before you go to that thought the works that we had was when the air conditioning went out that was by far like the one worst night we had than last year
-- Constants / Configuration
-- ============================================================

-- Globals
local OFFSET_POSITION_X = settings.Get("generalSettings.offsetPosition.x")
local OFFSET_POSITION_Y = settings.Get("generalSettings.offsetPosition.y")
local isDraggingOverlay = false

local ACTIVE_COMBAT_STYLE = settings.Get('playerState.combatStyle')
local HIDE_OUT_OF_COMBAT = settings.Get('generalSettings.hideOutOfCombat')

local GAUGE_COMPONENT_POSITIONS = {
    necromancy = settings.Get("necromancySettings.componentPositions"),
    magic = settings.Get("magicSettings.componentPositions"),
    ranged = settings.Get("rangedSettings.componentPositions"),
    melee = settings.Get("meleeSettings.componentPositions"),
}

local RUNE_LAYOUT = settings.Get("rangedSettings.componentPositions.RUNE_LAYOUT")

local READY_TEXT = settings.Get("generalSettings.readyText")
local DISPLAY_TIME_AS = settings.Get("generalSettings.displayTimeAs")
local UI_SCALE = settings.Get("generalSettings.scale")

local LARGE_FONT = id.Font.NOTO_SANS_13PT_BOLD_OUTLINE
local MEDIUM_FONT = id.Font.NOTO_SANS_11PT_BOLD_OUTLINE
local SMALL_FONT = id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE

local FONT_COLOUR = colourToVector4(settings.Get("fontColours.durationText"))
local COOLDOWN_COLOUR = colourToVector4(settings.Get("fontColours.cooldownText"))
local EXPIRING_COLOUR = colourToVector4(settings.Get("fontColours.expiringText"))
local READY_COLOUR = colourToVector4(settings.Get("fontColours.readyText"))

local SELECTED_GUTHIXIAN_RUNE = settings.Get("rangedSettings.selectedGuthixianRune")

local ACTIVE_RUNE_COLOUR = colourToVector4(settings.Get("uiColours.runeColours.active"))
local ACTIVE_RUNE_SHADOW_COLOUR = colourToVector4(settings.Get("uiColours.runeColours.activeShadow"))
local INACTIVE_RUNE_COLOUR = colourToVector4(settings.Get("uiColours.runeColours.inactive"))
local INACTIVE_RUNE_SHADOW_COLOUR = colourToVector4(settings.Get("uiColours.runeColours.inactiveShadow"))

local RUNE_SHADOW_OFFSET = 1

local BLOOD_TITHE_COLOUR = colourToVector4(settings.Get("uiColours.barColours.bloodTitheBar"))
local INCITE_FEAR_COLOUR = colourToVector4(settings.Get("uiColours.barColours.inciteFearBar"))
local ESSENCE_CORRUPTION_COLOUR = colourToVector4(settings.Get("uiColours.barColours.essenceCorruptionBar"))

local function getRuneLayout(perfectEquilibriumActive)
    local selectedGuthixianRune = SELECTED_GUTHIXIAN_RUNE

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

    local gameArea = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__GAME_AREA)
    if not gameArea then
    log("Can't find game area")
    return
    end

    local guthixian_runes
    guthixian_runes = guthixian.CreateSprites(gameArea)

    local word

    if SELECTED_GUTHIXIAN_RUNE == "lore" then
        if perfectEquilibriumActive then
            word = "NYU"
        else
            word = "BALANCE"
        end
    else
        if perfectEquilibriumActive then
            word = SELECTED_GUTHIXIAN_RUNE:rep(3)
        else
            word = SELECTED_GUTHIXIAN_RUNE:rep(7)
        end
    end

    local layout

    if SELECTED_GUTHIXIAN_RUNE == "lore" then
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

            if SELECTED_GUTHIXIAN_RUNE == "lore" then
                letter = word:sub(i, i)
            else
                letter = SELECTED_GUTHIXIAN_RUNE
            end

            local runeSprite = guthixian_runes[letter]

            shadow.sprite = runeSprite
            sprite.sprite = runeSprite

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


local ABILITY_SHADOW_COLOUR = colourToVector4(settings.Get("uiColours.shadowColour"))
local ABILITY_SHADOW_SIZE = 42
local ABILITY_SHADOW_OFFSET = -1
local abilityShadows = {}

local fontTexts = {}

local function ticksToSeconds(ticks)
    if DISPLAY_TIME_AS == "precise-ticks" then 
        return ticks * 0.6
    else 
        return math.ceil(ticks * 0.6)
    end
end

local function scaleToFactor(number)
    return math.floor(number * UI_SCALE )
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
    text.font = LARGE_FONT
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

local function createAbilitySpriteIndicator(parent, position)
    local layer = ui.Layer.new(parent)
    layer:SetSize(20, 20, 1.0, 1.0)

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
    sprite:SetSize(scaleToFactor(20), scaleToFactor(20))
    sprite:MoveToFront()

    local text = ui.Text.new(layer)
    text:SetPos(
        math.floor(position.x + 16 + OFFSET_POSITION_X),
        math.floor(position.y + 4 + OFFSET_POSITION_Y)
    )
    text:SetSize(22, 15)
    text:MoveToFront()
    text.content = ""
    text.font = MEDIUM_FONT
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

local magicUpkeepBars = {}
local function createMagicUpkeepIndicator(parent, position, name)
    local layer = ui.Layer.new(parent)
    layer:SetSize(90, 24, 1.0, 1.0)

    local text = ui.Text.new(layer)
    text:SetPos(
        math.floor(position.x + 9 + OFFSET_POSITION_X),
        math.floor(position.y - 4 + OFFSET_POSITION_Y)
    )
    text:SetSize(28, 16)
    text.content = ""
    text.font = SMALL_FONT
    text.colour = FONT_COLOUR
    text.isShadowed = true

    local shadow = ui.Sprite.new(layer)
    shadow:SetPos(
        math.floor(position.x + 59 + OFFSET_POSITION_X),
        math.floor(position.y + 3 + OFFSET_POSITION_Y)
    )
    shadow:SetSize(scaleToFactor(0), scaleToFactor(6))

    local sprite = ui.Sprite.new(layer)
    sprite:SetPos(
        math.floor(position.x + 58 + OFFSET_POSITION_X),
        math.floor(position.y + 2 + OFFSET_POSITION_Y)
    )
    sprite:SetSize(scaleToFactor(0), scaleToFactor(6))

    table.insert(fontTexts, text)

    magicUpkeepBars[name] = {
        layer = layer,
        text = text,
        sprite = sprite,
        shadow = shadow,
    }

    return magicUpkeepBars[name]
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

local function setAbilitySpriteIndicatorPosition(indicator, position)
    indicator.shadow:SetPos(
        math.floor(position.x + OFFSET_POSITION_X + ABILITY_SHADOW_OFFSET),
        math.floor(position.y + OFFSET_POSITION_Y + ABILITY_SHADOW_OFFSET)
    )

    indicator.sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.text:SetPos(
        math.floor(position.x + 16 + OFFSET_POSITION_X),
        math.floor(position.y + 4 + OFFSET_POSITION_Y)
    )

end

local function setSpriteIndicatorPosition(indicator, position)
    indicator:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
end

local function setMagicUpkeepIndicatorPosition(indicator, position)
    indicator.text:SetPos(
        math.floor(position.x + 9 + OFFSET_POSITION_X),
        math.floor(position.y - 4 + OFFSET_POSITION_Y)
    )

    indicator.sprite:SetPos(
        math.floor(position.x + 58 + OFFSET_POSITION_X),
        math.floor(position.y + 2 + OFFSET_POSITION_Y)
    )

    indicator.shadow:SetPos(
        math.floor(position.x + 59 + OFFSET_POSITION_X),
        math.floor(position.y + 3 + OFFSET_POSITION_Y)
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

    local deathGrasp = createAbilityIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.deathGrasp
    )

    local deathEssence = createAbilityIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.deathEssence
    )

    local soulCrush = createAbilityIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.soulCrush
    )

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
        GAUGE_COMPONENT_POSITIONS.magic.bloodTithe,
        "bloodTithe"
    )

    local inciteFear = createMagicUpkeepIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.inciteFear,
        "inciteFear"
    )

    local essenceCorruption = createMagicUpkeepIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.essenceCorruption,
        "essenceCorruption"
    )

    -- Ranged Overlay
    local rangedGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local deathsSwiftness = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.deathsSwiftness
    )

    local crystalRain = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.crystalRain
    )

    local splitSoul_ecb = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.splitSoul
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
    perfectEquilibriumStacksText.font = LARGE_FONT
    perfectEquilibriumStacksText.colour = FONT_COLOUR
    perfectEquilibriumStacksText.isShadowed = true
    perfectEquilibriumStacksText.alignHorizontal = ui.AlignMode.CENTRE
    perfectEquilibriumStacksText.alignVertical = ui.AlignMode.CENTRE

    table.insert(fontTexts, perfectEquilibriumStacksText)

    -- Melee Overlay
    local meleeGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local blackhole = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.blackhole
    )

    local igneousShowdown = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.igneousShowdown
    )

    local bloodlust = createAbilitySpriteIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.bloodlust
    )

    local chaosRoar = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.chaosRoar
    )

    local meteorStrike = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.meteorStrike
    )

    local berserk = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.berserk
    )

    local function updateOverlayPositions()
        local positions = GAUGE_COMPONENT_POSITIONS

        setAbilityIndicatorPosition(
            deathGrasp,
            positions.necromancy.deathGrasp
        )

        setAbilityIndicatorPosition(
            deathEssence,
            positions.necromancy.deathEssence
        )

        setAbilityIndicatorPosition(
            soulCrush,
            positions.necromancy.soulCrush
        )

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
            positions.magic.bloodTithe
        )

        setMagicUpkeepIndicatorPosition(
            inciteFear,
            positions.magic.inciteFear
        )

        setMagicUpkeepIndicatorPosition(
            essenceCorruption,
            positions.magic.essenceCorruption
        )

        setAbilityIndicatorPosition(
            crystalRain,
            positions.ranged.crystalRain
        )

        setAbilityIndicatorPosition(
            splitSoul_ecb,
            positions.ranged.splitSoul
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

        setAbilityIndicatorPosition(
            blackhole,
            positions.melee.blackhole
        )

        setAbilityIndicatorPosition(
            igneousShowdown,
            positions.melee.igneousShowdown
        )

        setAbilitySpriteIndicatorPosition(
            bloodlust,
            positions.melee.bloodlust
        )

        setAbilityIndicatorPosition(
            chaosRoar,
            positions.melee.chaosRoar
        )

        setAbilityIndicatorPosition(
            meteorStrike,
            positions.melee.meteorStrike
        )

        setAbilityIndicatorPosition(
            berserk,
            positions.melee.berserk
        )

        local perfectEquilibriumActive = events.playerData.ranged.perfectEquilibrium.active == 1
        local layout = getRuneLayout(perfectEquilibriumActive)

        perfectEquilibriumStacksText:SetPos(
            math.floor(layout.stacksText.x + OFFSET_POSITION_X),
            math.floor(layout.stacksText.y + OFFSET_POSITION_Y)
        )

    end

  local settingsBox = prettyui.Window.new(gameArea, {
    title = "Job Gauges by Nyu",
    x = 50,
    y = 250,
    width = 600,
    height = 835,
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
    meleeSettings.Create(meleePage)
    rangedSettings.Create(rangedPage, {
        setActiveRuneColour = function(colour)
            updateBOLGLetters(
                events.playerData.ranged.perfectEquilibrium.stacks,
                events.playerData.ranged.perfectEquilibrium.active == 1
            )
        end,
    })

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

local function updateMagicUpkeepIndicator(indicator, upkeep)
    indicator.shadow.sprite = overlaySprites.utility.bar
    indicator.sprite.sprite = overlaySprites.utility.bar
    indicator.sprite:SetSize(upkeep.remainingDuration * 2.25, 3)
    indicator.shadow:SetSize(upkeep.remainingDuration * 2.25, 3)
    indicator.shadow.colour = ABILITY_SHADOW_COLOUR
    if upkeep.name == "Blood Tithe" then
        indicator.sprite.colour = BLOOD_TITHE_COLOUR
    end
    if upkeep.name == "Incite Fear" then
        indicator.sprite.colour = INCITE_FEAR_COLOUR
    end
    if upkeep.name == "Essence Corruption" then
        indicator.sprite.colour = ESSENCE_CORRUPTION_COLOUR
    end
    indicator.text.content = tostring(ticksToSeconds(upkeep.remainingDuration) .. " (" .. tostring(upkeep.stacks) .. ")")
    indicator.text.colour = FONT_COLOUR
    if upkeep.remainingDuration <= 16 and math.floor(upkeep.remainingDuration) % 2 == 0 then
        indicator.text.colour = EXPIRING_COLOUR
    else 
        indicator.text.colour = FONT_COLOUR
    end

    if ticksToSeconds(upkeep.remainingDuration) == 0.0 and upkeep.stacks == 0 then
        indicator.text.content = ""
        indicator.sprite.hidden = true
        indicator.shadow.hidden = true
    else 
        indicator.sprite.hidden = false
        indicator.shadow.hidden = false
    end
end

local function updateOverlays()

    if overlaySprites == nil then return end

    local necromancySettings = settings.Get("necromancySettings")
    local magicSettings = settings.Get("magicSettings")
    local rangedSettings = settings.Get("rangedSettings")
    local meleeSettings = settings.Get("meleeSettings")

    local playerData = events.playerData
    local necromancy = playerData.necromancy
    local magic = playerData.magic
    local ranged = playerData.ranged
    local melee = playerData.melee
    local ultimates = playerData.ultimates

    if playerData.combatStyle == nil then
        playerData.combatStyle = ACTIVE_COMBAT_STYLE
    end

    updateGaugeVisibility()
    
    if playerData.inCombat ~= true and HIDE_OUT_OF_COMBAT == "combat-visible" then
        necromancyGaugeLayer.hidden = true
        magicGaugeLayer.hidden = true
        rangedGaugeLayer.hidden = true
        meleeGaugeLayer.hidden = true
     end

    if necromancySettings.componentVisibility["show-death-grasp"] then 
        deathGrasp.layer.hidden = false
        if necromancy.deathGrasp.active == 1
            then 
                deathGrasp.sprite.sprite = overlaySprites.necromancy.death_grasp.active
                if ticksToSeconds(necromancy.deathGrasp.remainingDuration) == 0.0 then
                    necromancy.deathGrasp.active = 0
                end
                deathGrasp.text.font = LARGE_FONT
                deathGrasp.text.content = tostring(ticksToSeconds(necromancy.deathGrasp.remainingDuration))
                deathGrasp.text.colour = FONT_COLOUR
            elseif necromancy.deathGrasp.cooldown >= 1 then 
                deathGrasp.sprite.sprite = overlaySprites.necromancy.death_grasp.inactive
                deathGrasp.text.font = LARGE_FONT
                deathGrasp.text.content = tostring(ticksToSeconds(necromancy.deathGrasp.cooldown))
                deathGrasp.text.colour = COOLDOWN_COLOUR
            else
                deathGrasp.sprite.sprite = overlaySprites.necromancy.death_grasp.active
                deathGrasp.text.font = SMALL_FONT
                deathGrasp.text.content = READY_TEXT
                deathGrasp.text.colour = READY_COLOUR
        end
    else 
        deathGrasp.layer.hidden = true
    end

    if necromancySettings.componentVisibility["show-death-essence"] then 
        deathEssence.layer.hidden = false
        if necromancy.deathEssence.active == 1
            then 
                deathEssence.sprite.sprite = overlaySprites.necromancy.death_essence.active
                if ticksToSeconds(necromancy.deathEssence.remainingDuration) == 0.0 then
                    necromancy.deathEssence.active = 0
                end
                deathEssence.text.font = LARGE_FONT
                deathEssence.text.content = tostring(ticksToSeconds(necromancy.deathEssence.remainingDuration))
                deathEssence.text.colour = FONT_COLOUR
            elseif necromancy.deathEssence.cooldown >= 1 then 
                deathEssence.sprite.sprite = overlaySprites.necromancy.death_essence.inactive
                deathEssence.text.font = LARGE_FONT
                deathEssence.text.content = tostring(ticksToSeconds(necromancy.deathEssence.cooldown))
                deathEssence.text.colour = COOLDOWN_COLOUR
            else
                deathEssence.sprite.sprite = overlaySprites.necromancy.death_essence.active
                deathEssence.text.font = SMALL_FONT
                deathEssence.text.content = READY_TEXT
                deathEssence.text.colour = READY_COLOUR
        end
    else 
        deathEssence.layer.hidden = true
    end

    if necromancySettings.componentVisibility["show-soul-crush"] then 
        soulCrush.layer.hidden = false
        if necromancy.soulCrush.active == 1
            then 
                soulCrush.sprite.sprite = overlaySprites.necromancy.soul_crush.active
                if ticksToSeconds(necromancy.soulCrush.remainingDuration) == 0.0 then
                    necromancy.soulCrush.active = 0
                end
                soulCrush.text.font = LARGE_FONT
                soulCrush.text.content = tostring(ticksToSeconds(necromancy.soulCrush.remainingDuration))
                soulCrush.text.colour = FONT_COLOUR
            elseif necromancy.soulCrush.cooldown >= 1 then 
                soulCrush.sprite.sprite = overlaySprites.necromancy.soul_crush.inactive
                soulCrush.text.font = LARGE_FONT
                soulCrush.text.content = tostring(ticksToSeconds(necromancy.soulCrush.cooldown))
                soulCrush.text.colour = COOLDOWN_COLOUR
            else
                soulCrush.sprite.sprite = overlaySprites.necromancy.soul_crush.active
                soulCrush.text.font = SMALL_FONT
                soulCrush.text.content = READY_TEXT
                soulCrush.text.colour = READY_COLOUR
        end
    else 
        soulCrush.layer.hidden = true
    end

    -- Conjure Undead Army
    if necromancySettings.componentVisibility["show-conjures"] then 
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
                conjureUndeadArmy.text.font = LARGE_FONT
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

    if necromancySettings.componentVisibility["show-living-death"] then 
        livingDeath.layer.hidden = false
        if necromancy.livingDeath.active == 1
            then 
                setAbilityIndicatorSprite(
                    livingDeath,
                    overlaySprites.necromancy.living_death.active,
                    overlaySprites.utility.shadow
                )
                livingDeath.text.font = LARGE_FONT
                livingDeath.text.content = tostring(ticksToSeconds(necromancy.livingDeath.remainingDuration))
                livingDeath.text.colour = FONT_COLOUR
            elseif necromancy.livingDeath.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    livingDeath,
                    overlaySprites.necromancy.living_death.inactive,
                    overlaySprites.utility.shadow
                )
                livingDeath.text.font = LARGE_FONT
                livingDeath.text.content = tostring(ticksToSeconds(necromancy.livingDeath.cooldown))
                livingDeath.text.colour = COOLDOWN_COLOUR
            else
                setAbilityIndicatorSprite(
                    livingDeath,
                    overlaySprites.necromancy.living_death.active,
                    overlaySprites.utility.shadow
                )
                livingDeath.text.font = SMALL_FONT
                livingDeath.text.content = READY_TEXT
                livingDeath.text.colour = READY_COLOUR
        end
    else 
        livingDeath.layer.hidden = true
    end
    
    -- Residual Soul Stacks
    if necromancySettings.componentVisibility["show-residual-souls"] then 
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
    if necromancySettings.componentVisibility["show-necrosis-stacks"] then 
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

    if necromancySettings.componentVisibility["show-bloat"] then
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
    if necromancySettings.componentVisibility["show-threads-of-fate"] then 
        threadsOfFate:SetSize(scaleToFactor(24), scaleToFactor(21))
    if necromancy.incantations.threadsOfFate.active == 1 then
        threadsOfFate.sprite = overlaySprites.necromancy.incantations.threadsOfFate.active
        else threadsOfFate.sprite = overlaySprites.necromancy.incantations.threadsOfFate.inactive
        end
    else
        threadsOfFate:SetSize(0, 0)
    end
    if necromancySettings.componentVisibility["show-split-soul"] then 
        splitSoul:SetSize(scaleToFactor(24), scaleToFactor(21))
    if necromancy.incantations.splitSoul.active == 1 then
        splitSoul.sprite = overlaySprites.necromancy.incantations.splitSoul.active
        else splitSoul.sprite = overlaySprites.necromancy.incantations.splitSoul.inactive
        end
    else
        splitSoul:SetSize(0, 0)
    end
    if necromancySettings.componentVisibility["show-invoke-death"] then 
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
    if magicSettings.componentVisibility["show-sunshine"] then 
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
                sunshine.text.font = LARGE_FONT
                sunshine.text.content = tostring(ticksToSeconds(magic.sunshine.remainingDuration))
                sunshine.text.colour = FONT_COLOUR
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
                sunshine.text.font = LARGE_FONT
                sunshine.text.content = tostring(ticksToSeconds(magic.sunshine.cooldown))
                sunshine.text.colour = COOLDOWN_COLOUR
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
                sunshine.text.font = SMALL_FONT
                sunshine.text.content = READY_TEXT
                sunshine.text.colour = READY_COLOUR
        end
    else 
        sunshine.layer.hidden = true
    end

    -- Tsunami
    if magicSettings.componentVisibility["show-tsunami"] then 
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
                tsunami.text.font = LARGE_FONT
                tsunami.text.content = tostring(ticksToSeconds(magic.tsunami.remainingDuration))
                tsunami.text.colour = FONT_COLOUR
            elseif magic.tsunami.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    tsunami,
                    overlaySprites.magic.tsunami.inactive,
                    overlaySprites.utility.shadow
                )
                tsunami.text.font = LARGE_FONT
                tsunami.text.content = tostring(ticksToSeconds(magic.tsunami.cooldown))
                tsunami.text.colour = COOLDOWN_COLOUR
            else
                setAbilityIndicatorSprite(
                    tsunami,
                    overlaySprites.magic.tsunami.active,
                    overlaySprites.utility.shadow
                )
                tsunami.text.font = SMALL_FONT
                tsunami.text.content = READY_TEXT
                tsunami.text.colour = READY_COLOUR
        end
    else 
        tsunami.layer.hidden = true
    end

    -- Runic Charge
    if magicSettings.componentVisibility["show-runic-charge"] then 
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
                runicCharge.text.font = LARGE_FONT
                runicCharge.text.content = tostring(ticksToSeconds(magic.runicCharge.remainingDuration))
                runicCharge.text.colour = FONT_COLOUR
            elseif magic.runicCharge.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    runicCharge,
                    overlaySprites.magic.runicCharge.inactive,
                    overlaySprites.utility.shadow
                )
                runicCharge.text.font = LARGE_FONT
                runicCharge.text.content = tostring(ticksToSeconds(magic.runicCharge.cooldown))
                runicCharge.text.colour = COOLDOWN_COLOUR
            else
                setAbilityIndicatorSprite(
                    runicCharge,
                    overlaySprites.magic.runicCharge.active,
                    overlaySprites.utility.shadow
                )
                runicCharge.text.font = SMALL_FONT
                runicCharge.text.content = READY_TEXT
                runicCharge.text.colour = READY_COLOUR
        end
    else 
        runicCharge.layer.hidden = true
    end

    if magicSettings.componentVisibility["show-soulfire"] then 
        soulfire.layer.hidden = false
        if magic.soulfire.active == 1
            then 
                soulfire.sprite.sprite = overlaySprites.magic.soulfire.active
                if ticksToSeconds(magic.soulfire.remainingDuration) == 0.0 then
                    magic.soulfire.active = 0
                end
                soulfire.text.font = LARGE_FONT
                soulfire.text.content = tostring(ticksToSeconds(magic.soulfire.remainingDuration))
                soulfire.text.colour = FONT_COLOUR
            elseif magic.soulfire.cooldown >= 1 then 
                soulfire.sprite.sprite = overlaySprites.magic.soulfire.inactive
                soulfire.text.font = LARGE_FONT
                soulfire.text.content = tostring(ticksToSeconds(magic.soulfire.cooldown))
                soulfire.text.colour = COOLDOWN_COLOUR
            else
                soulfire.sprite.sprite = overlaySprites.magic.soulfire.active
                soulfire.text.font = SMALL_FONT
                soulfire.text.content = READY_TEXT
                soulfire.text.colour = READY_COLOUR
        end
    else 
        soulfire.layer.hidden = true
    end

    if magicSettings.componentVisibility["show-instability"] then 
        instability.layer.hidden = false
        if magic.instability.active == 1
            then 
                instability.sprite.sprite = overlaySprites.magic.instability.active
                if ticksToSeconds(magic.instability.remainingDuration) == 0.0 then
                    magic.instability.active = 0
                end
                instability.text.font = LARGE_FONT
                instability.text.content = tostring(ticksToSeconds(magic.instability.remainingDuration))
                instability.text.colour = FONT_COLOUR
            elseif magic.instability.cooldown >= 1 then 
                instability.sprite.sprite = overlaySprites.magic.instability.inactive
                instability.text.font = LARGE_FONT
                instability.text.content = tostring(ticksToSeconds(magic.instability.cooldown))
                instability.text.colour = COOLDOWN_COLOUR
            else
                instability.sprite.sprite = overlaySprites.magic.instability.active
                instability.text.font = SMALL_FONT
                instability.text.content = READY_TEXT
                instability.text.colour = READY_COLOUR
        end
    else 
        instability.layer.hidden = true
    end

    if magicSettings.componentVisibility["show-active-spell"] and magic.activeSpell and magic.activeSpell.icon then
        activeSpellSprite:SetSize(scaleToFactor(24), scaleToFactor(21))
        activeSpellSprite.sprite = id.Sprite[magic.activeSpell.icon]
    else
        activeSpellSprite:SetSize(0, 0)
    end

    if magicSettings.componentVisibility["show-blood-tithe"] then
        updateMagicUpkeepIndicator(
            bloodTithe,
            magic.upkeep.blood_tithe
        )
    end

    if magicSettings.componentVisibility["show-incite-fear"] then
        updateMagicUpkeepIndicator(
            inciteFear,
            magic.upkeep.incite_fear
        )
    end

    if magicSettings.componentVisibility["show-essence-corruption"] then
        updateMagicUpkeepIndicator(
            essenceCorruption,
            magic.upkeep.essence_corruption
        )
    end

    -- Ranged Gauge

    if rangedSettings.componentVisibility["show-crystal-rain"] then 
        crystalRain.layer.hidden = false
        if ranged.crystalRain.active == 1
            then 
                crystalRain.sprite.sprite = overlaySprites.ranged.crystal_rain.active
                if ticksToSeconds(ranged.crystalRain.remainingDuration) == 0.0 then
                    ranged.crystalRain.active = 0
                end
                crystalRain.text.font = LARGE_FONT
                crystalRain.text.content = tostring(ticksToSeconds(ranged.crystalRain.remainingDuration))
                crystalRain.text.colour = FONT_COLOUR
            elseif ranged.crystalRain.cooldown >= 1 then 
                crystalRain.sprite.sprite = overlaySprites.ranged.crystal_rain.inactive
                crystalRain.text.font = LARGE_FONT
                crystalRain.text.content = tostring(ticksToSeconds(ranged.crystalRain.cooldown))
                crystalRain.text.colour = COOLDOWN_COLOUR
            else
                crystalRain.sprite.sprite = overlaySprites.ranged.crystal_rain.active
                crystalRain.text.font = SMALL_FONT
                crystalRain.text.content = READY_TEXT
                crystalRain.text.colour = READY_COLOUR
        end
    else 
        crystalRain.layer.hidden = true
    end

    if rangedSettings.componentVisibility["show-split-soul"] then 
        splitSoul_ecb.layer.hidden = false
        if ranged.splitSoul.active == 1
            then 
                splitSoul_ecb.sprite.sprite = overlaySprites.ranged.split_soul.splitsoul
                if ticksToSeconds(ranged.splitSoul.remainingDuration) == 0.0 then
                    ranged.splitSoul.active = 0
                end
                splitSoul_ecb.text.font = LARGE_FONT
                splitSoul_ecb.text.content = tostring(ticksToSeconds(ranged.splitSoul.remainingDuration))
                splitSoul_ecb.text.colour = FONT_COLOUR
            elseif ranged.splitSoul.cooldown >= 1 then 
                splitSoul_ecb.sprite.sprite = overlaySprites.ranged.split_soul.inactive
                splitSoul_ecb.text.font = LARGE_FONT
                splitSoul_ecb.text.content = tostring(ticksToSeconds(ranged.splitSoul.cooldown))
                splitSoul_ecb.text.colour = COOLDOWN_COLOUR
            else
                splitSoul_ecb.sprite.sprite = overlaySprites.ranged.split_soul.active
                splitSoul_ecb.text.font = SMALL_FONT
                splitSoul_ecb.text.content = READY_TEXT
                splitSoul_ecb.text.colour = READY_COLOUR
        end
    else 
        splitSoul_ecb.layer.hidden = true
    end

    -- Death's Swiftness
    if rangedSettings.componentVisibility["show-deaths-swiftness"] then 
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
                deathsSwiftness.text.font = LARGE_FONT
                deathsSwiftness.text.content = tostring(ticksToSeconds(ranged.deathsSwiftness.remainingDuration))
                deathsSwiftness.text.colour = FONT_COLOUR
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
                deathsSwiftness.text.font = LARGE_FONT
                deathsSwiftness.text.content = tostring(ticksToSeconds(ranged.deathsSwiftness.cooldown))
                deathsSwiftness.text.colour = COOLDOWN_COLOUR
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
                deathsSwiftness.text.font = SMALL_FONT
                deathsSwiftness.text.content = READY_TEXT
                deathsSwiftness.text.colour = READY_COLOUR
        end
    else 
        deathsSwiftness.layer.hidden = true
    end

    -- Searing Winds
    if rangedSettings.componentVisibility["show-searing-winds"] then 
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
                searingWinds.text.font = LARGE_FONT
                searingWinds.text.content = tostring(ticksToSeconds(ranged.searingWinds.remainingDuration))
                searingWinds.text.colour = FONT_COLOUR
            elseif ranged.searingWinds.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    searingWinds,
                    overlaySprites.ranged.searing_winds.inactive,
                    overlaySprites.utility.shadow
                )
                searingWinds.text.font = LARGE_FONT
                searingWinds.text.content = tostring(ticksToSeconds(ranged.searingWinds.cooldown))
                searingWinds.text.colour = COOLDOWN_COLOUR
            else
                setAbilityIndicatorSprite(
                    searingWinds,
                    overlaySprites.ranged.searing_winds.active,
                    overlaySprites.utility.shadow
                )
                searingWinds.text.font = SMALL_FONT
                searingWinds.text.content = READY_TEXT
                searingWinds.text.colour = READY_COLOUR
        end
    else 
        searingWinds.layer.hidden = true
    end

    -- Shadow Imbued
    if rangedSettings.componentVisibility["show-shadow-imbued"] then 
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
                shadowImbued.text.font = LARGE_FONT
                shadowImbued.text.content = tostring(ticksToSeconds(ranged.shadowImbued.remainingDuration))
                shadowImbued.text.colour = FONT_COLOUR
            elseif ranged.shadowImbued.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    shadowImbued,
                    overlaySprites.ranged.shadow_imbued.inactive,
                    overlaySprites.utility.shadow
                )
                shadowImbued.text.font = LARGE_FONT
                shadowImbued.text.content = tostring(ticksToSeconds(ranged.shadowImbued.cooldown))
                shadowImbued.text.colour = COOLDOWN_COLOUR
            else
                setAbilityIndicatorSprite(
                    shadowImbued,
                    overlaySprites.ranged.shadow_imbued.active,
                    overlaySprites.utility.shadow
                )
                shadowImbued.text.font = SMALL_FONT
                shadowImbued.text.content = READY_TEXT
                shadowImbued.text.colour = READY_COLOUR
        end
    else 
        shadowImbued.layer.hidden = true
    end

    -- Perfect Equilibrium
    if rangedSettings.componentVisibility["show-perfect-equilibrium"] then 
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

                perfectEquilibrium.text.font = LARGE_FONT
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


    -- MELEE COMPONENTS
    if meleeSettings.componentVisibility["show-blackhole"] then 
        blackhole.layer.hidden = false
        if melee.blackhole.active == 1
            then 
                blackhole.sprite.sprite = overlaySprites.melee.blackhole.active
                if ticksToSeconds(melee.blackhole.remainingDuration) == 0.0 then
                    melee.blackhole.active = 0
                end
                blackhole.text.font = LARGE_FONT
                blackhole.text.content = tostring(ticksToSeconds(melee.blackhole.remainingDuration))
                blackhole.text.colour = FONT_COLOUR
            elseif melee.blackhole.cooldown >= 1 then 
                blackhole.sprite.sprite = overlaySprites.melee.blackhole.inactive
                blackhole.text.font = LARGE_FONT
                blackhole.text.content = tostring(ticksToSeconds(melee.blackhole.cooldown))
                blackhole.text.colour = COOLDOWN_COLOUR
            else
                blackhole.sprite.sprite = overlaySprites.melee.blackhole.active
                blackhole.text.font = SMALL_FONT
                blackhole.text.content = READY_TEXT
                blackhole.text.colour = READY_COLOUR
        end
    else 
        blackhole.layer.hidden = true
    end

    if meleeSettings.componentVisibility["show-igneous-showdown"] then 
        igneousShowdown.layer.hidden = false
        if melee.igneousShowdown.active == 1
            then 
                igneousShowdown.sprite.sprite = overlaySprites.melee.igneous_showdown.active
                if ticksToSeconds(melee.igneousShowdown.remainingDuration) == 0.0 then
                    melee.igneousShowdown.active = 0
                end
                igneousShowdown.text.font = LARGE_FONT
                igneousShowdown.text.content = tostring(ticksToSeconds(melee.igneousShowdown.remainingDuration))
                igneousShowdown.text.colour = FONT_COLOUR
            elseif melee.igneousShowdown.cooldown >= 1 then 
                igneousShowdown.sprite.sprite = overlaySprites.melee.igneous_showdown.inactive
                igneousShowdown.text.font = LARGE_FONT
                igneousShowdown.text.content = tostring(ticksToSeconds(melee.igneousShowdown.cooldown))
                igneousShowdown.text.colour = COOLDOWN_COLOUR
            else
                igneousShowdown.sprite.sprite = overlaySprites.melee.igneous_showdown.active
                igneousShowdown.text.font = SMALL_FONT
                igneousShowdown.text.content = READY_TEXT
                igneousShowdown.text.colour = READY_COLOUR
        end
    else 
        igneousShowdown.layer.hidden = true
    end

    if meleeSettings.componentVisibility["show-bloodlust"] then 
        bloodlust.layer.hidden = false
        if melee.bloodlust.stacks > 3
            then 
                bloodlust.sprite.sprite = id.Sprite["BUFF_ICON_MELEE_BLOODLUST"]
                bloodlust.text.content = tostring(melee.bloodlust.stacks)
        elseif melee.bloodlust.stacks > 0
            then
                bloodlust.sprite.sprite = id.Sprite["BUFF_ICON_MELEE_BLOODLUST_INACTIVE"]
                bloodlust.text.content = tostring(melee.bloodlust.stacks)
            else
                bloodlust.sprite.sprite = id.Sprite["BUFF_ICON_MELEE_BLOODLUST_INACTIVE"]
                bloodlust.text.content = "0"
        end
    else 
        bloodlust.layer.hidden = true
    end

    if meleeSettings.componentVisibility["show-chaos-roar"] then 
        chaosRoar.layer.hidden = false
        if melee.chaosRoar.active == 1
            then 
                chaosRoar.sprite.sprite = overlaySprites.melee.chaos_roar.active
                if ticksToSeconds(melee.chaosRoar.remainingDuration) == 0.0 then
                    melee.chaosRoar.active = 0
                end
                chaosRoar.text.font = LARGE_FONT
                chaosRoar.text.content = tostring(ticksToSeconds(melee.chaosRoar.remainingDuration))
                chaosRoar.text.colour = FONT_COLOUR
            elseif melee.chaosRoar.cooldown >= 1 then 
                chaosRoar.sprite.sprite = overlaySprites.melee.chaos_roar.inactive
                chaosRoar.text.font = LARGE_FONT
                chaosRoar.text.content = tostring(ticksToSeconds(melee.chaosRoar.cooldown))
                chaosRoar.text.colour = COOLDOWN_COLOUR
            else
                chaosRoar.sprite.sprite = overlaySprites.melee.chaos_roar.active
                chaosRoar.text.font = SMALL_FONT
                chaosRoar.text.content = READY_TEXT
                chaosRoar.text.colour = READY_COLOUR
        end
    else 
        chaosRoar.layer.hidden = true
    end

    if meleeSettings.componentVisibility["show-meteor-strike"] then 
        meteorStrike.layer.hidden = false
        if melee.meteorStrike.active == 1
            then 
                meteorStrike.sprite.sprite = overlaySprites.melee.meteor_strike.active
                if ticksToSeconds(melee.meteorStrike.remainingDuration) == 0.0 then
                    melee.meteorStrike.active = 0
                end
                meteorStrike.text.font = LARGE_FONT
                meteorStrike.text.content = tostring(ticksToSeconds(melee.meteorStrike.remainingDuration))
                meteorStrike.text.colour = FONT_COLOUR
            elseif melee.meteorStrike.cooldown >= 1 then 
                meteorStrike.sprite.sprite = overlaySprites.melee.meteor_strike.inactive
                meteorStrike.text.font = LARGE_FONT
                meteorStrike.text.content = tostring(ticksToSeconds(melee.meteorStrike.cooldown))
                meteorStrike.text.colour = COOLDOWN_COLOUR
            else
                meteorStrike.sprite.sprite = overlaySprites.melee.meteor_strike.active
                meteorStrike.text.font = SMALL_FONT
                meteorStrike.text.content = READY_TEXT
                meteorStrike.text.colour = READY_COLOUR
        end
    else 
        meteorStrike.layer.hidden = true
    end

    if meleeSettings.componentVisibility["show-berserk"] then 
        berserk.layer.hidden = false
        if melee.berserk.active == 1
            then 
                setAbilityIndicatorSprite(
                    berserk,
                    overlaySprites.melee.berserk.active,
                    overlaySprites.utility.shadow
                )
                if ticksToSeconds(melee.berserk.remainingDuration) == 0.0 then
                    melee.berserk.active = 0
                end
                berserk.text.font = LARGE_FONT
                berserk.text.content = tostring(ticksToSeconds(melee.berserk.remainingDuration))
                berserk.text.colour = FONT_COLOUR
            elseif melee.berserk.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    berserk,
                    overlaySprites.melee.berserk.inactive,
                    overlaySprites.utility.shadow
                )
                berserk.text.font = LARGE_FONT
                berserk.text.content = tostring(ticksToSeconds(melee.berserk.cooldown))
                berserk.text.colour = COOLDOWN_COLOUR
            else
                setAbilityIndicatorSprite(
                    berserk,
                    overlaySprites.melee.berserk.active,
                    overlaySprites.utility.shadow
                )
                berserk.text.font = SMALL_FONT
                berserk.text.content = READY_TEXT
                berserk.text.colour = READY_COLOUR
        end
    else 
        berserk.layer.hidden = true
    end


    if Mouse.IsAvailable() and Keyboard.IsAvailable() then
        local shiftDown = Keyboard.IsShiftDown()
        local ctrlDown = Keyboard.IsControlDown()
        
        if shiftDown and ctrlDown then
            isDraggingOverlay = true
            
            local mousePositionXY = Mouse.GetPosition()
            OFFSET_POSITION_X = mousePositionXY.x
            OFFSET_POSITION_Y = mousePositionXY.y
            updateOverlayPositions()
        else
            if isDraggingOverlay then
                isDraggingOverlay = false
                
                settings.Set("generalSettings.offsetPosition.x", OFFSET_POSITION_X)
                settings.Set("generalSettings.offsetPosition.y", OFFSET_POSITION_Y)
            end
        end
    end

end

Event.Logic.Subscribe("updateOverlays", updateOverlays)

settings.Subscribe(
    "generalSettings.hideOutOfCombat",
    function(value)
        HIDE_OUT_OF_COMBAT = value
    end
)

settings.Subscribe(
    "playerState.combatStyle",
    function(value)
        ACTIVE_COMBAT_STYLE = value
    end
)

settings.Subscribe(
    "fontSizes.largeFont",
    function(value)
        LARGE_FONT = value
    end
)

settings.Subscribe(
    "fontSizes.mediumFont",
    function(value)
        MEDIUM_FONT = value
    end
)

settings.Subscribe(
    "fontSizes.smallFont",
    function(value)
        SMALL_FONT = value
    end
)

settings.Subscribe(
    "generalSettings.readyText",
    function(value)
        READY_TEXT = value
    end
)

settings.Subscribe(
    "generalSettings.scale",
    function(value)
        UI_SCALE = value
    end
)

settings.Subscribe(
    "generalSettings.displayTimeAs",
    function(value)
        DISPLAY_TIME_AS = value
    end
)

settings.Subscribe(
    "fontColours.durationText",
    function(colour)
        FONT_COLOUR = colourToVector4(colour)

        for _, text in ipairs(fontTexts) do
            text.colour = FONT_COLOUR
        end
    end
)

settings.Subscribe(
    "fontColours.expiringText",
    function(colour)
        EXPIRING_COLOUR = colourToVector4(colour)
    end
)

settings.Subscribe(
    "fontColours.cooldownText",
    function(colour)
        COOLDOWN_COLOUR = colourToVector4(colour)
    end
)

settings.Subscribe(
    "fontColours.readyText",
    function(colour)
        READY_COLOUR = colourToVector4(colour)
    end
)

settings.Subscribe(
    "uiColours.shadowColour",
    function(colour)
        ABILITY_SHADOW_COLOUR = colourToVector4(colour)

        for _, shadow in ipairs(abilityShadows) do
            shadow.colour = ABILITY_SHADOW_COLOUR
        end
    end
)

settings.Subscribe(
    "uiColours.barColours.bloodTitheBar",
    function(colour)
        local vector4Color = colourToVector4(colour)
        BLOOD_TITHE_COLOUR = vector4Color
        magicUpkeepBars.bloodTithe.sprite.colour = vector4Color
    end
)

settings.Subscribe(
    "uiColours.barColours.glacialEmbraceBar",
    function(colour)
        local vector4Color = colourToVector4(colour)
        INCITE_FEAR_COLOUR = vector4Color
        magicUpkeepBars.glacialEmbrace.sprite.colour = vector4Color
    end
)

settings.Subscribe(
    "uiColours.barColours.essenceCorruptionBar",
    function(colour)
        local vector4Color = colourToVector4(colour)
        ESSENCE_CORRUPTION_COLOUR = vector4Color
        magicUpkeepBars.essenceCorruption.sprite.colour = vector4Color
    end
)

settings.Subscribe(
    "uiColours.runeColours.active",
    function(colour)
        ACTIVE_RUNE_COLOUR = colourToVector4(colour)       
    end
)

settings.Subscribe(
    "uiColours.runeColours.activeShadow",
    function(colour)
        ACTIVE_RUNE_SHADOW_COLOUR = colourToVector4(colour)
    end
)

settings.Subscribe(
    "uiColours.runeColours.inactive",
    function(colour)
        INACTIVE_RUNE_COLOUR = colourToVector4(colour)
    end
)

settings.Subscribe(
    "uiColours.runeColours.inactiveShadow",
    function(colour)
        INACTIVE_RUNE_SHADOW_COLOUR = colourToVector4(colour)
    end
)

settings.Subscribe(
    "rangedSettings.selectedGuthixianRune",
    function(value)
        SELECTED_GUTHIXIAN_RUNE = value
    end
)

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
