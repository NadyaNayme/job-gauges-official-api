local settings = require("resources/database/settings")
local L = require("resources/data/localize")

local M = {}

function M.Create(page, options)

    page:AddTitle(L.Get("necromancy.gaugeComponentsTitle"))

    local componentSettings = settings.Get("necromancySettings.componentVisibility")

    page:AddCheckboxButton({
        {
            text = L.Get("necromancy.visibilityOptions.deathGrasp"),
            value = "show-death-grasp",
            selected = componentSettings["show-death-grasp"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.deathEssence"),
            value = "show-death-essence",
            selected = componentSettings["show-death-essence"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.soulCrush"),
            value = "show-soul-crush",
            selected = componentSettings["show-soul-crush"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.conjures"),
            value = "show-conjures",
            selected = componentSettings["show-conjures"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.residualSouls"),
            value = "show-residual-souls",
            selected = componentSettings["show-residual-souls"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.necrosisStacks"),
            value = "show-necrosis-stacks",
            selected = componentSettings["show-necrosis-stacks"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.bloat"),
            value = "show-bloat",
            selected = componentSettings["show-bloat"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.livingDeath"),
            value = "show-living-death",
            selected = componentSettings["show-living-death"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.invokeDeath"),
            value = "show-invoke-death",
            selected = componentSettings["show-invoke-death"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.threadsOfFate"),
            value = "show-threads-of-fate",
            selected = componentSettings["show-threads-of-fate"]
        },
        {
            text = L.Get("necromancy.visibilityOptions.splitSoul"),
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

    page:AddText(L.Get("necromancy.incantationsReadyTextLabel"))
    page:AddTextField({
        text = settings.Get("generalSettings.spriteReadyText") or "R",
        placeholder = "Ready text",
        maxLength = 5,
        onChange = function(_, _, text)
            settings.Set("generalSettings.spriteReadyText", text)
        end
    })

end

return M