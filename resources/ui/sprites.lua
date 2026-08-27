local M = {}

function M.CreateSprites(parent)
    if not parent then
        log("CreateSprites: parent is nil")
        return nil
    end

    local sprites = {
        necromancy = {
            living_death = {
                active = Plugin.resources.sprites.necromancy.living_death.active,
                inactive = Plugin.resources.sprites.necromancy.living_death.inactive
            },
            conjures = {
                active = Plugin.resources.sprites.necromancy.conjures.active,
                inactive = Plugin.resources.sprites.necromancy.conjures.inactive
            },
            incantations = {
                darkness = {
                    active      = Plugin.resources.sprites.necromancy.incantations.darkness.active,
                    inactive    = Plugin.resources.sprites.necromancy.incantations.darkness.inactive
                },
                invokeDeath = {
                    active      = Plugin.resources.sprites.necromancy.incantations.invokedeath.active,
                    inactive    = Plugin.resources.sprites.necromancy.incantations.invokedeath.inactive
                },
                splitSoul = {
                    active      = Plugin.resources.sprites.necromancy.incantations.splitsoul.active,
                    inactive    = Plugin.resources.sprites.necromancy.incantations.splitsoul.inactive
                },
                threadsOfFate = {
                    active      = Plugin.resources.sprites.necromancy.incantations.threadsoffate.active,
                    inactive    = Plugin.resources.sprites.necromancy.incantations.threadsoffate.inactive
                }
            },
            necrosis = {
                zero    = Plugin.resources.sprites.necromancy.necrosis.zero,
                two     = Plugin.resources.sprites.necromancy.necrosis.two,
                four    = Plugin.resources.sprites.necromancy.necrosis.four,
                six     = Plugin.resources.sprites.necromancy.necrosis.six,
                eight   = Plugin.resources.sprites.necromancy.necrosis.eight,
                ten     = Plugin.resources.sprites.necromancy.necrosis.ten,
                twelve  = Plugin.resources.sprites.necromancy.necrosis.twelve
            },
            souls = {
                zero   = Plugin.resources.sprites.necromancy.souls.zero,
                one    = Plugin.resources.sprites.necromancy.souls.one,
                two    = Plugin.resources.sprites.necromancy.souls.two,
                three  = Plugin.resources.sprites.necromancy.souls.three,
                four   = Plugin.resources.sprites.necromancy.souls.four,
                five   = Plugin.resources.sprites.necromancy.souls.five
            },
            bloat = {
                expired = Plugin.resources.sprites.necromancy.bloat.expired,
                bloat_100 = Plugin.resources.sprites.necromancy.bloat.applied,
                bloat_0     = Plugin.resources.sprites.necromancy.bloat.ten,
                bloat_10     = Plugin.resources.sprites.necromancy.bloat.nine,
                bloat_20   = Plugin.resources.sprites.necromancy.bloat.eight,
                bloat_30    = Plugin.resources.sprites.necromancy.bloat.seven,
                bloat_40    = Plugin.resources.sprites.necromancy.bloat.six,
                bloat_50     = Plugin.resources.sprites.necromancy.bloat.five,
                bloat_60   = Plugin.resources.sprites.necromancy.bloat.four,
                bloat_70   = Plugin.resources.sprites.necromancy.bloat.three,
                bloat_80    = Plugin.resources.sprites.necromancy.bloat.two,
                bloat_90     = Plugin.resources.sprites.necromancy.bloat.one
            }
        },
        magic = {
            sunshine = {
                active = Plugin.resources.sprites.magic.sunshine.active,
                inactive = Plugin.resources.sprites.magic.sunshine.inactive,
                greater_active = Plugin.resources.sprites.magic.sunshine.gactive,
                greater_inactive = Plugin.resources.sprites.magic.sunshine.ginactive
            },
            tsunami = {
                active = Plugin.resources.sprites.magic.tsunami.active,
                inactive = Plugin.resources.sprites.magic.tsunami.inactive,
            },
            runicCharge = {
                active = Plugin.resources.sprites.magic.runic_charge.active,
                inactive = Plugin.resources.sprites.magic.runic_charge.inactive,
            },
            instability = {
                active = Plugin.resources.sprites.magic.instability.active,
                inactive = Plugin.resources.sprites.magic.instability.inactive
            },
            soulfire = {
                active = Plugin.resources.sprites.magic.soulfire.active,
                inactive = Plugin.resources.sprites.magic.soulfire.inactive
            }
        },
        ranged = {
            deaths_swiftness = {
                active = Plugin.resources.sprites.ranged.deaths_swiftness.active,
                inactive = Plugin.resources.sprites.ranged.deaths_swiftness.inactive,
                greater_active = Plugin.resources.sprites.ranged.deaths_swiftness.gactive,
                greater_inactive = Plugin.resources.sprites.ranged.deaths_swiftness.ginactive
            },
            searing_winds = {
                active = Plugin.resources.sprites.ranged.searing_winds.active,
                inactive = Plugin.resources.sprites.ranged.searing_winds.inactive,
            },
            shadow_imbued = {
                active = Plugin.resources.sprites.ranged.shadow_imbued.active,
                inactive = Plugin.resources.sprites.ranged.shadow_imbued.inactive,
            },
            perfect_equilibrium = {
                active = Plugin.resources.sprites.ranged.perfect_equilibrium.active,
                inactive = Plugin.resources.sprites.ranged.perfect_equilibrium.inactive,
            },
            split_soul = {
                active = Plugin.resources.sprites.ranged.split_soul.active,
                inactive = Plugin.resources.sprites.ranged.split_soul.inactive,
            },
            crystal_rain = {
                active = Plugin.resources.sprites.ranged.crystal_rain.active,
                inactive = Plugin.resources.sprites.ranged.crystal_rain.inactive,
            }
        },
        melee = {
            berserk = {
                active = Plugin.resources.sprites.melee.berserk.active,
                inactive = Plugin.resources.sprites.melee.berserk.active,
            },
            chaos_roar = {
                active = Plugin.resources.sprites.melee.chaos_roar.active,
                inactive = Plugin.resources.sprites.melee.chaos_roar.active,
            },
            igneous_strike = {
                active = Plugin.resources.sprites.melee.igneous_strike.active,
                inactive = Plugin.resources.sprites.melee.igneous_strike.active,
            },
            blackhole = {
                active = Plugin.resources.sprites.melee.blackhole.active,
                inactive = Plugin.resources.sprites.melee.blackhole.active,
            }
        },
        utility = {
            shadow = Plugin.resources.sprites.utility.shadow,
            bar = Plugin.resources.sprites.utility.bar
        }
    }

    return sprites
end

return M

