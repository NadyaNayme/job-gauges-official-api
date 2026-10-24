local settings = require("resources/database/settings")
local events = require("resources/events/events")
local InterfaceMouse = require("resources/ui/mouse")
local sprites = require("resources/ui/sprites")
local guthixian = require("resources/data/guthixian_runes")
local ammoNames = require("resources/data/ammo")

local generalSettings = require("resources/ui/settings/general")
local necromancySettings = require("resources/ui/settings/necromancy")
local magicSettings = require("resources/ui/settings/magic")
local meleeSettings = require("resources/ui/settings/melee")
local rangedSettings = require("resources/ui/settings/ranged")

local M = {}

-- The vast majority of this is boilerplate to setup all of the UI components,
-- get them positioned, and tell them how to update based on data from events.playerData

-- Things typically go in blocks of Necromancy -> Magic -> Ranged -> Melee and repeat
-- as that is the order I developed the gauges in. First everything gets created: `create__ComponentType()`.
-- Then everything gets individual functions to update their state `update__ComponentName()`.
-- There is a block to reposition everything at once: `set__ComponentPosition()`.

local function colourToVector4(colour, fallback)
    if colour == nil then colour = fallback end
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

-- ============================================================ 
-- Constants / Configuration
-- ============================================================

-- Globals
local OFFSET_POSITION_X = settings.Get("generalSettings.offsetPosition.x")
local OFFSET_POSITION_Y = settings.Get("generalSettings.offsetPosition.y")
local POSITION_LOCKED = settings.Get("generalSettings.positionLocked")
local COMPONENT_EDITING = settings.Get("generalSettings.componentEditing")
local RETINA_MONITOR = settings.Get("generalSettings.retinaMonitor") or 1
local isDraggingOverlay = false
local overlayMouseCapture = nil
local draggedComponent = nil
local componentMouseCapture = nil
local dragOffsetX = 0
local dragOffsetY = 0

local ACTIVE_COMBAT_STYLE = settings.Get('playerState.combatStyle')
local HIDE_OUT_OF_COMBAT = settings.Get('generalSettings.hideOutOfCombat')

local GAUGE_COMPONENTS = {}

local GAUGE_COMPONENT_POSITIONS = {
    necromancy = settings.Get("necromancySettings.componentPositions"),
    magic = settings.Get("magicSettings.componentPositions"),
    ranged = settings.Get("rangedSettings.componentPositions"),
    melee = settings.Get("meleeSettings.componentPositions"),
}

local RUNE_LAYOUT = settings.Get("rangedSettings.componentPositions.RUNE_LAYOUT")

local READY_TEXT = tostring(settings.Get("generalSettings.readyText"))
local SPRITE_READY_TEXT = tostring(settings.Get("generalSettings.spriteReadyText"))
local DISPLAY_TIME_AS = settings.Get("generalSettings.displayTimeAs")
local UI_SCALE = settings.Get("generalSettings.scale") or 1

local supportedFonts = {
    ["9pt Outline"] = id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE,
    ["9pt Regular"] = id.Font.NOTO_SANS_09PT_REGULAR_SHADOW,
    ["11pt Outline"] = id.Font.NOTO_SANS_11PT_BOLD_OUTLINE,
    ["11pt Shadow"] = id.Font.NOTO_SANS_11PT_BOLD_SHADOW,
    ["13pt Outline"] = id.Font.NOTO_SANS_13PT_BOLD_OUTLINE,
    ["21pt Outline"] = id.Font.NOTO_SANS_21PT_BOLD_OUTLINE,
    ["21pt Shadow"] = id.Font.NOTO_SANS_21PT_BOLD_SHADOW
}

local smallFontSetting = settings.Get("fontSizes.smallFont")
local mediumFontSetting = settings.Get("fontSizes.mediumFont")
local largeFontSetting = settings.Get("fontSizes.largeFont")

local SMALL_FONT = supportedFonts[smallFontSetting]
    or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE

local MEDIUM_FONT = supportedFonts[mediumFontSetting]
    or id.Font.NOTO_SANS_11PT_BOLD_OUTLINE

local LARGE_FONT = supportedFonts[largeFontSetting]
    or id.Font.NOTO_SANS_13PT_BOLD_OUTLINE

local FONT_COLOUR = colourToVector4(settings.Get("fontColours.durationText"), "0xFFFFFFFF")
local COOLDOWN_COLOUR = colourToVector4(settings.Get("fontColours.cooldownText"), "0xFFFFFFFF")
local EXPIRING_COLOUR = colourToVector4(settings.Get("fontColours.expiringText"), "0xF30B0BFF")
local READY_COLOUR = colourToVector4(settings.Get("fontColours.readyText"), "0xFFFFFFFF")

local SELECTED_GUTHIXIAN_RUNE = settings.Get("rangedSettings.selectedGuthixianRune")

local SHOW_RUNES = settings.Get("rangedSettings.componentVisibility")["show-guthixian-runes"]
local ACTIVE_RUNE_COLOUR = colourToVector4(settings.Get("uiColours.runeColours.active"), "0x70FF00FF")
local ACTIVE_RUNE_SHADOW_COLOUR = colourToVector4(settings.Get("uiColours.runeColours.activeShadow"), "0x100101FF")
local INACTIVE_RUNE_COLOUR = colourToVector4(settings.Get("uiColours.runeColours.inactive"), "0x050012FF")
local INACTIVE_RUNE_SHADOW_COLOUR = colourToVector4(settings.Get("uiColours.runeColours.inactiveShadow"), "0xC1BDAC89")

local RUNE_SHADOW_OFFSET = 1

local BACKDROP_COLOUR = colourToVector4(settings.Get("uiColours.backdropColour"), "0xFFFFFF00")
local BLOOD_TITHE_COLOUR = colourToVector4(settings.Get("uiColours.barColours.bloodTitheBar"), "0xF30B0BFF")
local INCITE_FEAR_COLOUR = colourToVector4(settings.Get("uiColours.barColours.inciteFearBar"), "0x16D6E5FF")
local ESSENCE_CORRUPTION_COLOUR = colourToVector4(settings.Get("uiColours.barColours.essenceCorruptionBar"), "0x16A127FF")

local AMMO_ID = 53 -- Headless Arrow by default if no ammo is detected
local AMMO_NAME = ''
local AMMO_DISPLAY_NAME = nil

local function scaleToFactor(number)
    return math.floor(number * UI_SCALE )
end

-- Convert captured mouse coordinates to the coordinate system
-- used by the gauge positions.
local function mouseToUI(number)
    return number / RETINA_MONITOR
end

local function snapToGrid(value, gridSize)
    return math.floor(value / gridSize + 0.5) * gridSize
end

local function getRuneLayout(perfectEquilibriumActive)
    local selectedGuthixianRune = SELECTED_GUTHIXIAN_RUNE

    if selectedGuthixianRune == "lore" then
        if perfectEquilibriumActive or not SHOW_RUNES then
            return RUNE_LAYOUT.NYU
        else
            return RUNE_LAYOUT.BALANCE
        end
    else
        if perfectEquilibriumActive or not SHOW_RUNES then
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

    local gameArea = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
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

            local x = scaleToFactor(runeLayout.x_offset) + position.x + OFFSET_POSITION_X
            local y = position.y + OFFSET_POSITION_Y

            shadow:SetPos(
                x + RUNE_SHADOW_OFFSET,
                y + RUNE_SHADOW_OFFSET
            )

            shadow:SetSize(
                scaleToFactor(runeLayout.size.width),
                scaleToFactor(runeLayout.size.height)
            )

            sprite:SetPos(
                x,
                y
            )

            sprite:SetSize(
                scaleToFactor(runeLayout.size.width),
                scaleToFactor(runeLayout.size.height)
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
        if not SHOW_RUNES then
            shadow:SetSize(0, 0)
            sprite:SetSize(0, 0)
        end
    end
end


local ABILITY_SHADOW_COLOUR = colourToVector4(settings.Get("uiColours.shadowColour"), "0x111111DD")
local ABILITY_SHADOW_SIZE = 42
local ABILITY_SHADOW_OFFSET = -1
local abilityShadows = {}
local backdrops = {}

local fontTexts = {}

local function ticksToSeconds(ticks)
    if DISPLAY_TIME_AS == "precise-time" then 
        return ticks * 0.6
    elseif DISPLAY_TIME_AS == "precise-ticks" then
        return ticks
    else 
        return math.ceil(ticks * 0.6)
    end
end

local function createGaugeLayer(parent)
    local layer = ui.Layer.new(parent)
    layer:SetSize(scaleToFactor(600), scaleToFactor(600), 1.0, 1.0)
    return layer
end

local function setAbilityIndicatorSprite(indicator, sprite, shadowSprite)
    indicator.shadow.sprite = shadowSprite
    indicator.sprite.sprite = sprite
end

local function createAbilityIndicator(parent, position)
    local layer = ui.Layer.new(parent)
    layer:SetSize(scaleToFactor(40), scaleToFactor(40), 1.0, 1.0)

    local backdrop = ui.Rectangle.new(layer)
    backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
    backdrop:SetSize(scaleToFactor(40), scaleToFactor(40))
    backdrop.colour = BACKDROP_COLOUR
    backdrop.fill = true
    backdrop.outlineThickness = -4

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
        math.floor(position.x + scaleToFactor(8) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(14) + OFFSET_POSITION_Y)
    )
    text:SetSize(scaleToFactor(22), scaleToFactor(15))
    text:MoveToFront()
    text.content = ""
    text.font = LARGE_FONT
    text.colour = FONT_COLOUR
    text.isShadowed = true
    text.alignHorizontal = ui.AlignMode.CENTRE
    text.alignVertical = ui.AlignMode.CENTRE

    table.insert(fontTexts, text)
    table.insert(abilityShadows, shadow)
    table.insert(backdrops, backdrop)

    return {
        layer = layer,
        backdrop = backdrop,
        shadow = shadow,
        sprite = sprite,
        text = text,
        width = 40,
        height = 40,
        position = position,
    }
end

local function createAbilitySpriteIndicator(parent, position)
    local layer = ui.Layer.new(parent)
    layer:SetSize(scaleToFactor(20), scaleToFactor(20), 1.0, 1.0)

    local backdrop = ui.Rectangle.new(layer)
    backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
    backdrop:SetSize(scaleToFactor(40), scaleToFactor(40))
    backdrop.colour = BACKDROP_COLOUR
    backdrop.fill = true
    backdrop.outlineThickness = -4

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
        math.floor(scaleToFactor(position.x + scaleToFactor(16) + OFFSET_POSITION_X)),
        math.floor(scaleToFactor(position.y + scaleToFactor(4) + OFFSET_POSITION_Y))
    )
    text:SetSize(scaleToFactor(22), scaleToFactor(15))
    text:MoveToFront()
    text.content = ""
    text.font = MEDIUM_FONT
    text.colour = FONT_COLOUR
    text.isShadowed = true
    text.alignHorizontal = ui.AlignMode.CENTRE
    text.alignVertical = ui.AlignMode.CENTRE

    table.insert(fontTexts, text)
    table.insert(abilityShadows, shadow)
    table.insert(backdrops, backdrop)

    return {
        layer = layer,
        backdrop = backdrop,
        shadow = shadow,
        sprite = sprite,
        text = text,
        width = 20,
        height = 20,
        position = position,
    }
end

local function createSpriteIndicator(parent, position, width, height)
    local layer = ui.Layer.new(parent)
    layer:SetSize(scaleToFactor(20), scaleToFactor(20), 1.0, 1.0)

    local backdrop = ui.Rectangle.new(layer)
    backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
    backdrop:SetSize(scaleToFactor(width), scaleToFactor(height))
    backdrop.colour = BACKDROP_COLOUR
    backdrop.fill = true
    backdrop.outlineThickness = -4
    table.insert(backdrops, backdrop)

    local sprite = ui.Sprite.new(layer)
    sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    sprite:SetSize(
        scaleToFactor(width),
        scaleToFactor(height)
    )

    sprite:MoveToFront()

    local text = ui.Text.new(layer)
    text:SetPos(
        math.floor(position.x + scaleToFactor(1) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(4) + OFFSET_POSITION_Y)
    )
    text:SetSize(scaleToFactor(22), scaleToFactor(15))
    text:MoveToFront()
    text.content = ""
    text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
    text.colour = FONT_COLOUR
    text.isShadowed = true
    text.alignHorizontal = ui.AlignMode.CENTRE
    text.alignVertical = ui.AlignMode.CENTRE

    return {
        layer = layer,
        backdrop = backdrop,
        sprite = sprite,
        text = text
    }
end

local function createObjectSpriteIndicator(parent, position, width, height)
    local layer = ui.Layer.new(parent)
    layer:SetSize(scaleToFactor(32), scaleToFactor(32), 1.0, 1.0)


    local backdrop = ui.Rectangle.new(layer)
    backdrop:SetPos(
        math.floor(scaleToFactor(position.x) + OFFSET_POSITION_X),
        math.floor(scaleToFactor(position.y) + OFFSET_POSITION_Y)
    )
    backdrop:SetSize(scaleToFactor(width), scaleToFactor(height))
    backdrop.colour = BACKDROP_COLOUR
    backdrop.fill = true
    backdrop.outlineThickness = -4
    table.insert(backdrops, backdrop)

    local sprite = ui.Sprite.new(layer)   
    sprite:SetPos(
        math.floor(scaleToFactor(position.x) + OFFSET_POSITION_X + scaleToFactor(5)),
        math.floor(scaleToFactor(position.y) + OFFSET_POSITION_Y + scaleToFactor(2))
    )

    sprite:SetSize(
        scaleToFactor(width),
        scaleToFactor(height)
    )
    sprite:MoveToFront()

    local text = ui.Text.new(layer)
    text:SetPos(
        math.floor(scaleToFactor(position.x) + scaleToFactor(8) + OFFSET_POSITION_X),
        math.floor(scaleToFactor(position.y) + scaleToFactor(12) + OFFSET_POSITION_Y)
    )
    text:SetSize(scaleToFactor(22), scaleToFactor(15))
    text:MoveToFront()
    text.content = AMMO_DISPLAY_NAME or AMMO_NAME
    text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
    text.colour = FONT_COLOUR
    text.isShadowed = true
    text.alignHorizontal = ui.AlignMode.CENTRE
    text.alignVertical = ui.AlignMode.CENTRE
    
    local worn = Inventory.Find(config.Inv.WORN)
    local wornObj = worn:GetSlot(14)

    if not wornObj or not wornObj.obj then
        return {
            layer = layer,
            backdrop = backdrop,
            sprite = sprite,
            text = text
        }
    end

    local equipped = wornObj.obj
    local quiver = var.VarPlayer["QUIVER_ACTIVE_AMMO"]
    local quiverValue = quiver and quiver.value

    events.playerData.ranged.activeAmmo.name = equipped.name
    events.playerData.ranged.activeAmmo.icon = equipped.configName
    events.playerData.ranged.activeAmmo.id = equipped.id

    if quiverValue then
        events.playerData.ranged.quiverAmmo.name = quiverValue.name
        events.playerData.ranged.quiverAmmo.icon = quiverValue.configName
        events.playerData.ranged.quiverAmmo.id = quiverValue.id
    end

    if wornObj and wornObj.obj then
        if wornObj.obj.configName:find("ARROW", 1, true) then
            sprite:SetAssociatedObject(events.playerData.ranged.activeAmmo.id + 4)
        elseif wornObj.obj.configName:find("BOLT", 1, true) then
            sprite:SetAssociatedObject(events.playerData.ranged.activeAmmo.id + 0)
        elseif wornObj.obj.configName:find("QUIVER", 1, true) then
            sprite:SetAssociatedObject(events.playerData.ranged.quiverAmmo.id)
        end
    end

    return {
        layer = layer,
        backdrop = backdrop,
        sprite = sprite,
        text = text
    }
end

local function setObjectSpriteIndicatorPosition(indicator, position)

    indicator.backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.text:SetPos(
        math.floor(position.x + scaleToFactor(8) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(14) + OFFSET_POSITION_Y)
    )

end

local magicUpkeepBars = {}
local function createMagicUpkeepIndicator(parent, position, name)
    local layer = ui.Layer.new(parent)
    layer:SetSize(scaleToFactor(90), scaleToFactor(24), 1.0, 1.0)

    local backdrop = ui.Rectangle.new(layer)
    backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
    backdrop:SetSize(scaleToFactor(90), scaleToFactor(24))
    backdrop.colour = BACKDROP_COLOUR
    backdrop.fill = true
    backdrop.outlineThickness = -4
    table.insert(backdrops, backdrop)

    local text = ui.Text.new(layer)
    text:SetPos(
        math.floor(position.x + scaleToFactor(9) + OFFSET_POSITION_X),
        math.floor(position.y - scaleToFactor(4) + OFFSET_POSITION_Y)
    )
    text:SetSize(scaleToFactor(28), scaleToFactor(16))
    text.content = ""
    text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
    text.colour = FONT_COLOUR
    text.isShadowed = true

    local shadow = ui.Sprite.new(layer)
    shadow:SetPos(
        math.floor(position.x + scaleToFactor(59) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(3) + OFFSET_POSITION_Y)
    )
    shadow:SetSize(scaleToFactor(0), scaleToFactor(6))

    local sprite = ui.Sprite.new(layer)
    sprite:SetPos(
        math.floor(position.x + scaleToFactor(58) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(2) + OFFSET_POSITION_Y)
    )
    sprite:SetSize(scaleToFactor(0), scaleToFactor(6))

    table.insert(fontTexts, text)

    magicUpkeepBars[name] = {
        layer = layer,
        backdrop = backdrop,
        text = text,
        sprite = sprite,
        shadow = shadow,
    }

    return magicUpkeepBars[name]
end

local function setAbilityIndicatorPosition(indicator, position)
    indicator.backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.shadow:SetPos(
        math.floor(position.x + OFFSET_POSITION_X + ABILITY_SHADOW_OFFSET),
        math.floor(position.y + OFFSET_POSITION_Y + ABILITY_SHADOW_OFFSET)
    )

    indicator.sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.text:SetPos(
        math.floor(position.x + scaleToFactor(8) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(14) + OFFSET_POSITION_Y)
    )

end

local function setAbilitySpriteIndicatorPosition(indicator, position)
    indicator.backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.shadow:SetPos(
        math.floor(position.x + OFFSET_POSITION_X + ABILITY_SHADOW_OFFSET),
        math.floor(position.y + OFFSET_POSITION_Y + ABILITY_SHADOW_OFFSET)
    )

    indicator.sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.text:SetPos(
        math.floor(position.x + scaleToFactor(16) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(4) + OFFSET_POSITION_Y)
    )

end

local function setSpriteIndicatorPosition(indicator, position)
    indicator.backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.sprite:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )
    indicator.text:SetPos(
        math.floor(position.x + scaleToFactor(1) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(4) + OFFSET_POSITION_Y)
    )
end

local function setMagicUpkeepIndicatorPosition(indicator, position)
    indicator.backdrop:SetPos(
        math.floor(position.x + OFFSET_POSITION_X),
        math.floor(position.y + OFFSET_POSITION_Y)
    )

    indicator.text:SetPos(
        math.floor(position.x + scaleToFactor(9) + OFFSET_POSITION_X),
        math.floor(position.y - scaleToFactor(4) + OFFSET_POSITION_Y)
    )

    indicator.sprite:SetPos(
        math.floor(position.x + scaleToFactor(58) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(2) + OFFSET_POSITION_Y)
    )

    indicator.shadow:SetPos(
        math.floor(position.x + scaleToFactor(59) + OFFSET_POSITION_X),
        math.floor(position.y + scaleToFactor(3) + OFFSET_POSITION_Y)
    )
end

local CreateUI = function()
    local gameArea = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
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
    deathGrasp.style = "necromancy"
    deathGrasp.position = GAUGE_COMPONENT_POSITIONS.necromancy.deathGrasp
    deathGrasp.positionKey = "deathGrasp"
    deathGrasp.width = 40
    deathGrasp.height = 40
    table.insert(GAUGE_COMPONENTS, deathGrasp)

    local deathEssence = createAbilityIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.deathEssence
    )
    deathEssence.style = "necromancy"
    deathEssence.position = GAUGE_COMPONENT_POSITIONS.necromancy.deathEssence
    deathEssence.positionKey = "deathEssence"
    deathEssence.width = 40
    deathEssence.height = 40
    table.insert(GAUGE_COMPONENTS, deathEssence)

    local soulCrush = createAbilityIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.soulCrush
    )
    soulCrush.style = "necromancy"
    soulCrush.position = GAUGE_COMPONENT_POSITIONS.necromancy.soulCrush
    soulCrush.positionKey = "soulCrush"
    soulCrush.width = 40
    soulCrush.height = 40
    table.insert(GAUGE_COMPONENTS, soulCrush)

    local conjureUndeadArmy = createAbilityIndicator(necromancyGaugeLayer, GAUGE_COMPONENT_POSITIONS.necromancy.conjureUndeadArmy)
    local livingDeath = createAbilityIndicator(necromancyGaugeLayer, GAUGE_COMPONENT_POSITIONS.necromancy.livingDeath)

    conjureUndeadArmy.style = "necromancy"
    conjureUndeadArmy.position = GAUGE_COMPONENT_POSITIONS.necromancy.conjureUndeadArmy
    conjureUndeadArmy.positionKey = "conjureUndeadArmy"
    conjureUndeadArmy.width = 40
    conjureUndeadArmy.height = 40
    table.insert(GAUGE_COMPONENTS, conjureUndeadArmy)
    livingDeath.style = "necromancy"
    livingDeath.position = GAUGE_COMPONENT_POSITIONS.necromancy.livingDeath
    livingDeath.positionKey = "livingDeath"
    livingDeath.width = 40
    livingDeath.height = 40
    table.insert(GAUGE_COMPONENTS, livingDeath)

    local residualSoulsStacks = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.residualSoulsStacks,
        132,
        24
    )
    residualSoulsStacks.style = "necromancy"
    residualSoulsStacks.position = GAUGE_COMPONENT_POSITIONS.necromancy.residualSoulsStacks
    residualSoulsStacks.positionKey = "residualSoulsStacks"
    residualSoulsStacks.width = 132
    residualSoulsStacks.height = 24
    table.insert(GAUGE_COMPONENTS, residualSoulsStacks)

    local necrosisStacks = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.necrosisStacks,
        132,
        20
    )
    necrosisStacks.style = "necromancy"
    necrosisStacks.position = GAUGE_COMPONENT_POSITIONS.necromancy.necrosisStacks
    necrosisStacks.positionKey = "necrosisStacks"
    necrosisStacks.width = 132
    necrosisStacks.height = 20
    table.insert(GAUGE_COMPONENTS, necrosisStacks)

    local bloat = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.bloat,
        132,
        24
    )
    bloat.style = "necromancy"
    bloat.position = GAUGE_COMPONENT_POSITIONS.necromancy.bloat
    bloat.positionKey = "bloat"
    bloat.width = 132
    bloat.height = 24
    table.insert(GAUGE_COMPONENTS, bloat)

    local invokeDeath = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.invokeDeath,
        24,
        21
    )
    invokeDeath.style = "necromancy"
    invokeDeath.position = GAUGE_COMPONENT_POSITIONS.necromancy.invokeDeath
    invokeDeath.positionKey = "invokeDeath"
    invokeDeath.width = 24
    invokeDeath.height = 21
    table.insert(GAUGE_COMPONENTS, invokeDeath)

    local threadsOfFate = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.threadsOfFate,
        24,
        21
    )
    threadsOfFate.style = "necromancy"
    threadsOfFate.position = GAUGE_COMPONENT_POSITIONS.necromancy.threadsOfFate
    threadsOfFate.positionKey = "threadsOfFate"
    threadsOfFate.width = 24
    threadsOfFate.height = 21
    table.insert(GAUGE_COMPONENTS, threadsOfFate)

    local splitSoul = createSpriteIndicator(
        necromancyGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.necromancy.splitSoul,
        24,
        21
    )
    splitSoul.style = "necromancy"
    splitSoul.position = GAUGE_COMPONENT_POSITIONS.necromancy.splitSoul
    splitSoul.positionKey = "splitSoul"
    splitSoul.width = 24
    splitSoul.height = 21
    table.insert(GAUGE_COMPONENTS, splitSoul)

  -- Magic Overlay
    local magicGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local tsunami = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.tsunami
    )
    tsunami.style = "magic"
    tsunami.position = GAUGE_COMPONENT_POSITIONS.magic.tsunami
    tsunami.positionKey = "tsunami"
    tsunami.width = 40
    tsunami.height = 40
    table.insert(GAUGE_COMPONENTS, tsunami)

    local sunshine = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.sunshine
    )
    sunshine.style = "magic"
    sunshine.position = GAUGE_COMPONENT_POSITIONS.magic.sunshine
    sunshine.positionKey = "sunshine"
    sunshine.width = 40
    sunshine.height = 40
    table.insert(GAUGE_COMPONENTS, sunshine)

    local runicCharge = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.runicCharge
    )
    runicCharge.style = "magic"
    runicCharge.position = GAUGE_COMPONENT_POSITIONS.magic.runicCharge
    runicCharge.positionKey = "runicCharge"
    runicCharge.width = 40
    runicCharge.height = 40
    table.insert(GAUGE_COMPONENTS, runicCharge)

    local soulfire = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.soulfire
    )
    soulfire.style = "magic"
    soulfire.position = GAUGE_COMPONENT_POSITIONS.magic.soulfire
    soulfire.positionKey = "soulfire"
    soulfire.width = 40
    soulfire.height = 40
    table.insert(GAUGE_COMPONENTS, soulfire)

    local instability = createAbilityIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.instability
    )
    instability.style = "magic"
    instability.position = GAUGE_COMPONENT_POSITIONS.magic.instability
    instability.positionKey = "instability"
    instability.width = 40
    instability.height = 40
    table.insert(GAUGE_COMPONENTS, instability)

    local activeSpellSprite = createSpriteIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.activeSpell,
        24,
        21
    )
    activeSpellSprite.style = "magic"
    activeSpellSprite.position = GAUGE_COMPONENT_POSITIONS.magic.activeSpell
    activeSpellSprite.positionKey = "activeSpellSprite"
    activeSpellSprite.width = 24
    activeSpellSprite.height = 21
    table.insert(GAUGE_COMPONENTS, activeSpellSprite)

    local bloodTithe = createMagicUpkeepIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.bloodTithe,
        "bloodTithe"
    )
    bloodTithe.style = "magic"
    bloodTithe.position = GAUGE_COMPONENT_POSITIONS.magic.bloodTithe
    bloodTithe.positionKey = "bloodTithe"
    bloodTithe.width = 90
    bloodTithe.height = 24
    table.insert(GAUGE_COMPONENTS, bloodTithe)

    local inciteFear = createMagicUpkeepIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.inciteFear,
        "inciteFear"
    )
    inciteFear.style = "magic"
    inciteFear.position = GAUGE_COMPONENT_POSITIONS.magic.inciteFear
    inciteFear.positionKey = "inciteFear"
    inciteFear.width = 90
    inciteFear.height = 24
    table.insert(GAUGE_COMPONENTS, inciteFear)

    local essenceCorruption = createMagicUpkeepIndicator(
        magicGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.magic.essenceCorruption,
        "essenceCorruption"
    )
    essenceCorruption.style = "magic"
    essenceCorruption.position = GAUGE_COMPONENT_POSITIONS.magic.essenceCorruption
    essenceCorruption.positionKey = "essenceCorruption"
    essenceCorruption.width = 90
    essenceCorruption.height = 24
    table.insert(GAUGE_COMPONENTS, essenceCorruption)

    -- Ranged Overlay
    local rangedGaugeLayer = createGaugeLayer(jobGaugeLayer)
    local deathsSwiftness = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.deathsSwiftness
    )
    deathsSwiftness.style = "ranged"
    deathsSwiftness.position = GAUGE_COMPONENT_POSITIONS.ranged.deathsSwiftness
    deathsSwiftness.positionKey = "deathsSwiftness"
    deathsSwiftness.width = 40
    deathsSwiftness.height = 40
    table.insert(GAUGE_COMPONENTS, deathsSwiftness)

    local crystalRain = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.crystalRain
    )
    crystalRain.style = "ranged"
    crystalRain.position = GAUGE_COMPONENT_POSITIONS.ranged.crystalRain
    crystalRain.positionKey = "crystalRain"
    crystalRain.width = 40
    crystalRain.height = 40
    table.insert(GAUGE_COMPONENTS, crystalRain)

    local equippedAmmoSprite = createObjectSpriteIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.equippedAmmo,
        scaleToFactor(32),
        scaleToFactor(32)
    )
    if equippedAmmoSprite then
        equippedAmmoSprite.style = "ranged"
        equippedAmmoSprite.position = GAUGE_COMPONENT_POSITIONS.ranged.equippedAmmo
        equippedAmmoSprite.position.x = scaleToFactor(equippedAmmoSprite.position.x)
        equippedAmmoSprite.position.y = scaleToFactor(equippedAmmoSprite.position.y)
        equippedAmmoSprite.positionKey = "equippedAmmoSprite"
        equippedAmmoSprite.width = scaleToFactor(32)
        equippedAmmoSprite.height = scaleToFactor(32)
        table.insert(GAUGE_COMPONENTS, equippedAmmoSprite)
    end

    local splitSoul_ecb = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.splitSoul
    )
    splitSoul_ecb.style = "ranged"
    splitSoul_ecb.position = GAUGE_COMPONENT_POSITIONS.ranged.splitSoul
    splitSoul_ecb.positionKey = "splitSoul_ecb"
    splitSoul_ecb.width = 40
    splitSoul_ecb.height = 40
    table.insert(GAUGE_COMPONENTS, splitSoul_ecb)

    local searingWinds = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.searingWinds
    )
    searingWinds.style = "ranged"
    searingWinds.position = GAUGE_COMPONENT_POSITIONS.ranged.searingWinds
    searingWinds.positionKey = "searingWinds"
    searingWinds.width = 40
    searingWinds.height = 40
    table.insert(GAUGE_COMPONENTS, searingWinds)

    local shadowImbued = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.shadowImbued
    )
    shadowImbued.style = "ranged"
    shadowImbued.position = GAUGE_COMPONENT_POSITIONS.ranged.shadowImbued
    shadowImbued.positionKey = "shadowImbued"
    shadowImbued.width = 40
    shadowImbued.height = 40
    table.insert(GAUGE_COMPONENTS, shadowImbued)

    local perfectEquilibrium = createAbilityIndicator(
        rangedGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.ranged.perfectEquilibrium
    )
    perfectEquilibrium.style = "ranged"
    perfectEquilibrium.position = GAUGE_COMPONENT_POSITIONS.ranged.perfectEquilibrium
    perfectEquilibrium.positionKey = "perfectEquilibrium"
    perfectEquilibrium.width = 40
    perfectEquilibrium.height = 40
    table.insert(GAUGE_COMPONENTS, perfectEquilibrium)

    createBOLGLetters(rangedGaugeLayer)
    bolgLetters.style = "ranged"
    bolgLetters.position = GAUGE_COMPONENT_POSITIONS.ranged.guthixianRunes
    bolgLetters.positionKey = "bolgLetters"
    bolgLetters.width = 120
    bolgLetters.height = 40
    table.insert(GAUGE_COMPONENTS, bolgLetters)

    local perfectEquilibriumStacksText = ui.Text.new(rangedGaugeLayer)
    perfectEquilibriumStacksText:SetSize(scaleToFactor(22), scaleToFactor(24))
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
    blackhole.style = "melee"
    blackhole.position = GAUGE_COMPONENT_POSITIONS.melee.blackhole
    blackhole.positionKey = "blackhole"
    blackhole.width = 40
    blackhole.height = 40
    table.insert(GAUGE_COMPONENTS, blackhole)

    local igneousShowdown = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.igneousShowdown
    )
    igneousShowdown.style = "melee"
    igneousShowdown.position = GAUGE_COMPONENT_POSITIONS.melee.igneousShowdown
    igneousShowdown.positionKey = "igneousShowdown"
    igneousShowdown.width = 40
    igneousShowdown.height = 40
    table.insert(GAUGE_COMPONENTS, igneousShowdown)

    local bloodlust = createAbilitySpriteIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.bloodlust
    )
    bloodlust.style = "melee"
    bloodlust.position = GAUGE_COMPONENT_POSITIONS.melee.bloodlust
    bloodlust.positionKey = "bloodlust"
    bloodlust.width = 20
    bloodlust.height = 20
    table.insert(GAUGE_COMPONENTS, bloodlust)

    local chaosRoar = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.chaosRoar
    )
    chaosRoar.style = "melee"
    chaosRoar.position = GAUGE_COMPONENT_POSITIONS.melee.chaosRoar
    chaosRoar.positionKey = "chaosRoar"
    chaosRoar.width = 40
    chaosRoar.height = 40
    table.insert(GAUGE_COMPONENTS, chaosRoar)

    local meteorStrike = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.meteorStrike
    )
    meteorStrike.style = "melee"
    meteorStrike.position = GAUGE_COMPONENT_POSITIONS.melee.meteorStrike
    meteorStrike.positionKey = "meteorStrike"
    meteorStrike.width = 40
    meteorStrike.height = 40
    table.insert(GAUGE_COMPONENTS, meteorStrike)

    local berserk = createAbilityIndicator(
        meleeGaugeLayer,
        GAUGE_COMPONENT_POSITIONS.melee.berserk
    )
    berserk.style = "melee"
    berserk.position = GAUGE_COMPONENT_POSITIONS.melee.berserk
    berserk.positionKey = "berserk"
    berserk.width = 40
    berserk.height = 40
    table.insert(GAUGE_COMPONENTS, berserk)

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

        setObjectSpriteIndicatorPosition(
            equippedAmmoSprite,
            positions.ranged.equippedAmmo
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
        math.floor(scaleToFactor(layout.stacksText.x) + OFFSET_POSITION_X + bolgLetters.position.x - scaleToFactor(24)),
        math.floor(scaleToFactor(layout.stacksText.y) + OFFSET_POSITION_Y + bolgLetters.position.y - scaleToFactor(50))
    )

    end

local function beginMouseCapture()
    if mouseCaptureComponent then
        return true
    end

    local gameArea = ui.Interfaces:GetComponent(
        id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP
    )

    if not gameArea then
        return false
    end

    InterfaceMouse.BeginScreenCapture(gameArea, 0, 0)

    mouseCaptureComponent = gameArea

    return true
end

local function endMouseCapture()
    if not mouseCaptureComponent then
        return
    end

    InterfaceMouse.EndCapture(mouseCaptureComponent)
    mouseCaptureComponent = nil
end

local function getMousePosition()
    if not mouseCaptureComponent then
        return nil
    end

    return InterfaceMouse.GetPosition(
        mouseCaptureComponent,
        0,
        0
    )
end

local function getHoveredComponent(mousePosition)
    if not Mouse.IsAvailable() or not mousePosition then
        return nil
    end

    local combatStyle = events.playerData.combatStyle

    for _, component in ipairs(GAUGE_COMPONENTS) do
        if component.style == combatStyle or combatStyle == "all" then
            local position = component.position

            local x = position.x + OFFSET_POSITION_X
            local y = position.y + OFFSET_POSITION_Y

            local width = scaleToFactor(component.width)
            local height = scaleToFactor(component.height)

            if mousePosition.x >= x
                and mousePosition.x <= x + width
                and mousePosition.y >= y
                and mousePosition.y <= y + height
            then
                return component
            end
        end
    end

    return nil
end

local settingsView
Event.SettingsLayerReady.Subscribe("openSettingsWindow", function(event)
     if settingsView then settingsView:Destroy() end

     local parent = event.component

    settingsView = prettyui.SimpleView.new(parent, {
        width = parent.width,
        height = parent.height,
    })

  local tabs = settingsView:AddTabs({ "General", "Necromancy", "Magic", "Melee", "Ranged" }, { height = -20, heightAnchor = 1.0 })

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
end)

local contentView
Event.ContentLayerReady.Subscribe("openSettingsContentWindow", function(event)
     if contentView then contentView:Destroy() end

     local parent = event.component

    contentView = prettyui.SimpleView.new(parent, {
        width = parent.width,
        height = parent.height,
    })

  local tabs = contentView:AddTabs({ "General", "Necromancy", "Magic", "Melee", "Ranged" }, { height = -20, heightAnchor = 1.0 })

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
end)

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
    elseif combatStyle == "all" then
        necromancyGaugeLayer.hidden = false
        magicGaugeLayer.hidden = false
        rangedGaugeLayer.hidden = false
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
    indicator.sprite:SetSize(scaleToFactor(upkeep.remainingDuration * 2.25), scaleToFactor(3))
    indicator.shadow:SetSize(scaleToFactor(upkeep.remainingDuration * 2.25), scaleToFactor(3))
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

    -- Everything here follows the floor of "check visibility setting"
    -- and then what needs to be shown based on events.playerData

    -- TODO: Potential optimization: Only update gauges when that combat style is the active style...
    -- by adding `ACTIVE_COMBAT_STYLE == 'type' and` to each of these checks to shortcircuit
    -- if that gauge isn't visible and thus doesn't need to be being updated.
    
    if playerData.inCombat ~= true and HIDE_OUT_OF_COMBAT == "combat-visible" then
        necromancyGaugeLayer.hidden = true
        magicGaugeLayer.hidden = true
        rangedGaugeLayer.hidden = true
        meleeGaugeLayer.hidden = true
     end

    if playerData.viewingWorldMap == true then
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
                deathGrasp.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                deathEssence.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                soulCrush.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                livingDeath.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
                livingDeath.text.content = READY_TEXT
                livingDeath.text.colour = READY_COLOUR
        end
    else 
        livingDeath.layer.hidden = true
    end
    
    -- Residual Soul Stacks
    if necromancySettings.componentVisibility["show-residual-souls"] then 
        residualSoulsStacks.layer.hidden = false
        if necromancy.residualSoulStacks == 0 then
                residualSoulsStacks.sprite.sprite = overlaySprites.necromancy.souls.zero
        elseif necromancy.residualSoulStacks == 1 then
                residualSoulsStacks.sprite.sprite = overlaySprites.necromancy.souls.one
        elseif necromancy.residualSoulStacks == 2 then
                residualSoulsStacks.sprite.sprite = overlaySprites.necromancy.souls.two
        elseif necromancy.residualSoulStacks == 3 then
                residualSoulsStacks.sprite.sprite = overlaySprites.necromancy.souls.three
        elseif necromancy.residualSoulStacks == 4 then
                residualSoulsStacks.sprite.sprite = overlaySprites.necromancy.souls.four
        elseif necromancy.residualSoulStacks == 5 then
                residualSoulsStacks.sprite.sprite = overlaySprites.necromancy.souls.five
        end
    else 
        residualSoulsStacks.layer.hidden = true
    end

    -- Necrosis Stacks
    if necromancySettings.componentVisibility["show-necrosis-stacks"] then 
        necrosisStacks.layer.hidden = false
        if necromancy.necrosisStacks == 0 then
                necrosisStacks.sprite.sprite = overlaySprites.necromancy.necrosis.zero
        elseif necromancy.necrosisStacks == 2 then
                necrosisStacks.sprite.sprite = overlaySprites.necromancy.necrosis.two
        elseif necromancy.necrosisStacks == 4 then
                necrosisStacks.sprite.sprite = overlaySprites.necromancy.necrosis.four
        elseif necromancy.necrosisStacks == 6 then
                necrosisStacks.sprite.sprite = overlaySprites.necromancy.necrosis.six
        elseif necromancy.necrosisStacks == 8 then
                necrosisStacks.sprite.sprite = overlaySprites.necromancy.necrosis.eight
        elseif necromancy.necrosisStacks == 10 then
                necrosisStacks.sprite.sprite = overlaySprites.necromancy.necrosis.ten
        elseif necromancy.necrosisStacks == 12 then
                necrosisStacks.sprite.sprite = overlaySprites.necromancy.necrosis.twelve
        end
    else 
        necrosisStacks.layer.hidden = true
    end

    if necromancySettings.componentVisibility["show-bloat"] then
        bloat.layer.hidden = false

        if necromancy.bloat.active then
            if necromancy.bloat.remainingDuration < 1 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.expired
            elseif necromancy.bloat.remainingDuration < 3 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_0
            elseif necromancy.bloat.remainingDuration < 6 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_10
            elseif necromancy.bloat.remainingDuration < 9 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_20
            elseif necromancy.bloat.remainingDuration < 12 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_30
            elseif necromancy.bloat.remainingDuration < 15 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_40
            elseif necromancy.bloat.remainingDuration < 18 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_50
            elseif necromancy.bloat.remainingDuration < 21 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_60
            elseif necromancy.bloat.remainingDuration < 24 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_70
            elseif necromancy.bloat.remainingDuration < 27 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_80
            elseif necromancy.bloat.remainingDuration < 30 then
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_90
            else
                bloat.sprite.sprite = overlaySprites.necromancy.bloat.bloat_100
            end
        else
            bloat.sprite.sprite = overlaySprites.necromancy.bloat.expired
        end
    else
        bloat.layer.hidden = true
    end

    -- Incantations

    -- Invoke Death
    if necromancySettings.componentVisibility["show-invoke-death"] then 
        invokeDeath.layer.hidden = false
        if necromancy.incantations.invokeDeath.active == 1 then
            invokeDeath.sprite.sprite = overlaySprites.necromancy.incantations.invokeDeath.active
        else 
            invokeDeath.sprite.sprite = overlaySprites.necromancy.incantations.invokeDeath.inactive
        end
    else
        invokeDeath.layer.hidden = true
    end

    -- Threads of Fate
    if necromancySettings.componentVisibility["show-threads-of-fate"] then 
        threadsOfFate.layer.hidden = false
        if necromancy.incantations.threadsOfFate.active == 1 then
            threadsOfFate.sprite.sprite = overlaySprites.necromancy.incantations.threadsOfFate.active
            threadsOfFate.text.content = tostring(ticksToSeconds(events.playerData.necromancy.incantations.threadsOfFate.remainingDuration))
            threadsOfFate.text.colour = FONT_COLOUR
        else 
            threadsOfFate.sprite.sprite = overlaySprites.necromancy.incantations.threadsOfFate.inactive
            threadsOfFate.text.content = tostring(ticksToSeconds(events.playerData.necromancy.incantations.threadsOfFate.cooldown))
            threadsOfFate.text.colour = COOLDOWN_COLOUR
            if necromancy.incantations.threadsOfFate.cooldown == 0 then
                threadsOfFate.sprite.sprite = overlaySprites.necromancy.incantations.threadsOfFate.active
                threadsOfFate.text.content = SPRITE_READY_TEXT
                threadsOfFate.text.colour = READY_COLOUR
            end
        end
    else
        threadsOfFate.layer.hidden = true
    end

    -- Split Soul
    if necromancySettings.componentVisibility["show-split-soul"] then 
        splitSoul.layer.hidden = false
        if necromancy.incantations.splitSoul.active == 1 then
            splitSoul.sprite.sprite = overlaySprites.necromancy.incantations.splitSoul.active
            splitSoul.text.content = tostring(ticksToSeconds(events.playerData.necromancy.incantations.splitSoul.remainingDuration))
            splitSoul.text.colour = FONT_COLOUR
        else 
            splitSoul.sprite.sprite = overlaySprites.necromancy.incantations.splitSoul.inactive
            splitSoul.text.content = tostring(ticksToSeconds(events.playerData.necromancy.incantations.splitSoul.cooldown))
            splitSoul.text.colour = COOLDOWN_COLOUR
            if necromancy.incantations.splitSoul.cooldown == 0 then
                splitSoul.sprite.sprite = overlaySprites.necromancy.incantations.splitSoul.active
                splitSoul.text.content = SPRITE_READY_TEXT
                splitSoul.text.colour = READY_COLOUR
            end
        end
    else
        splitSoul.layer.hidden = true
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
                sunshine.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                tsunami.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                runicCharge.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                soulfire.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                instability.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
                instability.text.content = READY_TEXT
                instability.text.colour = READY_COLOUR
        end
    else 
        instability.layer.hidden = true
    end

    if magicSettings.componentVisibility["show-active-spell"] and magic.activeSpell and magic.activeSpell.icon then
        activeSpellSprite.layer.hidden = false
        activeSpellSprite.sprite.sprite = id.Sprite[magic.activeSpell.icon]
    else
        activeSpellSprite.layer.hidden = true
    end

    if magicSettings.componentVisibility["show-blood-tithe"] then
        bloodTithe.layer.hidden = false
        updateMagicUpkeepIndicator(
            bloodTithe,
            magic.upkeep.blood_tithe
        )
    else
        bloodTithe.layer.hidden = true
    end

    if magicSettings.componentVisibility["show-incite-fear"] then
        inciteFear.layer.hidden = false
        updateMagicUpkeepIndicator(
            inciteFear,
            magic.upkeep.incite_fear
        )
    else
        inciteFear.layer.hidden = true
    end

    if magicSettings.componentVisibility["show-essence-corruption"] then
        essenceCorruption.layer.hidden = false
        updateMagicUpkeepIndicator(
            essenceCorruption,
        magic.upkeep.essence_corruption
        )
    else
        essenceCorruption.layer.hidden = true
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
                crystalRain.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                splitSoul_ecb.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
                splitSoul_ecb.text.content = READY_TEXT
                splitSoul_ecb.text.colour = READY_COLOUR
        end
    else 
        splitSoul_ecb.layer.hidden = true
    end

    -- The nil checks are necessary as the ammo does not update immediately
    -- but rather, updates on the first game tick. So the first check returns
    -- and every subsequent check works
    if rangedSettings.componentVisibility["show-equipped-ammo"] then
        equippedAmmoSprite.layer.hidden = false
        local worn = Inventory.Find(config.Inv.WORN)
        local wornObj = worn:GetSlot(14)

        if wornObj and wornObj.obj then
            if wornObj.obj.configName:find("ARROW", 1, true) then
                -- Every stack of 5 is packed for arrows, at least that I saw
                local AMMO_STACK_ID = tonumber(AMMO_ID) + 4
                equippedAmmoSprite.sprite:SetAssociatedObject(AMMO_STACK_ID)
                equippedAmmoSprite.text.content = AMMO_DISPLAY_NAME or string.sub(AMMO_NAME, 1, 3)
            elseif wornObj.obj.configName:find("BOLT", 1, true) then 
                -- The same is not true of Bolts.
                local AMMO_STACK_ID = tonumber(AMMO_ID)
                equippedAmmoSprite.sprite:SetAssociatedObject(AMMO_STACK_ID)
                equippedAmmoSprite.text.content = AMMO_DISPLAY_NAME or string.sub(AMMO_NAME, 1, 3)
            elseif wornObj.obj.configName:find("QUIVER", 1, true) then
                -- If we have a quiver equipped, report the currently cycled ammo instead.
                local QUIVER_AMMO_ID = tonumber(AMMO_ID)
                if QUIVER_AMMO_ID == nil then return end
                QUIVER_AMMO_ID = QUIVER_AMMO_ID + 4
                equippedAmmoSprite.sprite:SetAssociatedObject(QUIVER_AMMO_ID)
                equippedAmmoSprite.text.content = AMMO_DISPLAY_NAME or string.sub(AMMO_NAME, 1, 3)
            end
        end
    else
        equippedAmmoSprite.layer.hidden = true
    end

    if magicSettings.componentVisibility["show-active-spell"] and magic.activeSpell and magic.activeSpell.icon then
        activeSpellSprite.layer.hidden = false
        activeSpellSprite.sprite.sprite = id.Sprite[magic.activeSpell.icon]
    else
        activeSpellSprite.layer.hidden = true
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
                deathsSwiftness.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                searingWinds.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                shadowImbued.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
    else 
        perfectEquilibrium.layer.hidden = true
    end

    if rangedSettings.componentVisibility["show-perfect-equilibrium-stacks"] then
        perfectEquilibriumStacksText.hidden = false
        perfectEquilibriumStacksText.content =
            tostring(ranged.perfectEquilibrium.stacks)
    else
        perfectEquilibriumStacksText.hidden = true
    end

    local perfectEquilibriumActive = ranged.perfectEquilibrium.active == 1
    local layout = getRuneLayout(perfectEquilibriumActive)

    perfectEquilibriumStacksText:SetPos(
        math.floor(scaleToFactor(layout.stacksText.x) + OFFSET_POSITION_X + bolgLetters.position.x - scaleToFactor(24)),
        math.floor(scaleToFactor(layout.stacksText.y) + OFFSET_POSITION_Y + bolgLetters.position.y - scaleToFactor(50))
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
                blackhole.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                igneousShowdown.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                setAbilityIndicatorSprite(
                    chaosRoar,
                    overlaySprites.melee.chaos_roar.active,
                    overlaySprites.utility.shadow
                )
                if ticksToSeconds(melee.chaosRoar.remainingDuration) == 0.0 then
                    melee.chaosRoar.active = 0
                end
                chaosRoar.text.font = LARGE_FONT
                chaosRoar.text.content = tostring(ticksToSeconds(melee.chaosRoar.remainingDuration))
                chaosRoar.text.colour = FONT_COLOUR
            elseif melee.chaosRoar.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    chaosRoar,
                    overlaySprites.melee.chaos_roar.inactive,
                    overlaySprites.utility.shadow
                )
                chaosRoar.text.font = LARGE_FONT
                chaosRoar.text.content = tostring(ticksToSeconds(melee.chaosRoar.cooldown))
                chaosRoar.text.colour = COOLDOWN_COLOUR
            else
                setAbilityIndicatorSprite(
                    chaosRoar,
                    overlaySprites.melee.chaos_roar.active,
                    overlaySprites.utility.shadow
                )
                chaosRoar.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                setAbilityIndicatorSprite(
                    meteorStrike,
                    overlaySprites.melee.meteor_strike.active,
                    overlaySprites.utility.shadow
                )
                if ticksToSeconds(melee.meteorStrike.remainingDuration) == 0.0 then
                    melee.meteorStrike.active = 0
                end
                meteorStrike.text.font = LARGE_FONT
                meteorStrike.text.content = tostring(ticksToSeconds(melee.meteorStrike.remainingDuration))
                meteorStrike.text.colour = FONT_COLOUR
            elseif melee.meteorStrike.cooldown >= 1 then 
                setAbilityIndicatorSprite(
                    meteorStrike,
                    overlaySprites.melee.meteor_strike.inactive,
                    overlaySprites.utility.shadow
                )
                meteorStrike.text.font = LARGE_FONT
                meteorStrike.text.content = tostring(ticksToSeconds(melee.meteorStrike.cooldown))
                meteorStrike.text.colour = COOLDOWN_COLOUR
            else
                setAbilityIndicatorSprite(
                    meteorStrike,
                    overlaySprites.melee.meteor_strike.active,
                    overlaySprites.utility.shadow
                )
                meteorStrike.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
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
                berserk.text.font = SMALL_FONT or id.Font.NOTO_SANS_09PT_REGULAR_OUTLINE
                berserk.text.content = READY_TEXT
                berserk.text.colour = READY_COLOUR
        end
    else 
        berserk.layer.hidden = true
    end

    if POSITION_LOCKED or not Mouse.IsAvailable() or not Keyboard.IsAvailable() then
        isDraggingOverlay = false

        if draggedComponent then
            draggedComponent = nil
            dragOffsetX = 0
            dragOffsetY = 0
        end

        endMouseCapture()
    end

    -- Allow for repositioning the gauges without clunky X,Y sliders.
    -- TODO: Let users change the keybinds for this? Or change into a button
    -- that is clicked and begins repositioning until you press a keybind to stop it.
    -- But I prefer being able to unlock it and have it be freely movable.
    -- I'll have to see which users prefer.
    -- Allow repositioning the entire gauge overlay.
    if Mouse.IsAvailable()
        and Keyboard.IsAvailable()
        and not POSITION_LOCKED
        and not COMPONENT_EDITING
    then
        local shiftDown = Keyboard.IsShiftDown()
        local ctrlDown = Keyboard.IsControlDown()

        if shiftDown and ctrlDown then
            if not isDraggingOverlay then
                if beginMouseCapture() then
                    isDraggingOverlay = true
                end
            end

            if isDraggingOverlay then
                local mousePosition = getMousePosition()

                if mousePosition then
                    OFFSET_POSITION_X = math.floor(mouseToUI(mousePosition.x))
                    OFFSET_POSITION_Y = math.floor(mouseToUI(mousePosition.y))

                    updateOverlayPositions()
                end
            end
        elseif isDraggingOverlay then
            isDraggingOverlay = false

            endMouseCapture()

            settings.Set(
                "generalSettings.offsetPosition.x",
                OFFSET_POSITION_X
            )

            settings.Set(
                "generalSettings.offsetPosition.y",
                OFFSET_POSITION_Y
            )
        end
    end


-- Allow repositioning individual gauge components.
if Mouse.IsAvailable()
    and Keyboard.IsAvailable()
    and not POSITION_LOCKED
    and COMPONENT_EDITING
then
    local shiftDown = Keyboard.IsShiftDown()
    local ctrlDown = Keyboard.IsControlDown()
    local altDown = Keyboard.IsAltDown()

    if shiftDown and ctrlDown then
        if not mouseCaptureComponent then
            if not beginMouseCapture() then
                return
            end
        end

        -- Must be in the same coordinate system as component positions.
        local mousePosition = getMousePosition()

        if mousePosition then
            if draggedComponent == nil then
                draggedComponent = getHoveredComponent(mousePosition)

                if draggedComponent then
                    local position = draggedComponent.position

                    dragOffsetX =
                        mousePosition.x
                        - position.x
                        - OFFSET_POSITION_X

                    dragOffsetY =
                        mousePosition.y
                        - position.y
                        - OFFSET_POSITION_Y
                end
            end

            if draggedComponent then
                local position = draggedComponent.position

                local newX =
                    mousePosition.x
                    - OFFSET_POSITION_X
                    - dragOffsetX

                local newY =
                    mousePosition.y
                    - OFFSET_POSITION_Y
                    - dragOffsetY

                if altDown then
                    newX = snapToGrid(newX, 10)
                    newY = snapToGrid(newY, 10)
                end

                position.x = math.floor(mouseToUI(newX))
                position.y = math.floor(mouseToUI(newY))

                updateOverlayPositions()
            end
        end
    else
        if draggedComponent then
            local position = draggedComponent.position

            settings.Set(
                draggedComponent.style
                    .. "Settings.componentPositions."
                    .. draggedComponent.positionKey
                    .. ".x",
                position.x
            )

            settings.Set(
                draggedComponent.style
                    .. "Settings.componentPositions."
                    .. draggedComponent.positionKey
                    .. ".y",
                position.y
            )

            draggedComponent = nil
            dragOffsetX = 0
            dragOffsetY = 0
        end

        endMouseCapture()
    end
end

end

-- ServerLogic would result in a 1 tick delay - not sure this is too frequent to update everything
Event.Logic.Subscribe("updateOverlays", updateOverlays)

-- Return the user's ammo, unless the user has a quiver in which case
-- return the active ammo inside of the quiver instead.
local function returnEquippedAmmo()
    local worn = Inventory.Find(config.Inv.WORN)
    local wornObj = worn:GetSlot(14)

    if not wornObj or not wornObj.obj then
        return nil
    end

    local equipped = wornObj.obj
    local quiver = var.VarPlayer["QUIVER_ACTIVE_AMMO"]
    local quiverValue = quiver and quiver.value

    events.playerData.ranged.activeAmmo.name = equipped.name
    events.playerData.ranged.activeAmmo.configName = equipped.configName
    events.playerData.ranged.activeAmmo.id = equipped.id
    AMMO_ID = events.playerData.ranged.activeAmmo.id
    AMMO_NAME = events.playerData.ranged.activeAmmo.name
    AMMO_DISPLAY_NAME = ammoNames[events.playerData.ranged.activeAmmo.configName]

    if quiverValue then
        events.playerData.ranged.quiverAmmo.name = quiverValue.name
        events.playerData.ranged.quiverAmmo.configName = quiverValue.configName
        events.playerData.ranged.quiverAmmo.id = quiverValue.id
        if quiverValue.name ~= "" then
            AMMO_NAME = events.playerData.ranged.quiverAmmo.name
            AMMO_DISPLAY_NAME = ammoNames[events.playerData.ranged.quiverAmmo.configName]
        end
        if quiverValue.id ~= -1 then
            AMMO_ID = events.playerData.ranged.quiverAmmo.id
        end
    end

    return nil
end

-- Ammo can only be updated once every game tick, so only need to
-- check once every game tick.
Event.ServerLogic.Subscribe("updateAmmo", returnEquippedAmmo)

-- UI update subscriptions to changes in the user's settings
-- Update the global variables and then on the next re-render
-- aka the next `Logic.logicTick` everything is updated
settings.Subscribe(
    "generalSettings.positionLocked",
    function(value)
        POSITION_LOCKED = value
    end
)

settings.Subscribe(
    "generalSettings.retinaMonitor",
    function(value)
        RETINA_MONITOR =  tonumber(value) or 1
        updateOverlayPositions()
    end
)

settings.Subscribe(
    "generalSettings.scale",
    function(value)
        UI_SCALE = tonumber(value) or 1
        updateOverlayPositions()
    end
)

settings.Subscribe(
    "generalSettings.componentEditing",
    function(value)
        COMPONENT_EDITING = value
    end
)

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
        largeFontSetting = value
    end
)

settings.Subscribe(
    "fontSizes.mediumFont",
    function(value)
        mediumFontSetting = value
    end
)

settings.Subscribe(
    "fontSizes.smallFont",
    function(value)
        smallFontSetting = value
    end
)

settings.Subscribe(
    "generalSettings.readyText",
    function(value)
        READY_TEXT = value
    end
)

settings.Subscribe(
    "generalSettings.spriteReadyText",
    function(value)
        SPRITE_READY_TEXT = value
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
        FONT_COLOUR = colourToVector4(colour, "0xFFFFFFFF")

        for _, text in ipairs(fontTexts) do
            text.colour = FONT_COLOUR
        end
    end
)

settings.Subscribe(
    "fontColours.expiringText",
    function(colour)
        EXPIRING_COLOUR = colourToVector4(colour, "0xF30B0BFF")
    end
)

settings.Subscribe(
    "fontColours.cooldownText",
    function(colour)
        COOLDOWN_COLOUR = colourToVector4(colour, "0xFFFFFFFF")
    end
)

settings.Subscribe(
    "fontColours.readyText",
    function(colour)
        READY_COLOUR = colourToVector4(colour, "0xFFFFFFFF")
    end
)

settings.Subscribe(
    "uiColours.backdropColour",
    function(colour)
        BACKDROP_COLOUR = colourToVector4(colour, "0xFFFFFF00")

        for _, backdrop in ipairs(backdrops) do
            backdrop.colour = BACKDROP_COLOUR
        end
    end
)

settings.Subscribe(
    "uiColours.shadowColour",
    function(colour)
        ABILITY_SHADOW_COLOUR = colourToVector4(colour, "0x111111DD")

        for _, shadow in ipairs(abilityShadows) do
            shadow.colour = ABILITY_SHADOW_COLOUR
        end
    end
)

settings.Subscribe(
    "uiColours.barColours.bloodTitheBar",
    function(colour)
        local vector4Color = colourToVector4(colour, "0xF30B0BFF")
        BLOOD_TITHE_COLOUR = vector4Color
        magicUpkeepBars.bloodTithe.sprite.colour = vector4Color
    end
)

settings.Subscribe(
    "uiColours.barColours.inciteFearBar",
    function(colour)

        local vector4Color = colourToVector4(colour, "0x16D6E5FF")
        INCITE_FEAR_COLOUR = vector4Color

        local bar = magicUpkeepBars.inciteFear
        if bar and bar.sprite then
            bar.sprite.colour = vector4Color
        end
    end
)

settings.Subscribe(
    "uiColours.barColours.essenceCorruptionBar",
    function(colour)
        local vector4Color = colourToVector4(colour, "0x16A127FF")
        ESSENCE_CORRUPTION_COLOUR = vector4Color
        magicUpkeepBars.essenceCorruption.sprite.colour = vector4Color
    end
)

settings.Subscribe(
    "uiColours.runeColours.active",
    function(colour)
        ACTIVE_RUNE_COLOUR = colourToVector4(colour, "0x70FF00FF")       
    end
)

settings.Subscribe(
    "uiColours.runeColours.activeShadow",
    function(colour)
        ACTIVE_RUNE_SHADOW_COLOUR = colourToVector4(colour, "0x100101FF")
    end
)

settings.Subscribe(
    "uiColours.runeColours.inactive",
    function(colour)
        INACTIVE_RUNE_COLOUR = colourToVector4(colour, "0x050012FF")
    end
)

settings.Subscribe(
    "uiColours.runeColours.inactiveShadow",
    function(colour)
        INACTIVE_RUNE_SHADOW_COLOUR = colourToVector4(colour, "0xC1BDAC89")
    end
)

settings.Subscribe(
    "rangedSettings.selectedGuthixianRune",
    function(value)
        SELECTED_GUTHIXIAN_RUNE = value
    end
)

settings.Subscribe(
    "rangedSettings.componentVisibility.show-guthixian-runes",
    function(value)
        SHOW_RUNES = value
        updateBOLGLetters(
            events.playerData.ranged.perfectEquilibrium.stacks,
            events.playerData.ranged.perfectEquilibrium.active == 1
        )
    end
)
  return {
    Destroy = function()
      if settingsView then
        settingsView:Destroy()
        settingsView = nil
      end
      if contentView then
        contentView:Destroy()
        contentView = nil
      end
    end,
  }
end

M.CreateUI = CreateUI

return M
