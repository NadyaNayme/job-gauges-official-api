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
                applied = Plugin.resources.sprites.necromancy.bloat.applied,
                one     = Plugin.resources.sprites.necromancy.bloat.one,
                two     = Plugin.resources.sprites.necromancy.bloat.two,
                three   = Plugin.resources.sprites.necromancy.bloat.three,
                four    = Plugin.resources.sprites.necromancy.bloat.four ,
                five    = Plugin.resources.sprites.necromancy.bloat.five ,
                six     = Plugin.resources.sprites.necromancy.bloat.six ,
                seven   = Plugin.resources.sprites.necromancy.bloat.seven,
                eight   = Plugin.resources.sprites.necromancy.bloat.eight ,
                nine    = Plugin.resources.sprites.necromancy.bloat.nine,
                ten     = Plugin.resources.sprites.necromancy.bloat.ten
            }
        }
    }

    return sprites
end

return M

