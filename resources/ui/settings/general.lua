local settings = require("resources/database/settings")
local events = require("resources/events/events")

local M = {}

function M.Create(page, options)

    page:AddTitle("Job Gauge Settings")
    page:AddColourPicker({
        value = settings.Get("fontColour"),
        alphaSlider = true,
        buttonSize = 48,
        windowTitle = "Font Colour",
        tooltip = "Choose the colour of duration and cooldown text",
        acceptText = "Set Color",

        onChange = function(_, colour)
            settings.Set(
                "fontColour",
                string.format("0x%08X", colour)
            )

            options.setFontColour(colour)
        end,
    })

    page:AddText("Dynamically swap active style gauge using...")

    options.dynamicGaugeSetting = page:AddRadioButton({
        { text = "Abilities Used", value = "dynamic" },
        { text = "Mainhand Weapon", value = "mainhand" },
        { text = "I'll set it myself", value = "static" },
    }, {
        selectedValue = settings.Get("automaticallySwapGauge"),

        onChange = function(_, value)
            settings.Set("automaticallySwapGauge", value)
        end,
    })

    page:AddText("If you chose to set it yourself, set your gauge using the below buttons.")

    page:AddDivider({
        marginTop = 12,
        marginBottom = 12,
    })
    page:AddSimpleButton("Necromancy", function(self, _)
        events.playerData.combatStyle = 'necromancy'
        settings.Set('lastKnownCombatStyle', 'necromancy')
    end, { inline = true})
    page:AddSimpleButton("Magic", function(self, _)
        events.playerData.combatStyle = 'magic'
        settings.Set('lastKnownCombatStyle', 'magic')
    end, { inline = true})
    page:AddSimpleButton("Ranged", function(self, _)
        events.playerData.combatStyle = 'ranged'
        settings.Set('lastKnownCombatStyle', 'ranged')
    end, { inline = true})
    page:AddSimpleButton("Melee", function(self, _)
        events.playerData.combatStyle = 'melee'
        settings.Set('lastKnownCombatStyle', 'melee')
    end, { inline = true})

    page:AddText("Hide the combat style gauge while out of combat")
    page:AddRadioButton({
        { text = "Yes", value = "combat-visible" },
        { text = "No", value = "always-visible" },
    }, {
        selectedValue = settings.Get("hideGaugeOutOfCombat"),

        onChange = function(group, value)
            settings.Set("hideGaugeOutOfCombat", value)
        end,
    })

    page:AddText("Show precise time remaining or round to the nearest second?")
    page:AddRadioButton({
        { text = "Precise Ticks", value = "precise-ticks" },
        { text = "Nearest Second", value = "nearest-second" },
    }, {
        selectedValue = settings.Get("showPreciseDurations"),

        onChange = function(group, value)
            settings.Set("showPreciseDurations", value)
        end,
    })

    page:AddText("Tip! Hold Shift+Alt to reposition your gauges.")

end

return M