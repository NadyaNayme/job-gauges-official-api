local settings = require("resources/database/settings")
local L = require("resources/data/localize")

local M = {}

function M.Create(page, options)
    page:AddTitle(L.Get("melee.gaugeComponentsTitle"))

    local meleeComponentSettings = settings.Get("meleeSettings.componentVisibility")

    page:AddCheckboxButton({
        {
            text = L.Get("melee.blackhole"),
            value = "show-blackhole",
            selected = meleeComponentSettings["show-blackhole"]
        },
        {
            text = L.Get("melee.igneousShowdown"),
            value = "show-igneous-showdown",
            selected = meleeComponentSettings["show-igneous-showdown"]
        },
        {
            text = L.Get("melee.bloodlust"),
            value = "show-bloodlust",
            selected = meleeComponentSettings["show-bloodlust"]
        },
        {
            text = L.Get("melee.chaosRoar"),
            value = "show-chaos-roar",
            selected = meleeComponentSettings["show-chaos-roar"]
        },
        {
            text = L.Get("melee.meteorStrike"),
            value = "show-meteor-strike",
            selected = meleeComponentSettings["show-meteor-strike"]
        },
        {
            text = L.Get("melee.berserk"),
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