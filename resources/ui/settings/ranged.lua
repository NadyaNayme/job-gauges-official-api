local settings = require("resources/database/settings")

local M = {}

function M.Create(page)
    page:AddTitle("Ranged Gauge Components")

    local rangedComponentSettings = settings.Get("rangedVisibleGaugeComponents")

    page:AddCheckboxButton({
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
        {
            text = "Show Split Soul (Eldritch Crossbow Special Attack)",
            value = "show-split-soul",
            selected = rangedComponentSettings["show-split-soul"]
        },
        {
            text = "Show Crystal Rain (Seren Godbow Special Attack)",
            value = "show-crystal-rain",
            selected = rangedComponentSettings["show-crystal-rain"]
        },
    }, {
        onChange = function(_, _, changedValue, selected)
            local current =
                settings.Get("rangedVisibleGaugeComponents")

            current[changedValue] = selected

            settings.Set(
                "rangedVisibleGaugeComponents",
                current
            )
        end,
    })
end

return M