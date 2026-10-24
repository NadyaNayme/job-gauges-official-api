local settings = require("resources/database/settings")
local events = require("resources/events/events")
local L = require("resources/data/localize")

local M = {}

-- This and the next 4 settings files handles all the PrettyUI settings windows
-- with lazy localization to fully support all officially supported languages

function M.Create(page, options)

    page:AddTitle(L.Get("general.gaugeSettingsTitle"))

    page:AddText(L.Get("general.dynamicSwappingLabel"))

    options.dynamicGaugeSetting = page:AddRadioButton({
        { text = L.Get("general.dynamicSwappingOptions.ultimateAbilities"), value = "dynamic" },
        { text = L.Get("general.dynamicSwappingOptions.equippedMainhandWeapon"), value = "mainhand" },
        { text = L.Get("general.dynamicSwappingOptions.setItMyself"), value = "static" },
    }, {
        selectedValue = settings.Get("generalSettings.automaticSwapping"),

        onChange = function(_, value)
            settings.Set("generalSettings.automaticSwapping", value)
        end,
    })

    page:AddText("")
    page:AddSimpleButton(L.Get("general.combatStyleNames.necromancy"), function(self, _)
        events.playerData.combatStyle = 'necromancy'
        settings.Set("generalSettings.automaticSwapping", "static")
        options.dynamicGaugeSetting:SetSelectedValue("static")
        settings.Set('playerState.combatStyle', 'necromancy')
    end, { inline = true})
    page:AddSimpleButton(L.Get("general.combatStyleNames.magic"), function(self, _)
        events.playerData.combatStyle = 'magic'
        settings.Set("generalSettings.automaticSwapping", "static")
        options.dynamicGaugeSetting:SetSelectedValue("static")
        settings.Set('playerState.combatStyle', 'magic')
    end, { inline = true})
    page:AddSimpleButton(L.Get("general.combatStyleNames.melee"), function(self, _)
        events.playerData.combatStyle = 'melee'
        settings.Set("generalSettings.automaticSwapping", "static")
        options.dynamicGaugeSetting:SetSelectedValue("static")
        settings.Set('playerState.combatStyle', 'melee')
    end, { inline = true})
    page:AddSimpleButton(L.Get("general.combatStyleNames.ranged"), function(self, _)
        events.playerData.combatStyle = 'ranged'
        settings.Set("generalSettings.automaticSwapping", "static")
        options.dynamicGaugeSetting:SetSelectedValue("static")
        settings.Set('playerState.combatStyle', 'ranged')
    end, { inline = true})
    page:AddSimpleButton(L.Get("general.combatStyleNames.all"), function(self, _)
        events.playerData.combatStyle = 'all'
        settings.Set("generalSettings.automaticSwapping", "static")
        options.dynamicGaugeSetting:SetSelectedValue("static")
        settings.Set('playerState.combatStyle', 'all')
    end, { inline = true})

    page:AddTitle(L.Get("general.displaySettingsTitle"))

    page:AddText(L.Get("general.hideInCombatLabel"))
    page:AddText("")
    page:AddRadioButton({
        { text = L.Get("general.hideInCombatOptions.yes"), value = "combat-visible" },
        { text = L.Get("general.hideInCombatOptions.no"), value = "always-visible" },   
    }, {
        selectedValue = settings.Get("generalSettings.hideOutOfCombat"),
        inline = true,

        onChange = function(group, value)
            settings.Set("generalSettings.hideOutOfCombat", value)
        end,
    })

    page:AddText(L.Get("general.displayTimeAsLabel"))
    page:AddText("")
    page:AddRadioButton({
        { text = L.Get("general.displayTimeAsOptions.preciseTime"), value = "precise-time" },
        { text = L.Get("general.displayTimeAsOptions.nearestSecond"), value = "nearest-second" },
        { text = L.Get("general.displayTimeAsOptions.preciseTicks"), value = "precise-ticks" },
    }, {
        selectedValue = settings.Get("generalSettings.displayTimeAs"),
        inline = true,

        onChange = function(group, value)
            settings.Set("generalSettings.displayTimeAs", value)
        end,
    })

    page:AddText(L.Get("general.readyTextLabel"))
    page:AddTextField({
        text = settings.Get("generalSettings.readyText") or "Ready",
        placeholder = L.Get("general.readyTextPlaceholder"),
        maxLength = 5,
        onChange = function(_, _, text)
            settings.Set("generalSettings.readyText", text)
        end
    })

    page:AddText({
        text = L.Get("general.fontSizeLabels.small"),
    })
    
    options.retinaMonitorSetting = page:AddRadioButton({
        { text = L.Get("9pt Outline"), value = "9pt Outline" },
        { text = L.Get("9pt Regular"), value = "9pt Regular" },
        { text = L.Get("11pt Outline"), value = "11pt Outline" },
        { text = L.Get("11pt Shadow"), value = "11pt Shadow" },
        { text = L.Get("13pt Outline"), value = "13pt Outline" },
        { text = L.Get("21pt Outline"), value = "21pt Outline" },
        { text = L.Get("21pt Shadow"), value = "21pt Shadow" },
    }, {
        selectedValue = settings.Get("fontSizes.smallFont"),

        onChange = function(_, value)
            settings.Set("fontSizes.smallFont", value)
        end,
    })

    page:AddText({
        text = L.Get("general.fontSizeLabels.medium"),
    })

    options.retinaMonitorSetting = page:AddRadioButton({
        { text = L.Get("9pt Outline"), value = "9pt Outline" },
        { text = L.Get("9pt Regular"), value = "9pt Regular" },
        { text = L.Get("11pt Outline"), value = "11pt Outline" },
        { text = L.Get("11pt Shadow"), value = "11pt Shadow" },
        { text = L.Get("13pt Outline"), value = "13pt Outline" },
        { text = L.Get("21pt Outline"), value = "21pt Outline" },
        { text = L.Get("21pt Shadow"), value = "21pt Shadow" },
    }, {
        selectedValue = settings.Get("fontSizes.mediumFont"),

        onChange = function(_, value)
            settings.Set("fontSizes.mediumFont", value)
        end,
    })

    page:AddText({
        text = L.Get("general.fontSizeLabels.large"),
    })

    options.retinaMonitorSetting = page:AddRadioButton({
        { text = L.Get("9pt Outline"), value = "9pt Outline" },
        { text = L.Get("9pt Regular"), value = "9pt Regular" },
        { text = L.Get("11pt Outline"), value = "11pt Outline" },
        { text = L.Get("11pt Shadow"), value = "11pt Shadow" },
        { text = L.Get("13pt Outline"), value = "13pt Outline" },
        { text = L.Get("21pt Outline"), value = "21pt Outline" },
        { text = L.Get("21pt Shadow"), value = "21pt Shadow" },
    }, {
        selectedValue = settings.Get("fontSizes.largeFont"),

        onChange = function(_, value)
            settings.Set("fontSizes.largeFont", value)
        end,
    })


    page:AddTitle(L.Get("general.colourSettingsTitle"))
    page:AddText("")
    page:AddColourPicker({
        value = settings.Get("fontColours.durationText"),
        alphaSlider = true,
        inline = true,
        buttonSize = 26,
        windowTitle = L.Get("general.durationText.windowtitle"),
        tooltip = L.Get("general.durationText.tooltip"),
        acceptText = L.Get("general.durationText.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "fontColours.durationText",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = L.Get("general.durationText.label"),
        inline = true,
    })

    page:AddText({
        text = "",
        inline = false,
    })

    page:AddColourPicker({
        value = settings.Get("fontColours.cooldownText"),
        alphaSlider = true,
        inline = true,
        buttonSize = 26,
        windowTitle = L.Get("general.cooldownText.windowtitle"),
        tooltip = L.Get("general.cooldownText.tooltip"),
        acceptText = L.Get("general.cooldownText.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "fontColours.cooldownText",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = L.Get("general.cooldownText.label"),
        inline = true,
    })

    page:AddText({
        text = "",
        inline = false,
    })

    page:AddColourPicker({
        value = settings.Get("fontColours.readyText"),
        alphaSlider = true,
        inline = true,
        buttonSize = 26,
        windowTitle = L.Get("general.readyText.windowtitle"),
        tooltip = L.Get("general.readyText.tooltip"),
        acceptText = L.Get("general.readyText.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "fontColours.readyText",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = L.Get("general.readyText.label"),
        inline = true
    })

    page:AddText({
        text = "",
        inline = false,
    })

    page:AddColourPicker({
        value = settings.Get("uiColours.backdropColour"),
        alphaSlider = true,
        inline = true,
        buttonSize = 26,
        windowTitle = L.Get("general.abilityBorder.windowtitle"),
        tooltip = L.Get("general.abilityBorder.tooltip"),
        acceptText = L.Get("general.abilityBorder.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "uiColours.backdropColour",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = L.Get("general.backdropColour.label"),
        inline = true
    })

    page:AddText({
        text = "",
        inline = false,
    })
    
    page:AddColourPicker({
        value = settings.Get("uiColours.shadowColour"),
        alphaSlider = true,
        inline = true,
        buttonSize = 26,
        windowTitle = L.Get("general.abilityBorder.windowtitle"),
        tooltip = L.Get("general.abilityBorder.tooltip"),
        acceptText = L.Get("general.abilityBorder.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "uiColours.shadowColour",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = L.Get("general.abilityBorder.label"),
        inline = true
    })

    page:AddTitle(L.Get("general.positionSettingsTitle"))

    page:AddText({
        text = L.Get("general.retinaMonitor.label"),
    })

    page:AddText({
        text = "",
        inline = false,
    })

    options.retinaMonitorSetting = page:AddRadioButton({
        { text = L.Get("general.retinaMonitor.oneX"), value = "1" },
        { text = L.Get("general.retinaMonitor.twoX"), value = "2" },
        { text = L.Get("general.retinaMonitor.fourX"), value = "4" },
    }, {
        selectedValue = settings.Get("generalSettings.retinaMonitor"),
        inline = true,

        onChange = function(_, value)
            settings.Set("generalSettings.retinaMonitor", value)
        end,
    })

    page:AddText({
        text = L.Get("general.scaleLabel"),
    })

    page:AddSlider({
        min = 1.0,
        max = 4.0,
        value = settings.Get("generalSettings.scale") or 1.0,
        step = 0.5,
        onChange = function(_, value)
            settings.Set("generalSettings.scale", value)
        end,
    })

    page:AddCheckboxButton({
        {
            text = L.Get("general.lockPositionLabel"),
            value = true,
            selected = settings.Get("generalSettings.positionLocked")
        },
    }, {
        onChange = function(_, _, _, selected)
            settings.Set(
                "generalSettings.positionLocked",
                selected
            )
        end,
    })

    page:AddCheckboxButton({
        {
            text = L.Get("general.componentEditingLabel"),
            value = true,
            selected = settings.Get("generalSettings.componentEditing")
        },
    }, {
        onChange = function(_, _, _, selected)
            settings.Set(
                "generalSettings.componentEditing",
                selected
            )
        end,
    })

    page:AddText(L.Get("general.lockPositionHelp"))

    -- TODO: Allow users to reset their settings
    page:AddTitle(L.Get("general.restoreDefaultSettings"))
    page:AddText(L.Get("general.restoreDefaultSettingsHelp"))
    page:AddSimpleButton(id.Sprite.CHAT_V2_FILTERS_ON_8, function()
        settings.Reset()
        -- TODO: Add a confirmation to this when PrettyUI is updated
        -- Confirm.new({
        --     title = L.Get("general.confirmTitle"),
        --     body = L.Get("general.confirmRestoreDefaultSettings"),
        --     cancelLabel = L.Get("general.confirmCancelLabel"),
        --     confirmLabel = L.Get("general.confirmConfirmLabel")
        -- }, {
        --     onConfirm = function()
        --         settings.Reset()
        --     end,
        -- })
    end)

end

return M