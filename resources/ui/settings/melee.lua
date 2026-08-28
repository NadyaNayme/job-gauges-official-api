local settings = require("resources/database/settings")

local M = {}

function M.Create(page)
    page:AddTitle("Melee Gauge Components")

    local meleeComponentSettings = settings.Get("meleeSettings.componentVisibility")

    page:AddCheckboxButton({
        {
            text = "Show Blackhole (Zaros godsword Special Attack)",
            value = "show-blackhole",
            selected = meleeComponentSettings["show-blackhole"]
        },
        {
            text = "Show Igneous Showdown (Ek-ZekKil Special Attack)",
            value = "show-igneous-showdown",
            selected = meleeComponentSettings["show-igneous-showdown"]
        },
        {
            text = "Show Bloodlust Stacks",
            value = "show-bloodlust",
            selected = meleeComponentSettings["show-bloodlust"]
        },
        {
            text = "Show Chaos Roar",
            value = "show-chaos-roar",
            selected = meleeComponentSettings["show-chaos-roar"]
        },
        {
            text = "Show Meteor Strike",
            value = "show-meteor-strike",
            selected = meleeComponentSettings["show-meteor-strike"]
        },
        {
            text = "Show Berserk",
            value = "show-berserk",
            selected = meleeComponentSettings["show-berserk"]
        },
    }, {
        onChange = function(_, _, changedValue, selected)
            settings.Set(
                "meleeSettings.componentVisibility." .. changedValue,
                selected
            )
        end,
    })
end

return M