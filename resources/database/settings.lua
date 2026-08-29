local settings = {}

local defaults = {

    playerState = {
        combatStyle = nil,
        activeSpell = nil,
    },

    fontColours = {
        durationText = "0xFFFFFFFF",
        expiringText = "0xFFFFFFFF",
        cooldownText = "0xFFFFFFFF",
        readyText = "0xFFFFFFFF",
    },
    uiColours = {
        shadowColour = "0xFFFFFFFF",
        runeColours = {
            active = "0x70FF00FF",
            activeShadow = "0x100101FF",
            inactive = "0x050012FF",
            inactiveShadow = "0xC1BDAC89",
        },
        barColours = {
            bloodTitheBar = "0xFFFA2B4F",
            inciteFearBar = "0xFFB8E8F3",
            essenceCorruptionBar = "0xFF70DC3F¢",
            bloatBar = nil,
        }
    },

    generalSettings = {
        automaticSwapping = "mainhand",
        hideOutOfCombat = "combat-visible",
        displayTimeAs = "precise-ticks",
        readyText = "Ready",
        scale = 1,
        offsetPosition = {
            x = 0,
            y = 0,
        }
    },

    necromancySettings = {
        componentVisibility = {
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
        offsetPosition = {
            x = 0,
            y = 0,
        },
        componentPositions = {
            conjureUndeadArmy = {
                x = 0,
                y = 0,
            },
            livingDeath = {
                x = 40,
                y = 0,
            },
            residualSoulsStacks = {
                x = 2,
                y = 44,
            },
            necrosisStacks = {
                x = 2,
                y = 67,
            },
            bloat = {
                x = 2,
                y = 87,
            },
            invokeDeath = {
                x = 96,
                y = 0,
            },
            threadsOfFate = {
                x = 84,
                y = 22,
            },
            splitSoul = {
                x = 108,
                y = 22,
            }
        }
        -- ["hide-native-residual-souls"] = true, -- Haven't found how to do this yet, so hide the setting.
    },

    magicSettings = {
        componentVisibility = {
            ["show-soulfire"] = true,
            ["show-instability"] = true,
            ["show-active-spell"] = true,
            ["show-runic-charge"] = true,
            ["show-tsunami"] = true,
            ["show-sunshine"] = true,
            ["show-blood-tithe"] = true,
            ["show-blood-tithe-text"] = true,
            ["show-incite-fear"] = true,
            ["show-incite-fear-text"] = true,
            ["show-essence-corruption"] = true,
            ["show-essence-corruption-text"] = true,
        },
        offsetPosition = {
            x = 0,
            y = 0,
        },
        componentPositions = {
            soulfire = {
                x = 0,
                y = -34,
            },
            instability = {
                x = 40,
                y = -34,
            },
            activeSpell = {
                x = 88,
                y = -24,
            },
            runicCharge = {
                x = 0,
                y = 0,
            },
            tsunami = {
                x = 40,
                y = 0,
            },
            sunshine = {
                x = 80,
                y = 0,
            },
            bloodTithe = {
                x = -55,
                y = 45,
            },
            inciteFear = {
                x = -55,
                y = 55,
            },
            essenceCorruption = {
                x = -55,
                y = 65,
            }
        }
    },

    rangedSettings = {
        componentVisibility = {
            ["show-deaths-swiftness"] = true,
            ["show-searing-winds"] = true,
            ["show-shadow-imbued"] = true,
            ["show-perfect-equilibrium"] = true,
            ["show-split-soul"] = true,
            ["show-crystal-rain"] = true,
        },
        offsetPosition = {
            x = 0,
            y = 0,
        },
        componentPositions = {
            crystalRain = {
                x = 0,
                y = -34,
            },
            splitSoul = {
                x = 40,
                y = -34,
            },
            searingWinds = {
                x = 0,
                y = 0,
            },
            shadowImbued = {
                x = 40,
                y = 0,
            },
            deathsSwiftness = {
                x = 80,
                y = 0,
            },
            perfectEquilibrium = {
                x = -20,
                y = 40,
            },
            guthixianRunes = {
                x = 20,
                y = 50,
            },
            RUNE_LAYOUT = {
                BALANCE = {
                    [1] = { x_offset = 0,   size = { width = 24, height = 24 } },
                    [2] = { x_offset = 12,  size = { width = 24, height = 24 } },
                    [3] = { x_offset = 28,  size = { width = 24, height = 24 } },
                    [4] = { x_offset = 36,  size = { width = 24, height = 24 } },
                    [5] = { x_offset = 50,  size = { width = 24, height = 24 } },
                    [6] = { x_offset = 66,  size = { width = 24, height = 24 } },
                    [7] = { x_offset = 82,  size = { width = 24, height = 24 } },
                    stacksText = { x = 120, y = 50},
                },

                NYU = {
                    [1] = { x_offset = 0,   size = { width = 24, height = 24 } },
                    [2] = { x_offset = 12,  size = { width = 24, height = 24 } },
                    [3] = { x_offset = 28,  size = { width = 24, height = 24 } },
                    stacksText = { x = 67, y = 50},
                },

                SEVEN = {
                    [1] = { x_offset = 0,   size = { width = 24, height = 24 } },
                    [2] = { x_offset = 12,  size = { width = 24, height = 24 } },
                    [3] = { x_offset = 24,  size = { width = 24, height = 24 } },
                    [4] = { x_offset = 36,  size = { width = 24, height = 24 } },
                    [5] = { x_offset = 48,  size = { width = 24, height = 24 } },
                    [6] = { x_offset = 60,  size = { width = 24, height = 24 } },
                    [7] = { x_offset = 72,  size = { width = 24, height = 24 } },
                    stacksText = { x = 120, y = 50},
                },

                THREE = {
                    [1] = { x_offset = 0,   size = { width = 24, height = 24 } },
                    [2] = { x_offset = 12,  size = { width = 24, height = 24 } },
                    [3] = { x_offset = 24,  size = { width = 24, height = 24 } },
                    stacksText = { x = 67, y = 50},
                },
            }
        },
        selectedGuthixianRune = "lore",
        selectedGuthixianRuneId = 27,
    },

    meleeSettings = {
        componentVisibility = {
            ["show-blackhole"] = true,
            ["show-igneous-showdown"] = true,
            ["show-bloodlust"] = true,
            ["show-chaos-roar"] = true,
            ["show-meteor-strike"] = true,
            ["show-berserk"] = true
        },
        offsetPosition = {
            x = 0,
            y = 0,
        },
        componentPositions = {
            blackhole = {
                x = 0,
                y = -34,
            },
            igneousShowdown = {
                x = 40,
                y = -34,
            },
            bloodlust = {
                x = 88,
                y = -24,
            },
            chaosRoar = {
                x = 0,
                y = 0,
            },
            meteorStrike = {
                x = 40,
                y = 0,
            },
            berserk = {
                x = 80,
                y = 0,
            },
        }
    }
}


local values = {}
local loaded = false

local function mergeDefaults(saved, default)
    if type(default) ~= "table" then
        return saved ~= nil and saved or default
    end

    if type(saved) ~= "table" then
        saved = {}
    end

    for key, defaultValue in pairs(default) do
        saved[key] = mergeDefaults(saved[key], defaultValue)
    end

    return saved
end

local function EnsureLoaded()
    if loaded then return end

    for key, default in pairs(defaults) do
        local saved = PersistentDB:Get(key)
        values[key] = mergeDefaults(saved, default)
        PersistentDB:Set(key, values[key])
    end

    loaded = true
end

local function getPathKeys(path) 
    local keys = {}

    for key in string.gmatch(path, "[^%.]+") do
        table.insert(keys, key)
    end

    return keys
end

local function getNestedValue(root, path)
    local current = root

    for key in string.gmatch(path, "[^%.]+") do
        if type(current) ~= "table" then
            return nil
        end

        current = current[key]
    end

    return current
end

function settings.Get(name)
    EnsureLoaded()
    return getNestedValue(values, name)
end

local listeners = {}
function settings.Subscribe(path, callback)
    if not listeners[path] then
        listeners[path] = {}
    end

    table.insert(listeners[path], callback)
end

local function notify(path, value)
    local callbacks = listeners[path]

    if not callbacks then
        return
    end

    for _, callback in ipairs(callbacks) do
        callback(value)
    end
end

function settings.Set(name, value)
    EnsureLoaded()

    local keys = getPathKeys(name)
    local current = values

    for i = 1, #keys - 1 do
        local key = keys[i]

        if type(current[key]) ~= "table" then
            current[key] = {}
        end

        current = current[key]
    end

    current[keys[#keys]] = value
    PersistentDB:Set(keys[1], values[keys[1]])
    notify(path, value)
end

function settings.Save()
    EnsureLoaded()

    for key, value in pairs(values) do
        PersistentDB:Set(key, value)
    end
end



return settings