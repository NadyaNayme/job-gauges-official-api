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

    page:AddText("Dynamically swap active style gauge based on active buffs (ie. after a style specific Ability is used)")

    options.dynamicGaugeSetting = page:AddRadioButton({
        { text = "Yes", value = "dynamic" },
        { text = "No", value = "static" },
    }, {
        selectedValue = settings.Get("automaticallySwapGauge"),

        onChange = function(_, value)
            settings.Set("automaticallySwapGauge", value)
        end,
    })

    page:AddText("You will need to select your active gauge if you do not have Dynamic Swapping enabled.")

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

    page:AddText("Gauge Position - Offset X")
    page:AddSlider({
        min = 0,
        max = 1920,
        value = settings.Get("necroUISettings")["necromancy_gauge_offset_x"],
        step = 1,

        onChange = function(_, value)
            local current = settings.Get("necroUISettings")

            current["necromancy_gauge_offset_x"] = value

            settings.Set("necroUISettings", current)

            options.setOffsetX(value)
            options.updateOverlayPositions()
        end,
    })

    page:AddText("Gauge Position - Offset Y")
    page:AddSlider({
        min = 0,
        max = 1080,
        value = settings.Get("necroUISettings")["necromancy_gauge_offset_y"],
        step = 1,

        onChange = function(_, value)
            local current = settings.Get("necroUISettings")

            current["necromancy_gauge_offset_y"] = value

            settings.Set("necroUISettings", current)

            options.setOffsetY(value)
            options.updateOverlayPositions()
        end,
    })

end

return M