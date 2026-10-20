local settings = {}


-- Default initialization of settings
local defaults = {

    playerState = {
        combatStyle = nil,
        activeSpell = nil,
    },

    fontColours = {
        durationText = "0xFFFFFFFF",
        expiringText = "0xF30B0BFF",
        cooldownText = "0xFFFFFFFF",
        readyText = "0xFFFFFFFF",
    },
    uiColours = {
        backdropColour = "0xFFFFFF00",
        shadowColour = "0x111111DD",
        runeColours = {
            active = "0x70FF00FF",
            activeShadow = "0x100101FF",
            inactive = "0x050012FF",
            inactiveShadow = "0xC1BDAC89",
        },
        barColours = {
            bloodTitheBar = "0xF30B0BFF",
            inciteFearBar = "0x16D6E5FF",
            essenceCorruptionBar = "0x16A127FF",
            bloatBar = "0x16A1271A",
        }
    },

    generalSettings = {
        positionLocked = false,
        componentEditing = false,
        automaticSwapping = "mainhand",
        hideOutOfCombat = "always-visible",
        displayTimeAs = "nearest-second",
        readyText = "Ready",
        spriteReadyText = "R",
        scale = 1,
        offsetPosition = {
            x = 0,
            y = 0,
        }
    },

    necromancySettings = {
        componentVisibility = {
            ["show-death-grasp"] = true,
            ["show-death-essence"] = true,
            ["show-soul-crush"] = true,
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
            deathGrasp = {
                x = 0,
                y = 6,
            },
            deathEssence = {
                x = 40,
                y = 6,
            },
            soulCrush = {
                x = 80,
                y = 6,
            },
            conjureUndeadArmy = {
                x = 0,
                y = 40,
            },
            livingDeath = {
                x = 40,
                y = 40,
            },
            residualSoulsStacks = {
                x = 2,
                y = 84,
            },
            necrosisStacks = {
                x = 2,
                y = 107,
            },
            bloat = {
                x = 2,
                y = 127,
            },
            invokeDeath = {
                x = 96,
                y = 40,
            },
            threadsOfFate = {
                x = 84,
                y = 62,
            },
            splitSoul = {
                x = 108,
                y = 62,
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
            ["show-incite-fear"] = true,
            ["show-essence-corruption"] = true,
        },
        offsetPosition = {
            x = 0,
            y = 0,
        },
        componentPositions = {
            soulfire = {
                x = 0,
                y = 6,
            },
            instability = {
                x = 40,
                y = 6,
            },
            activeSpell = {
                x = 88,
                y = 16,
            },
            runicCharge = {
                x = 0,
                y = 40,
            },
            tsunami = {
                x = 40,
                y = 40,
            },
            sunshine = {
                x = 80,
                y = 40,
            },
            bloodTithe = {
                x = -55,
                y = 85,
            },
            inciteFear = {
                x = -55,
                y = 95,
            },
            essenceCorruption = {
                x = -55,
                y = 105,
            }
        }
    },

    rangedSettings = {
        componentVisibility = {
            ["show-crystal-rain"] = true,
            ["show-split-soul"] = true,
            ["show-equipped-ammo"] = true,
            ["show-searing-winds"] = true,
            ["show-shadow-imbued"] = true,
            ["show-deaths-swiftness"] = true,
            ["show-perfect-equilibrium"] = true,
            ["show-perfect-equilibrium-stacks"] = true,
            ["show-guthixian-runes"] = true,
        },
        offsetPosition = {
            x = 0,
            y = 0,
        },
        componentPositions = {
            crystalRain = {
                x = 0,
                y = 6,
            },
            splitSoul = {
                x = 40,
                y = 6,
            },
            equippedAmmo = {
                x = 80,
                y = 6,
            },
            searingWinds = {
                x = 0,
                y = 40,
            },
            shadowImbued = {
                x = 40,
                y = 40,
            },
            deathsSwiftness = {
                x = 80,
                y = 40,
            },
            perfectEquilibrium = {
                x = -20,
                y = 80,
            },
            guthixianRunes = {
                x = 20,
                y = 90,
            },
            RUNE_LAYOUT = {
                -- LORE
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
                -- Easter egg. :-) 
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
                y = 6,
            },
            igneousShowdown = {
                x = 40,
                y = 6,
            },
            bloodlust = {
                x = 88,
                y = 16,
            },
            chaosRoar = {
                x = 0,
                y = 40,
            },
            meteorStrike = {
                x = 40,
                y = 40,
            },
            berserk = {
                x = 80,
                y = 40,
            },
        }
    }
}

-- Things do what they say from here on out

local values = {}
local loaded = false

local function mergeDefaults(saved, default)
    if type(default) ~= "table" then
        if saved ~= nil then
            return saved
        end

        return default
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

-- Allow functions to subscribe to settings updates, allowing the UI to update whenever
-- a user changes their settings. Without doing what I was doing before, which was
-- calling settings.Get() every Logic event. Which was probably very bad. ^^;
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
    --EnsureLoaded()

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
    notify(name, value)
end

function settings.Save()
    --EnsureLoaded()

    for key, value in pairs(values) do
        PersistentDB:Set(key, value)
    end
end

function settings.Reset()
    EnsureLoaded()

    values = mergeDefaults({}, defaults)

    for key, value in pairs(values) do
        PersistentDB:Set(key, value)
    end

    for path, callbacks in pairs(listeners) do
        local value = getNestedValue(values, path)

        for _, callback in ipairs(callbacks) do
            callback(value)
        end
    end
end

return settings