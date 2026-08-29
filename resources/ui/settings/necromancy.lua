local settings = require("resources/database/settings")

local M = {}

function M.Create(page, options)

    page:AddTitle("Necromancy Gauge Components")

    local componentSettings = settings.Get("necromancySettings.componentVisibility")

    page:AddCheckboxButton({
        {
            text = "Show Death Grasp (T70 Weapon Spec)",
            value = "show-death-grasp",
            selected = componentSettings["show-death-grasp"]
        },
        {
            text = "Show Death Essence (Omni Guard Weapon Spec)",
            value = "show-death-essence",
            selected = componentSettings["show-death-essence"]
        },
        {
            text = "Show Soul Crush (Devourer's Guard Weapon Spec)",
            value = "show-soul-crush",
            selected = componentSettings["show-soul-crush"]
        },
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
            settings.Set(
                "necromancySettings.componentVisibility." .. changedValue,
                selected
            )
        end,
    })

    page:AddText("Change 'Ready' text for Incantions (set blank to hide)")
    page:AddTextField({
        text = settings.Get("generalSettings.spriteReadyText") or "R",
        placeholder = "Ready text",
        maxLength = 5,
        onSubmit = function(_, text)
            settings.Set("generalSettings.spriteReadyText", text)
        end
    })

end

return M