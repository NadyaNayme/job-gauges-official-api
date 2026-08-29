local settings = require("resources/database/settings")
local events = require("resources/events/events")

local M = {}

function M.Create(page, options)

    page:AddTitle("Job Gauge Settings")

    page:AddText("Dynamically swap active style gauge using...")

    options.dynamicGaugeSetting = page:AddRadioButton({
        { text = "Abilities Used", value = "dynamic" },
        { text = "Mainhand Weapon", value = "mainhand" },
        { text = "I'll set it myself", value = "static" },
    }, {
        selectedValue = settings.Get("generalSettings.automaticSwapping"),

        onChange = function(_, value)
            settings.Set("generalSettings.automaticSwapping", value)
        end,
    })

    page:AddText("If you chose to set it yourself, set your gauge using the below buttons.")

    page:AddDivider({
        marginTop = 12,
        marginBottom = 12,
    })
    page:AddSimpleButton("Necromancy", function(self, _)
        events.playerData.combatStyle = 'necromancy'
        settings.Set('playerState.combatStyle', 'necromancy')
    end, { inline = true})
    page:AddSimpleButton("Magic", function(self, _)
        events.playerData.combatStyle = 'magic'
        settings.Set('playerState.combatStyle', 'magic')
    end, { inline = true})
    page:AddSimpleButton("Ranged", function(self, _)
        events.playerData.combatStyle = 'ranged'
        settings.Set('playerState.combatStyle', 'ranged')
    end, { inline = true})
    page:AddSimpleButton("Melee", function(self, _)
        events.playerData.combatStyle = 'melee'
        settings.Set('playerState.combatStyle', 'melee')
    end, { inline = true})

    page:AddText("Hide the combat style gauge while out of combat")
    page:AddRadioButton({
        { text = "Yes", value = "combat-visible" },
        { text = "No", value = "always-visible" },
        
    }, {
        selectedValue = settings.Get("generalSettings.hideOutOfCombat"),

        onChange = function(group, value)
            settings.Set("generalSettings.hideOutOfCombat", value)
        end,
    })

    page:AddText("Show precise time remaining or round to the nearest second?")
    page:AddRadioButton({
        { text = "Precise Ticks", value = "precise-ticks" },
        { text = "Nearest Second", value = "nearest-second" },
    }, {
        selectedValue = settings.Get("generalSettings.displayTimeAs"),

        onChange = function(group, value)
            settings.Set("generalSettings.displayTimeAs", value)
        end,
    })

    page:AddText("Change 'Ready' text (set blank to hide)")
    page:AddTextField({
        text = settings.Get("generalSettings.readyText") or "Ready",
        placeholder = "Ready text",
        maxLength = 5,
        onSubmit = function(_, text)
            settings.Set("generalSettings.readyText", text)
        end
    })

    page:AddDivider({
        marginTop = 5,
        marginBottom = 5
    })

    page:AddTitle("Colour Settings")
    page:AddText({
        text = "Duration Text Colour",
    })
    page:AddColourPicker({
        value = settings.Get("fontColours.durationText"),
        alphaSlider = true,
        buttonSize = 26,
        windowTitle = "Duration Colour",
        tooltip = "Choose the colour of duration and cooldown text",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "fontColours.durationText",
                string.format("0x%08X", colour)
            )
            options.setFontColour(colour)
        end,
    })


    page:AddText({
        text = "'On Cooldown' Text Colour",
    })
    page:AddColourPicker({
        value = settings.Get("fontColours.cooldownText"),
        alphaSlider = true,
        buttonSize = 26,
        windowTitle = "Cooldown Colour",
        tooltip = "Choose the colour of the remaining cooldown duration",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "fontColours.cooldownText",
                string.format("0x%08X", colour)
            )
        end,
    })

    page:AddText("'Ready' Text Colour")
    page:AddColourPicker({
        value = settings.Get("fontColours.readyText"),
        alphaSlider = true,
        buttonSize = 26,
        windowTitle = "Ready Colour",
        tooltip = "Choose the colour of 'Ready' text",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "fontColours.readyText",
                string.format("0x%08X", colour)
            )
        end,
    })

    page:AddText("Ability Border Colour")
    page:AddColourPicker({
        value = settings.Get("uiColours.shadowColour"),
        alphaSlider = true,
        buttonSize = 26,
        windowTitle = "Ability Shadow Colour",
        tooltip = "Choose the colour of the shadow behind ability icons",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.shadowColour",
                string.format("0x%08X", colour)
            )
            options.setAbilityShadowColour(colour)
        end,
    })

    page:AddText("Tip! Hold Shift+Alt to reposition your gauges.")

end

return M