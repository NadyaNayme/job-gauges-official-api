local settings = require("resources/database/settings")

local M = {}

function M.Create(page, options)
    page:AddTitle("Magic Gauge Components")

    local magicComponentSettings = settings.Get("magicSettings.componentVisibility")

    page:AddCheckboxButton({
        {
            text = "Show Soulfire (Roar of Awakening Special Attack)",
            value = "show-soulfire",
            selected = magicComponentSettings["show-soulfire"]
        },
        {
            text = "Show Instability (Fractured Staff of Armadyl Special Attack)",
            value = "show-instability",
            selected = magicComponentSettings["show-instability"]
        },
        {
            text = "Show Active Spell",
            value = "show-active-spell",
            selected = magicComponentSettings["show-active-spell"]
        },
        {
            text = "Show Runic Charge",
            value = "show-runic-charge",
            selected = magicComponentSettings["show-runic-charge"]
        },
        {
            text = "Show Tsunami",
            value = "show-tsunami",
            selected = magicComponentSettings["show-tsunami"]
        },
        {
            text = "Show Sunshine",
            value = "show-sunshine",
            selected = magicComponentSettings["show-sunshine"]
        },
        -- {
        --     text = "Show Blood Tithe",
        --     value = "show-blood-tithe",
        --     selected = magicComponentSettings["show-blood-tithe"]
        -- },
        -- {
        --     text = "Show Incite Fear",
        --     value = "show-incite-fear",
        --     selected = magicComponentSettings["show-incite-fear"]
        -- },
        -- {
        --     text = "Show Essence Corruption",
        --     value = "show-essence-corruption",
        --     selected = magicComponentSettings["show-essence-corruption"]
        -- },
    }, {
        onChange = function(_, _, changedValue, selected)
            settings.Set(
                "magicSettings.componentVisibility." .. changedValue,
                selected
            )
        end,
    })

    page:AddTitle({
        text = "Spell Tracking Colours",
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
        windowTitle = "Expiring Flash",
        tooltip = "Choose the colour of Expiring text",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "fontColours.expiringText",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = "Expiring Flash - This color alternates when under 10s to keep stacks",
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
        windowTitle = "Blood tithe Colour",
        tooltip = "Choose the colour for Blood tithe",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.barColours.bloodTitheBar",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        inline = true,
        text = "Blood Tithe (Exsanguinate)",
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
        windowTitle = "Glacial Embrace Colour",
        tooltip = "Choose the bar colour for Glacial Embrace",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.barColours.inciteFearBar",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        inline = true,
        text = "Glacial Embrace (Incite Fear)",
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
        windowTitle = "Essence Corruption Bar Colour",
        tooltip = "Choose the colour for Essence Corruption",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.barColours.essenceCorruptionBar",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        inline = true,
        text = "Essence Corruption (Roar of Awakening passive)",
    })

end

return M