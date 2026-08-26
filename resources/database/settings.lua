local settings = {}

local defaults = {
    fontColour = 0xFFFFFFFF,
    automaticallySwapGauge = "dynamic",
    hideGaugeOutOfCombat = "combat-visible",
    showPreciseDurations = "precise-ticks",
    lastKnownCombatStyle = '',
    lastKnownActiveSpell = nil,
    selectedGuthixianRune = "lore",
    selectedGuthixianRuneId = 27,

    necroVisibleGaugeComponents = {
        ["show-conjures"] = true,
        ["show-residual-souls"] = true,
        ["show-necrosis-stacks"] = true,
        ["show-bloat"] = true,
        ["show-living-death"] = true,
        ["show-invoke-death"] = true,
        ["show-darkness"] = true,
        ["show-threads-of-fate"] = true,
        ["show-split-soul"] = true,
    },

    necroUISettings = {
        ["hide-residual-souls"] = true,
        ["necromancy_gauge_offset_x"] = 0,
        ["necromancy_gauge_offset_y"] = 0
    },

    magicVisibleGaugeComponents = {
        ["show-sunshine"] = true,
        ["show-tsunami"] = true,
        ["show-runic-charge"] = true,
        ["show-instability"] = true,
        ["show-soulfire"] = true,
        ["show-active-spell"] = true
    },

    magicUISettings = {
        ["magic_gauge_offset_x"] = 0,
        ["magic_gauge_offset_y"] = 0
    },

    rangedVisibleGaugeComponents = {
        ["show-deaths-swiftness"] = true,
        ["show-searing-winds"] = true,
        ["show-shadow-imbued"] = true,
        ["show-perfect-equilibrium"] = true,
        ["show-split-soul"] = true,
        ["show-crystal-rain"] = true,
    },
}


local values = {}
local loaded = false

local function EnsureLoaded()
    if loaded then return end

    for key, default in pairs(defaults) do
        local saved = PersistentDB:Get(key)

        if saved ~= nil then
            values[key] = saved
        else
            values[key] = default
            PersistentDB:Set(key, default)
        end
    end

    loaded = true
end


function settings.Get(name)
    EnsureLoaded()

    if values[name] == nil then
        values[name] = defaults[name]
    end

    return values[name]
end


function settings.Set(name, value)
    EnsureLoaded()

    values[name] = value
    PersistentDB:Set(name, value)
end


function settings.Save()
    for key, value in pairs(values) do
        PersistentDB:Set(key, value)
    end
end



return settings