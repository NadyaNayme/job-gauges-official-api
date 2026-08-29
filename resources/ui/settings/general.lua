local settings = require("resources/database/settings")
local events = require("resources/events/events")

local M = {}

function M.Create(page, options)

    page:AddTitle("Job Gauge Settings")

    page:AddText("Dynamically swap active style gauge using...")

    options.dynamicGaugeSetting = page:AddRadioButton({
        { text = "Ultimate Abilities Used", value = "dynamic" },
        { text = "Equipped Mainhand Weapon", value = "mainhand" },
        { text = "I'll set it myself", value = "static" },
    }, {
        selectedValue = settings.Get("generalSettings.automaticSwapping"),

        onChange = function(_, value)
            settings.Set("generalSettings.automaticSwapping", value)
        end,
    })

    page:AddText("If you chose 'I'll set it myself', set your active gauge using the below buttons.")

    page:AddText("")
    page:AddSimpleButton("Necromancy", function(self, _)
        events.playerData.combatStyle = 'necromancy'
        settings.Set('playerState.combatStyle', 'necromancy')
    end, { inline = true})
    page:AddSimpleButton("Magic", function(self, _)
        events.playerData.combatStyle = 'magic'
        settings.Set('playerState.combatStyle', 'magic')
    end, { inline = true})
    page:AddSimpleButton("Melee", function(self, _)
        events.playerData.combatStyle = 'melee'
        settings.Set('playerState.combatStyle', 'melee')
    end, { inline = true})
    page:AddSimpleButton("Ranged", function(self, _)
        events.playerData.combatStyle = 'ranged'
        settings.Set('playerState.combatStyle', 'ranged')
    end, { inline = true})

    page:AddTitle("Display Settings")

    page:AddText("Hide the combat style gauge while out of combat or banking")
    page:AddRadioButton({
        { text = "Yes", value = "combat-visible" },
        { text = "No", value = "always-visible" },
        
    }, {
        selectedValue = settings.Get("generalSettings.hideOutOfCombat"),

        onChange = function(group, value)
            settings.Set("generalSettings.hideOutOfCombat", value)
        end,
    })

    page:AddText("Show precise time or round up to the nearest second?")
    page:AddRadioButton({
        { text = "Precise Time (16.8)", value = "precise-ticks" },
        { text = "Nearest Second (17)", value = "nearest-second" },
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

    page:AddText("")

    page:AddTitle("Colour Settings")
    page:AddText({
        text = "",
        inline = false,
    })
    page:AddColourPicker({
        value = settings.Get("fontColours.durationText"),
        alphaSlider = true,
        inline = true,
        buttonSize = 26,
        windowTitle = "Duration Colour",
        tooltip = "Choose the colour of duration and cooldown text",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "fontColours.durationText",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = "Duration Remaining / Stacks Text",
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
    page:AddText({
        text = "Cooldown Remaining Text",
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
    page:AddText({
        text = "'Ready' Text",
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
        windowTitle = "Ability Shadow Colour",
        tooltip = "Choose the colour of the shadow behind ability icons",
        acceptText = "Set Colour",

        onChange = function(_, colour)
            settings.Set(
                "uiColours.shadowColour",
                string.format("0x%08X", colour)
            )
        end,
    })
    page:AddText({
        text = "Ability Border Colour",
        inline = true
    })

    page:AddText("Tip! Hold Shift+Ctrl to reposition your gauges.")

end

return M