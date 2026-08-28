local settings = require("resources/database/settings")

local M = {}

function M.Create(page)
    page:AddTitle("Magic Gauge Components")

    local magicComponentSettings = settings.Get("magicVisibleGaugeComponents")

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
    }, {
        onChange = function(_, _, changedValue, selected)
            local current =
                settings.Get("magicVisibleGaugeComponents")

            current[changedValue] = selected

            settings.Set(
                "magicVisibleGaugeComponents",
                current
            )
        end,
    })
end

return M