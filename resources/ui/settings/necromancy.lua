local settings = require("resources/database/settings")

local M = {}

function M.Create(page)

    page:AddTitle("Necromancy Gauge Components")

    local componentSettings = settings.Get("necroVisibleGaugeComponents")

    page:AddCheckboxButton({
        {
            text = "Show Conjures",
            value = "show-conjures",
            selected = componentSettings["show-conjures"]
        },
        {
            text = "Show Residual Souls",
            value = "show-residual-souls",
            selected = componentSettings["show-residual-souls"]
        },
        {
            text = "Show Necrosis Stacks",
            value = "show-necrosis-stacks",
            selected = componentSettings["show-necrosis-stacks"]
        },
        {
            text = "Show Bloat",
            value = "show-bloat",
            selected = componentSettings["show-bloat"]
        },
        {
            text = "Show Living Death",
            value = "show-living-death",
            selected = componentSettings["show-living-death"]
        },
        {
            text = "Show Invoke Death",
            value = "show-invoke-death",
            selected = componentSettings["show-invoke-death"]
        },
        {
            text = "Show Darkness",
            value = "show-darkness",
            selected = componentSettings["show-darkness"]
        },
        {
            text = "Show Threads of Fate",
            value = "show-threads-of-fate",
            selected = componentSettings["show-threads-of-fate"]
        },
        {
            text = "Show Split Soul",
            value = "show-split-soul",
            selected = componentSettings["show-split-soul"]
        },
    }, {
        onChange = function(_, _, changedValue, selected)
            local current =
                settings.Get("necroVisibleGaugeComponents")

            current[changedValue] = selected

            settings.Set(
                "necroVisibleGaugeComponents",
                current
            )
        end,
    })


    page:AddTitle("UI Settings")

    local uiSettings = settings.Get("necroUISettings")

    page:AddCheckboxButton({
        {
            text = "Hide Native Residual Souls",
            value = "hide-residual-souls",
            selected = uiSettings["hide-residual-souls"]
        }
    }, {
        onChange = function(_, _, changedValue, selected)
            local current = settings.Get("necroUISettings")

            current[changedValue] = selected

            settings.Set("necroUISettings", current)
        end,
    })

end

return M