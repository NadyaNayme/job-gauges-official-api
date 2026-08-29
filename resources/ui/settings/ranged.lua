local settings = require("resources/database/settings")

local M = {}

function M.Create(page, options)
    page:AddTitle("Ranged Gauge Components")

    local rangedComponentSettings = settings.Get("rangedSettings.componentVisibility")

    page:AddCheckboxButton({
        {
            text = "Show Crystal Rain (Seren Godbow Special Attack)",
            value = "show-crystal-rain",
            selected = rangedComponentSettings["show-crystal-rain"]
        },
        {
            text = "Show Split Soul (Eldritch Crossbow Special Attack)",
            value = "show-split-soul",
            selected = rangedComponentSettings["show-split-soul"]
        },
        {
            text = "Show Equipped Ammo",
            value = "show-equipped-ammo",
            selected = rangedComponentSettings["show-equipped-ammo"]
        },
        {
            text = "Show Searing Winds (Galeshot)",
            value = "show-searing-winds",
            selected = rangedComponentSettings["show-searing-winds"]
        },
        {
            text = "Show Shadow Imbued (Imbue: Shadows)",
            value = "show-shadow-imbued",
            selected = rangedComponentSettings["show-shadow-imbued"]
        },
        {
            text = "Show Death's Swiftness",
            value = "show-deaths-swiftness",
            selected = rangedComponentSettings["show-deaths-swiftness"]
        },
        {
            text = "Show Perfect Equilibrium",
            value = "show-perfect-equilibrium",
            selected = rangedComponentSettings["show-perfect-equilibrium"]
        },


    }, {
    onChange = function(_, _, changedValue, selected)
        settings.Set(
            "rangedSettings.componentVisibility." .. changedValue,
            selected
        )
    end,
    })

    page:AddText("Guthixian Rune for Perfect Equilibrium Stacks")

    page:AddComboBox({
    entries = {
        { label = "A", id = 1 },
        { label = "B", id = 2 },
        { label = "C", id = 3 },
        { label = "D", id = 4 },
        { label = "E", id = 5 },
        { label = "F", id = 6 },
        { label = "G", id = 7 },
        { label = "H", id = 8 },
        { label = "I", id = 9 },
        { label = "J", id = 10 },
        { label = "K", id = 11 },
        { label = "L", id = 12 },
        { label = "M", id = 13 },
        { label = "N", id = 14 },
        { label = "O", id = 15 },
        { label = "P", id = 16 },
        { label = "Q", id = 17 },
        { label = "R", id = 18 },
        { label = "S", id = 19 },
        { label = "T", id = 20 },
        { label = "U", id = 21 },
        { label = "V", id = 22 },
        { label = "W", id = 23 },
        { label = "X", id = 24 },
        { label = "Y", id = 25 },
        { label = "Z", id = 26 },
        { label = "???", id = 27 },
    },
    selectedID = settings.Get("rangedSettings.selectedGuthixianRuneId") or 27,
    onChange = function(_, id, label)

        if id < 27 then
        settings.Set(
            "rangedSettings.selectedGuthixianRune",
            label
        )
        else 
        settings.Set(
            "rangedSettings.selectedGuthixianRune",
            "lore"
        )
        end
        settings.Set(
            "rangedSettings.selectedGuthixianRuneId",
            id
        )    
    end,
})

    page:AddTitle({
        text = "Guthixian Runes Colours",
    })
    page:AddText({
        text = "",
        inline = false,
    })
    page:AddColourPicker({
        value = settings.Get("uiColours.runeColours.active"),
        inline = true,
        alphaSlider = true,
        buttonSize = 28,
        windowTitle = "Guthixian Runes Colour",
        tooltip = "Choose the active colour",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.runeColours.active",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddColourPicker({
        value = settings.Get("uiColours.runeColours.activeShadow"),
        inline = true,
        alphaSlider = true,
        buttonSize = 28,
        windowTitle = "Guthixian Runes Colour",
        tooltip = "Choose the active shadow colour",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.runeColours.activeShadow",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        inline = true,
        text = "Active Color & Active Shadow",
    })    
    page:AddText({
        text = "",
        inline = false,
    })
    page:AddColourPicker({
        value = settings.Get("uiColours.runeColours.inactive"),
        inline = true,
        alphaSlider = true,
        buttonSize = 28,
        windowTitle = "Guthixian Runes Colour",
        tooltip = "Choose the inactive colour",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.runeColours.inactive",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddColourPicker({
        value = settings.Get("uiColours.runeColours.inactiveShadow"),
        inline = true,
        alphaSlider = true,
        buttonSize = 28,
        windowTitle = "Guthixian Runes Colour",
        tooltip = "Choose the inactive shadow colour",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.runeColours.inactiveShadow",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        inline = true,
        text = "Inactive Color & Inactive Shadow",
    })
    
end

return M