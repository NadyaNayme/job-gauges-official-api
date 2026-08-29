local settings = require("resources/database/settings")
local L = require("resources/data/localize")

local M = {}

function M.Create(page, options)
    page:AddTitle(L.Get("magic.gaugeComponentsTitle"))

    local magicComponentSettings = settings.Get("magicSettings.componentVisibility")

    page:AddCheckboxButton({
        {
            text = L.Get("magic.visibilityOptions.soulfire"),
            value = "show-soulfire",
            selected = magicComponentSettings["show-soulfire"]
        },
        {
            text = L.Get("magic.visibilityOptions.instability"),
            value = "show-instability",
            selected = magicComponentSettings["show-instability"]
        },
        {
            text = L.Get("magic.visibilityOptions.activeSpell"),
            value = "show-active-spell",
            selected = magicComponentSettings["show-active-spell"]
        },
        {
            text = L.Get("magic.visibilityOptions.runicCharge"),
            value = "show-runic-charge",
            selected = magicComponentSettings["show-runic-charge"]
        },
        {
            text = L.Get("magic.visibilityOptions.tsunami"),
            value = "show-tsunami",
            selected = magicComponentSettings["show-tsunami"]
        },
        {
            text = L.Get("magic.visibilityOptions.sunshine"),
            value = "show-sunshine",
            selected = magicComponentSettings["show-sunshine"]
        },
    }, {
        onChange = function(_, _, changedValue, selected)
            settings.Set(
                "magicSettings.componentVisibility." .. changedValue,
                selected
            )
        end,
    })

    page:AddTitle({
        text = L.Get("magic.spellTrackingColoursTitle"),
    })
    page:AddText({
        text = "",
        inline = false,
    })

    page:AddColourPicker({
        value = settings.Get("fontColours.expiringText"),
        alphaSlider = true,
        inline = true,
        buttonSize = 26,
        windowTitle = L.Get("magic.expiringFlash.windowTitle"),
        tooltip = L.Get("magic.expiringFlash.tooltip"),
        acceptText = L.Get("magic.expiringFlash.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "fontColours.expiringText",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = L.Get("magic.expiringFlash.label"),
        inline = true
    })

    page:AddText({
        text = "",
        inline = false,
    })

    page:AddColourPicker({
        value = settings.Get("uiColours.barColours.bloodTitheBar"),
        inline = true,
        alphaSlider = true,
        buttonSize = 28,
        windowTitle = L.Get("magic.bloodTithe.windowTitle"),
        tooltip = L.Get("magic.bloodTithe.tooltip"),
        acceptText = L.Get("magic.bloodTithe.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "uiColours.barColours.bloodTitheBar",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        inline = true,
        text = L.Get("magic.bloodTithe.label"),
    })    
    page:AddText({
        text = "",
        inline = false,
    })
    page:AddColourPicker({
        value = settings.Get("uiColours.barColours.inciteFearBar"),
        inline = true,
        alphaSlider = true,
        buttonSize = 28,
        windowTitle = L.Get("magic.glacialEmbrace.windowTitle"),
        tooltip = L.Get("magic.glacialEmbrace.tooltip"),
        acceptText = L.Get("magic.glacialEmbrace.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "uiColours.barColours.inciteFearBar",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        inline = true,
        text = L.Get("magic.glacialEmbrace.label"),
    })    
    page:AddText({
        text = "",
        inline = false,
    })
    page:AddColourPicker({
        value = settings.Get("uiColours.barColours.essenceCorruptionBar"),
        inline = true,
        alphaSlider = true,
        buttonSize = 28,
        windowTitle = L.Get("magic.essenceCorruption.windowTitle"),
        tooltip = L.Get("magic.essenceCorruption.tooltip"),
        acceptText = L.Get("magic.essenceCorruption.acceptButton"),

        onChange = function(_, colour)
            settings.Set(
                "uiColours.barColours.essenceCorruptionBar",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        inline = true,
        text = L.Get("magic.essenceCorruption.label"),
    })

end

return M